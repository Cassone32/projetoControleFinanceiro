Unit uLancamentosDespesas;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DBGrids, DBCtrls, ZDataset, udm, LCLType, uFuncoes;

Type

  { TfrmLancamentosDespesas }

  TfrmLancamentosDespesas = class(TForm)
    bbtnGravar: TBitBtn;
    bbtnCancelar: TBitBtn;
    DataSourceStatus: TDataSource;
    DataSourceCategoria: TDataSource;
    DBLookupCbCategoria: TDBLookupComboBox;
    DBLookupCbStatus: TDBLookupComboBox;
    edtValor: TEdit;
    edtDescricao: TEdit;
    edtAno: TEdit;
    edtMes: TEdit;
    edtCodigo: TEdit;
    grbLancamento: TGroupBox;
    GroupBox1: TGroupBox;
    lblStatus: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    pnlTop: TPanel;
    ZQueryStatus: TZQuery;
    ZQueryCategoria: TZQuery;
    Procedure bbtnCancelarClick(Sender: TObject);
    Procedure bbtnGravarClick(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure BancosParaInterface;
  Private

  Public
    Constructor Create(AOwner : TComponent; pSituacao, pIdReferencia, pIdLancamento : integer);

  End;

Var
  frmLancamentosDespesas: TfrmLancamentosDespesas;
  situacao, IdReferencia, IdLancamento: integer; //1: Cadastro e 2: Alteração.

Implementation

{$R *.lfm}

{ TfrmLancamentosDespesas }

Constructor TfrmLancamentosDespesas.Create(AOwner : TComponent; pSituacao, pIdReferencia, pIdLancamento : integer);
Begin
  inherited Create(AOwner);

  situacao     := pSituacao;
  IdReferencia := pIdReferencia;
  IdLancamento := pIdLancamento;

End;

Procedure TfrmLancamentosDespesas.bbtnCancelarClick(Sender: TObject);
Begin
  //Cancelamento da ação: Fechamento do formulário.
  Close;
End;

Procedure TfrmLancamentosDespesas.bbtnGravarClick(Sender: TObject);
Begin
  //Validação.
  If(DBLookupCbCategoria.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    Exit;
  End
  Else If(DBLookupCbStatus.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    Exit;
  End
  Else If(edtDescricao.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    If(edtDescricao.CanFocus) then
     edtDescricao.SetFocus;
    Exit;
  End
  Else If(edtValor.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    If(edtValor.CanFocus) then
     edtValor.SetFocus;
    Exit;
  End;

  Case situacao of
  1: //Salvar novo registro na base de dados
   Begin
     Try
       incluir_lancamento(DMPrincipal.ZQueryAux, ZQueryCategoria.FieldByName('CATEGORIA_DESPESAS_ID').AsInteger, ZQueryStatus.FieldByName('STATUS_DESPESAS_ID').AsInteger, IdReferencia, edtDescricao.Text, StrToFloat(edtValor.Text));
       Application.MessageBox('Cadastro realizado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

       //Atualização formulário principal.
       exibir_referencia(DMPrincipal.ZQueryReferencia);
       Close;
     Except
       Application.MessageBox('Erro ao realizar o lançamento!', 'Aviso!', MB_OK + MB_ICONERROR);
       Exit;
     End;
   End;
  2: //Alteração do lançamento
   Begin
     Try
       alterar_lancamento(DMPrincipal.ZQueryAux, ZQueryCategoria.FieldByName('CATEGORIA_DESPESAS_ID').AsInteger, ZQueryStatus.FieldByName('STATUS_DESPESAS_ID').AsInteger, IdReferencia, edtDescricao.Text, StrToFloat(edtValor.Text), StrToInt(edtCodigo.Text));
       Application.MessageBox('Alteração realizada com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

       //Atualização formulário principal.
       exibir_referencia(DMPrincipal.ZQueryReferencia);
       Close;
     Except
       Application.MessageBox('Erro ao realizar a alteração do lançamento!', 'Aviso!', MB_OK + MB_ICONERROR);
       Exit;
     End;
   End;
  End; //case
End;

Procedure TfrmLancamentosDespesas.FormShow(Sender: TObject);
Begin
  ZQueryCategoria.Active := True;
  ZQueryStatus.Active    := True;
  Try
    Case situacao of
    1: //Cadastro
      Begin
        lblStatus.Caption := 'Lançando despesa!';
        buscar_referencia_especifica(DMPrincipal.ZQueryAux, IdReferencia);
        BancosParaInterface;
      End;
    2: //Alteração
      Begin
        lblStatus.Caption := 'Alterando despesa!';
        buscar_lancamento_especifico(DMPrincipal.ZQueryAux, IdLancamento);
        BancosParaInterface;
      End;
    End;
  Except
    Application.MessageBox('Ocorreu uma exceção ao preencher dados automáticos na interface!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmLancamentosDespesas.BancosParaInterface;
Begin
  Case situacao of
  1: //Cadastro> somente preencher dados da referência
    Begin
      edtAno.Text := DMPrincipal.ZQueryAux.FieldByName('ANO').AsString;
      edtMes.Text := DMPrincipal.ZQueryAux.FieldByName('MES').AsString;
    End;
  2: //Alteração> preencher todos os dados
    Begin
      edtMes.Text := DMPrincipal.ZQueryAux.FieldByName('ANO').AsString;
      edtAno.Text := DMPrincipal.ZQueryAux.FieldByName('MES').AsString;

      edtCodigo.Text               := DMPrincipal.ZQueryAux.FieldByName('LANCAMENTO_DESPESAS_ID').AsString;

      DBLookupCbCategoria.KeyValue := DMPrincipal.ZQueryAux.FieldByName('CATEGORIA_DESPESAS_ID').AsInteger;
      DBLookupCbStatus.KeyValue    := DMPrincipal.ZQueryAux.FieldByName('STATUS_DESPESAS_ID').AsInteger;

      edtDescricao.Text            := DMPrincipal.ZQueryAux.FieldByName('DESCRICAOLANCAMENTO').AsString;
      edtValor.Text                := DMPrincipal.ZQueryAux.FieldByName('VALOR').AsString;
    End;
  End;
End;

End.

