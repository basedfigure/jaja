unit fmt2d;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, IntfGraphics, LCLIntf, LCLType, OpenGLContext,
  { Beware: OpenGL, utils, don't change the order: } glu, gl, GLext,
  // Juju
  typutil;

type

  { tex_2d_t }

  tex_2d_t = object
    id: GLuint;
    wid, hei: int;
    bm: TBitmap;
    pix:  PGLubyte;
    procedure load_file_from_disk(const path: str; in_bgra_order: bool);
    procedure init_gl(var contxt: TOpenGLControl);
  end;

implementation

{ tex_2d_t }

procedure tex_2d_t.load_file_from_disk(const path: str; in_bgra_order: bool);
var
  w, h, i, j: int;
  pic: TPicture;
  img: TLazIntfImage;
  p: PByte;
begin
  pic:=TPicture.Create;
  try
    pic.LoadFromFile(path);
    img:=pic.Bitmap.CreateIntfImage;
      w:=img.Width;
      h:=img.Height;
    pix:=GetMem(w * h * 4);
    p:=pix;
    for i:=0 to h-1 do
      for j:=0 to w-1 do begin
        with img.Colors[j,i] do begin
          if in_bgra_order = false then begin
            { RGBA }
            p^:=red;   inc(p);
            p^:=green; inc(p);
            p^:=blue;  inc(p);
            p^:=alpha; inc(p);
          end else begin
            { BGRA }
            p^:=blue;  inc(p);
            p^:=green; inc(p);
            p^:=red;   inc(p);
            p^:=alpha; inc(p);
          end;
        end;
      end;
    wid:=w;
    hei:=h;
    bm:=TBitmap.Create;
    bm.PixelFormat:=pf32bit;
    bm.SetSize(wid, hei);
    Move(pix^, bm.RawImage.Data^, wid * hei * 4);
  finally
    img.Free;
    pic.Free;
  end;
end;

procedure tex_2d_t.init_gl(var contxt: TOpenGLControl);
begin
  contxt.MakeCurrent();
  glGenTextures(1, @id);
  glBindTexture(  GL_TEXTURE_2D, id);
  glTexParameteri(GL_TEXTURE_2D,    GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,    GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,    GL_TEXTURE_WRAP_S,     GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D,    GL_TEXTURE_WRAP_T,     GL_REPEAT);
  glTexImage2D(   GL_TEXTURE_2D, 0, GL_RGBA, wid, hei, 0,  GL_BGRA,
                  GL_UNSIGNED_BYTE, pix);
  contxt.ReleaseContext();
end;

end.

