use p9g3
drop table FARMA_PRESCRICAO;
DROP TABLE FARMA_FARMACIA;
drop TABLE FARMA_FARMACO;
drop table FARMA_FARMACEUTICA;
DROP TABLE FARMA_PACIENTE;
DROP TABLE FARMA_MEDICO;
create table FARMA_MEDICO
(
    ID int not null,
    Nome varchar (32 ) not null,
    Especialidade varchar (32 ) not null,
    constraint PK_MEDICO_ID primary key (ID)
)
create table FARMA_PACIENTE
(
    Numero_utente int not null,
    Nome varchar (32 ) not null,
    Data_nascimento date not null,
    Endereco varchar (32 ) not null,
    constraint PK_PACIENTE_NUMERO_UTENTE primary key (Numero_utente)
)

go
create table FARMA_FARMACEUTICA
(
    N_registro int not null,
    Nome varchar (32 ) not null,
    Endereco varchar (32 ) not null,
    Telefone varchar (32 ) not null,
    constraint PK_FARMACEUTICA_N_REGISTRO primary key (N_registro)
)
go

create table FARMA_FARMACO 
(
    Nome_comercial varchar (32 ) not null,
    Farmaceutica_n_registro int not null,
    Nif_farmacia int not null,
    Formula varchar (32 ) not null,
    constraint PK_FARMACO_NOME_REGISTIO primary key (Nome_comercial, Farmaceutica_n_registro)
    constraint FK_FARMACO_FARMACEUTICA foreign key (Farmaceutica_n_registro) references FARMA_FARMACEUTICA (N_registro),
)
go

create table FARMA_FARMACIA
(
    Nif int not null,
    Farmaco_nome varchar (32 ) not null,
	Farmaco_farmacia int not null,
    Nome varchar (32 ) not null,
    Endereco varchar (32 ) not null,
    Telefone varchar (32 ) not null,
    constraint PK_MEDICAMENTO_ID primary key (Nif),
    constraint FK_FARMACO_FARMACO_N_REGISTRO foreign key (Farmaco_nome, Farmaco_farmacia) references FARMA_FARMACO (Nome_comercial, Farmaceutica_n_registro) ,
)
create table FARMA_PRESCRICAO(
    ID int not null,
    Farmaco_nome varchar (32 ) not null,
    Farmacia int not null,
    Data_prescricao_farmacia date ,
    Data_prescricao date not null,
    Medico_id int not null,
    Paciente_numero_utente int not null,    
    constraint PK_PRESCRICAO_ID primary key (ID),
    constraint FK_PRESCRICAO_FARMACO_NOME_REGISTRO foreign key (Farmaco_nome, Farmacia) references FARMA_FARMACO (Nome_comercial, Farmaceutica_n_registro) ,
    constraint FK_PRESCRICAO_MEDICO_ID foreign key (Medico_id) references FARMA_MEDICO (ID) ,
    constraint FK_PRESCRICAO_PACIENTE_NUMERO_UTENTE foreign key (Paciente_numero_utente) references FARMA_PACIENTE (Numero_utente)
)