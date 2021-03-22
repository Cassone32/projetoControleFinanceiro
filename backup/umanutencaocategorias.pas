Unit uManutencaoCategorias;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, DBGrids, udm, LCLType, uFuncoes;

Type

  { TfrmManutencaoCategorias }

  TfrmManutencaoCategorias = class(TForm)
    bbtnSair: TBitBtn;
    bbtnCancelar: TBitBtn;
    bbtnGravar: TBitBtn;
    bbtnCadastrar: TBitBtn;
    bbtnAlterar: TBitBtn;
    bbtnExcluir: TBitBtn;
    DataSourceAuxiliarCategorias: TDataSource;
    DBGridCategorias: TDBGrid;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
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
    Procedure DataSourceAuxiliarCategoriasDataChange(Sender: TObject;
      Field: TField);
    Procedure FormShow(Sender: TObject);
    Procedure ManipulaElementosTela(Situacao: integer; Sender: TObject);
    Procedure TimerInterfaceTimer(Sender: TObject);
    Procedure BancoParaInterface;
    Procedure TimerSituacaoBotaoTimer(Sender: TObject);
  Private

  Public

  End;

Var
  frmManutencaoCategorias: TfrmManutencaoCategorias;
  situacao: integer; //situacao = 1 (incluir) / 2 (alterar) / 3 (consultar) / 4 (exclusão)

Implementation

{$R *.lfm}

{ TfrmManutencaoCategorias }

Procedure TfrmManutencaoCategorias.bbtnSairClick(Sender: TObject);
Begin
  frmManutencaoCategorias.Close;
End;

Procedure TfrmManutencaoCategorias.DataSourceAuxiliarCategoriasDataChange(
  Sender: TObject; Field: TField);
Begin
  Try
    BancoParaInterface;
  Except
    Application.MessageBox('Erro ao preencher os dados na interface!', 'Aviso!', MB_OK + MB_ICONERROR);
  End;
End;

Procedure TfrmManutencaoCategorias.bbtnCadastrarClick(Sender: TObject);
Begin
  //Cadastro
  situacao := 1;
  ManipulaElementosTela(1, frmManutencaoCategorias);
End;

Procedure TfrmManutencaoCategorias.bbtnAlterarClick(Sender: TObject);
Begin
  //Alteração
  situacao := 2;
  ManipulaElementosTela(2, frmManutencaoCategorias);
End;

Procedure TfrmManutencaoCategorias.bbtnCancelarClick(Sender: TObject);
Begin
  //Cancelamento das ações
  situacao := 3;
  If(DataSourceAuxiliarCategorias.DataSet.RecordCount > 0) then
  Begin
    ManipulaElementosTela(3, frmManutencaoCategorias);
  End
  Else
  Begin
    ManipulaElementosTela(0, frmManutencaoCategorias);
  End;
End;

Procedure TfrmManutencaoCategorias.bbtnExcluirClick(Sender: TObject);
Var
  Id_Categoria: integer;
  RegistroVinculado: integer;
Begin
  situacao := 4;

  If(Application.MessageBox('Confirma a exclusão desse registro?', 'Confirmação',
                                      MB_YESNO + MB_ICONQUESTION)) = IDYES then
  Begin
    Id_Categoria := DMPrincipal.ZQueryCategorias.FieldByName('CATEGORIA_DESPESAS_ID').AsInteger;

    Try
      RegistroVinculado := verificar_vinculo_categoria(DMPrincipal.ZQueryAux, Id_Categoria);

      If(RegistroVinculado = 0) then
      Begin
        excluir_categorias(DMPrincipal.ZQueryAux, Id_Categoria);
        Application.MessageBox('Registro excluído com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);
      End
      Else
      Begin

      End;
    Except
      Application.MessageBox('Erro ao realizar a exclusão do registro!', 'Aviso!', MB_OK + MB_ICONERROR);
      Exit;
    End;

    exibir_categorias(DMPrincipal.ZQueryCategorias);
  End;

  situacao := 3;
  ManipulaElementosTela(3, frmManutencaoCategorias);
End;

Procedure TfrmManutencaoCategorias.bbtnGravarClick(Sender: TObject);
Begin
  //Validação inicial.
  If(edtDescricao.Text = '') then
  Begin
    Application.MessageBox('Campo obrigatório não preenchido!', 'Validação!', MB_OK + MB_ICONWARNING);
    If(edtDescricao.CanFocus) then
     edtDescricao.SetFocus;
    Exit;
  End;

  //Gravar o registro
  Case situacao of
  1: //Cadastro
    Begin
      Try
        incluir_categorias(DMPrincipal.ZQueryAux, edtDescricao.Text);
        Application.MessageBox('Cadastro realizado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização.
        exibir_categorias(DMPrincipal.ZQueryCategorias);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoCategorias);
      Except
        Application.MessageBox('Erro ao realizar o cadastro!', 'Aviso!', MB_OK + MB_ICONERROR);
        Exit;
      End;
    End;
  2: //Edição
    Begin
      Try
        alterar_categorias(DMPrincipal.ZQueryAux, edtDescricao.Text, StrToInt(edtCodigo.Text));
        Application.MessageBox('Registro alterado com sucesso!', 'Aviso!', MB_OK + MB_ICONEXCLAMATION);

        //Atualização
        exibir_categorias(DMPrincipal.ZQueryCategorias);
        situacao := 3;
        ManipulaElementosTela(3, frmManutencaoCategorias);
      Except
        Application.MessageBox('Erro ao realizar a edição do registro!', 'Aviso!', MB_OK + MB_ICONERROR);
        Exit;
      End;
    End;
  End; //Case

End;

Procedure TfrmManutencaoCategorias.ManipulaElementosTela(Situacao: integer; Sender: TObject);
Begin
  If (DataSourceAuxiliarCategorias.DataSet.RecordCount > 0) and (Situacao <> 2) then
  Begin
    DataSourceAuxiliarCategorias.DataSet.First;
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
       edtDescricao.Enabled  := False;

       edtCodigo.Text        := '0';
       edtDescricao.Text     := '';

       DBGridCategorias.Enabled := True;
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
       edtDescricao.Enabled  := True;

       edtCodigo.Text        := '0';
       edtDescricao.Text     := '';

       If(edtDescricao.CanFocus) then
        edtDescricao.SetFocus;

       DBGridCategorias.Enabled := False;
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
       edtDescricao.Enabled  := True;

       If(edtDescricao.CanFocus) then
        edtDescricao.SetFocus;

       DBGridCategorias.Enabled := False;
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
       edtDescricao.Enabled  := False;

       DBGridCategorias.Enabled := True;
     End;
  End; //case
End;

Procedure TfrmManutencaoCategorias.TimerInterfaceTimer(Sender: TObject);
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

Procedure TfrmManutencaoCategorias.FormShow(Sender: TObject);
Begin
  TimerInterface.Enabled     := True;
  TimerSituacaoBotao.Enabled := True;
  Try
    exibir_categorias(DMPrincipal.ZQueryCategorias);
    situacao := 3;

    If(DataSourceAuxiliarCategorias.DataSet.RecordCount > 0) then
    Begin
      ManipulaElementosTela(3, frmManutencaoCategorias);
    End
    Else
    Begin
      ManipulaElementosTela(0, frmManutencaoCategorias);
    End;
  Except
    Application.MessageBox('Erro ao listar as categorias cadastradas!', 'Aviso!', MB_OK + MB_ICONERROR);
    Exit;
  End;
End;

Procedure TfrmManutencaoCategorias.BancoParaInterface;
Begin
  edtCodigo.Text    := DMPrincipal.ZQueryCategorias.FieldByName('CATEGORIA_DESPESAS_ID').AsString;
  edtDescricao.Text := DMPrincipal.ZQueryCategorias.FieldByName('DESCRICAO').AsString;
End;

Procedure TfrmManutencaoCategorias.TimerSituacaoBotaoTimer(Sender: TObject);
Begin
  //Analisando a tela para verificar se os botões deverão ser desabilitados.
  If(DataSourceAuxiliarCategorias.DataSet.RecordCount <= 0) then
  Begin
    bbtnAlterar.Enabled := False;
    bbtnExcluir.Enabled := False;
  End;
End;

End.

