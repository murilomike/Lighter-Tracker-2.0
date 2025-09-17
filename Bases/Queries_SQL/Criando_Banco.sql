CREATE DATABASE LighterTrackerDB;

-- Recovery Model
ALTER DATABASE LighterTrackDB SET RECOVERY FULL;

-- roles para controle de acesso
USE LighterTrackDB;
CREATE ROLE db_lightertrack_read;
CREATE ROLE db_lightertrack_write;
-- usuários para a aplicação e analistas
CREATE LOGIN lightertrack_analyst WITH PASSWORD = '123456';
CREATE LOGIN lightertrack_app WITH PASSWORD = '123456';
CREATE USER lightertrack_analyst FOR LOGIN lightertrack_analyst;
CREATE USER lightertrack_app FOR LOGIN lightertrack_app;
-- permissões mínimas
GRANT SELECT TO db_lightertrack_read;
GRANT SELECT, INSERT, UPDATE, DELETE TO db_lightertrack_write;
ALTER ROLE db_lightertrack_read ADD MEMBER lightertrack_analyst;
ALTER ROLE db_lightertrack_write ADD MEMBER lightertrack_app;


