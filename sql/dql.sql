/* A. Consultar o Saldo Atual (Carteira) de um Investidor Específico

Esta query mostra quais ações o investidor possui e a quantidade, fazendo o join com os dados do Investidor.
*Filtro aplicado: Investidor ID 5 (Ana Longo Prazo)*/

SELECT 
    I.nome AS Investidor,
    S.fk_Acao_Ticker AS Acao,
    E.Nome_Empresa,
    S.Quantidade AS Qtd_em_Carteira
FROM Possui_saldo S
JOIN Investidor I ON S.fk_Investidor_id_investidor = I.id_investidor
JOIN Acao A ON S.fk_Acao_Ticker = A.Ticker
JOIN Empresa E ON A.fk_Empresa_id_empresa = E.id_empresa
WHERE I.id_investidor = 5
ORDER BY S.fk_Acao_Ticker;

/*B. Extrato de Movimentações (Nota de Corretagem)

Lista todas as compras e vendas de um investidor, calculando o valor total da operação.
*/

SELECT 
    N.data_hora,
    N.Tipo_operacao,
    N.fk_Acao_Ticker AS Ticker,
    N.Quantidade,
    N.Valor AS Preco_Unitario,
    (N.Quantidade * N.Valor) AS Valor_Total_Operacao
FROM Negocia N
WHERE N.fk_Investidor_id_investidor = 4 -- Carlos DayTrader
ORDER BY N.data_hora DESC;



/*Histórico de Preços de uma Ação (Intraday)

Mostra a evolução do preço de um ativo específico em ordem cronológica.*/

SELECT 
    fk_Acao_Ticker AS Ticker,
    DATE_FORMAT(Data_hora, '%H:%i') AS Hora, -- Formata hora (MySQL)
    Valor
FROM Cotacao
WHERE fk_Acao_Ticker = 'VALE3'
ORDER BY Data_hora ASC;


/* Máxima, Mínima e Média do dia por Ação

Uma query analítica para ver a volatilidade dos papéis no dia.*/


SELECT 
    fk_Acao_Ticker AS Ticker,
    MIN(Valor) AS Minima_Dia,
    MAX(Valor) AS Maxima_Dia,
    AVG(Valor) AS Media_Preco,
    COUNT(*) AS Qtd_Cotacoes_Registradas
FROM Cotacao
GROUP BY fk_Acao_Ticker;

/*
 E. Ranking de Ações mais Negociadas (Volume Financeiro)

Quais ações movimentaram mais dinheiro na corretora?*/

SELECT 
    N.fk_Acao_Ticker AS Ticker,
    COUNT(N.id_negocia) AS Total_Trades,
    SUM(N.Quantidade) AS Total_Papeis_Negociados,
    SUM(N.Quantidade * N.Valor) AS Volume_Financeiro_Total
FROM Negocia N
GROUP BY N.fk_Acao_Ticker
ORDER BY Volume_Financeiro_Total DESC;


/*Distribuição de Empresas por Setor

Quantas empresas temos cadastradas por setor de atuação?*/

SELECT 
    Setor_Atuacao,
    COUNT(id_empresa) AS Qtd_Empresas,
    AVG(Valor_Mercado) AS Valor_Mercado_Medio
FROM Empresa
GROUP BY Setor_Atuacao
ORDER BY Qtd_Empresas DESC;
/*

Pega o saldo do cliente e multiplica pela última cotação disponível no banco para saber quanto dinheiro ele tem hoje.
*/
SELECT 
    I.nome,
    SUM(S.Quantidade * C.Valor) AS Patrimonio_Total_Estimado
FROM Possui_saldo S
JOIN Investidor I ON S.fk_Investidor_id_investidor = I.id_investidor
-- Subquery para pegar apenas a cotação mais recente de cada ação
JOIN (
    SELECT c1.fk_Acao_Ticker, c1.Valor
    FROM Cotacao c1
    INNER JOIN (
        SELECT fk_Acao_Ticker, MAX(Data_hora) as MaxData
        FROM Cotacao
        GROUP BY fk_Acao_Ticker
    ) c2 ON c1.fk_Acao_Ticker = c2.fk_Acao_Ticker AND c1.Data_hora = c2.MaxData
) C ON S.fk_Acao_Ticker = C.fk_Acao_Ticker
GROUP BY I.nome
ORDER BY Patrimonio_Total_Estimado DESC;
