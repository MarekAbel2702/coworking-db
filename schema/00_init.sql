CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	full_name TEXT NOT NULL,
	email TEXT UNIQUE NOT NULL,
	phone TEXT,
	role TEXT CHECK (role IN ('client', 'admin')) DEFAULT 'client',
	created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE desks (
	desk_id SERIAL PRIMARY KEY,
	label TEXT UNIQUE NOT NULL,
	location TEXT NOT NULL,
	available BOOLEAN DEFAULT TRUE
);

CREATE TABLE meeting_rooms (
	room_id SERIAL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	capacity INTEGER NOT NULL CHECK (capacity > 0),
	location TEXT NOT NULL
);

CREATE TABLE reservations (
	reservation_id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(user_id),
	desk_id INTEGER REFERENCES desks(desk_id),
	room_id INTEGER REFERENCES meeting_rooms(room_id),
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP NOT NULL,
	status TEXT CHECK (status IN('active', 'cancelled', 'finished')) DEFAULT 'active',
	CHECK (
		(desk_id IS NOT NULL AND room_id IS NULL)
		OR (desk_id IS NULL AND room_id IS NOT NULL)
	),
	CHECK (start_time < end_time)
);

CREATE TABLE payments (
	payment_id SERIAL PRIMARY KEY,
	reservation_id INTEGER REFERENCES reservations(reservation_id),
	amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
	payment_date TIMESTAMP DEFAULT NOW(),
	method TEXT CHECK (method IN ('card', 'transfer', 'cash')) NOT NULL
);

CREATE TABLE invoices (
	invoice_id SERIAL PRIMARY KEY,
	payment_id INTEGER REFERENCES payments(payment_id),
	issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
	invoice_number TEXT UNIQUE NOT NULL
);

CREATE TABLE access_logs (
	log_id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(user_id),
	entry_time TIMESTAMP NOT NULL,
	exit_time TIMESTAMP
);