CREATE VIEW vw_pedidos_totais AS
SELECT 
    o.orderNumber,
    c.country,
    o.orderDate,
    SUM(od.quantityOrdered * od.priceEach) AS total_por_pedido
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber, c.country, o.orderDate;