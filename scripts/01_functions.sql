CREATE OR REPLACE FUNCTION is_desk_available(p_desk_id INTEGER, p_start TIMESTAMP, p_end TIMESTAMP)
RETURNS BOOLEAN AS $$
BEGIN 
	RETURN NOT EXISTS (
		SELECT 1 FROM reservations
		WHERE desk_id = p_desk_id
		AND status = 'active'
		AND  (
			(p_start, p_end) OVERLAPS (start_time, end_time)
		)
	);
END
$$ LANGUAGE plpgsql;

SELECT is_desk_available(1, '2025-07-08 10:00', '2025-07-08 14:00');

CREATE OR REPLACE FUNCTION is_room_available(p_room_id INTEGER, p_start TIMESTAMP, p_end TIMESTAMP)
RETURNS BOOLEAN AS $$
BEGIN
	RETURN NOT EXISTS (
		SELECT 1 FROM reservations
		WHERE room_id = p_room_id
		AND status = 'active'
		AND (
			(p_start, p_end) OVERLAPS (start_time, end_time)
		)
	);
END;
$$ LANGUAGE plpgsql;

SELECT is_room_available(1, '2025-07-08 10:00', '2025-07-08 14:00');

CREATE OR REPLACE FUNCTION make_reservation(
	p_user_id INTEGER,
	p_start TIMESTAMP,
	p_end TIMESTAMP,
	p_desk_id INTEGER DEFAULT NULL,
	p_room_id INTEGER DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE 
	available BOOLEAN;
	new_reservation_id INTEGER;
BEGIN
	IF p_desk_id IS NOT NULL THEN
		available := is_desk_available(p_desk_id, p_start, p_end);
		IF NOT available THEN
			RETURN 'Desk is not available in that time range.';
		END IF;

		INSERT INTO reservations (user_id, desk_id, start_time, end_time)
		VALUES (p_user_id, p_desk_id, p_start, p_end)
		RETURNING reservation_id INTO new_reservation_id;

	ELSIF p_room_id IS NOT NULL THEN
		available := is_room_available(p_room_id, P_start, p_end);
		IF NOT available THEN 
			RETURN 'Room is not available in that time range.';
		END IF;
		
		INSERT INTO reservations (user_id, room_id, start_time, end_time)
		VALUES (p_user_id, p_room_id, p_start, p_end)
		RETURNING reservation_id INTO new_reservation_id;

	ELSE
		RETURN 'Must provide either desk_id or room_id.';
	END IF;

	RETURN FORMAT('Reservation created with ID %s', new_reservation_id);
END;
$$ LANGUAGE plpgsql;

SELECT make_reservation(1, '2025-07-08 10:00', '2025-07-08 14:00',1, NULL);