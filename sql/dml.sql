/* ==========================================================================
   0. LIMPEZA (Ordem correta para respeitar Foreign Keys)
   ========================================================================== */
DELETE FROM Possui_saldo;
DELETE FROM Negocia;
DELETE FROM Cotacao;
DELETE FROM Acao;
DELETE FROM Empresa;
DELETE FROM Investidor;
DELETE FROM Log_Auditoria;

/* ==========================================================================
   1. INVESTIDORES (8 Registros)
   Nota: Documentos formatados respeitam o CHECK CONSTRAINT (Length >= 11 ou 14)
   ========================================================================== */
INSERT INTO Investidor (id_investidor, documento, nome, tipo, email, telefone) VALUES
(1, '11122233344', 'João da Silva', 'F', 'joao@mail.com', '11999990001'),
(2, '22233344455', 'Maria Oliveira', 'F', 'maria@mail.com', '21988880002'),
(3, '12345678000190', 'Alpha Capital', 'J', 'adm@alpha.com', '1130304040'),
(4, '33344455566', 'Carlos DayTrader', 'F', 'carlos@trader.com', '11977770003'),
(5, '44455566677', 'Ana Longo Prazo', 'F', 'ana@holder.com', '31966660004'),
(6, '98765432000110', 'Fundo Quant', 'J', 'ops@quant.com', '1135005000'),
(7, '55566677788', 'Roberto Aposentado', 'F', 'beto@mail.com', '41955550005'),
(8, '66677788899', 'Julia Tech', 'F', 'julia@tech.com', '48944440006');

/* ==========================================================================
   2. EMPRESAS (6 Registros)
   Nota: Valor de Mercado com 4 casas decimais
   ========================================================================== */
INSERT INTO Empresa (id_empresa, cnpj, Setor_Atuacao, Nome_Empresa, Valor_Mercado) VALUES
(1, '33000167000101', 'Petróleo', 'Petrobras', 500000000000.0000),
(2, '60746948000112', 'Bancário', 'Bradesco', 180000000000.0000),
(3, '47508411000156', 'Varejo', 'Magazine Luiza', 20000000000.0000),
(4, '33592510000154', 'Mineração', 'Vale S.A.', 350000000000.0000),
(5, '84429695000111', 'Industrial', 'WEG S.A.', 160000000000.0000),
(6, '00000000000191', 'Bancário', 'Itaú Unibanco', 250000000000.0000);

/* ==========================================================================
   3. AÇÕES (6 Registros)
   Nota: Definindo IDs manualmente para facilitar as FKs abaixo
   ========================================================================== */
INSERT INTO Acao (id_acao, fk_Empresa_id_empresa, Ticker) VALUES
(10, 1, 'PETR4'),
(20, 2, 'BBDC4'),
(30, 3, 'MGLU3'),
(40, 4, 'VALE3'),
(50, 5, 'WEGE3'),
(60, 6, 'ITUB4');

/* ==========================================================================
   4. COTAÇÕES
   Nota: fk_Acao_id_acao usa os IDs numéricos (10, 20...), não strings.
   Data_hora usa precisão de microssegundos.
   ========================================================================== */
INSERT INTO Cotacao (id_cotacao, fk_Acao_id_acao, Data_hora, Valor) VALUES
-- Abertura (VALE3 -> ID 40)
(101, 40, '2023-11-01 10:00:00.000000', 70.0000),
(102, 50, '2023-11-01 10:00:00.000000', 35.0000), -- WEGE3
(103, 60, '2023-11-01 10:00:00.000000', 28.0000), -- ITUB4
(104, 10, '2023-11-01 10:00:00.000000', 34.5000), -- PETR4

-- Oscilações (VALE3 -> ID 40)
(105, 40, '2023-11-01 11:30:00.500000', 71.5000), 
(106, 40, '2023-11-01 12:00:00.123000', 69.8000),

-- Penny Stock caindo (MGLU3 -> ID 30)
(109, 30, '2023-11-01 14:00:00.000000', 2.1000),
(110, 30, '2023-11-01 14:30:00.000000', 2.0500),

-- Fechamento
(113, 40, '2023-11-01 17:00:00.000000', 70.2000),
(114, 50, '2023-11-01 17:00:00.000000', 36.0000),
(115, 60, '2023-11-01 17:00:00.000000', 29.0000),
(116, 10, '2023-11-01 17:00:00.000000', 35.0000),
(117, 30, '2023-11-01 17:00:00.000000', 2.0000),
(118, 20, '2023-11-01 17:00:00.000000', 15.0000);

/* ==========================================================================
   5. NEGOCIAÇÕES
   Nota: Substituimos Ticker por ID da Ação.
   ========================================================================== */
INSERT INTO Negocia (id_negocia, fk_Investidor_id_investidor, fk_Acao_id_acao, Tipo_operacao, data_hora, Quantidade, Valor) VALUES
-- 1. Carlos (DayTrader) operando VALE3 (ID 40)
(501, 4, 40, 'C', '2023-11-01 10:05:00.100000', 1000, 70.1000),
(502, 4, 40, 'V', '2023-11-01 11:35:00.200000', 1000, 71.4000),
(503, 4, 40, 'C', '2023-11-01 12:05:00.000000', 500, 69.9000),
(504, 4, 40, 'V', '2023-11-01 15:10:00.999000', 500, 70.4000), 

-- 2. Ana (Holder) comprando WEGE3 (ID 50) e ITUB4 (ID 60)
(505, 5, 50, 'C', '2023-11-01 10:30:00.000000', 100, 35.1000),
(506, 5, 60, 'C', '2023-11-01 10:35:00.000000', 200, 28.1000),
(507, 5, 50, 'C', '2023-11-01 16:50:00.000000', 50, 35.9000),

-- 3. Fundo Quant operando PETR4 (ID 10) e BBDC4 (ID 20)
(508, 6, 10, 'C', '2023-11-01 11:00:00.000000', 10000, 34.6000),
(509, 6, 10, 'V', '2023-11-01 11:20:00.555000', 5000, 34.7500),
(510, 6, 20, 'C', '2023-11-01 14:00:00.000000', 20000, 15.1000),

-- 4. João comprando MGLU3 (ID 30)
(511, 1, 30, 'C', '2023-11-01 14:10:00.000000', 1000, 2.1000),
(512, 1, 30, 'V', '2023-11-01 16:55:00.000000', 1000, 2.0100), -- Zerou

-- 5. Alpha Capital movimentando VALE3 (ID 40)
(514, 3, 40, 'C', '2023-11-01 13:00:00.000000', 2000, 70.0000),

-- 6. Carlos Swing Trade MGLU3 (ID 30)
(519, 4, 30, 'C', '2023-11-01 16:59:00.000000', 5000, 2.0000);

/* ==========================================================================
   6. SALDO DE CARTEIRA (Snapshot Atual)
   Nota: Inclui campo 'version' (padrão 1).
   Usamos IDs no lugar dos Tickers.
   ========================================================================== */

-- Carlos (ID 4): Terminou com 5000 de MGLU3 (ID 30)
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (4, 30, 5000, 1);

-- Ana (ID 5):
-- WEGE3 (ID 50): 100 + 50 = 150
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (5, 50, 150, 1);
-- ITUB4 (ID 60): 200
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (5, 60, 200, 1);

-- Fundo Quant (ID 6):
-- PETR4 (ID 10): 10000 - 5000 = 5000
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (6, 10, 5000, 1);
-- BBDC4 (ID 20): 20000
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (6, 20, 20000, 1);

-- Alpha Capital (ID 3):
-- VALE3 (ID 40): 2000
INSERT INTO Possui_saldo (fk_Investidor_id_investidor, fk_Acao_id_acao, Quantidade, version) 
VALUES (3, 40, 2000, 1);

/* ==========================================================================
   7. AUDITORIA (Exemplo de log inicial)
   ========================================================================== */
INSERT INTO Log_Auditoria (tabela_afetada, id_registro_afetado, acao, usuario_responsavel, detalhes_json) 
VALUES 
('Sistema', 0, 'INSERT', 'Admin_DBA', '{"msg": "Carga inicial de dados fictícios concluída"}');