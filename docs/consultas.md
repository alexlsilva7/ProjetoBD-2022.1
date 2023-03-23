# Consultas
## 1. Liste a quantidade de vendas realizadas nos anos 2021, 2027 e 2015, agrupada pelo nome do produto, por ano e por mês; o resultado deve ser mostrado de maneira decrescente pelo valor da soma do total de vendas do produto.
```sql
SELECT
  YEAR(p.data) AS ano,
  MONTH(p.data) AS mes,
  SUM(pp.quantidade) AS quantidade,
  prod.nome AS nomeProduto
FROM
    Pedido p,
    ProdutoPedido pp,
    Produto prod
WHERE
    YEAR(p.data) IN (2021, 2027, 2015) AND
    p.id = pp.pedidoId AND
    pp.produtoId = prod.id
GROUP BY
    nomeProduto,
    ano,
    mes
ORDER BY
    quantidade DESC;
```
## 2. Para cada produto, liste o nome do produto e a descrição do produto em todos os idiomas que constam no banco de dados.
```sql
SELECT
  prod.nome AS nomeProduto,
  prod.descricao AS descricaoProduto,
  tp.idioma AS idioma,
  tp.nome AS nomeTraducao,
  tp.descricao AS descricaoTraducao
FROM
    Produto prod,
    TraducaoProduto tp
WHERE
    prod.id = tp.produtoId;
```
ou:
```sql
(SELECT
  tp.produtoId AS produtoID,
  tp.idioma AS idioma,
  tp.nome AS nomeProduto,
  tp.descricao AS descricaoProduto
FROM
  TraducaoProduto tp) 
  union 
(SELECT
   prod.id AS produtoID,
  'pt_BR' AS idioma,
  prod.nome AS nomeProduto,
  prod.descricao AS descricaoProduto
FROM
  Produto prod)
```
## 3. Listar o nome completo e a cidade dos clientes chineses que realizaram um valor total de compras superior a 13 mil em cada um dos seguintes anos: 2022, 2021 e 2015.
```sql
(SELECT
  c.nome AS nomeCliente,
  c.cidade AS cidadeCliente,
  SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalCompras,
  YEAR(p.data) AS ano
FROM
    Cliente c,
    Pedido p,
    ProdutoPedido pp
WHERE
    c.pais = 'China' AND
    c.id = p.clienteId AND
    p.id = pp.pedidoId AND
    YEAR(p.data) IN (2022)
GROUP BY
    nomeCliente,
    cidadeCliente,
    ano
HAVING
    valorTotalCompras > 13000)

union

(SELECT
  c.nome AS nomeCliente,
  c.cidade AS cidadeCliente,
  SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalCompras,
  YEAR(p.data) AS ano
FROM
    Cliente c,
    Pedido p,
    ProdutoPedido pp
WHERE
    c.pais = 'China' AND
    c.id = p.clienteId AND
    p.id = pp.pedidoId AND
    YEAR(p.data) IN (2021)
GROUP BY
    nomeCliente,
    cidadeCliente,
    ano
HAVING
    valorTotalCompras > 13000)
    
union

(SELECT
  c.nome AS nomeCliente,
  c.cidade AS cidadeCliente,
  SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalCompras,
  YEAR(p.data) AS ano
FROM
    Cliente c,
    Pedido p,
    ProdutoPedido pp
WHERE
    c.pais = 'China' AND
    c.id = p.clienteId AND
    p.id = pp.pedidoId AND
    YEAR(p.data) IN (2015)
GROUP BY
    nomeCliente,
    cidadeCliente,
    ano
HAVING
    valorTotalCompras > 13000)
```
## 4. Que meses foram mais rentáveis para a empresa nos anos de 2022 e 2021?
```sql
SELECT
  YEAR(p.data) AS ano,
  MONTH(p.data) AS mes,
  SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalCompras
FROM
    Pedido p,
    ProdutoPedido pp
WHERE
    YEAR(p.data) IN (2022, 2021)
GROUP BY
    ano,
    mes
ORDER BY
    valorTotalCompras DESC;
```

## 5. Qual fornecedor fornece produtos que vendem mais, para cada tipo de categoria de produto?
```sql
SELECT
    cat.nome AS nomeCategoria,
    f.nome AS nomeFornecedor,
    SUM(pp.quantidade) AS quantidadeVendida
FROM
    Fornecedor f,
    Produto p,
    ProdutoPedido pp,
    ProdutoCategoria pc,
    Categoria cat
WHERE
    f.id = p.fornecedorId AND
    p.id = pp.produtoId AND
    p.id = pc.produtoId AND
    pc.categoriaId = cat.id
GROUP BY
    nomeFornecedor,
    nomeCategoria
ORDER BY
    quantidadeVendida DESC;
```
## 6. Para cada produto, liste o preço de tabela do produto, o preço mínimo de venda do produto e o valor máximo e mínimo que o produto já foi vendido em 2020 ou em 2018.
```sql
SELECT
  prod.id AS produtoID,
  prod.precoVenda AS precoTabela,
  prod.precoVendaMin AS precoVendaMin,
  MAX(pp.precoVendaProduto) AS precoVendaMax,
  MIN(pp.precoVendaProduto) AS precoVendaMin,
  YEAR(p.data) AS ano
FROM
    Produto prod,
    ProdutoPedido pp,
    Pedido p
WHERE
    prod.id = pp.produtoId AND
    pp.pedidoId = p.id AND
    YEAR(p.data) IN (2020, 2018)
GROUP BY
    produtoID,
    ano;
```
## 7. Ordenar de maneira decrescente a soma total de vendas realizadas no ano 2021 por clientes mexicanos, agrupada por estado e cidade do cliente.
```sql
SELECT
    c.estado AS estado,
    c.cidade AS cidade,
    COUNT(*) AS totalVendas
FROM
    Cliente c,
    Pedido p,
    (SELECT
        p.id AS pedidoId,
        SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalPedido
    FROM
        Pedido p,
        ProdutoPedido pp
    WHERE
        p.id = pp.pedidoId
    GROUP BY
        pedidoId) valorTotalPedido
WHERE
    YEAR(p.data) = 2021 AND
    c.pais = 'Mexico' AND
    c.id = p.clienteId AND
    p.id = valorTotalPedido.pedidoId
GROUP BY
    estado,
    cidade
ORDER BY
    totalVendas DESC;
```

## 8. Liste o nome, o limite de crédito, o estado e a cidade dos clientes japoneses que já realizaram pelo menos 20 compras que possuem o valor total do pedido maior do que 10.000.
```sql
SELECT
    c.nome AS nomeCliente,
    c.limiteCredito AS limiteCredito,
    c.estado AS estado,
    c.cidade AS cidade,
    COUNT(*) AS totalCompras
FROM
    Cliente c,
    Pedido p,
    (SELECT
        p.id AS pedidoId,
        SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalPedido
    FROM
        Pedido p,
        ProdutoPedido pp
    WHERE
        p.id = pp.pedidoId
    GROUP BY
        pedidoId) valorTotalPedido
WHERE
    c.pais = 'Japão' AND
    c.id = p.clienteId AND
    p.id = valorTotalPedido.pedidoId AND
    valorTotalPedido.valorTotalPedido > 10000
GROUP BY
    nomeCliente,
    limiteCredito,
    estado,
    cidade
HAVING
    totalCompras >= 20
```
    
## 9. Liste o nome, a data de garantia e uma descrição de cada produto cuja diferença entre o preço de venda e o preço de venda mínimo é menor que 500.
```sql
SELECT
  prod.nome AS nomeProduto,
  prod.dataGarantia AS dataGarantia,
  prod.descricao AS descricaoProduto,
  prod.precoVenda AS precoVenda,
  prod.precoVendaMin AS precoVendaMin,
  (prod.precoVenda - prod.precoVendaMin) AS diferencaPreco
FROM
    Produto prod
WHERE
    (prod.precoVenda - prod.precoVendaMin) < 500;
```
## 10. Para cada compra realizada em 2018, 2019 ou 2022, listar: a data da compra, o valor total da compra, o modo da compra, a quantidade de produtos vendidos e o nome e o valor de crédito do cliente que realizou a compra.
```sql
SELECT
  p.data AS dataCompra,
  SUM(pp.precoVendaProduto * pp.quantidade) AS valorTotalCompra,
  p.modoEncomenda AS modoCompra,
  COUNT(*) AS quantidadeProdutosVendidos,
  c.nome AS nomeCliente,
  c.limiteCredito AS limiteCredito
FROM
    Pedido p,
    ProdutoPedido pp,
    Cliente c
WHERE
    YEAR(p.data) IN (2018, 2019, 2022) AND
    p.clienteId = c.id AND
    p.id = pp.pedidoId
GROUP BY
    dataCompra,
    modoCompra,
    nomeCliente,
    limiteCredito;
```