WITH vendas_mensais AS (
    SELECT 
        DATE_FORMAT(o.orderDate, '%Y-%m') AS ano_mes,
        c.customerName,
        SUM(od.quantityOrdered * od.priceEach) AS total_vendas
    FROM orders o
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY ano_mes, c.customerName
),

ranking AS (
    SELECT 
        ano_mes,
        customerName,
        total_vendas,

        RANK() OVER (
            PARTITION BY ano_mes 
            ORDER BY total_vendas DESC
        ) AS ranking_mes,

        SUM(total_vendas) OVER (
            PARTITION BY customerName 
            ORDER BY ano_mes
        ) AS acumulado_cliente

    FROM vendas_mensais
)

SELECT *
FROM ranking
WHERE ranking_mes <= 5
ORDER BY ano_mes DESC, ranking_mes;