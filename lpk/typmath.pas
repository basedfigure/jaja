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
    procedure add (const v: xyz_t);
    procedure sub (const v: xyz_t);
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

{ mat4_t }

procedure mat4_t.identity;
begin
  sx:=1; sy:=0; sz:=0; ux:=0; uy:=1; uz:=0; fx:=0; fy:=0; fz:=1;
  tx:=0; ty:=0; tz:=0; px:=0; py:=0; pz:=0; w:=1;
end;

end.

