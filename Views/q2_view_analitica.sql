/* ========================================================================
   Q2 - MONITORAMENTO DE DEMORA NO TRANSPORTE / DESPACHO
   ========================================================================
   OBJETIVO GERAL E REGRA DE NEGÓCIO: 
   Monitorar a eficiência da equipe de logística, garantindo o menor tempo 
   de processamento possível entre a data do pedido (orderDate) e a data de 
   despacho (shippedDate). Pedidos cancelados são ignorados.

   CÁLCULOS E TRATAMENTOS:
   - DATEDIFF(): Calcula a diferença em dias corridos.
   - COALESCE(): Transforma valores nulos (pedidos não enviados) em 0 dias.

   CRITÉRIOS DE PRIORIZAÇÃO (Score de Atraso):
   - Extremo : 10 dias ou mais (Urgente)
   - Alto    : Entre 5 e 9 dias
   - Médio   : Entre 3 e 4 dias
   - Nenhum  : Menos de 3 dias ou recém-criados na fila de envio
======================================================================== */

-- ------------------------------------------------------------------------
-- VERSÃO 1: View Padrão (Sem CTE)
-- Implementação direta da regra de negócio repetindo os cálculos no CASE.
-- ------------------------------------------------------------------------
create or replace view DemoraNoTransporte(NumedoCliente, Cliente, NumeroPedido, Solicitacao, DiasPassados, Atraso)
as
select c.customerNumber, c.customerName, p.orderNumber, p.orderDate, coalesce(datediff(p.shippedDate, p.orderDate), 0) as diasPassados, 
case 
	when coalesce(datediff(p.shippedDate, p.orderDate), 0) >= 10 then 'Extremo'
	when coalesce(datediff(p.shippedDate, p.orderDate), 0) >= 5 and coalesce(datediff(p.shippedDate, p.orderDate), 0) < 10 then 'Alto'
	when coalesce(datediff(p.shippedDate, p.orderDate), 0) >= 3 and coalesce(datediff(p.shippedDate, p.orderDate), 0) < 5 then 'Médio'
	when coalesce(datediff(p.shippedDate, p.orderDate), 0) < 3 then 'Nenhum'
end
from customers as c inner join orders as p on c.customerNumber = p.customerNumber
where p.status != 'Cancelled';


-- ------------------------------------------------------------------------
-- VERSÃO 2: View Otimizada (Com CTE)
-- Refatoração do código anterior para aplicar boas práticas. 
-- A CTE 'PedidosCalculados' calcula os dias apenas uma vez, evitando 
-- repetição de código no SELECT principal e facilitando a leitura.
-- ------------------------------------------------------------------------
create or replace view DemoraNoTransporteCTE(NumeroCliente, Cliente, NumeroPedido, Solicitacao, DiasPassados, Atraso)
as
with PedidosCalculados
as (
select c.customerNumber, c.customerName, p.orderNumber, p.orderDate, coalesce(datediff(p.shippedDate, p.orderDate), 0) as calendarDays
from customers as c inner join orders as p on c.customerNumber = p.customerNumber
where p.status != 'Cancelled'
)
select 
customerNumber, customerName, orderNumber, orderDate,calendarDays, 
case
	when calendarDays >= 10 then 'Extremo'
	when calendarDays >= 5 and calendarDays < 10 then 'Alto'
	when calendarDays >= 3 and calendarDays < 5 then 'Médio'
	when calendarDays < 3 then 'Nenhum'
end
from PedidosCalculados;


-- ------------------------------------------------------------------------
-- EXTRAÇÃO ANALÍTICA: Resumo para Dashboards e Gráficos
-- Esta consulta consome a View otimizada e agrupa os dados, 
-- contando quantas ocorrências existem em cada categoria de atraso. 
-- Ideal para exportar e alimentar gráficos de pizza (ex: LibreOffice/Excel).
-- ------------------------------------------------------------------------
SELECT 
    Atraso AS categoria_atraso, 
    COUNT(*) AS quantidade_pedidos
FROM DemoraNoTransporteCTE
GROUP BY Atraso
ORDER BY quantidade_pedidos DESC;
