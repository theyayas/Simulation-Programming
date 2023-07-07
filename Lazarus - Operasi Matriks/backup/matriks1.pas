unit matriks1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList,
  StdCtrls, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LANJUT: TButton;
    Dimensi: TLabel;
    TAMBAH: TButton;
    KURANG: TButton;
    KALI: TButton;
    Operasi: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    A: TLabel;
    B: TLabel;
    C: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure KALIClick(Sender: TObject);
    procedure KURANGClick(Sender: TObject);
    procedure LANJUTClick(Sender: TObject);
    procedure TAMBAHClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.LANJUTClick(Sender: TObject);

  var baris, kolom:integer;
begin
  baris := strtointdef (edit1.text,0);
  kolom := strtointdef (edit2.text,0);

  stringgrid1.rowcount := baris;
  stringgrid1.colcount := kolom;
end;

procedure TForm1.Button1Click(Sender: TObject);
  var baris, kolom:integer;
begin
  baris := strtointdef (edit3.text,0);
  kolom := strtointdef (edit4.text,0);

  stringgrid2.rowcount := baris;
  stringgrid2.colcount := kolom;
end;

procedure TForm1.TAMBAHClick(Sender: TObject);
   var baris, kolom,x,y,z :integer;
begin
  for baris := 1 to stringgrid1.rowcount do
  for kolom := 1 to stringgrid1.colcount do
  begin
    x := strtointdef  ( stringgrid1.Cells[kolom-1, baris-1],0);
    y := strtointdef  ( stringgrid2.Cells[kolom-1, baris-1],0);
    z := x + y;
    stringgrid3.Cells[kolom-1,baris-1]:= inttostr(z);
  end;
end;

procedure TForm1.KALIClick(Sender: TObject);
   var h,i,j,k,l,m,n,o : integer;
   begin
   l := strtoint (edit1.Text);
   m := strtoint (edit2.Text);
   n := strtoint (edit3.Text);
   o := strtoint (edit4.Text);
   stringgrid1.rowCount := l;
   stringgrid1.colCount := m;
   stringgrid2.rowCount := n;
   stringgrid2.colCount := o;
   if m=n then k:=n;
   for i:= 0 to n-1 do
   for j := 0 to l-1 do
   begin
   h:= 0;
   for k := 0 to m-1 do
   h:= h + strtoint (stringgrid1.Cells[k,i])*strtoint(stringgrid2.Cells[j,k]);
   stringgrid3.Cells[j,i]:= inttostr (h);
   end;
   end;



procedure TForm1.KURANGClick(Sender: TObject);
   var baris, kolom,x,y,z :integer;
begin
     for baris := 1 to stringgrid1.rowcount do
     for kolom := 1 to stringgrid1.colcount do
     begin
       x := strtointdef  ( stringgrid1.Cells[kolom-1, baris-1],0);
       y := strtointdef  ( stringgrid2.Cells[kolom-1, baris-1],0);
       z := x - y;
       stringgrid3.Cells[kolom-1,baris-1]:= inttostr(z);
     end;
end;

end.

