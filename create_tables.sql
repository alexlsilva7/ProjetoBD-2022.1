CREATE TABLE Fornecedor (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  localidade VARCHAR(255) NOT NULL,
  tipo ENUM('Física', 'Jurídica') NOT NULL,
  documento VARCHAR(50) NOT NULL
);

CREATE TABLE Categoria (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) UNIQUE NOT NULL,
  descricao VARCHAR(255) NOT NULL
);

CREATE TABLE Produto (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  dataGarantia DATE,
  status ENUM('ativo', 'inativo') NOT NULL,
  precoCusto DECIMAL(10,2) NOT NULL,
  precoVenda DECIMAL(10,2) NOT NULL,
  precoVendaMin DECIMAL(10,2) NOT NULL,
  fornecedorId INT UNSIGNED NOT NULL,
  FOREIGN KEY (fornecedorId) REFERENCES Fornecedor(id),
  CONSTRAINT precoCustoMenorPrecoVenda CHECK (precoCusto < precoVenda),
  CONSTRAINT precoVendaMaiorQueZero CHECK (precoVenda > 0),
  CONSTRAINT precoVendaMinMenorPrecoVendaAndMaiorPrecoCusto CHECK (precoVendaMin < precoVenda AND precoVendaMin > precoCusto)
);

CREATE TABLE TraducaoProduto (
  produtoId INT UNSIGNED NOT NULL,
  idioma VARCHAR(10) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  PRIMARY KEY (produtoId, idioma),
  FOREIGN KEY (produtoId) REFERENCES Produto(id)
);

CREATE TABLE ProdutoCategoria (
  produtoId INT UNSIGNED NOT NULL,
  categoriaId INT UNSIGNED NOT NULL,
  PRIMARY KEY (produtoId, categoriaId),
  FOREIGN KEY (produtoId) REFERENCES Produto(id),
  FOREIGN KEY (categoriaId) REFERENCES Categoria(id)
);

CREATE TABLE Armazem (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(255) NOT NULL
);

CREATE TABLE Estoque (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  quantidade INT UNSIGNED NOT NULL,
  armazemId INT UNSIGNED NOT NULL,
  produtoId INT UNSIGNED NOT NULL,
  FOREIGN KEY (armazemId) REFERENCES Armazem(id),
  FOREIGN KEY (produtoId) REFERENCES Produto(id)
);

CREATE TABLE Cliente (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  pais VARCHAR(100),
  estado VARCHAR(100),
  cidade VARCHAR(100),
  limiteCredito DECIMAL(10,2) NOT NULL,
  dataCadastro DATE NOT NULL,
  CONSTRAINT limiteCreditoMaiorQueZero CHECK (limiteCredito > 0)
);

CREATE TABLE TelefoneCliente (
  clienteId INT UNSIGNED NOT NULL,
  telefone VARCHAR(11) NOT NULL,
  PRIMARY KEY (clienteId, telefone),
  FOREIGN KEY (clienteId) REFERENCES Cliente(id),
  CONSTRAINT telefoneCliente11Digitos CHECK (LENGTH(telefone) = 11)
);

CREATE TABLE EmailCliente (
  clienteId INT UNSIGNED AUTO_INCREMENT NOT NULL,
  email VARCHAR(255) NOT NULL,
  PRIMARY KEY (clienteId, email),
  FOREIGN KEY (clienteId) REFERENCES Cliente(id)
);

CREATE TABLE Pedido (
  id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
  data DATE NOT NULL,
  modoEncomenda ENUM('Retirada', 'Entrega') NOT NULL,
  status ENUM('Aguardando Pagamento', 'Pagamento Confirmado', 'Em Preparação', 'Em Transporte', 'Entregue') NOT NULL,
  prazoEntrega DATE NOT NULL,
  clienteId INT UNSIGNED NOT NULL,
  FOREIGN KEY (clienteId) REFERENCES Cliente(id),
  CONSTRAINT prazoEntregaMaiorIgualData CHECK (prazoEntrega >= data)
);

CREATE TABLE ProdutoPedido (
  produtoId INT UNSIGNED NOT NULL,
  pedidoId INT UNSIGNED NOT NULL,
  precoVendaProduto DECIMAL(10,2) NOT NULL,
  quantidade INT UNSIGNED NOT NULL,
  PRIMARY KEY (produtoId, pedidoId),
  FOREIGN KEY (produtoId) REFERENCES Produto(id),
  FOREIGN KEY (pedidoId) REFERENCES Pedido(id),
  CONSTRAINT precoVendaProdutoMaiorQueZero CHECK (precoVendaProduto > 0),
  CONSTRAINT quantidadeMaiorQueZero CHECK (quantidade > 0)
);