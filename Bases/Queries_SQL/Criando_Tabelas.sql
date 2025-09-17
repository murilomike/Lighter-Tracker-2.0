USE LighterTrackerDB;
GO

-- Tabela: Estados
-- Armazena estados para contextualizar localização geográfica.
CREATE TABLE Estados (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nome_estado VARCHAR(100) NOT NULL, -- Nome do estado (ex.: "São Paulo")
    sigla CHAR(2) NOT NULL,           -- Sigla do estado (ex.: "SP")
    regiao VARCHAR(50)                -- Região do país (ex.: "Sudeste") para análises regionais
);

-- Tabela: Cidades
-- Armazena cidades, vinculadas a estados, para localização de usuários e estabelecimentos.
CREATE TABLE Cidades (
    id_cidade INT PRIMARY KEY IDENTITY(1,1),
    id_estado INT NOT NULL,
    nome_cidade VARCHAR(100) NOT NULL, -- Nome da cidade (ex.: "Campinas")
    latitude DECIMAL(9,6),             -- Latitude para análises geoespaciais
    longitude DECIMAL(9,6),            -- Longitude para análises geoespaciais
    FOREIGN KEY (id_estado) REFERENCES Estados(id_estado)
);

-- Tabela: Marcas
-- Armazena marcas de isqueiros.
CREATE TABLE Marcas (
    id_marca INT PRIMARY KEY IDENTITY(1,1),
    nome_marca VARCHAR(50) NOT NULL,   -- Nome da marca (ex.: "Bic")
    pais_origem VARCHAR(50)            -- País de origem da marca (ex.: "França") para análises
);

-- Tabela: Categorias
-- Classifica isqueiros por tipo (ex.: tamanho, tipo de chama).
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categoria VARCHAR(50) NOT NULL, -- Nome da categoria (ex.: "Mini")
    descricao VARCHAR(200)              -- Descrição da categoria (ex.: "Isqueiros pequenos")
);

-- Tabela: Usuários
-- Armazena informações dos usuários do aplicativo.
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_cidade INT NOT NULL,
    nome VARCHAR(100) NOT NULL,         -- Nome do usuário
    email VARCHAR(100) NOT NULL,        -- E-mail para login/notificações
    data_cadastro DATE NOT NULL,        -- Data de cadastro no app
    idade INT,                          -- Idade para análises demográficas
    profissao VARCHAR(50),             -- Profissão para segmentação (ex.: "Estudante")
    data_ultimo_acesso DATETIME,       -- Último login para rastrear engajamento
    FOREIGN KEY (id_cidade) REFERENCES Cidades(id_cidade)
);

-- Tabela: Estabelecimentos
-- Locais onde os isqueiros são comprados.
CREATE TABLE Estabelecimentos (
    id_estabelecimento INT PRIMARY KEY IDENTITY(1,1),
    id_cidade INT NOT NULL,
    nome_estabelecimento VARCHAR(100) NOT NULL, -- Nome do local (ex.: "Supermercado X")
    tipo_comercio VARCHAR(50),                  -- Tipo de comércio (ex.: "Tabacaria")
    endereco VARCHAR(200),                     -- Endereço para maior precisão
    FOREIGN KEY (id_cidade) REFERENCES Cidades(id_cidade)
);

-- Tabela: Isqueiros
-- Catálogo de modelos de isqueiros disponíveis.
CREATE TABLE Isqueiros (
    id_isqueiro INT PRIMARY KEY IDENTITY(1,1),
    id_marca INT NOT NULL,
    id_categoria INT NOT NULL,
    nome_isqueiro VARCHAR(100) NOT NULL, -- Nome do modelo (ex.: "Bic Mini")
    cor VARCHAR(50),                     -- Cor do isqueiro (ex.: "Azul")
    material VARCHAR(50),                -- Material (ex.: "Plástico") para durabilidade
    tipo_combustivel VARCHAR(50),       -- Tipo de combustível (ex.: "Gás") para manutenção
    preco_medio DECIMAL(10,2),          -- Preço médio para análises de custo
    FOREIGN KEY (id_marca) REFERENCES Marcas(id_marca),
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

-- Tabela: Compras
-- Registra transações de compra de isqueiros.
CREATE TABLE Compras (
    id_compra INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    id_estabelecimento INT NOT NULL,
    data_compra DATETIME NOT NULL,      -- Data e hora da compra para análises temporais
    valor_total DECIMAL(10,2),          -- Valor total da compra
    metodo_pagamento VARCHAR(50),       -- Método de pagamento (ex.: "Cartão")
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_estabelecimento) REFERENCES Estabelecimentos(id_estabelecimento)
);

-- Tabela: Itens_Compra
-- Detalha os isqueiros comprados em cada transação.
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
-- Registra instâncias específicas de isqueiros possuídas por usuários.
CREATE TABLE Isqueiros_Usuario (
    id_isqueiro_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    id_isqueiro INT NOT NULL,
    id_item_compra INT NOT NULL,
    data_aquisicao DATE NOT NULL,       -- Data de aquisição do isqueiro
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
    tipo_local VARCHAR(50),             -- Tipo (ex.: "Residência")
    latitude DECIMAL(9,6),              -- Latitude para análises geoespaciais
    longitude DECIMAL(9,6),             -- Longitude para análises geoespaciais
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
    duracao_uso INT,                   -- Duração do uso em segundos (ex.: 5s por acendimento)
    condicao_uso VARCHAR(50),          -- Condição ambiental (ex.: "Chuva")
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
-- Registra eventos de manutenção dos isqueiros.
CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY IDENTITY(1,1),
    id_isqueiro_usuario INT NOT NULL,
    data_manutencao DATE NOT NULL,     -- Data da manutenção
    tipo_manutencao VARCHAR(50) NOT NULL, -- Tipo (ex.: "Recarga de gás")
    custo DECIMAL(10,2),               -- Custo da manutenção
    local_manutencao VARCHAR(100),     -- Local onde foi feita (ex.: "Tabacaria Y")
    FOREIGN KEY (id_isqueiro_usuario) REFERENCES Isqueiros_Usuario(id_isqueiro_usuario)
);