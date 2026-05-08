/*Stored Procedure*/
DELIMITER $UvU$

CREATE PROCEDURE sp_relatorio_vendas(
    IN inicio_periodo DATE,
    IN fim_periodo DATE,
    IN nacao VARCHAR(50)
)
BEGIN

    IF inicio_periodo > fim_periodo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data de início maior que a do fim.';
    END IF;


    SELECT 
        country,
        COUNT(*) AS total_pedidos,
        SUM(total_por_pedido) AS receita_total,
        AVG(total_por_pedido) AS valor_medio_dos_pedidos
    FROM vw_pedidos_totais
    WHERE orderDate BETWEEN inicio_periodo AND fim_periodo
    AND country = nacao
    GROUP BY country;

END$UvU$

DELIMITER ;