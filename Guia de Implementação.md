# Lighter Tracker 2.0 - Guia de Implementação

## 📱 Como os Usuários Inserem Dados no Aplicativo

O Lighter Tracker 2.0 utiliza uma interface intuitiva que permite aos usuários registrarem informações de forma natural, enquanto o banco de dados organiza automaticamente os dados nas tabelas correspondentes.

## 🔄 Fluxo de Interação do Usuário

### 1. Cadastro do Usuário
**Tabela Relacionada**: `Usuarios`

**O que o usuário faz:**
- Cria conta fornecendo informações básicas
- Seleciona cidade ou permite detecção por geolocalização
- Preenche dados opcionais para personalização

**Campos Preenchidos:**
- `nome`, `email`, `id_cidade` (obrigatórios)
- `data_cadastro` (automático - data atual)
- `idade`, `profissao` (opcionais via formulário)
- `data_ultimo_acesso` (atualizado a cada login)

**Interface Sugerida:**
- Campos de texto para nome e e-mail
- Dropdown para cidade baseado em geolocalização
- Campos opcionais para idade e profissão
- Sugestão automática de cidade via GPS

---

### 2. Registro de Isqueiro
**Tabelas Relacionadas**: `Isqueiros`, `Compras`, `Itens_Compra`, `Isqueiros_Usuario`

**O que o usuário faz:**
- Adiciona novo isqueiro ao inventário pessoal
- Seleciona modelo de lista pré-cadastrada
- Informa local e detalhes da compra
- Personaliza com nome único

**Dados Coletados:**
- **Modelo**: Selecionado da tabela `Isqueiros`
- **Cor**: Lista predefinida ou texto livre
- **Local de compra**: Dropdown de `Estabelecimentos` ou novo cadastro
- **Data da compra**: Data atual (ajustável)
- **Valor e quantidade**: Campos opcionais
- **Nome personalizado**: Ex: "Meu Bic Azul"

**Campos Preenchidos:**
- `Compras`: `id_usuario` (automático), `id_estabelecimento`, `data_compra`, `valor_total`, `metodo_pagamento`
- `Itens_Compra`: `id_compra`, `id_isqueiro`, `quantidade`, `valor_unitario`, `desconto`
- `Isqueiros_Usuario`: `id_usuario`, `id_isqueiro`, `status` ("Ativo"), `identificador_unico`

**Interface Sugerida:**
- Dropdown para modelo (ex: "Bic Mini")
- Campo de cor com sugestões
- Busca de estabelecimentos por geolocalização
- Campos numéricos para valor e quantidade
- Campo de texto para nome personalizado

---

### 3. Registro de Uso
**Tabelas Relacionadas**: `Utilizacao`, `Locais`

**O que o usuário faz:**
- Registra cada utilização do isqueiro
- Seleciona isqueiro do inventário pessoal
- Informa contexto e condições de uso
- Permite captura automática de localização

**Dados Coletados:**
- **Isqueiro usado**: Seleção de `Isqueiros_Usuario`
- **Local**: Seleção de `Locais` ou novo cadastro
- **Contexto**: Ex: "Acender cigarro" (lista ou texto livre)
- **Condição ambiental**: Ex: "Chuva" (dropdown opcional)
- **Duração**: Estimativa ou padrão (opcional)

**Campos Preenchidos:**
- `Utilizacao`: `id_isqueiro_usuario`, `id_local`, `data_uso` (automático), `contexto_uso`, `duracao_uso`, `condicao_uso`
- `Locais` (se novo): `id_cidade` (GPS), `nome_local`, `tipo_local`, `latitude`, `longitude`

**Interface Sugerida:**
- Dropdown para seleção de isqueiro
- Busca de locais com sugestão GPS
- Dropdown para contextos frequentes
- Campos opcionais para condição e duração
- Captura automática de coordenadas

---

### 4. Registro de Perda
**Tabelas Relacionadas**: `Historico_Localizacao`, `Isqueiros_Usuario`

**O que o usuário faz:**
- Marca isqueiro como perdido
- Informa local e circunstâncias da perda
- Confirma a veracidade da informação
- Adiciona detalhes opcionais

**Dados Coletados:**
- **Isqueiro perdido**: Seleção de `Isqueiros_Usuario`
- **Local da perda**: Seleção de `Locais` ou novo
- **Detalhes**: Ex: "Esqueci no bar" (opcional)
- **Confirmação**: Checkbox para validação

**Campos Preenchidos:**
- `Historico_Localizacao`: `id_isqueiro_usuario`, `id_local`, `data_localizacao` (automático), `tipo_evento` ("Perdido"), `detalhes`, `status_confirmado`
- `Isqueiros_Usuario`: Atualiza `status` para "Perdido" e `data_fim_uso`

**Interface Sugerida:**
- Dropdown para isqueiro ativo
- Busca de locais recentes
- Campo de texto para detalhes
- Checkbox "Perda confirmada"
- Sugestão de locais de uso recente

---

### 5. Registro de Manutenção
**Tabela Relacionada**: `Manutencao`

**O que o usuário faz:**
- Registra recargas ou reparos
- Seleciona tipo de manutenção
- Informa custos e local (opcional)
- Mantém histórico de cuidados

**Dados Coletados:**
- **Isqueiro**: Seleção de `Isqueiros_Usuario`
- **Tipo**: Ex: "Recarga de gás" (dropdown)
- **Local**: Texto livre (opcional)
- **Custo**: Campo numérico (opcional)

**Campos Preenchidos:**
- `Manutencao`: `id_isqueiro_usuario`, `data_manutencao`, `tipo_manutencao`, `custo`, `local_manutencao`

**Interface Sugerida:**
- Dropdown para seleção de isqueiro
- Lista predefinida de tipos de manutenção
- Campos opcionais para custo e local
- Histórico de manutenções anteriores

---

## 🎯 Facilitadores de Entrada de Dados

### Automação Inteligente
- **Geolocalização**: GPS automático para `latitude`, `longitude` e sugestão de `id_cidade`
- **Timestamps**: Preenchimento automático de datas e horários
- **Campos Opcionais**: Redução de sobrecarga com campos não obrigatórios
- **Sugestões Contextuais**: Locais recentes e isqueiros mais usados

### Padronização
- **Dropdowns**: Listas predefinidas para `nome_marca`, `tipo_local`, `contexto_uso`
- **Validação**: Prevenção de erros com seleções controladas
- **Consistência**: Dados padronizados facilitam análises posteriores

### Experiência do Usuário
- **Interface Intuitiva**: Fluxos simples e diretos
- **Feedback Visual**: Confirmações e sugestões em tempo real
- **Flexibilidade**: Adaptação a diferentes níveis de engajamento

---

## 📊 Exemplo de Fluxo Completo no App

### Cenário: Novo Usuário
1. **Login** → `data_ultimo_acesso` atualizado automaticamente
2. **Adiciona isqueiro** → "Bic Mini, Azul, Supermercado X, R$2,50"
   - Insere em: `Compras`, `Itens_Compra`, `Isqueiros_Usuario`
3. **Registra uso** → "Acendi cigarro em casa às 18:00"
   - Insere em: `Utilizacao` (e `Locais` se necessário)
4. **Reporta perda** → "Perdi no bar, esqueci na mesa"
   - Insere em: `Historico_Localizacao`
   - Atualiza: `Isqueiros_Usuario` (status → "Perdido")

---

## 🗄️ Organização das Tabelas para Captura Exata

### Validação da Estrutura
As tabelas propostas seguem **boas práticas de sistemas reais**:

#### ✅ Pontos Fortes
- **Normalização (3NF)**: Evita redundâncias e facilita joins complexos
- **Flexibilidade**: Campos opcionais atendem diferentes perfis de usuário
- **Suporte a ML**: Features ricas para modelos preditivos
- **Escalabilidade**: Estrutura suporta milhões de registros

#### 🔄 Comparação com Sistemas Reais
**Similaridades com apps estabelecidos:**
- **Strava**: Estrutura similar para usuários, atividades, locais e equipamentos
- **YNAB**: Organização parecida para transações e categorização
- **Tile**: Foco em rastreamento de objetos e predição de perdas

### Requisitos para Previsão de Perdas

#### Features de Uso
- **Frequência**: Calculada via `COUNT` em `Utilizacao`
- **Localização**: `id_local`, `tipo_local`, coordenadas geográficas
- **Contexto**: `contexto_uso`, `condicao_uso`

#### Features de Perda
- **Histórico**: `Historico_Localizacao` com `tipo_evento = 'Perdido'`
- **Status**: Campo `status` em `Isqueiros_Usuario`

#### Features do Usuário
- **Demografia**: `idade`, `profissao`, `id_cidade`
- **Comportamento**: Padrões em `Compras` e `Itens_Compra`

#### Features do Isqueiro
- **Características**: `material`, `tipo_combustivel`, `cor`

---

## 🎯 Garantindo Qualidade dos Dados

### Estratégias de Validação
- **Dados Padronizados**: Uso de dropdowns e listas controladas
- **Automação**: GPS e timestamps automáticos
- **Confirmação**: Campo `status_confirmado` para validação
- **Volume**: Estratégia para obter dados suficientes para ML

### Considerações de Implementação
- **Usabilidade**: Interface não deve desencorajar o uso
- **Precisão**: Balanceamento entre automação e controle manual
- **Engajamento**: Incentivos para uso contínuo e registro detalhado

---

## 🚀 Próximos Passos

1. **Prototipagem**: Desenvolvimento de mockups da interface
2. **Dados Sintéticos**: Geração de dataset para testes iniciais
3. **MVP**: Implementação das funcionalidades core
4. **Testes**: Validação com usuários reais
5. **ML Pipeline**: Desenvolvimento dos modelos preditivos

---

**Nota**: Este documento serve como guia de implementação. A estrutura das tabelas e fluxos podem ser ajustados conforme feedback dos usuários e requisitos técnicos específicos.