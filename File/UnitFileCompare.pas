{ Copyright (c) <2015> <ozok26@gmail.com>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE. }

unit UnitFileCompare;

interface

uses
  Classes, SysUtils, Windows, IOUtils, DateUtils, IdHashMessageDigest, idHash,
  ComCtrls, JclFileUtils;

type
  TFileComperator = class
  private
    function StreamsAreIdentical(const FileStream1, FileStream2: TStream; const BlockSize: Integer): Boolean;
    function CompareLastModifiedDate(const FilePath1: string; const FilePath2: string): Boolean;
    function CompareMD5(const FileStream1, FileStream2: TStream): Boolean;
    function CalculateMD5(const FS: TStream): string;
    function GetFileLastModDate(FileName: string): TDateTime;
    function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
  public
    Stop: Boolean;
    function CompareFiles(const FileName1, FileName2: string; const BlockSize: Integer; const CompareMethod: integer; var Reason: string): Boolean;
  end;

implementation

uses
  UnitMainForm;

{ TFileComperator }

function TFileComperator.CalculateMD5(const FS: TStream): string;
var
  LMD5: TIdHashMessageDigest5;
begin
  LMD5 := TIdHashMessageDigest5.Create;
  try
    Result := LMD5.HashStreamAsHex(FS);
  finally
    LMD5.Free;
  end;
end;

function TFileComperator.CompareFiles(const FileName1, FileName2: string; const BlockSize: Integer; const CompareMethod: integer; var Reason: string): Boolean;
var
  LFS1, LFS2: TFileStream;
begin
  Result := False;
  Stop := False;
  if not (FileExists(FileName1) and FileExists(FileName2)) then
  begin
    Reason := 'Destination file doesn''t exist';
    Exit;
  end;

  try
    // last modified date comparison does not require files to be opened
    if CompareMethod <> 3 then
    begin
      LFS1 := TFileStream.Create(FileName1, fmOpenRead or fmShareDenyWrite);
      LFS2 := TFileStream.Create(FileName2, fmOpenRead or fmShareDenyWrite);
      LFS1.Seek(0, soBeginning);
      LFS2.Seek(0, soBeginning);
    end;
    case CompareMethod of
      0:
        begin
          Reason := 'Files are different';
          Result := StreamsAreIdentical(LFS1, LFS2, BlockSize);
        end;
      1:
        begin
          Reason := 'MD5 hashes are different';
          Result := CompareMD5(LFS1, LFS2);
        end;
      2:
        begin
          Reason := 'Different file sizes';
          Result := LFS1.Size = LFS2.Size;
        end;
      3:
        begin
          Result := CompareLastModifiedDate(FileName1, FileName2);
          Reason := 'Last modified dates are different';
        end;
    end;
    if Result then
    begin
      Reason := '';
    end;
  finally
    try
      if Assigned(LFS1) then
      begin
        LFS1.Free;
      end;
      if Assigned(LFS2) then
      begin
        LFS2.Free;
      end;
    except
      on E: Exception do


    end;
  end;
end;

function TFileComperator.CompareMD5(const FileStream1, FileStream2: TStream): Boolean;
var
  LHashStr1, LHashStr2: string;
begin
  LHashStr1 := CalculateMD5(FileStream1);
  LHashStr2 := CalculateMD5(FileStream2);
  Result := LHashStr1 = LHashStr2;
end;

function TFileComperator.FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  ModifiedTime: TFileTime;
  SystemTime: TSystemTime;
begin
  Result := 0;
  if (FileTime.dwLowDateTime = 0) and (FileTime.dwHighDateTime = 0) then
    Exit;
  try
    FileTimeToLocalFileTime(FileTime, ModifiedTime);
    FileTimeToSystemTime(ModifiedTime, SystemTime);
    Result := SystemTimeToDateTime(SystemTime);
  except
    Result := Now;
  end;
end;

function TFileComperator.CompareLastModifiedDate(const FilePath1, FilePath2: string): Boolean;
begin
  Result := GetFileLastModDate(FilePath1) = GetFileLastModDate(FilePath2);
end;

function TFileComperator.GetFileLastModDate(FileName: string): TDateTime;
begin
  Result := FileTimeToDateTime(GetFileLastWrite(FileName));
end;

function TFileComperator.StreamsAreIdentical(const FileStream1, FileStream2: TStream; const BlockSize: Integer): Boolean;
var
  LBuffer1: array of byte;
  LBuffer2: array of byte;
  LBuffer1Readed, LBuffer2Readed, LBlockSize: integer;
  LMemStream1, LMemStream2: TMemoryStream;
begin
  Result := False;
  if FileStream1.Size <> FileStream2.Size then
  begin
    Exit;
  end;

  FileStream1.Position := 0;
  FileStream2.Position := 0;

  if BlockSize > 0 then
  begin
    LBlockSize := BlockSize
  end
  else
  begin
    LBlockSize := 4096;
  end;

  SetLength(LBuffer1, LBlockSize);
  SetLength(LBuffer2, LBlockSize);

  if (LBlockSize >= FileStream1.Size) and (LBlockSize >= FileStream2.Size) then
  begin
    LMemStream1 := TMemoryStream.Create;
    LMemStream2 := TMemoryStream.Create;
    try
      LMemStream1.LoadFromStream(FileStream1);
      LMemStream2.LoadFromStream(FileStream2);
      Result := CompareMem(LMemStream1.Memory, LMemStream2.Memory, FileStream1.Size);
      Exit;
    finally
      LMemStream1.Free;
      LMemStream2.Free;
    end;
  end;


  LBuffer1Readed := 1; // just for entering while

  while (LBuffer1Readed > 0) and (FileStream1.Position < FileStream1.Size) do
  begin
    if Stop then
    begin
      Break;
    end;
    LBuffer1Readed := FileStream1.Read(LBuffer1[0], LBlockSize);
    LBuffer2Readed := FileStream2.Read(LBuffer2[0], LBlockSize);

    if (LBuffer1Readed <> LBuffer2Readed) or ((LBuffer1Readed <> LBlockSize) and (FileStream1.Position < FileStream1.Size)) then
      Exit;

    if not CompareMem(@LBuffer1[0], @LBuffer2[0], LBuffer1Readed) then
      Exit;
  end; // while

  Result := True;
end;

end.

