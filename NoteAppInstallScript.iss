; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
#define ApplicationName 'Application Name'
#define ApplicationVersion GetFileVersion('NoteApp.exe')


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{56173605-727C-4C0D-867F-954D7AC0DCF8}
AppName={#ApplicationName}
AppVerName={#ApplicationName} {#ApplicationVersion}
VersionInfoVersion={#ApplicationVersion}
;AppVerName=NoteApp 1.0
AppPublisher=Toxa, Inc.
DefaultDirName={pf}\NoteApp
DefaultGroupName=NoteApp
AllowNoIcons=yes
OutputBaseFilename=setup
SetupIconFile=G:\Download Games\FIFA.14.Multi13-RU.Repack.by.z10yded\Icon.ico
Compression=lzma
SolidCompression=yes

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "L:\Personal .NET\NoteApp\NoteApp\NoteApp\bin\Debug\NoteApp.exe"; DestDir: "{app}"; Flags: ignoreversion

Source: "L:\Personal .NET\NoteApp\NoteApp\NoteApp\bin\Debug\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\NoteApp"; Filename: "{app}\NoteApp.exe"
Name: "{commondesktop}\NoteApp"; Filename: "{app}\NoteApp.exe"; Tasks: desktopicon

;------------------------------------------------------------------------------
;   ������ ���� ���������� �� ���������� �����
;------------------------------------------------------------------------------
[Code]



function GetUninstallString: string;
var
  sUnInstPath: string;
  sUnInstallString: String;
begin
  Result := '';
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{{56173605-727C-4C0D-867F-954D7AC0DCF8}_is1'); //Your App GUID/ID
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade: Boolean;
begin
  Result := (GetUninstallString() <> '');
end;






const
  MinNetFrameWork = 'v2.0'; // ����������� ������ NetFrameWork
  // ��������� ������ = 'v1.0', 'v1.1', 'v2.0', 'v3.0', 'v3.5', 'v4.0'

var
  url: string;

procedure GetUrlNetFrameWork(ver: string);
begin
  // �������� �������� http://www.microsoft.com/downloads/results.aspx?pocId=&freetext=Framework&DisplayLang=ru
  case ver of
    // �� ���� ������ v1.1, �.�. ������ �� v1.0, � �� �����... �������... ;)
    'v1.0': url := 'http://download.microsoft.com/download/0/8/6/086e7824-ddad-45c0-b765-721e5e28e4c5/dotnetfx.exe';
    'v1.1': url := 'http://download.microsoft.com/download/0/8/6/086e7824-ddad-45c0-b765-721e5e28e4c5/dotnetfx.exe';
    'v2.0': url := 'http://download.microsoft.com/download/5/6/7/567758a3-759e-473e-bf8f-52154438565a/dotnetfx.exe';
    'v3.0': url := 'http://download.microsoft.com/download/4/d/a/4da3a5fa-ee6a-42b8-8bfa-ea5c4a458a7d/dotnetfx3setup.exe';
    'v3.5': url := 'http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe';
    'v4.0': url := 'http://download.microsoft.com/download/1/B/E/1BE39E79-7E39-46A3-96FF-047F95396215/dotNetFx40_Full_setup.exe';
  else
    url := 'http://download.microsoft.com/download/5/6/7/567758a3-759e-473e-bf8f-52154438565a/dotnetfx.exe';
  end;
end;

function CompareMinVer(const ver: string): Boolean;
var
  min_ver: string;
begin
  Result := False;
  min_ver := MinNetFrameWork;
  if (Length(min_ver) > 2) and (Length(ver) > 2) then
    if (min_ver[2] > #47) and (min_ver[2] < #58) and (ver[2] > #47) and (ver[2] < #58) then
      Result := ver[2] > min_ver[2];
end;

function DetectInstallNetFrameWork: Boolean;
var
  VerNetFrameWorkInstalled: TArrayOfString;
  i: Integer;
begin
  Result := False;
  if RegGetSubkeyNames(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP', VerNetFrameWorkInstalled) then
    case CompareMinVer(VerNetFrameWorkInstalled[0]) of
      True : Result := True;
      False:
        for i := 0 to GetArrayLength(VerNetFrameWorkInstalled)-1 do
          if Pos(MinNetFrameWork, VerNetFrameWorkInstalled[i]) > 0 then
            begin
              Result := True;
              Break;
            end;
    end;
end;

function SearchNetFrameWork: Boolean;
var
  ErrorCode: Integer;
begin
  Result := DetectInstallNetFrameWork;
  if not Result then
    if MsgBox('��� ���� ��������� ��������� ������������� .NET Framework �� ���� ' + MinNetFrameWork + '. ' +
              '���������� ��������� � ���������� .NET Framework � ��������� ��������� �����. ' +
              '�� ������ ��������� .NET Framework ������?', mbConfirmation, MB_YESNO) = idYes then
      begin
        GetUrlNetFrameWork(MinNetFrameWork);
        ShellExec('open', url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
      end;
end;

function InitializeSetup: Boolean;
var
  V: Integer;
  iResultCode: Integer;
  sUnInstallString: string;
begin
  Result := True; // in case when no previous version is found
  if RegValueExists(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Uninstall\{56173605-727C-4C0D-867F-954D7AC0DCF8}_is1', 'UninstallString') then  //Your App GUID/ID
  begin
    V := MsgBox(ExpandConstant('Hey! An old version of app was detected. Do you want to uninstall it?'), mbInformation, MB_YESNO); //Custom Message if App installed
    if V = IDYES then
    begin
      sUnInstallString := GetUninstallString();
      sUnInstallString :=  RemoveQuotes(sUnInstallString);
      Exec(ExpandConstant(sUnInstallString), '', '', SW_SHOW, ewWaitUntilTerminated, iResultCode);
      Result := True;
      Result := SearchNetFrameWork;
//if you want to proceed after uninstall
                //Exit; //if you want to quit after uninstall
    end
    else
      Result := False; //when older version present and not uninstalled
  end;
 
end;




[Run]
;------------------------------------------------------------------------------
;   ������ ������� ����� �����������
;------------------------------------------------------------------------------

Filename: "{app}\NoteApp.exe"; Description: "{cm:LaunchProgram,NoteApp}"; Flags: nowait postinstall skipifsilent
