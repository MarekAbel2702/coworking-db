CREATE OR REPLACE FUNCTION create_invoice_after_payment()
RETURNS TRIGGER AS $$
BEGIN 
	PERFORM generate_invoice(NEW.payment_id);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_auto
AFTER INSERT ON payments
FOR EACH ROW
EXECUTE FUNCTION create_invoice_after_payment();
	