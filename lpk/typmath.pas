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
    { Proc }
    procedure add   (const v: xyz_t);
    procedure sub   (const v: xyz_t);
    procedure mul   (const v: xyz_t);
    procedure sca   (s: single);
    procedure norm;
    procedure cross (const v: xyz_t);
    { Func }
    function dot    (const v: xyz_t): single;
  end;

  { vert_t }

  vert_t = record
    x,y,z,nx,ny,nz,u,v: single;
    // Don't add fields here, lest it breaks JTF mapping.
  end;

  { face_t }

  face_t = record
    a,b,c: vert_t; // Tri
  end;
  face_a = array of face_t;

  { mat4_t }

  mat4_t = packed object
    {axes}sx,sy,sz,ux,uy,uz,fx,fy,fz,{trans - proj}tx,ty,tz,px,py,pz,w: double;
    procedure identity;
  end;

  function xyz (ax, ay, az: double): xyz_t;
implementation

function xyz (ax, ay, az: double): xyz_t;
begin
  with result do begin
    x:=ax;
    y:=ay;
    z:=az;
  end;
end;

{ xyz_t }

procedure xyz_t.add (const v: xyz_t);
begin
  x:=x + v.x;
  y:=y + v.y;
  z:=z + v.z;
end;

procedure xyz_t.sub (const v: xyz_t);
begin
  x:=x - v.x;
  y:=y - v.y;
  z:=z - v.z;
end;

procedure xyz_t.mul (const v: xyz_t);
begin
  x:=x * v.x;
  y:=y * v.y;
  z:=z * v.z;
end;

procedure xyz_t.sca (s: single);
begin
  x:=x * s;
  y:=y * s;
  z:=z * s;
end;

procedure xyz_t.norm;
var
  l: double;
begin
  l:=Sqrt(x * x + y * y + z * z);
  if l <> 0 then begin
    x:=x / l;
    y:=y / l;
    z:=z / l;
  end;
end;

procedure xyz_t.cross (const v: xyz_t);
var
  t: xyz_t;
begin
  t.x:=y * v.z - z * v.y;
  t.y:=z * v.x - x * v.z;
  t.z:=x * v.y - y * v.x;
    x:=t.x;
    y:=t.y;
    z:=t.z;
end;

function xyz_t.dot (const v: xyz_t): single;
begin
  result:=x * v.x + y * v.y + z * v.z;
end;

{ mat4_t }

procedure mat4_t.identity;
begin
  { axes } sx:=1; sy:=0; sz:=0; ux:=0; uy:=1; uz:=0; fx:=0; fy:=0; fz:=1;
  { trans - proj } tx:=0; ty:=0; tz:=0; px:=0; py:=0; pz:=0; w:=1;
end;

end.

