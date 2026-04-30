CREATE VIEW vw_painel_vendas_gerencial AS
SELECT
    strftime('%Y-%m', f.scheduled_departure) AS mes,
    COUNT(DISTINCT t.ticket_no) AS total_passagens,
    COUNT(tf.flight_id) AS total_voos_reservados,
    SUM(tf.amount) AS receita_total,
    AVG(tf.amount) AS ticket_medio
FROM tickets t
JOIN ticket_flights tf 
    ON t.ticket_no = tf.ticket_no
JOIN flights f 
    ON tf.flight_id = f.flight_id
GROUP BY mes
ORDER BY mes;

 SELECT * FROM vw_painel_vendas_gerencial;

CREATE VIEW vw_painel_vendas_detalhadas AS
SELECT
    t.ticket_no,
    t.book_ref,
    tf.flight_id,
    f.flight_no,
    f.departure_airport,
    f.arrival_airport,
    f.scheduled_departure,
    tf.fare_conditions,
    tf.amount AS valor_passagem
FROM tickets t
JOIN ticket_flights tf 
    ON t.ticket_no = tf.ticket_no
JOIN flights f 
    ON tf.flight_id = f.flight_id;

    SELECT * FROM vw_painel_vendas_detalhadas LIMIT 20;