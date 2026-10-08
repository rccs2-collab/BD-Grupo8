--         ENTIDADES

CREATE TABLE Usuario( --povoado
    cpf INTEGER,
    email VARCHAR2(100),

    CONSTRAINT Usuario_pkey
    PRIMARY KEY (cpf)

);

CREATE TABLE Pesquisador( --povoado
    cpf INTEGER,
    primeiro_nome VARCHAR2(40),
    segundo_nome VARCHAR2(40),

    CONSTRAINT Pesquisador_pkey
    PRIMARY KEY (cpf),
    CONSTRAINT Pesquisador_fkey
    FOREIGN KEY (cpf) REFERENCES Usuario(cpf)
);

CREATE TABLE Formacao( --povoado
    cpf INTEGER,
    formacao VARCHAR2(50),

    CONSTRAINT Formacao_pkey
    PRIMARY KEY (cpf,formacao),
    CONSTRAINT Formacao_fkey
    FOREIGN KEY (cpf) REFERENCES Pesquisador(cpf)
);

CREATE TABLE Leitor( --povoado
    cpf INTEGER,
    nome_de_usuario VARCHAR2(50),
    data_do_proximo_pagamento DATE,

    CONSTRAINT Leitor_pkey
    PRIMARY KEY (cpf),
    CONSTRAINT Leitor_fkey
    FOREIGN KEY (cpf) REFERENCES Usuario(cpf)
);

CREATE TABLE Instituicao( --povoado
    codigo_institucional INTEGER,
    nome VARCHAR2(100),
    tipo VARCHAR2(50),
    data_do_proximo_pagamento DATE,

    CONSTRAINT Instituicao_pkey
    PRIMARY KEY (codigo_institucional)
);

CREATE TABLE Telefone( --povoado
    codigo_institucional INTEGER,
    telefone INTEGER,

    CONSTRAINT Telefone_pkey
    PRIMARY KEY (codigo_institucional, telefone),
    CONSTRAINT Telefone_fkey
    FOREIGN KEY (codigo_institucional) REFERENCES Instituicao(codigo_institucional)
);

CREATE TABLE Periodico( --povoado
    codigo INTEGER,
    nome VARCHAR2(50),

    CONSTRAINT Periodico_pkey
    PRIMARY KEY (codigo)
);

CREATE TABLE Topico(--povoado
    numero INTEGER,
    nome VARCHAR2(20),

    CONSTRAINT Topico_pkey
    PRIMARY KEY (numero)
);

CREATE TABLE Edicao( --povoado
    numero INTEGER,
    codigo_periodico INTEGER,
    titulo VARCHAR2(100),

    CONSTRAINT Edicao_pkey
    PRIMARY KEY (numero, codigo_periodico),
    CONSTRAINT Edicao_fkey
    FOREIGN KEY (codigo_periodico) REFERENCES Periodico(codigo)
);

CREATE TABLE Artigo( -- povoado
    codigo INTEGER,
    titulo VARCHAR2(100),
    tipo VARCHAR2(50),
    data_de_escrita DATE,
    numero_edicao INTEGER,
    codigo_periodico INTEGER,

    CONSTRAINT Artigo_pkey
    PRIMARY KEY (codigo),
    CONSTRAINT Artigo_fkey1
    FOREIGN KEY (numero_edicao, codigo_periodico) REFERENCES Edicao(numero, codigo_periodico)
);

CREATE TABLE Pagamento_instituicao( --povoado
    data_de_realizacao DATE,
    codigo_institucional INTEGER,
    valor FLOAT,
    forma_de_pagamento VARCHAR2(40),

    CONSTRAINT Pagamento_instituicao_pkey
    PRIMARY KEY (data_de_realizacao, codigo_institucional),
    CONSTRAINT Pagamento_instituicao_fkey
    FOREIGN KEY (codigo_institucional) REFERENCES Instituicao(codigo_institucional),

    CONSTRAINT Pagamento_instituicao_check
    CHECK (valor = 300.0)
);

CREATE TABLE Pagamento_leitor( --povoado
    data_de_realizacao DATE,
    cpf INTEGER,
    valor FLOAT,
    forma_de_pagamento VARCHAR2(40),

    CONSTRAINT Pagamento_leitor_pkey
    PRIMARY KEY (data_de_realizacao, cpf),
    CONSTRAINT Pagamento_leitor_fkey
    FOREIGN KEY (cpf) REFERENCES Leitor(cpf),

    CONSTRAINT Pagamento_leitor_check
    CHECK (valor = 50.0)
);

-- RELACIONAMENTOS

CREATE TABLE Escrever( --Povoado
    codigo_institucional INTEGER,
    cpf INTEGER,
    codigo_artigo INTEGER,

    CONSTRAINT Escrever_pkey
    PRIMARY KEY (codigo_institucional, cpf, codigo_artigo),
    CONSTRAINT Escrever_fkey1
    FOREIGN KEY (codigo_institucional) REFERENCES Instituicao(codigo_institucional),
    CONSTRAINT Escrever_fkey2
    FOREIGN KEY (cpf) REFERENCES Pesquisador(cpf),
    CONSTRAINT Escrever_fkey3
    FOREIGN KEY (codigo_artigo) REFERENCES Artigo(codigo)
);

CREATE TABLE Citar( --povoado
    codigo_citado INTEGER,
    codigo_citante INTEGER,

    CONSTRAINT Citar_pkey
    PRIMARY KEY (codigo_citado, codigo_citante),
    CONSTRAINT Citar_fkey1
    FOREIGN KEY (codigo_citado) REFERENCES Artigo(codigo),
    CONSTRAINT Citar_fkey2
    FOREIGN KEY (codigo_citante) REFERENCES Artigo(codigo)
);

CREATE TABLE Publicar( --povoado
    codigo_institucional INTEGER,
    codigo_periodico INTEGER,
    data_de_publicacao DATE,

    CONSTRAINT Publicar_pkey
    PRIMARY KEY (codigo_institucional, codigo_periodico, data_de_publicacao),
    CONSTRAINT Publicar_fkey1
    FOREIGN KEY (codigo_institucional) REFERENCES Instituicao(codigo_institucional),
    CONSTRAINT Publicar_fkey2
    FOREIGN KEY (codigo_periodico) REFERENCES Periodico(codigo)
);

CREATE TABLE Abrange( --povoado
    numero_topico INTEGER,
    numero_edicao INTEGER,
    codigo_periodico INTEGER,

    CONSTRAINT Abrange_pkey
    PRIMARY KEY (numero_topico, numero_edicao, codigo_periodico),
    CONSTRAINT Abrange_fkey1
    FOREIGN KEY (numero_topico) REFERENCES Topico(numero),
    CONSTRAINT Abrange_fkey2
    FOREIGN KEY (numero_edicao, codigo_periodico) REFERENCES Edicao(numero, codigo_periodico)
);

CREATE TABLE Notificar( --povoada
    cpf INTEGER,
    codigo_institucional INTEGER,
    codigo_periodico INTEGER,
    data_de_publicacao DATE,
    data_de_notificacao DATE,
    situacao VARCHAR2(10),

    CONSTRAINT Notificar_pkey
    PRIMARY KEY (cpf, codigo_institucional, codigo_periodico, data_de_publicacao),
    CONSTRAINT Notificar_fkey1
    FOREIGN KEY (cpf) REFERENCES Leitor(cpf),
    CONSTRAINT Notificar_fkey2
    FOREIGN KEY (codigo_institucional) REFERENCES Instituicao(codigo_institucional),
    CONSTRAINT Notificar_fkey3
    FOREIGN KEY (codigo_periodico) REFERENCES Periodico(codigo),

    CONSTRAINT Notificar_check
    CHECK (situacao IN ('enviada','recebida','lida'))
);

CREATE TABLE Inscrever( --povoada
    cpf INTEGER,
    codigo_periodico INTEGER,

    CONSTRAINT Inscrever_pkey
    PRIMARY KEY (cpf, codigo_periodico),
    CONSTRAINT Inscrever_fkey1
    FOREIGN KEY (cpf) REFERENCES Leitor(cpf),
    CONSTRAINT Inscrever_fkey2
    FOREIGN KEY (codigo_periodico) REFERENCES Periodico(codigo)
);

CREATE TABLE Ler( --povoado
    cpf INTEGER,
    numero_edicao INTEGER,
    codigo_periodico INTEGER,

    CONSTRAINT Ler_pkey
    PRIMARY KEY (cpf, numero_edicao, codigo_periodico),
    CONSTRAINT Ler_fkey1
    FOREIGN KEY (cpf) REFERENCES Leitor(cpf),
    CONSTRAINT Ler_fkey2
    FOREIGN KEY (numero_edicao, codigo_periodico) REFERENCES Edicao(numero, codigo_periodico)
);