unit fmtmod;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,
  // Juju:
  typutil,
  // Jaja:
  typmath;

type

  { mod_t }

  mod_t = record
    fa: face_a;
  end;
  mod_a  = array of mod_t;

  function load_jtf_files_from_dsk(lpath: TStrings): mod_a;
implementation

function load_jtf_files_from_dsk(lpath: TStrings): mod_a;
var
  fs: TFileStream;
  i,j: int;
  m: mod_t;
begin
  // Original, export script for Blender at: http://runtimeterror.com/tech/jtf/
  // Blender compatibles at: io/link.txt

  // Mem OBJ to JTF converter
  SetLength(result, lpath.Count);

  for i:=0 to lpath.Count-1 do begin
    fs:=nil;
    try
      fs:=TFileStream.Create(lpath[i], fmOpenRead);
      if (fs.ReadByte <> 74) or
         (fs.ReadByte <> 84) or
         (fs.ReadByte <> 70) or
         (fs.ReadByte <> 33) then

         raise Exception.Create('Invalid file format');

      if fs.ReadDWord <> 0 then
        raise Exception.Create('Unknown vertex format');

      SetLength(m.fa, fs.ReadDWord);

      for j:=0 to High(m.fa) do fs.Read(m.fa[j], SizeOf(face_t));

      result[i]:=m;
    except
      on e: Exception do ShowMessage('Error loading ' + lpath[i] + ': ' +
        e.Message);
    end;

    FreeAndNil(fs);
  end;
end;

end.

