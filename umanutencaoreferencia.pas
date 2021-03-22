Unit uManutencaoReferencia;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DBGrids, udm, uFuncoes, LCLType;

Type

  { TfrmManutencaoReferencia }

  TfrmManutencaoReferencia = class(TForm)
    bbtnSair: TBitBtn;
    bbtnCadastrar: TBitBtn;
    bbtnAlterar: TBitBtn;
    bbtnExcluir: TBitBtn;
    bbtnCancelar: TBitBtn;
    bbtnGravar: TBitBtn;
    DataSourceAuxiliarReferencia: TDataSource;
    DBGridReferencias: TDBGrid;
    edtCodigo: TEdit;
    edtMes: TEdit;
    edtAno: TEdit;
    grbCadastroEdicao: TGroupBox;
    grbGridRegistros: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblStatus: TLabel;
    pnlBody: TPanel;
    pnlBodyGroup: TPanel;
    pnlFooter: TPanel;
    pnlGrbGridRegistros: TPanel;
    pnlHead: TPanel;
    TimerSituacaoBotao: TTimer;
    TimerInterface: TTimer;
    Procedure bbtnAlterarClick(Sender: TObject);
    Procedure bbtnCadastrarClick(Sender: TObject);
    Procedure bbtnCancelarClick(Sender: TObject);
    Procedure bbtnExcluirClick(Sender: TObject);
    Procedure bbtnGravarClick(Sender: TObject);
    Procedure bbtnSairClick(Sender: TObject);
    Procedure DataSourceAuxiliarReferenciaDataChange(Sender: TObject;
      Field: TField);
    Procedure FormShow(Sender: TObject);
    Procedure BancoParaInterface;
    Procedure ManipulaElementosTela(Situacao: integer; Sender: TObject);
    Procedure TimerInterfaceTimer(Sender: TObject);
    Procedure TimerSituacaoBotaoTimer(Sender: TObject);
  Private

  Public

  End;

Var
  frmManutencaoReferencia: TfrmManutencaoReferencia;
  situacao: integer; //situacao = 1 (incluir) / 2 (alterar) / 3 (consultar) / 4 (exclusão)

Implementation

{$R *.lfm}

{ TfrmManutencaoReferencia }

Procedure TfrmManutencaoReferencia.bbtnSairClick(Sender: TObject);
Begin
  frmManutencaoReferencia.Close;
End;

Procedure TfrmManutencaoReferencia.bbtnCadastrarClick(Sender: TObject);
Begin
  //Cadastro
  situacao := 1;
  ManipulaElementosTela(1, frmManutencaoReferencia);
End;

Procedure TfrmManutencaoReferencia.bbtnAlterarClick(Sender: TObject);
Begin
  //Alteração
  situacao := 2;
  ManipulaElementosTela(2, frmManutencaoReferencia);
End;

Procedure TfrmManutencaoReferencia.bbtnCancelarClick(Sender: TObject);
Begin
  //Cancelamento das ações
  situacao := 3;
  If(DataSourceAuxiliarReferencia.DataSet.RecordCount > 0) then
  Begin
    ManipulaElementosTela(3, frmManutencaoReferencia);
  End
  Else
  Begin
    ManipulaElementosTela(0, frmManutencaoReferencia);
  End;
End;

Procedure TfrmManutencaoReferencia.bbtnExcluirClick(Sender: TObject);
Var
  Id_Referencia: integer;
  RegistroVinculado: integer;
Begin
  situacao := 4;

  If(Application.MessageBox('Confirma a exclusão desse registro?', 'Confirmação',
                                      MB_YESNO + MB_ICONQUESTION)) = IDYES then
  Begin
    Id_Referencia := DMPrincipal.ZQueryReferencia.FieldByName('REFERENCIA_LANCAMENTO_DESPESAS_ID').AsInteger;

    Try
      RegistroVinculado := verificar_vinculo_referencia(DMPrincipal.ZQueryAux, Id_Referencia);

      If(RegistroVinculado = 0) then
      Begin
        excluir_referencia(DMPrincipal.ZQueryAux, Id_Referencia);
        Application.MessageBox('Registro excluído com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
      End
      Else
      Begin
        Application.MessageBox('Este registro possui vínculos com outros objetos na base de dados! Exclusão não possibilitada.', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
      End;
    Except
      Application.MessageBox('Erro ao realizar a exclusão do registro!', 'Aviso!', MB_OK + MB_ICONERROR);
      Exit;
    End;

    exibir_referencia(DMPrincipal.ZQueryReferencia);
  End;

  situacao := 3;
  ManipulaElementosTela(3, frmManutencaoReferencia);
End;

Procedure TfrmManutencaoReferencia.bbtnGravarClick(Sender: TObject);
Begin
  //Validação inicial
  If(edtMes.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    If(edtMes.CanFocus) then
     edtMes.SetFocus;
    Exit;
  End
  Else If(edtAno.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    If(edtAno.CanFocus) then
     edtAno.SetFocus;
    Exit;
  End;

  //Gravar o registro
  Case situacao of
  1: //Cadastro
    Begin
      Try
        incluir_referencia(DMPrincipal.ZQueryAux, StrToInt(edtMes.Text), StrToInt(edtAno.Text));
        Application.MessageBox('Cadastro realizado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização.
        exibir_referencia(DMPrincipal.ZQueryReferencia);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoReferencia);
      Except
        Application.MessageBox('Erro ao realizar o cadastro!', 'Aviso!', MB_OK + MB_ICONERROR);
        Exit;
      End;
    End;
  2: //Edição
    Begin
      Try
        alterar_referencia(DMPrincipal.ZQueryAux, StrToInt(edtMes.Text), StrToInt(edtAno.Text), StrToInt(edtCodigo.Text));
        Application.MessageBox('Registro alterado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização.
        exibir_referencia(DMPrincipal.ZQueryReferencia);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoReferencia);
      Except
        Application.MessageBox('Erro ao realizar a edição do registro!', 'Aviso!', MB_OK + MB_ICONERROR);
        Exit;
      End;
    End;
  End; //case
End;

Procedure TfrmManutencaoReferencia.DataSourceAuxiliarReferenciaDataChange(
  Sender: TObject; Field: TField);
Begin
  Try
    BancoParaInterface;
  Except
    Application.MessageBox('Erro ao preencher os dados na interface!', 'Aviso!', MB_OK + MB_ICONERROR);
  End;
End;

Procedure TfrmManutencaoReferencia.BancoParaInterface;
Begin
  edtCodigo.Text := DMPrincipal.ZQueryReferencia.FieldByName('REFERENCIA_LANCAMENTO_DESPESAS_ID').AsString;
  edtMes.Text    := DMPrincipal.ZQueryReferencia.FieldByName('MES').AsString;
  edtAno.Text    := DMPrincipal.ZQueryReferencia.FieldByName('ANO').AsString;
End;

Procedure TfrmManutencaoReferencia.FormShow(Sender: TObject);
Begin
  TimerInterface.Enabled     := True;
  TimerSituacaoBotao.Enabled := True;
  Try
    exibir_referencia(DMPrincipal.ZQueryReferencia);
    situacao := 3;

    If(DataSourceAuxiliarReferencia.DataSet.RecordCount > 0) then
    Begin
      ManipulaElementosTela(3, frmManutencaoReferencia);
    End
    Else
    Begin
      ManipulaElementosTela(0, frmManutencaoReferencia);
    End;
  Except
    Application.MessageBox('Erro ao listar as referências cadastradas!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmManutencaoReferencia.ManipulaElementosTela(Situacao: integer; Sender: TObject);
Begin
  If (DataSourceAuxiliarReferencia.DataSet.RecordCount > 0) and (Situacao <> 2) then
  Begin
    DataSourceAuxiliarReferencia.DataSet.First;
  End;

  Case Situacao of
  0: //Situação normal da interface;
     Begin
       bbtnCadastrar.Enabled := True;
       bbtnAlterar.Enabled   := False;
       bbtnExcluir.Enabled   := False;

       bbtnGravar.Enabled    := False;
       bbtnCancelar.Enabled  := False;

       bbtnSair.Enabled      := True;

       edtCodigo.Enabled     := False;
       edtMes.Enabled        := False;
       edtAno.Enabled        := False;

       edtCodigo.Text        := '0';
       edtMes.Text           := '';
       edtAno.Text           := '';

       DBGridReferencias.Enabled := True;
     End;
  1: //Situação de cadastro
     Begin
       bbtnCadastrar.Enabled := False;
       bbtnAlterar.Enabled   := False;
       bbtnExcluir.Enabled   := False;

       bbtnGravar.Enabled    := True;
       bbtnCancelar.Enabled  := True;

       bbtnSair.Enabled      := False;

       edtCodigo.Enabled     := True;
       edtMes.Enabled        := True;
       edtAno.Enabled        := True;

       edtCodigo.Text        := '0';
       edtMes.Text           := '';
       edtAno.Text           := '';

       If(edtMes.CanFocus) then
        edtMes.SetFocus;

       DBGridReferencias.Enabled := False;
     End;
  2: //Situação de alteração.
     Begin
       bbtnCadastrar.Enabled := False;
       bbtnAlterar.Enabled   := False;
       bbtnExcluir.Enabled   := False;

       bbtnGravar.Enabled    := True;
       bbtnCancelar.Enabled  := True;

       bbtnSair.Enabled      := False;

       edtCodigo.Enabled     := True;
       edtMes.Enabled        := True;
       edtAno.Enabled        := True;

       If(edtMes.CanFocus) then
        edtMes.SetFocus;

       DBGridReferencias.Enabled := False;
     End;
  3: //Situação de consulta com dados.
     Begin
       bbtnCadastrar.Enabled := True;
       bbtnAlterar.Enabled   := True;
       bbtnExcluir.Enabled   := True;

       bbtnGravar.Enabled    := False;
       bbtnCancelar.Enabled  := False;

       bbtnSair.Enabled      := True;

       edtCodigo.Enabled     := False;
       edtMes.Enabled        := False;
       edtAno.Enabled        := False;

       DBGridReferencias.Enabled := True;
     End;
  End; //case
End;

Procedure TfrmManutencaoReferencia.TimerInterfaceTimer(Sender: TObject);
Begin
  Case situacao Of
  1: //Cadastrando
    Begin
      lblStatus.Caption    := 'CADASTRANDO REGISTRO...';
      lblStatus.Font.Color := clGreen;
    End;
  2: //Alterando
    Begin
      lblStatus.Caption    := 'ALTERANDO REGISTRO...';
      lblStatus.Font.Color := clYellow;
    End;
  3: //Consultando
    Begin
      lblStatus.Caption    := 'CONSULTANDO REGISTROS...';
      lblStatus.Font.Color := clBlue;
    End;
  4: //Exclusão de registro
    Begin
      lblStatus.Caption    := 'EXCLUSÃO DE REGISTROS...';;
      lblStatus.Font.Color := clRed;
    End;
  End; //case

  If(lblStatus.Visible = False) then
  Begin
    lblStatus.Visible  := True;
  End
  Else
  Begin
    lblStatus.Visible  := False;
  End;
End;

Procedure TfrmManutencaoReferencia.TimerSituacaoBotaoTimer(Sender: TObject);
Begin
  //Analisando a tela para verificar se os botões deverão ser desabilitados.
  If(DataSourceAuxiliarReferencia.DataSet.RecordCount <= 0) then
  Begin
    bbtnAlterar.Enabled := False;
    bbtnExcluir.Enabled := False;
  End;
End;

End.

