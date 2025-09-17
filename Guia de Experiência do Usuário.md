# Guia de Experiência do Usuário - Lighter Tracker 2.0

## 📱 Como Sua Experiência Seria Capturada no Sistema

Este documento demonstra como as interações reais de um usuário são mapeadas para o banco de dados do Lighter Tracker 2.0, mostrando como cada ação se traduz em dados estruturados para análise e predição de perdas.

---

## 👤 Perfil do Usuário Exemplo

**Cenário**: Usuário que possui experiência com isqueiros Bic (laranja, rosa, amarelo, preto), com diferentes padrões de uso e situações de perda.

**Características**:
- Ex-fumante que usa isqueiros para tabaco e incenso
- Já perdeu isqueiros em contextos sociais
- Tem padrões específicos de uso para diferentes cores/isqueiros

---

## 🔄 Jornada Completa do Usuário

### 1. Cadastro Inicial
**Tabela Relacionada**: `Usuarios`

**Experiência do Usuário:**
- Primeiro acesso ao aplicativo
- Criação de conta com informações básicas
- Permissão de geolocalização para sugestões automáticas

**Dados Coletados:**
- **Nome**: Identificação pessoal
- **E-mail**: Comunicação e login
- **Cidade**: Detectada via GPS ou selecionada manualmente
- **Idade**: 30 anos (opcional)
- **Profissão**: Designer (opcional)

**Facilidades do App:**
- Geolocalização automática sugere cidade
- `data_cadastro` preenchida automaticamente
- Campos opcionais não obrigatórios

---

### 2. Registro de Isqueiros no Inventário
**Tabelas Relacionadas**: `Isqueiros`, `Compras`, `Itens_Compra`, `Isqueiros_Usuario`

**Experiência do Usuário:**
O usuário registra seus isqueiros existentes e novos:

#### Isqueiro Laranja
- **Modelo**: Bic Mini
- **Cor**: Laranja
- **Status**: Usado ~50 vezes, depois dado a um amigo
- **Local de compra**: Distribuidora
- **Nome personalizado**: "Bic Laranja"

#### Isqueiro Rosa
- **Modelo**: Bic Mini
- **Cor**: Rosa
- **Status**: Ativo, usado para incenso e tabaco
- **Nome personalizado**: "Bic Rosa"

#### Isqueiro Amarelo
- **Modelo**: Bic Mini
- **Cor**: Amarela
- **Status**: Ativo, usado principalmente para tabaco
- **Nome personalizado**: "Bic Amarelo"

#### Isqueiro Preto
- **Modelo**: Bic Mini
- **Cor**: Preta
- **Status**: Comprado recentemente, usado uma vez, dado a um amigo
- **Nome personalizado**: "Bic Preto"

**Dados Capturados:**
- **Marcas e Categorias**: Bic classificado como "Mini" (pré-cadastrado)
- **Características**: Material plástico, combustível a gás, preço médio R$ 2,50
- **Compras**: Registradas com estabelecimento, data, valor e método de pagamento
- **Inventário pessoal**: Cada isqueiro vinculado ao usuário com identificação única

**Interface Intuitiva:**
- Dropdown para modelos conhecidos
- Campo personalizável para nome único
- Busca de estabelecimentos por localização
- Data de compra ajustável (padrão: hoje)

---

### 3. Registro de Usos Cotidianos
**Tabelas Relacionadas**: `Utilizacao`, `Locais`

**Experiência do Usuário:**

#### Uso do Amarelo (Hoje à tarde)
- **Ação**: Acender tabaco 2 vezes com intervalo de 30 minutos
- **Local**: Casa
- **Contexto**: Tabaco
- **Condição**: Normal
- **Duração**: ~5 segundos por uso

#### Uso do Rosa (Hoje à noite)
- **Ação**: Acender incenso
- **Local**: Casa
- **Contexto**: Incenso
- **Duração**: ~10 segundos

#### Histórico do Laranja
- **Padrão**: Usado ~50 vezes em diversas situações
- **Exemplo**: Piquenique no parque
- **Resultado**: Dado a um amigo após uso extensivo

**Dados Estruturados:**
- **Locais**: Casa e Parque com coordenadas GPS
- **Timestamps**: Data e hora automáticas para cada uso
- **Contexto**: Categorização clara (Tabaco, Incenso, Piquenique)
- **Condições**: Ambientais como "Sol" ou "Normal"
- **Duração**: Medida em segundos para análise de intensidade

**Facilidades de Registro:**
- Seleção rápida do isqueiro pelo nome personalizado
- Sugestão de locais frequentes via GPS
- Dropdowns para contextos comuns
- Valores padrão para duração e condições

---

### 4. Registro de Perdas
**Tabelas Relacionadas**: `Historico_Localizacao`, `Isqueiros_Usuario`

**Experiência do Usuário:**

#### Perda do Laranja
- **Situação**: Dado a um amigo durante piquenique
- **Local**: Parque
- **Motivo**: "Dado ao amigo no piquenique"
- **Status**: Perda confirmada pelo usuário

#### Perda do Preto
- **Situação**: Usado uma vez e dado a outro amigo
- **Local**: Casa/Cidade
- **Motivo**: "Dado ao amigo na cidade"
- **Status**: Perda confirmada

**Dados Capturados:**
- **Tipo de evento**: "Perdido" com detalhes específicos
- **Confirmação**: Flag de validação para qualidade dos dados
- **Timeline**: Data exata da perda para cálculo de vida útil
- **Atualização de status**: Mudança de "Ativo" para "Perdido"

**Interface de Perda:**
- Seleção fácil do isqueiro perdido
- Sugestão de locais recentes de uso
- Campo livre para detalhes da circunstância
- Checkbox de confirmação para validação

---

### 5. Contextos Sociais
**Cenário**: Amiga que usa isqueiros diferentes a cada visita, irmã que também usa

**Experiência Social:**
- **Amiga**: Padrão de trocar de isqueiro frequentemente
- **Irmã**: Uso eventual em contexto familiar
- **Você**: Observa padrões de uso em grupo

**Captura de Dados Sociais:**
- **Ambiente**: Campo adicional para "Com amigos" vs "Sozinho"
- **Contexto social**: Usos em casa com outras pessoas
- **Padrões comportamentais**: Identificação de "usuários descuidados"

**Análise para ML:**
- Correlação entre contexto social e perda de isqueiros
- Padrões de uso em grupo vs individual
- Clustering de usuários por comportamento social

---

## 🎯 Insights Específicos para Predição

### Padrões Identificados

#### Alta Probabilidade de Perda
- **Contextos sociais**: Piqueniques, saídas com amigos
- **Isqueiros novos**: Uso único seguido de perda
- **Locais públicos**: Parques, bares, eventos

#### Baixa Probabilidade de Perda
- **Uso doméstico**: Casa, ambiente controlado
- **Contextos específicos**: Incenso, rituais pessoais
- **Usuários experientes**: Padrões estabelecidos de cuidado

#### Fatores de Risco
- **Frequência de troca**: Usuários que mudam de isqueiro frequentemente
- **Contexto social**: Presença de outras pessoas
- **Localização**: Ambientes públicos ou não familiares

---

## 🔍 Comparação: Bic vs Zippo

### Características Capturadas no Sistema

#### Isqueiros Bic
- **Material**: Plástico
- **Combustível**: Gás butano
- **Vida útil**: 1.000-3.000 acendimentos
- **Preço**: R$ 2-5
- **Disponibilidade**: Mercados, padarias, distribuidoras
- **Manutenção**: Descartável (sem registros em `Manutencao`)

#### Isqueiros Zippo
- **Material**: Metal
- **Combustível**: Fluido específico
- **Vida útil**: Décadas (com manutenção)
- **Preço**: R$ 50-500
- **Disponibilidade**: Lojas especializadas, online
- **Manutenção**: Recarga a cada ~150 acendimentos
- **Personalização**: Gravuras, designs únicos

### Análise de Durabilidade

#### Vida Útil do Objeto
- **Zippo**: Superior devido ao material robusto e possibilidade de reparo
- **Bic**: Limitada, descartável após esgotamento

#### Uso Contínuo sem Recarga
- **Bic**: Mais acendimentos por "carga" (até 2.000)
- **Zippo**: Menor autonomia (~150 acendimentos por recarga)

#### Perfil de Usuário
- **Bic**: Conveniência, baixo custo, uso casual
- **Zippo**: Colecionadores, uso simbólico, investimento

---

## 📊 Alimentação do Modelo de Machine Learning

### Features Extraídas da Experiência

#### Comportamentais
- **Frequência de uso**: Contagem de usos por dia/semana
- **Padrão temporal**: Horários preferidos de uso
- **Contexto predominante**: Tabaco vs Incenso vs Social

#### Ambientais
- **Tipo de local**: Casa vs Público vs Trabalho
- **Condições**: Normal vs Adversas (chuva, vento)
- **Contexto social**: Sozinho vs Com outras pessoas

#### Características do Isqueiro
- **Material**: Plástico vs Metal
- **Tipo de combustível**: Gás vs Fluido
- **Cor**: Possível influência psicológica
- **Idade**: Tempo desde a aquisição

#### Perfil do Usuário
- **Demografia**: Idade, profissão
- **Histórico**: Perdas anteriores
- **Comportamento de compra**: Frequência, local, valor

### Target para Predição
- **Status de perda**: Binário (perdido/não perdido)
- **Tempo até perda**: Regressão para vida útil esperada
- **Probabilidade de perda**: Score contínuo por contexto

### Padrões da Experiência Específica

#### Isqueiro Laranja
- **Padrão**: Alto uso (50x) → Perda em contexto social
- **Insight**: Uso intensivo + ambiente público = risco elevado

#### Isqueiro Preto
- **Padrão**: Baixo uso (1x) → Perda rápida em contexto social
- **Insight**: Isqueiros novos em situações sociais têm risco imediato

#### Isqueiros Rosa/Amarelo
- **Padrão**: Uso doméstico variado → Mantidos ativos
- **Insight**: Contextos controlados preservam isqueiros

#### Padrão da Amiga
- **Comportamento**: Troca frequente de isqueiros
- **Classificação**: "Usuário descuidado" via clustering
- **Predição**: Alta probabilidade de perdas futuras

---

## 🎯 Aplicações Práticas

### Para o Usuário
- **Alertas preventivos**: "Cuidado ao levar isqueiros para locais públicos"
- **Recomendações**: "Baseado no seu padrão, considere um Zippo para uso social"
- **Insights pessoais**: "Você mantém isqueiros por mais tempo quando usa em casa"

### Para Análise de Mercado
- **Segmentação**: Usuários casuais vs colecionadores
- **Preferências**: Bic para conveniência, Zippo para durabilidade
- **Canais de venda**: Distribuidoras para Bic, lojas especializadas para Zippo

### Para Desenvolvimento do Produto
- **Features prioritárias**: Alertas de localização, backup de dados
- **Gamificação**: Conquistas por manter isqueiros por longos períodos
- **Social**: Compartilhamento de estatísticas com amigos

---

## ✅ Validação da Experiência

### Realismo do Sistema
- ✅ **Captura natural**: Fluxos intuitivos que refletem uso real
- ✅ **Dados acionáveis**: Informações úteis para predição e insights
- ✅ **Flexibilidade**: Acomoda diferentes níveis de detalhamento
- ✅ **Automação inteligente**: Reduz esforço do usuário mantendo qualidade

### Qualidade dos Dados
- ✅ **Consistência**: Dropdowns e validações garantem padronização
- ✅ **Completude**: Campos opcionais permitem registro básico ou detalhado
- ✅ **Veracidade**: Confirmações pelo usuário melhoram confiabilidade
- ✅ **Relevância**: Todos os dados coletados têm propósito analítico

### Experiência do Usuário
- ✅ **Simplicidade**: Registro rápido para ações cotidianas
- ✅ **Utilidade**: Insights valiosos em troca dos dados fornecidos
- ✅ **Personalização**: Nomes únicos e contextos específicos
- ✅ **Gamificação**: Potencial para elementos motivacionais

---

*Este documento demonstra como uma experiência real de usuário se traduz perfeitamente na estrutura de dados proposta, validando tanto a arquitetura do banco quanto a viabilidade do produto para seus objetivos de machine learning e análise comportamental.*