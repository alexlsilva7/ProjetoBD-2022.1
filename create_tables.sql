CREATE TABLE Fornecedor (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  localidade VARCHAR(255),
  tipo ENUM('Física', 'Jurídica'),
  documento VARCHAR(50)
);

CREATE TABLE Categoria (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT
);

CREATE TABLE Produto (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  dataGarantia DATE,
  status Enum('ativo', 'inativo'),
  precoCusto DECIMAL(10,2),
  precoVenda DECIMAL(10,2),
  precoVendaMin DECIMAL(10,2),
  fornecedorId INT,
  FOREIGN KEY (fornecedorId) REFERENCES Fornecedor(id)
);

CREATE TABLE TraducaoProduto (
  produtoId INT NOT NULL,
  idioma VARCHAR(10) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  PRIMARY KEY (produtoId, idioma),
  FOREIGN KEY (produtoId) REFERENCES Produto(id)
);



CREATE TABLE ProdutoCategoria (
  produtoId INT NOT NULL,
  categoriaId INT NOT NULL,
  PRIMARY KEY (produtoId, categoriaId),
  FOREIGN KEY (produtoId) REFERENCES Produto(id),
  FOREIGN KEY (categoriaId) REFERENCES Categoria(id)
);

CREATE TABLE Armazem (
  id INT NOT NULL PRIMARY KEY,
  codigo VARCHAR(50),
  endereco TEXT
);

CREATE TABLE Estoque (
  id INT NOT NULL PRIMARY KEY,
  codigo VARCHAR(50),
  quantidade INT,
  armazemId INT,
  produtoId INT,
  FOREIGN KEY (armazemId) REFERENCES Armazem(id),
  FOREIGN KEY (produtoId) REFERENCES Produto(id)
);


CREATE TABLE Cliente (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  pais VARCHAR(100),
  estado VARCHAR(100),
  cidade VARCHAR(100),
  limiteCredito DECIMAL(10,2),
  dataCadastro DATE
);

CREATE TABLE TelefoneCliente (
  clienteId INT NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  PRIMARY KEY (clienteId, telefone),
  FOREIGN KEY (clienteId) REFERENCES Cliente(id)
);

CREATE TABLE EmailCliente (
  clienteId INT NOT NULL,
  email VARCHAR(255) NOT NULL,
  PRIMARY KEY (clienteId, email),
  FOREIGN KEY (clienteId) REFERENCES Cliente(id)
);

CREATE TABLE Pedido (
  id INT NOT NULL PRIMARY KEY,
  data DATE,
  modoEncomenda VARCHAR(50),
  status ENUM('Aguardando Pagamento', 'Pagamento Confirmado', 'Em Preparação', 'Em Transporte', 'Entregue'),
  prazoEntrega DATE,
  clienteId INT,
  FOREIGN KEY (clienteId) REFERENCES Cliente(id)
);

CREATE TABLE ProdutoPedido (
  produtoId INT NOT NULL,
  pedidoId INT NOT NULL,
  precoVendaProduto DECIMAL(10,2),
  quantidade INT,
  PRIMARY KEY (produtoId, pedidoId),
  FOREIGN KEY (produtoId) REFERENCES Produto(id),
  FOREIGN KEY (pedidoId) REFERENCES Pedido(id)
);

CREATE TABLE Venda (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  data DATETIME,
  produtoId INT NOT NULL,
  categoriaId INT NOT NULL,
  quantidade INT,
  precoVendaProduto DECIMAL(10,2),
  FOREIGN KEY(produtoID) REFERENCES Produto(id)
);

-- CONSULTAS --

-- --
# 1. Liste a quantidade de vendas realizadas nos anos 2021, 2027 e 2015, agrupada pelo nome
# do produto, por ano e por mês; o resultado deve ser mostrado de maneira decrescente pelo
# valor da soma do total de vendas do produto.

SELECT
    Produto.nome AS NomeProduto,
    YEAR(Venda.data) AS Ano,
    MONTH(Venda.data) AS Mes,
    SUM(Venda.quantidade) AS QuantidadeVendida,
    SUM(Venda.precoVendaProduto * Venda.quantidade) AS TotalVendas
FROM
    Venda
    INNER JOIN Produto ON Venda.produtoID = Produto.id
WHERE
    YEAR(Venda.data) IN (2021, 2027, 2015)
GROUP BY
    Produto.nome, YEAR(Venda.data), MONTH(Venda.data)
ORDER BY
    TotalVendas DESC;

# Essa consulta usa a função SUM para calcular a quantidade total de produtos vendidos e o valor total de vendas de cada produto, juntos por nome do produto, ano e mês. 
# INNER JOIN é usada para unir a tabela venda com a tabela produto, para que o nome do produto possa aparecer nos resultados. 
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
-- --