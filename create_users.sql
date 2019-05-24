\c military_db

DROP USER IF EXISTS reader;
DROP USER IF EXISTS writer;
DROP GROUP IF EXISTS readers;
DROP GROUP IF EXISTS writers;

\! sudo deluser reader
\! sudo deluser writer

\! sudo useradd -M reader
\! sudo useradd -M writer

CREATE GROUP readers;
CREATE GROUP writers;
CREATE USER reader WITH PASSWORD 'password';
CREATE USER writer WITH PASSWORD 'password';
ALTER GROUP readers ADD USER reader;
ALTER GROUP writers ADD USER writer;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO GROUP readers;
GRANT ALL ON ALL TABLES IN SCHEMA public TO GROUP writers;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO GROUP writers;
