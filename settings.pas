unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin,IniFiles;

type

  { TForm2 }

  TForm2 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
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
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    function WriteSettings():boolean;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  unit1;

{ TForm2 }
{$R *.lfm}


procedure TForm2.FormShow(Sender: TObject);
var
  Ini: TIniFile;
  i: Integer;
  path: string;
begin
  If not form1.ReadSettings() then
    begin
     showmessage('Файл настроек НЕ НАЙДЕН !'+#13+'Будет создан файл настроек со значениями по умолчанию');
     form1.WriteDefSettings();
     form1.WriteDefServer();
    end;

  form2.SpinEdit1.Value:=Sett.uploadtime;
  form2.SpinEdit2.Value:=Sett.downloadtime;
  form2.Edit1.Text:=Sett.cBase;
  form2.Edit2.Text:=Sett.cHost;
  form2.SpinEdit3.Value:=Sett.nPort;
  form2.Edit4.Text:=Sett.cUser;
  form2.Edit5.Text:=Sett.cPass;
  form2.CheckBox3.Checked:=Sett.fixempty;
  form2.CheckBox4.Checked:=Sett.fixroute;
  form2.CheckBox5.Checked:=Sett.fixdocs;
  form2.CheckBox6.Checked:=Sett.fixvse;
   //form2.Label48.Caption := 'Версия:'+MajorNum+'.'+MinorNum+'.'+RevisionNum+'.'+BuildNum;//версия программы

end;


function TForm2.WriteSettings():boolean;
var
    Ini: TIniFile;
    i: Integer;
    path: string;
begin
    result:=false;
    path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
    Ini := TIniFile.Create(path);
    try
      Ini.WriteString('base_connection','cBase',form2.Edit1.Text);
      Ini.WriteString('base_connection','cUser',form2.Edit4.Text);
      Ini.WriteString('base_connection','cPass',form2.Edit5.Text);
      Ini.WriteString('base_connection','cHost',form2.Edit2.Text);
      Ini.WriteInteger('base_connection','nPort',form2.SpinEdit3.Value);
      Ini.WriteString('contact','countryid','185');
      Ini.WriteString('contact','countryname','Россия');
      Ini.WriteInteger('counts','nsheddays',4);
      Ini.WriteInteger('counts','limit_attempt',2);
      Ini.WriteInteger('counts','maxz',7);
      Ini.WriteInteger('counts','downloadtime',form2.SpinEdit2.value);
      Ini.WriteInteger('counts','uploadtime',form2.SpinEdit1.value);
      Sett.fixempty:=form2.CheckBox3.Checked;
      Sett.fixroute:=form2.CheckBox4.Checked;
      Sett.fixdocs:=form2.CheckBox5.Checked;
      Sett.fixvse:=form2.CheckBox6.Checked;
      Ini.WriteBool('fix','fix_empty',Sett.fixempty);
      Ini.writeBool('fix','lost_route',Sett.fixroute);
      Ini.writeBool('fix','wrong_docs',Sett.fixdocs);
      Ini.writeBool('fix','fix_others',Sett.fixvse);
    finally
      Ini.Free;
    end;
    result:=true;
end;


procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //лог приема
   If form2.CheckBox1.Checked then
    Sett.lreceive_log:=1
    else
      Sett.lreceive_log:=0;
   //лог передачи
   If form2.CheckBox2.Checked then
    Sett.lsend_log:=1
    else
      Sett.lsend_log:=0;

   form2.WriteSettings();
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;



procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  If key=27 then Self.Close;
end;




end.

