# Dicionário de Dados - Lighter Tracker 2.0

## 📋 Visão Geral

Este documento descreve a estrutura completa do banco de dados do sistema Lighter Tracker 2.0, um aplicativo para rastreamento e gerenciamento de isqueiros. O banco foi projetado para suportar análises comportamentais, preditivas e geográficas, além de funcionalidades de machine learning.

## 🎯 Decisões de Projeto e Justificativas

### Princípios de Design Adotados

- **Usabilidade**: Campos intuitivos e de fácil preenchimento via aplicativo móvel
- **Flexibilidade**: Campos opcionais para usuários com diferentes níveis de engajamento
- **Precisão Analítica**: Dados estruturados para suportar análises avançadas e ML
- **Personalização**: Recursos que tornam a experiência do usuário mais significativa

### Decisões Estratégicas

- **Geolocalização Precisa**: Substituição de coordenadas genéricas por campos específicos de latitude/longitude
- **Dados Temporais Granulares**: Uso de DATETIME para capturar timestamp completo dos eventos
- **Campos Contextuais**: Inclusão de metadados ricos para análises comportamentais
- **Rastreamento Completo**: Ciclo de vida completo dos isqueiros desde compra até descarte

## 🗃️ Esquema do Banco de Dados

### 1. Estados

**Propósito**: Armazenar unidades federativas para contextualização geográfica.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_estado | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária padrão |
| nome_estado | VARCHAR(100) | NOT NULL | Nome completo do estado | Identificação oficial |
| sigla | CHAR(2) | NOT NULL | Sigla do estado | Padrão nacional |
| regiao | VARCHAR(20) | NULL | Região do país | **NOVO**: Análises regionais comparativas |

**Decisão**: Adição de `regiao` para permitir análises macroregionais (ex: Sudeste vs Nordeste)

### 2. Cidades

**Propósito**: Registrar municípios para vinculação de usuários e estabelecimentos.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_cidade | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_estado | INT | FK, NOT NULL | Chave estrangeira para Estados | Integridade geográfica |
| nome_cidade | VARCHAR(100) | NOT NULL | Nome da cidade | Identificação oficial |
| latitude | DECIMAL(9,6) | NULL | Coordenada geográfica | **NOVO**: Mapas e geolocalização precisa |
| longitude | DECIMAL(9,6) | NULL | Coordenada geográfica | **NOVO**: Análises geoespaciais avançadas |

**Decisão**: Campos de coordenadas separados para maior precisão em análises espaciais

### 3. Usuários

**Propósito**: Armazenar dados demográficos e comportamentais dos usuários.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_usuario | INT | PK, IDENTITY(1,1) | Identificador único | Identificação única |
| id_cidade | INT | FK, NOT NULL | Cidade de residência | Contexto geográfico |
| nome | VARCHAR(100) | NOT NULL | Nome completo | Identificação pessoal |
| email | VARCHAR(100) | NOT NULL | E-mail para contato | Comunicação e login |
| data_cadastro | DATE | NOT NULL | Data de registro | Engajamento temporal |
| idade | INT | NULL | Idade do usuário | Segmentação demográfica |
| genero | CHAR(1) | NULL | Gênero (M/F/O) | Análise demográfica |
| profissao | VARCHAR(50) | NULL | Ocupação profissional | **NOVO**: Contexto socioeconômico |
| data_ultimo_acesso | DATETIME | NULL | Último login | **NOVO**: Métrica de engajamento |

**Decisão**: Adição de campos demográficos e de engajamento para clustering avançado

### 4. Estabelecimentos

**Propósito**: Cadastro de locais de compra de isqueiros.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_estabelecimento | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_cidade | INT | FK, NOT NULL | Localização geográfica | Contexto regional |
| nome_estabelecimento | VARCHAR(100) | NOT NULL | Razão social | Identificação comercial |
| tipo_comercio | VARCHAR(50) | NULL | Segmento do comércio | Categorização |
| endereco | VARCHAR(200) | NULL | Endereço completo | **NOVO**: Precisão locacional |
| latitude | DECIMAL(9,6) | NULL | Coordenada geográfica | Georreferenciamento |
| longitude | DECIMAL(9,6) | NULL | Coordenada geográfica | Georreferenciamento |

**Decisão**: Endereço completo para complementar as coordenadas geográficas

### 5. Marcas

**Propósito**: Catálogo de fabricantes de isqueiros.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_marca | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| nome_marca | VARCHAR(50) | NOT NULL | Nome da marca | Identificação comercial |
| pais_origem | VARCHAR(50) | NULL | País de origem | **NOVO**: Análise de preferência por origem |

**Decisão**: Campo de origem para análise de preferências nacionais vs importados

### 6. Categorias

**Propósito**: Classificação técnica dos isqueiros.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_categoria | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| nome_categoria | VARCHAR(50) | NOT NULL | Nome da categoria | Classificação principal |
| descricao | VARCHAR(200) | NULL | Descrição detalhada | **NOVO**: Contexto explicativo |

**Decisão**: Descrição para esclarecer categorias técnicas para usuários finais

### 7. Isqueiros

**Propósito**: Catálogo de modelos de isqueiros.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_isqueiro | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_marca | INT | FK, NOT NULL | Marca fabricante | Relacionamento |
| id_categoria | INT | FK, NOT NULL | Categoria técnica | Classificação |
| nome_isqueiro | VARCHAR(100) | NOT NULL | Nome do modelo | Identificação |
| cor | VARCHAR(50) | NULL | Cor predominante | Identificação visual |
| preco_medio | DECIMAL(10,2) | NULL | Preço médio de mercado | Análise de custo |
| material | VARCHAR(50) | NULL | Material de construção | **NOVO**: Durabilidade |
| tipo_combustivel | VARCHAR(30) | NULL | Tipo de combustível | **NOVO**: Manutenção |

**Decisão**: Campos técnicos para análise de durabilidade e padrões de manutenção

### 8. Compras

**Propósito**: Registro de transações de compra.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_compra | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_usuario | INT | FK, NOT NULL | Comprador | Relacionamento |
| id_estabelecimento | INT | FK, NOT NULL | Local da compra | Contexto comercial |
| data_compra | DATETIME | NOT NULL | Data e hora da transação | **AJUSTE**: Timestamp completo |
| valor_total | DECIMAL(10,2) | NULL | Valor total | Análise financeira |
| metodo_pagamento | VARCHAR(50) | NULL | Forma de pagamento | Preferência comercial |
| nota_fiscal | VARCHAR(100) | NULL | Número da nota fiscal | Rastreamento fiscal |

**Decisão**: Mudança para DATETIME para capturar padrões horários de compra

### 9. Itens_Compra

**Propósito**: Detalhamento dos itens por transação.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_item_compra | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_compra | INT | FK, NOT NULL | Transação relacionada | Relacionamento |
| id_isqueiro | INT | FK, NOT NULL | Modelo comprado | Item da transação |
| quantidade | INT | NOT NULL | Quantidade adquirida | Volume |
| valor_unitario | DECIMAL(10,2) | NULL | Preço unitário | Análise de preço |
| desconto | DECIMAL(10,2) | NULL | Valor de desconto | **NOVO**: Promoções |

**Decisão**: Campo de desconto para análise de sensibilidade a preço

### 10. Isqueiros_Usuario

**Propósito**: Inventário de isqueiros por usuário.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_isqueiro_usuario | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_usuario | INT | FK, NOT NULL | Proprietário | Relacionamento |
| id_isqueiro | INT | FK, NOT NULL | Modelo do isqueiro | Especificação |
| id_item_compra | INT | FK, NOT NULL | Origem da aquisição | Rastreamento |
| data_aquisicao | DATE | NOT NULL | Data de aquisição | Início do ciclo |
| data_fim_uso | DATE | NULL | Data de perda/descarte | **NOVO**: Fim do ciclo |
| status | VARCHAR(20) | NOT NULL | Status atual | Estado atual |
| identificador_unico | VARCHAR(100) | NULL | Identificação personalizada | **NOVO**: Personalização |

**Decisão**: Campos para personalização e rastreamento completo do ciclo de vida

### 11. Locais

**Propósito**: Cadastro de locais de uso e armazenamento.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_local | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_cidade | INT | FK, NOT NULL | Localização geográfica | Contexto regional |
| nome_local | VARCHAR(100) | NOT NULL | Nome do local | Identificação amigável |
| tipo_local | VARCHAR(50) | NULL | Tipo de local | Categorização |
| endereco | VARCHAR(200) | NULL | Endereço completo | **NOVO**: Precisão |
| latitude | DECIMAL(9,6) | NULL | Coordenada geográfica | **AJUSTE**: Precisão |
| longitude | DECIMAL(9,6) | NULL | Coordenada geográfica | **AJUSTE**: Precisão |

**Decisão**: Separação de coordenadas para maior precisão em análises espaciais

### 12. Utilizacao

**Propósito**: Registro de eventos de uso dos isqueiros.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_utilizacao | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_isqueiro_usuario | INT | FK, NOT NULL | Isqueiro utilizado | Relacionamento |
| id_local | INT | FK, NOT NULL | Local de uso | Contexto espacial |
| data_uso | DATETIME | NOT NULL | Data e hora do uso | Timestamp |
| contexto_uso | VARCHAR(100) | NULL | Contexto do uso | **NOVO**: Comportamento |
| duracao_uso | INT | NULL | Duração em segundos | **NOVO**: Intensidade de uso |
| condicao_uso | VARCHAR(50) | NULL | Condições ambientais | **NOVO**: Fatores externos |

**Decisão**: Campos contextuais para análise comportamental avançada

### 13. Historico_Localizacao

**Propósito**: Rastreamento de movimentação e eventos.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_historico_localizacao | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_isqueiro_usuario | INT | FK, NOT NULL | Isqueiro rastreado | Relacionamento |
| id_local | INT | FK, NOT NULL | Local do evento | Contexto espacial |
| data_localizacao | DATETIME | NOT NULL | Data e hora | Timestamp |
| tipo_evento | VARCHAR(20) | NOT NULL | Tipo de evento | Categorização |
| status_confirmado | BIT | DEFAULT 0 | Confirmação do evento | **NOVO**: Validação |
| detalhes | VARCHAR(200) | NULL | Informações adicionais | Contexto |

**Decisão**: Campo de confirmação para melhorar qualidade dos dados de treinamento

### 14. Manutencao

**Propósito**: Registro de atividades de manutenção.

| Coluna | Tipo | Restrições | Descrição | Justificativa |
|--------|------|------------|-----------|---------------|
| id_manutencao | INT | PK, IDENTITY(1,1) | Identificador único | Chave primária |
| id_isqueiro_usuario | INT | FK, NOT NULL | Isqueiro mantido | Relacionamento |
| data_manutencao | DATE | NOT NULL | Data do serviço | Temporal |
| tipo_manutencao | VARCHAR(50) | NOT NULL | Tipo de manutenção | Categorização |
| local_manutencao | VARCHAR(100) | NULL | Local do serviço | **NOVO**: Contexto |
| custo | DECIMAL(10,2) | NULL | Custo da manutenção | Análise de custo |

**Decisão**: Local de manutenção para análise de padrões de cuidado

## 🔍 Aplicações para Machine Learning

### Modelos Suportados

- **Regressão Logística**: Previsão de perda de isqueiros (status + tipo_evento)
- **Regressão Linear**: Previsão de vida útil (data_aquisicao → data_fim_uso)
- **Clustering**: Segmentação de usuários (idade, profissao, padrões de uso)
- **Análise de Sobrevivência**: Durabilidade por material/tipo_combustivel

### Variáveis Relevantes

- **Features**: material, condicao_uso, contexto_uso, coordenadas geográficas
- **Targets**: status de perda, tempo até perda, custo de manutenção
- **Métricas de Engajamento**: data_ultimo_acesso, frequência de uso

### Aprimoramentos para ML

- **status_confirmado**: Melhora qualidade dos dados de treinamento
- **duracao_uso**: Nova feature para modelos de intensidade de uso
- **condicao_uso**: Fator contextual para modelos preditivos
- **identificador_unico**: Permite tracking individualizado para análise longitudinal

## 📊 Estratégia de Análise

### Camadas Analíticas

- **Descritiva**: RFV, padrões geográficos, sazonalidade
- **Preditiva**: Previsão de perdas, vida útil esperada
- **Prescritiva**: Recomendações de compra, alertas de manutenção

### Insights Prioritários

- Correlação entre material e durabilidade
- Padrões geográficos de perda
- Sensibilidade a preço (desconto vs quantidade)
- Fatores ambientais que influenciam perdas

## 📱 Considerações de Usabilidade

### Para o Usuário Final

- **identificador_unico**: Nome personalizado para isqueiros
- **contexto_uso**: Campo simples para descrição de uso
- **condicao_uso**: Seleção em dropdown para facilidade
- **Campos opcionais**: Flexibilidade para diferentes níveis de detalhe

### Para Coleta de Dados

- Geolocalização automática via GPS
- Timestamps automáticos
- Seleções predefinidas para consistência
- Interface intuitiva para minimizar erros
