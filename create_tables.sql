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