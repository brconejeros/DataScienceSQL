# SQL Para Análise de Dados e Data Science - Capítulo 12


-- Cria a tabela
CREATE TABLE cap12.vendas_temporais (
    id SERIAL PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_venda DECIMAL(10,2) NOT NULL,
    funcionario_id INT NOT NULL
);


-- Insere os registros
INSERT INTO cap12.vendas_temporais (data_venda, valor_venda, funcionario_id) VALUES
('2025-01-01', 175.00, 1001),
('2025-01-02', 155.00, 1001),
('2025-01-03', 321.00, 1002),
('2025-01-04', 254.00, 1001),
('2025-01-05', 189.00, 1002),
('2025-01-05', 182.00, 1002),
('2025-01-05', 183.00, 1002),
('2025-01-06', 190.00, 1003),
('2025-01-07', 190.00, 1003),
('2025-01-08', 245.00, 1004),
('2025-01-09', 456.00, 1005),
('2025-01-09', 230.00, 1005),
('2025-01-09', 150.00, 1003),
('2025-01-10', 157.00, 1002),
('2025-01-10', 188.00, 1001);


-- 1. Crie uma query para comparar em um relatório os dados de vendas diárias com a média móvel
-- Considere janela de 3 dias para a média móvel
select 
	data_venda,
	valor_venda,
	round(avg(valor_venda) over(order by data_venda ROWS BETWEEN 2 PRECEDING and current row), 2) media_movel
from cap12.vendas_temporais;

select 
	data_venda,
	valor_venda,
	round(avg(valor_venda) over(order by data_venda ROWS BETWEEN 1 PRECEDING and 1 following), 2) media_movel
from cap12.vendas_temporais;

-- 2. Crie uma query para comparar em um relatório os dados de vendas diárias com a média móvel
-- Considere janela de 7 dias para a média móvel
select 
	data_venda,
	valor_venda,
	round(avg(valor_venda) over(order by data_venda ROWS BETWEEN 6 PRECEDING and current row), 2) media_movel
from cap12.vendas_temporais;

select 
	data_venda,
	valor_venda,
	round(avg(valor_venda) over(order by data_venda ROWS BETWEEN 3 PRECEDING and 3 following), 2) media_movel
from cap12.vendas_temporais;

-- 3. Crie uma query que mostre o crescimento das vendas diárias em relação ao dia anterior
-- Por exemplo: De um dia para outro a venda aumento em 23 ou diminuiu em 57
select 
	data_venda,
	valor_venda,
	coalesce(cast(valor_venda - lag(valor_venda) over(order by data_venda) as varchar), 'Sem dados') diff_vendas
from cap12.vendas_temporais;

select 
	data_venda,
	valor_venda,
	coalesce(valor_venda - lag(valor_venda) over(order by data_venda), 0) diff_vendas
from cap12.vendas_temporais;

-- 4. Crie uma query que mostre a soma acumulada de vendas dia a dia
select 
	data_venda,
	sum(valor_venda) over(order by data_venda) soma_acumulada
from cap12.vendas_temporais;

select 
	data_venda,
	sum(valor_venda) over(partition by extract(month from data_venda) order by data_venda) soma_acumulada
from cap12.vendas_temporais;

-- 5. [Desafio] Crie um ranking de vendas por funcionário considerando o valor total de vendas por dia e de cada funcionário
with vendas_by_funcionario as (
select 
	funcionario_id,
	data_venda,
	sum(valor_venda) valor_total
from cap12.vendas_temporais
	group by 1, 2
)
select 
	*,
	dense_rank() over(partition by funcionario_id order by valor_total desc) rank
from vendas_by_funcionario;
