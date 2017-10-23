CREATE USER "dbuser" WITH PASSWORD 'dbuser';
CREATE USER "dbadmin" WITH PASSWORD 'dbadmin';
CREATE DATABASE sample WITH OWNER = "dbadmin" ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1;
GRANT ALL PRIVILEGES ON DATABASE sample to "dbuser";
GRANT ALL PRIVILEGES ON DATABASE sample to "dbadmin";

CONNECT sample;

CREATE TABLE "user"
(
  id        SERIAL PRIMARY KEY,
  user_name CHARACTER VARYING NOT NULL,
  password  CHARACTER VARYING NOT NULL,
  CONSTRAINT user_username_key UNIQUE (user_name)
);

CREATE TABLE user_role
(
  id         SERIAL PRIMARY KEY,
  user_id    INT4 NOT NULL,
  role_name  CHARACTER VARYING NOT NULL,
  CONSTRAINT role_role_user_key UNIQUE (user_id, role_name),
  FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE subject_permission
(
  id              SERIAL PRIMARY KEY,
  subject_name    CHARACTER VARYING NOT NULL,
  permission_name CHARACTER VARYING NOT NULL,
  CONSTRAINT permission_permission_role_key UNIQUE (subject_name, permission_name)
);

INSERT INTO "user" (user_name, password) VALUES
  ('admin', 'password'),
  ('brian', 'password'),
  ('daenerys', 'password'),
  ('negan', 'password'),
  ('maggie', 'password'),
  ('jamie', 'password'),
  ('guest', 'password');

INSERT INTO user_role (user_id, role_name) VALUES
  ((SELECT id FROM "user" WHERE user_name = 'admin'), 'admin'),
  ((SELECT id FROM "user" WHERE user_name = 'guest'), 'guest'),
  ((SELECT id FROM "user" WHERE user_name = 'brian'), 'lannister'),
  ((SELECT id FROM "user" WHERE user_name = 'brian'), 'targaryen'),
  ((SELECT id FROM "user" WHERE user_name = 'brian'), 'savior'),
  ((SELECT id FROM "user" WHERE user_name = 'brian'), 'alexandrian'),
  ((SELECT id FROM "user" WHERE user_name = 'negan'), 'savior'),
  ((SELECT id FROM "user" WHERE user_name = 'maggie'), 'alexandrian'),
  ((SELECT id FROM "user" WHERE user_name = 'daenerys'), 'targaryen'),
  ((SELECT id FROM "user" WHERE user_name = 'jamie'), 'lannister');

INSERT INTO subject_permission (subject_name, permission_name) VALUES
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'admin'), 'town:*:*'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'lannister'), 'town:visit:kings_landing'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'targaryen'), 'town:visit:dragonstone'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'savior'), 'town:visit:bunker'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'alexandrian'), 'town:visit:alexandria'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'alexandrian'), 'town:visit:hilltop'),
  ((SELECT DISTINCT role_name FROM user_role WHERE role_name = 'alexandrian'), 'town:visit:kingdom');

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public to "dbuser";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public to "dbadmin";



