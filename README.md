# Projeto Banco de Dados

Projeto da disciplina de Banco de Dados, do curso de Ciência da Computação da Universidade Federal do Agreste de Pernambuco (UFAPE), ministrada pelo professor Dimas Cassimiro do Nascimento Filho.

## REQUISITOS

O banco de dados deve armazenar informações de produtos, pedidos, clientes, estoques e
outras informações relacionadas. Um produto deve ser identificado por um identificador (ID),
o qual deve ser único e sequencial para cada produto. Todo produto tem um nome, descrição,
data de garantia, valor (numérico) de status, preço de custo, preço de venda e preço de venda
mínimo. Um produto pode ter diversos nomes e descrições em idiomas diferentes. Os
produtos são classificados em diferentes categorias, sendo que cada categoria possui um ID
próprio, um nome e uma descrição. Além disso, deve ser possível identificar o fornecedor de
um produto, tal que cada fornecedor tem um nome, localidade, tipo de fornecedor (pessoa
física ou jurídica) e número do CNPJ ou do CPF. O estoque deve ser identificado unicamente
por um ID (único e sequencial), além de possuir um código. Um estoque sempre está
relacionado a um único produto, identificando a quantidade existente de um determinado
produto. Por sua vez, um armazém é composto por um ou mais estoques. Além disso, cada
armazém possui um ID único e sequencial, além de nome e endereço do armazém. Um pedido
realizado por um cliente pode conter diversos produtos diferentes, sendo que os diferentes
produtos de uma compra podem ser encomendados em quantidades diferentes. Por sua vez, o
preço do produto em um pedido pode ser diferente do preço de venda padrão associado ao
produto, mas não pode ser inferior ao preço mínimo de venda do produto. Um pedido deve
ser identificado unicamente e sequencialmente por um ID, além de constar informações sobre
data do pedido, modo de encomenda (presencial ou online), o cliente que realizou o pedido, o
status do pedido e a data de prazo de entrega do pedido. Finalmente, cada cliente deve ser
identificado unicamente e sequencialmente por um ID, além de constar dados sobre o nome,
os telefone(s), o país, estado, cidade, e-mail(s), limite de crédito ($) e data de cadastro do
cliente.

## ENTIDADES

### Produto
    - prodID INT PRIMARY KEY AUTO_INCREMENT
    - nomeProd VARCHAR(50)
    - descricaoProd VARCHAR(100)
    - dataGarantia DATE
    - statusProd ENUM('Ativo', 'Inativo')
    - precoCusto DECIMAL(10,2)
    - precoVenda DECIMAL(10,2)
    - precoVendaMin DECIMAL(10,2)
    - fornecedorID INT FOREIGN KEY REFERENCES Fornecedor(fornecedorID)
    - categoriasProdID INT FOREIGN KEY REFERENCES Categoria(categoriaID)
    - traducaoProdID INT FOREIGN KEY REFERENCES TraducaoProduto(traducaoProdID)
    ( UM PRODUTO PODE TER VÁRIAS CATEGORIAS? )
    ( UM PRODUTO PODE TER VÁRIOS ESTOQUES OU APENAS UM? )
    
### Categoria
    - categoriaID INT PRIMARY KEY AUTO_INCREMENT
    - nomeCategoria VARCHAR(50)
    - descricaoCategoria VARCHAR(100)

### Fornecedor
    - fornecedorID INT PRIMARY KEY AUTO_INCREMENT
    - nomeFornecedor VARCHAR(50)
    - localidadeFornecedor VARCHAR(50)
    - tipoFornecedor ENUM('Física', 'Jurídica')
    - documentoFornecedor VARCHAR(50)

### Estoque
    - estoqueID INT PRIMARY KEY AUTO_INCREMENT
    - codigoEstoque VARCHAR(50)
    - quantidade INT
    - produtoID INT FOREIGN KEY REFERENCES Produto(produtoID)
    - armazemID INT FOREIGN KEY REFERENCES Armazem(armazemID)

### Armazem
    - armazemID INT PRIMARY KEY AUTO_INCREMENT
    - nomeArmazem VARCHAR(50)
    - enderecoArmazem VARCHAR(50)
    ( MODELAR ESTOQUES POR ARMAZEM )

### Pedido
    - pedidoID INT PRIMARY KEY AUTO_INCREMENT
    - clienteID INT FOREIGN KEY REFERENCES Cliente(clienteID)
    - dataPedido DATETIME
    - modoEncomenda ENUM('Presencial', 'Online')
    - statusPedido ENUM('Aguardando Pagamento', 'Pagamento Confirmado', 'Em Preparação', 'Em Transporte', 'Entregue')
    - PrazoEntrega DATE
    ( MODELAR PRODUTOS POR PEDIDO, COM QUANTIDADES DIFERENTES, E CHECAR SE O PREÇO DO PRODUTO É IGUAL OU SUPERIOR AO PREÇO DE VENDA MÍNIMO DO PRODUTO )

### Cliente
    - clienteID INT PRIMARY KEY AUTO_INCREMENT
    - nomeCliente VARCHAR(50)
    - telefoneCliente VARCHAR(50)
    - paisCliente VARCHAR(50)
    - estadoCliente VARCHAR(50)
    - cidadeCliente VARCHAR(50)
    - emailCliente VARCHAR(50)
    - limiteCredito DECIMAL(10,2)
    - dataCadastroCliente DATETIME

### TraducaoProduto
    - idioma PRIMARY KEY VARCHAR(50)
    - produtoID INT PRIMARY KEY FOREIGN KEY REFERENCES Produto(produtoID)
    - nomeTraducao VARCHAR(50)
    - descricaoTraducao VARCHAR(100)
    

