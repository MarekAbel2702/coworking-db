CREATE OR REPLACE FUNCTION generate_invoice(p_payment_id INTEGER)
RETURNS TEXT AS $$
DECLARE	
	existing_invoice TEXT;
	new_invoice_number TEXT;
BEGIN
	SELECT invoice_number INTO existing_invoice
	FROM invoices
	WHERE payment_id = p_payment_id;

	IF existing_invoice IS NOT NULL THEN
		RETURN FORMAT('Invoice already exists: %s', existing_invoice);
	END IF;

	SELECT 'FV-' || TO_CHAR(CURRENT_DATE, 'YYYY') || '-' || LPAD((COUNT(*) + 1)::TEXT, 3, '0')
	INTO new_invoice_number
	FROM invoices
	WHERE EXTRACT(YEAR FROM issue_date) = EXTRACT(YEAR FROM CURRENT_DATE);

	INSERT INTO invoices (payment_id, invoice_number)
	VALUES (p_payment_id, new_invoice_number);

	RETURN FORMAT('Invoice %s created for payment %s', new_invoice_number, p_payment_id);
END;
$$ LANGUAGE plpgsql;

SELECT generate_invoice(1);