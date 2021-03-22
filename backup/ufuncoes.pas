Unit uFuncoes;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, sqldb, ZDataset;

{Status}
Procedure exibir_status(Query: TZQuery);
Procedure incluir_status(Query: TZQuery; DescricaoStatus: String);
Procedure alterar_status(Query: TZQuery; DescricaoStatus: String; Id: integer);
Procedure excluir_status(Query: TZQuery; Id: integer);

{Categorias}
Procedure exibir_categorias(Query: TZQuery);
Procedure incluir_categorias(Query: TZQuery; DescricaoCategoria: String);
Procedure alterar_categorias(Query: TZQuery; DescricaoCategoria: String; Id: integer);
Procedure excluir_categorias(Query: TZQuery; Id: integer);

{Referência lançamento}
Procedure exibir_referencia(Query: TZQuery);
Procedure incluir_referencia(Query: TZQuery; Mes: integer; Ano: integer);
Procedure alterar_referencia(Query: TZQuery; Mes: Integer; Ano: integer; Id: integer);
Procedure excluir_referencia(Query: TZQuery; Id: integer);
Procedure buscar_referencia_especifica(Query: TZQuery; Id: integer);

Function  verificar_vinculo_referencia(Query: TZQuery; Id: integer) : integer;
Function  verificar_vinculo_categoria(Query: TZQuery; Id: integer) : integer;
Function  verificar_vinculo_status(Query: TZQuery; Id: integer) : integer;

{Lancamentos referência}
Procedure exibir_lancamento_referencia(Query: TZQuery; IdReferencia: integer);

{Lançamentos despesas}
Procedure incluir_lancamento(Query: TZQuery; IdCategoriaDespesa: integer; IdStatusDespesa: integer;
  IdReferenciaLancamentoDespesa: integer; DescricaoDespesa: String; ValorDespesa: Double);

Procedure alterar_lancamento(Query: TZQuery; IdCategoriaDespesas: integer; IdStatusDespesa: integer;
  IdReferenciaLancamentoDespesa: integer; DescricaoDespesa: String; ValorDespesa: Double; IdLancamento: integer);

Procedure buscar_lancamento_especifico(Query: TZQuery; Id: integer);

Procedure excluir_lancamento(Query: TZQuery; Id: integer);

Implementation

Function verificar_vinculo_referencia(Query: TZQuery; Id: integer) : integer;
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT LANCAMENTO_DESPESAS_ID FROM LANCAMENTO_DESPESAS');
  Query.SQL.Add('WHERE REFERENCIA_LANCAMENTO_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
  Query.Open;

  If(Query.RecordCount > 0) then
  Begin
    Result := 1;
  End
  Else
  Begin
    Result := 0;
  End;
End;

Function verificar_vinculo_categoria(Query: TZQuery; Id: integer) : integer;
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT LANCAMENTO_DESPESAS_ID FROM LANCAMENTO_DESPESAS');
  Query.SQL.Add('WHERE CATEGORIA_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
  Query.Open;

  If(Query.RecordCount > 0) then
  Begin
    Result := 1;
  End
  Else
  Begin
    Result := 0;
  End;
End;

Procedure exibir_referencia(Query: TZQuery);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM REFERENCIA_LANCAMENTO_DESPESAS ORDER BY ANO, MES ASC');
  Query.ExecSQL;
  Query.Open;
End;

Procedure buscar_referencia_especifica(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM REFERENCIA_LANCAMENTO_DESPESAS');
  Query.SQL.Add('WHERE REFERENCIA_LANCAMENTO_DESPESAS_ID = :IDREFERENCIA');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
  Query.Open;
End;

Procedure buscar_lancamento_especifico(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT ld.*,');
  Query.SQL.Add('       ld.DESCRICAO' + '''DESCRICAOLANCAMENTO''' + ',');
  Query.SQL.Add('       rld.ANO' + '''ANO''' + ',');
  Query.SQL.Add('       rld.MES' + '''MES''' + '');
  Query.SQL.Add('FROM LANCAMENTO_DESPESAS ld');
  Query.SQL.Add('INNER JOIN REFERENCIA_LANCAMENTO_DESPESAS rld  ON rld.REFERENCIA_LANCAMENTO_DESPESAS_ID  = ld.REFERENCIA_LANCAMENTO_DESPESAS_ID');
  Query.SQL.Add('WHERE ld.LANCAMENTO_DESPESAS_ID = :LANCAMENTO_DESPESAS_ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
  Query.Open;
End;

Procedure exibir_lancamento_referencia(Query: TZQuery; IdReferencia: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT ld.*,');
  Query.SQL.Add('       ld.DESCRICAO' + '''DESCRICAOLANCAMENTO''' + ',');
  Query.SQL.Add('       cd.DESCRICAO' + '''TIPODESPESA''' + ',');
  Query.SQL.Add('       sd.DESCRICAO' + '''STATUSDESPESA''' + '');
  Query.SQL.Add('FROM LANCAMENTO_DESPESAS ld');
  Query.SQL.Add('INNER JOIN CATEGORIA_DESPESAS cd ON cd.CATEGORIA_DESPESAS_ID = ld.CATEGORIA_DESPESAS_ID');
  Query.SQL.Add('INNER JOIN STATUS_DESPESAS sd  ON sd.STATUS_DESPESAS_ID = ld.STATUS_DESPESAS_ID');
  Query.SQL.Add('INNER JOIN REFERENCIA_LANCAMENTO_DESPESAS rld  ON rld.REFERENCIA_LANCAMENTO_DESPESAS_ID  = ld.REFERENCIA_LANCAMENTO_DESPESAS_ID');
  Query.SQL.Add('WHERE rld.REFERENCIA_LANCAMENTO_DESPESAS_ID = :IDREFERENCIA');

  Query.Params[0].AsInteger := IdReferencia;
  Query.ExecSQL;
  Query.Open;
End;

Procedure exibir_categorias(Query: TZQuery);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM CATEGORIA_DESPESAS');
  Query.ExecSQL;
  Query.Open;
End;

Procedure exibir_status(Query: TZQuery);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM STATUS_DESPESAS');
  Query.ExecSQL;
  Query.Open;
End;

Procedure incluir_categorias(Query: TZQuery; DescricaoCategoria: String);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO CATEGORIA_DESPESAS(DESCRICAO)');
  Query.SQL.Add(' VALUES(:DESCRICAO)');

  Query.Params[0].AsString := DescricaoCategoria;
  Query.ExecSQL;
End;

Procedure incluir_lancamento(Query: TZQuery; IdCategoriaDespesa: integer; IdStatusDespesa: integer;
  IdReferenciaLancamentoDespesa: integer; DescricaoDespesa: String; ValorDespesa: Double);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO LANCAMENTO_DESPESAS(CATEGORIA_DESPESAS_ID, STATUS_DESPESAS_ID, REFERENCIA_LANCAMENTO_DESPESAS_ID, DESCRICAO, VALOR)');
  Query.SQL.Add(' VALUES(:CATEGORIA_DESPESAS_ID, :STATUS_DESPESAS_ID, :REFERENCIA_LANCAMENTO_DESPESAS_ID, :DESCRICAO, :VALOR)');

  Query.Params[0].AsInteger := IdCategoriaDespesa;
  Query.Params[1].AsInteger := IdStatusDespesa;
  Query.Params[2].AsInteger := IdReferenciaLancamentoDespesa;
  Query.Params[3].AsString  := DescricaoDespesa;
  Query.Params[4].AsFloat   := ValorDespesa;
  Query.ExecSQL;
End;

Procedure incluir_referencia(Query: TZQuery; Mes: integer; Ano: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO REFERENCIA_LANCAMENTO_DESPESAS(MES, ANO)');
  Query.SQL.Add(' VALUES(:MES, :ANO)');

  Query.Params[0].AsInteger := Mes;
  Query.Params[1].AsInteger := Ano;
  Query.ExecSQL;
End;

Procedure incluir_status(Query: TZQuery; DescricaoStatus: String);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('INSERT INTO STATUS_DESPESAS(DESCRICAO)');
  Query.SQL.Add(' VALUES(:DESCRICAO)');

  Query.Params[0].AsString := DescricaoStatus;
  Query.ExecSQL;
End;

Procedure alterar_status(Query: TZQuery; DescricaoStatus: String; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE STATUS_DESPESAS SET DESCRICAO = :DESCRICAO');
  Query.SQL.Add('WHERE STATUS_DESPESAS_ID = :ID');

  Query.Params[0].AsString := DescricaoStatus;
  Query.Params[1].AsInteger:= Id;
  Query.ExecSQL;
End;

Procedure alterar_referencia(Query: TZQuery; Mes: Integer; Ano: integer; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE REFERENCIA_LANCAMENTO_DESPESAS SET MES = :MES, ANO = :ANO');
  Query.SQL.Add('WHERE REFERENCIA_LANCAMENTO_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Mes;
  Query.Params[1].AsInteger := Ano;
  Query.Params[2].AsInteger := Id;
  Query.ExecSQL;
End;

Procedure alterar_categorias(Query: TZQuery; DescricaoCategoria: String; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE CATEGORIA_DESPESAS SET DESCRICAO = :DESCRICAO');
  Query.SQL.Add('WHERE CATEGORIA_DESPESAS_ID = :ID');

  Query.Params[0].AsString := DescricaoCategoria;
  Query.Params[1].AsInteger:= Id;
  Query.ExecSQL;
End;

Procedure alterar_lancamento(Query: TZQuery; IdCategoriaDespesas: integer; IdStatusDespesa: integer;
  IdReferenciaLancamentoDespesa: integer; DescricaoDespesa: String; ValorDespesa: Double; IdLancamento: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE LANCAMENTO_DESPESAS SET CATEGORIA_DESPESAS_ID = :CATEGORIA_DESPESAS_ID,');
  Query.SQL.Add('                               STATUS_DESPESAS_ID = :STATUS_DESPESAS_ID,');
  Query.SQL.Add('                               REFERENCIA_LANCAMENTO_DESPESAS_ID = :REFERENCIA_LANCAMENTO_DESPESAS_ID,');
  Query.SQL.Add('                               DESCRICAO := :DESCRICAO,');
  Query.SQL.Add('                               VALOR := :VALOR');
  Query.SQL.Add('WHERE LANCAMENTO_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := IdCategoriaDespesas;
  Query.Params[1].AsInteger := IdStatusDespesa;
  Query.Params[2].AsInteger := IdReferenciaLancamentoDespesa;
  Query.Params[3].AsString  := DescricaoDespesa;
  Query.Params[4].AsFloat   := ValorDespesa;
  Query.Params[5].AsInteger := IdLancamento;
  Query.ExecSQL;
End;

Procedure excluir_status(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('DELETE FROM STATUS_DESPESAS');
  Query.SQL.Add('WHERE STATUS_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
End;

Procedure excluir_lancamento(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('DELETE FROM LANCAMENTO_DESPESAS');
  Query.SQL.Add('WHERE LANCAMENTO_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
End;

Procedure excluir_categorias(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('DELETE FROM CATEGORIA_DESPESAS');
  Query.SQL.Add('WHERE CATEGORIA_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
End;

Procedure excluir_referencia(Query: TZQuery; Id: integer);
Begin
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('DELETE FROM REFERENCIA_LANCAMENTO_DESPESAS');
  Query.SQL.Add('WHERE REFERENCIA_LANCAMENTO_DESPESAS_ID = :ID');

  Query.Params[0].AsInteger := Id;
  Query.ExecSQL;
End;

End.

