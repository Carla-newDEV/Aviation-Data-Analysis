CREATE OR REPLACE VIEW vw_painel_vendas_gerencial AS
SELECT 
    DATE_FORMAT(o.orderDate, '%Y-%m') AS mes_venda,
    pl.productLine AS linha_produto,
    COUNT(DISTINCT o.orderNumber) AS total_pedidos,
    SUM(od.quantityOrdered * od.priceEach) AS receita_total,
    ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS ticket_medio
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN productlines pl ON p.productLine = pl.productLine
WHERE o.status != 'Cancelled'
GROUP BY 
    DATE_FORMAT(o.orderDate, '%Y-%m'), 
    pl.productLine
ORDER BY 
    mes_venda DESC, 
    receita_total DESC;



######




CREATE OR REPLACE VIEW vw_painel_vendas_detalhadas AS
SELECT 
    o.orderDate AS data_venda,
    o.orderNumber AS numero_pedido,
    c.customerName AS nome_cliente,
    p.productName AS nome_produto,
    p.productLine AS linha_produto,
    od.quantityOrdered AS quantidade,
    od.priceEach AS valor_unitario,
    (od.quantityOrdered * od.priceEach) AS valor_total_item,
    o.status AS status_pedido
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode;
