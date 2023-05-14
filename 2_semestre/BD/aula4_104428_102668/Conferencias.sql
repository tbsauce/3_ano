use p9g3
GO

CREATE TABLE Conferencias_Participante (
	[Nome] [varchar](256) NOT NULL,
	[Mail] [varchar](256) NOT NULL,
	[Morada] [varchar](256) NOT NULL,
	[Pdata] [int] NOT NULL,
	CONSTRAINT [PK_Conferencias_Participante] PRIMARY KEY CLUSTERED
	(
		[Mail]
	)
)
GO

CREATE TABLE Conferencias_Autor (
	[Mail] [varchar](256) NOT NULL,
	[Nome] [varchar](256) NOT NULL,
	[Instituicao] [varchar](256) NOT NULL,
	CONSTRAINT [PK_Conferencias_Autor] PRIMARY KEY CLUSTERED
	(
		[Mail]
	)
)
GO

CREATE TABLE Conferencias_Artigo (
	[Num_Reg] [int] NOT NULL,
	[Nome] [varchar](256) NOT NULL,
	[Autroes] [varchar](256) NOT NULL,
	CONSTRAINT [PK_Conferencias_Artigo] PRIMARY KEY CLUSTERED
	(
		[Num_Reg]
	)
)
GO


CREATE TABLE Conferencias_Instituicao(
	[Nome] [varchar](256) NOT NULL,
	[Endereco] [varchar](256),
	CONSTRAINT [PK_Conferencias_Instituicao] PRIMARY KEY CLUSTERED
	(
		[Endereco]
	)
)
GO

CREATE TABLE Conferencias_Conferencia(
	[Artigos] [int] NOT NULL,
	[Participantes] [varchar](256),
	CONSTRAINT [PK_Conferencias_Conferencia] PRIMARY KEY CLUSTERED
	(
		[Artigos]
	)
)
GO


CREATE TABLE Conferencias_Estudante (
	[Comprovativo] [varchar](256) NOT NULL,
	[Pmail] [varchar](256) NOT NULL,
	[IEndereco] [varchar](256) NOT NULL
	CONSTRAINT [PK_Conferencias_Estudante] PRIMARY KEY CLUSTERED
	(
		[Pmail]
	)
)
GO

CREATE TABLE Conferencias_Nao_Estudante (
	[Referencia] [int] NOT NULL,
	[Pmail] [varchar](256) NOT NULL,
	CONSTRAINT [PK_Conferencias_Nao_Estudante] PRIMARY KEY CLUSTERED
	(
		[Pmail]
	)
)
GO

ALTER TABLE Conferencias_Conferencia WITH CHECK ADD CONSTRAINT [FK_Conferencias_Conferencia_Conferencias_Artigo]
	FOREIGN KEY ([Artigos]) REFERENCES Conferencias_Artigo([Num_Reg])

ALTER TABLE Conferencias_Conferencia WITH CHECK ADD CONSTRAINT [FK_Conferencias_Conferencia_Conferencias_Participante]
	FOREIGN KEY ([Participantes]) REFERENCES Conferencias_Participante([Mail])


ALTER TABLE Conferencias_Artigo WITH CHECK ADD CONSTRAINT [FK_Conferencias_Artigo_Conferencia_Autore]
	FOREIGN KEY ([Autroes]) REFERENCES Conferencias_Autor([Mail])


ALTER TABLE Conferencias_Estudante WITH CHECK ADD CONSTRAINT [FK_Conferencias_Estudante_Conferencias_Participante]
	FOREIGN KEY ([Pmail]) REFERENCES Conferencias_Participante([Mail])


ALTER TABLE Conferencias_Nao_Estudante WITH CHECK ADD CONSTRAINT [FK_Conferencias_Nao_Estudante_Conferencias_Participante]
	FOREIGN KEY ([Pmail]) REFERENCES Conferencias_Participante([Mail])


ALTER TABLE Conferencias_Estudante WITH CHECK ADD CONSTRAINT [FK_Conferencias_Estudante_Conferencias_Instituicao]
	FOREIGN KEY ([IEndereco]) REFERENCES Conferencias_Instituicao([Endereco])

	
ALTER TABLE Conferencias_Autor WITH CHECK ADD CONSTRAINT [FK_Conferencias_Autor_Conferencias_Instituicao]
	FOREIGN KEY ([Instituicao]) REFERENCES Conferencias_Instituicao([Endereco])



