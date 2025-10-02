unit typmath;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { xy_t }

  xy_t = packed object
    x,y: double;
  end;

  { xyz_t }

  xyz_t = packed object
    x,y,z: double;
  end;

  { vert_t }

  vert_t = record
    x,y,z,nx,ny,nz,u,v: single;
    // Don't add fields here lest it breaks JTF mapping.
  end;

  { face_t }

  face_t = record
    a,b,c: vert_t; // Tri
  end;
  face_a = array of face_t;

  function xyz(ax, ay, az: double): xyz_t;
implementation

function xyz(ax, ay, az: double): xyz_t;
begin
  with result do begin
    x:=ax;
    y:=ay;
    z:=az;
  end;
end;

end.

