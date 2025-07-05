INSERT INTO users (full_name, phone, role)
VALUES
	('Jan Kowalski', 'jan.kowalski@example.com', '123456789', 'client'),
	('Anna Nowak', 'anna.nowak@example.com', '987654321', 'client'),
	('Admin User', 'admin@example.com', '111222333', 'admin');

INSERT INTO desks (label, location)
VALUES
	('D-101', '1 piętro'),
	('D-102', '1 piętro'),
	('D-201', '2 piętro');

INSERT INTO meeting_rooms (name, capacity, location)
VALUES
	('Sala A', 6, '1 piętro'),
	('Sala B', 12, '2 piętro');

INSERT INTO reservations (user_id, desk_id, start_time, end_time)
VALUES 
	(1, 1, '2025-07-06 09:00', '2025-07-06 17:00'),
	(2, 2, '2025-07-06 10:00', '2025-07-06 15:00');

INSERT INTO reservations (user_id, room_id, start_time, end_time)
VALUES 
	(1, 1, '2025-07-07 10:00', '2025-07-07 12:00');

INSERT INTO payments (reservation_id, amount, method)
VALUES
	(1, 120.00, 'card'),
	(2, 100.00, 'transfer'),
	(3, 200.00, 'card');

INSERT INTO invoices (payment_id, invoice_number)
VALUES
	(1, 'FV-2025-001'),
	(2, 'FV-2025-002'),
	(3, 'FV-2025-003');

INSERT INTO acces_logs (user_id, entry_time, exit_time)
VALUES
	(1, '2025-07-06 08:50', '2025-07-06 17:10'),
	(2, '2025-07-06 09:45', '2025-07-06 15:10'),
	(1, '2025-07-07 09:45', '2025-07-07 12:15');