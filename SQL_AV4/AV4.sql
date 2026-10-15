--              ~~~~~~~~~~~~~~  SQL ~~~~~~~~~~~~~~

-- ALTER TABLE


-- CREATE INDEX


-- INSERT INTO
INSERT INTO Usuario
VALUES (77788833355,'usuario_teste@foo.com');

-- UPDATE
UPDATE Leitor
SET data_do_proximo_pagamento = TO_DATE('2026-05-18','YYYY-MM-DD')
WHERE cpf = 11122233345;

-- DELETE
DELETE FROM Topico
WHERE numero = 1;

-- SELECT-FROM-WHERE
-- pegar uma lista de formacoes do Pesquisador de cpf 11122233323
SELECT formacao
FROM Formacao
WHERE cpf = 11122233323;

-- IN
/* obter o cpf do usuario que recebeu a  notificacao, e o codigo do periodico que gerou a notificacao,
de todas as notificacoes que estao na situacao de enviada ou recebida, ou seja, nao foram lidas*/
SELECT cpf, codigo_periodico
FROM Notificar
WHERE situacao IN ('enviada','recebida');

--LIKE
-- pegar todos os artigos escritos em 2026
SELECT titulo
FROM Artigo
WHERE TO_CHAR(data_de_escrita, 'YYYY-MM-DD') LIKE '2026%';

-- IS NULL ou IS NOT NULL
-- achar todos os Pesquisadores que nao tem o segundo nome registrado
SELECT cpf
FROM Pesquisador
WHERE segundo_nome IS NULL;

-- INNER JOIN
-- pegar o e-mail de cada pesquisador
SELECT P.cpf, U.email
FROM 
Pesquisador P
INNER JOIN
Usuario U ON U.cpf = P.cpf;

-- GROUP BY
-- COUNT
-- HAVING
-- contar o numero de visualizacoes de cada edicao de cada periodico, e exibir aquelas que estejam com pelo menos 500 visualizacoes
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
HAVING COUNT(*) > 500;

-- MAX
-- ORDER BY
--pegar qual o maior numero de visualizacoes obtido por cada periodico em ordem decrescente
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
)
SELECT codigo_periodico, MAX(visualizacoes)
FROM tabela_visualizacoes
GROUP BY codigo_periodico
ORDER BY MAX(visualizacoes) DESC;

-- MIN
--pegar qual o maior numero de visualizacoes obtido por cada periodico em ordem crescente
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
)
SELECT codigo_periodico, MIN(visualizacoes)
FROM tabela_visualizacoes
GROUP BY codigo_periodico
ORDER BY MIN(visualizacoes);

-- AVG
-- pegar a media de visualizacoes recebida nas edicoes de um periodico
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
)
SELECT codigo_periodico, AVG(visualizacoes)
FROM tabela_visualizacoes
GROUP BY codigo_periodico;

-- BETWEEN
-- pegar todas as edicoes que tem no minimo 500 visualizacoes, mas nao passam de 100.000
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
)
SELECT numero_edicao, codigo_periodico, visualizacoes
FROM tabela_visualizacoes
WHERE visualizacoes BETWEEN 500 AND 100000;

-- LEFT ou RIGHT ou FULL OUTER JOIN
-- pegar todos os pesquisadores e seus respectivos artigos, incluindo aqueles que ainda nao tem artigos escritos
SELECT P.cpf, A.titulo
FROM Escrever E,
Artigo A
LEFT OUTER JOIN
Pesquisador P ON E.cpf = P.cpf AND E.codigo_artigo = A.codigo;

--SUBCONSULTA COM OPERADOR RELACIONAL
-- pegar todas as edicoes com numero de visualizacoes acima da media para o periodico de numero 1
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
WHERE E.codigo_periodico = 1
GROUP BY L.numero_edicao
)
SELECT numero_edicao, visualizacoes
FROM tabela_visualizacoes
WHERE visualizacoes > (
    SELECT AVG(visualizacoes)
    FROM tabela_visualizacoes
);

-- SUBCONSULTA COM IN
-- ver quais leitores tambem sao pesquisadores que ja escreveram artigos
SELECT cpf
FROM Leitor
WHERE cpf IN (
    SELECT P.cpf
    FROM Escrever E,
    Artigo A
    INNER JOIN
    Pesquisador P ON E.cpf = P.cpf AND E.codigo_artigo = A.codigo
);

-- SUBCONSULTA COM ANY


-- SUBCONSULTA COM ALL
-- pegar as edicoes que tenham a maior quantidade de visualizacoes do portal inteiro
WITH tabela_visualizacoes AS (
SELECT L.numero_edicao, E.codigo_periodico, COUNT(*) AS visualizacoes
FROM
Edicao E
INNER JOIN
Ler L ON E.numero = L.numero_edicao AND E.codigo_periodico = L.codigo_periodico
GROUP BY L.numero_edicao, E.codigo_periodico
)
SELECT numero_edicao, codigo_periodico
FROM tabela_visualizacoes
WHERE visualizacoes >= ALL(-- >= pois elas nao podem ser maiores que si mesmas
    SELECT visualizacoes
    FROM tabela_visualizacoes
);

-- UNION ou INTERSECT ou MINUS
-- selecionar todos os os cpfs que sao de ambos Pesquisadores e Leitores
(SELECT U.cpf
FROM Usuario U, Pesquisador P
WHERE U.cpf = P.cpf)
    INTERSECT
(SELECT U.cpf
FROM Usuario U, Leitor L
WHERE U.cpf = L.cpf);


-- CREATE VIEW


--              ~~~~~~~~~~~~~~  PL ~~~~~~~~~~~~~~

-- USO DE RECORD
-- BLOCO ANONIMO
-- SELECT INTO
-- %TYPE
-- armazenar a quantidade de edicoes do periodico 1
DECLARE

    TYPE NUMERO_EDICOES IS RECORD(
        codigo_periodico Periodico.codigo%TYPE,
        qtd_edicoes INTEGER
    );
    periodico1 NUMERO_EDICOES;

BEGIN

    SELECT codigo_periodico, COUNT(*)
    INTO periodico1
    FROM Edicao
    WHERE codigo_periodico = 1
    GROUP BY codigo_periodico;

END;
/

-- CURSOR (OPEN, FETCH e CLOSE)

-- USO DE ESTRUTURA DE DADOS DO TIPO TABLE
-- %ROWTYPE
-- FOR IN LOOP
-- armazenar as tuplas dos primeiros n usuarios adicionados no banco
DECLARE

    TYPE USUARIOS IS TABLE OF Usuario%ROWTYPE
    INDEX BY BINARY_INTEGER;

    primeiros_usuarios USUARIOS;
    temp Usuario%ROWTYPE;
    n INTEGER:=3;

    -- copia para ser lida uma por uma
    CURSOR Usuarios_cursor
    IS SELECT *
    FROM Usuario;

BEGIN

    OPEN Usuarios_cursor;
    FOR i IN 0..n LOOP
        FETCH Usuarios_cursor INTO temp;
        EXIT WHEN Usuarios_cursor%NOTFOUND;

        primeiros_usuarios(i) := temp;
    END LOOP;
    CLOSE Usuarios_cursor;

END;
/

-- CREATE PROCEDURE

-- CREATE FUNCTION


-- CASE WHEN


-- LOOP EXIT WHEN
-- IF ELSIF
-- pegar a data de uma edicao especifica de um periodico (nesse caso o periodico 1, edicao 3)
DECLARE

    codigo_selecionado Periodico.codigo%TYPE :=1;
    numero_edicao Edicao.numero%TYPE :=3;
    data_edicao Publicar.data_de_publicacao%TYPE;
    temp_data Publicar.data_de_publicacao%TYPE;
    n INTEGER:=0;

    CURSOR datas_edicoes_cursor
    IS SELECT data_de_publicacao
    FROM Publicar
    WHERE codigo_periodico = codigo_selecionado;

BEGIN

    OPEN datas_edicoes_cursor;
    LOOP

        n := n + 1;

        FETCH datas_edicoes_cursor INTO temp_data;
        EXIT WHEN datas_edicoes_cursor%NOTFOUND;
        IF n=numero_edicao THEN
            data_edicao := temp_data;
        END IF;

        EXIT WHEN n=numero_edicao;
    END LOOP;
    CLOSE datas_edicoes_cursor;

END;
/

-- WHILE LOOP




-- EXCEPTION WHEN

-- USO DE PARAMETROS (IN, OUT ou IN OUT)

-- CREATE OR REPLACE PACKAGE

-- CREATE OR REPLACE PACKAGE BODY

-- CREATE OR REPLACE TRIGGER (COMANDO)

-- CREATE OR REPLACE TRIGGER (LINHA)
-- checagem de valor valido de cpf?, procurar o calculo oficial

