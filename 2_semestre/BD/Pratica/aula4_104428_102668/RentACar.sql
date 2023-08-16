/*drop table RentACar_BALCAO;
drop table RentACar_Cliente;
drop table RentACar_TipoVeiculo;
drop table RentACar_Veiculo;
drop table RentACar_Pesado;
drop table RentACar_Ligeiro;
drop table RentACar_Aluguer;*/

USE p9g3
GO 

CREATE TABLE RentACar_BALCAO (
	[Numero] [int] NOT NULL,
	[Nome] [varchar](256) NOT NULL, 
	[Endereco] [varchar](1024) NOT NULL,
	CONSTRAINT [PK_RentACar_Balcao] PRIMARY KEY CLUSTERED
	(
		[Numero]
	)
)
GO


CREATE TABLE RentACar_Cliente (
	[NIF] [int] NOT NULL, 
	[Nome] [varchar](256) NOT NULL, 
	[Endereço] [varchar](1024) NOT NULL, 
	[NumCarta] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_Cliente] PRIMARY KEY CLUSTERED
	(
		[NIF]
	)
)
GO

CREATE TABLE RentACar_TipoVeiculo(
	[Designacao] [varchar](256) NOT NULL, 
	[Codigo] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_TipoVeiculo] PRIMARY KEY CLUSTERED
	(
		[Codigo]
	)
)
GO


CREATE TABLE RentACar_Veiculo( 
	[Matricula] [varchar](30) NOT NULL, 
	[Marca] [varchar](30) NOT NULL, 
	[Ano] [int] NOT NULL, 
	[TPcodigo] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_Veiculo] PRIMARY KEY CLUSTERED
	(
		[Matricula]
	)
)
GO


CREATE TABLE RentACar_Pesado( 
	[Peso] [int] NOT NULL, 
	[Passageiros] [int] NOT NULL,
	[TPcodigo] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_Pesado] PRIMARY KEY CLUSTERED
	(
		[TPcodigo]
	)
)
GO


CREATE TABLE RentACar_Ligeiro( 
	[NumLugares] [int] NOT NULL, 
	[Portas] [int] NOT NULL,
	[Combustivel] [varchar](256) NOT NULL,
	[TPcodigo] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_Ligeiro] PRIMARY KEY CLUSTERED
	(
		[TPcodigo]
	)
)
GO

CREATE TABLE RentACar_Aluguer (
	[Numero] [int] NOT NULL, 
	[Duracao] [int] NOT NULL,
	[Data] [varchar](30) NOT NULL, 
	[Vmatricula] [varchar](30) NOT NULL, 
	[Bnumero] [int] NOT NULL, 
	[Cnif] [int] NOT NULL,
	CONSTRAINT [PK_RentACar_Aluguer] PRIMARY KEY CLUSTERED
	(
		[Numero]
	)
)
GO


ALTER TABLE RentACar_Ligeiro WITH CHECK ADD CONSTRAINT [FK_RentACar_Ligeiro_RentACar_TipoVeiculo]
	FOREIGN KEY ([TPCodigo]) REFERENCES RentACar_TipoVeiculo([Codigo])

ALTER TABLE RentACar_Pesado WITH CHECK ADD CONSTRAINT [FK_RentACar_Pesado_RentACar_TipoVeiculo]
	FOREIGN KEY ([TPCodigo]) REFERENCES RentACar_TipoVeiculo([Codigo])

ALTER TABLE RentACar_Veiculo WITH CHECK ADD CONSTRAINT [FK_RentACar_Veiculo_RentACar_TipoVeiculo]
	FOREIGN KEY ([TPCodigo]) REFERENCES RentACar_TipoVeiculo([Codigo])



ALTER TABLE RentACar_Aluguer WITH CHECK ADD CONSTRAINT [FK_RentACar_Aluguer_RentACar_Balcao]
	FOREIGN KEY ([Bnumero]) REFERENCES RentACar_Balcao([Numero])

ALTER TABLE RentACar_Aluguer WITH CHECK ADD CONSTRAINT [FK_RentACar_Aluguer_RentACar_Veiculo]
	FOREIGN KEY ([Vmatricula]) REFERENCES RentACar_Veiculo([Matricula])

ALTER TABLE RentACar_Aluguer WITH CHECK ADD CONSTRAINT [FK_RentACar_Aluguer_RentACar_Cliente]
	FOREIGN KEY ([Cnif]) REFERENCES RentACar_Cliente([NIF])


