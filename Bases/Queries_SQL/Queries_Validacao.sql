USE LighterTrackerDB
GO

-- Uma query para extrair dados para a regress�o log�stica (prever perdas) seria:

SELECT iu.id_isqueiro_usuario, u.idade, u.profissao, i.material, i.tipo_combustivel,
       COUNT(u2.id_utilizacao) AS total_usos, 
       AVG(DATEDIFF(HOUR, u2.data_uso, GETDATE())) AS media_tempo_uso,
       l.tipo_local, hl.tipo_evento AS perdeu
FROM Isqueiros_Usuario iu
JOIN Usuarios u ON iu.id_usuario = u.id_usuario
JOIN Isqueiros i ON iu.id_isqueiro = i.id_isqueiro
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Locais l ON u2.id_local = l.id_local
LEFT JOIN Historico_Localizacao hl ON iu.id_isqueiro_usuario = hl.id_isqueiro_usuario
GROUP BY iu.id_isqueiro_usuario, u.idade, u.profissao, i.material, i.tipo_combustivel, l.tipo_local, hl.tipo_evento;


-- Verificar usu�rios e suas cidades
SELECT u.nome, c.nome_cidade, e.nome_estado
FROM Usuarios u
JOIN Cidades c ON u.id_cidade = c.id_cidade
JOIN Estados e ON c.id_estado = e.id_estado;



-- Verificar usos por isqueiro
SELECT iu.id_isqueiro_usuario, i.nome_isqueiro, COUNT(u2.id_utilizacao) as total_usos
FROM Isqueiros_Usuario iu
JOIN Isqueiros i ON iu.id_isqueiro = i.id_isqueiro
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
GROUP BY iu.id_isqueiro_usuario, i.nome_isqueiro;

-- Dados para Machine Learning

/*A estrutura suporta os tr�s modelos de Machine Learning mencionados:Regress�o Log�stica (Classifica��o - Perda):Target: Campo tipo_evento da tabela Historico_Localizacao (1 para "Perdido", 0 para outros) ou status da tabela Isqueiros_Usuario.
Features:Categ�ricas: nome_marca, nome_categoria, cor, nome_local, tipo_local, contexto_uso.
Num�ricas: frequencia_dia, n�mero total de usos (via COUNT em Utilizacao), tempo desde compra (data_uso - data_aquisicao), valor_total.
Temporais: data_uso, data_localizacao. */

 SELECT iu.id_isqueiro_usuario, u.nome, i.nome_isqueiro, i.cor, m.nome_marca,
       COUNT(u2.id_utilizacao) as total_usos,
       CASE WHEN hl.tipo_evento = 'Perdido' THEN 1 ELSE 0 END as perdeu
FROM Isqueiros_Usuario iu
JOIN Usu�rios u ON iu.id_usuario = u.id_usuario
JOIN Isqueiros i ON iu.id_isqueiro = i.id_isqueiro
JOIN Marcas m ON i.id_marca = m.id_marca
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Historico_Localizacao hl ON iu.id_isqueiro_usuario = hl.id_isqueiro_usuario
GROUP BY iu.id_isqueiro_usuario, u.nome, i.nome_isqueiro, i.cor, m.nome_marca, hl.tipo_evento;


 /* 
 Regress�o Linear (Tempo de Reposi��o):Target: Tempo at� a perda (calculado como data_localizacao - data_aquisicao para eventos de perda) ou frequ�ncia de uso (frequencia_dia).
Features: Mesmas features da regress�o log�stica, com foco em vari�veis num�ricas (ex.: valor_unitario, total_usos).
 */

 SELECT iu.id_isqueiro_usuario, DATEDIFF(DAY, iu.data_aquisicao, hl.data_localizacao) as tempo_ate_perda,
       COUNT(u2.id_utilizacao) as total_usos, AVG(u2.frequencia_dia) as media_frequencia
FROM Isqueiros_Usuario iu
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Historico_Localizacao hl ON iu.id_isqueiro_usuario = hl.id_isqueiro_usuario
WHERE hl.tipo_evento = 'Perdido'
GROUP BY iu.id_isqueiro_usuario, iu.data_aquisicao, hl.data_localizacao;


/* 
Clustering (Segmenta��o de Usu�rios):Objetivo: Agrupar usu�rios em categorias como "frequentes", "avulsos", "noturnos", etc.
Features:Frequ�ncia de uso (m�dia de frequencia_dia ou COUNT de Utilizacao).
Taxa de perda (COUNT de tipo_evento = 'Perdido' por usu�rio).
Hor�rio de uso (extra�do de data_uso para identificar "noturno" vs. "diurno").
Frequ�ncia de compras (COUNT de Compras por usu�rio).
*/

SELECT u.id_usuario, u.nome,
       COUNT(DISTINCT c.id_compra) as total_compras,
       COUNT(DISTINCT u2.id_utilizacao) as total_usos,
       AVG(u2.frequencia_dia) as media_frequencia,
       COUNT(DISTINCT hl.id_historico_localizacao) as total_perdas,
       SUM(CASE WHEN HOUR(u2.data_uso) >= 18 THEN 1 ELSE 0 END) as usos_noturnos
FROM Usu�rios u
LEFT JOIN Compras c ON u.id_usuario = c.id_usuario
LEFT JOIN Isqueiros_Usuario iu ON u.id_usuario = iu.id_usuario
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Historico_Localizacao hl ON iu.id_isqueiro_usuario = hl.id_isqueiro_usuario
GROUP BY u.id_usuario, u.nome;


