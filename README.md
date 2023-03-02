# Projeto Banco de Dados - 2022.1 - UFAPE

Projeto da disciplina de Banco de Dados, do curso de Ciência da Computação da Universidade Federal do Agreste de Pernambuco (UFAPE), ministrada pelo professor Dimas Cassimiro do Nascimento Filho.

## Requisitos do Projeto

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

## Modelo Conceitual (ER)

![Modelo Conceitual](entidade-relacionamento.png)

## Modelo Lógico (Relacional)

- [Modelo relacional simples](Modelo_Relacional.pdf)

