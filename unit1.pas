unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateTimePicker, ZConnection, ZDataset, LazFileUtils,
 // FileUtil,
  lNetComponents, lNEt,
  lFTP, version_info,
  Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, Buttons, EditBtn, ActnList, process,
  //{$IFDEF MSWINDOWS} windows, {$ENDIF}
 {$IFDEF UNIX}  unixutil, {$ENDIF}

  dateutils, IniFiles,
  //LCLproc,
  LazUTF8,
  DOM, XMLRead, XMLWrite, XMLConf, settings;


type

   TSiteInfo = record
    Site: string;
    Host: string;
    Port: string;
    path: string;
    user: string;
    pass: string;
    Anonymous: Boolean;
    ldir: string;
    Number: Integer;
  end;


  TSettingsPDP = record
  //timeout_wait=2;
  maxz: integer; //=7; //кол-во попыток ожидания дисконнекта предыдущего запроса
  limit_attempt: integer; //попытки отправки файла
  countryid: string;
  countryname: string; //='Россия';
  downloadtime: integer; //35;
  uploadtime: integer; //=10;
  nSheddays: integer; //=-4; //актуальность действия переданного ранее расписания при повтороной передаче
  cUser: string; //='platforma';
  cPass: string; //'19781985';
  cHost: string; //='172.27.1.5';
  nPort: integer; //=5432;
  cBase: string; // ='platforma';
  lreceive_log: integer; //писать лог о приеме квитаний
  lsend_log: integer; //писать лог об отправке данных
  idpoint_station: integer; //id поинт сервера где установлена коробочка (параметр station_type справочника points)
  pathapp:string;
  nident:string;
  nokato:string;
  fixempty:boolean;
  fixvse:boolean;
  fixdocs:boolean;
  fixroute:boolean;
  end;


  { TForm1 }

  TForm1 = class(TForm)
    accConnect: TAction;
    accDisconnect: TAction;
    accSiteManager: TAction;
    ActionList1: TActionList;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    FileNameEdit1: TFileNameEdit;
    FTP: TLFTPClientComponent;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
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
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MemoLog: TMemo;
    OpenDialog1: TOpenDialog;
    Process1: TProcess;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SBar: TStatusBar;
    Shape1: TShape;
    Shape2: TShape;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StaticText1: TStaticText;
    TCountDown: TTimer;
    TimerControl: TTimer;
    TimerDelete: TTimer;
    TimerReceive: TTimer;
    TimerRegular: TTimer;
    TimerSend: TTimer;
    XMLConfig1: TXMLConfig;
    ZConnection1: TZConnection;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure accConnectExecute(Sender: TObject);
    procedure accDisconnectExecute(Sender: TObject);
    //procedure accSiteManagerExecute(Sender: TObject);
    procedure Bevel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Bevel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    //procedure ButtonGetFileClick(Sender: TObject);
    //procedure ButtonPutFileClick(Sender: TObject);
    function Connect(ZCon:TZConnection;serv:integer):boolean;
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure TCountDownTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FTPConnect(aSocket: TLSocket);
    procedure FTPControl(aSocket: TLSocket);
    procedure FTPError(const msg: string; aSocket: TLSocket);
    procedure FTPReceive(aSocket: TLSocket);
    procedure FTPSent(aSocket: TLSocket; const Bytes: Integer);
    procedure FTPSuccess(aSocket: TLSocket; const aStatus: TLFTPStatus);
    procedure RadioButton1Change(Sender: TObject);
    procedure TimerDeleteTimer(Sender: TObject);
    procedure TimerReceiveStartTimer(Sender: TObject);
    procedure TimerReceiveTimer(Sender: TObject);
    procedure TimerRegularTimer(Sender: TObject);
    procedure TimerSendStartTimer(Sender: TObject);
    procedure TimerSendTimer(Sender: TObject);
    //  procedure SockPutCallBack(Sender: TObject);
    //  Reason: THookSocketReason; const Value: string);
    //procedure SockGetCallBack(Sender: TObject;
    //  Reason: THookSocketReason; const Value: string);
    //function putFile(s:string):boolean;
    procedure RadioButton2Change(Sender: TObject);
    function PDPlog_new_csv(dd1:string;dd2:string;server:integer;fname:string):boolean;//запись в логи о готовности файла на отправку
    function PDPlog_new_XML(sname:string;fname:string;stampLog:string):boolean; //запись в логи о готовности справочника на отправку
    procedure PDPlog_send(fsend:string);
    procedure TimerControlTimer(Sender: TObject);
    procedure GetAnswerSprav();   //собрать ответы с сервера
    procedure PDPlog_get(fsend:string;flag:integer);
    procedure PDPlog_delete(fsend:string);
    function CntDown(tt:string):string;
    procedure GetSuccess();//успешный прием файла Ответов
    procedure SendSuccess();//успешный передача файла ПДП
    procedure ClearALL();//сброс всех состояний
    function Data_RESEND():boolean;//повторная передача файла
    function Data_RESENDempty():boolean;//повторная передача пустых файлов
    function ReadSettings():boolean;//чтение файла настроек
    function WriteDefSettings():boolean;//запись файла настроек в ини
    function WriteDefServer():boolean;  //данных данных вокзала в ини

  private
    { private declarations }
     FLastN: Integer;
    FList: TStringList;
    FFile: TFileStream;
    FDLSize: Int64;
    FDLDone: Int64;
    //FDoc: TXMLDocument;
     CreateFilePath: string;
    FDirListing: string;
    procedure UpdateSite;
    procedure Discon_FTP(ClearLog: boolean);
    function GetLocalServers():boolean;
    procedure ComboServ();
    procedure mess_log(s:string);
    function xmlparse(fpath:string;fname:string):boolean;
    function PADL(Src: string; AddSrc: string; Lg: Integer): string; // Функция добавляет символами строку до необходимого размера слева
    procedure Data_SEND(from_period:string;to_period:string;spoint:string);
    function Data_SENDempty(from_period:string;to_period:string;sname:string):boolean;
    procedure Data_GET();
    procedure SPR_SEND(mode:string);//передача справочников
    procedure Delete_old();
    //---------- ПРИЕМ ФАЙЛОВ ОТВЕТОВ -------------------------------
    procedure Files_to_get();
    procedure stop_auto_upload();
    procedure stop_auto_download();
    procedure start_auto_upload();
    procedure start_auto_download();

  public
    { public declarations }
    procedure MyExceptionHandler(Sender : TObject; E : Exception); //ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  *********
    procedure LoadLastSite;
    function SetSite(sitename:string):boolean;
    //procedure SaveOption(const ASection,AOption,AValue:string);
    //procedure SaveOption(const ASection,AOption:string; AValue:Integer);
  end;


  function TimeLocalToUTC(UT: TDateTime): TDateTime;
  function CreateXmlPoints(stamp_mode:TDateTime):boolean;
  function CreateXmlPerevoz(stamp_mode:TDateTime):boolean;
  function CreateXmlServers():boolean;
  function CreateXmlShedule(stamp_mode:TDateTime):boolean;
  //function myhost2ip(host: string): string;
  function makeCSV(date1:string;date2:string;idpoint:integer;fname:string):string;
  function ip_del_zero(ip:string):string; // Убираем нули из IP адреса
  function POSNEXT(stroka:string;substroka:string;nextpos:integer):integer;  // Возвращает позицию подстроки substroka в stroka под номером nextpos
  function GetSitePath:string;

var
  Form1: TForm1;
  Sett: TSettingsPDP;

  const

  //cBase='platforma_stav_av';
  servsize=19;
  sendsize=4;
  globaltimer=600;
  sprupdatetimes=2;
  lenarrans=4;
  maxuploadtime=30;
  waitforanswer=18;
  upperactual=80;


implementation

{$R *.lfm}




var
  //frmSites: TfrmSites;
  Site: TSiteInfo;

  //FSites: array of TSiteInfo;
  //nIdent,nOkato: string;
  uploadFile,downfile,deletefile,xml_name:string;
  n:integer;
  //points:string;
  arservers:array of array of string; //Массив доступных серверов
  arsend:array of array of string; //массив серверов, куда отправлялись данные в заданный промежуток времени
  ar_shed:array of string;
  MySettings:TFormatSettings;
  //timeout_local:integer;
  timeout_s,timeout_r:cardinal;
  active_process:boolean;
  fl_send:boolean;
  //filecode:string;
  zbusy,fl_receive,ziz,allans:integer;
  arans: array of array of string;//массив ответов
  ardel: array of array of string;//массив на удаление
  counterr,timercnt: integer;
  downall,downok,downnow,uplnow,uplall:integer;
    stamp_spr_send,    stamp_spr_send_correct,    stamp_spr_actual,
    time_main, //нижняя граница актуального периода отправки данных
    time_past, ZeroDateTime //нулевое время
      :TDateTime;
  arrans:array of array of string;
  attempt:integer;
  ftpdeny:boolean;
  readytodownload:boolean;//готовность к загрузке
  hostname:string;
  connectionfail:integer;
  MajorNum : String;
   MinorNum : String;
   RevisionNum : String;
   BuildNum : String;
   ddate:Tdate;
   timesend:TDatetime;
   mempos:tpoint;

function TForm1.WriteDefServer():boolean;
var
    Ini: TIniFile;
    //i: Integer;
    path: string;
begin
    result:=false;
    path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
    Ini := TIniFile.Create(path);
    try
      Ini.WriteString('contact','Department','');
      Ini.WriteString('contact','email','');
      Ini.WriteString('contact','fax','');
      Ini.WriteString('contact','Lastname','');
      Ini.WriteString('contact','Name','');
      Ini.WriteString('contact','Person','');
      Ini.WriteString('contact','Phone','');
      Ini.WriteString('contact','Post','');
      Ini.WriteString('contact','Surname','');
      Ini.WriteString('contact','fullName','');
      Ini.WriteString('contact','shortName','');
      Ini.WriteString('contact','latName','');
      Ini.WriteString('contact','lawAddress','');
      Ini.WriteString('contact','nearTown','');
      Ini.WriteString('contact','kladr','');
      Ini.WriteString('contact','egrul','');
      Ini.WriteString('contact','egrip','');
      Ini.WriteString('contact','egisId','');
      Ini.WriteString('contact','okato','');
    finally
      Ini.Free;
    end;
    result:=true;
end;


function TForm1.WriteDefSettings():boolean;
var
    Ini: TIniFile;
    //i: Integer;
    path: string;
begin
    result:=false;
    path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
    Ini := TIniFile.Create(path);
    try
      Ini.WriteString('base_connection','cBase','platforma');
      Ini.WriteString('base_connection','cUser','platforma');
      Ini.WriteString('base_connection','cPass','19781985');
      Ini.WriteString('base_connection','cHost','172.27.1.5');
      Ini.WriteInteger('base_connection','nPort',5432);
      Ini.WriteString('misc','countryid','185');
      Ini.WriteString('misc','countryname','Россия');
      Ini.WriteInteger('counts','nsheddays',-4);
      Ini.WriteInteger('counts','limit_attempt',2);
      Ini.WriteInteger('counts','maxz',7);
      Ini.WriteInteger('counts','downloadtime',55);
      Ini.WriteInteger('counts','uploadtime',35);
      Ini.WriteBool('fix','fix_empty',true);
      Ini.writeBool('fix','lost_route',false);
      Ini.writeBool('fix','wrong_docs',false);
      Ini.writeBool('fix','fix_others',false);
    finally
      Ini.Free;
    end;
    result:=true;
end;


function TForm1.ReadSettings():boolean;
var
  Ini: TIniFile;
  //i: Integer;
  path: string;
begin
  result:=false;
  path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
  if not FileExistsUTF8(path) then
    begin
     exit;
    end;
  Ini := TIniFile.Create(path);
  try
    Sett.pathapp := Ini.ReadString('main','pathapp', ExtractFilePath(Application.ExeName));
     //showmessage(Sett.pathapp);
    Sett.nident := Ini.ReadString('main','nident', '22013');
    Sett.nOkato := Ini.ReadString('contact','okato', '07701000');
    Sett.countryid:= Ini.ReadString('contact','countryid','185');
    Sett.countryname:= Ini.ReadString('contact','countryname','Россия');
    Sett.idpoint_station:= Ini.ReadInteger('contact','idpoint_station_Type',815);
    Sett.cBase:= Ini.ReadString('base_connection','cBase','platforma');
    Sett.cUser:= Ini.ReadString('base_connection','cUser','platforma');
    Sett.cPass:= Ini.ReadString('base_connection','cPass','19781985');
    Sett.cHost:= Ini.ReadString('base_connection','cHost','172.27.1.5');
    Sett.nPort:= Ini.ReadInteger('base_connection','nPort',5432);
    Sett.nsheddays:= Ini.ReadInteger('counts','nsheddays',-4);
    If Sett.nsheddays>0 then  Sett.nsheddays:=Sett.nsheddays*-1;
    Sett.limit_attempt:= Ini.ReadInteger('counts','limit_attempt',2);
    Sett.maxz:= Ini.ReadInteger('counts','maxz',7);
    Sett.downloadtime:= Ini.ReadInteger('counts','downloadtime',55);
    Sett.uploadtime:= Ini.ReadInteger('counts','uploadtime',35);
    //If ini.SectionExists('fix_empty') then
      //showmessage('1');
      //If Ini.Readbool('fix','fix_empty',true) then
            //showmessage('1')
        //else     showmessage('2');
    Sett.fixempty:= Ini.Readbool('fix','fix_empty',true);
    Sett.fixroute:= Ini.ReadBool('fix','lost_route',false);
    Sett.fixdocs := Ini.ReadBool('fix','wrong_docs',false);
    Sett.fixvse  := Ini.ReadBool('fix','fix_others',false);
  finally
    Ini.Free;
  end;
  result:=true;
end;


procedure TForm1.LoadLastSite;
var
  Ini: TIniFile;
  i: Integer;
  s: string;
begin
  s := extractFilePath(Application.ExeName)+'sites.ini';
  Ini := TIniFile.Create(s);
  try
    I := Ini.ReadInteger('global','lastsite', -1);
    s := 'site'+IntToStr(i);
    Site.Site := Ini.ReadString(s, 'site', '');
    Site.Host := Ini.ReadString(s, 'host', '');
    Site.Port := Ini.ReadString(s, 'port', '');
    Site.path := Ini.ReadString(s, 'path', '');
    Site.user := Ini.ReadString(s, 'user', '');
    //Site.pass := DecryptString(Ini.ReadString(s, 'pass', ''));
    Site.pass := Ini.ReadString(s, 'pass', '');
    Site.ldir := ini.ReadString(s, 'ldir', '');
    if Site.Site<>'' then
      Site.Number := I
    else
      Site.Number := 0;
  finally
    Ini.Free;
  end;
end;


 function TForm1.SetSite(sitename:string):boolean;
  var
    Ini: TIniFile;
    i,n: Integer;
    s: string;
  begin
    result:=false;
    s := extractFilePath(Application.ExeName)+'sites.ini';
    Ini := TIniFile.Create(s);
    try
      I := Ini.ReadInteger('global','sitecount', 0);
      for n:=1 to I do
      begin
      s := 'site'+IntToStr(n);
      If utf8pos(sitename,Ini.ReadString(s, 'site', ''))>0 then
      begin
      Site.Site := Ini.ReadString(s, 'site', '');
      Site.Host := Ini.ReadString(s, 'host', '');
      Site.Port := Ini.ReadString(s, 'port', '');
      Site.path := Ini.ReadString(s, 'path', '');
      Site.user := Ini.ReadString(s, 'user', '');
      //Site.pass := DecryptString(Ini.ReadString(s, 'pass', ''));
      Site.pass := Ini.ReadString(s, 'pass', '');
      Site.ldir := ini.ReadString(s, 'ldir', '');
      if Site.Site<>'' then
        Site.Number := n
      else
        Site.Number := 0;
      result:=true;
      break;
      end;
      end;
    finally
      Ini.Free;
    end;

  end;



//procedure TList.XML2List(XMLDoc: TXMLDocument; ur:string);
//var
//  iNode : IXMLNode;
//  i:integer;
//  procedure ProcessNode(
//        Node : IXMLNode);
//  var
//    cNode : IXMLNode;
//  begin
//    if Node = nil then Exit;
//    with Node do
//    begin
//      indexes.Add(DecodeText(Attributes['name']));
//      items.Add(DecodeText(Attributes['Items']));
//    end;
//
//  end; (*ProcessNode*)
//begin
//  i:=0;
//
//  indexes.Clear;
//  Items.Clear;
//
//  XMLDoc.FileName := ur;
//  XMLDoc.Active := True;
//  if XMLDoc = nil then exit;
//  iNode := XMLDoc.DocumentElement.ChildNodes.First;
//
//  while iNode <> nil do
//  begin
//    ProcessNode(iNode);
//    inc(i);
//    iNode := iNode.NextSibling;
//  end;
//
//  XMLDoc.Active := False;
//end;



procedure TForm1.Button4Click(Sender: TObject);
var
  str: string;
   n,m:integer;
  //arrvse:array of string;
begin
   // If form1.ZConnection1.Connected then
   //begin
   // If zbusy<Sett.maxz then
   //  begin
   //   zbusy:=zbusy+1;
   //   Form1.mess_log('--z18.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
   //   active_process:=false;
   //   exit;
   //   end;
   //  form1.ZConnection1.Disconnect;
   //  zbusy:=0;
   //end;
   //setlength(arrvse,0);
   //
   //
   //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s8--ЗАПРАШИВАЕМ ФАЙЛЫ ОТВЕТОВ ');
   //
   // If not(form1.Connect(form1.ZConnection1,-1)) then
   //  begin
   //   Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
   //   active_process:=false;
   //   exit;
   //  end;
   // form1.ZReadOnlyQuery1.SQL.Clear;
   // form1.ZReadOnlyQuery1.SQL.add('select file_send,file_answer from av_pdp_log where data_exist=true and');
   // //form1.ZReadOnlyQuery1.SQL.add('stamp_to is not null and stamp_send is not null and
   // //form1.ZReadOnlyQuery1.SQL.add('file_send=''22013_2016_04_02_05_46_36_675.csv'' and ');
   // form1.ZReadOnlyQuery1.SQL.add('file_answer<>'''' and error_main=0 and not correct and date(stamp_from)>''29-02-2016'' order by stamp_from desc;');
   // //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   //try
   //  form1.ZReadOnlyQuery1.open;
   //except
   //   Form1.mess_log('--e59--Ошибка запроса !');
   //   //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
   //   form1.ZReadOnlyQuery1.close;
   //   form1.ZConnection1.disconnect;
   //   active_process:=false;
   //   exit;
   //end;
   //If form1.ZReadOnlyQuery1.RecordCount>0 then
   // begin
   //  //If not Form1.SetSite('csv') then
   //  If not Form1.SetSite('answer') then
   //  begin
   //      Form1.mess_log('--e52--Не определены параметры подключения к FTP для приема файлов ответов !');
   //      Exit;
   //  end;
   // UpdateSite;
      //spath:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir);//$
      //spath:=ExtractFilePath(Application.ExeName);//$
   //   //spath:='/home/platforma/243prikaz/ANSWER/';
   //
   //   for n:=0 to form1.ZReadOnlyQuery1.RecordCount-1 do
   //   begin
   //   setlength(arrvse,length(arrvse)+1);
   //   arrvse[length(arrvse)-1]:=form1.ZReadOnlyQuery1.FieldByName('file_answer').AsString;
   //    form1.ZReadOnlyQuery1.Next;
   //   end;
   //  end;
   //  form1.ZReadOnlyQuery1.close;
   //  form1.ZConnection1.disconnect;

   //for n:=low(arrvse) to high(arrvse) do
   //begin

    //if FileExistsUTF8(spath+arrvse[n]) then
    //     begin
    //       If not xmlparse(spath,arrvse[n]) then exit;
    //       //showmessage(fotvet+'  GOOD');
    //       if length(arrans)<3 then exit;
    //       //записываем результат
    //       PDPlog_get(arrvse[n], 2);
    //     end;
   //end;

    //showmessage(ExtractFileName(FileNameEdit1.FileName));
  If not xmlparse('',FileNameEdit1.FileName) then exit;
  If length(arrans)=0 then exit;
  str:='';
    for n:=0 to length(arrans)-1 do
      begin
        for m:=0 to length(arrans[0])-1 do
          begin
              str:=str+' | '+arrans[n,m];
          end;
         str:=str+#13
      end;
    //showmessage(str);
   //PDPlog_get(ExtractFileName(FileNameEdit1.FileName), 2);
end;

//подключится/отключится от FTP
procedure TForm1.Button2Click(Sender: TObject);
begin
  If active_process then
    begin
      mess_log('Прием невозможен ! Приложение занято, подождите...');
      exit;
    end;
  If FTP.Connected then
    begin
     Discon_FTP(false);
     form1.MemoLog.Clear;
     mess_log('Отключение от FTP-сервера...');
     exit;
    end;
  If form1.CheckBox3.Checked then
   If not Form1.SetSite('csv') then
     begin
         Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
         Exit;
     end;
   If form1.CheckBox4.Checked then
   If not Form1.SetSite('shedules') then
     begin
         Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
         Exit;
     end;
   // If form1.CheckBox6.Checked then
   //If not Form1.SetSite('perevoz') then
   //  begin
   //      Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
   //      Exit;
   //  end;
   //  If form1.CheckBox7.Checked then
   //If not Form1.SetSite('servers') then
   //  begin
   //      Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
   //      Exit;
   //  end;
      If form1.CheckBox5.Checked then
   If not Form1.SetSite('points') then
     begin
         Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
         Exit;
     end;
   If not(form1.CheckBox3.Checked or form1.CheckBox4.Checked or form1.CheckBox5.Checked) then
    If not Form1.SetSite('answer') then
     begin
         Form1.mess_log('Ошибка ! Не определены параметры подключения к FTP !');
         Exit;
     end;
  UpdateSite;

  form1.accConnectExecute(Self);
  form1.mess_log(Site.Host+':'+Site.Port+' '+GetSitePath);
end;



function TForm1.xmlparse(fpath:string;fname:string):boolean;
var
//xmlcfg: TXmlConfig;
  //s:string;
  //Parser: TDOMParser;
  FDoc: TXMLDocument;
  iNode: TDOMNode;
  //j: Integer;

  procedure ProcessNode(Node: TDOMNode);
  var
    cNode: TDOMNode;
    k: Integer;
  begin
    if Node = nil then Exit; // выходим, если достигнут конец документа
    // добавляем узел в дерево
    if Node.HasAttributes and (Node.Attributes.Length>0) then
    begin
      If (Node.NodeName='entry') and (Node.Attributes[0].NodeName='errCode') then
       begin
          setlength(arrans,2,lenarrans);
          arrans[1,0]:=Node.Attributes[0].NodeValue;
       end;
      If (Node.NodeName='fault') then
       begin
        setlength(arrans,length(arrans)+1,lenarrans);
        for k:=0 to Node.Attributes.Length-1 do
        begin
        If (Node.Attributes[k].NodeName='errCode') then
        arrans[length(arrans)-1,0]:=Node.Attributes[k].NodeValue;
        If (Node.Attributes[k].NodeName='line') then
        arrans[length(arrans)-1,1]:=Node.Attributes[k].NodeValue;
        If (Node.Attributes[k].NodeName='description') then
        arrans[length(arrans)-1,2]:=StringReplace( trim(Node.Attributes[k].NodeValue),#39,'',[rfReplaceAll, rfIgnoreCase]);
      //showmessage(Node.Attributes[k].NodeName+' '+Node.Attributes[k].NodeValue);
       //s:=s+Node.Attributes[k].NodeName+' '+Node.Attributes[k].NodeValue+#13;
    //else
      //s:='';
    //TreeNode := tree.Items.AddChild(TreeNode, s);
    // переходим к дочернему узлу
        end;
    end;
    end;
    cNode := Node.FirstChild;

    // проходим по всем дочерним узлам
    while cNode <> nil do
    begin
      ProcessNode(cNode);
      cNode := cNode.NextSibling;
    end;
  end;


 begin
   result:=false;
   setlength(arrans,0,0);
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s01--разбор файла '+fname);
   //if Assigned(FDoc) then
    //FreeAndNil(FDoc);

  ////if not FileExistsUTF8(fname) then exit;
  // Parser := TDOMParser.Create;
  //// и источник данных
  //Src := TXMLInputSource.Create(AStream);
  //// Включаем проверку достоверности
  //Parser.Options.Validate := True;
  //// Назначаем обработчик ошибок, который будет получать уведомления о них
  //Parser.OnError := @ErrorHandler;
  //// А теперь работаем
  //Parser.Parse(Src, TheDoc);
//   procedure TMyObject.ErrorHandler(E: EXMLReadError);
//begin
//  if E.Severity = esError then  // Нас интересуют только ошибки проверки достоверности
//    writeln(E.Message);
//end;

  try
  ReadXMLFile(FDoc, UTF8ToSys(fpath+fname));
  except
       on E: EXMLReadError do
       begin
       mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e9--ОШИБКА разбора XML:'+ E.Message +' unit:'+ E.UnitName);
      //showmessage('Это фигня какая-то, а не файл xml...');
      //WriteLn(E.Message);
       RenameFileUTF8(fpath+fname,fpath+fname+'.notvalid');
         //DeleteFileUtf8(fpath+fname);
       exit;
       end;
  end;
  setlength(arrans,0,2);

  //if not Assigned(FDoc) then exit;
  //showmessage('1');
   // Используем свойства FirstChild и NextSibling
   iNode := FDoc.DocumentElement;
   If (iNode<>nil) then
    If iNode.HasAttributes and (iNode.Attributes.Length>0) then
      If iNode.Attributes[0].NodeName='errCode' then
      begin
        setlength(arrans,1,2);
        arrans[0,0]:=iNode.Attributes[0].NodeValue;
   //showmessage(s);
      end;


   iNode := FDoc.DocumentElement.FirstChild;

   while iNode<>nil do
   begin
     //If iNode.Attributes.Item[0].NodeName='errCode' then
     //s:=iNode.Attributes.Item[0].NodeValue+#13;
     ////showmessage(inttostr(iNode.iNodeNodes.Count));
     //// Используем свойство iNodeNodes
     //with iNode.ChildNodes do
     //try
     //  for j := 0 to (Count - 1) do
     //    s:=s+Item[j].NodeName + ' ' + Item[j].NodeValue+#13;
     //finally
     //  Free;
     //end;
     ProcessNode(iNode);
     iNode := iNode.NextSibling;
   end;
   FDoc.Free;
   result:=true;

   //showmessage(s);


// xmlcfg := TXMLConfig.Create(nil);
//try
//xmlcfg.RootName:='ns2:ImportAck';
//xmlcfg.Filename:=UTF8ToSys(FileNameEdit1.FileName);
////fPlatformsBaseDir := UTF8Encode(xmlcfg.GetValue('Platforms', fPlatformsBaseDir ));
//filecode   := xmlcfg.GetValue('errCode', '777');
//stringcode := xmlcfg.GetValue('entry/errCode','777');
//showmessage(xmlcfg.GetValue('entry/fault/errCode','777'));
//showmessage(xmlcfg.GetValue('entry/fault/description','777'));
//finally
//xmlcfg.Free;
//end;

end;

  //************************************ ОБРАБОТЧИК ИСКЛЮЧЕНИЙ  **************************************
procedure TForm1.MyExceptionHandler(Sender : TObject; E : Exception);
begin
  //if e.Message <> 'Access violation' then
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--@EXCEPTION-- mes:'+ E.Message +' unit:'+  E.MethodName(Sender));
  E.Free;
end;

procedure TForm1.stop_auto_upload();
begin
 form1.Label1.Caption:='---:---:---';
 form1.Shape1.Brush.Color:=clWhite;
 If length(ardel)>0 then setlength(ardel,0,0);
end;

procedure TForm1.stop_auto_download();
begin
 form1.Label7.Caption:='---:---:---';
 form1.Shape2.Brush.Color:=clWhite;
 If length(arans)>0 then setlength(arans,0,0);
 attempt:=0;
end;

procedure TForm1.start_auto_upload();
begin
 form1.Label1.Caption:='00:00:00';
 form1.Shape1.Brush.Color:=clLime;
 form1.Shape2.Brush.Color:=clWhite;
end;

procedure TForm1.start_auto_download();
begin
 form1.Label7.Caption:='00:00:00';
 form1.Shape2.Brush.Color:=clLime;
 form1.Shape1.Brush.Color:=clWhite;
end;


procedure TForm1.SendSuccess();
//var
  //fileuploaded:string;
begin
   form1.TimerSend.Enabled:=false;
   //fileuploaded:=uploadfile;
   uploadfile:='';
   form1.TimerControl.Enabled:=false;
   form1.Label5.Caption:=floattostr(form1.TimerControl.Interval div 1000);
   //form1.TimerControl.Enabled:=true;


   //inc(uplnow);
   //inc(uplall);
   //form1.ProgressBar1.Position := Round(downnow / FDLSize * 100);
   //form1.Label10.Caption:=inttostr(downnow);

  If fl_send then
  begin
    counterr:=0;
   // mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s18--передача данных. УСПЕШНО! ');
    inc(uplnow);
    inc(uplall);
    allans:=-1;//сброс флага отсутствия неотвеченных файлов
    //form1.Label11.Caption:=inttostr(downall);
    end
   else
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z12--ПЕРЕДАЧА ДАННЫХ. ОШИБКА! ');

    form1.Label17.Caption:=inttostr(uplnow);
    form1.Label19.Caption:=inttostr(uplall);
    active_process:=false;
    PDPlog_send(xml_name);
    fl_send:=false;
    form1.stop_auto_upload();

    If form1.TCountDown.Enabled=false then form1.TCountDown.Enabled:=true;
    If form1.TimerRegular.Enabled=false then form1.TimerRegular.Enabled:=true;
end;


procedure TForm1.GetSuccess();
var
  filedownloaded,fpath:string;
  //found:boolean;
begin
   //found:=false;
   filedownloaded:=downfile;
   downfile:='';
   If trim(filedownloaded)='' then
   begin
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e85--Пустой файл квитанции!');
     exit;
    end;
    //form1.Label1.Caption:='00:00:00';
    //form1.TimerReceive.Enabled:=false;
    form1.TimerControl.Enabled:=false;
    form1.Label5.Caption:=floattostr(form1.TimerControl.Interval div 1000);
    form1.TimerControl.Enabled:=true;


   form1.ProgressBar1.Position := Round(downnow / FDLSize * 100);
   form1.Label10.Caption:=inttostr(downnow);

  If fl_receive>0 then
  begin
    //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s11--Успешный ПРИЕМ ФАЙЛА ответов: '+filedownloaded);
    inc(downall);
    inc(downnow);
    form1.Label11.Caption:=inttostr(downall);
    end;
   //else
    //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s12--НЕ НАЙДЕН файл квитанции: '+filedownloaded);

   If fl_receive=1 then
   begin
     inc(downok);
     mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s11--КОРРЕКТНЫЙ файл квитанции!');//+filedownloaded);
     form1.Label12.Caption:=inttostr(downok);
     end;

  //если файл принят с ошибкой, разбираем
  If fl_receive=2 then
  begin
   fpath:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir);
   if FileExistsUTF8(fpath+filedownloaded) then
      //файл ответа кривой, ошибка разбора
    begin
     freeandnil(Ffile);//%1027
     If not xmlparse(fpath,filedownloaded) then
      begin
        mess_log('--e56--Ошибка разбора файла квитанции: '+fpath+filedownloaded);
        //found:=true;//%1027
        fl_receive:=3;
      end;
    end
   else
   begin
     //found:=false; //%1027
      mess_log('--e66--Не найден файл квитанции: '+fpath+filedownloaded);
   end;
  end;
  //showmessage(inttostr(fl_receive));
 //запись лога о получении файла
  If ((fl_receive>0) and (trim(filedownloaded)<>'') and (utf8length(filedownloaded)>4)) OR (fl_receive=0) then
        PDPlog_get(filedownloaded, fl_receive)
        else
          mess_log('--i01--Не записывать лог приема по файлу: '+fpath+filedownloaded);
          //showmessage(inttostr(fl_receive));

   fl_receive:=0;
   active_process:=false;
   form1.TimerReceive.Enabled:=true;
end;


function TForm1.CntDown(tt:string):string;
  var
    sec:integer;
begin
      result:=tt;
   //sec:=strtoint(copy(tt,1,2))*3600+strtoint(copy(tt,4,2))*60+strtoint(copy(tt,6,2));
   //секунды
   try
   sec:=strtoint(copy(tt,7,2));
   except
     Form1.mess_log('--e3--ОШИБКА КОНВЕРТАЦИИ !!! '+'НЕВЕРНОЕ преобразование времени !');
   end;
   If sec>0 then
   begin
    result:=copy(tt,1,6)+padl(inttostr(sec-1),'0',2);
    exit;
   end;
   //минуты
   try
   sec:=strtoint(copy(tt,4,2));
   except
     Form1.mess_log('ОШИБКА КОНВЕРТАЦИИ !!! '+'НЕВЕРНОЕ преобразование времени !');
   end;
    If sec>0 then
   begin
    result:=copy(tt,1,3)+padl(inttostr(sec-1),'0',2)+':59';
    exit;
   end;
    //часы
   try
   sec:=strtoint(copy(tt,1,2));
   except
     Form1.mess_log('ОШИБКА КОНВЕРТАЦИИ !!! '+'НЕВЕРНОЕ преобразование времени !');
   end;
    If sec>0 then
   begin
    result:=padl(inttostr(sec-1),'0',2)+':59:59';
    exit;
   end;
  end;

  //собрать ответы с сервера
procedure TForm1.GetAnswerSprav();
begin
  //If active_process then
  //   begin
  //     mess_log('--11. Сбор информации невозможен ! Приложение занято, подождите...');
  //     exit;
  //   end;
  //
  //mess_log('_____________________________________________________________');
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  ```````````` СБОР ОТВЕТОВ ПО СПРАВОЧНИКАМ ``````````````');
  //
  //   If form1.ZConnection1.Connected then
  // begin
  //  If zbusy<Sett.maxz then
  //   begin
  //    zbusy:=zbusy+1;
  //    Form1.mess_log('--z11--'+inttostr(zbusy)+'Выполняется запрос! Выход...');
  //    exit;
  //    end;
  //   form1.ZConnection1.Disconnect;
  //   zbusy:=0;
  // end;
  //  If not(form1.Connect(form1.ZConnection1,-1)) then
  //   begin
  //    Form1.mess_log('--e14--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
  //    //включить таймер обратного отсчета
  //    exit;
  //   end;
  //
  ////собираем инфу по отправленным справочникам
  //  form1.ZReadOnlyQuery1.SQL.Clear;
  //  form1.ZReadOnlyQuery1.SQL.add(' select * FROM av_pdp_log where id_point=0 and answer=false and stamp_send is not null order by stamp_send desc;');
  //  //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
  // try
  //   form1.ZReadOnlyQuery1.open;
  // except
  //    Form1.mess_log('--e15--Ошибка запроса по отправленным данным на сервера !');
  //    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
  //    form1.ZReadOnlyQuery1.close;
  //    form1.ZConnection1.disconnect;
  //    exit;
  // end;
  // If form1.ZReadOnlyQuery1.RecordCount=0 then
  //  begin
  //   form1.ZReadOnlyQuery1.close;
  //    form1.ZConnection1.disconnect;
  //    exit;
  //  end;
  // setlength(arans,0,0);
  //
  //  For n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  //  begin
  //    If trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)='' then continue;
  //     setlength(arans,length(arans)+1,2);
  //     arans[length(arans)-1,1]:='0';
  //     If trim(form1.ZReadOnlyQuery1.FieldByName('remark').AsString)='shedules' then
  //      arans[length(arans)-1,0]:='TT_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.ack'
  //     else
  //      arans[length(arans)-1,0]:='RD_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.ack';
  //    form1.ZReadOnlyQuery1.Next;
  //  end;
  //
  //  form1.ZReadOnlyQuery1.close;
  //  form1.ZConnection1.disconnect;
end;


  // Функция добавляет символами строку до необходимого размера слева
function TForm1.PADL(Src: string; AddSrc: string; Lg: Integer): string;
 begin
  Result := trim(Src);
  while Length(Result) < Lg do
   Result := AddSrc + Result;
 end;

//запись в логи об отправке файла
procedure TForm1.PDPlog_send(fsend:string);
begin
  //exit;//$
  //If Sett.lsend_log=0 then exit;

  If trim(fsend)='' then
 begin
    Form1.mess_log('--e89--Ошибка! НЕ ОПРЕДЕЛЕН файл для передачи !');
    exit; //неудача
  end;
  If not fl_send then exit;

  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z1--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e16--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        exit;
       end;
  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      form1.ZReadOnlyQuery1.SQL.add(' Update av_pdp_log set stamp_send=now() WHERE file_send='+quotedstr(fsend));
      //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;
  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e17--ОШИБКА логирования ! Файл отправлен: '+xml_name);
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
        exit;
  end;
     mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--s02--логгирование успешной отправки данных');

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
end;



//запись в логи об получении файла
procedure TForm1.PDPlog_delete(fsend:string);
//var
  //flag_correct:string;
  //flans:string;
begin
  If trim(fsend)='' then
 begin
    Form1.mess_log('--e78--Ошибка! Неверный ответ !');
    exit; //неудача
  end;

  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z22--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e18--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        exit;
       end;

  active_process:=true;
  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      form1.ZReadOnlyQuery1.SQL.add('Update av_pdp_log set kill=true where data_exist and file_send notnull and stamp_answer notnull and stamp_send notnull and correct and file_answer='+quotedstr(fsend));
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;
  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e21--ОШИБКА логирования ! Файл удален: '+fsend);
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
          active_process:=false;
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
        exit;
  end;
    active_process:=false;
  form1.ZReadOnlyQuery1.close;
  form1.ZConnection1.disconnect;

  mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--s03-- удаление квитанций. запись в журнал.');

end;


//запись в логи об получении файла
procedure TForm1.PDPlog_get(fsend:string;flag:integer);
var
  flag_correct:string;
  flans:string;
  j:integer;
begin

  //If Sett.lreceive_log=0 then exit;
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s04-- Прием файла квитанции. Запись в журнал.');//+filedownloaded);

  If trim(fsend)='' then
 begin
    Form1.mess_log('--e79--Ошибка! Неверный ответ !');
    exit; //неудача
  end;
 case flag of
   0: flag_correct:='false';
   1: flag_correct:='true';
   2: flag_correct:='false';
   3: flag_correct:='false';
 end;
  case flag of
   0: flans:='false';
   1: flans:='true';
   2: flans:='true';
   3: flans:='true';
 end;

  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z23--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e18--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        exit;
       end;

    active_process:=true;

  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      //если ответа нет
       If (flag=0) then
        begin
         //помечаем файл как не отправленный, если долго не было ответа
         form1.ZReadOnlyQuery1.SQL.add('Update av_pdp_log set stamp_send=null  WHERE file_send='+quotedstr(copy(fsend,9,pos('.zip.ack',fsend)-9)));
         form1.ZReadOnlyQuery1.SQL.add(' and (stamp_send + interval '''+inttostr(waitforanswer)+' hours'')<now();');
           Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
         end
       else
       //если есть ответ
       begin
         form1.ZReadOnlyQuery1.SQL.add('Update av_pdp_log set stamp_answer=now(),answer='+flans+',correct='+flag_correct);
       end;


      //если файл принят с ошибкой
      If (flag=2) and (length(arrans)>2) then
      begin
      form1.ZReadOnlyQuery1.SQL.add(',error_main='+arrans[0,0]);
      form1.ZReadOnlyQuery1.SQL.add(',error_file='+arrans[1,0]);
      form1.ZReadOnlyQuery1.SQL.add(',error_line='+arrans[2,0]);
      If flag=3 then
       form1.ZReadOnlyQuery1.SQL.add(',answer_text=''Ошибка разбора файла квитанции!''')
      else
      form1.ZReadOnlyQuery1.SQL.add(',answer_text='''+arrans[2,0]+'>'+arrans[2,1]+'<'+arrans[2,2]+'|');
      for j:=3 to length(arrans)-1 do
      begin
        form1.ZReadOnlyQuery1.SQL.add(arrans[j,0]+'>'+arrans[j,1]+'<'+arrans[j,2]+'|');
      end;
       form1.ZReadOnlyQuery1.SQL.add(''' ');
      end;
      //iF pos('xml',fsend)>0 then        //1128
      //form1.ZReadOnlyQuery1.SQL.add(',file_answer='+quotedstr(fsend)+' WHERE file_send='+quotedstr(copy(fsend,9,pos('.ack',fsend)-9)))
      //else


       //если файл недавно отправлен и нет квитанции, то не помечать
       //If (flag=0) then
       // begin
       //  form1.ZReadOnlyQuery1.SQL.add(' and (stamp_send + interval '''+inttostr(waitforanswer)+' hours'')<now()');
       //  mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       //  end
       //else

    //запись лога об принятом ответе
     If (flag<>0) then
       begin
       form1.ZReadOnlyQuery1.SQL.add(',file_answer='+quotedstr(fsend)+' WHERE file_send='+quotedstr(copy(fsend,9,pos('.zip.ack',fsend)-9)));
       mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s05-- прием файлов квитанций. Успешная запись в журнал.');
       end;

       //mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;

  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e19--ОШИБКА логирования ! Файл принят: '+fsend);
        Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
        active_process:=false;
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
        exit;
  end;
    active_process:=false;
  form1.ZReadOnlyQuery1.close;
  form1.ZConnection1.disconnect;
end;


procedure TForm1.ClearALL();
begin
  //If form1.TimerReceive.Enabled then form1.TimerReceive.Enabled:=false;
  //If form1.TimerSend.Enabled    then form1.TimerSend.Enabled:=false;
 //If ftpdeny and (uploadfile<>'') then
  //begin
  //stop_auto_download();
  mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--oClearAll--');//$
  //uploadfile:='';
  //exit;
 //end;
  //Discon_FTP(false);
   //form1.TCountDown.Enabled:=false;  //$
   If form1.CheckBox2.Checked then
  begin
  //mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--o002--');//$
  If (form1.Shape2.Brush.Color=clLime) or (form1.Label7.Caption='00:00:00') or (fl_receive>0) then
   begin
    //mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--o003--');//$
     If fl_receive>0 then
      begin
       mess_log('--s06-- получение файлов квитанций. УСПЕШНО!');
       form1.GetSuccess();
      end;
      form1.Label7.Caption:='---:---:---';
      form1.Shape2.Brush.Color:=clWhite;
      //stop_auto_download(); //$ //не обнулять массив приемных файлов
    end;
   If (form1.Shape1.Brush.Color=clLime) or (form1.Label1.Caption='00:00:00') or fl_send then
   begin
   If ftpdeny and (uploadfile<>'') then
     mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--o001--');//$

   uploadfile:='';

     If fl_send then
      begin
       counterr:=0;
       mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--s06-- Отправка данных ПДП. Успешно!');
       PDPlog_send(xml_name);
      end;
     mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--o004--');//$
     stop_auto_upload();
   end;
    //mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--o004--');//$
  end;
 If active_process then active_process:=false;
 If form1.TimerReceive.Enabled then form1.TimerReceive.Enabled:=false;
 If form1.TimerSend.Enabled then form1.TimerSend.Enabled:=false;
 If form1.TCountDown.Enabled=false then form1.TCountDown.Enabled:=true;
 If form1.TimerRegular.Enabled=false then form1.TimerRegular.Enabled:=true;
 If form1.TimerControl.Enabled then form1.TimerControl.Enabled:=false;
     //Discon_FTP(false);
 CreateFilePath := '';
end;


//таймер контроля результатов соединения
procedure TForm1.TimerControlTimer(Sender: TObject);
begin
  form1.TimerControl.Enabled:=false;
  mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--e888--Таймер Подключения к FTP Сброс всех флагов !');
  form1.ClearALL();
end;

//передача справочников
procedure TFOrm1.SPR_SEND(mode:string);
//mode : present
//       firsttime
var
m,n,cnt:integer;
spr:string;
sres:boolean;
sprDT:TDateTime;
F: TextFile;
begin
 mess_log('___sprsend___');
  //если ручной режим - выход
  If form1.CheckBox1.Checked and (mode='present') then exit;
  //form1.Label1.Caption:='00:00:00';
  //выключить таймер обратного отсчета
  //form1.CountDown.Enabled:=false;

     If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z20--Передача справочников невозможна ! Приложение занято, подождите...');
      exit;
    end;


   uploadFile:='';
  xml_name:='';
  mess_log('__________________________'+mode+'_________________________________');
  If mode<>'firsttime' then
   begin
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  ============== ОБНОВЛЕНИЕ СПРАВОЧНИКОВ =============1=');

   end;
   //stamp_spr_send:=form1.DateTimePicker1.DateTime;
    //If (stamp_spr_send_correct>stamp_spr_send) OR (mode='firsttime') then
     //stamp_spr_send_correct := stamp_spr_send;
   //If (stamp_spr_actual>stamp_spr_send_correct) OR (mode='firsttime') then
     //stamp_spr_actual := stamp_spr_send_correct;
   //exit;


     If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z24--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('--e21--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      exit;
     end;
    spr:='';

      //проверяем была ли уже передача в эти 24 часа
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add('select * ');
    form1.ZReadOnlyQuery1.SQL.add(',(select count(*) from av_pdp_log b where b.remark=m.remark and b.stamp_send>current_date and b.stamp_from=stamp_from_vse) cnt ');
    form1.ZReadOnlyQuery1.SQL.add('from ( ');
    form1.ZReadOnlyQuery1.SQL.add('Select * ');
    form1.ZReadOnlyQuery1.SQL.add(',coalesce((select stamp_from from av_pdp_log ');
    form1.ZReadOnlyQuery1.SQL.add('		where id_point=0 and remark=c.remark and stamp_send notnull ');
    form1.ZReadOnlyQuery1.SQL.add('		and data_exist ORDER BY stamp_send desc limit 1),now()-interval ''370 days'') stamp_from_vse ');
    form1.ZReadOnlyQuery1.SQL.add(',coalesce((select stamp_from from av_pdp_log ');
    form1.ZReadOnlyQuery1.SQL.add('		where id_point=0 and remark=c.remark and stamp_send notnull  ');
    form1.ZReadOnlyQuery1.SQL.add('		and data_exist and correct ORDER BY stamp_send desc limit 1),now()-interval ''370 days'') stamp_from ');
    form1.ZReadOnlyQuery1.SQL.add(',coalesce((select stamp_send from av_pdp_log ');
    form1.ZReadOnlyQuery1.SQL.add('		where id_point=0 and remark=c.remark and stamp_send notnull ');
    form1.ZReadOnlyQuery1.SQL.add('		and data_exist and correct ORDER BY stamp_send desc limit 1),now()-interval ''370 days'') stamp_send_correct ');
    form1.ZReadOnlyQuery1.SQL.add(',coalesce((select stamp_send from av_pdp_log ');
    form1.ZReadOnlyQuery1.SQL.add('		where id_point=0 and remark=c.remark and stamp_send notnull ');
    form1.ZReadOnlyQuery1.SQL.add('		and data_exist ORDER BY stamp_send desc limit 1),now()-interval ''370 days'') stamp_send');
    form1.ZReadOnlyQuery1.SQL.add(' FROM ( ');
    form1.ZReadOnlyQuery1.SQL.add('select remark FROM av_pdp_log where ');
    form1.ZReadOnlyQuery1.SQL.add('id_point=0 and remark<>'''' ');
    form1.ZReadOnlyQuery1.SQL.add('and date(stamp_send)=current_date ');
    form1.ZReadOnlyQuery1.SQL.add('and data_exist ');
    form1.ZReadOnlyQuery1.SQL.add('group by remark ');
    form1.ZReadOnlyQuery1.SQL.add(') c ) m;');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e22--Ошибка запроса по отправленным данным на сервера !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;
   //If form1.ZReadOnlyQuery1.RecordCount=0 then
   //begin
    //spr:='points';
    //end
    //else
    //begin
    //spr:='*';
    for n:=1 to 2 do
    begin
    //города
     If n=1 then
        If form1.CheckBox11.Checked then spr:='points'
          else continue;
     //расписания
     If n=2 then
        if form1.CheckBox8.Checked then spr:='shedules'
        else continue;
     //if n=2 then spr:='perevoz';
     if spr='' then break;


     //Если повторная передача данных
     //If mode='present' then
     //begin
     //  sprDT:=now();
     //end
     //else
     //begin
     //  sprDT:=form1.DateTimePicker1.DateTime;
     // end;

     sprDT:=form1.DateTimePicker1.DateTime;

     cnt:=0;
      form1.ZReadOnlyQuery1.First;
       for m:=0 to form1.ZReadOnlyQuery1.RecordCount-1 do
       begin

          //If (stamp_spr_actual<IncDay(ZeroDateTime,1)) or (mode='firsttime') then
            //If (form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime)=(form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime) then
              //stamp_spr_actual:=form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime;


          If spr=form1.ZReadOnlyQuery1.FieldByName('remark').AsString then
          begin
          //inc(cnt);
          cnt:=form1.ZReadOnlyQuery1.FieldByName('cnt').AsInteger;
          //устанавливаем константы
          If stamp_spr_send<form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime then
             stamp_spr_send:=form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime;
          //showmessage(formatdatetime('hh:nn:ss.zzz dd-mm-yy',stamp_spr_send));//$

          If stamp_spr_send_correct<form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime then
             stamp_spr_send_correct:=form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime;
          //условия при которых обновлять НЕ НУЖНО
              //showmessage(
              // //FormatDateTime('dd-mm-yyyy hh:nn',incday(stamp_spr_actual,370))
              //        FormatDateTime('dd-mm-yyyy hh:nn',form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime)+#13+
              //            FormatDateTime('dd-mm-yyyy hh:nn',sprDT)+#13+
              ////FormatDateTime('dd-mm-yyyy hh:nn',incHour(form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime))
              //            FormatDateTime('dd-mm-yyyy hh:nn',(incDay(sprDT,Sett.nSheddays)))
              //);
              //если текущая передача, и еще ни разу справочник не передавался, то пока не надо
               //If  (mode='present') or (mode='firsttime')  then //and ((incday(stamp_spr_actual,370)<now())
                //если прошло меньше 90 минут с последней передачи и нет корректного ответа, то не надо
                 If ((incMinute(form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime,90)>now())
                    and (form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime<>form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime))
                  OR
                  //если на последний запрос этого справочника получен корректный ответ
                   ((form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime=form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime)
                 //И если период данных больше периода справочника в разумных пределах, тоже
                     AND (form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime>=(incDay(sprDT,Sett.nsheddays)))
                     AND (sprDT>=form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime))

                 then
                   //OR IncHour(form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime,1)>now()))
          ////если текущая передача, то если прошло меньше суток - НЕ надо
          //     If  ((mode='present') and (IncDay(form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime, 1)>sprDT))
          //          OR
          //     //если исправление, то не ранее  nsheddays или не позднее -55 минут до события - НЕ надо
          //           ((mode='prev') and (incMinute(form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime,-55)<sprDT)
          //           AND
          //           (form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime>IncDay(sprDT,-1*Sett.nsheddays)))

                 begin
                 //If spr='shedules' then
                 //If (spr<>'perevoz') and
                 //showmessage(FormatDateTime('dd-mm-yyyy hh:nn',form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime)+#13+
                                  //FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_actual));
                 //если
                  //If (mode='present') and (stamp_spr_actual>form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime) then
                  If spr='shedules' then
                    begin
                      //showmessage(FormatDateTime('dd-mm-yyyy hh:nn',form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime));
                     //If form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime=form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime then
                      stamp_spr_actual:=form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime;
                    end;
                 spr:='*';
                 //inc(cnt);
                 //If stamp_spr_send_correct<form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime then
                    //stamp_spr_send_correct:=form1.ZReadOnlyQuery1.FieldByName('stamp_send_correct').AsDateTime;
                    //stamp_spr_send:=form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime;
              end;
          //else
          //begin
            //если еще не получили ответ на предыдующее обновление
            //If (cnt>0) and (inchour(form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime,1)>now()) then
              //begin
                //stamp_spr_send:=form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime;
                //spr:='*';
              //end;
           //end;

          //если период не соотвествует, и проверка не первый раз, сброс счетчкика
          If (spr<>'*') and (mode<>'firsttime') and
            ((form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime<(incDay(sprDT,Sett.nSheddays)))
           OR (sprDT<form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime)) then cnt:=0;
          end;

          form1.ZReadOnlyQuery1.Next;
           //If mode<>'present' then break;
        end;
      //If  spr='points' then continue;//$//&

   If (cnt=0) or (mode='force') then break;

   If (cnt>sprupdatetimes) and (mode='present') and form1.CheckBox2.Checked and (spr<>'*') then
   begin
    form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e47 Отмена! Справочник '+spr+' отправлялся уже '+inttostr(cnt)+' раза !');
    spr:='';
    continue;
   end;

    //spr:='*';
    //continue;
    //end;
    If spr<>'*' then break;
   //end;
  end;
    form1.ZReadOnlyQuery1.close;
    form1.ZConnection1.disconnect;

  form1.mess_log('  s_a: '+formatdatetime('dd-mm hh:nn',stamp_spr_actual)+'  t_m: '+formatdatetime('dd-mm hh:nn',sprDT));

  //если еще не было данных по переданным справочникам и уже отправлялся этот вид справочников, то не обновлять
  If (mode='firsttime') and (cnt>0) then exit;

    If spr='*' then
    begin
     form1.mess_log('        Обновление справочников НЕ требуется !');
     //s_a: '+formatdatetime('dd-mm hh:nn',stamp_spr_actual)+'  t_m: '+formatdatetime('dd-mm hh:nn',sprDT));
     form1.stop_auto_upload();//$
     exit;
    end;
    If spr='' then
    begin
    form1.stop_auto_upload();//$
    exit;
    end;
    //mess_log('_____________________________________________________________');
    //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'========== ОБНОВЛЕНИЕ СПРАВОЧНИКОВ ==========1=');

      If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e23--Передача справочников невозможна ! Приложение занято, подождите...');
      exit;
    end;

      If not Form1.SetSite(spr) then
         begin
          Form1.mess_log('--e24--Не найдено настроек FTP для передачи справочника !');
          exit;
         end;

    UpdateSite;

      If spr='points' then
       sres:=CreateXmlPoints(sprDT);
      If spr='perevoz' then
       sres:=CreateXmlPerevoz(sprDT);
      If spr='shedules' then
       begin
        //If mode='prev' then
         sres:=CreateXmlShedule(sprDT)
         //else
         //sres:=CreateXmlShedule(now());
       end;

       If sres then Form1.mess_log('   --s07-- XML-справочник '+spr+' успешно создан !')
        else
        Form1.mess_log('--e25--Ошибка создания XML-справочника '+spr+' !');

      If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e26--Передача справочников невозможна ! Приложение занято, подождите...');
      exit;
    end;

   //form1.Label1.Caption:='---:---:---';
   //active_process:=true;

  If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log('--e27--ОШИБКА ! Не найден XML-файл для передачи ! '+ uploadFile);
      exit;
    end;

  //упаковываем полученный файл
    // Запускаем внешнее приложение
  //fpsystem(ExtractFilePath(Application.ExeName)+'plathtml'+' '+trim(FileHTMLname)+' &');

   {$IFDEF LINUX}
    {$I-} // выключение контроля ошибок ввода-вывода
    try
  AssignFile(F,Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.sh');
  Rewrite(F);
  WriteLn(F, '#!/bin/bash');
  WriteLn(F, 'cd '+Sett.pathapp+Site.ldir);
  WriteLn(F, 'zip -m '+xml_name+'.zip '+xml_name);
   finally
  CloseFile(F);
    end;
   {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
   begin
     Form1.mess_log('--e40--Ошибка создания АРХИВА справочника!');
     Exit;
   end;


  form1.Process1.CommandLine:='/bin/bash '+Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir) +'arhiv.sh';
  //form1.MemoLog.Lines.LoadFromFile(Site.ldir+'arhiv.sh');
  form1.Process1.Options:=form1.Process1.Options + [poWaitOnExit];
  try
  form1.Process1.Execute;
   except
    Form1.mess_log('--e40--Ошибка создания АРХИВА !');
    exit;
    //finally
      //form1.Process1.Free;
   end;
  {$ENDIF}
  {$IFDEF WINDOWS}
    {$I-} // выключение контроля ошибок ввода-вывода
   AssignFile(F,Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat');
   Rewrite(F);
   WriteLn(F,'@echo off      ');
   WriteLn(F,'set xml_name="'+Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+xml_name+'"');
   WriteLn(F,'"C:\7-Zip\7z.exe" a -tzip -ssw -sdel -mx9 %xml_name%.zip %xml_name% ');
   //WriteLn(F, 'CD '+filepath);
    CloseFile(F);
    {$I+} // включение контроля ошибок ввода-вывода
    if IOResult<>0 then // если есть ошибка открытия, то
     begin
       Form1.mess_log('--e40--Ошибка создания АРХИВА справочника!');
       Exit;
     end;
    //form1.MemoLog.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'arhiv.bat');
    //form1.Process1.Executable:='C:\windows\system32\cmd.exe';
    ExecuteProcess(GetEnvironmentVariable('COMSPEC'), ['/c', Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat']);
    //form1.Process1.CommandLine:='C:\windows\system32\cmd.exe '+pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat';
    //form1.Process1.Parameters.Clear;
    //form1.Process1.Parameters.Add(pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat');
  {$ENDIF}

  uploadFIle:=UploadFile+'.zip';
   If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log('--e27--ОШИБКА ! Не найден XML-файл для передачи ! '+ uploadFile);
      exit;
    end;

      //файл готов к отправке записать в лог
    //If not PDPlog_new_XML(spr,xml_name,FormatDateTime('dd-mm-yyyy hh',incDay(sprDT,Sett.nSheddays))+':00:00')
    If not PDPlog_new_XML(spr,xml_name,FormatDateTime('dd-mm-yyyy hh:nn',sprDT))
     then
      begin
        Form1.mess_log('--e28--Ошибка логирования справочника '+xml_name+' !');
        exit;
       end;
   //stamp_spr_send:=incminute(now(),-10);//20180430 заремарино
  Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'   запись в базу, справочник '+spr+' готов к отправке');


  Discon_FTP(false);
  form1.accConnectExecute(Self);
  form1.TimerSend.Enabled:=true;
  form1.start_auto_upload();
end;


//запись в логи о готовности справочника на отправку
function TForm1.PDPlog_new_XML(sname:string;fname:string; stampLog:string):boolean;
begin
 result:=false;
  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z1.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      exit;
     end;

  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;

  //создаем запись о созданном файле
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add(' INSERT INTO av_pdp_log(id_point,remark,data_exist,file_send,file_answer,stamp_from) VALUES (');
    form1.ZReadOnlyQuery1.SQL.add('0,'+quotedstr(sname)+',true,'+quotedstr(fname)+','''','+Quotedstr(stampLog)+');');
    //If sname='shedules' then
     //form1.ZReadOnlyQuery1.SQL.add(Quotedstr(FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_actual))+');')
     //else
     //form1.ZReadOnlyQuery1.SQL.add('now());');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
     //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$

     form1.ZReadOnlyQuery1.open;
     form1.ZConnection1.Commit;
   except
      if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
      Form1.mess_log('--e29--Ошибка запроса !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
  result:=true;
end;

//запись в логи о готовности файла на отправку
function TForm1.PDPlog_new_csv(dd1:string;dd2:string;server:integer;fname:string):boolean;
begin
  //result:=true;//$
  //exit;       //$
 result:=false;
  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z2.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      exit;
     end;

  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;

  //создаем запись о созданном файле
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add(' INSERT INTO av_pdp_log(id_point,stamp_from,stamp_to,data_exist,file_send,file_answer) VALUES (');
    form1.ZReadOnlyQuery1.SQL.add(inttostr(server)+','+quotedstr(dd1)+','+quotedstr(dd2)+',true,'+quotedstr(fname)+','''');');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
     //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
     form1.ZReadOnlyQuery1.open;
     form1.ZConnection1.Commit;
   except
      if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
      Form1.mess_log('--e30--Ошибка запроса !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
  result:=true;
end;



  // Альтернативный ShowMessage
procedure TForm1.mess_log(s:string);
 var
  //i:integer;
  //MyMesDlg:TForm;
  //MyComponent:TButton;
  //E:TBitBtn;
  log_file: textfile;
  ns:integer;
  namelog:string='';
begin
// 100 	Запрошенное действие инициировано, дождитесь следующего ответа прежде, чем выполнять новую команду.
//110 	Комментарий
//120 	Функция будет реализована через nnn минут
//125 	Канал открыт, обмен данными начат
//150 	Статус файла правилен, подготавливается открытие канала
//200 	Команда корректна
//202 	Команда не поддерживается
//211 	Системный статус или отклик на справочный запрос
//212 	Состояние каталога
//213 	Состояние файла
//214 	Справочное поясняющее сообщение
//215 	Выводится вместе с информацией о системе по команде SYST
//220 	Служба готова для нового пользователя.
//221 	Благополучное завершение по команде quit
//225 	Канал сформирован, но информационный обмен отсутствует
//226 	Закрытие канала, обмен завершен успешно
//227 	Переход в пассивный режим (h1,h2,h3,h4,p1,p2).
//228 	переход в длинный пассивный режим (длинный адрес, порт).
//229 	Переход в расширенный пассивный режим (|||port|).
//230 	Пользователь идентифицирован, продолжайте
//231 	Пользовательский сеанс окончен; Обслуживание прекращено.
//232 	Команда о завершении сеанса принята, она будет завершена по завершении передачи файла.
//250 	Запрос прошёл успешно
//257 	«ПУТЬ» создан.
//331 	Имя пользователя корректно, нужен пароль
//332 	Для входа в систему необходима аутентификация
//350 	Запрошенное действие над файлом требует большей информации
//404 	Данный удалённый сервер не найден
//421 	Процедура невозможна, канал закрывается
//425 	Открытие информационного канала не возможно
//426 	Канал закрыт, обмен прерван
//434 	Запрашиваемый хост недоступен
//450 	Запрошенная функция не реализована, файл не доступен, например, занят
//451 	Локальная ошибка, операция прервана
//452 	Ошибка при записи файла (недостаточно места)
//500 	Синтаксическая ошибка, команда не может быть интерпретирована (возможно она слишком длинна)
//501 	Синтаксическая ошибка (неверный параметр или аргумент)
//502 	Команда не используется (нелегальный тип MODE)
//503 	Неудачная последовательность команд
//504 	Команда не применима для такого параметра
//530 	Вход не выполнен! Требуется авторизация (not logged in)
//532 	Необходима аутентификация для запоминания файла
//550 	Запрошенная функция не реализована, файл недоступен, например, не найден
//551 	Запрошенная операция прервана. Неизвестный тип страницы.
//552 	Запрошенная операция прервана. Выделено недостаточно памяти
//553 	Запрошенная операция не принята. Недопустимое имя файла.

  If pos('|~|',s)>0 then
   begin
    ns:=pos('|~|',s);
  ////фильтруем содержимое
  //If copy(s,ns+7,3)='150' then exit;
  If copy(s,ns+7,3)='200' then exit;
  If copy(s,ns+7,3)='211' then exit;
  If copy(s,ns+7,3)='220' then exit;
  //If copy(s,ns+7,3)='227' then exit;
  If copy(s,ns+7,3)='230' then exit;
  If copy(s,ns+7,3)='231' then exit;
  If copy(s,ns+7,3)='250' then exit;
  If copy(s,ns+7,3)='331' then exit;
  ////
  //If copy(s,ns,3)='226' then exit;
   end;
  If pos('|get|',s)>0 then exit;

  form1.MemoLog.Lines.Add(trim(s));
  mempos.x:=0;
  mempos.y:=form1.MemoLog.Lines.Count-1;
  form1.MemoLog.CaretPos:=mempos;
  form1.MemoLog.SelStart:=length(form1.MemoLog.Text);
  form1.MemoLog.SelLength:=0;
  //application.ProcessMessages;

 namelog:=ExtractFilePath(Application.ExeName)+'log/'+FormatDateTime('yy-mm-dd', now())+'.log';
  // --------Проверяем что уже есть каталог LOG если нет то создаем
  If Not DirectoryExistsUTF8(ExtractFilePath(Application.ExeName)+'log') then
    begin
     CreateDir(ExtractFilePath(Application.ExeName)+'log');
    end;
  //--------- Создаем log: ..log/log_01.01.2012.log
  //if fileexistsUTF8(namelog) then
   //begin
    //fileutil.RenameFileUTF8(namelog, ExtractFilePath(Application.ExeName)+'log/'+FormatDateTime('yy-mm-dd_hh_nn', now())+'.log');
   //end;
  {$I-} // отключение контроля ошибок ввода-вывода
   AssignFile(log_file,namelog);
   if fileexistsUTF8(namelog) then
       Append(log_file) else
       Rewrite(log_file); // открытие файла для записи
  {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
   begin
     Exit;
   end;
  // id_user+datetime
   //writeln(log_file,'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
   //writeln(log_file,user_ip+'; ['+(inttostr(id_user))+'] '+name_user_active+'; '+FormatDateTime('dd/mm/yyyy hh:mm:ss', now()));
   //writeln(log_file,FormatDateTime('dd/mm/yyyy hh:mm:ss', now()));

   If (formatdatetime('hh',now())='00') and (formatdatetime('nn',now())='00') and (ddate<>date()) then
    begin
     writeln(log_file,'+Version: '+MajorNum+'.'+MinorNum+'.'+RevisionNum+'.'+BuildNum);
     ddate:=date();
     end;
   writeln(log_file,trim(s));

   // --------- Закрываем текстовый файл
  CloseFile(log_file);
 end;

  // Возвращает позицию подстроки substroka в stroka под номером nextpos
function POSNEXT(stroka:string;substroka:string;nextpos:integer):integer;
 var
   n:integer;
   kol:integer=0;
begin
  Result:=0;
  for n:=1 to UTF8Length(stroka) do
    begin
      if UTF8Copy(stroka,n,utf8length(trim(substroka)))=trim(substroka) then kol:=kol+1;
      if kol=nextpos then
        begin
         Result:=n;
         exit;
        end;
    end;
end;

// Убираем нули из IP адреса
function ip_del_zero(ip:string):string;
   var
     ip_r:string='';
begin
     ip:=trim(ip);
     ip_r:=inttostr(strtoint(trim(UTF8Copy(ip,1,POSNEXT(ip,'.',1)-1))))+'.';
     ip_r:=ip_r+inttostr(strtoint(trim(UTF8Copy(ip,POSNEXT(ip,'.',1)+1,POSNEXT(ip,'.',2)-POSNEXT(ip,'.',1)-1))))+'.';
     ip_r:=ip_r+inttostr(strtoint(trim(UTF8Copy(ip,POSNEXT(ip,'.',2)+1,POSNEXT(ip,'.',3)-POSNEXT(ip,'.',2)-1))))+'.';
     ip_r:=ip_r+inttostr(strtoint(trim(UTF8Copy(ip,POSNEXT(ip,'.',3)+1,3))));
     result:=ip_r;
end;

procedure TForm1.ComboServ();
begin
   form1.ComboBox1.Clear;
   for n:=0 to length(arservers)-1 do
     begin
        form1.ComboBox1.Items.Add(arservers[n,0]+'| '+arservers[n,1]);
       end;
 end;


function Tform1.GetLocalServers():boolean;
begin
result:=false;
  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z3.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
    If not(form1.Connect(form1.ZConnection1,-1)) then
   begin
    Form1.mess_log('Соединение с сервером базы данных отсутствует !');
    exit;
   end;

     // Заполняем массив СЕРВЕРОВ
  SetLength(arservers,0,0);

form1.ZReadOnlyQuery1.SQL.Clear;
//form1.ZReadOnlyQuery1.SQL.add(' (select point_id as id,ip,ip2,base_name,login,pwd,port,real_virtual,-1 as local,''виртуальный'' as pname ');
//form1.ZReadOnlyQuery1.SQL.add(' from av_servers where del=0 and real_virtual=0 limit 1) ');
//form1.ZReadOnlyQuery1.SQL.add(' union all ');
form1.ZReadOnlyQuery1.SQL.add(' (select point_id as id,ip,ip2,base_name,login,pwd,port,real_virtual,1 as local ');
form1.ZReadOnlyQuery1.SQL.add(' ,(select b.name from av_spr_point b where b.del=0 and b.id=point_id limit 1) as pname ');
form1.ZReadOnlyQuery1.SQL.add(' from av_servers where del=0 and real_virtual=1 and point_id in ( ');
form1.ZReadOnlyQuery1.SQL.add(' select id_point from av_shedule_sostav where del=0 and id_shedule in ( ');
form1.ZReadOnlyQuery1.SQL.add(' select id_shedule from av_shedule_fio where del=0) group by id_point)) ');
form1.ZReadOnlyQuery1.SQL.add(' union all ');
form1.ZReadOnlyQuery1.SQL.add(' (select point_id+1000 as id,ip,ip2,base_name,login,pwd,port,real_virtual,1 as local ');
form1.ZReadOnlyQuery1.SQL.add(' ,(select b.name from av_spr_point b where b.del=0 and b.id=point_id limit 1) as pname ');
form1.ZReadOnlyQuery1.SQL.add(' from av_servers where del=0 and real_virtual=1 and point_id in ( ');
form1.ZReadOnlyQuery1.SQL.add(' select id_point from av_shedule_sostav where del=0 and id_shedule in ( ');
form1.ZReadOnlyQuery1.SQL.add(' select id_shedule from av_shedule_fio where del=0) group by id_point)) ');
form1.ZReadOnlyQuery1.SQL.add(' order by ip2,id; ');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e48--Ошибка запроса локальных серверов !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;
   If form1.ZReadOnlyQuery1.RecordCount=0 then
   begin
      Form1.mess_log('Не найдено локальных серверов !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;

  for n:=0 to form1.ZReadOnlyQuery1.RecordCount-1 do
    begin
      //showmessage(utf8copy(trim(form1.ZReadOnlyQuery1.FieldByName('pname').asString),1,3));
      If (form1.ZReadOnlyQuery1.FieldByName('id').AsInteger=381)
        or (utf8copy(trim(form1.ZReadOnlyQuery1.FieldByName('pname').asString),1,3)='Мих') then
        begin
         form1.ZReadOnlyQuery1.Next;
         continue;  //$
         end;
      //АРЗГИР
        //If (form1.ZReadOnlyQuery1.FieldByName('id').AsInteger=84) then continue;
        //ИПАТОВО
        //If (form1.ZReadOnlyQuery1.FieldByName('id').AsInteger=72) then continue;
      SetLength(arservers,length(arservers)+1,servsize);
           arservers[length(arservers)-1,0]:=form1.ZReadOnlyQuery1.FieldByName('id').asString;
           arservers[length(arservers)-1,1]:=form1.ZReadOnlyQuery1.FieldByName('pname').asString;
           arservers[length(arservers)-1,2]:=ip_del_zero(form1.ZReadOnlyQuery1.FieldByName('ip').asString);
           arservers[length(arservers)-1,3]:=ip_del_zero(form1.ZReadOnlyQuery1.FieldByName('ip2').asString);
           arservers[length(arservers)-1,4]:=form1.ZReadOnlyQuery1.FieldByName('base_name').asString;
           arservers[length(arservers)-1,5]:=form1.ZReadOnlyQuery1.FieldByName('login').asString;
           arservers[length(arservers)-1,6]:=form1.ZReadOnlyQuery1.FieldByName('pwd').asString;
           arservers[length(arservers)-1,7]:=form1.ZReadOnlyQuery1.FieldByName('port').asString;
           arservers[length(arservers)-1,8]:='';
           arservers[length(arservers)-1,9]:='';
           arservers[length(arservers)-1,10]:='';
           arservers[length(arservers)-1,11]:='';
           arservers[length(arservers)-1,12]:='';
           arservers[length(arservers)-1,13]:='';
           arservers[length(arservers)-1,14]:='';
           arservers[length(arservers)-1,15]:='';
           arservers[length(arservers)-1,16]:='';
           form1.ZReadOnlyQuery1.Next;
    end;


  //Заполняем массив расписаний
//  SetLength(ar_shed,0);
//
//form1.ZReadOnlyQuery1.SQL.Clear;
//form1.ZReadOnlyQuery1.SQL.add(' select id_shedule from av_shedule_fio where del=0 order by id_shedule;');//$
////form1.ZReadOnlyQuery1.SQL.add(' select id_shedule from av_shedule_fio where del=0 and id_shedule in (select id_shedule from av_shedule_atp where id_kontr in (');//$
////form1.ZReadOnlyQuery1.SQL.add(' SELECT id_kontr from av_spr_kontr_fio where del=0 and not(trim(ogrnip)='''' and trim(ogrn)='''')));');
//    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
//   try
//     form1.ZReadOnlyQuery1.open;
//   except
//      Form1.mess_log('--e31--Ошибка запроса расписаний !');
//      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
//      form1.ZReadOnlyQuery1.close;
//      form1.ZConnection1.disconnect;
//      exit;
//   end;
//   If form1.ZReadOnlyQuery1.RecordCount=0 then
//   begin
//      Form1.mess_log('Не найдено расписаний !');
//      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
//      form1.ZReadOnlyQuery1.close;
//      form1.ZConnection1.disconnect;
//      exit;
//   end;
//
//  for n:=0 to form1.ZReadOnlyQuery1.RecordCount-1 do
//    begin
//    //IF (form1.ZReadOnlyQuery1.FieldByName('id_shedule').asinteger=60) OR
//    //   (form1.ZReadOnlyQuery1.FieldByName('id_shedule').asinteger=61) OR
//    //   (form1.ZReadOnlyQuery1.FieldByName('id_shedule').asinteger=138) then
//    //  begin
//    //  form1.ZReadOnlyQuery1.Next;
//    //  continue;//$
//    //  end;
//      SetLength(ar_shed,length(ar_shed)+1);
//      ar_shed[length(ar_shed)-1]:=form1.ZReadOnlyQuery1.FieldByName('id_shedule').asString;
//      form1.ZReadOnlyQuery1.Next;
//    end;
  //Showmessage(inttostr(n));

 form1.ZReadOnlyQuery1.SQL.Clear;
 form1.ZReadOnlyQuery1.SQL.add('SELECT stamp_from FROM av_pdp_log where id_point>0 order by stamp_to desc limit 1;');//$
 //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e32--Ошибка запроса периода !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;
   If form1.ZReadOnlyQuery1.RecordCount>0 then
   begin
      time_main:=form1.ZReadOnlyQuery1.FieldByName('stamp_from').asDateTime;
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;

  form1.ZReadOnlyQuery1.Close;
  form1.ZConnection1.disconnect;

  result:=true;
end;

procedure TForm1.FTPConnect(aSocket: TLSocket);
var
  aName, Pass: string;
begin
  aName := Site.User;
  if (aName='') and not InputQuery('Name', 'Please type in your username',
    False, aName)
  then
    exit;
  Pass := Site.Pass;
  if (not Site.Anonymous) and (Pass='') then
    Pass := PasswordBox('Password', 'Please type in your password');

  FTP.Authenticate(aName, Pass);
  FTP.Binary := True;

  aName := Site.path;
  if aName='/' then
    aName := '';

  FTP.ListFeatures;


  //FDirListing := '';
  //FTP.List(aName);
  FTP.ChangeDirectory(aName);

  //FTP.List(FileName);
  //DoList(aName);
  // TODO: ask for current dir here
end;


procedure TForm1.RadioButton2Change(Sender: TObject);
begin
    If form1.RadioButton2.Checked then
    begin
      form1.Edit1.Enabled:=true;
      form1.BitBtn1.Enabled:=true;
      FORM1.Button1.Caption:='ОТПРАВИТЬ';
     form1.GroupBox3.Enabled:=false;
    end
  else
  begin
      form1.Edit1.Enabled:=false;
      form1.BitBtn1.Enabled:=false;
      FORM1.Button1.Caption:='СОЗДАТЬ и ОТПРАВИТЬ';
    end;
end;



//создать файл данных
function makeCSV(date1:string;date2:string;idpoint:integer;fname:string):string;
var
  fffile,F: TextFile;
  spisok,pathfile: string;
  n,m,k,npoint:integer;
  bHead,sqlerror:boolean;
begin
    result:='';
    spisok:='';
    bHead:=false;
    //sett.pathapp:='';
    //form1.MemoLog.Clear;
   //showmessage(ExtractFilePath(Application.ExeName)+Site.ldir);
   If not DirectoryExistsUTF8(sett.pathapp+Site.ldir)  then
     begin
       CreateDir(sett.pathapp+'CSV');
       Site.ldir:='CSV';
     end;

   pathfile:=sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir);

   {$I-} // отключение контроля ошибок ввода-вывода
   AssignFile(fffile,pathfile +fname);
   ////открываем файл
     if FileExistsUTF8(pathfile +fname) then
      begin
        Append(fffile); // открытие существулющего файла для записи
        {$I+} // включение контроля ошибок ввода-вывода
        if IOResult<>0 then // если есть ошибка открытия, то
        begin
         Form1.mess_log('--e32--Ошибка отрытия файла !');
         Exit;
        end;
        //seek(filetxt,filesize(filetxt));  //сдвигаем указатель в конец файла
      end
   else
      begin
        {$I-} // отключение контроля ошибок ввода-вывода
        Rewrite(fffile); // создание и открытие файла для записи
        {$I+} // включение контроля ошибок ввода-вывода
        if IOResult<>0 then // если есть ошибка открытия, то
        begin
         Form1.mess_log('--e34--Ошибка создания файла !');
         Exit;
        end;
      end;
     sqlerror:=false;

  for k:=0 to length(arservers)-1 do
    begin

    //ищем конкретный сервер
      If (idpoint>0) and (inttostr(idpoint)<>arservers[k,0]) then continue;
      //If arservers[k,0]='66' then continue; //пропустить виртуальный
      //If arservers[k,0]<>'815' then continue; //$
     //If k>4 then continue;//$
      //If k=9 then continue;//пропустить Новоалександровск
      //If k=11 then continue;//пропустить Красную Гвардию
      //If k=23 then continue;//пропустить Грачевку
      Form1.mess_log(inttostr(k)+'  '+arservers[k,1]+' ['+arservers[k,0]+'] '+arservers[k,3]+' '+arservers[k,4]);
      Form1.mess_log('---Запрос данных с: '+date1+'  по: '+date2);

      If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z4.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      break;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,k)) then
     begin
      Form1.mess_log('Соединение с сервером базы данных отсутствует !');
       sqlerror:=true;
      continue;
     end;
   application.ProcessMessages;

   try
     npoint := strtoint(arservers[k,0]);
   except
     Form1.mess_log('Ошибка преобразования в целое !');
     sqlerror:=true;
     continue;
   end;


   form1.ZReadOnlyQuery1.SQL.Clear;
   form1.ZReadOnlyQuery1.SQL.add(' select get_personal_info3(''pdp'', '+Quotedstr(date1)+','+Quotedstr(date2));
   If npoint>1000 then
     form1.ZReadOnlyQuery1.SQL.add(',1')
     else
       form1.ZReadOnlyQuery1.SQL.add(',0');
   form1.ZReadOnlyQuery1.SQL.add(','+Sett.nIdent+');');
   form1.ZReadOnlyQuery1.SQL.add(' FETCH ALL IN pdp;');
   //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
   //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
      form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e35--Ошибка запроса ПДП !');
      sqlerror:=true;
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      continue;
   end;

  If form1.ZReadOnlyQuery1.RecordCount=0 then
    begin
     Form1.mess_log('<<< НЕТ данных за период ! >>>');
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     continue;
    end;

  result:=pathfile+fname;

   If not bHead then
   begin
     bHead:=true;
  //заполняем заголовки столбцов первой строкой
   for m:=0 to form1.ZReadOnlyQuery1.FieldCount-2 do
    begin
      write(fffile,form1.ZReadOnlyQuery1.Fields[m].FieldName+';');
    end;
   write(fffile,form1.ZReadOnlyQuery1.Fields[form1.ZReadOnlyQuery1.FieldCount-1].FieldName+#13);
   end;

  For n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  begin
    //registertimeis;surname;arrivedate;buydate;departdate
     for m:=0 to form1.ZReadOnlyQuery1.FieldCount-2 do
     begin
       If (form1.ZReadOnlyQuery1.Fields[m].FieldName='registertimeis') or
       (form1.ZReadOnlyQuery1.Fields[m].FieldName='arrivedate') or
       (form1.ZReadOnlyQuery1.Fields[m].FieldName='buydate') or
       (form1.ZReadOnlyQuery1.Fields[m].FieldName='departdate') then
        write(fffile,formatDateTime('yyyy-mm-dd',form1.ZReadOnlyQuery1.Fields[m].AsDatetime)+'T'+formatDateTime('hh:nn',form1.ZReadOnlyQuery1.Fields[m].AsDatetime)+'Z;')
       else
         If trim(form1.ZReadOnlyQuery1.Fields[m].AsString)='' then
            begin
              If (form1.ZReadOnlyQuery1.Fields[m].FieldName='name')
              or (form1.ZReadOnlyQuery1.Fields[m].FieldName='surname')
              or (form1.ZReadOnlyQuery1.Fields[m].FieldName='patronymic') then
              write(fffile,'пусто;')
              else
               write(fffile,';');
            end
            else
             begin
              If (form1.ZReadOnlyQuery1.Fields[m].FieldName='birthday') then
                  write(fffile,formatDateTime('yyyy-mm-dd',form1.ZReadOnlyQuery1.Fields[m].AsDatetime)+';')
              else
                  write(fffile,form1.ZReadOnlyQuery1.Fields[m].AsString+';');
             end;
     end;
     write(fffile,form1.ZReadOnlyQuery1.Fields[m+1].AsString+#13);
     form1.ZReadOnlyQuery1.Next;
    end;

   form1.ZReadOnlyQuery1.close;
   form1.ZConnection1.disconnect;
  If (idpoint=0) and (k=5) then
   begin
     Form1.mess_log(inttostr(k)+' WTF!!!  '+arservers[k,1]+' ['+arservers[k,0]+'] '+arservers[k,3]+' '+arservers[k,4]);
   break;
    end;
  end;
 //finally
    closefile(fffile);
  {$I+} // включение контроля ошибок ввода-вывода
    if IOResult<>0 then // если есть ошибка открытия, то
     begin
       Form1.mess_log('--e36--Ошибка создания АРХИВА данных!');
       Exit;
     end;

     if not FileExistsUTF8(pathfile +fname) then
      begin
        Form1.mess_log('--e36--Ошибка! Не найден файл: '+pathfile+fname);
        result:='';
        exit;
       end;


//записать в базе о файле пустышке
   //удалить файл если он пустой
 if result='' then
    begin
     //Form1.mess_log('Удаление пустого файла...');
       //удалить пустой файл
     If not DeleteFileUTF8(pathfile +fname)
     then Form1.mess_log('--e38--Ошибка удаления пустого файла !');
     end;

 //записать в базе о файле пустышке
  if (result='') and not sqlerror  then
       begin
          Form1.mess_log('--i427--Файл с ПДП пуст');
          If form1.CheckBox10.Checked then exit;//$
   If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z5.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      exit;
     end;
     try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
  //проверяем была ли уже передача в эти 10 минут
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add(' INSERT INTO av_pdp_log(id_point, stamp_from, stamp_to, data_exist,file_send,file_answer) VALUES (');
    form1.ZReadOnlyQuery1.SQL.add(inttostr(idpoint)+','+quotedstr(date1)+','+quotedstr(date2)+',false,'''','''');');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
     //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$

     form1.ZReadOnlyQuery1.open;
     form1.ZConnection1.Commit;
   except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
      Form1.mess_log('--e37--Ошибка запроса !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;

      exit;
   end;
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     exit;
end;
  If sqlerror then exit;

//упаковываем полученный файл
    // Запускаем внешнее приложение
  //fpsystem(ExtractFilePath(Application.ExeName)+'plathtml'+' '+trim(FileHTMLname)+' &');
   {$IFDEF LINUX}
   {$I-} // отключение контроля ошибок ввода-вывода
   try
  AssignFile(F,pathfile+'arhiv.sh');
  Rewrite(F);
  WriteLn(F, '#!/bin/bash');
  WriteLn(F, 'cd '+Sett.pathapp+Site.ldir);
  WriteLn(F, 'zip -m '+fname+'.zip '+fname);
  finally
  CloseFile(F);
  end;
   {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
   begin
     Form1.mess_log('--e401--Ошибка создания АРХИВА!');
     Exit;
   end;
  form1.Process1.CommandLine:='/bin/bash '+pathfile +'arhiv.sh';
  //form1.MemoLog.Lines.LoadFromFile(Site.ldir+'arhiv.sh');
  form1.Process1.Options:=form1.Process1.Options + [poWaitOnExit];
  try
    form1.Process1.Execute;
   except
    Form1.mess_log('--e40--Ошибка создания АРХИВА !');
    result:='';
    exit;
  end;
  //form1.Process1.Free;

  {$ENDIF}
  {$IFDEF WINDOWS}
    {$I-} // отключение контроля ошибок ввода-вывода
    try
       AssignFile(F,pathfile+'arhiv.bat');
       Rewrite(F);
       WriteLn(F,'@echo off      ');
       WriteLn(F,'set fname="'+pathfile+fname+'"');
       WriteLn(F,'"C:\7-Zip\7z.exe" a -tzip -ssw -sdel -mx9 %fname%.zip %fname% ');
       //WriteLn(F, 'CD '+filepath);
    finally
       CloseFile(F);
    end;
      {$I+} // включение контроля ошибок ввода-вывода
  if IOResult<>0 then // если есть ошибка открытия, то
   begin
     Form1.mess_log('--e401--Ошибка создания АРХИВА справочника!');
      result:='';
     Exit;
   end;
    //form1.MemoLog.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'arhiv.bat');
    //form1.Process1.Executable:='C:\windows\system32\cmd.exe';
    //form1.Process1.CommandLine:='C:\windows\system32\cmd.exe '+Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat';
    //form1.MemoLog.Lines.LoadFromFile(Site.ldir+'arhiv.sh');
    //form1.Process1.Options:=form1.Process1.Options + [poWaitOnExit];
    //try
    //form1.Process1.Execute;
    //except
    //Form1.mess_log('--e40--Ошибка создания АРХИВА !');
    //result:='';
    //exit;
    //finally
    //form1.Process1.Free;
    //end;

  try
    ExecuteProcess(GetEnvironmentVariable('COMSPEC'), ['/c', Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat']);
  except
    Form1.mess_log('--e40--Ошибка создания АРХИВА справочника!');
    result:='';
    exit;
  end;

    //form1.Process1.CommandLine:='C:\windows\system32\cmd.exe '+Sett.pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat';
    //form1.Process1.Parameters.Clear;
    //form1.Process1.Parameters.Add(pathapp+IncludeTrailingPathDelimiter(Site.ldir)+'arhiv.bat');
  {$ENDIF}
  //Process1.Active:=false;
//Process1.ShowWindow:=swoHIDE;
//Process1.Executable:='cmd';
//Process1.Parameters.Clear;
//Process1.Parameters.Add('/k');
//Process1.Parameters.Add('notepad.exe');
//Process1.Execute;
//Sleep(1000);
//Process1.Active:=false;

  fname:=fname+'.zip';
  If fileexistsUTF8(pathfile +fname) then //;Site.ldir) then
  Form1.mess_log('--s08-- АРХИВ успешно создан '+fname)
  else
    begin
       Form1.mess_log('--e41--Не найден файл АРХИВА '+pathfile +fname+' !!!');
       result:='';
       exit;
    end;
  result:=pathfile +fname; //2;
end;


  //создать xml расписаний
function CreateXmlShedule(stamp_mode:TDateTime):boolean;
var
  xdoc: TXMLDocument;                                  // переменная документа
  RootNode, parentNode, nofilho, data,rut, child,rut2: TDOMNode;
  startR,sizon:string;
  n,form,rejs,max,k,tekshed:integer;
  actual:string;
  countryname:string='Российская Федерация';
begin
  result:=false;
 If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z6.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
   If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с сервером базы данных отсутствует !');
      exit;
     end;

   If active_process=false then active_process:=true;

   form1.ZReadOnlyQuery1.SQL.Clear;
   form1.ZReadOnlyQuery1.SQL.add(' SELECT pdp_shedules(''pdpsh'','+Quotedstr(formatdatetime('yyyy-mm-dd',stamp_mode))+');');
   form1.ZReadOnlyQuery1.SQL.add(' FETCH ALL IN pdpsh;');
  //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      Form1.mess_log('--e43--Ошибка запроса !');
      exit;
   end;

   active_process:=false;

  If form1.ZReadOnlyQuery1.recordcount=0 then
    begin
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     exit;
    end;

  //stamp_spr_actual:=stamp_mode;

  application.ProcessMessages;//$
  //Создаём документ
  xdoc := TXMLDocument.create;

  //Создаём корневой узел
  RootNode := xdoc.CreateElement('imp:Import');
  TDOMElement(RootNode).SetAttribute('xsi:type','imp:FullImport');
  //TDOMElement(RootNode).SetAttribute('xsi:type','imp:DeltaImport');//$
  //s:=formatdatetime('yyyy-mm-ddhh:nn:ss',TimeLocalToUtc(now()));

  actual:=formatdatetime('yyyy-mm-dd',stamp_mode)+'T'+formatdatetime('hh:nn',stamp_mode)+'Z';//$

  //actper:=actper+Form1.PADL(inttostr(actual div 60),'0',2)+':'+Form1.PADL(inttostr(actual mod 60),'0',2)+':00Z';//$
  TDOMElement(RootNode).SetAttribute('createdAt', actual);//$
  TDOMElement(RootNode).SetAttribute('dataType','TIMETABLE_PLAN');
  //TDOMElement(RootNode).SetAttribute('recordCount',inttostr(form1.ZReadOnlyQuery1.recordcount));
  TDOMElement(RootNode).SetAttribute('recordCount',form1.ZReadOnlyQuery1.FieldByName('vsegotrip').AsString);
  TDOMElement(RootNode).SetAttribute('transportSegment','AUTO');
  TDOMElement(RootNode).SetAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
  TDOMElement(RootNode).SetAttribute('xmlns:imp','http://www.egis-otb.ru/gtimport/');
  TDOMElement(RootNode).SetAttribute('xmlns:tt','http://www.egis-otb.ru/data/timetable/');
  TDOMElement(RootNode).SetAttribute('xmlns:dt','http://www.egis-otb.ru/datatypes/');
  TDOMElement(RootNode).SetAttribute('xsi:schemaLocation','http://www.egis-otb.ru/gtimport/ ru.egisotb.import.xsd http://www.egis-otb.ru/data/timetable/ ru.egisotb.data.timetable.xsd ');
  Xdoc.Appendchild(RootNode);                           // Добавляем корневой узел в документ

  //Создаём родительский узел
  RootNode:= xdoc.DocumentElement;
  k:=0;
  tekshed:=0;

  for n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  begin
   form:=form1.ZReadOnlyQuery1.FieldByName('form').asInteger;
   //rejs:=form1.ZReadOnlyQuery1.FieldByName('rejs').asInteger;
   If form=1 then
     begin
     tekshed:=form1.ZReadOnlyQuery1.FieldByName('id_shedule').asinteger;
      //если конечный пункт рейса
      If (form1.ZReadOnlyQuery1.FieldByName('point_order').asInteger=max)  then
        begin
         k:=k+1;
         rut:= xdoc.CreateElement('routePoint');
  //TDOMElement(rut).SetAttribute('departTime',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('depart').asDateTime)+'T'
                                  //+formatdatetime('hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('depart').asDateTime));
  TDOMElement(rut).SetAttribute('arriveTime',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('ddate').asDateTime)+'T'
  +formatdatetime('hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('arrive').asdatetime)+'Z');
                                  //+formatdatetime('hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('arrive').asDateTime));
  TDOMElement(rut).SetAttribute('xsi:type', 'tt:RoutePoint');   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('pathIndex', inttostr(k));   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('timeFromStart', form1.ZReadOnlyQuery1.FieldByName('vputi').asString);   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('stopTimeInterval', form1.ZReadOnlyQuery1.FieldByName('stoit').asString);   // создаём его атрибуты
          child.AppendChild(rut);
          rut2:= xdoc.CreateElement('station');
          TDOMElement(rut2).SetAttribute('value', form1.ZReadOnlyQuery1.FieldByName('station').asString); //form1.ZReadOnlyQuery1.FieldByName('pname').asString);   // создаём его атрибуты
          TDOMElement(rut2).SetAttribute('xsi:type', 'dt:SimpleDictionaryValue');   // создаём его атрибуты
          rut.AppendChild(rut2);
  rut:= xdoc.CreateElement('routeEnd');
  TDOMElement(rut).SetAttribute('value', form1.ZReadOnlyQuery1.FieldByName('station').asString); //form1.ZReadOnlyQuery1.FieldByName('pname').asString);   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('xsi:type', 'dt:SimpleDictionaryValue');   // создаём его атрибуты
  child.AppendChild(rut);
  rut:= xdoc.CreateElement('routeStart');
  TDOMElement(rut).SetAttribute('value', startR);   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('xsi:type', 'dt:SimpleDictionaryValue');   // создаём его атрибуты
  child.AppendChild(rut);

  //Создаём ещё один дочерний узел
  nofilho:= xdoc.CreateElement('calendar');
  TDOMElement(nofilho).SetAttribute('xsi:type','tt:MonthCalendar');   // создаём его атрибуты
  TDOMElement(nofilho).SetAttribute('daymask', sizon);   // создаём его атрибуты
  data.Appendchild(nofilho);
        end;

      //новое вхождение расписания (другой рейс)
  If (form1.ZReadOnlyQuery1.FieldByName('point_order').asInteger<max) or (trim(form1.ZReadOnlyQuery1.FieldByName('max').asString)<>'') then
    begin
     k:=0;
     max:=form1.ZReadOnlyQuery1.FieldByName('max').asInteger;
  parentNode := xdoc.CreateElement('entry');
  //parentNode := xdoc.CreateElement('updated-entry');//$
  TDOMElement(parentNode).SetAttribute('sourceId',form1.ZReadOnlyQuery1.FieldByName('route').asString);        // создаём атрибуты родительского узла
  TDOMElement(parentNode).SetAttribute('xsi:type','imp:ImportedEntry');        // создаём атрибуты родительского узла
  RootNode.Appendchild(parentNode);                        // добавляем родительский узел

  //Создаём дочерний узел
  data := xdoc.CreateElement('data');
  TDOMElement(data).SetAttribute('xsi:type','tt:CalendarTimetable');
  parentNode.AppendChild(data);     // вставляем дочерний узел в соответствующий родительский
   //Создаём дочерний узел
  nofilho := xdoc.CreateElement('actualPeriod');
  //TDOMElement(nofilho).SetAttribute('from',actper);//$
  //If form1.CheckBox1.Checked then
   //TDOMElement(nofilho).SetAttribute('from',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('dates').asDateTime)+'T00:00:00Z')
  //else
  TDOMElement(nofilho).SetAttribute('from',formatdatetime('yyyy-mm-dd',incday(stamp_mode,Sett.nSheddays))+'T00:00Z');
//  TDOMElement(nofilho).SetAttribute('to'  ,formatdatetime('yyyy-mm-dd',incday(now(),upperactual))+'T00:00Z');//$
  TDOMElement(nofilho).SetAttribute('to'  ,'2023-12-31T00:00Z');//$

  //TDOMElement(nofilho).SetAttribute('to',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('datepo').asDateTime)+'T00:00:00Z');
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:ImportDateTimePeriod');
  data.AppendChild(nofilho);
  //Создаём ещё один дочерний узел
  nofilho:= xdoc.CreateElement('operator');
  TDOMElement(nofilho).SetAttribute('value', form1.ZReadOnlyQuery1.FieldByName('egisid').asString);   // создаём его атрибуты
  data.Appendchild(nofilho);                         // сохраняем узел
  //Создаём ещё один дочерний узел
  //nofilho:= xdoc.CreateElement('calendar');
  //TDOMElement(nofilho).SetAttribute('xsi:type','tt:MonthCalendar');   // создаём его атрибуты
  //TDOMElement(nofilho).SetAttribute('daymask', form1.ZReadOnlyQuery1.FieldByName('sezon').asString);   // создаём его атрибуты
  //data.Appendchild(nofilho);                         // сохраняем узел
  sizon:='1111111111111111111111111111111';
  //If form1.ZReadOnlyQuery1.FieldByName('sezon').asString='0000000000000000000000000000000' then //$
      //sizon:='0100000000000001000000000000010'                                                  //$
    //else                                                                                        //$
      //sizon:=form1.ZReadOnlyQuery1.FieldByName('sezon').asString;                               //$

  child:= xdoc.CreateElement('route');
  TDOMElement(child).SetAttribute('routeName', form1.ZReadOnlyQuery1.FieldByName('rejs_name').asString);   // имя рейса
  //TDOMElement(child).SetAttribute('routeName', form1.ZReadOnlyQuery1.FieldByName('pname').asString+'-'+form1.ZReadOnlyQuery1.FieldByName('rname').asString);   // создаём его атрибуты
  //TDOMElement(child).SetAttribute('routeName', form1.ZReadOnlyQuery1.FieldByName('id_point').asString+'-'+form1.ZReadOnlyQuery1.FieldByName('point_end').asString);   // создаём его атрибуты
  TDOMElement(child).SetAttribute('international', lowercase(form1.ZReadOnlyQuery1.FieldByName('international').asString));   // признак международного
  TDOMElement(child).SetAttribute('chartered', lowercase(form1.ZReadOnlyQuery1.FieldByName('chartered').asString));   // признак заказного
  TDOMElement(child).SetAttribute('xsi:type', 'tt:RouteHead');   // создаём его атрибуты
  data.AppendChild(child);

  rut:= xdoc.CreateElement('routePoint');
  TDOMElement(rut).SetAttribute('departTime',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('ddate').asDateTime)+'T'
  +formatdatetime('hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('depart').asDatetime)+'Z');
                                  //+formatdatetime('hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('depart').asDateTime));
  TDOMElement(rut).SetAttribute('xsi:type', 'tt:RoutePoint');   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('pathIndex', inttostr(k));   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('timeFromStart','0');   // создаём его атрибуты
  TDOMElement(rut).SetAttribute('stopTimeInterval', form1.ZReadOnlyQuery1.FieldByName('stoit').asString);   // создаём его атрибуты
  child.AppendChild(rut);

  rut2:= xdoc.CreateElement('station');
  TDOMElement(rut2).SetAttribute('value', form1.ZReadOnlyQuery1.FieldByName('station').asString); //form1.ZReadOnlyQuery1.FieldByName('pname').asString);   // создаём его атрибуты
  TDOMElement(rut2).SetAttribute('xsi:type', 'dt:SimpleDictionaryValue');   // создаём его атрибуты
  rut.AppendChild(rut2);
   startR:='';
   startR:=form1.ZReadOnlyQuery1.FieldByName('station').asString; //form1.ZReadOnlyQuery1.FieldByName('pname').asString;

     end;
     end;

     If form=0 then
       begin
         if tekshed=form1.ZReadOnlyQuery1.FieldByName('id_shedule').asinteger then
         begin
      k:=k+1;
      rut:= xdoc.CreateElement('routePoint');
       TDOMElement(rut).SetAttribute('departTime',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('ddate').asDateTime)+'T'
                                  +formatdatetime('hh:nn',form1.ZReadOnlyQuery1.FieldByName('depart').asDateTime)+'Z');
       TDOMElement(rut).SetAttribute('arriveTime',formatdatetime('yyyy-mm-dd',form1.ZReadOnlyQuery1.FieldByName('ddate').asDateTime)+'T'
                                  +formatdatetime('hh:nn',form1.ZReadOnlyQuery1.FieldByName('arrive').asDateTime)+'Z');
       TDOMElement(rut).SetAttribute('xsi:type', 'tt:RoutePoint');   // создаём его атрибуты
       TDOMElement(rut).SetAttribute('pathIndex', inttostr(k));   // создаём его атрибуты
       TDOMElement(rut).SetAttribute('stopTimeInterval', form1.ZReadOnlyQuery1.FieldByName('stoit').asString);   // создаём его атрибуты
       TDOMElement(rut).SetAttribute('timeFromStart', form1.ZReadOnlyQuery1.FieldByName('vputi').asString);   // создаём его атрибуты
       child.AppendChild(rut);

       rut2:= xdoc.CreateElement('station');
       TDOMElement(rut2).SetAttribute('value', form1.ZReadOnlyQuery1.FieldByName('station').asString); //form1.ZReadOnlyQuery1.FieldByName('pname').asString);   // создаём его атрибуты
       TDOMElement(rut2).SetAttribute('xsi:type', 'dt:SimpleDictionaryValue');   // создаём его атрибуты
       rut.AppendChild(rut2);
         end
         else
            Form1.mess_log('--e431--Ошибка формирования состава расписания !'+#13
            +'tekshed='+inttostr(tekshed)+' | shed='+form1.ZReadOnlyQuery1.FieldByName('id_shedule').asstring+' | k='+inttostr(k)
            );
     end;


  form1.ZReadOnlyQuery1.Next;
  end;

  form1.ZReadOnlyQuery1.Close;
  form1.ZConnection1.Disconnect;
 //если в автомате, то используем реальное время, если нет, То из первого периода


  xml_name:=sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh',stamp_mode)+'_00_'+formatDateTime('ss_zzz',now())+'.xml';
   If not DirectoryExistsUTF8(ExtractFilePath(Application.ExeName)+Site.ldir)  then
     begin
       CreateDir(ExtractFilePath(Application.ExeName)+'SHEDULES');
       Site.ldir:='SHEDULES';
     end;
  uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  writeXMLFile(xDoc,uploadFile);  // записываем всё в XML-файл
  Xdoc.free;                                               // освобождаем память
  result:=true;
end;




//создать xml
function CreateXmlServers():boolean;
var
  xdoc: TXMLDocument;                                  // переменная документа
  RootNode, parentNode , nofilho, tmp: TDOMNode;
  s:string;
   n:integer;
    Ini: TIniFile;
  i: Integer;
  path: string;
begin
  result:=false;

  path:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.ini';
  if not FileExistsUTF8(path) then
    begin
       If MessageDlg('Файл настроек НЕ НАЙДЕН !'+#13+'Создать файл настроек со значениями по умолчанию?',mtConfirmation, mbYesNo, 0)=7 then exit;
    end;
  Ini := TIniFile.Create(path);

  //Создаём документ
  xdoc := TXMLDocument.create;

  //Создаём корневой узел
  RootNode := xdoc.CreateElement('imp:Import');
  TDOMElement(RootNode).SetAttribute('xsi:type','imp:FullImport');

//  s:=formatdatetime('yyyy-mm-ddhh:nn:ss',TimeLocalToUtc(now()));
  //try
  //actual:=strtoint(copy(s,1,2))*60+strtoint(copy(s,3,2))+10;
  //except
  //exit;
  //end;
  TDOMElement(RootNode).SetAttribute('createdAt',formatdatetime('yyyy-mm-dd',form1.DateTimePicker1.DateTime)+'T'+formatdatetime('hh:nn',form1.DateTimePicker1.DateTime)+'Z');
  TDOMElement(RootNode).SetAttribute('recordCount','1');
  TDOMElement(RootNode).SetAttribute('dataType','TRANSPORT_SUBJECT');
  TDOMElement(RootNode).SetAttribute('transportSegment','AUTO');
  TDOMElement(RootNode).SetAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
  TDOMElement(RootNode).SetAttribute('xmlns:imp','http://www.egis-otb.ru/gtimport/');
  TDOMElement(RootNode).SetAttribute('xmlns:dt','http://www.egis-otb.ru/datatypes/');
  TDOMElement(RootNode).SetAttribute('xmlns:transsubj','http://www.egis-otb.ru/data/onsi/transportSubject/');
  TDOMElement(RootNode).SetAttribute('xmlns:onsi-stat','http://www.egis-otb.ru/data/onsi/stations/');
  TDOMElement(RootNode).SetAttribute('xsi:schemaLocation','http://www.egis-otb.ru/gtimport/ ru.egisotb.import.xsd http://www.egis-otb.ru/data/onsi/transportSubject/ ru.egisotb.data.onsi.transportSubject.xsd');

  Xdoc.Appendchild(RootNode);                           // Добавляем корневой узел в документ

  //Создаём родительский узел
  RootNode:= xdoc.DocumentElement;

  //for n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  //begin
  parentNode := xdoc.CreateElement('entry');
  TDOMElement(parentNode).SetAttribute('sourceId',Sett.nIdent);       // создаём атрибут ы родительского узла
  TDOMElement(parentNode).SetAttribute('xsi:type','imp:ImportedEntry');        // создаём атрибуты родительского узла
  RootNode.Appendchild(parentNode);                        // добавляем родительский узел
   try
  //Создаём дочерний узел
  tmp := xdoc.CreateElement('data');
  //Form1.mess_log(form1.ZReadOnlyQuery1.FieldByName('name').asString);
  s:='Отдел КО';
  TDOMElement(tmp).SetAttribute('contactDepartment',Ini.ReadString('contact','Department',''));
  TDOMElement(tmp).SetAttribute('contactEmail',Ini.ReadString('contact','Email',''));
  TDOMElement(tmp).SetAttribute('contactFax',Ini.ReadString('contact','Fax',''));
  s:='Николаевич';
  TDOMElement(tmp).SetAttribute('contactLastname',Ini.ReadString('contact','LastName',''));
  s:='Георгий';
  TDOMElement(tmp).SetAttribute('contactName',Ini.ReadString('contact','Name',''));
  s:='зам.начальника Отдела';
  TDOMElement(tmp).SetAttribute('contactPerson',Ini.ReadString('contact','Person',''));
  TDOMElement(tmp).SetAttribute('contactPhone',Ini.ReadString('contact','Phone',''));
  s:='355017, Россия, Ставропольский край, г.Ставрополь, ул. Маршала Жукова, д. 29';
  TDOMElement(tmp).SetAttribute('contactPost',Ini.ReadString('contact','Post',''));
  s:='Лубенцов';
  TDOMElement(tmp).SetAttribute('contactSurname',Ini.ReadString('contact','Surname',''));
  s:='Ставропольский автовокзал';
  TDOMElement(tmp).SetAttribute('fullName',Ini.ReadString('contact','Fullname',''));
  TDOMElement(tmp).SetAttribute('kladr',Ini.ReadString('contact','kladr',''));
  TDOMElement(tmp).SetAttribute('latName',Ini.ReadString('contact','latname',''));
  TDOMElement(tmp).SetAttribute('latitude','');
  //s:='355017, Россия, Ставропольский край, г.Ставрополь, ул. Маршала Жукова, д. 29';
  TDOMElement(tmp).SetAttribute('lawAddress',Ini.ReadString('contact','lawadress',''));
  TDOMElement(tmp).SetAttribute('longitude','');
  TDOMElement(tmp).SetAttribute('nearTown',Ini.ReadString('contact','nearTown',''));
  TDOMElement(tmp).SetAttribute('shortName',Ini.ReadString('contact','shortName',''));
  TDOMElement(tmp).SetAttribute('egrul',Ini.ReadString('contact','egrul',''));
  TDOMElement(tmp).SetAttribute('egrip',Ini.ReadString('contact','egrip',''));
  s:='Ставрополь';
  //TDOMElement(tmp).SetAttribute('city',s);
  TDOMElement(tmp).SetAttribute('xsi:type','transsubj:TransportSubject');
  TDOMElement(tmp).SetAttribute('egisId',Sett.nIdent);
  //Создаём дочерний узел
  nofilho := xdoc.CreateElement('actualPeriod');
  TDOMElement(nofilho).SetAttribute('from',formatdatetime('yyyy-mm-dd',incday(form1.DateTimePicker1.DateTime,Sett.nSheddays))+'T'+formatdatetime('hh:nn',form1.DateTimePicker1.DateTime)+'Z');
  //TDOMElement(nofilho).SetAttribute('to'  ,formatdatetime('yyyy-mm-dd',incday(now(),upperactual))+'T00:00Z');//$
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:ImportDateTimePeriod');
  tmp.AppendChild(nofilho);
  //Создаём дочерний узел
  nofilho := xdoc.CreateElement('okato');
  TDOMElement(nofilho).SetAttribute('value',Sett.nOkato);
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:SimpleDictionaryValue');
  tmp.AppendChild(nofilho);     // вставляем дочерний узел в соответствующий родительский
  //Создаём дочерний узел
  nofilho := xdoc.CreateElement('country');
  TDOMElement(nofilho).SetAttribute('id',Sett.countryid);
  TDOMElement(nofilho).SetAttribute('value',Sett.countryname);
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:SimpleDictionaryValue');
  tmp.AppendChild(nofilho);
  //form1.ZReadOnlyQuery1.Next;
  //end;
  parentNode.AppendChild(tmp);     // вставляем дочерний узел в соответствующий родительский

  xml_name:=Sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh_nn_ss_zzz',now())+'.xml';
  //writeXMLFile(xDoc,'servers__.xml');                           // записываем всё в XML-файл
   If not DirectoryExistsUTF8(ExtractFilePath(Application.ExeName)+Site.ldir)  then
     begin
       CreateDir(ExtractFilePath(Application.ExeName)+'SERVERS');
       Site.ldir:='SERVERS';
     end;
  uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  writeXMLFile(xDoc,uploadFile);
  Xdoc.free;                                               // освобождаем память
  result:=true;

   finally
    Ini.Free;
  end;

  //form1.EditLocalFile.Text:=ExtractFilePath(Application.ExeName)+xml_servers_name;
end;


//создать xml перевозчиков
function CreateXmlPerevoz(stamp_mode:TDateTime):boolean;
var
  xdoc: TXMLDocument;                                  // переменная документа
  RootNode, parentNode, nofilho, tmp: TDOMNode;
  sden, str:string;
  strana:string;
  n:integer;
begin
  result:=false;
   If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z7.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
   If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с сервером базы данных отсутствует !');
      exit;
     end;

   sden:=formatdatetime('yyyy-mm-dd',stamp_mode);
     //If IncDay(now(),-1)>stamp_mode then str:='and createdate<='+Quotedstr(sden)
   //else
     str:='';
   form1.ZReadOnlyQuery1.SQL.Clear;
   form1.ZReadOnlyQuery1.SQL.add('select * ');
   form1.ZReadOnlyQuery1.SQL.add(',(case when strana=''0'' then '''' else (select short_name from av_country where id=to_number(x.strana,''FM999'') limit 1) end) cntry ');
   form1.ZReadOnlyQuery1.SQL.add(' FROM (');
   form1.ZReadOnlyQuery1.SQL.add('select * ');
   //form1.ZReadOnlyQuery1.SQL.add(',(select b.egisid FROM av_spr_kontr_fio b where b.id_kontr=c.id and b.createdate<'+quotedstr(sden)+' order by b.del asc, b.createdate desc limit 1) as egisid ');
   form1.ZReadOnlyQuery1.SQL.add(',(select b.ogrn FROM av_spr_kontr_fio b where b.id_kontr=c.id '+str+' order by b.del asc, b.createdate desc limit 1) as ogrn ');
   form1.ZReadOnlyQuery1.SQL.add(',(select b.ogrnip FROM av_spr_kontr_fio b where b.id_kontr=c.id '+str+' order by b.del asc, b.createdate desc limit 1) as ogrnip ');
   form1.ZReadOnlyQuery1.SQL.add(',(select b.polname FROM av_spr_kontragent b where b.id=c.id '+str+' order by b.del asc, b.createdate desc limit 1) as polname ');
   form1.ZReadOnlyQuery1.SQL.add(',(select b.name FROM av_spr_kontragent b where b.id=c.id '+str+' order by b.del asc, b.createdate desc limit 1) as name ');
   form1.ZReadOnlyQuery1.SQL.add(',coalesce((select b.adrpos FROM av_spr_kontragent b where length(b.adrpos)<8 and b.adrpos<>'''' and b.id=c.id order by b.del asc, b.createdate desc limit 1),''0'') as strana ');
   form1.ZReadOnlyQuery1.SQL.add('from ( ');
   form1.ZReadOnlyQuery1.SQL.add('   select * ');
   form1.ZReadOnlyQuery1.SQL.add('  ,(select b.id_kontr FROM av_spr_kontr_fio b where b.egisid=a.egisid '+str+' order by b.del asc, b.createdate desc limit 1) as id ');
   form1.ZReadOnlyQuery1.SQL.add('from ( ');
   form1.ZReadOnlyQuery1.SQL.add('select c.egisid,count(*) ');
   form1.ZReadOnlyQuery1.SQL.add(' FROM av_spr_kontr_fio c where c.del=0 ');
   form1.ZReadOnlyQuery1.SQL.add(' and not(trim(c.ogrnip)='''' and trim(c.ogrn)='''') and not(trim(c.egisid)='''') ');
   //form1.ZReadOnlyQuery1.SQL.add(' and c.id_kontr not in (3944,5424)');//$
   form1.ZReadOnlyQuery1.SQL.add(' group by c.egisid --having count(*)>1 ');
   form1.ZReadOnlyQuery1.SQL.add(' ) a ');
   form1.ZReadOnlyQuery1.SQL.add(' ) c');
   form1.ZReadOnlyQuery1.SQL.add(' ) x;');
   //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$

   //form1.ZReadOnlyQuery1.SQL.add('select c.id_kontr as id ');
   //form1.ZReadOnlyQuery1.SQL.add(' FROM av_spr_kontr_fio c where ');
   //form1.ZReadOnlyQuery1.SQL.add(' not(trim(c.ogrnip)='''' and trim(c.ogrn)='''') and not(trim(c.egisid)='''') ');
   //form1.ZReadOnlyQuery1.SQL.add(' and c.createdate<'+quotedstr(sden)+' ');
   //form1.ZReadOnlyQuery1.SQL.add(' group by c.id_kontr ');
   //form1.ZReadOnlyQuery1.SQL.add(' ) c; ');
   //form1.ZReadOnlyQuery1.SQL.add('select distinct on (a.egisid) a.id_kontr,a.ogrn,a.ogrnip,a.egisid');
   //form1.ZReadOnlyQuery1.SQL.add(',(select b.polname FROM av_spr_kontragent b where b.id=a.id_kontr order by b.del asc, b.createdate desc limit 1) as polname ');
   //form1.ZReadOnlyQuery1.SQL.add(',(select b.name FROM av_spr_kontragent b where b.id=a.id_kontr order by b.del asc, b.createdate desc limit 1) as name ');
   //form1.ZReadOnlyQuery1.SQL.add(' FROM av_spr_kontr_fio a where a.del=0 ');
   //form1.ZReadOnlyQuery1.SQL.add(' and not(trim(ogrnip)='''' and trim(ogrn)='''') and not(trim(egisid)='''') ');

   //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
   try
     form1.ZReadOnlyQuery1.open;
   except
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      Form1.mess_log('--e44--Ошибка запроса !');
      exit;
   end;
  If form1.ZReadOnlyQuery1.recordcount=0 then
    begin
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     exit;
    end;
  //Создаём документ
  xdoc := TXMLDocument.create;

  //Создаём корневой узел
  RootNode := xdoc.CreateElement('imp:Import');
  TDOMElement(RootNode).SetAttribute('xsi:type','imp:FullImport');
  //TDOMElement(RootNode).SetAttribute('xsi:type','imp:DeltaImport');//$
  //s:=formatdatetime('yyyy-mm-ddhh:nn:ss',TimeLocalToUtc(now()));//$

  TDOMElement(RootNode).SetAttribute('createdAt', formatdatetime('yyyy-mm-dd',stamp_mode)+'T'+formatdatetime('hh:nn',stamp_mode)+'Z');//$
  TDOMElement(RootNode).SetAttribute('recordCount',inttostr(form1.ZReadOnlyQuery1.recordcount));
  TDOMElement(RootNode).SetAttribute('dataType','OPERATOR');
  TDOMElement(RootNode).SetAttribute('transportSegment','AUTO');
  TDOMElement(RootNode).SetAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
  TDOMElement(RootNode).SetAttribute('xmlns:imp','http://www.egis-otb.ru/gtimport/');
  TDOMElement(RootNode).SetAttribute('xmlns:dt','http://www.egis-otb.ru/datatypes/');
  TDOMElement(RootNode).SetAttribute('xmlns:opers','http://www.egis-otb.ru/data/onsi/operators/');
  TDOMElement(RootNode).SetAttribute('xsi:schemaLocation','http://www.egis-otb.ru/gtimport/ ru.egisotb.import.xsd http://www.egis-otb.ru/data/onsi/operators/ ru.egisotb.data.onsi.operators.xsd');

  Xdoc.Appendchild(RootNode);                           // Добавляем корневой узел в документ

  //Создаём родительский узел
  RootNode:= xdoc.DocumentElement;

  for n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  begin
  parentNode := xdoc.CreateElement('entry');
  //parentNode := xdoc.CreateElement('updated-entry');//$
  TDOMElement(parentNode).SetAttribute('sourceId',form1.ZReadOnlyQuery1.FieldByName('id').asString);        // создаём атрибуты родительского узла
  TDOMElement(parentNode).SetAttribute('xsi:type','imp:ImportedEntry');        // создаём атрибуты родительского узла
  RootNode.Appendchild(parentNode);                        // добавляем родительский узел

  //Создаём дочерний узел
  tmp := xdoc.CreateElement('data');
  TDOMElement(tmp).SetAttribute('xsi:type','opers:Operator');
  //Form1.mess_log(form1.ZReadOnlyQuery1.FieldByName('name').asString);
  TDOMElement(tmp).SetAttribute('name',form1.ZReadOnlyQuery1.FieldByName('polname').asString); // form1.ZReadOnlyQuery1.FieldByName('name').asString);     // создаём его атрибуты
  TDOMElement(tmp).SetAttribute('contactDepartment','');
  TDOMElement(tmp).SetAttribute('contactEmail','');
  TDOMElement(tmp).SetAttribute('contactFax','');
  TDOMElement(tmp).SetAttribute('contactLastname','');
  TDOMElement(tmp).SetAttribute('contactName','');
  TDOMElement(tmp).SetAttribute('contactPerson','');
  TDOMElement(tmp).SetAttribute('contactPhone','');
  TDOMElement(tmp).SetAttribute('contactPost','');
  TDOMElement(tmp).SetAttribute('contactSurname','');
  If trim(form1.ZReadOnlyQuery1.FieldByName('ogrn').asString)='' then
  TDOMElement(tmp).SetAttribute('egrip',form1.ZReadOnlyQuery1.FieldByName('ogrnip').asString)
  else
   TDOMElement(tmp).SetAttribute('egrul',form1.ZReadOnlyQuery1.FieldByName('ogrn').asString);
  //TDOMElement(tmp).SetAttribute('latName','');
  //TDOMElement(tmp).SetAttribute('lawAddress','');
  TDOMElement(tmp).SetAttribute('shortName',form1.ZReadOnlyQuery1.FieldByName('name').asString);
  TDOMElement(tmp).SetAttribute('egisId',form1.ZReadOnlyQuery1.FieldByName('egisid').asString);
  nofilho := xdoc.CreateElement('actualPeriod');
  //TDOMElement(nofilho).SetAttribute('from',actper);//$
  TDOMElement(nofilho).SetAttribute('from',formatdatetime('yyyy-mm-dd',IncDay(stamp_mode,Sett.nSheddays))+'T00:00Z');//$
  TDOMElement(nofilho).SetAttribute('to'  ,formatdatetime('yyyy-mm-dd',incday(now(),upperactual))+'T00:00Z');//$
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:ImportDateTimePeriod');
  tmp.AppendChild(nofilho);
  nofilho := xdoc.CreateElement('country');
  If form1.ZReadOnlyQuery1.FieldByName('strana').AsInteger=0 then
  begin
    TDOMElement(nofilho).SetAttribute('id',Sett.countryid);
    TDOMElement(nofilho).SetAttribute('value',Sett.countryname);
  end
  else
  begin
    TDOMElement(nofilho).SetAttribute('id',form1.ZReadOnlyQuery1.FieldByName('strana').AsString);
    TDOMElement(nofilho).SetAttribute('value',form1.ZReadOnlyQuery1.FieldByName('cntry').AsString);
    //TDOMElement(nofilho).SetAttribute('value',Sett.countryname);
  end;
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:SimpleDictionaryValue');
  tmp.AppendChild(nofilho);

   parentNode.AppendChild(tmp);     // вставляем дочерний узел в соответствующий родительский
  form1.ZReadOnlyQuery1.Next;
  end;

  form1.ZReadOnlyQuery1.Close;
  form1.ZConnection1.Disconnect;
   //если в автомате, то используем реальное время, если нет, То из первого периода
  //If form1.CheckBox2.Checked then
     //xml_name:=nIdent+'_'+formatDateTime('yyyy_mm_dd_hh_nn_ss_zzz',now())+'.xml'
  //else
     xml_name:=Sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh',stamp_mode)+'_00_'+formatDateTime('ss_zzz',now())+'.xml';//$
  If not DirectoryExistsUTF8(ExtractFilePath(Application.ExeName)+Site.ldir)  then
     begin
       CreateDir(ExtractFilePath(Application.ExeName)+'PEREVOZ');
       Site.ldir:='PEREVOZ';
     end;
  uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  writeXMLFile(xDoc,uploadFile);
  Xdoc.free;                                               // освобождаем память
  result:=true;
end;


// ПОПЫТКИ ПОДКЛЮЧЕНИЯ К БАЗЕ
function TForm1.Connect(ZCon:TZConnection;serv:integer):boolean;
var
   counter:Tdatetime;
begin
 result:=false;
 //подключаемся к центральному серверу
 If serv=-1 then
   begin
  Zcon.user:=Sett.cUser;
  Zcon.password:=Sett.cPass;
  Zcon.hostname:=Sett.cHost;
 try
  Zcon.port:=Sett.nPort;
 except
   on exception: EConvertError do
  begin
    Form1.mess_log('ОШИБКА КОНВЕРТАЦИИ !!! '+'НЕВЕРНОЕ ЗНАЧЕНИЕ ПОРТА !');
    exit;
  end;
 end;
     Zcon.Database:=Sett.cBase;
  end;

  If ZCon.Connected then
    begin
    If ZCon.InTransaction then Zcon.Rollback;
    ZCon.Disconnect;
    end;
  counter:=time();

 while 1=1 do
 begin
   If (time()-counter>strtotime('00:00:59')) then break;
   //begin
     //showmessage(formatdatetime('hh:nn:ss',time()-counter)+#13+hostname);
    //continue;
   //end;
    If ZCon.Connected then break;
 //если подключение НЕ к центральной базе
  if serv>-1 then
    begin
     //showmessage(arservers[serv,3]);
     //mess_log( arservers[serv,3]);
    If (hostname<>arservers[serv,3]) and (hostname<>arservers[serv,2]) then
      hostname:=arservers[serv,3];
    //если не можем подключиться по одному адресу, используем другой
      If connectionfail>1 then
        begin
       If hostname=arservers[serv,3] then
            hostname:=arservers[serv,2]
           else
            hostname:=arservers[serv,3];
       connectionfail:=0;
       end;
      Zcon.hostname:=hostname;
    //Zcon.hostname:='10.10.1.34';
     try
       Zcon.port:=strToInt(arservers[serv,7]);
      except
         on exception: EConvertError do
         begin
          Form1.mess_log('ОШИБКА КОНВЕРТАЦИИ !!! '+'НЕВЕРНОЕ ЗНАЧЕНИЕ ПОРТА !');
          exit;
         end;
      end;
      //showmessage(arservers[n,4]);//$
     Zcon.Database:=arservers[serv,4];
     Zcon.user:=arservers[serv,5];
     Zcon.password:=arservers[serv,6];

    end;
    //Form1.mess_log(Zcon.user+#13+Zcon.password+#13+Zcon.hostname+#13+inttostr(Zcon.port)+#13+Zcon.Database);


   Zcon.Properties.Text:='timeout=5';
   try
      ZCon.connect;
   except
      on E:Exception do
      begin
       Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i06--НЕ удается подключиться к БД по адресу: '+hostname +' !!!');
       inc(connectionfail);
      //flwait:=true;
      continue;
      end;
   end;
   //if serv>-1 then
   //  If Zcon.Connected then
   //    begin
   //     inc(connectionfail);
   //     Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--Подлкючено по адресу: '+hostname +' !!!');
   //     Zcon.Disconnect;
   //    end
   //else
   break;
 end;
    If ZCon.Connected then result:=true;
end;

//заблокировать авто отправку файлов
procedure TForm1.Image2Click(Sender: TObject);
begin
   form1.stop_auto_upload();
   form1.Image2.Visible:=false;
   form1.Image4.Visible:=true;
end;

//разблокировать автозагрузку квитанций
procedure TForm1.Image3Click(Sender: TObject);
begin
   form1.stop_auto_download();
   form1.Image3.Visible:=false;
   form1.Image5.Visible:=true;
end;

//разблокировать авто отправку файлов
procedure TForm1.Image4Click(Sender: TObject);
begin
   form1.stop_auto_upload();
   form1.Image2.Visible:=true;
   form1.Image4.Visible:=false;
end;

//заблокировать авто загрузку квитанций
procedure TForm1.Image5Click(Sender: TObject);
begin
   form1.stop_auto_download();
   form1.Image5.Visible:=false;
   form1.Image3.Visible:=true;
end;



procedure TForm1.TCountDownTimer(Sender: TObject);
var
   myYear, myMonth, myDay : Word;
   //tempstamp:TDatetime;
   repair:boolean;
   k:integer;
begin
  // Часы + Дата
  //DecodeDate(Date, myYear, myMonth, myDay);
 //If active_process then
 //begin
 //   //Form1.mess_log('--i01--Идет обработка данных. ВЫХОД.');
 //   exit;
 //end;
 label9.Caption:=inttostr(attempt);//formatdatetime('yyyy-mm-dd hh:nn:ss',stamp_spr_actual);//$
 inc(ziz);//$
 If (ziz>60) and (ziz<3600) then label22.Caption:=inttostr(ziz div 60)+' мин. '+inttostr(ziz mod 60)+' сек.';//minutes$
 If ziz>3600 then label22.Caption:=inttostr(ziz div 3600)+' ч. '+inttostr((ziz mod 3600) div 60)+' мин. '+inttostr(ziz mod 60)+' сек.';//minutes$
   //в ожидании приема

 inc(timercnt);//таймер зависонов

   //если прием включен
    If form1.Image5.Visible then
      begin
         If (form1.Label7.Caption='---:---:---')   then
           begin
           //If form1.TimerGet.Enabled then exit;
           form1.Label7.Caption:=
           padl(inttostr(Sett.downloadtime div 3600),'0',2)+':'
           +padl(inttostr(Sett.downloadtime div 60 - (Sett.downloadtime div 3600 *60)),'0',2)+':'
           +padl(inttostr(Sett.downloadtime - (Sett.downloadtime div 60 * 60 - (Sett.downloadtime div 3600 *60))),'0',2);
           exit;
           end;
    end;

   //если передача включена
    If form1.Image2.Visible then
    begin
      //в ожидании начала отправки
       If (form1.Label1.Caption='---:---:---') then
       begin
       form1.Label1.Caption:=
     padl(inttostr(Sett.uploadtime div 3600),'0',2)+':'
    +padl(inttostr(Sett.uploadtime div 60 - (Sett.uploadtime div 3600 *60)),'0',2)+':'
    +padl(inttostr(Sett.uploadtime - (Sett.uploadtime div 60 * 60 - (Sett.uploadtime div 3600 *60))),'0',2);
       exit;
       end;
    end;

    If active_process then
 begin
    //Form1.mess_log('--i01--Идет обработка данных. ВЫХОД.');
    exit;
 end;
   form1.TCountDown.Enabled:=false;
   //If not form1.TimerRegular.Enabled then
   //begin
    //form1.TimerRegular.Enabled:=true;
    //exit;
   //end;

   //получение ответов
     If (form1.Label7.Caption<>'00:00:00') and form1.Image5.Visible then
     begin
     form1.Label7.Caption:=CntDown(form1.Label7.Caption);
      If form1.Label7.Caption='00:00:00' then
       begin
       If length(arans)=0 then files_to_get();
       //form1.start_auto_download();
       //ПОЛУЧЕНИЕ ОТВЕТОВ С СЕРВЕРА
        Data_Get();
        //stop_auto_download();
       end;

    //   If (form1.Label7.Caption='00:00:00') then
    //begin
    // //If form1.TimerGet.Enabled then exit;
    //form1.Label7.Caption:=
    // padl(inttostr(Sett.downloadtime div 3600),'0',2)+':'
    //+padl(inttostr(Sett.downloadtime div 60 - (Sett.downloadtime div 3600 *60)),'0',2)+':'
    //+padl(inttostr(Sett.downloadtime - (Sett.downloadtime div 60 * 60 - (Sett.downloadtime div 3600 *60))),'0',2);
    //end;
      end;
      //exit;

    //отправка данных
  If (form1.Label1.Caption<>'00:00:00') and form1.Image2.Visible  then
  begin
      repair:=false;
      form1.Label1.Caption:=CntDown(form1.Label1.Caption);
      If form1.Label1.Caption='00:00:00' then
       begin

         //tempstamp:=stamp_spr_send;
       //поиск ошибок и повторная передача
        If checkbox10.Checked then
        begin

          //Если тупо надо еще раз отправить по отделению
        If utf8pos('|',form1.ComboBox1.Text)>0 then
         begin
           try strtoint(utf8copy(form1.ComboBox1.Text,1,utf8pos('|',form1.ComboBox1.Text)-1))
           except
             showmessage('Некорректный сервер!');
             exit;
           end;

           //k:=0;
          //while k<5 do
           begin
            If timesend<form1.DateTimePicker2.DateTime then
            begin
            //showmessage(formatDateTime('yyyy-mm-dd hh:nn:ss',timesend));
            //showmessage(formatDateTime('yyyy-mm-dd hh:nn:ss',incminute(timesend,30)));
            data_send(formatDateTime('yyyy-mm-dd hh:nn:ss',timesend),formatDateTime('dd-mm-yyyy hh:nn:ss',incminute(timesend,30)),utf8copy(form1.ComboBox1.Text,1,utf8pos('|',form1.ComboBox1.Text)-1));
            inc(k);
            timesend:=incminute(timesend,30);
            end
           else
           begin
              Form1.mess_log('!!!!!!!!  DONE !!!!!!!!');
           end;
          end;
         end;

          If not(Sett.fixempty or Sett.fixvse or Sett.fixdocs or Sett.fixroute) then
          begin
            Form1.mess_log('--s47-- Не выбрана ни одна из опций исправления ошибочных данных! ');
           end
         else
           begin
             //If Sett.fixempty and not repair then repair:=Data_reSENDempty();
             If (Sett.fixvse or Sett.fixdocs or Sett.fixroute) and not repair then
                begin
                 //repair:=Data_Resend();
                 end;
            end;

        end;

         //если ошибок нет, продолжим
         If not repair then
         begin
          form1.DateTimePicker1.DateTime:=time_main;

        If form1.CheckBox8.Checked or form1.CheckBox11.Checked then
           begin
              //обновление справочников
           If stamp_spr_send<incDay(ZeroDateTime,2) then
             Spr_Send('firsttime')
             else
              begin
             //если  период справочников меньше периодa данных (уменьшенного на n дней) или
            //период передачи данных меньше периода справочников отправляем
             //если справочники были отправлены, но корректного ответа еще не было
              If (time_main<stamp_spr_actual) OR
              (stamp_spr_send_correct<stamp_spr_send) OR
              (stamp_spr_actual<(incDay(time_main,(Sett.nSheddays div 2))))
                then
                    begin
                       Spr_Send('present');//$
                    end
                else
                    begin
                     //если справочники передавались давно, передадим еще раз
                       If stamp_spr_send<(incDay(now(),Sett.nSheddays+1)) then
                              Spr_Send('present');//$
                      //If (time_main>stamp_spr_actual) then
                          //form1.mess_log('|\/| s_s_a: '+formatdatetime('dd-mm hh:nn',stamp_spr_actual)+' <  t_m: '+formatdatetime('dd-mm hh:nn',time_main));
                          //else form1.mess_log('|\/|1');
                      //If (stamp_spr_send_correct>stamp_spr_send) then
                          //form1.mess_log('|\/| s_s_s_c: '+formatdatetime('dd-mm hh:nn',stamp_spr_send_correct)+' >  s_s_s: '+formatdatetime('dd-mm hh:nn',stamp_spr_send));
                           //else form1.mess_log('|\/|2');
                      //If (stamp_spr_actual>(incDay(time_main,(Sett.nSheddays div 2)))) then
                          //form1.mess_log('|\/| s_s_a: '+formatdatetime('dd-mm hh:nn',stamp_spr_actual)+' > inc t_m: '+formatdatetime('dd-mm hh:nn',incDay(time_main,(Sett.nSheddays div 2))));
                    end;
              end;
          end;

           //form1.DateTimePicker1.DateTime:=strtodatetime(formatDateTime('dd-mm-yyyy hh',now())+':01:02',mySettings);
     //ОТПРАВКА СПРАВОЧНИКОВ НА СЕРВЕР

               If uploadFile='' then
                 begin
                           //If (incday(stamp_spr_actual,Sett.nsheddays)<timeS) and form1.CheckBox8.Checked then
                           //  begin
                           //  Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z798--Справочник НЕ АКТУАЛЕН. Требуется повторная передача !');
                           //  Spr_Send('force');//$
                           //  end
                           //else
                    //showmessage(FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_actual)+#13+
                    //      FormatDateTime('dd-mm-yyyy hh:nn',time_main)+#13+
                    //       FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_send)+#13+
                    //      FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_send_correct));

      //ОТПРАВКА ДАННЫХ НА СЕРВЕР
                  //If form1.CheckBox9.Checked then
                    If Time_main<now() then
                      begin
                      //если период начала расписаний меньше периода данных и получен корректный ответ на последнюю передачу справочников //если справочники переданы полчаса назад
                      If ((stamp_spr_actual<=time_main) and (stamp_spr_send=stamp_spr_send_correct) and (IncMinute(stamp_spr_send,30)<now()))
                      //или справочники были отправлены больше 3-х часов назад
                        OR (IncMinute(stamp_spr_send,-180)>now())
                         //или вообще не надо справочники передавать
                        OR (form1.CheckBox8.Checked=false and form1.CheckBox11.Checked=false)
                          then
                              Data_Send('','','0')
                              else
                               begin
                                If (stamp_spr_actual<=time_main) and (stamp_spr_send=stamp_spr_send_correct) and (IncMinute(stamp_spr_send,30)>now())
                                then Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i08--После отправки справочников, прошло менее 30 минут!')
                                else Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i09--НЕ выполнены условия для ПЕРЕДАЧИ данных !');
                                Form1.mess_log('.s_a: '+formatdatetime('dd-mm hh:nn:ss.zzz',stamp_spr_actual)+'  t_m: '+formatdatetime('dd-mm hh:nn:ss.zzz',time_main));
                                Form1.mess_log('.stamp_send: '+formatdatetime('dd-mm hh:nn:ss.zzz',stamp_spr_send)+'  stamp_corr: '+formatdatetime('dd-mm hh:nn:ss.zzz',stamp_spr_send_correct));
                               end;
                      end
                  else
                     Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i10--нижняя граница актуального периода отправки данных больше текущего времени !');
                end;
               //else
               //begin
               //   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i021--НЕ отправлен файл: '+RightStr(uploadfile,36));
               //   uploadfile:='';
               //end;
         end;
         //end
       //else
         //begin
          //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  После обновления справочников прошло МЕНЕЕ 1 ЧАСА !');
          //form1.stop_auto_upload();
         //end;

        //УДАЛЕНИЕ ФАЙЛОВ С СЕРВЕРА
        //If (uploadFile='') and form1.CheckBox10.Checked
          //then Delete_Old();
       end;

    //  If (form1.Label1.Caption='00:00:00') then
    //begin
    //form1.Label1.Caption:=
    // padl(inttostr(Sett.uploadtime div 3600),'0',2)+':'
    //+padl(inttostr(Sett.uploadtime div 60 - (Sett.uploadtime div 3600 *60)),'0',2)+':'
    //+padl(inttostr(Sett.uploadtime - (Sett.uploadtime div 60 * 60 - (Sett.uploadtime div 3600 *60))),'0',2);
    //end;
      end;

   form1.TCountDown.Enabled:=true;
end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   //FList.Free;
  FreeAndNil(FFile);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   logname:string;
   Info: TVersionInfo;
begin
   Info := TVersionInfo.Create;
   Info.Load(HINSTANCE);
   // grab just the Build Number
   MajorNum := IntToStr(Info.FixedInfo.FileVersion[0]);
   MinorNum := IntToStr(Info.FixedInfo.FileVersion[1]);
   RevisionNum := IntToStr(Info.FixedInfo.FileVersion[2]);
   BuildNum := IntToStr(Info.FixedInfo.FileVersion[3]);
   Info.Free;

  Form1.mess_log('.Версия:'+MajorNum+'.'+MinorNum+'.'+RevisionNum+'.'+BuildNum);
  ddate:=date();
  MySettings.DateSeparator := '-';
  MySettings.TimeSeparator := ':';
  MySettings.ShortDateFormat := 'dd-mm-yy';
  MySettings.ShortTimeFormat := 'hh:nn:ss';
  MySettings.LongDateFormat:='dd-mm-yyyy hh:nn:ss';
    // Обработчик исключений
  Application.OnException:=@MyExceptionHandler;//$
  counterr:=0;
  FDLSize := 1;
  //FList := TStringList.Create;
  FFile := nil;
  zbusy:=0;
  CreateFilePath := '';
  Form1.LoadLastSite;
  UpdateSite;

  //загрузить настройки в структуру
  If not form1.ReadSettings() then
         If form1.WriteDefSettings() then
           form1.ReadSettings();
  Sett.lreceive_log:=1;
  Sett.lsend_log:=1;

  downall:=0;
  uplall:=0;
  uplnow:=0;
  downok:=0;
  downnow:=0;
  ziz:=0;
  allans:=-1;
  attempt:=0;

  form1.Label17.Caption:='0';
  form1.Label19.Caption:='0';
  form1.Label22.Caption:='';
  timercnt:=0;
  downfile:='';
  uploadfile:='';
  deletefile:='';

  form1.DateTimePicker1.DateTime:=strtodatetime(formatDateTime('dd-mm-yyyy hh',now())+':00:00',mySettings);
  form1.DateTimePicker2.DateTime:=strtodatetime(formatDateTime('dd-mm-yyyy hh',now())+':30:00',mySettings);
  //if (Site.Site='') or (Site.ldir='') then
  //  SetLocalDirectory(ExtractFilePath(ParamStr(0)));
  logname:=ExtractFilePath(Application.ExeName)+'log/'+FormatDateTime('yy-mm-dd', now());

  //--------- Создаем log: ..log/log_01.01.2012.log
  if fileexistsUTF8(logname+'.log') then
   begin
     RenameFileUTF8(logname+'.log',logname+FormatDateTime('_hh_nn', now())+'.log');
   end;

  //time_main:=now();
   //time_main:=strtodatetime('23-08-2016 06:00:00',mySettings);
   time_main:=strtodatetime(formatdatetime('dd-mm-yyyy',IncDay(now(),-1))+' 01:00:00',mysettings);//нижняя граница актуального периода отправки данных
   //уточняем time_main в следующей процедуре
   Form1.GetLocalServers();
   form1.ComboServ();
   //form1.TimerControl.Enabled:=true;
   //form1.CheckBox1.Checked:=false;
  //stamp_spr_actual:=strtodatetime('01-01-1970 00:00:01',mySettings); //$
   ZeroDateTime:=strtodatetime('01-01-1971 00:00:01',mySettings);
   stamp_spr_send:=ZeroDateTime;
   stamp_spr_send_correct:=IncDay(ZeroDateTime,-1);
   stamp_spr_actual:=stamp_spr_send;
   time_past:=strtodatetime('01-01-2018 23:59:50',mySettings);

end;


procedure TForm1.FTPControl(aSocket: TLSocket);
  var
  s: string;
  n:integer;
begin
  If ftpdeny then
    begin
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i11--ftp disconnect');
     If ftp.Connected then ftp.Disconnect(true);
     exit;//$
    end;
  try
    n:=FTP.GetMessage(s)
  except
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e447--getmessage exception');
  end;
   If n=0 then
     begin
     Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i12--no ftp messages');
     exit;
     end;
  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+s);
  //exit;
  //загрузка ответов
  If trim(downfile)<>'' then
    begin
     //нет файла
     If (pos(#10+'550',s)>0) or (copy(s,1,3)='550') then
     begin
      fl_receive:=0;
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i13--Не найден файл ответа '+downfile);
      //ftp.Disconnect();//#1126
      For n:=low(arans) to high(arans) do
    begin
     //нет файла
    If (arans[n,0]=downfile)  and (arans[n,1]<>'1') then
    begin
    arans[n,1]:='1';
    break;
    end;
     end;
       inc(attempt);
       //ftp.Nlst(downfile);
       //downfile:='';
       //mess_log('--i81--Не найден файл ответа ');
       FreeAndNil(FFile);
       form1.GetSuccess();
      exit;
    end;

     //файл получен
      If (pos(#10+'226',s)>0) or (copy(s,1,3)='226') then
     begin
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s09--Успешно ПОЛУЧЕН файл квитанции: '+RightStr(downfile,36));
      attempt:=0;
      If fl_receive=0 then fl_receive:=2;
      For n:=low(arans) to high(arans) do
    begin
    If (arans[n,0]=downfile) and (arans[n,1]<>'2') then
    begin
    arans[n,1]:='2';
    break;
    end;
     end;
      FreeAndNil(FFile);    //%1027
      form1.GetSuccess();   //%1027
      exit;
    end;
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|get|'+s);
      exit;
  end;

   //удаление ответов
  If trim(deletefile)<>'' then
    begin
     //нет файла
     If (pos(#10+'550',s)>0) or (copy(s,1,3)='550') or (copy(s,1,3)='450') then
     begin
       Form1.mess_log('--o87--УДАЛЕНИЕ квитанции НЕУДАЧА: '+deletefile);
       //inc(uplnow);
       //inc(uplall);
       //form1.Label17.Caption:=inttostr(uplnow);
       //form1.Label19.Caption:=inttostr(uplall);
       active_process:=false;
       form1.PDPlog_delete(deletefile);
       deletefile:='';
      exit;
    end;
     //файл УДАЛЕН
      If (pos(#10+'250',s)>0) or (copy(s,1,3)='250') then
     begin
      //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s250--success');
      inc(uplnow);
       //inc(uplall);
       form1.Label17.Caption:=inttostr(uplnow);
       //form1.Label19.Caption:=inttostr(uplall);
       active_process:=false;
       Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s10-- Успешное удаление квитанции: '+RightStr(deletefile,36)); //+deletefile);
       form1.PDPlog_delete(deletefile);
    //  For n:=low(arans) to high(arans) do
    //begin
    //If (arans[n,0]=deletefile) and (arans[n,1]<>'2') then
    //begin
    //arans[n,1]:='2';
    //break;
    //end;
    // end;
      //form1.GetSuccess();
      exit;
    end;
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|del|'+s);
      exit;
  end;

  //готов к отправке
  If (pos(#10+'150',s)>0) or (copy(s,1,3)='150') then
    readytodownload:=true;

    //отправка файлов
  If trim(uploadfile)<>'' then
    begin
     //файл отправлен
      If (pos(#10+'226',s)>0) or (copy(s,1,3)='226') then
     begin
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s12--Успешно ОТПРАВЛЕН файл: '+RightStr(uploadfile,32));
      fl_send:=true;
      form1.SendSuccess();
      exit;
    end;
      If (pos(#10+'426',s)>0) then
        begin
          Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e12-- Код 426. Канал закрыт, обмен прерван. Сброс.');
          form1.ClearALL();
         exit;
         end;

      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|upl|'+s);
      exit;
  end;
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|ZZZ|'+s);
end;


procedure TForm1.FTPError(const msg: string; aSocket: TLSocket);
begin
  If form1.TimerRegular.Enabled=false then form1.TimerRegular.Enabled:=true;
    //ftpdeny:=true;
    If (uploadfile<>'') then
      begin
        If utf8pos('Error on connect',msg)>0 then
          begin
             if counterr>Sett.limit_attempt then
             begin
              counterr:=0;
           Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o667--CLOSED Connection !!!');
           ftp.Disconnect(true);
           form1.ClearALL();
             end;
           inc(counterr);
           exit;
          end
        else  Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o999-- '+form1.Label7.Caption+' '+msg);
      end
    else
     Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o777-- '+form1.Label7.Caption+' '+msg);


    if not FTP.Connected then FTP.Disconnect;
    //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--'+uploadfile);
    //form1.ClearALL();
   //MemoLog.Append(msg);
   // connection has been closed, update gui

    //ToolButton2.Down := True;
   //end;
    //CreateFilePath := '';
end;

procedure TForm1.FTPReceive(aSocket: TLSocket);
  //procedure FindNames;
  //var
    //i, nRow: Integer;
    //Parser: TDirEntryParser;
  //begin
    //rmtGrid.BeginUpdate;
    //try
    //  // adds dirup entry
    //  rmtGrid.RowCount := 2;
    //  rmtGrid.Cells[1,1] := '..';
    //  rmtGrid.objects[0,1] := FSpecialIcons[siDirUp];
    //
      // adds every item in list
      //if FList.Count > 0 then begin

        //nRow := rmtGrid.RowCount;
        //rmtGrid.RowCount := nRow + FList.Count;

        //FList.SaveToFile('last.txt');
        //for i := 0 to FList.Count-1 do begin

          //rmtGrid.Objects[0,nRow] := nil; // no special icon index

          //Parser := DirParser.Parse(pchar(FList[i]));
          //if Assigned(Parser) then begin
          //  DirParser.PrefParser := Parser;

            // default icon index/entry type
            //if Parser.IsLink then begin
              //rmtGrid.Objects[0,nRow] := FSpecialIcons[siLink];

            //end else if Parser.IsDir then
              //rmtGrid.Objects[0,nRow] := FSpecialIcons[siDir]
            //else begin
              //rmtGrid.Objects[0,nRow] := GetFileIcon(Parser.EntryName);

  //          end;
  //
  //          // text properties
  //          rmtGrid.Cells[1, nRow] := Parser.EntryName;
  //          if Parser.IsDir or Parser.IsLink then
  //            rmtGrid.Cells[2, nRow] := ''
  //          else
  //            rmtGrid.Cells[2, nRow] := IntToStr(Parser.EntrySize);
  //          rmtGrid.Cells[3, nRow] := FormatDateTime(ShortDateFormat+' '+
  //                                                ShortTimeFormat,Parser.Date);
  //          rmtGrid.Cells[4, nRow] := Parser.Attributes;
  //          if rmtGrid.Columns[5].Visible then
  //            rmtGrid.Cells[5, nRow] := Parser.LinkName;
  //        end else begin
  //          {$IFDEF INCLUDEERRORS}
  //          rmtGrid.Cells[1, nRow] := FList[i];
  //          rmtGrid.Objects[0, nRow] := FSpecialIcons[siError];
  //          {$ELSE}
  //          rmtGrid.RowCount:=rmtGrid.RowCount-1;
  //          continue;
  //          {$ENDIF}
  //        end;
  //
  //        if rmtGrid.Objects[0, nRow] = nil then
  //          rmtGrid.Objects[0, nRow] := FSpecialIcons[siFile];
  //
  //        Inc(nRow);
  //      end;
  //
  //      if FList.Count>1 then
  //        rmtGrid.SortColRow(True, 1, 1, rmtGrid.RowCount-1);
  //
  //    end;
  //  finally
  //    rmtGrid.EndUpdate;
  //  end;
  //end;

var
  s: string;
  i: Integer;
  Buf: array[0..65535] of Byte;
begin
  if FTP.CurrentStatus = fsRetr then begin // getting file, save to file
    sleep(100);
    i := FTP.GetData(Buf, 65535);
    if i > 0 then begin
      //mess_log('--!1--');//$
      if Length(CreateFilePath) > 0 then begin
        FFile := TFileStream.Create(CreateFilePath, fmCreate or fmOpenWrite);
        CreateFilePath := '';
        //If FDLSize<i then FDLSize:=i;
        iF i=265 then
        begin
         fl_receive:=1;
         mess_log('--s13-- КОРРЕКТНЫЙ ОТВЕТ !');
        end
        else
         mess_log('--s14-- Квитанция получена !');//$
      end;
      FFile.Write(Buf, i);
    end else begin
      // file download ended
      //LeftView.UpdateFileList;
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|ret|'+s);
      FreeAndNil(FFile);
      CreateFilePath := '';
      If fl_receive=0 then fl_receive:=2;
      //If active_process and (fl_receive=0) then
       //begin
         //fl_receive:=2;
         mess_log('--s15-- Получение файлов квитанци УСПЕШНО !');
         form1.getsuccess();//%1027
       //end;
      //DoList('');
    end;
    Inc(FDLDone, i);
    //mess_log('--!3--');
  end else begin // getting listing
    s := FTP.GetDataMessage;
    if Length(s) > 0 then
    begin
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'|~|lis|'+s);
      If utf8pos('errCode="0"',s)>0 then fl_receive:=0;//%1027

      FDirListing := FDirListing + s;
    end
    else begin
      //FList.Text := FDirListing;
      FDirListing := '';
       //Form1.mess_log('--r--null '+s);
      //FindNames;
      //FList.Clear;
    end;
  end;
end;

procedure TForm1.FTPSent(aSocket: TLSocket; const Bytes: Integer);
var
  n: Integer;
begin
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'###7 Контрольная точка '+uploadFile);
  if Bytes > 0 then begin
    Inc(FDLDone, Bytes);
    //if Form1.MemoLog.Lines.Count > 0 then begin
      n := Integer(Round(FDLDone / FDLSize * 100));
      if n <> FLastN then begin
        ProgressBar1.Position := n;
        FLastN := n;
      end;
      If n>98 then
        begin
        fl_send:=true;//$20180323

        //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'   ook1  файл отправлен: '+xml_name);
        //SendSuccess();
        end;

       //end;
  end
  else
    begin
       fl_send:=true;//$20180323

       counterr:=0;
       //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' okk2 файл отправлен: '+xml_name);
       //SendSuccess();
       end;
    //DoList('');
end;

procedure TForm1.FTPSuccess(aSocket: TLSocket; const aStatus: TLFTPStatus);
var
  i: Integer;
  s: string = '';
begin
  case aStatus of
    //fsFeat : FormFeatures.ListBoxFeatures.Items.Assign(FTP.FeatureList);
    fsList : FTP.PresentWorkingDirectory;
    fsPWD  : begin
               Site.Path := FTP.PresentWorkingDirectoryString;
               SBar.Panels[3].Text := site.path;
               //TFrmSites.SaveOption('site' + IntToStr(Site.Number), 'path', site.path);
             end;
    //fsCon: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsCon');
    //fsNone: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsNone');
    //fsUser: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsUser');
    //fsPass: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsPass');
    fsPasv: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsPasv');
    fsPort: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsPort');
    //fsRetr: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsRetr');
    //fsStor: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsStor');
    //fsType: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsType');
    //fsCWD: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsCWD');
    fsMKD: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsMKD');
    fsRMD: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsRMD');
    fsDEL: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsDEL');
    fsRNFR: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsRNFR');
    fsRNTO: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsRNTO');
    fsSYS: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsSYS');
    //fsFeat: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsFeat');
    fsHelp: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsHelp');
    fsLast: mess_log(formatdatetime('hh:nn:ss.zzz',now())+'----++-----fsLast');
    // TODO: check status of other commands here properly!
  end;
end;


procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  iF FORM1.RadioButton1.Checked then form1.GroupBox3.Enabled:=true;
end;


procedure TForm1.TimerDeleteTimer(Sender: TObject);
var
  filepath:string;
  fl:boolean;
begin
  form1.TimerDelete.Enabled:=false;

    If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e27--Удаление квитанций невозможно ! Приложение занято, подождите...');
      exit;
    end;


   If not  FTP.Connected then exit;

 //если авто режим
If not form1.checkbox2.checked then exit;
deletefile:='';
  For n:=low(ardel) to high(ardel) do
   begin
    If ardel[n,1]='1' then continue;//нет файла
     deletefile:=ardel[n,0];
     active_process:=true;
     ardel[n,1]:='1';
     If not ftpdeny then
     begin
     FTP.DeleteFile(deletefile);
     form1.TimerDelete.Enabled:=true;
     end;
     active_process:=false;
     break;
    end;

     //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' ###Контрольная точка 2');//$
  If deletefile='' then
   begin
    stop_auto_upload();
    stop_auto_download();//нужно для обнуления массива ardel
    active_process:=false;
    form1.TimerControl.Enabled:=false;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'~~~~~~~~~~~~~ УДАЛЕНИЕ КВИТАНЦИЙ. КОНЕЦ ~~~~~~~~~~~~~~');//$
    //form1.accDisconnectExecute(Self);
    exit;
   end;

 //form1.TimerDelete.Enabled:=true;
end;

procedure TForm1.TimerReceiveStartTimer(Sender: TObject);
begin
  timeout_r:=0;
end;



// ПЕРЕДАЧА ФАЙЛА
procedure TForm1.TimerSendTimer(Sender: TObject);
var
timeout,fl: string;
FF: TFileStream;
Sr: TSearchRec;
begin
 form1.TimerSend.Enabled:=false;//#1126
 form1.TCountDown.Enabled:=false;//$

  If timeout_s>=maxuploadtime then
    begin
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  FORCE DISABLE upload timer !');
    SendSuccess();
    exit;
    end;
  //timeout_local:=timeout_local+1;
  //Form1.mess_log('Контроль timeout_max: '+inttostr(timeout_max)+' interval:'+inttostr(Form1.TimerSend.Interval));//&
  If uploadFile='' then
    begin
     mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o432--НЕ ОПРЕДЕЛЕН файл для отправки !');
     SendSuccess();
     exit;
    end;

  If fl_send then
        begin
          mess_log('--s16-- передача данных. УСПЕШНО!');
          SendSuccess();
          exit;
        end;
  //If active_process then
  // begin
  //  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  Объект занят !');
  // exit;
  // end;

  //SBar.Panels[3].Text := 'СОЕДИНЕНИЕ '+points;
  //application.ProcessMessages;
  //if timeout_local=timeout_wait then
   //begin
    //timeout_local:=0;

   If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e33--ОШИБКА ! Не найден файл для передачи ! '+ xml_name);
      SendSuccess();
      exit;
    end;

  //form1.TimerSend.Enabled:=true;

 If FTP.Connected or readytodownload then
  begin
  //если уже идет передача файла
 //If active_process and (timeout_s>0) then
 //   begin
 //     mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e29--Файл уже передается '+inttostr(timeout_s)+'секунд...');
 //     inc(timeout_s);
 //     exit;
 //   end;
    //If active_process then fl:='true' else fl:='false';//$
    //timeout:=inttostr(timeout_s);//$
    //mess_log('@@@'+fl+'_'+timeout);//$
 If not active_process then active_process:=true;
 If timeout_s=0 then
  begin
    FDLDone := 0;
    FLastN := 0;
    FDLSize := 1;
  //If IOResult<>0 then
  // begin
  //    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e56-- Ошибка операции с файлом: '+inttostr(IOResult));
  //   end;
    //{$I-} // отключение контроля ошибок ввода-вывода
   If counterr>=Sett.limit_attempt then
   begin
     if fileexistsUTF8(uploadFile) then
   begin
    mess_log('--e56--Множественные ошибки открытия файла. Файл переименован в '+uploadFile+'.bad');
    RenameFileUTF8(uploadFile,uploadFile+'.bad');
    counterr:=0;
    SendSuccess();
    exit;
   end;
   end;

    If counterr<Sett.limit_attempt then
    begin
     timeout_s:=timeout_s+1;
     //showmessage(inttostr(timeout_s));


  // try
  //  FF := TFileStream.Create(uploadFile, fmOpenRead or fmShareDenyWrite);
  //  FDLSize := FF.Size;
  //  FF.Free;
  // except
  //   //on E:  EInOutError do
  //  on E: Exception do
  //   // on exception: EFOpenError do
  //    //begin
  //    //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e56-- Ошибка операции с файлом: ');
  //  //end;
  //   //FreeAndNil(FF);
  //   //FF.Free;
  // //end;
  //  //{$I+} // включение контроля ошибок ввода-вывода
  ////if IOResult<>0 then // если есть ошибка открытия, то
  //  begin
  //    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e57-- Ошибка операции с файлом: '+E.Message); //+E.ClassName+'/'+E.Message);
  //    inc(counterr);
  //    FF.Free;
  //    SendSuccess();
  //    exit;
  //   end;
  // end;
   end;

    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'=== Соединение успешно. Начинается отправка файла... ===');
   end
     else
    begin
      //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e58=== Продолжается отправка файла... ===');
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i29--Файл уже передается '+inttostr(timeout_s)+'секунд...');
      inc(timeout_s);
      exit;
    end;
    //Form1.mess_log('Начинается передача файла: '+xml_name);
    If not ftpdeny then
    begin
     form1.TCountDown.Enabled:=false;//$
     form1.TimerRegular.Enabled:=false;//$
    //try
    //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'###5 Контрольная точка '+uploadFile);
    try
      FTP.Put(uploadFile);
      //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'###655 точка '+uploadFile);
    except
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e324 Ошибка передачи! Уже передан файл: '+uploadFile);
      fl_send:=true;
      form1.SendSuccess();
      exit;
    end;
    end;
   end
 else
   begin
     If not readytodownload then
       mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o57 Не готов к отправке');
   end;

   If not FTP.Connected then
   begin
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e356 НЕТ соединения для отправки файла: '+uploadFile);
    form1.TimerSend.Enabled:=false;
    form1.ClearALL();
       //form1.accConnectExecute(Self);
   end;
   inc(timeout_s);

   //end;
end;



//прием файла
procedure TForm1.TimerReceiveTimer(Sender: TObject);
var
  filepath:string;
  fl:boolean;
  rfile:File of byte;
begin
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s78--Контрольная точка');
 //если еще получаем данные
   // If FTP.Connected and
   //If (FTP.CurrentStatus=fsRetr)
   // //and (timeout_r<(Sett.downloadtime div 2))
    //then
   //begin
   //   //timeout_r:=timeout_r+form1.TimerReceive.Interval div 500;
      //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z18--получение данных, подождите...');
      //exit;
   //end;

   form1.TimerReceive.Enabled:=false;

   //If not FTP.Connected then
   // begin
   //  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i78--Нет соединения. Выход.');
   //  stop_auto_download();
   //  form1.TimerControl.Enabled:=false;
   // exit;//$
   // end;

    If fl_receive>0 then
   begin
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s17-- Файл получен. Запись в журнал.');
    form1.GetSuccess();
    exit;
   end;


   //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' ###Контрольная точка 1');//$
 //если авто режим
If form1.checkbox2.checked then
begin
  downfile:='';
  For n:=low(arans) to high(arans) do
   begin
    If arans[n,1]='1' then continue;//нет файла
    If arans[n,1]='2' then continue;//уже получили
    downfile:=arans[n,0];
  //If trim(downfile)='' then
  //  begin
  //    Form1.mess_log('--z11-НЕТ ЗАПИСЕЙ с файлами без ответов !');
  //    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
  //    form1.ZReadOnlyQuery1.close;
  //    form1.ZConnection1.disconnect;
  //    active_process:=false;
  //    exit;
  //  end;
  //points:='';
  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'KILLFTP_BEFORERECIEVE >>>>>>>>>>> ');
     break;
    end;
     //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' ###Контрольная точка 2');//$
end;

  If downfile='' then
   begin
    stop_auto_download();
    form1.TimerControl.Enabled:=false;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'-------- ПОЛУЧЕНИЕ ФАЙЛОВ ОТВЕТОВ КОНЕЦ ------------');//$
    //form1.accDisconnectExecute(Self);
    exit;
   end;

   //If fl_receive>0 then
   //begin
   // form1.GetSuccess();
   // exit;
   //end;
      //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' ###Контрольная точка 3');//$

      //если файл уже есть
    filepath:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+downfile;
   If FileExistsUTF8(filepath) then
   begin
     try
       {$I-} // выключение контроля ошибок ввода-вывода
       AssignFile(rfile,filepath);
       Reset(rfile);
     If System.FileSize(rfile)>0 then
     begin
        If System.FileSize(rfile)=265 then
          fl_receive:=1
          else fl_receive:=2;
        CloseFIle(rfile);
         //If active_process then
       //begin
        If form1.CheckBox2.Checked then
        begin
          fl:=false;
          For n:=low(arans) to high(arans) do
          begin
           If (arans[n,0]=downfile) and (arans[n,1]<>'2')  then
            begin
             arans[n,1]:='2';
             mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s18-- файл квитанции '+downfile+' уже был получен!');
             form1.GetSuccess();
             break;
            end;
          end;
        end
        else
         begin
          mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s19--файл ответов уже был получен!');
           form1.GetSuccess();
          end;
         exit;
        //end;
        //end;
       end;
       except
          CloseFIle(rfile);
           Form1.mess_log('--e403--Ошибка работы с файлом!');
        end;
     if IOResult<>0 then // если есть ошибка открытия, то
    begin
     Form1.mess_log('--e402--Ошибка работы с файлом!');
    end;
     end;

   If timeout_r>=Sett.downloadtime then
   begin
    If form1.CheckBox2.Checked then
        begin
          For n:=low(arans) to high(arans) do
          begin
           If arans[n,0]=downfile then
            begin
          arans[n,1]:='1';
          break;
          end;
          end;
        end;
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  FORCE DISABLE timerRec !');
    stop_auto_download();
    form1.TimerControl.Enabled:=false;
    exit;
   end;

 If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e61--Ошибка! Получение данных уже происходит !!!');

      //timeout_r:=timeout_r+form1.TimerReceive.Interval div 1000;
      form1.TimerReceive.Enabled:=true;
   exit;
   end;
        //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' ###Контрольная точка 4');//$
  //timeout_local:=timeout_local+1;

  //SBar.Panels[3].Text := 'СОЕДИНЕНИЕ '+points;
  //application.ProcessMessages;
  //if timeout_local=timeout_wait then
  // begin

  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'>>> '+downfile);


   If FTP.Connected AND (FTP.CurrentStatus<>fsRetr) and (timeout_r=0) then
   begin
     inc(timeout_r);
    //form1.TimerReceive.Enabled:=false;
    active_process:=true;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+' << Начинается прием файла №'+inttostr(n+1)); //+downfile);
    //FDLSize := 265; //CurrentSize;
    //FDLDone := 0;
    //if FDLSize = 0 then
    //FDLSize := 1;
    FreeAndNil(FFile);
    CreateFilePath := '';
    CreateFilePath := filepath;
    //FTP.list(downfile);
    If not ftpdeny then
    FTP.Retrieve(downfile);
    //Form1.mess_log(CreateFilePath);
    //Form1.mess_log('Отключение от FTP-сервера');
    //form1.TimerReceive.Enabled:=true;
    exit;
   end;
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'###Контрольная точка 6_'+inttostr(timeout_r));//$
   If FTP.Connected then
    form1.TimerReceive.Enabled:=true;
    //timeout_r:=timeout_r+form1.TimerReceive.Interval div 1000;
   //end;
end;


procedure TForm1.TimerRegularTimer(Sender: TObject);
var
minut,k,n:integer;
d1,d2,fd2,td1,td2,tfd:string;
flag_send,fl_final:boolean;
begin
   form1.label3.caption:=TimeToStr(Time);//время
     //inc(timercnt);//$
   form1.Label20.Caption:=inttostr(globaltimer-timercnt);//таймер зависонов
   //Где-то зависон, СБРОСИТЬ ВСЕ
   If timercnt>=globaltimer then
   begin
     mess_log(formatDateTime('hh:mm:nn.zzz',now())+'-!-!-!-!- Сброс всех флагов -!-!-!-!-');
      timercnt:=0;
      uploadfile:='';//$
      form1.ClearALL();
    //If form1.CheckBox2.Checked and not form1.TCountDown.Enabled
    //then form1.TCountDown.Enabled:=true;  //$
      exit;
    end;
  //form1.label2.caption:=IntToStr(myDay)+' '+GetMonthName(MonthOfTheYear(Date));//+' '+inttostr(myYear)+' г.';
  //form1.label3.caption:=GetDayName(DayOftheWeek(Date));
  //проверочная инфо
  If form1.TimerControl.Enabled=false then
  begin
   form1.Label5.Caption:='0';
   end
   else
    begin
   try
     If strtoint(form1.Label5.Caption) <1 then
     begin
      //mess_log(formatDateTime('hh:mm:nn.zzz',now())+'--e78--Ошибка таймера контроля !');
       form1.Label5.Caption:=floattostr(form1.TimerControl.Interval div 1000);//$
     end
     else
     begin
       form1.Label5.Caption:=inttostr(strtoint(form1.Label5.Caption)-1);//$
     end;
    except
      exit;
    end;
    end;

   If active_process and not form1.TimerControl.Enabled
      then
        begin
         //showmessage('1');
        //form1.TimerControl.Enabled:=true;#1207
        end;

   //приращения к таймеру зависона
   If form1.CheckBox2.Checked then
      begin
       If (form1.Shape2.Brush.Color=clLime) or (form1.Label7.Caption='00:00:00') or (fl_receive>0)
         or (form1.Shape1.Brush.Color=clLime) or (form1.Label1.Caption='00:00:00') or (fl_send)
         then inc(timercnt);//таймер сбоя

     //если висим в простое
     If (timercnt mod 180 =0) and (form1.Label1.Caption='00:00:00') and not(form1.Shape1.Brush.Color=clLime) and not form1.TimerSend.Enabled then
        begin
          mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o987-- Остановка отправки данных');
          form1.stop_auto_upload();
          timercnt:=0;
          end;

     If (timercnt mod 120 =0) and (form1.Label7.Caption='00:00:00') and not(form1.Shape2.Brush.Color=clLime) and not form1.TimerReceive.Enabled then
        begin
         mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--o986-- Остановка загрузки данных');
         form1.stop_auto_download();
         timercnt:=0;
         end;

         form1.Label10.Caption:=inttostr(downnow);
         form1.Label11.Caption:=inttostr(downall);
         form1.Label12.Caption:=inttostr(downok);
         form1.Label17.Caption:=inttostr(uplnow);
         form1.Label19.Caption:=inttostr(uplall);

       //If form1.TimerSend.Enabled then
       // begin
          //start_auto_upload();
          //exit;
        //end;
       //If form1.TimerReceive.Enabled then
       // begin
          //start_auto_download();
          //exit;
        //end;
       //form1.CountDown.Enabled:=false;
      end;

  If form1.CheckBox1.Checked then
  begin
   stop_auto_upload();
   stop_auto_download();
   //form1.CountDown.Enabled:=false;
   exit;
   end;
 //$If form1.CheckBox2.Checked and not form1.TCountDown.Enabled
   //then form1.TCountDown.Enabled:=true;
end;


procedure TForm1.TimerSendStartTimer(Sender: TObject);
begin
  progressbar1.Position:=0;
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+' Контроль: таймер передача старт');
  timeout_s:=0;
end;



//передача файла
procedure TForm1.Data_SEND(from_period:string;to_period:string;spoint:string);
var
minut,k,n,tekpoint:integer;
d1,d2,fd2,td1,td2,newname:string;
flag_send,fl_final,flag_find,flchange_maintime:boolean;
sendtime,time_diff,time_min:TDateTime;
//arpro:array of string;
begin
  d1:='';
  d2:='';
  fd2:='';
  td1:='';
  td2:='';
  newname:='';
  flchange_maintime:=true; //флаг возможности изменения периода данных
  //если ручной режим - выход
 //If form1.CheckBox1.Checked then
 //  begin
 //  exit;
 //  end;
 If active_process then
     begin
       mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e73--Передача невозможна ! Приложение занято, подождите...');
       exit;
     end;

 //идет загрузка (получение ответов)
 If form1.Shape2.Brush.Color=clLime then
 begin
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i14--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
   form1.stop_auto_upload();
    exit;
 end;

  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^2^^');
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ОТПРАВКА ДАННЫХ. НАЧАЛО. ========');
  // This is unix time 2010-07-26 17:50:17
  //d := UnixToDateTime(1280166617);
  //d := TimeLocalToUTC(now());
  If (length(arservers)=0)
    //or (Length(ar_shed)=0)
    then
   begin
       Form1.mess_log('Не определен массив подразделений !');
       exit;
   end;
   If not Form1.SetSite('csv') then
     begin
         Form1.mess_log('Не определены параметры подключения к FTP для передачи ПДП !');
         Exit;
     end;
    UpdateSite;


  //если отправка не вручную или повторно, то рассчитываем
  If (from_period='') and (to_period='') then
   begin
    sendTime:=now();
    fd2:=formatDateTime('yyyy_mm_dd_hh_nn',sendTime);
  try
    minut :=strtoint(FormatDateTime('nn',sendTime));
  except
    Form1.mess_log('Ошибка преобразования времени !');
    exit;
  end;
 If minut>30 then
  begin
    td1:=formatDateTime('yyyy-mm-dd hh',sendTime)+':00:00';
    td2:=formatDateTime('yyyy-mm-dd hh',sendTime)+':30:00';
  end
 else
   begin
    td1:=formatDateTime('yyyy-mm-dd hh',incHour(sendTime,-1))+':30:00';
    td2:=formatDateTime('yyyy-mm-dd hh',sendTime)+':00:00';
  end;

  end
  else
  begin
     fd2:=formatDateTime('yyyy_mm_dd_hh_nn',incminute(strtodatetime(to_period,mySettings),5));
       d1:=from_period;
       d2:=to_period;
  end;


   uploadFile:='';
   xml_name:='';
   flag_send:=false; //наличие записей в БД по данному отделению (серверу)

    fl_final:=false;
    k:=-1;
   //проверяем есть ли файлы созданные но не отправленные
      If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z18.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

   active_process:=true;

   //$20180323
  //If 1>1 then
    begin
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      exit;
     end;

   //ищем созданные но не отправленные данные
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add('select * from av_pdp_log where stamp_to notnull and data_exist and stamp_send isnull ');
    form1.ZReadOnlyQuery1.SQL.add(' and error_main=0 and id_point>0 order by stamp_from desc limit 1;');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e59--Ошибка запроса по еще НЕ ОТПРАВЛЕННЫМ данным !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      exit;
   end;
   If form1.ZReadOnlyQuery1.RecordCount>0 then
    begin
      xml_name:=form1.ZReadOnlyQuery1.FieldByName('file_send').AsString;
     end;
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;

 If xml_name<>'' then
  uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name+'.zip';

  If fileexistsUTF8(uploadFile) then
    begin
    fl_final:=true;//ставим признак, что есть что отправлять
    //Form1.mess_log(' Файл существует '+ uploadFile);
    //Form1.mess_log('--i15--Переименование неотправленного файла: '+xml_name+#13+' ++++ '+uploadFile);
    newname:=utf8copy(uploadfile,1,utf8length(uploadfile)-11)+'999.csv.zip';
    //RenameFileUTF8(uploadFile,newname);
    //uploadfile:=newname;
    //RenameFileUTF8(newname,uploadFile);
    end;
  //else
  iF (xml_name<>'') and not fl_final then
  begin
   Form1.mess_log('--e60--ОШИБКА ! Не найден файл для передачи ! '+ uploadFile);
   //exit;//$

  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z1--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      active_process:=false;
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e61--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        active_process:=false;
        exit;
       end;
  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      form1.ZReadOnlyQuery1.SQL.add(' Update av_pdp_log set error_main=1,remark='+Quotedstr('60|Не найден файл для передачи')+' WHERE file_send='+quotedstr(xml_name));
      //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;
  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e62--ОШИБКА ЗАПИСИ В БАЗУ !');
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
  end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
   end;

  iF (xml_name<>'') and fl_final then    mess_log('--i16--Отправляем ранее созданный файл: '+xml_name);
 end;//$20180323

  //ОТПРАВЛЯЕМ НОВЫЙ ФАЙЛ
   If not fl_final then
     begin
      uploadFile:='';
      xml_name:='';
      setlength(arsend,0);


      //ВОСПОЛНЯЕМ ПРОБЕЛЫ В ПЕРЕДАЧЕ
  //    setlength(arpro,0);
  //    d1:=formatDateTime('yyyy-mm-dd hh:nn',timeS);
  //    d2:=formatDateTime('yyyy-mm-dd hh:nn',incminute(timeS,30));
  //    If form1.ZConnection1.Connected then
  // begin
  //  If zbusy<Sett.maxz then
  //   begin
  //    zbusy:=zbusy+1;
  //    Form1.mess_log('--z8.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
  //    active_process:=false;
  //    exit;
  //    end;
  //   form1.ZConnection1.Disconnect;
  //   zbusy:=0;
  // end;
  //
  //  If not(form1.Connect(form1.ZConnection1,-1)) then
  //   begin
  //    Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
  //    active_process:=false;
  //    exit;
  //   end;
  ////определяем уже переданные данные по отделениям
  //  form1.ZReadOnlyQuery1.SQL.Clear;
  //  form1.ZReadOnlyQuery1.SQL.add('select id_point FROM av_pdp_log where stamp_from='+Quotedstr(d1));
  //  form1.ZReadOnlyQuery1.SQL.add(' and stamp_to='+Quotedstr(d2)+' order by stamp_to asc; ');
  //  //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
  // try
  //   form1.ZReadOnlyQuery1.open;
  // except
  //    Form1.mess_log('--e49--Ошибка запроса по отправленным данным на сервера !');
  //    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
  //    form1.ZReadOnlyQuery1.close;
  //    form1.ZConnection1.disconnect;
  //    active_process:=false;
  //    exit;
  // end;
  // If form1.ZReadOnlyQuery1.RecordCount>0 then
  //  begin
  //     for n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  //     begin
  //       setlength(arpro,length(arpro)+1);
  //       arpro[length(arpro)-1]:=form1.ZReadOnlyQuery1.FieldByName('id_point').AsString;
  //       form1.ZReadOnlyQuery1.Next;
  //     end;
  //   end;
  // form1.ZReadOnlyQuery1.close;
  // form1.ZConnection1.disconnect;

  //если отправка актуальных данных
  If (from_period='') and (to_period='') then
  begin
  //ставим по умолчанию текущий период данных
  //time_diff - актуальное верхнее время от отделения в базе
   time_diff:=time_main;
   time_min:=time_main;

   //проходимся по серверам  | ЦИКЛ по СЕРВЕРАМ
   for k:=0 to length(arservers)-1 do
  //for k:=0 to 6 do //$
  begin
   try
      tekpoint:=strtoint(arservers[k,0]);
   except
      Form1.mess_log('--z99'+' Ошибка преобразования в целое!');
      continue;
   end;

       fl_final:=false;
       //If (arservers[k,0]='814') or (arservers[k,0]='815') or (arservers[k,0]='816') then continue; //$
       //If (arservers[k,0]<>'67') then continue; //$
       //If (arservers[k,0]='76') then continue; //$ Нефтекумск
       //If (arservers[k,0]='814') then continue; //$ АС2
       //If (arservers[k,0]='1814') then continue; //$ АС2
       //If (arservers[k,0]='72') then continue; //$ Ипатово
       //If (arservers[k,0]='1072') then continue; //$ Ипатово
       //If (arservers[k,0]='79') then continue; //$ Новопавловск
       //If (arservers[k,0]='757') then continue; //$ Левокумское
       //If (arservers[k,0]='795') then continue; //$ Донское
       //If (arservers[k,0]='786') then continue; //$ КРАСНАЯ ГВАРДИЯ
       //If (arservers[k,0]='758') then continue; //$ Александровское
       //If (arservers[k,0]='71') then continue; //$  Благодарный
       //If (arservers[k,0]='778') then continue; //$ Грачевка
       //If (arservers[k,0]='776') then continue; //$ Курсавка
       //If (arservers[k,0]='84') then continue; //$ Арзгир
       //If (arservers[k,0]='83') then continue; //$ новотроицкая
       //If (arservers[k,0]='624') then continue; //$ Рыздвяный
       //If (arservers[k,0]='52') then continue; //$ Солнечнодольск
       //If (arservers[k,0]='761') then continue; //$ Курская
       //If (arservers[k,0]='762') then continue; //$ Кочубеевское
       //If (arservers[k,0]='65') then continue; //$ Изобильный
       //If (arservers[k,0]='66') then continue; //$ виртуальный

       //контроль внешнего цикла
       //If k=length(arservers)-1 then fl_final:=true;
       uploadFile:='';
       xml_name:='';
       flag_send:=false; //наличие записей в БД по данному отделению (серверу)

    If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z8.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      active_process:=false;
      break;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      break;
     end;
  //определяем последнее время передачи на каждом отделении
    form1.ZReadOnlyQuery1.SQL.Clear;

    //If strtoint(arservers[k,0])>1000 then
    //form1.ZReadOnlyQuery1.SQL.add('select (stamp_to - interval ''30 minute'') as from_period, stamp_to as to_period, (stamp_to + ''1 minute'') tofname ')
    //else
    form1.ZReadOnlyQuery1.SQL.add('select stamp_to as from_period,(stamp_to + interval ''30 minute'') to_period, (stamp_to + interval ''31 minute'') tofname ');
    form1.ZReadOnlyQuery1.SQL.add('FROM av_pdp_log where stamp_to is not null and id_point='+arservers[k,0]+' order by stamp_to desc limit 1; ');
  //form1.ZReadOnlyQuery1.SQL.add('FROM av_pdp_log where id_point='+arservers[k,0]+' and stamp_to<''06-03-2018'' and stamp_from>''01-03-2018'' order by stamp_to desc limit 1; ');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e49--Ошибка запроса по отправленным данным на сервера !');
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      break;
   end;
   If form1.ZReadOnlyQuery1.RecordCount>0 then
    begin
      time_diff:=form1.ZReadOnlyQuery1.FieldByName('from_period').AsDateTime;
      d1:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('from_period').AsDateTime);
      d2:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('to_period').AsDateTime);
      flag_send:=true;//наличие записей в БД по данному отделению (серверу)

     //если начало периода данных меньше начала период справочников, то необходимо обновить справочники
       //период передачи данных меньше периода справочников отправляем
      If form1.CheckBox8.Checked and
         ((stamp_spr_actual<incDay(time_diff,sett.nSheddays)) or (time_diff<stamp_spr_actual)) then
      begin
         form1.ZReadOnlyQuery1.close;
         form1.ZConnection1.disconnect;
         Form1.mess_log('--i17--период '+d1+' для ['+arservers[k,0]+'] '+arservers[k,1]+' НЕ соотв-т периоду справочников!');
        //если период отделения меньше минимального или он вообще отличается от текущего периода, тогда меняем минимальный период
         If (time_diff<time_min) or ((time_main=time_min) and (time_main<time_diff))
           then time_min:=time_diff;
         form1.mess_log('\\\time_main: '+formatdatetime('dd-mm hh:nn',time_main)+' |time_diff: '+formatdatetime('dd-mm hh:nn',time_diff)
           +' |time_min: '+formatdatetime('dd-mm hh:nn',time_min));
         flchange_maintime:=true;//флаг возможности изменения периода данных
         continue;
      end;
     //time_main:=time_diff;

    //If IncMinute(form1.ZReadOnlyQuery1.FieldByName('to_period').AsDateTime,30)>sendTime then //$
    If form1.ZReadOnlyQuery1.FieldByName('to_period').AsDateTime>=sendTime then //$
     begin
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     Form1.mess_log(padl(inttostr(k),'-',3)+' ['+arservers[k,0]+'] файл уже отправлен за период: '+
     formatDateTime('dd-mm-yyyy hh:nn',incminute(strtodatetime(d1,mySettings),-30))+' - '+
     formatDateTime('dd-mm-yyyy hh:nn',incminute(strtodatetime(d2,mySettings),-30)));
     continue;
     end;

    flchange_maintime:=false;//флаг возможности изменения периода данных (НЕ ПЕРЕДВИГАТЬ!)

     end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;

     //// ЕСЛИ НЕТ записей в БД по данному отделению (серверу) меняем временную метку
      If not flag_send then
       begin
          Form1.mess_log('--i18-- НЕТ информации по отправке ПДП для отделения: ['+arservers[k,0]+'] !!!');
         //If time_main<sendTime then
            //time_main:=sendTime;
           d1:=td1;
           d2:=td2;
       end;

  //flag_find:=false;
  //   for n:=low(arpro) to high(arpro) do
  //     begin
  //      If arpro[n]=arservers[k,0] then
  //      begin
  //       flag_find:=true;
  //       break;
  //      end;
  //     end;
  // If flag_find then continue;
  //    Form1.mess_log('----!!'+arservers[k,0]+'  '+arservers[k,1]+'  !!----');


      //создать файл на отправку
       //xml_name :=Sett.nIdent+'_'+fd2+'_'+formatDateTime('ss',now())+'_'+padl(rightstr((arservers[k,0]),3),'0',3)+'.csv';//$
       xml_name :=Sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh_nn_ss',now())+'_'+padl(rightstr((arservers[k,0]),3),'0',3)+'.csv';//$
       uploadFile:=makeCSV(d1,d2,strtoint(arservers[k,0]),xml_name);

        If uploadFile='' then
        begin
        If form1.TimerControl.Enabled then TimerControl.Enabled:=false;

        //flchange_maintime:=false; //если просто нет данных, то не менять актуальный период

        //если отправка не вручную или повторно, то рассчитываем
        If (from_period='') and (to_period='') then
         continue else break;
        end;
      //end;
  //xml_name:='Rootkits.pdf'+'_'+formatdatetime('ss',now());//&
  //fileutil.CopyFile(IncludeTrailingPathDelimiter(Site.ldir)+'Rootkits.pdf',IncludeTrailingPathDelimiter(Site.ldir)+xml_name);//&
  //uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name;

  If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log('--e52--ОШИБКА ! Не найден файл для передачи ! '+ uploadFile);
      continue;
    end;

    //файл готов к отправке записать в лог
    If not PDPlog_new_csv(d1,d2,strtoint(arservers[k,0]),xml_name) then
      begin
         //удалить файл
         If not DeleteFileUTF8(uploadFile)
           then Form1.mess_log('--e53--Ошибка удаления файла: '+uploadFile);
        Form1.mess_log('--e54--Ошибка логирования ! файл '+xml_name+' удален !');
        break;
       end;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--- '+arservers[k,1]+' запись в журнал, готов к отправке');
    fl_final:=true;//ставим признак, что есть что отправлять
   break;
 end;

   //если нечего отправлять, то меняем время периода отправки
     If not fl_final then
      begin
      //если период отделения меньше минимального или он вообще отличается от текущего периода, тогда меняем минимальный период
         If (time_diff<time_min) or ((time_main=time_min) and (time_main<time_diff))
           then time_min:=time_diff;

       If (time_min<>time_main) and flchange_maintime then
             time_main:=time_min;

     end;
     If flchange_maintime then
          form1.mess_log('///flchange_maintime');
     form1.mess_log('///sendTime: '+formatdatetime('dd-mm hh:nn',sendTime)+' |time_main: '+formatdatetime('dd-mm hh:nn',time_main)
                   +' |time_diff: '+formatdatetime('dd-mm hh:nn',time_diff)+' |time_min: '+formatdatetime('dd-mm hh:nn',time_min));
   end;



  //если Ручная ОТПРАВКА
  If not((from_period='') or (to_period='')) then
  begin
      xml_name :=Sett.nIdent+'_'+fd2+'_'+formatDateTime('ss',now())+'_'+padl(rightstr((spoint),3),'0',3)+'.csv';//$
      uploadFile:=makeCSV(d1,d2,strtoint(spoint),xml_name);
      //нет данных
     If uploadFile='' then
        begin
        If form1.TimerControl.Enabled then TimerControl.Enabled:=false;
        active_process:=false;
        Form1.stop_auto_upload();//$
        exit;
        end;
        If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log('--e52--ОШИБКА ! Не найден файл для передачи ! '+ uploadFile);
      active_process:=false;
      Form1.stop_auto_upload();//$
      exit;
    end;

    //файл готов к отправке записать в лог
    If not PDPlog_new_csv(d1,d2,strtoint(spoint),xml_name) then
      begin
         //удалить файл
         If not DeleteFileUTF8(uploadFile)
           then Form1.mess_log('--e53--Ошибка удаления файла: '+uploadFile);
        Form1.mess_log('--e54--Ошибка логирования ! файл '+xml_name+' удален !');
        exit;
       end;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--manual--['+spoint+'] запись в журнал, готов к отправке');
    fl_final:=true;//ставим признак, что есть что отправлять
  end;

  end;


   //$20180323
  // If uploadFile<>'' then
  //begin
  //  fl_send:=true;
  //  form1.SendSuccess();
  //  exit;
  //end;   //$ 20180323


  If not fl_final then
   begin
    //times:=incminute(timeS,30);//$
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z21-- НЕТ ДАННЫХ для передачи: '+formatdatetime('dd-mm hh:nn',time_main)+' min:'+formatdatetime('dd-mm hh:nn',time_min));
    //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--z21-- НЕТ ДАННЫХ ДЛЯ ПЕРЕДАЧИ ');
    active_process:=false;
    Form1.stop_auto_upload();//$
    uploadfile:='';
    exit;
   end;
  //xml_name:='CSV/22013_2014_04_12_16_49_40_286.csv.zip';
  //uploadFile:=IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  //showmessage(uploadFile);

  //points:='';
    //ftp.Disconnect();
    //Form1.mess_log('NORMALKILLFTP >>>>>>>>>>> '+formatdatetime('hh:nn:ss.zzz',now()));

    //если идет прием файлов, отбой
  If form1.TimerReceive.Enabled then
  begin
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i19--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
    //active_process:=false; //12.04
    uploadfile:='';
    Form1.stop_auto_upload();//$
    exit;
  end;
  uplnow:=0;
  Discon_FTP(false);                //&
  form1.accConnectExecute(Self);    //&
  //timeout_max:=0;
  form1.TimerSend.Enabled:=true; //&
  form1.start_auto_upload();
  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s18-test-Успешно ОТПРАВЛЕН файл: '+RightStr(uploadfile,32));
end;




//---------- ПРИЕМ ФАЙЛОВ ОТВЕТОВ -------------------------------
procedure TForm1.Files_to_get();
const alimit=1000;
var
idpoint:integer;
begin
    //если ручной режим - выход
 If form1.CheckBox1.Checked then
   begin
   exit;
   end;
 If active_process then
  begin
    mess_log('--e46--ПРИЕМ файлов невозможен ! Приложение занято, подождите...');
    exit;
  end;

 //если загрузок не было и файлов без ответов тоже нет, то пропускаем
 If (allans=0) then
 begin
 mess_log('======== нет файлов без ответов ======55=');
  form1.stop_auto_download();
 exit;
 end;
  mess_log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ЗАПРОС ФАЙЛОВ БЕЗ ОТВЕТОВ. НАЧАЛО. ======5=');
 //если неотвеченных файлов больше чем limit в запросе, то сбрасываем
 If alimit>=attempt then attempt:=0;
  idpoint:=0;
  //setlength(arans,0,0);

    If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z9.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      //form1.stop_auto_download();
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

    active_process:=true;

    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      //form1.stop_auto_download();
      exit;
     end;
  //файлы требующие ответа
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add('select pdp_answerneed(''tt'','+quotedstr(formatdatetime('yyyy-mm-dd hh:nn:ss',time_past))+','+inttostr(attempt)+');');
    form1.ZReadOnlyQuery1.SQL.add('fetch all in tt;');
    //form1.ZReadOnlyQuery1.SQL.add('(select id_point,file_send,stamp_send,remark from av_pdp_log where data_exist and file_send<>'''' and stamp_answer isnull and id_point=0');
    //form1.ZReadOnlyQuery1.SQL.add('and stamp_send notnull and stamp_send>'+quotedstr(formatdatetime('yyyy-mm-dd hh:nn:ss',time_past))+' order by stamp_send asc)');
    //form1.ZReadOnlyQuery1.SQL.add('UNION ALL ');
    //form1.ZReadOnlyQuery1.SQL.add('(select id_point,file_send,stamp_send,remark from av_pdp_log where data_exist and file_send<>'''' and stamp_answer isnull and id_point>0 ');
    //form1.ZReadOnlyQuery1.SQL.add('and stamp_send notnull and stamp_send>'+quotedstr(formatdatetime('yyyy-mm-dd hh:nn:ss',time_past)));
    //form1.ZReadOnlyQuery1.SQL.add('order by stamp_send asc limit 20 offset '+inttostr(attempt)+');');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e50--Ошибка запроса по отправленным данным на сервера !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      exit;
   end;

   active_process:=false;
   If form1.ZReadOnlyQuery1.RecordCount>0 then
    begin

        For n:=1 to form1.ZReadOnlyQuery1.RecordCount do
        begin
      If trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)='' then continue;
      setlength(arans,length(arans)+1,3);
      arans[length(arans)-1,1]:='0';

      //setlength(arans,2,3);
      // arans[length(arans)-1,1]:='0';
      // arans[length(arans)-2,1]:='0';
      //  arans[length(arans)-1,2]:=formatdatetime('dd-mm-yyyy hh:nn:ss',now());
      //  arans[length(arans)-2,2]:=formatdatetime('dd-mm-yyyy hh:nn:ss',now());
      //  arans[length(arans)-1,0]:='TT_AUTO_22013_2015_12_17_00_00_54_458.xml.ack';
      //  arans[length(arans)-2,0]:='platpdp.res';

       arans[length(arans)-1,2]:=formatdatetime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('stamp_send').AsDateTime);

         If form1.ZReadOnlyQuery1.FieldByName('id_point').AsInteger=0 then
          begin
       If trim(form1.ZReadOnlyQuery1.FieldByName('remark').AsString)='shedules' then
        arans[length(arans)-1,0]:='TT_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.zip.ack'
       else
        arans[length(arans)-1,0]:='RD_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.zip.ack';
        end
      else
      begin
       arans[length(arans)-1,0]:='PD_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.zip.ack';
       end;
      form1.ZReadOnlyQuery1.Next;
          end;


   If form1.CheckBox2.Checked then
     form1.start_auto_download();
    end;
   If form1.ZReadOnlyQuery1.RecordCount=0 then
   begin
     Form1.mess_log('^^^^^^^^^^^ нет файлов без ответов ');
     allans:=0;
     attempt:=0;
     //If form1.CheckBox2.Checked then
      form1.stop_auto_download();
   end;

  //ищем повторно не найденные ответы
   // form1.ZReadOnlyQuery1.SQL.Clear;
   // form1.ZReadOnlyQuery1.SQL.add('select * from av_pdp_log where data_exist and file_send notnull and stamp_answer isnull and not answer ');
   // form1.ZReadOnlyQuery1.SQL.add('and stamp_send notnull and stamp_send>(now()-interval ''5 days'')  order by id_point asc,stamp_send asc limit 40;');//$
   // //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   //try
   //  form1.ZReadOnlyQuery1.open;
   //except
   //   Form1.mess_log('--e51--Ошибка запроса по отправленным данным на сервера !');
   //   //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
   //   form1.ZReadOnlyQuery1.close;
   //   form1.ZConnection1.disconnect;
   //   //active_process:=false;
   //   exit;
   //end;
   //If form1.ZReadOnlyQuery1.RecordCount>0 then
   // begin
   //   setlength(arans,0,0);
   //
   // For n:=1 to form1.ZReadOnlyQuery1.RecordCount do
   // begin
   //   If trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)='' then continue;
   //    setlength(arans,length(arans)+1,2);
   //    arans[length(arans)-1,1]:='0';
   //      If form1.ZReadOnlyQuery1.FieldByName('id_point').AsInteger=0 then
   //   begin
   //    If trim(form1.ZReadOnlyQuery1.FieldByName('remark').AsString)='shedules' then
   //     arans[length(arans)-1,0]:='TT_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.ack'
   //    else
   //     arans[length(arans)-1,0]:='RD_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.ack';
   //   end
   //   else
   //   begin
   //    arans[length(arans)-1,0]:='PD_AUTO_'+trim(form1.ZReadOnlyQuery1.FieldByName('file_send').AsString)+'.zip.ack';
   //    end;
   //   form1.ZReadOnlyQuery1.Next;
   // end;
   // end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;


end;


//---------- удаление ФАЙЛОВ ОТВЕТОВ -------------------------------
procedure TForm1.Delete_old();
var
idpoint:integer;
begin

    //если ручной режим - выход
 If form1.CheckBox1.Checked then
   begin
   exit;
   end;
 If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i20--удаление квитанций невозможно! Приложение занято, подождите...');
      exit;
    end;

  //идет загрузка (получение ответов)
 If form1.Shape2.Brush.Color=clLime then
 begin
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i21--удаление квитанций невозможно! Идет прием файлов!');
   form1.stop_auto_upload();
    exit;
 end;



  mess_log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~3~~');

    If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z9.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;


  active_process:=true;
    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      exit;
     end;
  //определяем последнее время передачи на каждом отделении
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add('select * from av_pdp_log where data_exist and file_send notnull and stamp_answer notnull');
    form1.ZReadOnlyQuery1.SQL.add('and stamp_send notnull and correct and not kill order by stamp_send asc limit 10;');//$
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e50--Ошибка запроса по отправленным данным на сервера !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      exit;
   end;

   active_process:=false;

   If form1.ZReadOnlyQuery1.RecordCount=0 then
    begin
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     //Form1.mess_log('! Не найдено файлов ответов для удаления !');
     stop_auto_upload();
     exit;
    end;

    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== УДАЛЕНИЕ КОРРЕКТНЫХ КВИТАНЦИЙ. НАЧАЛО. =======');
    setlength(ardel,0,0);

    For n:=1 to form1.ZReadOnlyQuery1.RecordCount do
    begin
      If trim(form1.ZReadOnlyQuery1.FieldByName('file_answer').AsString)='' then continue;
       setlength(ardel,length(ardel)+1,2);
       ardel[length(ardel)-1,1]:='0';
       ardel[length(ardel)-1,0]:=trim(form1.ZReadOnlyQuery1.FieldByName('file_answer').AsString);
      form1.ZReadOnlyQuery1.Next;
    end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;


    If not Form1.SetSite('answer') then
     begin
         Form1.mess_log('--e52--Не определены параметры подключения к FTP для приема файлов ответов !');
         Exit;
     end;
    UpdateSite;


  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'KILLFTP_BEFORERECIEVE >>>>>>>>>>> ');
 //If ftp.Connected then
  Discon_FTP(false);
  form1.accConnectExecute(Self);
  //form1.TimerGet.Enabled:=true;
  uplnow:=0;
 form1.Label17.Caption:=inttostr(uplnow);
 //form1.Label19.Caption:=inttostr(uplall);
  If form1.CheckBox2.Checked then
   begin
   FDLSize:=length(ardel);
   form1.Label5.Caption:=floattostr(form1.TimerControl.Interval div 1000);
   end;
  progressbar1.Position:=0;

  form1.TimerDelete.Enabled:=true;
end;


//---------- ПРИЕМ ФАЙЛОВ ОТВЕТОВ -------------------------------
procedure TForm1.Data_GET();
var
idpoint:integer;
pathf:string;
begin
  If length(arans)=0 then
   begin
      //mess_log('--z89. НЕТ ФАЙЛОВ БЕЗ ОТВЕТОВ !!!');
      exit;
   end;
  //buzz:=0;//сбрасываем флаг отсутствия неотвеченных файлов
 //если ручной режим - выход
 If form1.CheckBox1.Checked then
   begin
   exit;
   end;

 If active_process then
    begin
      mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e47--Ошибка приема квитанций! Приложение занято, подождите...');
      exit;
    end;

 //не зеленый цвет (массив еще не обнулялся)
 If form1.Shape2.Brush.Color<>clLime then
 begin
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i22--ИЗМЕНЕН РЕЖИМ РАБОТЫ !');
   //form1.stop_auto_download();
   form1.start_auto_download();
    //exit;
 end;

    If not Form1.SetSite('answer') then
     begin
         Form1.mess_log('--e52--Не определены параметры подключения к FTP для приема файлов ответов !');
         Exit;
     end;
    UpdateSite;
    pathf:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir);

  mess_log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПРИЕМ ФАЙЛОВ ОТВЕТОВ. НАЧАЛО. ======4=');
  If length(arans)=0 then
   begin
        Form1.mess_log('! Файлов, требующих ответа, НЕ НАЙДЕНО !');
        exit;
   end;

  //проверяем нет ли уж скачанных ответов
  uploadFile:='';
  idpoint:=0;

 //   If form1.ZConnection1.Connected then
 //  begin
 //   If zbusy<Sett.maxz then
 //    begin
 //     zbusy:=zbusy+1;
 //     Form1.mess_log('--z9.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
 //     active_process:=false;
 //     exit;
 //     end;
 //    form1.ZConnection1.Disconnect;
 //    zbusy:=0;
 //  end;
 //
 //   downnow:=0;
 //
 //  for n:=low(arans) to high(arans) do
 //  begin
 //    inc(downnow);
 //    form1.Label10.Caption:=inttostr(downnow);
 //    If time_past>strtodatetime(arans[n,2],mySettings) then
 //    continue;
 //
 //    time_past:=strtodatetime(arans[n,2],mySettings);
 //
 //   if FileExistsUTF8(pathf+arans[n,0]) then
 //        begin
 //          If not xmlparse(pathf,arans[n,0])
 //            then continue;
 //            arans[n,1]:='2';
 //          if length(arrans)<3 then
 //          begin
 //          //если без ошибок, логим
 //            If arrans[0,0]='0' then
 //            begin
 //             PDPlog_get(arans[n,0], 1);
 //             inc(downok);
 //             form1.Label12.Caption:=inttostr(downok);
 //             end;
 //          end
 //            else
 //            begin
 //            //записываем результат
 //             PDPlog_get(arans[n,0], 2);
 //            end;
 //            inc(downall);
 //            form1.Label11.Caption:=inttostr(downall);
 //            application.ProcessMessages;
 //        end
 //   else
 //    begin
 //      //arans[n,1]:='1';
 //      Form1.mess_log('--e19-- Среди принятых НЕТ файла: '+arans[n,0]);
 //      //application.ProcessMessages;
 //    end;
 //  end;
 //
 //If not checkbox8.Checked then
 //begin
 //   timercnt:=0;//$
 //   stop_auto_download();//$
 //   exit;//$
 //end;

  //подключаемся к серверу для получения файлов
  //active_process:=true;
  downfile:='';

  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'KILLFTP_BEFORERECIEVE >>>>>>>>>>> ');
 //If ftp.Connected then
  Discon_FTP(false);
  form1.accConnectExecute(Self);
  //form1.TimerGet.Enabled:=true;
  downnow:=0;
  If form1.CheckBox2.Checked then
   begin
   FDLSize:=length(arans);
   form1.Label5.Caption:=floattostr(form1.TimerControl.Interval div 1000);
   end;
  progressbar1.Position:=0;
  form1.TimerReceive.Enabled:=true;
end;


//создать xml остановочных пунктов
function CreateXmlPoints(stamp_mode:TDateTime):boolean;
var
  xdoc: TXMLDocument;                                  // переменная документа
  RootNode, parentNode , nofilho, tmp, child: TDOMNode;
  sdate, datcheck:string;
  n:integer;

begin
  result:=false;
  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z10.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
   If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с сервером базы данных отсутствует !');
      exit;
     end;
   sdate:=formatdatetime('yyyy-mm-dd hh:nn:ss',stamp_mode);
   If IncDay(now(),-1)>stamp_mode then datcheck:='and createdate<'+Quotedstr(sdate)
   else datcheck:='';
   form1.ZReadOnlyQuery1.SQL.Clear;
     form1.ZReadOnlyQuery1.SQL.add(' select pdp_points(''pnt'');');
     form1.ZReadOnlyQuery1.SQL.add(' FETCH ALL IN pnt;');
   //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$

   try
     form1.ZReadOnlyQuery1.open;
   except
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      exit;
   end;
  If form1.ZReadOnlyQuery1.recordcount=0 then
    begin
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;
     exit;
    end;
  //Создаём документ
  xdoc := TXMLDocument.create;

  //Создаём корневой узел
  RootNode := xdoc.CreateElement('imp:Import');
  TDOMElement(RootNode).SetAttribute('xsi:type','imp:FullImport');
  //TDOMElement(RootNode).SetAttribute('xsi:type','imp:DeltaImport');//$
  //s:=formatdatetime('yyyy-mm-dd',TimeLocalToUtc(now()));//$

  TDOMElement(RootNode).SetAttribute('createdAt',formatdatetime('yyyy-mm-dd',stamp_mode)+'T'+formatdatetime('hh:nn',stamp_mode)+'Z');
  TDOMElement(RootNode).SetAttribute('dataType','DESTINATION');
  TDOMElement(RootNode).SetAttribute('recordCount',inttostr(form1.ZReadOnlyQuery1.recordcount));
  TDOMElement(RootNode).SetAttribute('transportSegment','AUTO');
  TDOMElement(RootNode).SetAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
  TDOMElement(RootNode).SetAttribute('xmlns:imp','http://www.egis-otb.ru/gtimport/');
  TDOMElement(RootNode).SetAttribute('xmlns:dt','http://www.egis-otb.ru/datatypes/');
  TDOMElement(RootNode).SetAttribute('xmlns:onsi-stat','http://www.egis-otb.ru/data/onsi/stations/');
  TDOMElement(RootNode).SetAttribute('xsi:schemaLocation','http://www.egis-otb.ru/gtimport/ ru.egisotb.import.xsd http://www.egis-otb.ru/data/onsi/stations/ '+
  'ru.egisotb.data.onsi.stations.xsd http://www.egis-otb.ru/datatypes/ ru.egisotb.datatypes.xsd');
  Xdoc.Appendchild(RootNode);                           // Добавляем корневой узел в документ

  //Создаём родительский узел
  RootNode:= xdoc.DocumentElement;

  for n:=1 to form1.ZReadOnlyQuery1.RecordCount do
  begin
   //showmessage(form1.ZReadOnlyQuery1.FieldByName('strana').asString
           //+#13+form1.ZReadOnlyQuery1.FieldByName('okato').asString);//$
   //If form1.ZReadOnlyQuery1.FieldByName('idcountry').asinteger=0 then
      //begin
      //form1.ZReadOnlyQuery1.Next;
      //continue;
      //end;
  parentNode := xdoc.CreateElement('entry');
  //parentNode := xdoc.CreateElement('updated-entry');//$
  TDOMElement(parentNode).SetAttribute('sourceId',form1.ZReadOnlyQuery1.FieldByName('id').asString); // создаём атрибуты родительского узла
  TDOMElement(parentNode).SetAttribute('xsi:type','imp:ImportedEntry');        // создаём атрибуты родительского узла
  RootNode.Appendchild(parentNode);                        // добавляем родительский узел

  //Создаём дочерний узел
  tmp := xdoc.CreateElement('data');
  //Form1.mess_log(form1.ZReadOnlyQuery1.FieldByName('name').asString);
  //TDOMElement(tmp).SetAttribute('name',form1.ZReadOnlyQuery1.FieldByName('id').asString);
  TDOMElement(tmp).SetAttribute('name',form1.ZReadOnlyQuery1.FieldByName('nn').asString);     //$ создаём его атрибуты
  //TDOMElement(tmp).SetAttribute('latitude','');
  //TDOMElement(tmp).SetAttribute('longitude','');
  //TDOMElement(tmp).SetAttribute('nearestTown','');
  //TDOMElement(tmp).SetAttribute('shortLatName','');
  //TDOMElement(tmp).SetAttribute('shortName','');
  TDOMElement(tmp).SetAttribute('xsi:type','onsi-stat:AutoStation');
  nofilho := xdoc.CreateElement('actualPeriod');
  //TDOMElement(nofilho).SetAttribute('from',actper);//$
  TDOMElement(nofilho).SetAttribute('from',formatdatetime('yyyy-mm-dd',INCday(stamp_mode,Sett.nSheddays))+'T00:00Z');
  TDOMElement(nofilho).SetAttribute('to'  ,formatdatetime('yyyy-mm-dd',incday(now(),upperactual))+'T00:00Z');//$
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:ImportDateTimePeriod');
  tmp.AppendChild(nofilho);
  nofilho := xdoc.CreateElement('countryCode');
  //TDOMElement(nofilho).SetAttribute('id',form1.ZReadOnlyQuery1.FieldByName('idcountry').asString);
  TDOMElement(nofilho).SetAttribute('value',form1.ZReadOnlyQuery1.FieldByName('strana').asString);
  TDOMElement(nofilho).SetAttribute('xsi:type','dt:SimpleDictionaryValue');
  tmp.AppendChild(nofilho);
  If trim(form1.ZReadOnlyQuery1.FieldByName('okato').asString)<>'' then
    begin
      nofilho := xdoc.CreateElement('okato');
        TDOMElement(nofilho).SetAttribute('value',form1.ZReadOnlyQuery1.FieldByName('okato').asString);
          TDOMElement(nofilho).SetAttribute('xsi:type','dt:SimpleDictionaryValue');
            tmp.AppendChild(nofilho);
    end;
  //Создаём ещё один дочерний узел
  child:= xdoc.CreateElement('stationType');
  //TDOMElement(parentNode).SetAttribute('ano', '1976');   // создаём его атрибуты
  If form1.ZReadOnlyQuery1.FieldByName('id').AsInteger=Sett.idpoint_station then
  nofilho := xdoc.CreateTextNode('true')                    // вставляем значение в узел
  else
   nofilho := xdoc.CreateTextNode('false');
  child.Appendchild(nofilho);                         // сохраняем узел
  tmp.AppendChild(child);     // вставляем дочерний узел в соответствующий родительский
  parentNode.AppendChild(tmp);     // вставляем дочерний узел в соответствующий родительский

  form1.ZReadOnlyQuery1.Next;
  end;

  form1.ZReadOnlyQuery1.Close;
  form1.ZConnection1.Disconnect;
  //если в автомате, то используем реальное время, если нет, То из первого периода
  //If form1.CheckBox2.Checked then
  //xml_name:=nIdent+'_'+formatDateTime('yyyy_mm_dd_hh_nn_ss_zzz',now())+'.xml'
  //else
  xml_name:=Sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh',stamp_mode)+'_00_'+formatDateTime('ss_zzz',now())+'.xml';
    If not DirectoryExistsUTF8(ExtractFilePath(Application.ExeName)+Site.ldir)  then
     begin
       CreateDir(ExtractFilePath(Application.ExeName)+'POINTS');
       Site.ldir:='POINTS';
     end;
  uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  writeXMLFile(xDoc,uploadFile);

  Xdoc.free;                                               // освобождаем память
  result:=true;
end;


function TimeLocalToUTC(UT: TDateTime): TDateTime;
var
  LT: TDateTime;
  TZOffset: Integer;
  {$IFDEF MSWINDOWS}
  BiasType: Byte;
  //TZInfo: TTimeZoneInformation;
  {$ENDIF}
begin
  LT := UT;
  {$IFDEF MSWINDOWS}
  //BiasType := GetTimeZoneInformation(TZInfo);
  //if (BiasType=0) then begin
  //  Result := UT;
  //  Exit;
  //end;

  // Determine offset in effect for DateTime UT.
  //if (BiasType=2) then
  //  TZOffset := TZInfo.Bias + TZInfo.DaylightBias
  //else
  //  TZOffset := TZInfo.Bias + TZInfo.StandardBias;
  {$ENDIF}
  {$IFDEF UNIX}
    TZOffset := -Tzseconds div 60;
  {$ENDIF}

  // Apply offset.
  if (TZOffset > 0) then
    // Time zones west of Greenwich.
    LT := UT + EncodeTime(TZOffset div 60, TZOffset mod 60, 0, 0)
  else if (TZOffset = 0) then
    // Time Zone = Greenwich.
    LT := UT
  else if (TZOffset < 0) then
    // Time zones east of Greenwich.
    LT := UT - EncodeTime(Abs(TZOffset) div 60, Abs(TZOffset) mod 60, 0, 0);

  // Return Local Time.
  Result := LT;
end;

//**************** создание и отправвка файлов ВРУЧНУЮ ************************
procedure TForm1.Button1Click(Sender: TObject);
var
  date1,date2,spr:string;
  enable:boolean;
begin
 enable:=false;

  If active_process then
    begin
      mess_log('-manual_mode-1.0--Передача файлов невозможно ! Приложение занято, подождите...');
      exit;
    end;
  uploadFile:='';
  xml_name:='';
  // This is unix time 2010-07-26 17:50:17
  //d := UnixToDateTime(1280166617);
  //d := TimeLocalToUTC(now());
  date1:=formatDateTime('yyyy-mm-dd hh:nn:ss',form1.DateTimePicker1.DateTime);//&
  date2:=formatDateTime('yyyy-mm-dd hh:nn:ss',form1.DateTimePicker2.DateTime);//&


   //ПДП
 If form1.CheckBox3.Checked then
   begin
    If form1.ComboBox1.ItemIndex<0 then
  begin
    showmessage('Не выбран субъект для формирования пакета данных!');
    exit;
  end;
     //If not Form1.SetSite('pdp_auto') then
    If not Form1.SetSite('csv') then
      begin
       Form1.mess_log('Не найдено настроек FTP для передачи данных !');
       exit;
      end;
    //form2:=Tform2.create(self);
    //form2.ShowModal;
    //FreeAndNil(form2);
    xml_name :=Sett.nIdent+'_'+formatDateTime('yyyy_mm_dd_hh_nn',form1.DateTimePicker1.DateTime)+'_57_'+formatDateTime('zzz',now())+'.csv';//$
    uploadFile:= makeCSV(date1,date2,strtoint(utf8copy(form1.ComboBox1.Text,1,utf8pos('|',form1.ComboBox1.Text)-1)),xml_name);
    //exit;
    If uploadFile='' then exit;
    //файл готов к отправке записать в лог
    If not PDPlog_new_csv(date1,date2,strtoint(utf8copy(form1.ComboBox1.Text,1,utf8pos('|',form1.ComboBox1.Text)-1)),xml_name) then
      begin
         //удалить файл
         If not DeleteFileUTF8(uploadFile)
           then Form1.mess_log('Ошибка удаления файла !');
           exit;
        Form1.mess_log('Ошибка логирования ! файл '+xml_name+' удален !');
       end;

    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  запись в базу, готов к отправке');
    end;



//остановочные пункты
 If form1.CheckBox5.Checked and not enable then
   begin
    enable:=true;
    spr:='points';
   If not Form1.SetSite('points') then
      begin
       Form1.mess_log('Не найдено настроек FTP для передачи справочника !');
       exit;
      end;
    If CreateXmlPoints(form1.DateTimePicker1.DateTime) then
     Form1.mess_log('XML остановочных пунктов Успешно создан !')
     else
     Form1.mess_log('Ошибка создания XML !');
   end;

 //перевозчики
 //If form1.CheckBox6.Checked and not enable then
 // begin
 // enable:=true;
 // spr:='perevoz';
 // If not Form1.SetSite('perevoz') then
 //     begin
 //      Form1.mess_log('Не найдено настроек FTP для передачи справочника !');
 //      exit;
 //     end;
 //If CreateXmlPerevoz(form1.DateTimePicker1.DateTime) then
 //  Form1.mess_log('XML перевозчиков Успешно создан !')
 //  else
 //    Form1.mess_log('Ошибка создания XML !');
 //end;

 //сервера
 //If form1.CheckBox7.Checked and not enable then
 // begin
 // enable:=true;
 //  spr:='servers';
 //     If not Form1.SetSite('servers') then
 //     begin
 //      Form1.mess_log('Не найдено настроек FTP для передачи справочника !');
 //      exit;
 //     end;
 // If CreateXmlServers() then
 //  Form1.mess_log('XML серверов Успешно создан !')
 //  else
 //    Form1.mess_log('Ошибка создания XML !');
 // end;


 //РАСПИСАНИЯ
  If form1.CheckBox4.Checked and not enable then
    begin
    enable:=true;
     spr:='shedules';
       If not Form1.SetSite('shedules') then
      begin
       Form1.mess_log('Не найдено настроек FTP для передачи расписаний !');
       exit;
      end;
        Form1.mess_log('Создание справочника расписаний, подождите...');
   If form1.RadioButton1.Checked then
     If CreateXmlShedule(form1.DateTimePicker1.DateTime) then
       Form1.mess_log('XML расписаний Успешно создан !')
     else
     Form1.mess_log('Ошибка создания XML !')
   else
     uploadFile:=form1.Edit1.text;
    end;

   If FTP.Connected and form1.TimerSend.Enabled then
    begin
      If SBar.Panels[0].Text = Site.site then
       begin
      mess_log('-manual_mode-1.10--FTP-соединение актуально');
      exit;

       end
      else
       begin
        mess_log('-manual_mode-1.11--Запрос на передачу другого типа данных');
         form1.TimerSend.Enabled:=false;
       end;
    end;

  UpdateSite;

  //xml_name:='22013_2014_04_26_16_47_06_398.csv.zip';
  //uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+xml_name;

  If not fileexistsUTF8(uploadFile) then
    begin
      Form1.mess_log('ОШИБКА ! Не найден файл для передачи ! '+ uploadFile);
      exit;
    end;

  If not form1.CheckBox3.Checked then
   begin
     //файл готов к отправке записать в лог
    If not PDPlog_new_XML(spr,xml_name,date1) then
      begin
        Form1.mess_log('--e59--Ошибка логирования справочника '+xml_name+' !');
        exit;
       end;
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'   запись в базу, справочник '+spr+' готов к отправке');
    end;
  //xml_name:='CSV/22013_2014_04_12_16_49_40_286.csv.zip';
  //uploadFile:=IncludeTrailingPathDelimiter(Site.ldir)+xml_name; //для Win ='\' Linux='/'
  //showmessage(uploadFile);

  //points:='';

  If active_process then
   begin
     mess_log('-manual_mode-1.12--Передача файлов невозможно ! Приложение занято, подождите...');
     exit;
   end;
  Discon_FTP(false);
  form1.accConnectExecute(Self);
  form1.TimerSend.Enabled:=true;
end;

//******************* получить ответ вручную ***************************************
procedure TForm1.Button3Click(Sender: TObject);
begin

  //xmlparse(form1.Edit1.Text);
  //exit;
 //showmessage(ExtractFilePath(Application.ExeName));
  //If active_process then
  //  begin
  //    mess_log('Прием невозможен ! Приложение занято, подождите...');
  //    exit;
  //  end;
  //
  //   If not Form1.SetSite('answer') then
  //   begin
  //       Form1.mess_log('Не определены параметры подключения к FTP для передачи ПДП !');
  //       Exit;
  //   end;
  //  UpdateSite;

  downfile:='';
   //If not Form1.SetSite('sprav') then
      //begin
       //Form1.mess_log('Не найдено настроек FTP для передачи справочника !');
       //exit;
      //end;
  //downfile:='PD_AUTO_22013_2015_09_13_14_31_00_990.csv.zip.ack';
  //downfile:='PD_AUTO_22013_2016_01_28_08_31_00_201.csv.zip.ack'; //.ack
  //downfile:='PD_AUTO_22013_2016_01_11_04_31_00_906.csv.zip.ack';

     downfile:='TT_AUTO_22013_2015_12_17_00_00_54_458.xml.ack';
     CreateFilePath:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+downfile;

      //'platpdp.res';
  //Discon_FTP(false);//$
  //form1.accConnectExecute(Self);
  //form1.TimerReceive.Enabled:=true;// $

   If FTP.Connected then
   begin
    active_process:=true;
    Form1.mess_log('Начинается прием файла: '+createfilepath);
   //FDLSize := CurrentSize;
    FDLDone := 0;
    if FDLSize = 0 then
      FDLSize := 1;
    FreeAndNil(FFile);
    CreateFilePath:='';
    CreateFilePath:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+downfile;
    Form1.mess_log(CreateFilePath);
    FTP.Retrieve(downfile);
   end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   Form2:=TForm2.create(self);
   Form2.ShowModal;
   FreeAndNil(Form2);
   form1.ReadSettings();
end;


procedure TForm1.accConnectExecute(Sender: TObject);
begin
  //сброс флагов
  fl_send:=false;

  if Length(Site.Host)=0 then
    begin
    Form1.mess_log('--e44--Не найдено настроек подключения к FTP !');
    exit;
    end;
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'********** ПОДКЛЮЧЕНИЕ к FTP-серверу *********');
 If not FTP.Connect(Site.Host, Word(StrToInt(Site.Port))) then
   begin
     Form1.mess_log('--e45--Не удается подключиться к FTP !');
     exit;
   end;
 //включаем таймер ожидания успешной передачи/приема
  //form1.TimerControl.Enabled:=true;#1207
end;

procedure TForm1.accDisconnectExecute(Sender: TObject);
begin
   Discon_FTP(false);
end;

procedure TForm1.Discon_ftp(ClearLog: boolean);
begin
  //выключить таймер контроля передачи
  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'<<< NORMAL_KILL_FTP');
  Form1.TimerControl.Enabled:=false;
  timercnt:=0;
  ftpdeny:=false;
  readytodownload:=false;//готовность к загрузке
  If ftp.Connected then
    begin
     FTP.Disconnect;
     //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s22-- FTP-соединение. Отключение. ');
    end;
  if ClearLog then form1.MemoLog.Clear;
  form1.SBar.Panels[3].Text:='ОТКЛЮЧЕНО ОТ FTP';
end;


//procedure TForm1.accSiteManagerExecute(Sender: TObject);
//var
//F: TFrmSites;
//Res: TModalResult;
//begin
//F := TFrmSites.Create(Self);
//try
//  Res := F.ShowModal;
//  if Res<>mrCancel then begin
//    UpdateSite;
//    //if Res=mrYes then
//      //accConnectExecute(Self);
//  end;
//finally
//  F.Free;
//end;
//end;



procedure TForm1.Bevel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     form1.Label1.Caption:='00:00:01';
end;

procedure TForm1.Bevel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
       form1.Label7.Caption:='00:00:01';
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    Form1.OpenDialog1.Execute;
    form1.Edit1.Text:=form1.OpenDialog1.FileName;
end;



procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  If form1.CheckBox1.Checked then
    form1.CheckBox2.Checked:=false
  else
    form1.CheckBox2.Checked:=true;

  If form1.CheckBox1.Checked and
    FORM1.RadioButton1.Checked then form1.GroupBox3.Enabled:=true;
  //form1.TimerSp r.Enabled:=true;//включить таймер выгрузки справочников

end;

//автоматический режим
procedure TForm1.CheckBox2Change(Sender: TObject);
begin
   timesend:=form1.DateTimePicker1.DateTime;

  form1.stop_auto_download();
  form1.stop_auto_upload();

    If form1.CheckBox2.Checked then
  begin
   form1.CheckBox1.Checked:=false;
   form1.GroupBox2.Enabled:=true;
   form1.GroupBox1.Enabled:=false;
   //form1.CheckBox8.Checked:=true;//$
   form1.CheckBox9.Checked:=true;
   form1.TCountDown.Enabled:=true;//включить таймер автоматической передачи
  end
  else
  begin
  form1.CheckBox1.Checked:=true;
  form1.GroupBox2.Enabled:=false;
  form1.GroupBox1.Enabled:=true;
  form1.TCountDown.Enabled:=false;//выключить таймер автоматической передачи
  end;
end;

procedure TForm1.CheckBox8Change(Sender: TObject);
begin
   //If form1.CheckBox8.Checked then
   //form1.TimerSpr.Enabled:=true//включить таймер выгрузки справочников
  //else
   //form1.TimerSpr.Enabled:=false//включить таймер выгрузки справочников

end;

procedure TForm1.CheckBox9Change(Sender: TObject);
begin
    If form1.CheckBox9.Checked then
    begin
    //включить автоматическую передачу данных
    //form1.Label1.Caption:='00:00:00';
    //form1.TCountDown.Enabled:=true;
    end;
end;

function GetSitePath: string;
begin
  if Site.path='' then
    result := '/'
  else
    Result := Site.Path;
end;


procedure TForm1.UpdateSite;
begin
  if Site.Site='' then
    SBar.Panels[0].Text := '<настройте подключения>'
  else begin
    SBar.Panels[0].Text := Site.site;
    //if DirectoryExists(Site.ldir) then
      //SetLocalDirectory(Site.ldir);
  end;
  SBar.Panels[1].Text := Site.user;
  if Site.Host <> '' then
    SBar.Panels[2].Text := Site.Host+' путь: '+GetSitePath
  else
    SBar.Panels[2].Text := '';

  //form1.Edit1.Text:='';
  If form1.RadioButton1.Checked then
  form1.Edit1.Text:=Site.ldir;

  application.ProcessMessages;
end;


//передача файла
function TForm1.Data_SENDempty(from_period:string;to_period:string;sname:string):boolean;
var
minut,k,n:integer;
d1,d2,fd2,td1,td2,newname:string;
flag_send,fl_final,flag_find,flchange_maintime:boolean;
sendtime,time_diff,time_min:TDateTime;
//arpro:array of string;
begin
  result:=false;
  d1:='';
  d2:='';
  fd2:='';
  td1:='';
  td2:='';
  flchange_maintime:=true;
  //если ручной режим - выход
 //If form1.CheckBox1.Checked then
 //  begin
 //  exit;
 //  end;
 If active_process then
     begin
       mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--e74--Передача невозможна ! Приложение занято, подождите...');
       exit;
     end;

 //идет загрузка (получение ответов)
 If form1.Shape2.Brush.Color=clLime then
 begin
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i23--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
   form1.stop_auto_upload();
    exit;
 end;

  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^12^^');
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ОТПРАВКА ДАННЫХ. НАЧАЛО. ========');

   If not Form1.SetSite('csv') then
     begin
         Form1.mess_log('Не определены параметры подключения к FTP для передачи ПДП !');
         Exit;
     end;
    UpdateSite;

  //если отправка не вручную или повторно, то рассчитываем
 // If (from_period='') and (to_period='') then
 //  begin
 //   sendTime:=now();
 //   fd2:=formatDateTime('yyyy_mm_dd_hh_nn',sendTime);
 // try
 //   minut :=strtoint(FormatDateTime('nn',sendTime));
 // except
 //   Form1.mess_log('Ошибка преобразования времени !');
 //   exit;
 // end;
 //If minut>30 then
 // begin
 //   td1:=formatDateTime('yyyy-mm-dd hh',sendTime)+':00:00';
 //   td2:=formatDateTime('yyyy-mm-dd hh',sendTime)+':30:00';
 // end
 //else
 //  begin
 //   td1:=formatDateTime('yyyy-mm-dd hh',incHour(sendTime,-1))+':30:00';
 //   td2:=formatDateTime('yyyy-mm-dd hh',sendTime)+':00:00';
 // end;
 //
 // end
 // else
  begin
     fd2:=formatDateTime('yyyy_mm_dd_hh_nn',incminute(strtodatetime(to_period,mySettings),5));
       d1:=from_period;
       d2:=to_period;
  end;

   uploadFile:='';
   xml_name:='';
   flag_send:=false;

    fl_final:=false;
    k:=-1;
   //проверяем есть ли файлы созданные но не отправленные
      If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z18.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

   active_process:=true;

   uploadFile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+sname+'.zip';
   newname := '';

  If fileexistsUTF8(uploadFile) then
    begin
    fl_final:=true;//ставим признак, что есть что отправлять
    //Form1.mess_log(' Файл существует '+ uploadFile);
    Form1.mess_log('--i31--Переименование неотправленного файла: '+sname+#13+' ++++ '+uploadFile);
    //newname:=utf8copy(uploadfile,1,utf8length(uploadfile)-11)+'777.csv.zip';//&
     newname:=utf8copy(sname,1,23)+'77_'+utf8copy(sname,utf8length(sname)-6,8);
    //RenameFileUTF8(newname,uploadFile);
    end;
  //else
  iF not fl_final then
  begin
   Form1.mess_log('--e90--ОШИБКА ! Не найден файл для передачи ! '+ uploadFile);
   //exit;//$

  If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z1--'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      active_process:=false;
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;
      If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e61--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        active_process:=false;
        exit;
       end;
  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      form1.ZReadOnlyQuery1.SQL.add(' Update av_pdp_log set error_main=1 WHERE file_send='+quotedstr(sname));
      //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;
  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e62--ОШИБКА ЗАПИСИ В БАЗУ !');
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
  end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;

      active_process:=false;
    Form1.stop_auto_upload();//$
     exit;
   end;

  mess_log('----Отправляем повторно ранее созданный файл: '+sname);
  //newname := '';
  //newname:=utf8copy(sname,1,23)+'77_'+utf8copy(sname,utf8length(sname)-7,7);
  RenameFileUTF8(uploadFile, ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+newname+'.zip');
  uploadfile:=ExtractFilePath(Application.ExeName)+IncludeTrailingPathDelimiter(Site.ldir)+newname+'.zip';
  xml_name:=newname;

   If not(form1.Connect(form1.ZConnection1,-1)) then
       begin
        Form1.mess_log('--e68--Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
        active_process:=false;
        exit;
       end;
  try
    if not form1.ZConnection1.InTransaction then form1.ZConnection1.StartTransaction
    else form1.ZConnection1.Rollback;
      //создаем запись о созданном файле
      form1.ZReadOnlyQuery1.SQL.Clear;
      form1.ZReadOnlyQuery1.SQL.add(' Update av_pdp_log set error_main=0,stamp_send=now(),answer=false,stamp_answer=null,file_answer='''',remark='+Quotedstr('100006|Загружен пустой файл->'+sname)+',file_send='+Quotedstr(newname)+' WHERE file_send='+quotedstr(sname));
      //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
       //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
       form1.ZReadOnlyQuery1.ExecSQL;
       form1.ZConnection1.Commit;
  except
       if form1.ZConnection1.InTransaction then form1.ZConnection1.Rollback;
        mess_log('--e62--ОШИБКА ЗАПИСИ В БАЗУ !');
        //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
        form1.ZReadOnlyQuery1.close;
        form1.ZConnection1.disconnect;
        active_process:=false;
        exit;
  end;

     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;


  //если идет прием файлов, отбой
  If form1.TimerReceive.Enabled then
  begin
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i24--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
    active_process:=false;
    uploadfile:='';
    Form1.stop_auto_upload();//$
    exit;
  end;
  uplnow:=0;
  Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'  файл '+xml_name+' готов к повторной отправке');
  result:=true;
  Discon_FTP(false);                //&
  form1.accConnectExecute(Self);    //&
  //timeout_max:=0;
  form1.TimerSend.Enabled:=true; //&
  form1.start_auto_upload();
  //Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--s28-test-Успешно ОТПРАВЛЕН файл: '+RightStr(uploadfile,32));
  //fl_send:=true;
  //form1.SendSuccess();
  //form1.stop_auto_upload();
end;

//повторная передача пустых файлов
function TForm1.Data_reSENDempty():boolean;
const
   arlen=7;
var
k:integer;
//spr:string;
flag_send,fl_final:boolean;
arresend:array of array of string;
begin
 result:=false;
  setlength(arresend,0,0);
  //если ручной режим - выход
 //If form1.CheckBox1.Checked then
 //  begin
 //  exit;
 //  end;
 If active_process then
  begin
    mess_log('--e87--Передача файлов невозможна ! Приложение занято, подождите...');
    exit;
  end;

 //идет загрузка (получение ответов)
 If form1.Shape2.Brush.Color=clLime then
 begin
   Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i25--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
   exit;
 end;

  //mess_log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
  //mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПОВТОРНАЯ ОТПРАВКА ДАННЫХ пустых файлов. НАЧАЛО. ======7=');
  uploadFile:='';
  xml_name:='';
  flag_send:=false;
  fl_final:=false;
  k:=-1;

  //выясняем файлы с ошибками
      If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z18.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

    active_process:=true;

    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      exit;
     end;
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add(' select id_point, stamp_from, stamp_to, file_send, error_line, error_file, answer_text ');
    form1.ZReadOnlyQuery1.SQL.add(' from av_pdp_log ');
    form1.ZReadOnlyQuery1.SQL.add('where error_main=-100006 and id_point>0 ');
    form1.ZReadOnlyQuery1.SQL.add('order by stamp_from desc limit 30 ');
   //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);//$
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e59--Ошибка запроса по еще НЕ ОТПРАВЛЕННЫМ данным !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      exit;
   end;
   active_process:=false;

   If form1.ZReadOnlyQuery1.RecordCount>0 then
    begin
    mess_log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПОВТОРНАЯ ОТПРАВКА ДАННЫХ пустых файлов. НАЧАЛО. ======7=');

   for k:=0 to form1.ZReadOnlyQuery1.RecordCount-1 do
    begin
      SetLength(arresend,length(arresend)+1,arlen);
      arresend[length(arresend)-1,0]:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime);
      arresend[length(arresend)-1,1]:=form1.ZReadOnlyQuery1.FieldByName('id_point').AsString;
      arresend[length(arresend)-1,2]:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('stamp_to').AsDateTime);
      arresend[length(arresend)-1,3]:=form1.ZReadOnlyQuery1.FieldByName('file_send').AsString;
      arresend[length(arresend)-1,4]:=form1.ZReadOnlyQuery1.FieldByName('error_file').AsString;
      arresend[length(arresend)-1,5]:=form1.ZReadOnlyQuery1.FieldByName('error_line').AsString;
      arresend[length(arresend)-1,6]:=form1.ZReadOnlyQuery1.FieldByName('answer_text').AsString;
      form1.ZReadOnlyQuery1.Next;
     end;
   end;
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;

   for k:=low(arresend) to high(arresend) do
    begin
        result:=true;
         //Form1.mess_log('++');//$
        If Data_Sendempty(arresend[k,0],arresend[k,2],arresend[k,3]) then
             //time_past:=strtodatetime(arresend[k,0],mySettings);
        begin
         mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПОВТОРНАЯ ОТПРАВКА ДАННЫХ. КОНЕЦ. =======');
         break;
         end;
    end;

end;




//повторная передача файла
function TForm1.Data_RESEND():boolean;
const
   arlen=7;
var
k:integer;
//spr:string;
flag_send,fl_final:boolean;
arresend:array of array of string;
begin
 result:=false;
  setlength(arresend,0,0);
  //если ручной режим - выход
 //If form1.CheckBox1.Checked then
 //  begin
 //  exit;
 //  end;
 If active_process then
  begin
    mess_log('--e87--Передача файлов невозможна ! Приложение занято, подождите...');
    exit;
  end;
  //идет загрузка (получение ответов)
 If form1.Shape2.Brush.Color=clLime then
 begin
    Form1.mess_log(formatdatetime('hh:nn:ss.zzz',now())+'--i26--Отправка НЕВОЗМОЖНА! Идет прием файлов!');
    exit;
 end;


  mess_log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
  mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПОВТОРНАЯ ОТПРАВКА ДАННЫХ. НАЧАЛО. ======6=');
  uploadFile:='';
  xml_name:='';
  flag_send:=false;
  fl_final:=false;
  k:=-1;

  //выясняем файлы с ошибками
      If form1.ZConnection1.Connected then
   begin
    If zbusy<Sett.maxz then
     begin
      zbusy:=zbusy+1;
      Form1.mess_log('--z18.'+inttostr(zbusy)+' Выполняется запрос! Выход...');
      exit;
      end;
     form1.ZConnection1.Disconnect;
     zbusy:=0;
   end;

    active_process:=true;

    If not(form1.Connect(form1.ZConnection1,-1)) then
     begin
      Form1.mess_log('Соединение с ЦЕНТРАЛЬНЫМ СЕРВЕРОМ отсутствует !');
      active_process:=false;
      exit;
     end;
    form1.ZReadOnlyQuery1.SQL.Clear;
    form1.ZReadOnlyQuery1.SQL.add('select * ');
    form1.ZReadOnlyQuery1.SQL.add('from (   ');
    form1.ZReadOnlyQuery1.SQL.add(' select ');
    form1.ZReadOnlyQuery1.SQL.add(' coalesce((select count(*) from av_pdp_log b where b.stamp_from=a.stamp_from and a.id_point=b.id_point ');
    form1.ZReadOnlyQuery1.SQL.add('    and b.stamp_send notnull and a.stamp_send<>b.stamp_send and b.data_exist and b.id_point>0 and not b.correct and b.answer group by b.id_point,b.stamp_from),0) as attempts ');
    form1.ZReadOnlyQuery1.SQL.add(' ,coalesce((select answer_text from av_pdp_log b where b.stamp_from=a.stamp_from and a.id_point=b.id_point ');
    form1.ZReadOnlyQuery1.SQL.add('    and b.stamp_send notnull and a.stamp_send<>b.stamp_send and b.data_exist and b.id_point>0 and not b.correct and b.answer order by b.stamp_send desc limit 1),'''') as lastanswer ');
    form1.ZReadOnlyQuery1.SQL.add('       ,(select stamp_send from av_pdp_log b where b.stamp_from=a.stamp_from and a.id_point=b.id_point ');
    form1.ZReadOnlyQuery1.SQL.add('    and b.stamp_send notnull and a.stamp_send<>b.stamp_send and b.data_exist and b.id_point>0 and not b.correct and b.answer order by b.stamp_send desc limit 1) as lasttime ');
    form1.ZReadOnlyQuery1.SQL.add(' ,a.stamp_send,a.id_point, a.stamp_from, stamp_to, file_send, error_line, error_file, answer_text ,a.remark ');
    form1.ZReadOnlyQuery1.SQL.add(' from av_pdp_log a ');
    form1.ZReadOnlyQuery1.SQL.add('where a.data_exist=true ');
    form1.ZReadOnlyQuery1.SQL.add('and a.file_answer<>'''' ');
    form1.ZReadOnlyQuery1.SQL.add('and a.id_point>0 ');
    form1.ZReadOnlyQuery1.SQL.add('and not a.correct ');
    form1.ZReadOnlyQuery1.SQL.add('--and a.error_main=0 ');
    form1.ZReadOnlyQuery1.SQL.add('and ((a.error_main<>-100006 or a.error_file<>-100006) and coalesce(trim(a.remark),'''')='''') ');
    form1.ZReadOnlyQuery1.SQL.add('and ( ');
      If sett.fixdocs then
    form1.ZReadOnlyQuery1.SQL.add(' (position(''docType'' in a.answer_text)>0 OR position(''документа'' in a.answer_text)>0 OR position(''алфавитов'' in a.answer_text)>0) OR ');
        If sett.fixroute then
    form1.ZReadOnlyQuery1.SQL.add(' position(''маршрут'' in a.answer_text)>0 OR ');
        If sett.fixvse then
    begin
    form1.ZReadOnlyQuery1.SQL.add('((position(''docType'' in a.answer_text)=0 and position(''документа'' in a.answer_text)=0 and position(''алфавитов'' in a.answer_text)=0) ');
    form1.ZReadOnlyQuery1.SQL.add('and position(''маршрут'' in a.answer_text)=0 ');
    form1.ZReadOnlyQuery1.SQL.add('and position(''неактуальной'' in a.answer_text)=0) OR ');
    end;
    form1.ZReadOnlyQuery1.SQL.add('1>1) ');
    form1.ZReadOnlyQuery1.SQL.add(' and a.stamp_from>'+quotedstr(formatdatetime('yyyy-mm-dd hh:nn:ss',time_past)));
    form1.ZReadOnlyQuery1.SQL.add('order by a.stamp_from asc ');
    form1.ZReadOnlyQuery1.SQL.add('limit 500 ');
    form1.ZReadOnlyQuery1.SQL.add(') c ');
    form1.ZReadOnlyQuery1.SQL.add('where ');
    form1.ZReadOnlyQuery1.SQL.add('coalesce((select 1 from av_pdp_log v where v.id_point=c.id_point and v.stamp_from=c.stamp_from and v.correct limit 1),0)<>1 ');
    form1.ZReadOnlyQuery1.SQL.add('and position(''неактуальной'' in c.lastanswer)=0 ');
    form1.ZReadOnlyQuery1.SQL.add('and attempts<4                                       ');
    form1.ZReadOnlyQuery1.SQL.add('order by attempts,stamp_from ');
    form1.ZReadOnlyQuery1.SQL.add('limit 30 ');
    //showmessage(form1.ZReadOnlyQuery1.SQL.text);//$
    //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
   try
     form1.ZReadOnlyQuery1.open;
   except
      Form1.mess_log('--e59--Ошибка запроса по еще НЕ ОТПРАВЛЕННЫМ данным !');
      //Form1.mess_log(form1.ZReadOnlyQuery1.SQL.text);
      form1.ZReadOnlyQuery1.close;
      form1.ZConnection1.disconnect;
      active_process:=false;
      exit;
   end;
   active_process:=false;

   If form1.ZReadOnlyQuery1.RecordCount>0 then
    begin
   for k:=1 to form1.ZReadOnlyQuery1.RecordCount-1 do
    begin
      SetLength(arresend,length(arresend)+1,arlen);
      arresend[length(arresend)-1,0]:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('stamp_from').AsDateTime);
      arresend[length(arresend)-1,1]:=form1.ZReadOnlyQuery1.FieldByName('id_point').AsString;
      arresend[length(arresend)-1,2]:=formatDateTime('dd-mm-yyyy hh:nn:ss',form1.ZReadOnlyQuery1.FieldByName('stamp_to').AsDateTime);
      arresend[length(arresend)-1,3]:=form1.ZReadOnlyQuery1.FieldByName('file_send').AsString;
      arresend[length(arresend)-1,4]:=form1.ZReadOnlyQuery1.FieldByName('error_file').AsString;
      arresend[length(arresend)-1,5]:=form1.ZReadOnlyQuery1.FieldByName('error_line').AsString;
      arresend[length(arresend)-1,6]:=form1.ZReadOnlyQuery1.FieldByName('answer_text').AsString;
      form1.ZReadOnlyQuery1.Next;
     end;
   end;
     form1.ZReadOnlyQuery1.close;
     form1.ZConnection1.disconnect;

   for k:=low(arresend) to high(arresend) do
    begin
     // If (arresend[k,5]='-2002') or (arresend[k,5]='-2004') then
       begin
       //showmessage(FormatDateTime('dd-mm-yyyy hh:nn',stamp_spr_actual)+#13+arresend[k,0]);
        //актуальность действия переданного ранее расписания
        If Sett.fixroute and
          ((stamp_spr_actual>strtodatetime(arresend[k,0],mySettings))
        OR (stamp_spr_actual<IncDay(strtodatetime(arresend[k,0],mySettings),Sett.nsheddays)))
        then
           begin
              form1.DateTimePicker1.DateTime:=IncHour(strtoDateTime(arresend[k,0],mySettings),-2);
              Spr_send('prev');
              result:=true;
              break;
           end;

        //If IncHour(stamp_spr_send)<now() then
          begin
             result:=true;
             Data_Send(arresend[k,0],arresend[k,2],arresend[k,1]);
             time_main:=strtodatetime(arresend[k,0],mySettings);
             break;
          end;
       end;
    end;
   mess_log(formatdatetime('hh:nn:ss.zzz',now())+'======== ПОВТОРНАЯ ОТПРАВКА ДАННЫХ. КОНЕЦ. =======');
end;


// Searching host in all nameservers
//function myhost2ip(host: string): string;
//var
//  dnsy, dns: string;
//  ipaddrs: TstringList;
//  dnsnr: byte;
//  found: boolean;
//const
//  dnsqtype = 1;
//begin
//  dnsnr := 0;
//  found := false;
//  dnsy := GetDNS;
//  ipaddrs := TstringList.Create;
//  // Searching host in all nameservers
//  repeat
//    inc(dnsnr);
//    ipaddrs.Clear;
//    // Searching host in one nameserver
//    dns := myGetnArg(dnsy, dnsnr, ',');
//    if dns = '' then
//      break;
//    with TDNSSend.Create do
//    try
//      TargetHost := dns;
//      found := DNSQuery(host, dnsqtype, ipaddrs);
//    finally
//      Free;
//    end;
//    // Break if find;
//    if found = true then
//      break;
//  until false;
//  // Return host
//  if found = true then
//    Result := ipaddrs[0];
//end;

//procedure TForm1.ButtonGetFileClick(Sender: TObject);
//  var
//  ip: string;
  //ftp: TFTPSend;
//begin
//  ProgressBar1.Position := 0;
//  MemoLog.Clear;
//  MemoLog.Lines.Add('Loking up:     ' + EditFtpServer.Text + '...');
//
//  ip := myhost2ip(EditFtpServer.Text);
//  if ip <> '' then
//    MemoLog.lines.Add('Connecting:     ' + ip + ':' + EditPort.Text + '...')
//  else
//  begin
//    MemoLog.Lines.Add('Cannot find:' + '  ' + EditFtpServer.text);
//    exit;
//  end;
//
//  ftp := TFTPSend.Create;
//  try
//    //ftp.DSock.OnStatus := SockGetCallBack; // Update ProgressBar1
//    ftp.Username := EditUser.text;
//    ftp.Password := EditPassw.text;
//    ftp.TargetHost := EditFtpServer.text;
//    ftp.TargetPort := EditPort.text;
//
//    if ftp.Login then
//      MemoLog.Lines.Add('Login:           success')
//    else
//    begin
//      MemoLog.Lines.Add('Login:           incorrect');
//      exit;
//    end;
//
//    ftp.DirectFileName := EditLocalFile.Text;
//    ftp.DirectFile := true;
//    TotalBytes := ftp.FileSize(EditRemoteFile.Text);
//
//    MemoLog.Lines.Add('Load file:  ' + EditRemoteFile.Text);
//    MemoLog.Lines.Add('TotalBytes: ' + IntToStr(TotalBytes));
//
//    if ftp.RetrieveFile(EditRemoteFile.Text, false) = true then
//      MemoLog.Lines.Add('Transfer completed')
//    else
//      MemoLog.lines.add('Transfer failed');
//
//    ftp.Logout;
//    MemoLog.Lines.Add('Connection closed');
//  finally
//    ftp.Free;
//  end;
//end;

//procedure TForm1.ButtonPutFileClick(Sender: TObject);
//var
//  ip: string;
//  ftp: TFTPSend;
//  f: file of Byte;
//begin
//  ProgressBar1.Position := 0;
//  MemoLog.Clear;
//  MemoLog.Lines.Add('Loking up:     ' + EditFtpServer.Text + '...');
//
//  ip := myhost2ip(EditFtpServer.Text);
//  if ip <> '' then
//    MemoLog.lines.Add('Connecting:     ' + ip + ':' + EditPort.Text + '...')
//  else
//  begin
//    MemoLog.Lines.Add('Cannot find:' + '  ' + EditFtpServer.text);
//    exit;
//  end;
//
//  AssignFile(f, EditLocalFile.Text);
//  Reset(f);
//  //try
//    //TotalBytes := FileSize(f);
//  //finally
//    //CloseFile(f);
//  //end;
//
//  ftp := TFTPSend.Create;
//  try
//    //ftp.DSock.OnStatus := SockPutCallBack; // Update ProgressBar1
//    ftp.Username := EditUser.text;
//    ftp.Password := EditPassw.text;
//    ftp.TargetHost := EditFtpServer.text;
//    ftp.TargetPort := EditPort.text;
//
//    if ftp.Login then
//      MemoLog.Lines.Add('Login:           success')
//    else
//    begin
//      MemoLog.Lines.Add('Login:           incorrect');
//      exit;
//    end;
//
//    // Delete old file, before sending new
//    ftp.FTPCommand('DELE ' + EditRemoteFile.Text);
//    ftp.DirectFileName := EditLocalFile.Text;
//    ftp.DirectFile := true;
//
//    MemoLog.Lines.Add('Sending file:   ' + EditLocalFile.Text);
//    MemoLog.Lines.Add('TotalBytes:   ' + IntToStr(TotalBytes));
//
//    if ftp.StoreFile(EditRemoteFile.Text, false) = true then
//      MemoLog.Lines.Add('Transfer completed')
//    else
//      MemoLog.lines.add('Transfer failed');
//
//    ftp.Logout;
//    MemoLog.Lines.Add('Connection closed');
//  finally
//    ftp.Free;
//  end;
//end;

//procedure TForm1.SockPutCallBack(Sender: TObject;
//  Reason: THookSocketReason; const Value: string);
//begin
//  case Reason of
//    HR_WriteCount:
//      begin
//        inc(CurrentBytes, StrToIntDef(Value, 0));
//        form1.ProgressBar.Position := Round(1000 * (CurrentBytes / TotalBytes));
//      end;
//    HR_Connect: CurrentBytes := 0;
//  end;
//end;

//procedure TForm1.SockGetCallBack(Sender: TObject;
//  Reason: THookSocketReason; const Value: string);
//// var  v: string;
//begin
//  case Reason of
//    HR_ReadCount:
//      begin
//        inc(CurrentBytes, StrToIntDef(Value, 0));
//        form1.ProgressBar.Position := Round(1000 * (CurrentBytes / TotalBytes));
//      end;
//    HR_Connect: CurrentBytes := 0;
//
//  end;
//end;


end.

