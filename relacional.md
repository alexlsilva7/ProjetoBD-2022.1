## Modelo relacional

### Produto
    - id INT PRIMARY KEY AUTO_INCREMENT
    - nome VARCHAR(50)
    - descricao VARCHAR(100)
    - dataGarantia DATE
    - status ENUM('Ativo', 'Inativo')
    - precoCusto DECIMAL(10,2)
    - precoVenda DECIMAL(10,2)
    - precoVendaMin DECIMAL(10,2)
    - fornecedorID INT FOREIGN KEY REFERENCES Fornecedor(id)
    
### Categoria
    - categoriaId INT PRIMARY KEY AUTO_INCREMENT
    - nome VARCHAR(50)
    - descricao VARCHAR(100)
    
### ProdutoCategoria
    - prodId INT FOREIGN KEY REFERENCES Produto(id)
    - categoriaId INT FOREIGN KEY REFERENCES Categoria(id)

### Fornecedor
    - id INT PRIMARY KEY AUTO_INCREMENT
    - nome VARCHAR(50)
    - localidade VARCHAR(50)
    - tipo ENUM('Física', 'Jurídica')
    - documento VARCHAR(50)

### Estoque
    - id INT PRIMARY KEY AUTO_INCREMENT
    - codigo VARCHAR(50)
    - quantidade INT
    - produtoID INT FOREIGN KEY REFERENCES Produto(id)
    - armazemID INT FOREIGN KEY REFERENCES Armazem(id)

### Armazem
    - id INT PRIMARY KEY AUTO_INCREMENT
    - nome VARCHAR(50)
    - endereco VARCHAR(50)

### Pedido
    - id INT PRIMARY KEY AUTO_INCREMENT
    - data DATETIME
    - modoEncomenda ENUM('Presencial', 'Online')
    - status ENUM('Aguardando Pagamento', 'Pagamento Confirmado', 'Em Preparação', 'Em Transporte', 'Entregue')
    - prazoEntrega DATE
    - clienteID INT FOREIGN KEY REFERENCES Cliente(id)

### ProdutoPedido
    - produtoID INT PRIMARY KEY FOREIGN KEY REFERENCES Produto(produtoID)
    - pedidoID INT PRIMARY KEY FOREIGN KEY REFERENCES Pedido(pedidoID)
    - quantidade INT
    - precoVendaProduto DECIMAL(10,2)

### Cliente
    - id INT PRIMARY KEY AUTO_INCREMENT
    - nome VARCHAR(50)
    - pais VARCHAR(50)
    - estado VARCHAR(50)
    - cidade VARCHAR(50)
    - limiteCredito DECIMAL(10,2)
    - dataCadastro DATETIME

### TelefoneCliente
    - clienteID INT PRIMARY KEY FOREIGN KEY REFERENCES Cliente(id)
    - telefone VARCHAR(50) PRIMARY KEY
    
### EmailCliente
    - clienteID INT PRIMARY KEY FOREIGN KEY REFERENCES Cliente(id)
    - email VARCHAR(50) PRIMARY KEY

### TraducaoProduto
    - idioma PRIMARY KEY VARCHAR(50)
    - produtoID INT PRIMARY KEY FOREIGN KEY REFERENCES Produto(produtoID)
    - nome VARCHAR(50)
    - descricao VARCHAR(100)

### Venda
    -id INT PRIMARY KEY AUTO_INCREMENT
    -data DATETIME
    -clienteID INT FOREIGN KEY REFERENCES Cliente(id)
    -produtoID INT FOREIGN KEY REFERENCES Produto(id)
    -quantidade INT
    -precoVendaProduto DECIMAL(10,2)

        