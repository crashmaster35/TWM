(*
  ToroWM_VESAModeSelection

  Author: Bruno Chavez
  Email: bruno.chavez@ccbrumer.com
  
  Description:
  This program tests VESA graphic modes, allowing the user to select a mode
  and save the selection in a configuration file. On subsequent runs, it 
  will load the previously selected mode. A pixel is drawn on the screen to 
  verify that the mode is properly initialized. The program also allows the 
  user to change the mode and save it for future use.
*)

program ToroWM_VESAModeSelection;

uses
  crt, dos;

type
  (* Record to hold the structure for VESA video mode information *)
  TVideoMode = record
    ModeAttr: Word;
    WinAAttr: Byte;
    WinBAttr: Byte;
    Granularity: Word;
    WinSize: Word;
    SegmentA: Word;
    SegmentB: Word;
    RealFctPtr: Pointer;
    Pitch: Word;
    Width: Word;
    Height: Word;
    CharacterWidth: Byte;
    CharacterHeight: Byte;
    Planes: Byte;
    BitsPerPixel: Byte;
    Banks: Byte;
    MemoryModel: Byte;
    BankSize: Byte;
    Pages: Byte;
    Reserved0: Byte;
    RedMaskSize: Byte;
    RedFieldPosition: Byte;
    GreenMaskSize: Byte;
    GreenFieldPosition: Byte;
    BlueMaskSize: Byte;
    BlueFieldPosition: Byte;
    ReservedMaskSize: Byte;
    ReservedFieldPosition: Byte;
    DirectColorInfo: Byte;
    PhysBasePtr: DWord;
    Reserved1: DWord;
    Reserved2: Word;
  end;

var
  Regs: Registers;
  VideoInfo: TVideoMode;
  VideoMode: Word;
  ConfigFile: Text;
  SelectedMode: Word;
  AvailableModes: array[1..10] of Word = ($101, $103, $105, $107, $10A, $10D, $10F, $111, $113, $115);
  ConfigFileName: String = 'config.txt';

(*
  Procedure to switch to a specified video mode using VESA.
  Mode: The video mode to set (e.g., 0x101 for 640x480 256 colors).
*)
procedure SetVideoMode(Mode: Word);
begin
  Regs.ax := $4F02;  (* BIOS interrupt for setting VESA mode *)
  Regs.bx := Mode;
  Intr($10, Regs);  (* Interrupt 0x10 is used for video services *)
end;

(*
  Procedure to draw a pixel at a specific coordinate (x, y) on the screen.
  x, y: Coordinates where the pixel will be drawn.
  color: The color value of the pixel to be set.
*)
procedure PutPixel(x, y: Word; color: Byte);
var
  PixelPos: LongInt;
begin
  PixelPos := y * 640 + x;  (* Calculate the pixel position in video memory *)
  Mem[$A000:PixelPos] := color;  (* Write the color value to video memory *)
end;

(*
  Procedure to save the selected video mode to a configuration file.
  Mode: The selected video mode to save.
*)
procedure SaveSelectedMode(Mode: Word);
begin
  Assign(ConfigFile, ConfigFileName);
  Rewrite(ConfigFile);  (* Open the file for writing *)
  WriteLn(ConfigFile, Mode);  (* Write the mode to the file *)
  Close(ConfigFile);  (* Close the file after writing *)
end;

(*
  Function to load the previously selected video mode from a configuration file.
  Returns: The mode stored in the config file, or 0x101 (default) if no config exists.
*)
function LoadSelectedMode: Word;
var
  Mode: Word;
begin
  Assign(ConfigFile, ConfigFileName);
  {$I-}  (* Disable I/O error checking *)
  Reset(ConfigFile);  (* Open the config file for reading *)
  {$I+}
  if IOResult = 0 then  (* If the file exists and is readable *)
  begin
    ReadLn(ConfigFile, Mode);  (* Read the mode from the file *)
    Close(ConfigFile);  (* Close the file after reading *)
    LoadSelectedMode := Mode;
  end
  else
    LoadSelectedMode := $101;  (* Default mode if no file found *)
end;

(*
  Procedure to display the available VESA graphic modes for selection.
*)
procedure DisplayAvailableModes;
var
  i: Integer;
begin
  WriteLn('Available graphic modes:');
  for i := 1 to Length(AvailableModes) do
  begin
    WriteLn(i, ': Mode ', HexStr(AvailableModes[i], 4));  (* List modes in hexadecimal format *)
  end;
end;

(*
  Function to allow the user to select a graphic mode from the list.
  Returns: The selected mode (or the default 0x101 if selection is invalid).
*)
function SelectMode: Word;
var
  ModeIndex: Integer;
begin
  DisplayAvailableModes;  (* Display available modes *)
  Write('Select a graphic mode (1-', Length(AvailableModes), '): ');
  ReadLn(ModeIndex);  (* User inputs a mode index *)
  if (ModeIndex >= 1) and (ModeIndex <= Length(AvailableModes)) then
    SelectMode := AvailableModes[ModeIndex]  (* Return selected mode *)
  else
    SelectMode := $101;  (* Default mode if selection is invalid *)
end;

begin
  ClrScr;
  
  (* Load the video mode from the configuration file *)
  SelectedMode := LoadSelectedMode;
  WriteLn('Loaded graphic mode from config: ', HexStr(SelectedMode, 4));

  (* Set the selected video mode *)
  SetVideoMode(SelectedMode);

  (* Draw a pixel at (320, 240) to test the selected mode *)
  PutPixel(320, 240, 15);  (* White pixel at the center of the screen *)

  (* Wait for user input to either exit or select a new mode *)
  WriteLn('Press any key to select a new mode or exit...');
  if KeyPressed then
  begin
    ReadKey;
    (* User selects a new video mode *)
    SelectedMode := SelectMode;
    
    (* Save the selected mode in the configuration file *)
    SaveSelectedMode(SelectedMode);

    (* Set the new selected video mode *)
    SetVideoMode(SelectedMode);
  end;

  (* Return to text mode *)
  Regs.ax := $0003;
  Intr($10, Regs);
end.
