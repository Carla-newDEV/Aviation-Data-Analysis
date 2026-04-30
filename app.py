## Aqui utilizaremos células para visualizar tabelas do banco
## Execute as células na ordem indicada

# %% 
# Célula 1 - Conexão com o banco
# Execute esta célula primeiro

import sqlite3

con = sqlite3.connect("data/processed/travel.sqlite")
cursor = con.cursor()

print("Conexão com o banco realizada!")

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
# (precisa da conexão com o banco)

cursor.execute("""
CREATE VIEW IF NOT EXISTS vw_painel_vendas_gerencial AS
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
ORDER BY mes
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