use p9g3
go 
create table ATL_PROFESSOR
(
    CC varchar(50) not null,
    Nome varchar(50) not null,
    N_funcionario int not null,
    D_nascimento date not null,
    Telefone varchar (50) not null,
    Email varchar(50) not null,
    constraint PK_ATL_PROFESSOR primary key (CC)
)
create table ATL_ATIVIDADE
(
    Id_atividade int not null,
    custo int not null,
    Designação varchar(50) not null,
    constraint PK_ATL_ATIVIDADE primary key (Id_atividade)
)
create table ALT_PESSOA_AUTORIZADA
(
    CC varchar(50) not null,
    Nome varchar(50) not null,
    Telefone varchar(50) not null,
    Email varchar(50) not null,
    Relacao varchar(50) not null,
    constraint PK_ALT_PESSOA_AUTORIZADA primary key (CC)
)
create table ALT_ENCARREGADO
(
    CC varchar(50) not null,
    Nome varchar(50) not null,
    Telefone varchar(50) not null,
    Email varchar(50) not null,
    Relacao varchar(50) not null,
    constraint PK_ALT_PESSOA_AUTORIZADA primary key (CC)
)
create table ATL_ALUNO(
    CC varchar(50) not null,
    Nome varchar(50) not null,
    Morada int not null,
    D_nascimento date not null,
    Encarregado_cc varchar (50) not null,
    Autorizado_cc varchar(50) not null,
    constraint PK_ATL_ALUNO primary key (CC)
    constraint FK_ATL_ALUNO_ATL_ENCARREGADO foreign key (Encarregado_cc) references ATL_ENCARREGADO(CC),
    constraint FK_ATL_ALUNO_ATL_PESSOA_AUTORIZADA foreign key (Autorizado_cc) references ATL_PESSOA_AUTORIZADA(CC)

)

create table ATL_TURMA(
    Id_turma int not null,
    Ano int not null,
    Designação varchar(50) not null,
    Professor_cc varchar(50) not null,
    Atividade_id int not null,
    Nmax_alunos varchar (50) not null,
    constraint PK_ATL_TURMA primary key (Id_turma),
    constraint FK_ATL_TURMA_ATL_PROFESSOR foreign key (Professor_cc) references ATL_PROFESSOR(CC),
    constraint FK_ATL_TURMA_ATL_ATIVIDADE foreign key (Atividade_id) references ATL_ATIVIDADE(Id_atividade),
    constraint FK_ATL_TURMA_ATL_ALUNO foreign key (Nmax_alunos) references ATL_ALUNO(CC)
)