Unit uPrincipal;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, uManutencaoStatus, uManutencaoCategorias, uManutencaoReferencia,
  uManutencaoLancamentos;

Type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    bbtnStatusDespesas: TBitBtn;
    bbtnCategoriaDespesas: TBitBtn;
    bbtnLancamentoDespesas: TBitBtn;
    bbtnReferenciaLancamentoDespesas: TBitBtn;
    Label1: TLabel;
    lblDataHora: TLabel;
    pnlFooter: TPanel;
    pnlCentral: TPanel;
    TimerPrincipal: TTimer;
    Procedure bbtnCategoriaDespesasClick(Sender: TObject);
    Procedure bbtnLancamentoDespesasClick(Sender: TObject);
    Procedure bbtnReferenciaLancamentoDespesasClick(Sender: TObject);
    Procedure bbtnStatusDespesasClick(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure TimerPrincipalTimer(Sender: TObject);
  Private

  Public

  End;

Var
  frmPrincipal: TfrmPrincipal;

Implementation

{$R *.lfm}

{ TfrmPrincipal }

Procedure TfrmPrincipal.bbtnCategoriaDespesasClick(Sender: TObject);
Begin
  {Abertura formulário de manutenção de categorias das despesas.}
  Try
    Application.CreateForm(TfrmManutencaoCategorias, frmManutencaoCategorias);
    frmManutencaoCategorias.ShowModal;
  Finally
    frmManutencaoCategorias.Close;
  End;
End;

Procedure TfrmPrincipal.bbtnLancamentoDespesasClick(Sender: TObject);
Begin
  {Abertura formulário de manutenção de lançamentos.}
  Try
    Application.CreateForm(TfrmManutencaoLancamentos, frmManutencaoLancamentos);
    frmManutencaoLancamentos.ShowModal;
  Finally
    frmManutencaoLancamentos.Close;
  End;

End;

Procedure TfrmPrincipal.bbtnReferenciaLancamentoDespesasClick(Sender: TObject);
Begin
  {Abertura formulário de manutenção de referência despesas.}
  Try
    Application.CreateForm(TfrmManutencaoReferencia, frmManutencaoReferencia);
    frmManutencaoReferencia.ShowModal;
  Finally
    frmManutencaoReferencia.Close;
  End;
End;

Procedure TfrmPrincipal.bbtnStatusDespesasClick(Sender: TObject);
Begin
  {Abertura formulário de manutenção de status despesas.}
  Try
    Application.CreateForm(TfrmManutencaoStatus, frmManutencaoStatus);
    frmManutencaoStatus.ShowModal;
  Finally
    frmManutencaoStatus.Close;
  End;
End;

Procedure TfrmPrincipal.FormShow(Sender: TObject);
Begin
End;

Procedure TfrmPrincipal.TimerPrincipalTimer(Sender: TObject);
Begin
  {Inicia o contador e insere a data e hora.}
  lblDataHora.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now);
  {Desabilita o contador.}
  TimerPrincipal.Enabled := False;
End;

End.

