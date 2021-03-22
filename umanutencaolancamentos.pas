Unit uManutencaoLancamentos;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, DBGrids, udm, uFuncoes, uLancamentosDespesas, LCLType;

Type

  { TfrmManutencaoLancamentos }

  TfrmManutencaoLancamentos = class(TForm)
    bbtnSair: TBitBtn;
    bbtnLancarDespesa: TBitBtn;
    bbtnAlterar: TBitBtn;
    bbtnExcluir: TBitBtn;
    DataSourceLancamentosAux: TDataSource;
    DBGridReferencias: TDBGrid;
    DBGridReferencias1: TDBGrid;
    edtValorDespesas: TEdit;
    grbMesReferencia: TGroupBox;
    grbLancamentoMesReferencia: TGroupBox;
    grbSomatorias: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlBodyGrbSomatorias: TPanel;
    pnlBody: TPanel;
    pnlHead: TPanel;
    pnlFooter: TPanel;
    TimerLancamento: TTimer;
    TimerReferencia: TTimer;
    Procedure bbtnAlterarClick(Sender: TObject);
    Procedure bbtnExcluirClick(Sender: TObject);
    Procedure bbtnLancarDespesaClick(Sender: TObject);
    Procedure bbtnSairClick(Sender: TObject);
    Procedure DataSourceLancamentosAuxDataChange(Sender: TObject; Field: TField
      );
    Procedure FormShow(Sender: TObject);
    Procedure TimerLancamentoTimer(Sender: TObject);
    Procedure TimerReferenciaTimer(Sender: TObject);
  Private

  Public

  End;

Var
  frmManutencaoLancamentos: TfrmManutencaoLancamentos;

Implementation

{$R *.lfm}

{ TfrmManutencaoLancamentos }

Procedure TfrmManutencaoLancamentos.bbtnSairClick(Sender: TObject);
Begin
  frmManutencaoLancamentos.Close;
End;

Procedure TfrmManutencaoLancamentos.bbtnLancarDespesaClick(Sender: TObject);
Begin
  With TfrmLancamentosDespesas.Create(self, 1, DMPrincipal.ZQueryReferencia.FieldByName('REFERENCIA_LANCAMENTO_DESPESAS_ID').AsInteger, 0) do
  Begin
    ShowModal;
    Free;
  End;
End;

Procedure TfrmManutencaoLancamentos.bbtnAlterarClick(Sender: TObject);
Begin
  If(DMPrincipal.ZQueryLancamentoReferencia.FieldByName('LANCAMENTO_DESPESAS_ID').AsInteger > 0) then
  Begin
   With TfrmLancamentosDespesas.Create(self, 2, DMPrincipal.ZQueryReferencia.FieldByName('REFERENCIA_LANCAMENTO_DESPESAS_ID').AsInteger, DMPrincipal.ZQueryLancamentoReferencia.FieldByName('LANCAMENTO_DESPESAS_ID').AsInteger) do
   Begin
    ShowModal;
    Free;
   End;
  End
  Else
  Begin
    Application.MessageBox('Nenhum registro para ser alterado!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  End;
End;

Procedure TfrmManutencaoLancamentos.bbtnExcluirClick(Sender: TObject);
Var
  IdLancamento : integer;
Begin
  If(Application.MessageBox('Confirma a exclusão desse registro?', 'Confirmação',
                                      MB_YESNO + MB_ICONQUESTION)) = IDYES then
  Begin
    IdLancamento := DMPrincipal.ZQueryLancamentoReferencia.FieldByName('LANCAMENTO_DESPESAS_ID').AsInteger;

    Try
      excluir_lancamento(DMPrincipal.ZQueryAux, IdLancamento);
      Application.MessageBox('Registro excluído com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
    Except
      Application.MessageBox('Erro ao realizar a exclusão do registro!', 'Aviso!', MB_OK + MB_ICONERROR);
      Exit;
    End;

    exibir_referencia(DMPrincipal.ZQueryReferencia);
  End;
End;

Procedure TfrmManutencaoLancamentos.DataSourceLancamentosAuxDataChange(
  Sender: TObject; Field: TField);
Var
  somaTotal: Double;
Begin
  somaTotal := 0;

  Try
    exibir_lancamento_referencia(DMPrincipal.ZQueryLancamentoReferencia, DMPrincipal.ZQueryReferencia.FieldByName('REFERENCIA_LANCAMENTO_DESPESAS_ID').AsInteger);
    DMPrincipal.ZQueryLancamentoReferencia.First;

    While not DMPrincipal.ZQueryLancamentoReferencia.EOF do
    Begin
      somaTotal := somaTotal + DMPrincipal.ZQueryLancamentoReferencia.FieldByName('VALOR').AsFloat;
      DMPrincipal.ZQueryLancamentoReferencia.Next;
    End;

    edtValorDespesas.Text := FloatToStr(somaTotal);

  Except
    Application.MessageBox('Erro ao listar as despesas vinculadas a esta referência!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmManutencaoLancamentos.FormShow(Sender: TObject);
Begin
  TimerLancamento.Enabled := True;
  TimerReferencia.Enabled := True;
  Try
    exibir_referencia(DMPrincipal.ZQueryReferencia);
  Except
    Application.MessageBox('Erro ao listar as referências!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmManutencaoLancamentos.TimerLancamentoTimer(Sender: TObject);
Begin
  If(DMPrincipal.DataSourceLancamentoReferencia.DataSet.RecordCount > 0) then
  Begin
    //Há lançamento, liberar botão, alterar e excluir
    bbtnAlterar.Enabled := True;
    bbtnExcluir.Enabled := True;
  End
  Else
  Begin
    //Não há lançamentos, bloquear botão, alterar e excluir
    bbtnAlterar.Enabled := False;
    bbtnExcluir.Enabled := False;
  End;
End;

Procedure TfrmManutencaoLancamentos.TimerReferenciaTimer(Sender: TObject);
Begin
  If(DataSourceLancamentosAux.DataSet.RecordCount > 0) then
  Begin
    //Há referência lançada, liberar botão 'Lançar'
    bbtnLancarDespesa.Enabled := True;
  End
  Else
  Begin
    //Não há referência lançada, bloquear 'Lançar'
    bbtnLancarDespesa.Enabled := False;
  End;
End;

End.

