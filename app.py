## Aqui utilizaremos células para visualizar tabelas do banco
## Execute as células na ordem indicada

# %% 
# Célula 1 - Conexão com o banco MySQL via XAMPP
# Execute esta célula primeiro

import mysql.connector


con = mysql.connector.connect(
    host="localhost",
    user="root",
    password="*********",
    database="classicmodels"
)
cursor = con.cursor()

print("Conexão com o banco MySQL realizada!")

# %% 
# Célula 2 - Visualizar amostra da tabela tickets
# Execute depois da célula 1

cursor.execute("SELECT * FROM tickets LIMIT 10")

dados = cursor.fetchall()

for linha in dados:
    print(linha)

# %% 
# Célula 3 - Criar VIEW gerencial
# Execute depois da célula 1

cursor.execute("""
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
""")

con.commit()

print("View gerencial criada!")

# %% 
# Célula 4 - Visualizar a VIEW gerencial
# Execute depois da célula 3

cursor.execute("SELECT * FROM vw_painel_vendas_gerencial")

dados = cursor.fetchall()

for linha in dados:
    print(linha)

# %% 
# Fim do script