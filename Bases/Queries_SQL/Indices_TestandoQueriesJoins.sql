USE LighterTrackerDB

/* O nome de cada usuário (u.nome)

O nome do isqueiro que ele possui (i.nome_isqueiro)

O nome do local onde o isqueiro foi usado (l.nome_local)

E o total de vezes que esse isqueiro foi utilizado (COUNT(u2.id_utilizacao))

Usuário tem isqueiros.

Isqueiros são usados em locais.

Cada uso é registrado.

*/

SELECT u.nome, i.nome_isqueiro, l.nome_local, COUNT(u2.id_utilizacao) AS total_usos
FROM Usuarios u
JOIN Isqueiros_Usuario iu ON u.id_usuario = iu.id_usuario
JOIN Isqueiros i ON iu.id_isqueiro = i.id_isqueiro
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Locais l ON u2.id_local = l.id_local
GROUP BY u.nome, i.nome_isqueiro, l.nome_local;


-- Criando os índices 

/* Escrever queries mais rápidas

Treinar joins e filtros com performance

Preparar a base para análises em Python
*/

-- Índices para melhorar desempenho
CREATE INDEX idx_usuarios_id_cidade ON Usuarios(id_cidade);
CREATE INDEX idx_isqueiros_id_marca ON Isqueiros(id_marca);
CREATE INDEX idx_isqueiros_id_categoria ON Isqueiros(id_categoria);
CREATE INDEX idx_compras_id_usuario ON Compras(id_usuario);
CREATE INDEX idx_compras_id_estabelecimento ON Compras(id_estabelecimento);
CREATE INDEX idx_itens_compra_id_compra ON Itens_Compra(id_compra);
CREATE INDEX idx_isqueiros_usuario_id_usuario ON Isqueiros_Usuario(id_usuario);
CREATE INDEX idx_utilizacao_id_isqueiro_usuario ON Utilizacao(id_isqueiro_usuario);
CREATE INDEX idx_utilizacao_data_uso ON Utilizacao(data_uso);
CREATE INDEX idx_historico_localizacao_id_isqueiro_usuario ON Historico_Localizacao(id_isqueiro_usuario);

-- Uma query para extrair dados para a regressão logística (prever perdas) seria:

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

-- Verificar usuários e suas cidades
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