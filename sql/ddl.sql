

ALTER TABLE Acao ADD CONSTRAINT FK_Acao_Empresa
    FOREIGN KEY (fk_Empresa_id_empresa)
    REFERENCES Empresa (id_empresa);


ALTER TABLE Cotacao ADD CONSTRAINT FK_Cotacao_Acao
    FOREIGN KEY (fk_Acao_id_acao)
    REFERENCES Acao (id_acao);


ALTER TABLE Negocia ADD CONSTRAINT FK_Negocia_Investidor
    FOREIGN KEY (fk_Investidor_id_investidor)
    REFERENCES Investidor (id_investidor);


ALTER TABLE Negocia ADD CONSTRAINT FK_Negocia_Acao
    FOREIGN KEY (fk_Acao_id_acao)
    REFERENCES Acao (id_acao);

ALTER TABLE Possui_saldo ADD CONSTRAINT FK_Saldo_Investidor
    FOREIGN KEY (fk_Investidor_id_investidor)
    REFERENCES Investidor (id_investidor);

ALTER TABLE Possui_saldo ADD CONSTRAINT FK_Saldo_Acao
    FOREIGN KEY (fk_Acao_id_acao)
    REFERENCES Acao (id_acao);