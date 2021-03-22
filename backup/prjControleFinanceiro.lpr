program prjControleFinanceiro;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uPrincipal, uDM, zcomponent, uManutencaoStatus, uFuncoes,
  uManutencaoCategorias, uManutencaoReferencia, uManutencaoLancamentos, uLancamentosDespesas
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TfrmManutencaoStatus, frmManutencaoStatus);
  Application.CreateForm(TfrmManutencaoCategorias, frmManutencaoCategorias);
  Application.CreateForm(TfrmManutencaoReferencia, frmManutencaoReferencia);
  Application.CreateForm(TfrmManutencaoLancamentos, frmManutencaoLancamentos);
  Application.CreateForm(TfrmLancamentosDespesas, frmLancamentosDespesas);
  Application.Run;
end.

