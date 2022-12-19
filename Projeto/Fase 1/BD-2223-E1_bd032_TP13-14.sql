-- ----------------------------------------------------------------------------
--Bases de Dados 2022/23 - DI-FCUL
--Grupo bd32
--João Leal,        56922, TP14 33%
--Jorge Ferreira,   58951, TP13 33%
--Mariana Valente,  55945, TP13 33%
--Criação de tabelas, em sql, relativas às Clinicas da empresa Care4U
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS fatura;
DROP TABLE IF EXISTS voluntarios;
DROP TABLE IF EXISTS nao_voluntarios;
DROP TABLE IF EXISTS visita;
DROP TABLE IF EXISTS visitante;
DROP TABLE IF EXISTS utente;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS quarto;
DROP TABLE IF EXISTS enfermaria;
DROP TABLE IF EXISTS cama;
DROP TABLE IF EXISTS internamento;
DROP TABLE IF EXISTS relatorio;
DROP TABLE IF EXISTS exame;
DROP TABLE IF EXISTS habilitado;
DROP TABLE IF EXISTS especialidade;
DROP Table IF EXISTS tem;
DROP TABLE IF EXISTS tecnico;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS empregado_clinico;
DROP TABLE IF EXISTS trabalha;
DROP TABLE IF EXISTS horario;
DROP TABLE IF EXISTS sala;
DROP TABLE IF EXISTS piso;
DROP TABLE IF EXISTS clinica;

-- ----------------------------------------------------------------------------

CREATE TABLE clinica (
    NIPC                NUMERIC(5),
    premio_anual        NUMERIC(6,2)    NOT NULL,
    correio_eletronico  VARCHAR(50)     NOT NULL,
    nome                VARCHAR(40)     NOT NULL,
    data_inauguracao    DATE,
    telefone            NUMERIC(9)      NOT NULL,
    morada              VARCHAR(40)     NOT NULL,
    --
    CONSTRAINT pk_NIPC
        PRIMARY KEY (NIPC),
    --
    CONSTRAINT ck_clinica_NIPC
        CHECK (NIPC > 0),
    --
    CONSTRAINT ck_clinica_telefone
        CHECK (telefone > 0),
    --
    CONSTRAINT un_clinica_telefone 
        UNIQUE (telefone),
    --
    CONSTRAINT un_clinica_correio_eletronico 
        UNIQUE (correio_eletronico),

);

-- ----------------------------------------------------------------------------

CREATE TABLE piso ( 
    n_piso  INT    NOT NULL,
    --
    CONSTRAINT pk_piso 
        PRIMARY KEY (n_piso),

);

-- ----------------------------------------------------------------------------

CREATE TABLE sala (
    n_sala      INT,
    capacidade  INT             NOT NULL,
    equipamento VARCHAR(100)    NOT NULL,
    dimensao    INT             NOT NULL,
    piso        INT             NOT NULL,
    --
    CONSTRAINT pk_sala 
        PRIMARY KEY (n_sala),
    --
    CONSTRAINT ck_sala_capacidade 
        CHECK (capacidade > 0),
    --
    CONSTRAINT ck_sala_n_sala 
        CHECK (n_sala > 0),
    --
    CONSTRAINT fk_sala_piso 
        FOREIGN KEY (n_piso) REFERENCES piso,

);

-- ----------------------------------------------------------------------------

CREATE TABLE horario (
    codigo      VARCHAR(100)      NOT NULL,
    dia_semana  DECIMAL()         NOT NULL, 
    tipo        VARCHAR(100)      NOT NULL,
    --
    CONSTRAINT pk_horario 
        PRIMARY KEY(codigo),
    
);

-- ----------------------------------------------------------------------------

CREATE TABLE empregado_clinico (
    NIF                 NUMERIC(9),
    NIC                 NUMERIC(5)      NOT NULL,
    nome                VARCHAR(40)     NOT NULL,
    data_nascimento     DATE,
    genero              VARCHAR(10)     NOT NULL,
    --
    CONSTRAINT pk_NIF
        PRIMARY KEY(NIF),
    --
    CONSTRAINT ck_empregado_clinico_NIF
        CHECK(NIF > 0),
    --
    CONSTRAINT ck_empregado_clinico_genero 
        CHECK (genero='M' OR genero='F'),

);

-- ----------------------------------------------------------------------------

CREATE TABLE medico (

    CONSTRAINT fk_medico_NIF 
        FOREIGN KEY(NIF) REFERENCES empregado_clinico,

);

-- ----------------------------------------------------------------------------

CREATE TABLE tecnico (

    CONSTRAINT fk_tecnico_NIF 
        FOREIGN KEY(NIF) REFERENCES empregado_clinico,

);

-- ----------------------------------------------------------------------------

CREATE TABLE tem (
    codigo          decimal(20,0)   NOT NULL,
    data_inicio     date            NOT NULL    DEFAULT '0000-00-00',
    medico          decimal(20,0)   NOT NULL,
    --
    CONSTRAINT pk_tem 
        PRIMARY KEY (codigo),
    --
    CONSTRAINT fk_tem_codigo 
        FOREIGN KEY (codigo) REFERENCES especialidade,
);

-- ----------------------------------------------------------------------------

CREATE TABLE especialidade (
    codigo          decimal(20,0)   NOT NULL,
    sigla           varchar(3),
    nome            varchar(30)     NOT NULL,
    preco_diario    decimal(5,2),
    --
    CONSTRAINT pk_especialidade 
        PRIMARY KEY (codigo),
    --
    CONSTRAINT ck_especialidade_preco_diario 
        CHECK (preco_diario > 0),
    --
    CONSTRAINT ck_especialidade_codigo 
        CHECK (codigo > 0),

);

-- ----------------------------------------------------------------------------

CREATE TABLE habilitado (
    data_inicio     DATE,
    --
    CONSTRAINT fk_habilitado_NIF 
        FOREIGN KEY(NIF) REFERENCES empregado_clinico,

);

-- ----------------------------------------------------------------------------

CREATE TABLE exame (
    codigo          NUMERIC(7),
    data_inicio     DATE,
    data_fim        DATE,
    sigla           VARCHAR(5)      NOT NULL,
    tipo            VARCHAR(20)     NOT NULL,
    preco_normal    NUMERIC(4,2)    NOT NULL,
    preco_urgencia  NUMERIC(4,2)    NOT NULL,
    --
    CONSTRAINT pk_codigo
        PRIMARY KEY(codigo),
    --
    CONSTRAINT ck_exame_codigo
        CHECK(codigo > 0),

);

-- ----------------------------------------------------------------------------

CREATE TABLE relatorio (
    descricao       VARCHAR(100) NOT NULL,
    data_relatorio  DATE,
    --
    CONSTRAINT fk_relatorio_codigo 
        FOREIGN KEY(codigo) REFERENCES exame,

);

-- ----------------------------------------------------------------------------

CREATE TABLE internamento (
    data_inicio             date NOT NULL DEFAULT '0000-00-00',
    max_visitantes          decimal(2,0) NOT NULL,
    --
    CONSTRAINT fk_internamento_NIF
        FOREIGN KEY(NIF) REFERENCES utente,
    --
    CONSTRAINT ck_max_visitantes 
        CHECK (max_visitantes <= 10),
    --
    CONSTRAINT ck_codigo_intermanento 
        CHECK (codigo_internamento > 0),

);

-- ----------------------------------------------------------------------------

CREATE TABLE cama (
    numero  decimal(3,0) NOT NULL,
    --
    CONSTRAINT pk_cama 
        PRIMARY KEY (numero),

);

-- ----------------------------------------------------------------------------

CREATE TABLE enfermaria (
    codigo_internamento decimal(20,0) NOT NULL,
    --
    CONSTRAINT pk_codigo_internamento 
        PRIMARY KEY (codigo_internamento),
    --
    CONSTRAINT fk_codigo_internamento 
        FOREIGN KEY (codigo_internamento) REFERENCES internamento,
    --
    CONSTRAINT ck_codigo_intermanento 
        CHECK (codigo_internamento > 0),

);

-- ----------------------------------------------------------------------------

CREATE TABLE quarto (
    codigo_internamento decimal(20,0) NOT NULL,
    --
    CONSTRAINT pk_quarto 
        PRIMARY KEY (codigo_internamento),
    --
    CONSTRAINT fk_quarto 
        FOREIGN KEY (codigo_internamento) REFERENCES internamento,
         
);

-- ----------------------------------------------------------------------------

CREATE TABLE cliente (
    nif                 VARCHAR(9)      NOT NULL,
    nic                 VARCHAR(5)      NOT NULL, 
    nome                VARCHAR(30)     NOT NULL,
    genero              VARCHAR(1)      NOT NULL, 
    telefone            NUMBER(13)      NOT NULL, 
    morada              VARCHAR(100)    NOT NULL,
    data_nascimento     DATE            NOT NULL    DEFAULT '0000-00-00',
    correio_eletronico  VARCHAR(100)    NOT NULL,
    --
    CONSTRAINT pk_cliente 
        PRIMARY KEY (nif),
    --
    CONSTRAINT un_telefone 
        UNIQUE (telefone),
    --
    CONSTRAINT un_cliente_correio_eletronico 
        UNIQUE (correio_eletronico),
    --
    CONSTRAINT ck_cliente_genero 
        CHECK (genero='M' OR genero='F'),

);

-- ----------------------------------------------------------------------------

CREATE TABLE utente (
    CONSTRAINT fk_utente_nif
        FOREIGN KEY (nif) REFERENCES cliente,

);

-- ----------------------------------------------------------------------------

CREATE TABLE visitante (
    CONSTRAINT fk_visitante_nif 
        FOREIGN KEY (nif) REFERENCES cliente,

);

-- ----------------------------------------------------------------------------

CREATE TABLE visita (
    tempo   INTEGER     NOT NULL,
    --
    CONSTRAINT fk_visita_nif
        FOREIGN KEY (nif) REFERENCES cliente,

);

-- ----------------------------------------------------------------------------

CREATE TABLE nao_voluntarios (
    CONSTRAINT fk_nao_voluntarios_nif
        FOREIGN KEY (nif) REFERENCES cliente,

);

-- ----------------------------------------------------------------------------

CREATE TABLE voluntarios (
    visitas_ano     INT             NOT NULL,
    associacao_sol  VARCHAR(30)     NOT NULL, 
    --
    CONSTRAINT fk_voluntarios_nif
        FOREIGN KEY (nif) REFERENCES cliente,

);

-- ----------------------------------------------------------------------------

CREATE TABLE fatura (
    numero_seq      NUMERIC(7),
    data_emissao    DATE,
    pagamento       VARCHAR(20)     NOT NULL,
    total           NUMERIC(6,2)    NOT NULL,
    --
    CONSTRAINT pk_fatura
        PRIMARY KEY (numero_seq),
    --
    CONSTRAINT ck_fatura_numero_seq
        CHECK (numero_seq > 0)
    --
    CONSTRAINT ck_fatura_total
        CHECK (total > 0.0)

);

-- ----------------------------------------------------------------------------

-- RIAS:
--
-- RIA 1: Apenas um médico gere a clínica.
-- RIA 2: O supervisor tem de trabalhar na clínica a que está afeto.
-- RIA 3: A duração de um mandato do médico responsável pela clínica depende da idade da clínica.
-- RIA 4: Uma sala só pode ser usada para um tipo de exame se o seu equipamento estiver de acordo com o necessário para esse exame.
-- RIA 5: O tipo de horário depende do dia da semana.

-- ----------------------------------------------------------------------------