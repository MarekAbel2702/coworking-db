1. users
Kolumna	Typ	Opis
user_id	SERIAL PRIMARY KEY	Unikalny identyfikator użytkownika
full_name	TEXT NOT NULL	Imię i nazwisko
email	TEXT UNIQUE NOT NULL	Adres e-mail
phone	TEXT	Numer telefonu
role	TEXT DEFAULT 'client'	client lub admin
created_at	TIMESTAMP DEFAULT NOW()	Data rejestracji

2. desks
Kolumna	Typ	Opis
desk_id	SERIAL PRIMARY KEY	Unikalny ID biurka
label	TEXT UNIQUE	Nazwa biurka (np. D-01)
location	TEXT	Lokalizacja (np. 1 piętro)
available	BOOLEAN DEFAULT TRUE	Czy biurko dostępne?

3. meeting_rooms
Kolumna	Typ	Opis
room_id	SERIAL PRIMARY KEY	ID sali konferencyjnej
name	TEXT UNIQUE	Nazwa sali
capacity	INTEGER	Ilość miejsc
location	TEXT	Gdzie się znajduje

4. reservations
Kolumna	Typ	Opis
reservation_id	SERIAL PRIMARY KEY	ID rezerwacji
user_id	INTEGER REFERENCES users(user_id)	Kto rezerwuje
desk_id	INTEGER REFERENCES desks(desk_id)	Jeśli to biurko
room_id	INTEGER REFERENCES meeting_rooms(room_id)	Jeśli sala
start_time	TIMESTAMP NOT NULL	Czas rozpoczęcia
end_time	TIMESTAMP NOT NULL	Czas zakończenia
status	TEXT DEFAULT 'active'	active, cancelled, finished

5. payments
Kolumna	Typ	Opis
payment_id	SERIAL PRIMARY KEY	ID płatności
reservation_id	INTEGER REFERENCES reservations(reservation_id)	Za co płatność
amount	NUMERIC(10,2)	Kwota
payment_date	TIMESTAMP DEFAULT NOW()	Data zapłaty
method	TEXT	card, transfer, cash itd.

6. invoices
Kolumna	Typ	Opis
invoice_id	SERIAL PRIMARY KEY	ID faktury
payment_id	INTEGER REFERENCES payments(payment_id)	Na podstawie jakiej płatności
issue_date	DATE	Data wystawienia
invoice_number	TEXT UNIQUE	Numer faktury (np. FV-2025-001)

7. access_logs
Kolumna	Typ	Opis
log_id	SERIAL PRIMARY KEY	ID loga
user_id	INTEGER REFERENCES users(user_id)	Kto wchodzi
entry_time	TIMESTAMP	Wejście
exit_time	TIMESTAMP	Wyjście

