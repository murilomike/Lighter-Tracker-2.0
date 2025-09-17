USE LighterTrackerDB;
GO

-- Tabela: Estados
-- Armazena estados para contextualizar localiza��o geogr�fica.
CREATE TABLE Estados (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nome_estado VARCHAR(100) NOT NULL, -- Nome do estado (ex.: "S�o Paulo")
    sigla CHAR(2) NOT NULL,           -- Sigla do estado (ex.: "SP")
    regiao VARCHAR(50)                -- Regi�o do pa�s (ex.: "Sudeste") para an�lises regionais
);

-- Tabela: Cidades
-- Armazena cidades, vinculadas a estados, para localiza��o de usu�rios e estabelecimentos.
CREATE TABLE Cidades (
    id_cidade INT PRIMARY KEY IDENTITY(1,1),
    id_estado INT NOT NULL,
    nome_cidade VARCHAR(100) NOT NULL, -- Nome da cidade (ex.: "Campinas")
    latitude DECIMAL(9,6),             -- Latitude para an�lises geoespaciais
    longitude DECIMAL(9,6),            -- Longitude para an�lises geoespaciais
    FOREIGN KEY (id_estado) REFERENCES Estados(id_estado)
);

-- Tabela: Marcas
-- Armazena marcas de isqueiros.
CREATE TABLE Marcas (
    id_marca INT PRIMARY KEY IDENTITY(1,1),
    nome_marca VARCHAR(50) NOT NULL,   -- Nome da marca (ex.: "Bic")
    pais_origem VARCHAR(50)            -- Pa�s de origem da marca (ex.: "Fran�a") para an�lises
);

-- Tabela: Categorias
-- Classifica isqueiros por tipo (ex.: tamanho, tipo de chama).
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categoria VARCHAR(50) NOT NULL, -- Nome da categoria (ex.: "Mini")
    descricao VARCHAR(200)              -- Descri��o da categoria (ex.: "Isqueiros pequenos")
);

-- Tabela: Usu�rios
-- Armazena informa��es dos usu�rios do aplicativo.
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_cidade INT NOT NULL,
    nome VARCHAR(100) NOT NULL,         -- Nome do usu�rio
    email VARCHAR(100) NOT NULL,        -- E-mail para login/notifica��es
    data_cadastro DATE NOT NULL,        -- Data de cadastro no app
    idade INT,                          -- Idade para an�lises demogr�ficas
    profissao VARCHAR(50),             -- Profiss�o para segmenta��o (ex.: "Estudante")
    data_ultimo_acesso DATETIME,       -- �ltimo login para rastrear engajamento
    FOREIGN KEY (id_cidade) REFERENCES Cidades(id_cidade)
);

-- Tabela: Estabelecimentos
-- Locais onde os isqueiros s�o comprados.
CREATE TABLE Estabelecimentos (
    id_estabelecimento INT PRIMARY KEY IDENTITY(1,1),
    id_cidade INT NOT NULL,
    nome_estabelecimento VARCHAR(100) NOT NULL, -- Nome do local (ex.: "Supermercado X")
    tipo_comercio VARCHAR(50),                  -- Tipo de com�rcio (ex.: "Tabacaria")
    endereco VARCHAR(200),                     -- Endere�o para maior precis�o
    FOREIGN KEY (id_cidade) REFERENCES Cidades(id_cidade)
);

-- Tabela: Isqueiros
-- Cat�logo de modelos de isqueiros dispon�veis.
CREATE TABLE Isqueiros (
    id_isqueiro INT PRIMARY KEY IDENTITY(1,1),
    id_marca INT NOT NULL,
    id_categoria INT NOT NULL,
    nome_isqueiro VARCHAR(100) NOT NULL, -- Nome do modelo (ex.: "Bic Mini")
    cor VARCHAR(50),                     -- Cor do isqueiro (ex.: "Azul")
    material VARCHAR(50),                -- Material (ex.: "Pl�stico") para durabilidade
    tipo_combustivel VARCHAR(50),       -- Tipo de combust�vel (ex.: "G�s") para manuten��o
    preco_medio DECIMAL(10,2),          -- Pre�o m�dio para an�lises de custo
    FOREIGN KEY (id_marca) REFERENCES Marcas(id_marca),
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

-- Tabela: Compras
-- Registra transa��es de compra de isqueiros.
CREATE TABLE Compras (
    id_compra INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    data_compra DATETIME NOT NULL,      -- Data e hora da compra para an�lises temporais
    valor_total DECIMAL(10,2),          -- Valor total da compra
    metodo_pagamento VARCHAR(50),       -- M�todo de pagamento (ex.: "Cart�o")
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimentos(id_estabelecimento)
);

-- Tabela: Itens_Compra
-- Detalha os isqueiros comprados em cada transa��o.
CREATE TABLE Itens_Compra (
    id_item_compra INT PRIMARY KEY IDENTITY(1,1),
    id_compra INT NOT NULL,
    id_isqueiro INT NOT NULL,
    quantidade INT NOT NULL,            -- Quantidade de isqueiros comprados
    valor_unitario DECIMAL(10,2),       -- Valor por isqueiro
    desconto DECIMAL(10,2),             -- Desconto aplicado (se houver)
    FOREIGN KEY (id_compra) REFERENCES Compras(id_compra),
    FOREIGN KEY (id_isqueiro) REFERENCES Isqueiros(id_isqueiro)
);

-- Tabela: Isqueiros_Usuario
-- Registra inst�ncias espec�ficas de isqueiros possu�das por usu�rios.
CREATE TABLE Isqueiros_Usuario (
    id_isqueiro_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    id_isqueiro INT NOT NULL,
    id_item_compra INT NOT NULL,
    data_aquisicao DATE NOT NULL,       -- Data de aquisi��o do isqueiro
    status VARCHAR(20) NOT NULL,        -- Status (ex.: "Ativo", "Perdido")
    identificador_unico VARCHAR(50),    -- Nome ou ID personalizado (ex.: "Meu Bic Azul")
    data_fim_uso DATE,                 -- Data de perda ou descarte
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_isqueiro) REFERENCES Isqueiros(id_isqueiro),
    FOREIGN KEY (id_item_compra) REFERENCES Itens_Compra(id_item_compra)
);

-- Tabela: Locais
-- Armazena locais de uso, armazenamento ou perda.
CREATE TABLE Locais (
    id_local INT PRIMARY KEY IDENTITY(1,1),
    id_cidade INT NOT NULL,
    nome_local VARCHAR(100) NOT NULL,   -- Nome do local (ex.: "Casa")
    tipo_local VARCHAR(50),             -- Tipo (ex.: "Resid�ncia")
    latitude DECIMAL(9,6),              -- Latitude para an�lises geoespaciais
    longitude DECIMAL(9,6),             -- Longitude para an�lises geoespaciais
    FOREIGN KEY (id_cidade) REFERENCES Cidades(id_cidade)
);

-- Tabela: Utilizacao
-- Registra eventos de uso dos isqueiros.
CREATE TABLE Utilizacao (
    id_utilizacao INT PRIMARY KEY IDENTITY(1,1),
    id_isqueiro_usuario INT NOT NULL,
    id_local INT NOT NULL,
    data_uso DATETIME NOT NULL,         -- Data e hora do uso
    contexto_uso VARCHAR(100),         -- Contexto (ex.: "Acender cigarro")
    duracao_uso INT,                   -- Dura��o do uso em segundos (ex.: 5s por acendimento)
    condicao_uso VARCHAR(50),          -- Condi��o ambiental (ex.: "Chuva")
    FOREIGN KEY (id_isqueiro_usuario) REFERENCES Isqueiros_Usuario(id_isqueiro_usuario),
    FOREIGN KEY (id_local) REFERENCES Locais(id_local)
);

-- Tabela: Historico_Localizacao
-- Registra onde os isqueiros foram guardados ou perdidos.
CREATE TABLE Historico_Localizacao (
    id_historico_localizacao INT PRIMARY KEY IDENTITY(1,1),
    id_isqueiro_usuario INT NOT NULL,
    id_local INT NOT NULL,
    data_localizacao DATETIME NOT NULL, -- Data e hora do evento
    tipo_evento VARCHAR(20) NOT NULL,  -- Tipo (ex.: "Guardado", "Perdido")
    detalhes VARCHAR(200),             -- Detalhes (ex.: "Esqueci no bar")
    status_confirmado BIT,             -- 1 para perda confirmada, 0 para suspeita
    FOREIGN KEY (id_isqueiro_usuario) REFERENCES Isqueiros_Usuario(id_isqueiro_usuario),
    FOREIGN KEY (id_local) REFERENCES Locais(id_local)
);

-- Tabela: Manutencao
-- Registra eventos de manuten��o dos isqueiros.
CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY IDENTITY(1,1),
    id_isqueiro_usuario INT NOT NULL,
    data_manutencao DATE NOT NULL,     -- Data da manuten��o
    tipo_manutencao VARCHAR(50) NOT NULL, -- Tipo (ex.: "Recarga de g�s")
    custo DECIMAL(10,2),               -- Custo da manuten��o
    local_manutencao VARCHAR(100),     -- Local onde foi feita (ex.: "Tabacaria Y")
    FOREIGN KEY (id_isqueiro_usuario) REFERENCES Isqueiros_Usuario(id_isqueiro_usuario)
);