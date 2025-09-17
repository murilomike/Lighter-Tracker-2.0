
import joblib
import pandas as pd
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

def carregar_modelo():
    """Carrega o modelo treinado"""
    try:
        model = joblib.load('lighter_tracker_model.pkl')
        return model
    except Exception as e:
        raise Exception(f"Erro ao carregar modelo: {e}")

def preparar_entrada(dados_usuario):
    """
    Prepara os dados de entrada para predição
    
    Parâmetros esperados no dicionário dados_usuario:
    - genero: 'M' ou 'F'
    - idade: int (18-65)
    - perfil_fumante: 'Pesado', 'Moderado', 'Social', 'Esporadico', 'Nao_fumante'
    - marca_isqueiro: 'Bic', 'Zippo', 'Clipper', 'Cricket', 'Ronson', 'Generico'
    - tipo_isqueiro: 'Descartavel' ou 'Recarregavel'
    - preco_compra: float (0.5-100.0)
    - tempo_posse: int (dias)
    - contexto_uso: 'Casa', 'Rua', 'Trabalho', 'Bar', 'Parque', 'Social', 'Festa', 'Carro'
    - proposito_uso: 'Cigarro', 'Tabaco', 'Vela', 'Incenso', 'Fogao', 'Camping', 'Charuto', 'Outro'
    - num_ascendimentos: int
    - frequencia_uso: float (ascendimentos por dia)
    """
    
    # Criar features derivadas
    intensidade_uso = dados_usuario['num_ascendimentos'] / max(dados_usuario['tempo_posse'], 1)
    
    # Categoria de preço
    if dados_usuario['preco_compra'] <= 5:
        categoria_preco = 'Barato'
    elif dados_usuario['preco_compra'] <= 15:
        categoria_preco = 'Medio'
    else:
        categoria_preco = 'Caro'
    
    # Categoria de idade
    idade = dados_usuario['idade']
    if idade <= 25:
        categoria_idade = 'Jovem'
    elif idade <= 35:
        categoria_idade = 'Adulto_Jovem'
    elif idade <= 50:
        categoria_idade = 'Adulto'
    else:
        categoria_idade = 'Maduro'
    
    # Faixa etária
    if idade <= 25:
        faixa_idade = '18-25'
    elif idade <= 35:
        faixa_idade = '26-35'
    elif idade <= 50:
        faixa_idade = '36-50'
    else:
        faixa_idade = '51+'
    
    # Mês atual
    mes_compra = datetime.now().month
    
    # Criar DataFrame com todas as features necessárias
    features_dict = {
        'idade': dados_usuario['idade'],
        'preco_compra': dados_usuario['preco_compra'],
        'tempo_posse': dados_usuario['tempo_posse'],
        'num_ascendimentos': dados_usuario['num_ascendimentos'],
        'frequencia_uso': dados_usuario['frequencia_uso'],
        'intensidade_uso': intensidade_uso,
        'mes_compra': mes_compra,
        'genero': dados_usuario['genero'],
        'faixa_idade': faixa_idade,
        'perfil_fumante': dados_usuario['perfil_fumante'],
        'marca_isqueiro': dados_usuario['marca_isqueiro'],
        'tipo_isqueiro': dados_usuario['tipo_isqueiro'],
        'contexto_uso': dados_usuario['contexto_uso'],
        'proposito_uso': dados_usuario['proposito_uso'],
        'categoria_preco': categoria_preco,
        'categoria_idade': categoria_idade
    }
    
    return pd.DataFrame([features_dict])

def prever_perda_isqueiro(dados_usuario):
    """
    Função principal para prever perda de isqueiro
    
    Retorna:
    - probabilidade: float (0-1) - Probabilidade de perda
    - categoria_risco: str - Categoria do risco
    - recomendacao: str - Recomendação para o usuário
    """
    
    try:
        # Carregar modelo
        model = carregar_modelo()
        
        # Preparar dados
        df_input = preparar_entrada(dados_usuario)
        
        # Fazer predição
        probabilidade = model.predict_proba(df_input)[0, 1]
        predicao = model.predict(df_input)[0]
        
        # Categorizar risco
        if probabilidade < 0.3:
            categoria_risco = "Baixo"
            emoji_risco = "🟢"
        elif probabilidade < 0.6:
            categoria_risco = "Médio"
            emoji_risco = "🟡"
        else:
            categoria_risco = "Alto"
            emoji_risco = "🔴"
        
        # Gerar recomendações baseadas nos fatores de risco
        recomendacoes = []
        
        if dados_usuario['contexto_uso'] in ['Rua', 'Bar', 'Festa', 'Social']:
            recomendacoes.append("⚠️ Evite levar seu isqueiro para locais públicos se possível")
        
        if dados_usuario['perfil_fumante'] in ['Social', 'Esporadico']:
            recomendacoes.append("💡 Considere manter seu isqueiro sempre no mesmo bolso")
        
        if dados_usuario['tipo_isqueiro'] == 'Descartavel':
            recomendacoes.append("🔄 Isqueiros descartáveis são perdidos mais facilmente - considere um recarregável")
        
        if dados_usuario['frequencia_uso'] > 3.0:
            recomendacoes.append("📱 Alto uso = alto risco. Configure lembretes para verificar seu isqueiro")
        
        if dados_usuario['idade'] <= 25:
            recomendacoes.append("👤 Jovens tendem a perder mais - tenha atenção extra!")
        
        if not recomendacoes:
            recomendacoes.append("✅ Continue com seus hábitos atuais - baixo risco de perda!")
        
        resultado = {
            'probabilidade': round(probabilidade * 100, 2),
            'categoria_risco': categoria_risco,
            'emoji_risco': emoji_risco,
            'predicao_binaria': 'Sim' if predicao else 'Não',
            'recomendacoes': recomendacoes,
            'fatores_risco': {
                'contexto_uso': dados_usuario['contexto_uso'],
                'perfil_fumante': dados_usuario['perfil_fumante'],
                'tipo_isqueiro': dados_usuario['tipo_isqueiro'],
                'frequencia_uso': dados_usuario['frequencia_uso'],
                'idade': dados_usuario['idade']
            }
        }
        
        return resultado
        
    except Exception as e:
        return {
            'erro': f"Erro na predição: {str(e)}",
            'probabilidade': None,
            'categoria_risco': None,
            'recomendacao': "Erro no processamento"
        }

# EXEMPLO DE USO:
if __name__ == "__main__":
    # Exemplo 1: Alto risco
    exemplo_alto_risco = {
        'genero': 'M',
        'idade': 22,
        'perfil_fumante': 'Social',
        'marca_isqueiro': 'Bic',
        'tipo_isqueiro': 'Descartavel',
        'preco_compra': 2.50,
        'tempo_posse': 15,
        'contexto_uso': 'Bar',
        'proposito_uso': 'Cigarro',
        'num_ascendimentos': 50,
        'frequencia_uso': 3.33
    }
    
    # Exemplo 2: Baixo risco
    exemplo_baixo_risco = {
        'genero': 'F',
        'idade': 45,
        'perfil_fumante': 'Nao_fumante',
        'marca_isqueiro': 'Zippo',
        'tipo_isqueiro': 'Recarregavel',
        'preco_compra': 55.00,
        'tempo_posse': 90,
        'contexto_uso': 'Casa',
        'proposito_uso': 'Vela',
        'num_ascendimentos': 25,
        'frequencia_uso': 0.28
    }
    
    print("=== TESTE DO MODELO ===")
    print("\n🔴 EXEMPLO ALTO RISCO:")
    resultado1 = prever_perda_isqueiro(exemplo_alto_risco)
    print(f"Probabilidade: {resultado1['probabilidade']:.1f}%")
    print(f"Categoria: {resultado1['emoji_risco']} {resultado1['categoria_risco']}")
    print("Recomendações:")
    for rec in resultado1['recomendacoes']:
        print(f"  {rec}")
    
    print("\n🟢 EXEMPLO BAIXO RISCO:")
    resultado2 = prever_perda_isqueiro(exemplo_baixo_risco)
    print(f"Probabilidade: {resultado2['probabilidade']:.1f}%")
    print(f"Categoria: {resultado2['emoji_risco']} {resultado2['categoria_risco']}")
    print("Recomendações:")
    for rec in resultado2['recomendacoes']:
        print(f"  {rec}")
