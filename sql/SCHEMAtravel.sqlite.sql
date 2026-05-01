
"
Origem do banco: https://www.kaggle.com/datasets/saadharoon27/airlines-dataset

tz = timezone em número
timezone = timezone em texto

numeric equivale a DECIMAL

"

CREATE TABLE IF NOT EXISTS aircrafts_data (
	aircraft_code	VARCHAR(3) NOT NULL,
	model	JSON NOT NULL,
	range	INT NOT NULL,
	CONSTRAINT aircrafts_range_check CHECK((range > 0))
);
CREATE TABLE IF NOT EXISTS airports_data (
	airport_code	VARCHAR(3) NOT NULL,
	airport_name	JSON NOT NULL,
	city	JSON NOT NULL,
	coordinates	POINT NOT NULL,
	timezone	text NOT NULL
);
CREATE TABLE IF NOT EXISTS boarding_passes (
	ticket_no	VARCHAR(13) NOT NULL,
	flight_id	INT NOT NULL,
	boarding_no	INT NOT NULL,
	seat_no	VARCHAR(4) NOT NULL
);
CREATE TABLE IF NOT EXISTS bookings (
	book_ref	VARCHAR(6) NOT NULL,
	book_date	DATETIME NOT NULL,
	book_tz VARCHAR(6) NOT NULL,
	total_amount	numeric(10, 2) NOT NULL
);
CREATE TABLE IF NOT EXISTS flights (
	flight_id	INT NOT NULL,
	flight_no	VARCHAR(6) NOT NULL,

	scheduled_departure	DATETIME NOT NULL,
	scheduled_departure_tz VARCHAR(6) NOT NULL,

	scheduled_arrival	DATETIME NOT NULL,
	scheduled_arrival_tz VARCHAR(6) NOT NULL,

	departure_airport	VARCHAR(3) NOT NULL,
	arrival_airport	VARCHAR(3) NOT NULL,
	status	VARCHAR(20) NOT NULL,
	aircraft_code	VARCHAR(3) NOT NULL,

	actual_departure	DATETIME,
	actual_departure_tz VARCHAR(6),
	
	actual_arrival	DATETIME,
	actual_arrival_tz VARCHAR(6)
);
CREATE TABLE IF NOT EXISTS seats (
	aircraft_code	VARCHAR(3) NOT NULL,
	seat_no	VARCHAR(4) NOT NULL,
	fare_conditions	VARCHAR(10) NOT NULL
);
CREATE TABLE IF NOT EXISTS ticket_flights (
	ticket_no	VARCHAR(13) NOT NULL,
	flight_id	INT NOT NULL,
	fare_conditions	VARCHAR(10) NOT NULL,
	amount	numeric(10, 2) NOT NULL
);
CREATE TABLE IF NOT EXISTS tickets (
	ticket_no	VARCHAR(13) NOT NULL,
	book_ref	VARCHAR(6) NOT NULL,
	passenger_id	VARCHAR(20) NOT NULL
);