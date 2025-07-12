CREATE OR REPLACE VIEW user_reservations_view AS
SELECT 
	r.reservation_id,
	r.start_time,
	r.end_time,
	COALESCE(d.label, m.name) AS resource,
	r.status,
	u.full_name
FROM reservations r
JOIN users u ON r.user_id = u.user_id
LEFT JOIN desks d ON r.desk_id = d.desk_id
LEFT JOIN meeting_rooms m ON r.room_id = m.room_id;

SELECT * FROM user_reservations_view;

CREATE OR REPLACE VIEW admin_payments_view AS 
SELECT 
	u.full_name,
	p.amount,
	p.payment_date,
	i.invoice_number,
	r.start_time,
	r.end_time
FROM payments p
JOIN reservations r ON r.reservation_id = p.reservation_id
JOIN users u ON u.user_id = r.user_id
LEFT JOIN invoices i ON i.payment_id = p.payment_id;

SELECT * FROM admin_payments_view;

CREATE ROLE client LOGIN PASSWORD 'client123';
CREATE ROLE admin LOGIN PASSWORD 'admin123';

GRANT CONNECT ON DATABASE coworking_db TO client;
GRANT USAGE ON SCHEMA public TO client;
GRANT SELECT ON user_reservations_view TO client;

GRANT CONNECT ON DATABASE coworking_db TO admin;
GRANT USAGE ON SCHEMA public TO admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO admin;