# SQL Para Análise de Dados e Data Science - Capítulo 08


-- Quais produtos não têm pedido associado?
-- Retorne id do produto, nome do produto, preço do produto, id do cliente associado ao pedido, quantidade e id do pedido
-- Ordene por nome do produto
SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.pedidos p
RIGHT JOIN cap08.produtos pr ON pr.id_produto = p.id_produto
ORDER BY pr.nome;


-- Mostre somente os produtos sem pedido associado.
SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.pedidos p
RIGHT JOIN cap08.produtos pr ON pr.id_produto = p.id_produto
WHERE p.id_pedido IS NULL
ORDER BY pr.nome;


-- Sem modificar a ordem das tabelas retorne somente os produtos que tiveram pedido.
SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.pedidos p
RIGHT JOIN cap08.produtos pr ON pr.id_produto = p.id_produto
WHERE p.id_pedido IS NOT NULL
ORDER BY pr.nome;


SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.pedidos p
LEFT JOIN cap08.produtos pr ON pr.id_produto = p.id_produto
ORDER BY pr.nome;


-- Observe o que acontece sem integridade referencial:

-- Retorne todos os pedidos com ou sem produto associado
-- Retorne id do produto, nome do produto, preço do produto, id do cliente associado ao pedido, quantidade e id do pedido
-- Ordene por nome do produto


-- Resposta com tabelas onde a IR foi implementada
SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.produtos pr
RIGHT JOIN cap08.pedidos p ON pr.id_produto = p.id_produto
ORDER BY pr.nome;


-- Resposta com tabelas onde a IR NÃO foi implementada
SELECT pr.id_produto, pr.nome, pr.preco, p.id_cliente, p.quantidade, p.id_pedido
FROM cap08.produtos pr
RIGHT JOIN cap08.pedidos_sem_ir p ON pr.id_produto = p.id_produto
ORDER BY pr.nome;


-- FULL JOIN
-- Retorna todos os registros havendo ou não correspondência entre as tabelas

SELECT * 
FROM cap08.produtos pr
FULL JOIN cap08.pedidos p ON pr.id_produto = p.id_produto;

SELECT * 
FROM cap08.produtos pr
FULL OUTER JOIN cap08.pedidos p ON pr.id_produto = p.id_produto;


-- CROSS JOIN
-- Produto cartesiano, ou seja, retorna todas as combinações possíveis entre as tabelas
SELECT * 
FROM cap08.produtos pr
CROSS JOIN cap08.pedidos p;


-- SELF JOIN
-- Queremos listar os pares de pedidos feitos pelo mesmo cliente.
-- Ou seja, queremos todas as combinações de 2 pedidos diferentes para cada cliente.

SELECT * 
FROM cap08.pedidos
ORDER BY id_cliente; 

SELECT p1.id_pedido AS Pedido1_ID, p2.id_pedido AS Pedido2_ID, p1.id_cliente 
FROM cap08.pedidos p1
JOIN cap08.pedidos p2 
ON p1.id_cliente = p2.id_cliente;

SELECT p1.id_pedido AS Pedido1_ID, p2.id_pedido AS Pedido2_ID, p1.id_cliente 
FROM cap08.pedidos p1
JOIN cap08.pedidos p2 
ON p1.id_cliente = p2.id_cliente AND p1.id_pedido != p2.id_pedido;

SELECT p1.id_pedido AS Pedido1_ID, p2.id_pedido AS Pedido2_ID, p1.id_cliente 
FROM cap08.pedidos p1
JOIN cap08.pedidos p2 
ON p1.id_cliente = p2.id_cliente AND p1.id_pedido < p2.id_pedido;











