Unit udm;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, db, ZConnection, ZDataset;

Type

  { TDMPrincipal }

  TDMPrincipal = class(TDataModule)
    DataSourceReferencia: TDataSource;
    DataSourceCategorias: TDataSource;
    DataSourceStatus: TDataSource;
    ZConexaoPrincipal: TZConnection;
    ZQueryReferencia: TZQuery;
    ZQueryCategorias: TZQuery;
    ZQueryAux: TZQuery;
    ZQueryStatus: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  Private

  Public

  End;

Var
  DMPrincipal: TDMPrincipal;

Implementation

{$R *.lfm}

{ TDMPrincipal }

procedure TDMPrincipal.DataModuleCreate(Sender: TObject);
begin

end;

End.

