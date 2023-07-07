unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs,
  VCLTee.Chart, math, VCLTee.Series;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    SpinEdit2: TSpinEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Topology: TButton;
    Initial: TButton;
    Training: TButton;
    Recall: TButton;
    Button5: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    RadioGait: TRadioButton;
    RadioAND: TRadioButton;
    RadioOR: TRadioButton;
    RadioXOR: TRadioButton;
    OpenDialog1: TOpenDialog;
    GroupBox4: TGroupBox;
    Chart2: TChart;
    Series2: TPointSeries;
    Chart5: TChart;
    Series8: THorizLineSeries;
    Series10: THorizLineSeries;
    Series11: TBarSeries;
    Chart3: TChart;
    Series3: TBarSeries;
    Series4: TBarSeries;
    Chart6: TChart;
    Series9: TBarSeries;
    Series12: TBarSeries;
    GroupBox5: TGroupBox;
    Chart1: TChart;
    Series1: THorizLineSeries;
    Chart4: TChart;
    Series5: THorizLineSeries;
    Series6: THorizLineSeries;
    Series7: THorizLineSeries;
    Series13: THorizLineSeries;
    Series14: THorizLineSeries;
    procedure TopologyClick(Sender: TObject);
    procedure InitialClick(Sender: TObject);
    procedure TrainingClick(Sender: TObject);
    procedure RecallClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  data, RecallGait : textfile;
  ILayer, HLayer1, Hlayer2, OLayer, LogicSum, GaitSum, datanum : integer;
  Input1, Input2, LogicOutput : array [1..10] of integer;
  treshold1, treshold2, treshold3, input : array [1..10] of extended;
  W1, W2, W3 : array [1..10,1..10] of extended;
  FinalW1, FinalW2, FinalW3 : array [1..10,1..10] of extended;
  MeanError : extended;
  StepError, SigmoidH1, SigmoidH2, SigmoidH3 : array [1..10] of extended; //fungsi aktivasi
  heel, toe, targetkaki : array [1..1000] of extended;

const
  alpha1=0.125;

implementation

{$R *.dfm}

procedure TForm1.TopologyClick(Sender: TObject);
begin
  ILayer := spinedit1.Value;
  HLayer1 := spinedit2.Value;
  HLayer2 := spinedit3.Value;
  OLayer := spinedit4.Value;

  Memo1.Lines.add('Input Layer Nodes : ' + inttostr(ILayer)+ sLineBreak +
                  'Hidden Layer 1 Nodes : ' + inttostr(HLayer1) + sLineBreak +
                  'Hidden Layer 2 Nodes : ' + inttostr(HLayer2) + sLineBreak +
                  'Output Layer Nodes : ' + inttostr(OLayer) + sLineBreak);
end;


procedure TForm1.InitialClick(Sender: TObject);
var
  I: Integer;
  J: Integer;

begin
  if RadioAnd.Checked = true then
  begin
    //Input for Logic function
    input1[1] := 0;
    input1[2] := 1;
    input1[3] := 0;
    input1[4] := 1;

    input2[1] := 0;
    input2[2] := 0;
    input2[3] := 1;
    input2[4] := 1;

    LogicOutput[1] := 0;
    LogicOutput[2] := 0;
    LogicOutput[3] := 0;
    LogicOutput[4] := 1;

    for I := 1 to 4 do
    begin
      series2.AddXY(input1[i],input2[i]);
      series3.AddXY(i,LogicOutput[i]);
    end;

    Logicsum := round(power(2,ILayer));

  end
  else if RadioOR.Checked = true then
  begin
    //Input for Logic function
    input1[1] := 0;
    input1[2] := 1;
    input1[3] := 0;
    input1[4] := 1;

    input2[1] := 0;
    input2[2] := 0;
    input2[3] := 1;
    input2[4] := 1;

    LogicOutput[1] := 0;
    LogicOutput[2] := 1;
    LogicOutput[3] := 1;
    LogicOutput[4] := 1;

    for I := 1 to 4 do
    begin
      series2.AddXY(input1[i],input2[i]);
      series3.AddXY(i,LogicOutput[i]);
    end;

    Logicsum := round(power(2,ILayer));

  end
  else if RadioXOR.Checked = true then
  begin
    //Input for Logic function
    input1[1] := 0;
    input1[2] := 1;
    input1[3] := 0;
    input1[4] := 1;

    input2[1] := 0;
    input2[2] := 0;
    input2[3] := 1;
    input2[4] := 1;

    LogicOutput[1] := 0;
    LogicOutput[2] := 1;
    LogicOutput[3] := 1;
    LogicOutput[4] := 0;

    for I := 1 to 4 do
    begin
      series2.AddXY(input1[i],input2[i]);
      series3.AddXY(i,LogicOutput[i]);
    end;

    Logicsum := round(power(2,ILayer));

  end
  else if RadioGait.Checked = true then
  begin
    assignfile(data,'training_normal.dat');
    reset(data);
    i := 0;
    while not EOF (data) do
    begin
      if i = 0  then
      begin
        readln (data, GaitSum);
        i := i + 1;
      end
      else if i > 0 then
      begin
        readln(data, heel[i] ,toe[i], targetkaki[i]);
        i := i + 1;
      end;
    end;
    closefile(data);

    for J := 1 to GaitSum do
    begin
      series8.AddXY(j, heel[j]);
      //series9.AddXY(j, targetkaki[j]);
      series10.AddXY(j, toe[j]);
      series11.AddXY(j, targetkaki[j]);
    end;

  end;

  for I := 1 to 9 do
  begin
    treshold1[i] := 0.1;
    treshold2[i] := 0.1;
    treshold3[i] := 0.1;
  end;

  //Inisialisasi weight
  {Input ke Hideen layer 1}
  Memo1.Lines.Add('Initial Weight 1');
  for I := 1 to HLayer1 do
  begin
    for J := 1 to ILayer do
    begin
      W1[i,j] := abs(randg(0,0.5));
      Memo1.Lines.Add('W1[' + inttostr(i) + ',' + inttostr(j) + '] = ' + floattostr(W1[i,j]));
    end;
  end;
  Memo1.Lines.Add(sLineBreak);

  {Hidden layer 1 ke Hideen layer 2}
  Memo1.Lines.Add('Initial Weight 2');
  for I := 1 to HLayer2 do
  begin
    for J := 1 to HLayer1 do
    begin
      W2[i,j] := abs(randg(0,0.5));
      Memo1.Lines.Add('W2[' + inttostr(i) + ',' + inttostr(j) + '] = ' + floattostr(W2[i,j]));
    end;
  end;
  Memo1.Lines.Add(sLineBreak);

  {Hidden layer 2 ke output}
  Memo1.Lines.Add('Initial Weight 3');
  for I := 1 to OLayer do
  begin
    for J := 1 to HLayer2 do
    begin
      W3[i,j] := abs(randg(0,0.5));
      Memo1.Lines.Add('W3[' + inttostr(i) + ',' + inttostr(j) + '] = ' + floattostr(W3[i,j]));
    end;
  end;
  memo1.Lines.Add(sLineBreak);
end;


procedure TForm1.TrainingClick(Sender: TObject);
var
  I, J, K, q, t: Integer;
  temp, beta, thresh : extended;
  DeltaJ56, DeltaJ57, etemp, target : array [1..10] of extended;

label
  mulai, ulang;
begin
  if (RadioAND.Checked = true) or (RadioOR.Checked = true) or (RadioXOR.Checked = true) then
  begin
    datanum := LogicSum;
  end
  else if (RadioGait.Checked = true) then
  begin
    datanum := GaitSum;
  end;

  beta := power(10,-4);
  q := 1;

  mulai :
  MeanError := 0;

  for T := 1 to datanum do
  begin
    if (RadioAND.Checked = true) or (RadioOR.Checked = true) or (RadioXOR.Checked = true) then
    begin
      input[1] := input1[t];
      input[2] := input2[t];
      target[t] := LogicOutput[t];
    end
    else if (RadioGait.Checked = true) then
    begin
      input[1] := heel[t];
      input[2] := toe[t];
      target[t] := targetkaki[t];
    end;
    //listbox1.Items.Add(floattostr(input[1]) + '       ' + floattostr(input[2]));

    //Feed Forward
    for j := 1 to HLayer1 do
    begin
      temp := 0;
      for k := 1 to ILayer do
      begin
        temp := temp + (input[k]*w1[j,k]);
      end;
      temp := temp - treshold1[j];
      SigmoidH1[j] := 1/(1 + exp(-temp));
    end;

    for I := 1 to HLayer2 do
    begin
      temp := 0;
      for J := 1 to HLayer1 do
      begin
        temp := temp + SigmoidH1[j]*W2[i,j];
      end;
      temp := temp - treshold2[i];
      SigmoidH2[i] := 1/(1 + exp(-temp));
      //listbox1.items.Add(floattostr(SigmoidH2[i]));
    end;

    for I := 1 to OLayer do
    begin
      temp := 0;
      for J := 1 to HLayer2 do
      begin
        temp := temp + SigmoidH2[j]*W3[i,j];
      end;
      temp := temp - treshold3[i];
      SigmoidH3[i] := 1/(1 + exp(-temp));

      //Error
      StepError[i] := target[t] - SigmoidH3[i];       //error pada langkah ini
      MeanError := MeanError + (0.5*(sqr(StepError[i]))); //rata2 semua error
    end;

    //Back Propagation//
    //Layer output ke hidden layer 2
    for I := 1 to HLayer2 do
    begin
      thresh := 0;
      for J := 1 to OLayer do
      begin
        DeltaJ56[j] := StepError[j]*SigmoidH3[j]*(1-SigmoidH3[j]); //Persamaan 3.56
        W3[j,i] := W3[j,i] + alpha1*DeltaJ56[j]*SigmoidH2[i];  //persamaan 3.55
        FinalW3[j,i] := W3[j,i];
        treshold3[j] := treshold3[j] - alpha1*DeltaJ56[j];
        thresh := thresh + treshold3[j];
      end;
      thresh := thresh/Olayer;
      series7.AddXY(q, thresh);
    end;

      //Hidden Layer 2 ke hidden layer 1
    for I := 1 to HLayer2 do
    begin
      temp := 0;
      for J := 1 to OLayer do
      begin
        temp := temp + W3[j,i]*DeltaJ56[j];
      end;
      etemp[i] := temp;
    end;
    for I := 1 to HLayer1 do
    begin
      thresh := 0;
      for J := 1 to HLayer2 do
      begin
        DeltaJ57[j]:= etemp[j]*SigmoidH2[j]*(1-SigmoidH2[j]); //Persamaan 3.57
        W2[j,i] := W2[j,i] + alpha1*DeltaJ57[j]*SigmoidH1[i];  //persamaan 3.55
        FinalW2[j,i] := W2[j,i];
        treshold2[j] := treshold2[j] - alpha1*DeltaJ57[j];
        thresh := thresh + treshold2[j];
      end;
      thresh := thresh/HLayer2;
      series6.AddXY(q, thresh);
    end;

    //Hidden Layer 1 ke Input layer
    for I := 1 to HLayer1 do
    begin
      temp := 0;
      for J := 1 to HLayer2 do
      begin
        temp := temp + W2[j,i]*DeltaJ57[j];
      end;
      etemp[i] := temp;
    end;
    for I := 1 to ILayer do
    begin
      thresh := 0;
      for J := 1 to HLayer1 do
      begin
        DeltaJ57[j]:= etemp[j]*SigmoidH1[j]*(1-SigmoidH1[j]); //Persamaan 3.57
        W1[j,i] := W1[j,i] + alpha1*DeltaJ57[j]*Input[i];  //persamaan 3.55
        FinalW1[j,i] := W1[j,i];
        treshold1[j] := treshold1[j] - alpha1*DeltaJ57[j];
        thresh := thresh + treshold1[j];
      end;
      thresh := thresh/HLayer2;
      series5.AddXY(q, thresh);
    end;

    series1.AddXY(q,MeanError);

    inc(q);   //update iteration inc(q)
  end;

  if MeanError > beta then //beta error limit
  begin
    inc(q);
    goto mulai;    //evaluasi error limit tiap seluruh data dipelajari
  end
  else
  begin
    edit1.Text := floattostr(q);
    edit2.Text := floattostr(MeanError);

    for I := 1 to ILayer do
    begin
      for J := 1 to HLayer1 do
      begin
        Memo1.Lines.Add('W1[' + inttostr(j) + ',' + inttostr(i) + '] = ' + floattostr(FinalW1[j,i]));
      end;
    end;

    for I := 1 to HLayer1 do
    begin
      for J := 1 to HLayer2 do
      begin
        Memo1.Lines.Add('W2[' + inttostr(j) + ',' + inttostr(i) + '] = ' + floattostr(FinalW2[j,i]));
      end;
    end;

    for I := 1 to HLayer2 do
    begin
      for J := 1 to OLayer do
      begin
        Memo1.Lines.Add('W3[' + inttostr(j) + ',' + inttostr(i) + '] = ' + floattostr(FinalW3[j,i]));
        //listbox1.items.Add(floattostr(w3[j,i]));
      end;

    end;

  end;

end;

procedure TForm1.RecallClick(Sender: TObject);
var
  I, J, K, T : integer;
  temp : extended;
begin
  if RadioGait.Checked = true then
  begin
      if OpenDialog1.Execute then
      begin
        assignfile(RecallGait,opendialog1.FileName);
        reset(RecallGait);
        i := 0;
        while not EOF (RecallGait) do
        begin
          if i = 0  then
          begin
            readln (RecallGait, GaitSum);
            i := i + 1;
          end
          else if i > 0 then
          begin
            readln(RecallGait, heel[i] ,toe[i], targetkaki[i]);
            i := i + 1;
          end;
        end;
        closefile(RecallGait);

        for J := 1 to GaitSum do
        begin
          series9.AddXY(j, targetkaki[j]);
          series13.AddXY(j, heel[j]);
          series14.AddXY(j, toe[j]);
        end;

      end;
      datanum := GaitSum;
  end;

  t := 1;
  repeat
    if (RadioAND.Checked = true) or (RadioOR.Checked = true) or (RadioXOR.Checked = true) then
    begin
      input[1] := input1[t];
      input[2] := input2[t];
      //target[t] := LogicOutput[t];
    end
    else if (RadioGait.Checked = true) then
    begin
      {input[1] := heel[t];
      input[2] := toe[t];}

      input[1] := heel[t];
      input[2] := toe[t];

    end;

    //Feed Forward
    for j := 1 to HLayer1 do
    begin
      temp := 0;
      for k := 1 to ILayer do
      begin
        temp := temp + input[k]*w1[j,k];
      end;
      temp := temp - treshold1[j];
      SigmoidH1[j] := 1/(1 + exp(-temp));
    end;

    for I := 1 to HLayer2 do
    begin
      temp := 0;
      for J := 1 to HLayer1 do
      begin
        temp := temp + SigmoidH1[j]*W2[i,j];
      end;
      temp := temp - treshold2[i];
      SigmoidH2[i] := 1/(1 + exp(-temp));
    end;

    for I := 1 to OLayer do
    begin
      temp := 0;
      for J := 1 to HLayer2 do
      begin
        temp := temp + SigmoidH2[j]*W3[i,j];
      end;
      temp := temp - treshold3[i];
      SigmoidH3[i] := 1/(1 + exp(-temp));


    end;

    if (RadioAND.Checked = true) or (RadioOR.Checked = true) or (RadioXOR.Checked = true) then
    begin
      series4.AddXY(t,SigmoidH3[1]);
    end
    else if (RadioGait.Checked = true) then
    begin
      series12.AddXY(t,SigmoidH3[1]);
    end;

    inc(t);

  until (t > datanum);
end;

end.
