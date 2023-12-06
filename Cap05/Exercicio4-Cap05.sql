# SQL Para Análise de Dados e Data Science - Capítulo 05


-- Criando a tabela 'fornecedores'
CREATE TABLE cap05.fornecedores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    email VARCHAR(255),
    data_registro DATE
);


-- Inserindo registros na tabela 'funcionarios'
INSERT INTO cap05.fornecedores (nome, cidade, estado, email, data_registro) VALUES
('Fornecedor 1', 'São Paulo', 'SP', 'fornecedor1@exemplo.dsa.com', '2023-09-01'),
('Fornecedor 2', 'Rio de Janeiro', 'RJ', 'fornecedor2@exemplo.dsa.com', '2023-09-02'),
('Fornecedor 3', 'Belo Horizonte', 'MG', 'fornecedor3@exemplo.dsa.com', '2023-09-03'),
('Fornecedor 4', 'Porto Alegre', 'RS', 'fornecedor4@exemplo.dsa.com', '2023-09-04'),
('Fornecedor 5', 'Curitiba', 'PR', 'fornecedor5@exemplo.dsa.com', '2023-09-05'),
('Fornecedor 6', 'Recife', 'PE', 'fornecedor6@exemplo.dsa.com', '2023-09-06'),
('Fornecedor 7', 'Salvador', 'BA', 'fornecedor7@exemplo.dsa.com', '2023-10-07'),
('Fornecedor 8', 'Fortaleza', 'CE', 'fornecedor8@exemplo.dsa.com', '2023-10-08'),
('Fornecedor 9', 'Goiânia', 'GO', 'fornecedor9@exemplo.dsa.com', '2023-10-09'),
('Fornecedor 10', 'Manaus', 'AM', 'fornecedor10@exemplo.dsa.com', '2023-10-10');


# Use SQL para responder às perguntas abaixo:


-- Pergunta 1: Qual é a quantidade de fornecedores por estado?
select
	count(1) qtde,
	estado
from cap05.fornecedores
group by 2;

select
	estado,
	(select count(1) from cap05.fornecedores where estado = f.estado) as quantidade_fornecedores
from cap05.fornecedores f
group by 1;


-- Pergunta 2: Qual é o estado com o maior número de fornecedores?
select
	count(1) qtde,
	estado
from cap05.fornecedores
group by 2
order by 1 desc
limit 1;

-- Pergunta 3: Quantos fornecedores foram registrados no mês de Setembro de 2023?
select count(1) qtde_fornecedores
from cap05.fornecedores
where extract(year from data_registro) = 2023
  and extract(month from data_registro) = 9;
  
select count(1) qtde_fornecedores
from cap05.fornecedores
where data_registro >= '2023-09-01'
  and data_registro < '2023-10-01';

-- Pergunta 4: Qual é a média de registros de fornecedores por mês?
with registros as (
select 
	count(1) qtde,
	extract(year from data_registro) ano,
    extract(month from data_registro) mes
from cap05.fornecedores
group by 2, 3
)
select 
	round(avg(qtde), 0) media_registros
from registros;

-- Pergunta 5: Qual é o fornecedor mais recente registrado?
select *
from cap05.fornecedores
order by 6 desc
limit 1;

select *
from cap05.fornecedores
where data_registro = (select max(data_registro) from cap05.fornecedores);

