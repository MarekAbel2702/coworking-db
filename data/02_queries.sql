SELECT 
	r.reservation_id,
	u.full_name AS user,
	d.label AS desk,
	m.name AS room,
	r.start_time,
	r.end_time,
	r.status
FROM reservations r
LEFT JOIN users u ON r.user_id = u.user_id
LEFT JOIN desks d ON r.desk_id = d.desk_id
LEFT JOIN meeting_rooms m ON r.room_id = m.room_id
ORDER BY r.start_time;

SELECT 
	SUM(amount) AS total_revenue
FROM payments;

SELECT 
	DATE(payment_date) AS date,
	SUM(amount) AS total
FROM payments
GROUP BY date
ORDER BY date;

SELECT 
	d.label,
	COUNT(*) AS reservation_count
FROM reservations r
JOIN desks d ON r.desk_id = d.desk_id
GROUP BY d.label
ORDER BY reservation_count DESC
LIMIT 3;

SELECT 
	u.full_name,
	COUNT(*) AS reservation_count
FROM reservations r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.full_name
ORDER BY reservation_count DESC;

SELECT 
	ROUND(AVG(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600), 2) AS avg_hours
FROM reservations;

SELECT 
	i.invoice_number,
	i.issue_date,
	p.amount,
	u.full_name
FROM invoices i
JOIN payments p ON i.payment_id = p.payment_id
JOIN reservations r ON p.reservation_id = r.reservation_id
JOIN users u ON r.user_id = u.user_id
ORDER BY i.issue_date;