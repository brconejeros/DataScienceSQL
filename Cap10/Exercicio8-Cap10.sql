# SQL Para Análise de Dados e Data Science - Capítulo 10


-- Criação da tabela 
CREATE TABLE cap10.vendas (
    ID INT PRIMARY KEY,
    DataVenda DATE,
    Produto VARCHAR(50),
    Quantidade INT,
    ValorUnitario DECIMAL(10, 2),
    Vendedor VARCHAR(50)
);


-- Insert
INSERT INTO cap10.vendas (ID, DataVenda, Produto, Quantidade, ValorUnitario, Vendedor) VALUES
(1, '2023-11-01', 'Produto A', 10, 100.00, 'Zico'),
(2, '2023-11-01', 'Produto B', 5, 200.00, 'Romário'),
(3, '2023-11-02', 'Produto A', 7, 100.00, 'Ronaldo'),
(4, '2023-11-02', 'Produto C', 3, 150.00, 'Bebeto'),
(5, '2023-11-03', 'Produto B', 8, 200.00, 'Romário'),
(6, '2023-11-03', 'Produto A', 5, 100.00, 'Zico'),
(7, '2023-11-04', 'Produto C', 10, 150.00, 'Bebeto'),
(8, '2023-11-04', 'Produto A', 2, 100.00, 'Ronaldo'),
(9, '2023-11-05', 'Produto B', 6, 200.00, 'Romário'),
(10, '2023-11-05', 'Produto C', 4, 150.00, 'Bebeto');


-- Pergunta 1: Qual o total de vendas por produto?
select 
	produto,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 1
order by 2 desc;

-- Pergunta 2: Qual o total de vendas por vendedor?
select 
	vendedor,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 1
order by 2 desc;

-- Pergunta 3: Qual o total de vendas por dia?
select 
	datavenda,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 1
order by 1 desc;

-- Pergunta 4: Como as vendas se acumulam por dia e por produto (incluindo subtotais diários)?
select 
	coalesce(to_char(datavenda, 'yyyy-mm-dd'), 'Total por Dia') data_venda,
	coalesce(produto, 'Total por Produto') produto,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 
	rollup(datavenda, produto)
order by 
	1, 2;

select 
	coalesce(to_char(datavenda, 'yyyy-mm-dd'), 'Total por Dia') data_venda,
	coalesce(produto, 'Total por Produto') produto,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 
	rollup(datavenda, produto)
order by 
	grouping(datavenda, produto), 1, 2;

-- Pergunta 5: Qual a combinação de vendedor e produto gerou mais vendas (incluindo todos os subtotais possíveis)?
select 
	coalesce(vendedor, 'Total por Vendedor') vendedor,
	coalesce(produto, 'Total por Produto') produto,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by 
	cube(vendedor, produto)
order by 
	grouping(vendedor, produto), total_vendas desc;

-- Imagine que você queira analisar as vendas totais por Produto, por Vendedor e também o total geral de todas as vendas. 
-- Como seria a Query SQL?
select 
	coalesce(vendedor, 'Todos') vendedor,
	coalesce(produto, 'Todos') produto,
	sum(quantidade*valorunitario) total_vendas
from cap10.vendas
group by grouping sets (
	(produto),
	(vendedor),
	()
)
order by 
	grouping(vendedor, produto), total_vendas desc
;






