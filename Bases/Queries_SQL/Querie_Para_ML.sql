USE LighterTrackerDB
GO

-- Testes de Queries para verificar as colunas

SELECT * FROM Usuarios;
SELECT * FROM MARCAS;
SELECT * FROM Categorias;

-- Query para ML target 'PERDEU

SELECT iu.id_isqueiro_usuario, u.idade, u.profissao, i.material, i.tipo_combustivel,
       COUNT(u2.id_utilizacao) AS total_usos, l.tipo_local, l.latitude, l.longitude,
       CASE WHEN hl.tipo_evento = 'Perdido' THEN 1 ELSE 0 END AS perdeu
FROM Isqueiros_Usuario iu
JOIN Usuarios u ON iu.id_usuario = u.id_usuario
JOIN Isqueiros i ON iu.id_isqueiro = i.id_isqueiro
LEFT JOIN Utilizacao u2 ON iu.id_isqueiro_usuario = u2.id_isqueiro_usuario
LEFT JOIN Locais l ON u2.id_local = l.id_local
LEFT JOIN Historico_Localizacao hl ON iu.id_isqueiro_usuario = hl.id_isqueiro_usuario
GROUP BY iu.id_isqueiro_usuario, u.idade, u.profissao, i.material, i.tipo_combustivel, l.tipo_local, l.latitude, l.longitude, hl.tipo_evento;


