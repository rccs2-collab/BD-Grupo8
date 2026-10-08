-- Entidades iniciais que nao dependem de nenhuma outra (nao tem foreign key)
-- Usuario, Instituicao, Periodico e Topico

INSERT INTO Usuario(cpf, email) VALUES (11122233323,'amanda@gmail.com');
INSERT INTO Usuario(cpf, email) VALUES (11122233345,'ricardo@gmail.com');
INSERT INTO Usuario(cpf, email) VALUES (11122233367,'julio@gmail.com');
INSERT INTO Usuario(cpf, email) VALUES (11122233389,'joao@gmail.com');

INSERT INTO Instituicao(codigo_institucional, nome, tipo, data_do_proximo_pagamento)
VALUES (1,'UFPE','universidade federal', TO_DATE('2026-04-15','YYYY-MM-DD'));
INSERT INTO Instituicao(codigo_institucional, nome, tipo, data_do_proximo_pagamento)
VALUES (2,'UPE','universidade estadual', TO_DATE('2026-04-26','YYYY-MM-DD'));

INSERT INTO Periodico(codigo, nome)
VALUES (1, 'Biologia e tecnologia');
INSERT INTO Periodico(codigo, nome)
VALUES (2,'Nanotecnologia aplicada');
INSERT INTO Periodico(codigo, nome)
VALUES (3,'O futuro feito ontem');


CREATE SEQUENCE numero_topico INCREMENT BY 1 START WITH 1;


INSERT INTO Topico(numero, nome)
VALUES (numero_topico.NEXTVAL, 'ciencia');
INSERT INTO Topico(numero, nome)
VALUES (numero_topico.NEXTVAL, 'tecnologia');
INSERT INTO Topico(numero, nome)
VALUES (numero_topico.NEXTVAL, 'biologia');
INSERT INTO Topico(numero, nome)
VALUES (numero_topico.NEXTVAL, 'geografia');

-- Herancas de Usuario, formacao e telefone

INSERT INTO Pesquisador(cpf, primeiro_nome, segundo_nome)
VALUES (11122233323,'amanda','amaral');
INSERT INTO Pesquisador(cpf, primeiro_nome, segundo_nome)
VALUES (11122233345,'ricardo','braga');

INSERT INTO Formacao(cpf, formacao)
VALUES (11122233323, 'biologia');
INSERT INTO Formacao(cpf, formacao)
VALUES (11122233323, 'ciencia da computacao');
INSERT INTO Formacao(cpf, formacao)
VALUES (11122233345, 'tecnologia da informacao');

INSERT INTO Leitor(cpf, nome_de_usuario, data_do_proximo_pagamento)
VALUES (11122233345, 'ricardo',TO_DATE('2026-04-18','YYYY-MM-DD'));
INSERT INTO Leitor(cpf, nome_de_usuario, data_do_proximo_pagamento)
VALUES (11122233367, 'julio',TO_DATE('2026-04-19','YYYY-MM-DD'));
INSERT INTO Leitor(cpf, nome_de_usuario, data_do_proximo_pagamento)
VALUES (11122233389, 'joao',TO_DATE('2026-04-20','YYYY-MM-DD'));

INSERT INTO Telefone(codigo_institucional, telefone)
VALUES (1,8197975555);
INSERT INTO Telefone(codigo_institucional, telefone)
VALUES (1,81993930000);
INSERT INTO Telefone(codigo_institucional, telefone)
VALUES (2, 81991912222);

-- Entidades fracas

INSERT INTO Edicao(numero, codigo_periodico, titulo)
VALUES (1,1,'Descobertas no cancer com uso de ciencia de dados');
INSERT INTO Edicao(numero, codigo_periodico, titulo)
VALUES (1,3,'Novas visoes sobre o lixo nuclear');

INSERT INTO Pagamento_instituicao(data_de_realizacao, codigo_institucional, valor, forma_de_pagamento)
VALUES (TO_DATE('2026-03-15','YYYY-MM-DD'), 1, 300.0, 'pix');
INSERT INTO Pagamento_instituicao(data_de_realizacao, codigo_institucional, valor, forma_de_pagamento)
VALUES (TO_DATE('2026-03-26','YYYY-MM-DD'), 2, 300.0, 'cheque sem fundo');

INSERT INTO Pagamento_leitor(data_de_realizacao, cpf, valor, forma_de_pagamento)
VALUES (TO_DATE('2026-03-18','YYYY-MM-DD'),11122233345,50.0,'cartao de credito');
INSERT INTO Pagamento_leitor(data_de_realizacao, cpf, valor, forma_de_pagamento)
VALUES (TO_DATE('2026-03-19','YYYY-MM-DD'),11122233367,50.0,'cartao de debito');
INSERT INTO Pagamento_leitor(data_de_realizacao, cpf, valor, forma_de_pagamento)
VALUES (TO_DATE('2026-03-20','YYYY-MM-DD'),11122233389,50.0, 'pix');

-- Artigo

INSERT INTO Artigo(codigo, titulo, tipo, data_de_escrita, numero_edicao, codigo_periodico)
VALUES (1, 'nova forma de lidar com o tumor do cancer de mama', 'doutorado', TO_DATE('2025-12-29','YYYY-MM-DD'), 1, 1);
INSERT INTO Artigo(codigo, titulo, tipo, data_de_escrita, numero_edicao, codigo_periodico)
VALUES (2, 'novo uso encontrado para o lixo nuclear', 'doutorado', TO_DATE('2026-01-10','YYYY-MM-DD'), 1, 3);
INSERT INTO Artigo(codigo, titulo, tipo, data_de_escrita, numero_edicao, codigo_periodico)
VALUES (3, 'nova interacao entre tumores no cancer de mama', 'Estudo de caso', TO_DATE('2024-05-04','YYYY-MM-DD'), 1, 1);

--    RELACIONAMENTOS

INSERT INTO Escrever(codigo_institucional, cpf, codigo_artigo)
VALUES (1,11122233323,1);
INSERT INTO Escrever(codigo_institucional, cpf, codigo_artigo)
VALUES (2,11122233345,2);

INSERT INTO Citar(codigo_citado, codigo_citante)
VALUES (3, 1);

INSERT INTO Publicar (codigo_institucional, codigo_periodico, data_de_publicacao)
VALUES (1,1, TO_DATE('2026-03-30','YYYY-MM-DD'));
INSERT INTO Publicar (codigo_institucional, codigo_periodico, data_de_publicacao)
VALUES (2,3, TO_DATE('2026-04-05','YYYY-MM-DD'));

INSERT INTO Abrange(numero_topico, numero_edicao, codigo_periodico)
VALUES (1, 1, 1);
INSERT INTO Abrange(numero_topico, numero_edicao, codigo_periodico)
VALUES (3, 1, 1);
INSERT INTO Abrange(numero_topico, numero_edicao, codigo_periodico)
VALUES (1, 1, 3);

INSERT INTO Notificar(cpf, codigo_institucional, codigo_periodico, data_de_publicacao, data_de_notificacao, situacao)
VALUES (11122233345, 1, 1, TO_DATE('2026-03-30','YYYY-MM-DD'), TO_DATE('2026-03-30','YYYY-MM-DD'), 'lida');
INSERT INTO Notificar(cpf, codigo_institucional, codigo_periodico, data_de_publicacao, data_de_notificacao, situacao)
VALUES (11122233389, 2, 3, TO_DATE('2026-04-05','YYYY-MM-DD'), TO_DATE('2026-04-05','YYYY-MM-DD'), 'recebida');

INSERT INTO Inscrever(cpf, codigo_periodico)
VALUES (11122233345,1);
INSERT INTO Inscrever(cpf, codigo_periodico)
VALUES (11122233367,2);
INSERT INTO Inscrever(cpf, codigo_periodico)
VALUES (11122233389,3);

INSERT INTO Ler(cpf, numero_edicao, codigo_periodico)
VALUES (11122233345, 1, 1);
INSERT INTO Ler(cpf, numero_edicao, codigo_periodico)
VALUES (11122233389, 1, 1);
INSERT INTO Ler(cpf, numero_edicao, codigo_periodico)
VALUES (11122233367, 1, 3);