Unit uManutencaoStatus;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DBGrids, udm, uFuncoes, LCLType;

Type

  { TfrmManutencaoStatus }

  TfrmManutencaoStatus = class(TForm)
    bbtnSair: TBitBtn;
    bbtnCadastrar: TBitBtn;
    bbtnAlterar: TBitBtn;
    bbtnCancelar: TBitBtn;
    bbtnGravar: TBitBtn;
    bbtnExcluir: TBitBtn;
    DataSourceAuxiliarStatus: TDataSource;
    DBGridStatus: TDBGrid;
    edtDescricao: TEdit;
    edtCodigo: TEdit;
    grbCadastroEdicao: TGroupBox;
    grbGridRegistros: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblStatus: TLabel;
    pnlGrbGridRegistros: TPanel;
    pnlBodyGroup: TPanel;
    pnlBody: TPanel;
    pnlFooter: TPanel;
    pnlHead: TPanel;
    TimerSituacaoBotao: TTimer;
    TimerInterface: TTimer;

    Procedure bbtnAlterarClick(Sender: TObject);
    Procedure bbtnCadastrarClick(Sender: TObject);
    Procedure bbtnCancelarClick(Sender: TObject);
    Procedure bbtnExcluirClick(Sender: TObject);
    Procedure bbtnGravarClick(Sender: TObject);
    Procedure bbtnSairClick(Sender: TObject);
    Procedure DataSourceAuxiliarStatusDataChange(Sender: TObject; Field: TField
      );
    Procedure FormShow(Sender: TObject);
    Procedure ManipulaElementosTela(Situacao: integer; Sender: TObject);
    Procedure BancoParaInterface;
    Procedure TimerInterfaceTimer(Sender: TObject);
    Procedure TimerSituacaoBotaoTimer(Sender: TObject);
  Private

  Public
  End;

Var
  frmManutencaoStatus: TfrmManutencaoStatus;
  situacao: integer; //situacao = 1 (incluir) / 2 (alterar) / 3 (consultar) / 4 (exclusão)

Implementation

{$R *.lfm}

{ TfrmManutencaoStatus }

Procedure TfrmManutencaoStatus.bbtnSairClick(Sender: TObject);
Begin
  frmManutencaoStatus.Close;
End;

Procedure TfrmManutencaoStatus.DataSourceAuxiliarStatusDataChange(
  Sender: TObject; Field: TField);
Begin
  Try
    BancoParaInterface;
  Except
    Application.MessageBox('Erro ao preencher os dados na interface!', 'Aviso', MB_OK + MB_ICONERROR);
  End;
End;

Procedure TfrmManutencaoStatus.bbtnAlterarClick(Sender: TObject);
Begin
  //Alteração
  situacao := 2;
  ManipulaElementosTela(2, frmManutencaoStatus);
End;

Procedure TfrmManutencaoStatus.bbtnCadastrarClick(Sender: TObject);
Begin
  //Cadastro
  situacao := 1;
  ManipulaElementosTela(1, frmManutencaoStatus);
End;

Procedure TfrmManutencaoStatus.bbtnCancelarClick(Sender: TObject);
Begin
  //Cancelamento das ações
  situacao := 3;
  If(DataSourceAuxiliarStatus.DataSet.RecordCount > 0) then
  Begin
    ManipulaElementosTela(3, frmManutencaoStatus);
  End
  Else
  Begin
    ManipulaElementosTela(0, frmManutencaoStatus);
  End;
End;

Procedure TfrmManutencaoStatus.bbtnExcluirClick(Sender: TObject);
Var
  Id_Status: integer;
  RegistroVinculado: integer;
Begin
  situacao := 4;
  If(Application.MessageBox('Confirma a exclusão desse registro?', 'Confirmação',
                                      MB_YESNO + MB_ICONQUESTION)) = IDYES then
  Begin
    Id_Status := DMPrincipal.ZQueryStatus.FieldByName('STATUS_DESPESAS_ID').AsInteger;

    Try
      RegistroVinculado := verificar_vinculo_status(DMPrincipal.ZQueryAux, Id_Status);

      If(RegistroVinculado = 0) then
      Begin
        excluir_status(DMPrincipal.ZQueryAux, Id_Status);
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

    exibir_status(DMPrincipal.ZQueryStatus);
  End;

  situacao := 3;
  ManipulaElementosTela(3, frmManutencaoStatus);
End;

Procedure TfrmManutencaoStatus.bbtnGravarClick(Sender: TObject);
Begin
  //Validação inicial
  If(edtDescricao.Text = '') then
  Begin
   Application.MessageBox('Campo obrigatório não preenchido!', 'Validação', MB_OK + MB_ICONWARNING);
   If(edtDescricao.CanFocus) then
    edtDescricao.SetFocus;
   Exit;
  End;

  //Gravar o registro
  Case situacao of
  1: //Cadastro
    Begin
      //Salvar STATUS
      Try
        incluir_status(DMPrincipal.ZQueryAux, edtDescricao.Text);
        Application.MessageBox('Cadastro realizado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização
        exibir_status(DMPrincipal.ZQueryStatus);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoStatus);
      Except
        Application.MessageBox('Erro ao realizar o cadastro!', 'Aviso!', MB_OK + MB_ICONERROR);
        Exit;
      End;
    End;
  2: //Edição
    Begin
      //Salvar STATUS
      Try
        alterar_status(DMPrincipal.ZQueryAux, edtDescricao.Text, StrToInt(edtCodigo.Text));
        Application.MessageBox('Registro alterado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização
        exibir_status(DMPrincipal.ZQueryStatus);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoStatus);
      Except
        Application.MessageBox('Erro ao realizar a edição do registro!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
        Exit;
      End;
    End;
  End; //case
End;

Procedure TfrmManutencaoStatus.FormShow(Sender: TObject);
Begin
  TimerInterface.Enabled          := True;
  TimerSituacaoBotao.Enabled      := True;
  Try
    exibir_status(DMPrincipal.ZQueryStatus);
    situacao := 3;

    If(DataSourceAuxiliarStatus.DataSet.RecordCount > 0) then
    Begin
      ManipulaElementosTela(3, frmManutencaoStatus);
    End
    Else
    Begin
      ManipulaElementosTela(0, frmManutencaoStatus);
    End;
  Except
    Application.MessageBox('Erro ao listar os status cadastrados!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmManutencaoStatus.ManipulaElementosTela(Situacao: integer; Sender: TObject);
Begin
  If (DataSourceAuxiliarStatus.DataSet.RecordCount > 0) and (situacao <> 2)  then
  Begin
    DataSourceAuxiliarStatus.DataSet.First;
  End;

  Case Situacao of
  0: //Situação normal da interface
    Begin
      bbtnCadastrar.Enabled := True;
      bbtnAlterar.Enabled   := False;
      bbtnExcluir.Enabled   := False;

      bbtnGravar.Enabled    := False;
      bbtnCancelar.Enabled  := False;

      bbtnSair.Enabled      := True;

      edtCodigo.Enabled     := False;
      edtDescricao.Enabled  := False;

      edtCodigo.Text        := '0';
      edtDescricao.Text     := '';

      DBGridStatus.Enabled  := True;
    End;
  1: //Situação de cadastro
    Begin
      bbtnCadastrar.Enabled := False;
      bbtnAlterar.Enabled   := False;
      bbtnExcluir.Enabled   := False;

      bbtnGravar.Enabled    := True;
      bbtnCancelar.Enabled  := True;

      bbtnSair.Enabled      := False;

      edtCodigo.Text        := '0';
      edtDescricao.Text     := '';

      edtCodigo.Enabled     := True;
      edtDescricao.Enabled  := True;

      If(edtDescricao.CanFocus) then
       edtDescricao.SetFocus;

      DBGridStatus.Enabled  := False;
    End;
  2: //Situação de edição de registro
    Begin
      bbtnCadastrar.Enabled := False;
      bbtnAlterar.Enabled   := False;
      bbtnExcluir.Enabled   := False;

      bbtnGravar.Enabled    := True;
      bbtnCancelar.Enabled  := True;

      bbtnSair.Enabled      := False;

      edtCodigo.Enabled     := True;
      edtDescricao.Enabled  := True;

      If(edtDescricao.CanFocus) then
       edtDescricao.SetFocus;

      DBGridStatus.Enabled  := False;
    End;
  3: //Situação inicial com dados no DataSet
    Begin
      bbtnCadastrar.Enabled := True;
      bbtnAlterar.Enabled   := True;
      bbtnExcluir.Enabled   := True;

      bbtnGravar.Enabled    := False;
      bbtnCancelar.Enabled  := False;
      bbtnSair.Enabled      := True;

      edtCodigo.Enabled     := False;
      edtDescricao.Enabled  := False;

      DBGridStatus.Enabled  := True;
    End;
  End; //case
End;

Procedure TfrmManutencaoStatus.BancoParaInterface;
Begin
  edtCodigo.Text    := DMPrincipal.ZQueryStatus.FieldByName('STATUS_DESPESAS_ID').AsString;
  edtDescricao.Text := DMPrincipal.ZQueryStatus.FieldByName('DESCRICAO').AsString;
End;

Procedure TfrmManutencaoStatus.TimerInterfaceTimer(Sender: TObject);
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

Procedure TfrmManutencaoStatus.TimerSituacaoBotaoTimer(Sender: TObject);
Begin
  //Analisando a tela para verificar se os botões deverão ser desabilitados.
  If(DataSourceAuxiliarStatus.DataSet.RecordCount <= 0) then
  Begin
    bbtnAlterar.Enabled := False;
    bbtnExcluir.Enabled := False;
  End;
End;

End.

