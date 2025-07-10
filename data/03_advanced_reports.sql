SELECT 
	TO_CHAR(payment_date, 'YYYY-MM') AS month,
	SUM(amount) AS total_income
FROM payments
GROUP BY month
ORDER BY month;

WITH daily_usage AS (
	SELECT 
		desk_id,
		SUM(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600) As used_hours
	FROM reservations
	WHERE desk_id IS NOT NULL
		AND start_time::date = '2025-07-06'
	GROUP BY desk_id
),
desk_usage AS (
SELECT 
	d.label,
	ROUND(COALESCE(du.used_hours, 0), 2) AS used_hours,
	ROUND(COALESCE(du.used_hours, 0) / 8 * 100, 1) AS usage_percent_num
FROM desks d
LEFT JOIN daily_usage du ON d.desk_id = du.desk_id
)
SELECT
	label,
	used_hours,
	usage_percent_num::text || '%' AS usage_percent
FROM desk_usage
ORDER BY usage_percent_num DESC;

SELECT 
	EXTRACT(HOUR FROM start_time) AS hour,
	COUNT(*) AS reservation_count
FROM reservations
GROUP BY hour
ORDER BY reservation_count DESC;

SELECT
	DATE(start_time) AS date,
	COUNT(*) AS room_reservations
FROM reservations
WHERE room_id IS NOT NULL
GROUP BY date
HAVING COUNT(*) > 1
ORDER BY date;

SELECT 
	u.full_name,
	TO_CHAR(r.start_time, 'YYYY-MM') AS month,
	COUNT(*) AS reservation_count
FROM reservations r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.full_name, month
ORDER BY month, reservation_count DESC;

SELECT 
	i.invoice_number,
	u.full_name,
	p.amount,
	p.method,
	p.payment_date
FROM invoices i
JOIN payments p ON p.payment_id = i.payment_id
JOIN reservations r ON r.reservation_id = p.reservation_id
JOIN users u ON u.user_id = r.user_id
ORDER BY p.amount DESC
LIMIT 3;