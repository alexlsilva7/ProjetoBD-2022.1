-- --
# 1. Liste a quantidade de vendas realizadas nos anos 2021, 2027 e 2015, agrupada pelo nome
# do produto, por ano e por mês; o resultado deve ser mostrado de maneira decrescente pelo
# valor da soma do total de vendas do produto.
#

SELECT 
    Produto.nome AS NomeProduto,
    YEAR(Pedido.data) AS Ano,
    MONTH(Pedido.data) AS Mes,
    SUM(ProdutoPedido.quantidade) AS QuantidadeVendida,
    SUM(ProdutoPedido.precoVendaProduto * ProdutoPedido.quantidade) AS TotalVendas
FROM
    ProdutoPedido
    INNER JOIN Produto ON ProdutoPedido.produtoID = Produto.id
    INNER JOIN Pedido ON ProdutoPedido.pedidoId = Pedido.id
WHERE
    YEAR(Pedido.data) IN (2021, 2027, 2015)
GROUP BY 
    Produto.nome, YEAR(Pedido.data), MONTH(Pedido.data)
ORDER BY 
    TotalVendas DESC;

# Essa consulta usa a função SUM para calcular a quantidade total de produtos vendidos e o valor total de vendas de cada produto, juntos por nome do produto, ano e mês. 
# INNER JOIN é usada para unir a tabela Produto com a tabela ProdutoPedido, para que o nome do produto possa aparecer nos resultados.
# INNER JOIN é usada para unir a tabela Pedido com a tabela ProdutoPedido, para que o nome do produto possa aparecer nos resultados.
# WHERE filtra os dados de vendas para incluir apenas as vendas realizadas nos anos de 2021, 2027 e 2015. 
# ORDER BY classifica o conjunto de resultados em ordem decrescente pelo valor total das vendas.
#
-- --

-- --
# 2. Para cada produto, liste o nome do produto e a descrição do produto em todos os idiomas
# que constam no banco de dados.

SELECT 
	p.nome, tp.idioma, tp.descricao
FROM 
	Produto p
LEFT JOIN 
	TraducaoProduto tp ON p.id = tp.produtoID
ORDER BY 
	p.nome, tp.idioma;
    
#Esta consulta usa um LEFT JOIN para incluir todos os produtos, mesmo aqueles que não possuem tradução em nenhum idioma. 
#ORDER BY classifica os resultados por nome e idioma do produto.
#