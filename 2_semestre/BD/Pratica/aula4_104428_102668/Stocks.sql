use p9g3
GO

/*drop table Stocks_Encomendas;
drop table Stocks_Produtos;
drop table Stocks_Fornecedor;
drop table Stocks_Armazem;*/

CREATE TABLE Stocks_Encomendas (
	[Numero_enc] [int] NOT NULL,
	[EData] [int] NOT NULL, 
	[Iva] [int] NOT NULL,
	[NIF] [int] NOT NULL,
	[Pcodigo] [int] NOT NULL,
	[FCodigo] [int] NOT NULL,
	CONSTRAINT [PK_Stocks_Encomendas] PRIMARY KEY CLUSTERED
	(
		[Numero_enc]
	)
)
GO


CREATE TABLE Stocks_Produtos (
	[Codigo] [int] NOT NULL,
	[Preco] [int] NOT NULL, 
	[Nome] [varchar](1024) NOT NULL,
	[Iva] [int] NOT NULL,
	CONSTRAINT [PK_Stocks_Produtos] PRIMARY KEY CLUSTERED
	(
		[Codigo]
	)
)
GO

CREATE TABLE Stocks_Fornecedor (
	[NIF] [int] NOT NULL,
	[Nome] [varchar](1024) NOT NULL,
	[Endereco] [varchar](1024) NOT NULL,
	[Fax] [int] NOT NULL,
	[Codigo] [int] NOT NULL,
	[Condicoes] [varchar](1024) NOT NULL, 
	CONSTRAINT [PK_Stocks_Fornecedor] PRIMARY KEY CLUSTERED
	(
		[Codigo]
	)
)
GO

CREATE TABLE Stocks_Armazem (
	[Codigo] [int] NOT NULL,
	[Unidade] [int] NOT NULL,
	[Pcodigo] [int] NOT NULL,
	[Iva] [int] NOT NULL,
	CONSTRAINT [PK_Stocks_Armazem] PRIMARY KEY CLUSTERED
	(
		[Codigo]
	)
)
GO

ALTER TABLE Stocks_Armazem WITH CHECK ADD CONSTRAINT [FK_Stocks_Armazem_Stocks_Produtos]
	FOREIGN KEY ([Pcodigo]) REFERENCES Stocks_Produtos([Codigo])

ALTER TABLE Stocks_Encomendas WITH CHECK ADD CONSTRAINT [FK_Stocks_Encomendas_Stocks_Produtos]
	FOREIGN KEY ([Pcodigo]) REFERENCES Stocks_Produtos([Codigo])

ALTER TABLE Stocks_Encomendas WITH CHECK ADD CONSTRAINT [FK_Stocks_Encomendas_Stocks_Fornecedor]
	FOREIGN KEY ([FCodigo]) REFERENCES Stocks_Fornecedor([Codigo])
