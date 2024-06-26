# SQL Para Análise de Dados e Data Science - Capítulo 17


-- 1. Qual o Número Total de Vendas e Média de Quantidade Vendida?
SELECT COUNT(*) FROM cap17.vendas;
SELECT ROUND(AVG(Quantidade),2) FROM cap17.vendas;


-- 2. Qual o Número Total de Produtos Únicos Vendidos?
SELECT COUNT(DISTINCT Id_Produto) FROM cap17.vendas;


-- 3. Quantas Vendas Ocorreram Por Produto? Mostre o Resultado em Ordem Decrescente.
SELECT p.nome, COUNT(v.Id_Produto) AS total_num_vendas
FROM cap17.vendas v
JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
GROUP BY p.nome
ORDER BY total_num_vendas DESC;


-- 4. Quais os 5 Produtos com Maior Número de Vendas?
SELECT p.nome, COUNT(*) AS total_vendas
FROM cap17.vendas v
JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
GROUP BY p.nome
ORDER BY total_vendas DESC
LIMIT 5;


-- 5. Quais Clientes Fizeram 6 ou Mais Transações de Compra?
SELECT c.nome, COUNT(v.Id_Cliente) AS total_compras
FROM cap17.vendas v
JOIN cap17.clientes c ON v.Id_Cliente = c.Id_Cliente
GROUP BY c.nome
HAVING COUNT(v.Id_Cliente) >= 6
ORDER BY total_compras DESC;

select
	c.id_cliente,
	c.nome,
	count(*) as quantidade_transacoes
from cap17.vendas v
left join cap17.clientes c
	using(id_cliente)
group by 1, 2
having count(*) > 5
order by 3 desc;


-- 6. Qual o Total de Transações Comerciais Por Mês no Ano de 2024? 
-- Apresente os Nomes dos Meses no Resultado, Que Deve Ser Ordenado Por Mês.
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM Data_Venda) = 1 THEN 'Janeiro'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 2 THEN 'Fevereiro'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 3 THEN 'Março'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 4 THEN 'Abril'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 5 THEN 'Maio'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 6 THEN 'Junho'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 7 THEN 'Julho'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 8 THEN 'Agosto'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 9 THEN 'Setembro'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 10 THEN 'Outubro'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 11 THEN 'Novembro'
        WHEN EXTRACT(MONTH FROM Data_Venda) = 12 THEN 'Dezembro'
    END AS mes,
    COUNT(*) AS total_vendas
FROM cap17.vendas
WHERE EXTRACT(YEAR FROM Data_Venda) = 2024
GROUP BY EXTRACT(MONTH FROM Data_Venda)
ORDER BY EXTRACT(MONTH FROM Data_Venda);


-- 7. Quantas Vendas de Notebooks Ocorreram em Junho e Julho de 2023?
SELECT COUNT(*) AS total_vendas_notebook
FROM cap17.vendas v
JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
WHERE p.nome = 'Notebook'
  AND EXTRACT(YEAR FROM v.Data_Venda) = 2023
  AND EXTRACT(MONTH FROM v.Data_Venda) IN (6, 7);

select
	p.nome,
	count(*) as total_vendas,
	sum(v.quantidade) as quantidade_produtos_vendidos,
	sum(v.quantidade * p.preco) as valor_total
from cap17.vendas v
left join cap17.produtos p
	using(id_produto)
where lower(p.nome) like '%notebook%'
  and extract(month from v.data_venda) between 6 and 7
  and extract(year from v.data_venda) = 2023
group by 1;


-- 8. Qual o Total de Vendas Por Mês e Por Ano ao Longo do Tempo?
SELECT DATE_TRUNC('month', Data_Venda) AS mes, COUNT(*) AS total_vendas
FROM cap17.vendas
GROUP BY mes
ORDER BY mes;

with aggregation as (
select
	extract(year from v.data_venda) ano,
	extract(month from v.data_venda) mes,
	count(*) as total_vendas,
	sum(v.quantidade) as quantidade_vendas,
	sum(v.quantidade * p.preco) as valor_total
from cap17.vendas v
left join cap17.produtos p
	using(id_produto)
group by 1, 2
)
select
	*,
	sum(total_vendas) over(order by ano, mes) as total_vendas_acumulativo,
	sum(quantidade_vendas) over(order by ano, mes) as quantidade_vendas_acumulativo,
	sum(valor_total) over(order by ano, mes) as valor_total_acumulativo
from aggregation
order by 1, 2;

-- 9. Quais Produtos Tiveram Menos de 100 Transações de Venda?
SELECT p.nome, COUNT(v.Id_Produto) AS total_vendas
FROM cap17.vendas v
JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
GROUP BY p.nome
HAVING COUNT(v.Id_Produto) < 100
ORDER BY total_vendas;

-- 10. Quais Clientes Compraram Smartphone e Também Compraram Smartwatch?

-- Subconsulta para clientes que compraram Smartphone
WITH compradores_smartphone AS (
    SELECT v.Id_Cliente
    FROM cap17.vendas v
    JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
    WHERE p.nome = 'Smartphone'
    GROUP BY v.Id_Cliente
),
-- Subconsulta para clientes que compraram Smartwatch
compradores_smartwatch AS (
    SELECT v.Id_Cliente
    FROM cap17.vendas v
    JOIN cap17.produtos p ON v.Id_Produto = p.Id_Produto
    WHERE p.nome = 'Smartwatch'
    GROUP BY v.Id_Cliente
)
-- Seleciona clientes que estão em ambas as subconsultas
SELECT c.nome
FROM cap17.clientes c
WHERE c.Id_Cliente IN (
    SELECT Id_Cliente FROM compradores_smartphone
    INTERSECT
    SELECT Id_Cliente FROM compradores_smartwatch
)
ORDER BY c.nome;

select
	c.nome as cliente,
	string_agg(distinct p.nome, ', ') as produto	
from cap17.vendas v
left join cap17.produtos p
	using(id_produto)
left join cap17.clientes c
	using(id_cliente)
where p.nome in ('Smartphone', 'Smartwatch')
group by 1
having string_agg(distinct p.nome, ', ') in ('Smartphone, Smartwatch', 'Smartwatch, Smartphone')
order by 1;

-- 11. Quais Clientes Compraram Smartphone e Também Compraram Smartwatch, Mas Não Compraram Notebook?

-- Clientes que compraram Smartphone
WITH clientes_smartphone AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartphone'
),
-- Clientes que compraram Smartwatch
clientes_smartwatch AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartwatch'
),
-- Clientes que compraram Notebook
clientes_notebook AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Notebook'
)
-- Clientes que compraram Smartphone e Smartwatch, mas não compraram Notebook
SELECT clientes.nome
FROM cap17.clientes
WHERE Id_Cliente IN (
    SELECT Id_Cliente FROM clientes_smartphone
    INTERSECT
    SELECT Id_Cliente FROM clientes_smartwatch
)
AND Id_Cliente NOT IN (
    SELECT Id_Cliente FROM clientes_notebook
);

with cliente_produto_notebook as (
	select
		c.id_cliente,
		c.nome as cliente,
		p.nome as produto
	from cap17.vendas v
	left join cap17.produtos p
		using(id_produto)
	left join cap17.clientes c
		using(id_cliente)
	where p.nome in ('Notebook')
)
select
	c.nome as cliente,
	string_agg(distinct p.nome, ', ') as produto
from cap17.vendas v
left join cap17.produtos p
	using(id_produto)
left join cap17.clientes c
	using(id_cliente)
where p.nome in ('Smartphone', 'Smartwatch')
  and c.id_cliente not in (select id_cliente from cliente_produto_notebook)
group by 1
having string_agg(distinct p.nome, ', ') in ('Smartphone, Smartwatch', 'Smartwatch, Smartphone')
order by 1;


-- 12. Quais Clientes Compraram Smartphone e Também Compraram Smartwatch, Mas Não Compraram Notebook em Maio/2024?

-- Clientes que compraram Smartphone em Maio/2024
WITH clientes_smartphone AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartphone'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
),
-- Clientes que compraram Smartwatch em Maio/2024
clientes_smartwatch AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartwatch'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
),
-- Clientes que compraram Notebook em Maio/2024
clientes_notebook AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Notebook'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
)
-- Clientes que compraram Smartphone e Smartwatch, mas não Notebook em Maio/2024
SELECT cap17.clientes.nome
FROM cap17.clientes
WHERE Id_Cliente IN (
    SELECT Id_Cliente FROM clientes_smartphone
    INTERSECT
    SELECT Id_Cliente FROM clientes_smartwatch
)
AND Id_Cliente NOT IN (
    SELECT Id_Cliente FROM clientes_notebook
);

with cliente_produto_notebook as (
	select
		c.id_cliente,
		c.nome as cliente,
		p.nome as produto
	from cap17.vendas v
	left join cap17.produtos p
		using(id_produto)
	left join cap17.clientes c
		using(id_cliente)
	where p.nome in ('Notebook')
	  and to_char(v.data_venda, 'YYYY-MM') = '2024-05'
)
select
	c.nome as cliente,
	string_agg(distinct p.nome, ', ') as produto
from cap17.vendas v
left join cap17.produtos p
	using(id_produto)
left join cap17.clientes c
	using(id_cliente)
where p.nome in ('Smartphone', 'Smartwatch')
  and to_char(v.data_venda, 'YYYY-MM') = '2024-05'
  and c.id_cliente not in (select id_cliente from cliente_produto_notebook)
group by 1
having string_agg(distinct p.nome, ', ') in ('Smartphone, Smartwatch', 'Smartwatch, Smartphone')
order by 1;

-- 13. Qual a Média Móvel de Quantidade de Unidades Vendidas ao Longo do Tempo? 
-- Considere Janela de 7 Dias.
SELECT
    Data_Venda,
    Quantidade,
    ROUND(AVG(Quantidade) OVER (ORDER BY Data_Venda
                          ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS media_movel_7dias
FROM cap17.vendas
ORDER BY Data_Venda;

with vendas as (
	select
		data_venda,
		round(avg(quantidade), 2) as media_vendas,
		row_number() over(order by data_venda) as media_movel_vendas
	from cap17.vendas
	group by 1
)
select
	data_venda,
	media_vendas,
	round(avg(media_vendas) over(order by media_movel_vendas RANGE BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as media_movel_vendas
from vendas;

-- 14. Qual a Média Móvel e Desvio Padrão Móvel de Quantidade de Unidades Vendidas ao Longo do Tempo? 
-- Considere Janela de 7 Dias.
SELECT
    Data_Venda,
    Quantidade,
    ROUND(AVG(Quantidade) OVER (ORDER BY Data_Venda
                                ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS media_movel_7dias,
    ROUND(STDDEV(Quantidade) OVER (ORDER BY Data_Venda
                                   ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS desvio_padrao_7dias
FROM cap17.vendas
ORDER BY Data_Venda;

with vendas as (
	select
		data_venda,
		round(avg(quantidade), 2) as media_vendas,
		round(stddev(quantidade), 2) as stddev_vendas,
		row_number() over(order by data_venda) as media_movel_vendas
	from cap17.vendas
	group by 1
)
select
	data_venda,
	media_vendas,
	round(avg(media_vendas) over(order by media_movel_vendas RANGE BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as media_movel_vendas,
	round(avg(stddev_vendas) over(order by media_movel_vendas RANGE BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as stddev_movel_vendas
from vendas;

-- 15. Quais Clientes Estão Cadastrados, Mas Ainda Não Fizeram Transação?
SELECT c.Id_Cliente, c.nome
FROM cap17.clientes c
LEFT JOIN cap17.vendas v ON c.Id_Cliente = v.Id_Cliente
WHERE v.Id_Cliente IS NULL;

select *
from cap17.clientes
where id_cliente not in (select distinct id_cliente from cap17.vendas);

