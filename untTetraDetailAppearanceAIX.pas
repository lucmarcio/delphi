unit untTetraDetailAppearanceAIX;

interface

uses System.Types, FMX.ListView, FMX.ListView.Types, FMX.ListView.Appearances, System.Classes, System.SysUtils,
  FMX.Types, FMX.Controls, System.UITypes, FMX.MobilePreview;

type

  TTetraDetailAppearanceNames = class
  public const
    ListItem = 'TetraDetailItem';
    ListItemCheck = ListItem + 'ShowCheck';
    ListItemDelete = ListItem + 'Delete';
    Detail1 = 'det1';  // Name of TetraDetail object/data
    Detail2 = 'det2';
    Detail3 = 'det3';
    Detail4 = 'det4';
  end;

implementation

uses System.Math, System.Rtti;

type

  TTetraDetailItemAppearance = class(TPresetItemObjects)
  public const
    cTextMarginAccessory          = 8;
    cDefaultImagePlaceOffsetX     = -3;
    cDefaultImageTextPlaceOffsetX = 4;
    cDefaultHeight                = 80;
    cDefaultImageWidth            = 65;
    cDefaultImageHeight           = 65;
  private
    FTetraDetail1: TTextObjectAppearance;
    FTetraDetail2: TTextObjectAppearance;
    FTetraDetail3: TTextObjectAppearance;
    FTetraDetail4: TTextObjectAppearance;
    procedure SetTetraDetail1(const Value: TTextObjectAppearance);
    procedure SetTetraDetail2(const Value: TTextObjectAppearance);
    procedure SetTetraDetail3(const Value: TTextObjectAppearance);
    procedure SetTetraDetail4(const Value: TTextObjectAppearance);
  protected
    function DefaultHeight: Integer; override;
    procedure UpdateSizes(const FinalSize: TSizeF); override;
    function GetGroupClass: TPresetItemObjects.TGroupClass; override;
    procedure SetObjectData(const AListViewItem: TListViewItem; const AIndex: string; const AValue: TValue; var AHandled: Boolean); override;
  public
    constructor Create(const Owner: TControl); override;
    destructor Destroy; override;
  published
    property Image;
    property TetraDetail1: TTextObjectAppearance read FTetraDetail1 write SetTetraDetail1;
    property TetraDetail2: TTextObjectAppearance read FTetraDetail2 write SetTetraDetail2;
    property TetraDetail3: TTextObjectAppearance read FTetraDetail3 write SetTetraDetail3;
    property TetraDetail4: TTextObjectAppearance read FTetraDetail4 write SetTetraDetail4;
    property Accessory;
  end;

  TTetraDetailDeleteAppearance = class(TTetraDetailItemAppearance)
  private const
    cDefaultGlyph = TGlyphButtonType.Delete;
  public
    constructor Create(const Owner: TControl); override;
  published
    property GlyphButton;
  end;

  TTetraDetailShowCheckAppearance = class(TTetraDetailItemAppearance)
  private const
    cDefaultGlyph = TGlyphButtonType.Checkbox;
  public
    constructor Create(const Owner: TControl); override;
  published
    property GlyphButton;
  end;


const
  cTetraDetail1Member = 'Detail1';
  cTetraDetail2Member = 'Detail2';
  cTetraDetail3Member = 'Detail3';
  cTetraDetail4Member = 'Detail4';

constructor TTetraDetailItemAppearance.Create(const Owner: TControl);
begin
  inherited;
  Accessory.DefaultValues.AccessoryType := TAccessoryType.More;
  Accessory.DefaultValues.Visible       := True;
  Accessory.RestoreDefaults;

  Text.DefaultValues.VertAlign     := TListItemAlign.Trailing;
  Text.DefaultValues.TextVertAlign := TTextAlign.Leading;
  Text.DefaultValues.Height        := 29;  // Item will be bottom aligned, with text top aligned
  Text.DefaultValues.Visible       := True;
  Text.RestoreDefaults;

  FTetraDetail1 := TTextObjectAppearance.Create;
  FTetraDetail1.Name := TTetraDetailAppearanceNames.Detail1;
  FTetraDetail1.DefaultValues.Assign(Text.DefaultValues);  // Start with same defaults as Text object
  FTetraDetail1.DefaultValues.Height := 29;  // Move text down
  FTetraDetail1.DefaultValues.IsDetailText := True; // Use detail font
  FTetraDetail1.RestoreDefaults;
  FTetraDetail1.OnChange := Self.ItemPropertyChange;
  FTetraDetail1.Owner := Self;

  FTetraDetail2 := TTextObjectAppearance.Create;
  FTetraDetail2.Name := TTetraDetailAppearanceNames.Detail2;
  FTetraDetail2.DefaultValues.Assign(FTetraDetail1.DefaultValues);  // Start with same defaults as Text object
  FTetraDetail2.DefaultValues.Height := 29; // Move text down
  FTetraDetail2.RestoreDefaults;
  FTetraDetail2.OnChange := Self.ItemPropertyChange;
  FTetraDetail2.Owner := Self;

  FTetraDetail3 := TTextObjectAppearance.Create;
  FTetraDetail3.Name := TTetraDetailAppearanceNames.Detail3;
  FTetraDetail3.DefaultValues.Assign(FTetraDetail2.DefaultValues);  // Start with same defaults as Text object
  FTetraDetail3.DefaultValues.Height := 29; // Move text down
  FTetraDetail3.RestoreDefaults;
  FTetraDetail3.OnChange := Self.ItemPropertyChange;
  FTetraDetail3.Owner := Self;

  FTetraDetail4      := TTextObjectAppearance.Create;
  FTetraDetail4.Name := TTetraDetailAppearanceNames.Detail4;
  FTetraDetail4.DefaultValues.Assign(FTetraDetail2.DefaultValues);  // Start with same defaults as Text object
  FTetraDetail4.DefaultValues.Height := 29; // Move text down

  FTetraDetail4.RestoreDefaults;
  FTetraDetail4.OnChange := Self.ItemPropertyChange;
  FTetraDetail4.Owner    := Self;

  // Define livebindings members that make up TetraDetail
  FTetraDetail1.DataMembers :=
    TObjectAppearance.TDataMembers.Create(
      TObjectAppearance.TDataMember.Create(
        cTetraDetail1Member, // Displayed by LiveBindings
        Format('Data["%s"]', [TTetraDetailAppearanceNames.Detail1])));   // Expression to access value from TListViewItem

  FTetraDetail2.DataMembers :=
    TObjectAppearance.TDataMembers.Create(
      TObjectAppearance.TDataMember.Create(
        cTetraDetail2Member, // Displayed by LiveBindings
        Format('Data["%s"]', [TTetraDetailAppearanceNames.Detail2])));   // Expression to access value from TListViewItem

  FTetraDetail3.DataMembers :=
    TObjectAppearance.TDataMembers.Create(
      TObjectAppearance.TDataMember.Create(
        cTetraDetail3Member, // Displayed by LiveBindings
        Format('Data["%s"]', [TTetraDetailAppearanceNames.Detail3])));   // Expression to access value from TListViewItem

  FTetraDetail4.DataMembers :=
    TObjectAppearance.TDataMembers.Create(
      TObjectAppearance.TDataMember.Create(
        cTetraDetail4Member, // Displayed by LiveBindings
        Format('Data["%s"]', [TTetraDetailAppearanceNames.Detail4])));   // Expression to access value from TListViewItem

  Image.DefaultValues.Width  := cDefaultImageWidth;
  Image.DefaultValues.Height := cDefaultImageHeight;
  Image.RestoreDefaults;

  GlyphButton.DefaultValues.VertAlign := TListItemAlign.Center;
  GlyphButton.RestoreDefaults;

  Text.DefaultValues.Height := 29;


  // Define the appearance objects
  AddObject(Text, True);
  AddObject(TetraDetail1, True);
  AddObject(TetraDetail2, True);
  AddObject(TetraDetail3, True);
  AddObject(TetraDetail4, True);
  AddObject(Image, True);
  AddObject(Accessory, True);
  AddObject(GlyphButton, IsItemEdit);  // GlyphButton is only visible when in edit mode
end;

constructor TTetraDetailDeleteAppearance.Create(const Owner: TControl);
begin
  inherited;
  GlyphButton.DefaultValues.ButtonType := cDefaultGlyph;
  GlyphButton.DefaultValues.Visible := True;
  GlyphButton.RestoreDefaults;
end;

constructor TTetraDetailShowCheckAppearance.Create(const Owner: TControl);
begin
  inherited;
  GlyphButton.DefaultValues.ButtonType := cDefaultGlyph;
  GlyphButton.DefaultValues.Visible := True;
  GlyphButton.RestoreDefaults;
end;

function TTetraDetailItemAppearance.DefaultHeight: Integer;
begin
  Result := cDefaultHeight;
end;

destructor TTetraDetailItemAppearance.Destroy;
begin
  FTetraDetail1.Free;
  FTetraDetail2.Free;
  FTetraDetail3.Free;
  FTetraDetail4.Free;
  inherited;
end;

procedure TTetraDetailItemAppearance.SetTetraDetail1(const Value: TTextObjectAppearance);
begin
  FTetraDetail1.Assign(Value);
end;

procedure TTetraDetailItemAppearance.SetTetraDetail2(const Value: TTextObjectAppearance);
begin
  FTetraDetail2.Assign(Value);
end;

procedure TTetraDetailItemAppearance.SetTetraDetail3(const Value: TTextObjectAppearance);
begin
  FTetraDetail3.Assign(Value);
end;

procedure TTetraDetailItemAppearance.SetTetraDetail4(const Value: TTextObjectAppearance);
begin
  FTetraDetail4.Assign(Value);
end;

procedure TTetraDetailItemAppearance.SetObjectData(
  const AListViewItem: TListViewItem; const AIndex: string;
  const AValue: TValue; var AHandled: Boolean);
begin
  inherited;

end;

function TTetraDetailItemAppearance.GetGroupClass: TPresetItemObjects.TGroupClass;
begin
  Result := TTetraDetailItemAppearance;
end;

procedure TTetraDetailItemAppearance.UpdateSizes(const FinalSize: TSizeF);
var
  LInternalWidth: Single;
  LImagePlaceOffset: Single;
  LImageTextPlaceOffset: Single;
begin
  BeginUpdate;
  try
    inherited;

    // Update the widths and positions of renderening objects within a TListViewItem
    if Image.ActualWidth = 0 then
    begin
      LImagePlaceOffset     := 0;
      LImageTextPlaceOffset := 0;
    end
    else
    begin
      LImagePlaceOffset     := cDefaultImagePlaceOffsetX;
      LImageTextPlaceOffset := cDefaultImageTextPlaceOffsetX;
    end;

    Image.InternalPlaceOffset.X := GlyphButton.ActualWidth + LImagePlaceOffset;
    if Image.ActualWidth > 0 then
      Text.InternalPlaceOffset.X := Image.ActualPlaceOffset.X +  Image.ActualWidth + LImageTextPlaceOffset
    else
      Text.InternalPlaceOffset.X :=  0 + GlyphButton.ActualWidth;

    TetraDetail1.InternalPlaceOffset.X := Text.InternalPlaceOffset.X;
    TetraDetail2.InternalPlaceOffset.X := Text.InternalPlaceOffset.X;
    TetraDetail3.InternalPlaceOffset.X := Text.InternalPlaceOffset.X;
    TetraDetail4.InternalPlaceOffset.X := Text.InternalPlaceOffset.X;

    LInternalWidth := FinalSize.Width - Text.ActualPlaceOffset.X - Accessory.ActualWidth;
    if Accessory.ActualWidth > 0 then
      LInternalWidth := LInternalWidth - cTextMarginAccessory;

    Text.InternalWidth := Max(1, LInternalWidth);
    TetraDetail1.InternalWidth := Text.InternalWidth;
    TetraDetail2.InternalWidth := Text.InternalWidth;
    TetraDetail3.InternalWidth := Text.InternalWidth;
    TetraDetail4.InternalWidth := Text.InternalWidth;
  finally
    EndUpdate;
  end;

end;

type
  TOption = TRegisterAppearanceOption;
const
  sThisUnit = 'untTetraDetailAppearanceAIX';     // Will be added to the uses list when appearance is used
initialization
  // TetraDetailItem group
  TAppearancesRegistry.RegisterAppearance(
    TTetraDetailItemAppearance, TTetraDetailAppearanceNames.ListItem,
    [TRegisterAppearanceOption.Item], sThisUnit);

  TAppearancesRegistry.RegisterAppearance(
    TTetraDetailDeleteAppearance, TTetraDetailAppearanceNames.ListItemDelete,
    [TRegisterAppearanceOption.ItemEdit], sThisUnit);

  TAppearancesRegistry.RegisterAppearance(
    TTetraDetailShowCheckAppearance, TTetraDetailAppearanceNames.ListItemCheck,
    [TRegisterAppearanceOption.ItemEdit], sThisUnit);

finalization
  TAppearancesRegistry.UnregisterAppearances(
    TArray<TItemAppearanceObjectsClass>.Create(
      TTetraDetailItemAppearance, TTetraDetailDeleteAppearance,
      TTetraDetailShowCheckAppearance));
end.
