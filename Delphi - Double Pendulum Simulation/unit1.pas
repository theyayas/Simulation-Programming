unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  TAGraph, TASeries, TAMultiSeries, math;

type

  { TForm1 }
  arraysaya = array[0..1000000] of double;
  matrix = array[0..1,0..1] of extended;
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart2: TChart;
    Chart2LineSeries1: TLineSeries;
    Chart3: TChart;
    Chart3LineSeries1: TLineSeries;
    Chart4: TChart;
    Chart4LineSeries1: TLineSeries;
    Chart5: TChart;
    Chart5LineSeries1: TLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Timer1: TTimer;

    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    function matriks(tet1, tet2, tetdot1, tetdot2 : extended): matrix;
    function plot(var1, var2 : extended): extended;
    function DFT(sinyal : arraysaya; range : integer): arraysaya;
    procedure RungeKutta();
    procedure Button1Click(Sender: TObject);
    //procedure Edit4Change(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
    //procedure GroupBox1Click(Sender: TObject);
    //procedure ListBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  m1, m2, l1, l2, iterasi : integer;
  mbesar, transm, invm, cbesar, invm_tau, coba, b : matrix;
  tet1, tet2, i1, i2, g, dt, tetdot1, tetdot2, detm, tetdotdot1, tetdotdot2, h : extended;
  x1, y1, x2, y2 : array[0..2] of extended;
  gbesar, coba2, tetdot, tau, tetdotdot, cbesar_tetdot, tetdotdotfinal : array[0..1] of extended;
  ftet1, fourier : arraysaya;
  //: array[0..3, 0..3] of extended;


  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Chart1Lineseries1.Clear;
  Chart1Lineseries2.Clear;
  Chart1Lineseries3.Clear;
  Chart1Lineseries4.Clear;
  Chart2Lineseries1.Clear;
  Chart3Lineseries1.Clear;
  Chart4Lineseries1.Clear;
  Chart5Lineseries1.Clear;

  if button1.Caption='Run' then
  begin
    button1.Caption:='Stop';
    m1 := strtoint(edit2.Text);
    m2 := strtoint(edit5.Text);
    l1 := strtoint(edit1.Text);
    l2 := strtoint(edit4.Text);
    tet1 := strtoint(edit3.Text)*pi/180;
    tet2 := strtoint(edit6.Text)*pi/180;
    i1 := m1*l1*l1;
    i2 := m2*l2*l2;

    g := 9.80665;
    dt := 0.05;
    iterasi := 0;

    tetdot1 := 0;
    tetdot2 := 0;

    timer1.Enabled := true;
  end
  else if button1.Caption='Stop' then
  begin
    button1.Caption := 'Run';
    timer1.Enabled := false;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  application.terminate;
end;

function TForm1.matriks(tet1, tet2, tetdot1, tetdot2: extended): matrix;
var
  I, J : integer;
begin
  {mbesar[0,0] := (m1/4 + m2)*l1*l1 + i1;        mbesar[1,0] := (1/2)*m2*l1*l2*cos(tet1-tet2);
  mbesar[0,1] := (1/2)*m2*l1*l2*cos(tet1-tet2); mbesar[1,1] := (1/4)*m2*l2*l2+i2;
  }
  detm := ((m1/4 + m2)*l1*l1 + i1)*((1/4)*m2*l2*l2+i2) - power((1/2)*m2*l1*l2*cos(tet1-tet2),2);

  transm[0,0] := (1/4)*m2*l2*l2+i2;                 transm[1,0] := -((1/2)*m2*l1*l2*cos(tet1-tet2));
  transm[0,1] := -((1/2)*m2*l1*l2*cos(tet1-tet2));  transm[1,1] := (m1/4 + m2)*l1*l1 + i1;

  for I := 0 to 1 do
  begin
    for J := 0 to 1 do
    begin
    invm[i,j] := transm[i,j]/detm;
    end;
  end;

  tau[0] := 0;
  tau[1] := 0;

  cbesar[0,0] := (1/2)*m2*l1*l2*sin(tet1-tet2)*tetdot2;             cbesar[1,0] := (-1/2)*m2*l1*l2*sin(tet1-tet2)*(tetdot1-tetdot2);
  cbesar[0,1] := (-1/2)*m2*l1*l2*sin(tet1-tet2)*(tetdot1-tetdot2);  cbesar[1,1] := (-1/2)*m2*l1*l2*tetdot1*sin(tet1-tet2);

  tetdot[0] := tetdot1;
  tetdot[1] := tetdot2;

  for i:= 0 to 1 do
  begin
      h := 0;
      for j:= 0 to 1 do
      begin
        h := h + cbesar[i,j]*tetdot[j];
      end;
      cbesar_tetdot[i] := h; //i
  end;

  gbesar[0] := ((1/2)*m1+m2)*g*l1*sin(tet1);
  gbesar[1] := (1/2)*m2*g*l2*sin(tet2);

  tetdotdot[0] := tau[0] - gbesar[0] - cbesar_tetdot[0];
  tetdotdot[1] := tau[1] - gbesar[1] - cbesar_tetdot[1];

  for i:= 0 to 1 do
  begin
      h := 0;
      for j:= 0 to 1 do
      begin
        h := h + invm[i,j]*tetdotdot[j];
      end;
      tetdotdotfinal[i] := h; //i
  end;

  tetdotdot1 := tetdotdotfinal[0];
  tetdotdot2 := tetdotdotfinal[1];
end;

procedure TForm1.RungeKutta();
var
k1, k2, k11, k12, k21, k22, k31, k32, k41, k42: extended;
begin
matriks(tet1, tet2, tetdot1, tetdot2);
k11 := dt/2*tetdotdot1;
k12 := dt/2*tetdotdot2;

k1 := dt/2*(tetdot1+k11/2);
k2 := dt/2*(tetdot2+k12/2);

matriks(tet1+k1, tet2+k2, tetdot1+k11, tetdot1+k12);
k21 := dt/2*tetdotdot1;
k22 := dt/2*tetdotdot2;

matriks(tet1+k1, tet2+k2, tetdot1+k21, tetdot1+k22);
k31 := dt/2*tetdotdot1;
k32 := dt/2*tetdotdot2;

matriks(tet1+(dt*(tetdot1+k31)), tet2+(dt*(tetdot2+k32)), tetdot1+2*k31, tetdot2+2*k32);
k41 := dt/2*tetdotdot1;
k42 := dt/2*tetdotdot2;

tet1 := tet1 + dt*(tetdot1+(k11+k21+k31)/3);
tet2 := tet2 + dt*(tetdot2+(k12+k22+k32)/3);

tetdot1 := tetdot1+(k11+2*k21+2*k31+k41)/3;
tetdot2 := tetdot2+(k12+2*k22+2*k32+k42)/3;

plot(tet1, tet2);
end;

function TForm1.plot(var1, var2: extended): extended;
var
I : integer;
begin
x1[0] := 0;
y1[0] := 0;
x2[0] := l1*sin(var1);
y2[0] := -l1*cos(var1);

x1[1] := l1*sin(var1);
y1[1] := -l1*cos(var1);
x2[1] := l1*sin(var1) + l2*sin(var2);
y2[1] := -(l1*cos(var1) + l2*cos(var2));

Chart1Lineseries1.Clear;
Chart1Lineseries2.Clear;
for I := 0 to 1 do
begin
  Chart1Lineseries1.AddXY(x1[i], y1[i]);
  Chart1Lineseries2.AddXY(x2[i], y2[i]);
end;

Chart1Lineseries3.AddXY(x2[0], y2[0]);
Chart1Lineseries4.AddXY(x2[1], y2[1]);

Chart2Lineseries1.AddXY(iterasi,tet1);
Chart3Lineseries1.AddXY(iterasi,tet2);

Chart4Lineseries1.AddXY(tet1,tetdot1);
Chart5Lineseries1.AddXY(tet1,tetdot2);

{ftet1[iterasi] := tet1;
DFT(ftet1, iterasi);
for i := 0 to round((iterasi-1)/2) do
begin
  chart6barseries1.AddXY(i, fourier[i]);
end;}


Edit7.Text := floattostr(roundto(tet1*180/pi,-2));
Edit8.Text := floattostr(roundto(tet2*180/pi,-2));
Edit9.Text := floattostr(roundto(tetdot1,-2));
Edit10.Text := floattostr(roundto(tetdot2,-2));
Edit11.Text := floattostr(iterasi);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
RungeKutta();
iterasi := iterasi + 1;
end;


function Tform1.DFT(sinyal : arraysaya; range : integer): arraysaya;
var
  Real, Imaginer : arraysaya;
  i, j : integer;
begin
  {for i := 0 to round((range-1)/2) do
  begin
    Real[i] :=0;
    Imaginer[i] :=0;
    for j := 0 to range-1 do
    begin
         Real[i] := Real[i] + sinyal[j]*cos(2*pi*i*j/range);
         Imaginer[i] := Imaginer[i] - sinyal[j]*sin(2*pi*i*j/range);
    end;
    fourier[i] := sqrt(sqr(Real[i]) + sqr(Imaginer[i]));
    DFT := fourier;
  end;}
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if Checkbox1.Checked = true then
  begin
    Chart1Lineseries2.ShowLines := true;
    Chart1Lineseries2.ShowPoints := true;

    Chart1Lineseries4.ShowLines := true;
    Checkbox3.Checked := true;
  end
  else if Checkbox1.Checked = false then
  begin
    Chart1Lineseries2.ShowLines := false;
    Chart1Lineseries2.ShowPoints := false;

    Chart1Lineseries4.ShowLines := false;
    Checkbox3.Checked := false;
  end;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  if Checkbox2.Checked = true then
  begin
    Chart1Lineseries1.ShowLines := true;
    Chart1Lineseries1.ShowPoints := true;

    Chart1Lineseries3.ShowLines := true;
    Checkbox4.Checked := true;
  end
  else if Checkbox2.Checked = false then
  begin
    Chart1Lineseries1.ShowLines := false;
    Chart1Lineseries1.ShowPoints := false;

    Chart1Lineseries3.ShowLines := false;
    Checkbox4.Checked := false;
  end;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if Checkbox3.Checked = true then
  begin
    Chart1Lineseries4.ShowLines := true;
  end
  else if Checkbox3.Checked = false then
  begin
    Chart1Lineseries4.ShowLines := false;
  end;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  if Checkbox4.Checked = true then
  begin
    Chart1Lineseries3.ShowLines := true;
  end
  else if Checkbox4.Checked = false then
  begin
    Chart1Lineseries3.ShowLines := false;
  end;
end;

end.

