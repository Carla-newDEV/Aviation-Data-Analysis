
CREATE TABLE IF NOT EXISTS aircrafts_data (
	aircraft_code	VARCHAR(3) NOT NULL,
	model	jsonb NOT NULL,
	range	INT NOT NULL,
	CONSTRAINT aircrafts_range_check CHECK((range > 0))
);
CREATE TABLE IF NOT EXISTS airports_data (
	airport_code	VARCHAR(3) NOT NULL,
	airport_name	jsonb NOT NULL,
	city	jsonb NOT NULL,
	coordinates	point NOT NULL,
	timezone	text NOT NULL
);
CREATE TABLE IF NOT EXISTS boarding_passes (
	ticket_no	VARCHAR(13) NOT NULL,
	flight_id	INT NOT NULL,
	boarding_no	INT NOT NULL,
	seat_no	VARCHAR varying(4) NOT NULL
);
CREATE TABLE IF NOT EXISTS bookings (
	book_ref	VARCHAR(6) NOT NULL,
	book_date	timestamp with time zone NOT NULL,
	total_amount	numeric(10, 2) NOT NULL
);
CREATE TABLE IF NOT EXISTS flights (
	flight_id	INT NOT NULL,
	flight_no	VARCHAR(6) NOT NULL,
	scheduled_departure	timestamp with time zone NOT NULL,
	scheduled_arrival	timestamp with time zone NOT NULL,
	departure_airport	VARCHAR(3) NOT NULL,
	arrival_airport	VARCHAR(3) NOT NULL,
	status	VARCHAR varying(20) NOT NULL,
	aircraft_code	VARCHAR(3) NOT NULL,
	actual_departure	timestamp with time zone,
	actual_arrival	timestamp with time zone
);
CREATE TABLE IF NOT EXISTS seats (
	aircraft_code	VARCHAR(3) NOT NULL,
	seat_no	VARCHAR varying(4) NOT NULL,
	fare_conditions	VARCHAR varying(10) NOT NULL
);
CREATE TABLE IF NOT EXISTS ticket_flights (
	ticket_no	VARCHAR(13) NOT NULL,
	flight_id	INT NOT NULL,
	fare_conditions	VARCHAR varying(10) NOT NULL,
	amount	numeric(10, 2) NOT NULL
);
CREATE TABLE IF NOT EXISTS tickets (
	ticket_no	VARCHAR(13) NOT NULL,
	book_ref	VARCHAR(6) NOT NULL,
	passenger_id	VARCHAR varying(20) NOT NULL
);
