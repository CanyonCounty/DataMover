program DBMover;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uDBWrapper in 'uDBWrapper.pas',
  uOptions in 'uOptions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DB Mover';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
