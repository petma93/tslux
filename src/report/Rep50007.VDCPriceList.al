report 50007 "VDC Price List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Rdlc/VDC Price List.rdlc';

    ApplicationArea = Basic, Suite;
    Caption = 'VDC Price List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Location Filter";
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(CalculateDateCaption; CalculateDateCaption)
            {
            }
            column(CalculateDate; CalculateDate)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(NoCaption; NoCaption)
            {
            }
            column(No; "No.")
            {
            }
            column(PictureCaption; PictureCaption)
            {
            }
            column(Picture; Picture)
            {
            }
            column(PicturePerfion; TempBlob.Blob)
            {
            }
            column(DescriptionCaption; DescriptionCaption)
            {
            }
            column(Description; Descr)
            {
            }
            column(HeightCaption; HeightCaption)
            {
            }
            column(Height; ItemUnitofMeasure.Height)
            {
                DecimalPlaces = 5 : 5;
            }
            column(WidthCaption; WidthCaption)
            {
            }
            column(Width; ItemUnitofMeasure.Width)
            {
                DecimalPlaces = 5 : 5;
            }
            column(LengthCaption; LengthCaption)
            {
            }
            column(Length; ItemUnitofMeasure.Length)
            {
                DecimalPlaces = 5 : 5;
            }
            column(QtyPerColloCaption; QtyPerColloCaption)
            {
            }
            column(QtyPerCollo; QtyPerCollo)
            {
                DecimalPlaces = 5 : 5;
            }
            column(GR1PriceCaption; GR1PriceCaption)
            {
            }
            column(GR1Price; GR1Price)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GR2PriceCaption; GR2PriceCaption)
            {
            }
            column(GR2Price; GR2Price)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GR1MinPriceCaption; GR1MinPriceCaption)
            {
            }
            column(GR1MinPrice; GR1MinPrice)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GR2MinPriceCaption; GR2MinPriceCaption)
            {
            }
            column(GR2MinPrice; GR2MinPrice)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GR1MinQtyCaption; GR1MinQtyCaption)
            {
            }
            column(GR1MinQty; GR1MinQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(GR2MinQtyCaption; GR2MinQtyCaption)
            {
            }
            column(GR2MinQty; GR2MinQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(CIFCaption; CIFCaption)
            {
            }
            column(FOBCaption; FOBCaption)
            {
            }
            column(FOBUSDCaption; FOBUSDCaption)
            {
            }
            column(ColorStockCodeCaption; ColorStockCodeCaption)
            {
            }
            column(WhereUsedCaption; WhereUsedCaption)
            {
            }
            column(WhereUsed; WhereUsed)
            {
            }
            column(CatalogCaption; CatalogCaption)
            {
            }
            column(Catalog; Catalog)
            {
            }
            column(CollectionCaption; CollectionCaption)
            {
            }
            column(Collection; Collection)
            {
            }
            column(ProductgroupCaption; ProductgroupCaption)
            {
            }
            column(Productgroup; "Item Category Code")
            {
            }
            column(ItemStatusCaption; ItemStatusCaption)
            {
            }
            column(ItemStatus; ItemStatus)
            {
            }
            column(InventoryCaption; InventoryCaption)
            {
            }
            column(InventoryQty; InventoryQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(SalesCaption; SalesCaption)
            {
            }
            column(SalesQty; SalesQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(OutboundTransferCaption; OutboundTransferCaption)
            {
            }
            column(OutboundTransferQty; OutboundTransferQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(PurchaseCaption; PurchaseCaption)
            {
            }
            column(PurchaseQty; PurchaseQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(InboundTransferCaption; InboundTransferCaption)
            {
            }
            column(InboundTransferQty; InboundTransferQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(AvailCaption; AvailCaption)
            {
            }
            column(AvailQty; AvailQty)
            {
                DecimalPlaces = 2 : 2;
            }
            column(MainMaterialCaption; MainMaterialCaption)
            {
            }
            column(MainMaterial; MainMaterial)
            {
            }
            column(Qty40ftHCCaption; Qty40ftHCCaption)
            {
            }
            column(LoadingVolumCaption; LoadingVolumCaption)
            {
            }
            column(VolumepackedCaption; VolumepackedCaption)
            {
            }
            column(Volumepacked; ItemUnitofMeasure."Loading Volume")
            {
            }
            column(VolumeM3Caption; VolumeM3Caption)
            {
            }
            column(GrossWeightCaption; GrossWeightCaption)
            {
            }
            column(GrossWeight; "Gross Weight")
            {
                DecimalPlaces = 2 : 2;
            }
            column(NetWeightCaption; NetWeightCaption)
            {
            }
            column(NetWeight; "Net Weight")
            {
                DecimalPlaces = 2 : 2;
            }
            column(SeatHeightCaption; SeatHeightCaption)
            {
            }
            column(SeatWidthCaption; SeatWidthCaption)
            {
            }
            column(SeatDepthCaption; SeatDepthCaption)
            {
            }
            column(ArmrestHeightCaption; ArmrestHeightCaption)
            {
            }
            column(ClearanceTableCaption; ClearanceTableCaption)
            {
            }
            column(BaseUoMCaption; BaseUoMCaption)
            {
            }
            column(BaseUoM; "Base Unit of Measure")
            {
            }
            column(CostRevaluedCaption; CostRevaluedCaption)
            {
            }
            column(CostRevalued; "Cost is Adjusted")
            {
            }
            column(PurchaseCurrencyCodeCaption; PurchaseCurrencyCodeCaption)
            {
            }
            column(PurchaseCurrencyCode; PurchasePrice."Currency Code")
            {
            }
            column(PurchasePriceCaption; PurchasePriceCaption)
            {
            }
            column(PurchasePrice; PurchasePrice."Direct Unit Cost")
            {
                DecimalPlaces = 2 : 2;
            }
            column(PurchaseVendorCaption; PurchaseVendorNoCaption)
            {
            }
            column(PurchaseVendor; PurchasePrice."Vendor No.")
            {
            }
            column(PurchaseVendorNameCaption; PurchaseVendorNameCaption)
            {
            }
            column(PurchaseVendorName; PurchaseVendorName)
            {
            }
            column(VendorItemNoCaption; VendorItemNoCaption)
            {
            }
            column(VendorItemNo; ItemVendor."Vendor Item No.")
            {
            }
            column(CountryOriginCaption; CountryOriginCaption)
            {
            }
            column(CountryOrigin; "Country/Region of Origin Code")
            {
            }
            column(CountryPurchasedCaption; CountryPurchasedCaption)
            {
            }
            column(CountryPurchased; "Country/Region Purchased Code")
            {
            }
            column(OnlyforCustomerGroupCaption; OnlyforCustomerGroupCaption)
            {
            }
            column(OnlyforCustomerCaption; OnlyforCustomerCaption)
            {
            }
            column(CreatedAtCaption; CreatedAtCaption)
            {
            }
            column(CreatedAt; format(CreatedAt))
            {
            }
            column(DontExportCaption; DontExportCaption)
            {
            }
            column(EndOfLifeCaption; EndOfLifeCaption)
            {
            }
            column(EndOfLife; EndOfLife)
            {
            }
            column(DateEndOfLifeCaption; DateEndOfLifeCaption)
            {
            }
            column(DateEndOfLife; DateEndOfLife)
            {
            }

            trigger OnAfterGetRecord()
            var
                NowUpdate: Boolean;
            begin
                //progress
                if GuiAllowed() then begin
                    NowUpdate := CurrentDateTime() - LastUpdatedAt >= 1000;
                    if NowUpdate then begin
                        Progress.Update(1, Round(Current / Total * 10000, 1));
                        LastUpdatedAt := CurrentDateTime();
                    end;
                end;

                GetPerfionData();
                GetBaseUoM();
                GetDesc();
                GetQtyPerCollo();
                GetGRPriceInfo();
                CalcAvail();
                GetVendor();
                GetItemVendor();
                GetPurchPrice();
                GetCreatedAt();
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed() then
                    Progress.Close();
                ReportDuration := CurrentDateTime() - StartedAt;
            end;

            trigger OnPreDataItem()
            begin
                Total := Item.Count();
                StartedAt := CurrentDateTime();
                LastUpdatedAt := CurrentDateTime();
                if GuiAllowed() then
                    Progress.Open(ProgressTxt);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(OptionsCtrls)
                {
                    Caption = 'Options';
                    field(CalculationDate; CalculateDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calculation Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CalculateDate := WorkDate();
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        if CalculateDate = 0D then
            CalculateDate := WorkDate();
        GetCaptions();
        ItemFilter := FormatDocument.GetRecordFiltersWithCaptions(Item);
    end;

    var
        TempBlob: Record TempBlob;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        PurchasePrice: Record "Purchase Price";
        ItemVendor: Record "Item Vendor";
        Vendor: Record Vendor;
        PRFN_CallPerfionMgt: Codeunit "PRFN_Call Perfion Mgt";
        CalculateDate: Date;
        Progress: Dialog;
        Total: Integer;
        Current: Integer;
        LastUpdatedAt: DateTime;
        StartedAt: DateTime;
        ReportDuration: Duration;
        CalculateDateCaption: Text;
        ItemFilter: Text;
        PerfionFldNameArray: array[20] of Text;
        PerfionFldValueArray: array[20] of Text;
        NoCaption: Text;
        Descr: Text;
        DescriptionCaption: Text;
        PictureCaption: Text;
        HeightCaption: Text;
        WidthCaption: Text;
        LengthCaption: Text;
        QtyPerColloCaption: Text;
        QtyPerCollo: Decimal;
        ProgressTxt: Label 'Progress @1@@@@@@@@@@@';
        GR1PriceCaption: Text;
        GR1Price: Decimal;
        GR2PriceCaption: Text;
        GR2Price: Decimal;
        GR1MinPriceCaption: Text;
        GR1MinPrice: Decimal;
        GR2MinPriceCaption: Text;
        GR2MinPrice: Decimal;
        GR1MinQtyCaption: Text;
        GR1MinQty: Decimal;
        GR2MinQtyCaption: Text;
        GR2MinQty: Decimal;
        CIFCaption: Text;
        FOBCaption: Text;
        FOBUSDCaption: Text;
        ColorStockCodeCaption: Text;
        WhereUsedCaption: Text;
        WhereUsed: Text;
        CatalogCaption: Text;
        Catalog: Text;
        CollectionCaption: Text;
        Collection: Text;
        ProductgroupCaption: Text;
        ItemStatusCaption: Text;
        ItemStatus: Text;
        InventoryCaption: Text;
        InventoryQty: Decimal;
        SalesCaption: Text;
        SalesQty: Decimal;
        OutboundTransferCaption: Text;
        OutboundTransferQty: Decimal;
        PurchaseCaption: Text;
        PurchaseQty: Decimal;
        InboundTransferCaption: Text;
        InboundTransferQty: Decimal;
        AvailCaption: Text;
        AvailQty: Decimal;
        MainMaterialCaption: Text;
        MainMaterial: Text;
        Qty40ftHCCaption: Text;
        LoadingVolumCaption: Text;
        VolumepackedCaption: Text;
        VolumeM3Caption: Text;
        GrossWeightCaption: Text;
        NetWeightCaption: Text;
        SeatHeightCaption: Text;
        SeatWidthCaption: Text;
        SeatDepthCaption: Text;
        ArmrestHeightCaption: Text;
        ClearanceTableCaption: Text;
        BaseUoMCaption: Text;
        CostRevaluedCaption: Text;
        PurchaseCurrencyCodeCaption: Text;
        PurchasePriceCaption: Text;
        PurchaseVendorNoCaption: Text;
        PurchaseVendorNameCaption: Text;
        PurchaseVendorName: Text;
        VendorItemNoCaption: Text;
        CountryOriginCaption: Text;
        CountryPurchasedCaption: Text;
        OnlyforCustomerGroupCaption: Text;
        OnlyforCustomerCaption: Text;
        CreatedAtCaption: Text;
        CreatedAt: Date;
        DontExportCaption: Text;
        EndOfLifeCaption: Text;
        EndOfLife: Boolean;
        DateEndOfLifeCaption: Text;
        DateEndOfLife: Text;

    local procedure GetImageName() Result: Text
    var
        PRFN_IntegrationMapping: Record "PRFN_Integration Mapping";
        Item: Record Item;
    begin
        //Result := 'GroupImage';
        //Result := 'ProductImage';
        Result := 'Image';

        PRFN_IntegrationMapping.SetRange("Table No.", DATABASE::Item);
        PRFN_IntegrationMapping.SetRange("Field No.", Item.FieldNo(Picture));
        PRFN_IntegrationMapping.SetFilter(XPAth, '<>%1');
        if PRFN_IntegrationMapping.FindFirst() then
            Result := PRFN_IntegrationMapping.XPAth;
    end;

    local procedure GetCaptions()
    begin
        CurrReport.Language := 2067; //=nlb
        CalculateDateCaption := GetCaption('Calculate Date', 'Berekeningsdatum');
        NoCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("No."), 'Nr.');
        PictureCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo(Picture), 'Foto');
        DescriptionCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo(Description), 'Omschrijving');
        HeightCaption := GetCaption('Height', 'H');
        WidthCaption := GetCaption('Width', 'W');
        LengthCaption := GetCaption('Length', 'D');
        QtyPerColloCaption := GetCaption('Qty. per Collo', 'Aantal verpakt per colli');
        GR1PriceCaption := GetCaption('GR1', 'GR1');
        GR2PriceCaption := GetCaption('GR2', 'GR2');
        GR1MinPriceCaption := GetCaption('GR1 min Qty Price', 'GR1 prijs min qty');
        GR2MinPriceCaption := GetCaption('GR2 min Qty Price', 'GR2 prijs min qty');
        GR1MinQtyCaption := GetCaption('GR1 min Qty', 'GR1 min Qty');
        GR2MinQtyCaption := GetCaption('GR2 min Qty', 'GR2 min Qty');
        CIFCaption := GetCaption('CIF', 'CIF');
        FOBCaption := GetCaption('FOB', 'FOB');
        FOBUSDCaption := GetCaption('FOB USD', 'FOB USD');
        ColorStockCodeCaption := GetCaption('Color stock code', 'Color stock code');
        WhereUsedCaption := GetCaption('Where used', 'Where used');
        CatalogCaption := GetCaption('Catalog', 'Catalog');
        CollectionCaption := GetCaption('Collection', 'Collectie');
        ProductgroupCaption := GetCaption('Productgroup', 'Productgroep');
        ItemStatusCaption := GetCaption('Item Status', 'Artikel status');

        InventoryCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo(Inventory), 'Voorraad');
        SalesCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Qty. on Sales Order"), 'Aantal in verkooporders');
        OutboundTransferCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Trans. Ord. Shipment (Qty.)"), 'Aantal in uitgaande transfers');
        PurchaseCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Qty. on Purch. Order"), 'Aantal in inkooporders');
        InboundTransferCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Trans. Ord. Receipt (Qty.)"), 'Aantal in binnenkomende transfers');
        AvailCaption := GetCaption('Available Inventory', 'Beschikbaar voorraad');

        MainMaterialCaption := GetCaption('Main Material', 'Hoofd materiaal');
        Qty40ftHCCaption := GetCaption('Qty 40ft HC', 'Aantal 40ft HC');
        LoadingVolumCaption := GetCaption('Loading Volume', 'Ladings Volume');
        VolumepackedCaption := GetCaption('Volume packed', 'Volume verpakt');
        VolumeM3Caption := GetCaption('m3', 'm3');
        GrossWeightCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Gross Weight"), 'Brutogewicht');
        NetWeightCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Net Weight"), 'Nettogewicht');
        SeatHeightCaption := GetCaption('Seat Height', 'Hoogte zitting');
        SeatWidthCaption := GetCaption('Seat Width', 'Breedte zitting');
        SeatDepthCaption := GetCaption('Seat Depth', 'Diepte zitting');
        ArmrestHeightCaption := GetCaption('Armrest Height', 'Hoogte armleuning');
        ClearanceTableCaption := GetCaption('Clearance Table', 'Clearance Table');
        BaseUoMCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Base Unit of Measure"), 'Basiseenheid');
        CostRevaluedCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Cost is Adjusted"), 'Kostprijs geherwaardeerd');
        PurchaseCurrencyCodeCaption := GetFieldCaption(DATABASE::"Purchase Price", PurchasePrice.FieldNo("Currency Code"), 'Valutacode');
        PurchasePriceCaption := GetFieldCaption(DATABASE::"Purchase Price", PurchasePrice.FieldNo("Direct Unit Cost"), 'Kostprijs');
        PurchaseVendorNoCaption := GetFieldCaption(DATABASE::"Purchase Price", PurchasePrice.FieldNo("Vendor No."), 'Leveranciersnr.');
        PurchaseVendorNameCaption := GetFieldCaption(DATABASE::Vendor, Vendor.FieldNo(Name), 'Naam');
        VendorItemNoCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Vendor Item No."), 'Artikelnr. leverancier');
        CountryOriginCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Country/Region of Origin Code"), 'Land/regio van oorsprong');
        CountryPurchasedCaption := GetFieldCaption(DATABASE::Item, Item.FieldNo("Country/Region Purchased Code"), 'Land/regio van aankoop');
        OnlyforCustomerGroupCaption := GetCaption('Only for Customergroup', 'Uitsluitend voor klantengroep');
        OnlyforCustomerGroupCaption := GetCaption('Only for Customer', 'Uitsluitend voor klant');
        CreatedAtCaption := GetCaption('Created At', 'Aangemaakt op');
        DontExportCaption := GetCaption('Dont Export', 'Niet opnemen in export');
        EndOfLifeCaption := GetCaption('End-of-life', 'End-of-life');
        DateEndOfLifeCaption := GetCaption('Date EOL', 'Datum EOL');
    end;

    local procedure GetCaption(ENUcaption: Text; DefaultNLBcaption: Text) Result: Text
    var
        STDR_ReportTranslationMgt: Codeunit "STDR_Report Translation Mgt";
    begin
        Result := STDR_ReportTranslationMgt.GetTransl(report::"VDC Price List", 'NLB', ENUcaption);
        if Result = '' then begin
            Result := DefaultNLBcaption;
            if Result = '' then
                Result := ENUcaption;
        end;
    end;

    local procedure GetFieldCaption(TableNo: Integer; FieldNo: Integer; DefaultNLBcaption: Text) Result: Text
    var
        STDR_ReportTranslationMgt: Codeunit "STDR_Report Translation Mgt";
        RecRef: RecordRef;
        FldRef: FieldRef;

    begin
        if TableNo = 0 then
          exit(DefaultNLBcaption);
        
        RecRef.Open(TableNo);
        if RecRef.FieldExist(FieldNo) then begin
          FldRef := RecRef.Field(FieldNo);
          Result := STDR_ReportTranslationMgt.GetTransl(report::"VDC Price List", 'NLB', FldRef.Name());
          if Result = '' then
            Result := DefaultNLBcaption;
          if Result = '' then
            Result := FldRef.Caption();
        end;
    end;

    local procedure GetPerfionData()
    var
        ResizeTxt: Text;
        d: Date;
    begin
        Clear(TempBlob);
        Clear(WhereUsed);
        Clear(Catalog);
        Clear(Collection);
        Clear(ItemStatus);
        Clear(MainMaterial);
        Clear(EndOfLife);
        Clear(DateEndOfLife);

        if Item."PRFN_Record ID" <> 0 then begin
            //get image from perfion server
            //ResizeTxt := '&size=50x50';
            PRFN_CallPerfionMgt.SetSkipDialog(true);
            PRFN_CallPerfionMgt.TempBlobLoadPerfionItemImageName(GetImageName(), Item."No.", Item."PRFN_Record ID", ResizeTxt, TempBlob, false);

            //get data from perfion server
            PerfionFldNameArray[1] := 'WhereUsed';
            PerfionFldNameArray[2] := 'Configuration';
            PerfionFldNameArray[3] := 'Collection';
            PerfionFldNameArray[4] := 'ItemStatus';
            PerfionFldNameArray[5] := 'MainMaterial';
            PerfionFldNameArray[6] := 'EOLDATE';
            PRFN_CallPerfionMgt.GetPerfionItemDataToTxtArray(Item."No.", 'NLB', Item."PRFN_Record ID", false, PerfionFldNameArray, PerfionFldValueArray);
            WhereUsed := PerfionFldValueArray[1];
            Catalog := PerfionFldValueArray[2];
            Collection := PerfionFldValueArray[3];
            ItemStatus := PerfionFldValueArray[4];
            MainMaterial := PerfionFldValueArray[5];
            d := PerfionDTtoDate(PerfionFldValueArray[6]);
            DateEndOfLife := format(d);
            EndOfLife := DateEndOfLife <> '';
        end;
    end;

    [TryFunction]
    local procedure PerfionDTtoDT(Txt: Text;var Result: DateTime)
    var
    PRFN_ProcessResult: Codeunit "PRFN_Process Result";
    begin
        //2017-04-20T00:00:00
        //1234567890123456789
        Result := PRFN_ProcessResult.CreateDateTimeFromText(Txt);
    end;

    local procedure PerfionDTtoDate(Txt: Text) Result: Date
    var
    dt: DateTime;
    begin
        PerfionDTtoDT(Txt,dt);
        if dt <> 0DT then       
          Result := DT2Date(dt);
    end;

    local procedure GetDesc()
    begin
        Descr := Item.Description;
        if Item."Description 2" <> '' then begin
            Descr := Item.Description + ' ' + Item."Description 2";
            if Item.Description = '' then
                Descr := Item."Description 2";
        end;
    end;

    local procedure GetBaseUoM()
    begin
        Clear(ItemUnitofMeasure);
        if ItemUnitofMeasure.Get(Item."No.", Item."Base Unit of Measure") then;
    end;

    local procedure GetQtyPerCollo()
    var
        ItemUnitofMeasure2: Record "Item Unit of Measure";
    begin
        QtyPerCollo := 0;
        //check if there is an extra uom besides the base uom
        ItemUnitofMeasure2.SetRange("Item No.", Item."No.");
        ItemUnitofMeasure2.SetFilter(Code, '<>%1', Item."Base Unit of Measure");
        if not ItemUnitofMeasure2.FindFirst() then
            exit;
        //check if there is only one extra uom
        if ItemUnitofMeasure2.Next() <> 0 then
            exit;

        QtyPerCollo := ItemUnitofMeasure2."Qty. per Unit of Measure";
    end;

    local procedure GetGRPriceInfo()
    var
        SalesPrice: Record "Sales Price";
    begin
        Clear(GR1Price);
        Clear(GR1MinPrice);
        Clear(GR1MinQty);
        Clear(GR2Price);
        Clear(GR2MinPrice);
        Clear(GR2MinQty);

        SalesPrice.SetCurrentKey("Item No.", "Sales Type", "Starting Date");
        SalesPrice.SetRange("Item No.", Item."No.");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, CalculateDate);
        SalesPrice.SetRange("Starting Date", 0D, CalculateDate);
        SalesPrice.SetRange("Minimum Quantity", 0);
        SalesPrice.SetRange("Sales Code", 'GR1');
        if SalesPrice.FindLast() then
            GR1Price := SalesPrice."Unit Price";
        SalesPrice.SetRange("Sales Code", 'GR2');
        if SalesPrice.FindLast() then
            GR2Price := SalesPrice."Unit Price";

        SalesPrice.SetFilter("Minimum Quantity", '>0');
        SalesPrice.SetRange("Sales Code", 'GR1');
        if SalesPrice.FindLast() then begin
            GR1MinPrice := SalesPrice."Unit Price";
            GR1MinQty := SalesPrice."Minimum Quantity";
        end;
        SalesPrice.SetRange("Sales Code", 'GR2');
        if SalesPrice.FindLast() then begin
            GR1MinPrice := SalesPrice."Unit Price";
            GR1MinQty := SalesPrice."Minimum Quantity";
        end;
    end;

    local procedure CalcAvail()
    var
        Supply: Decimal;
        Demand: Decimal;
    begin
        Item.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order", "Trans. Ord. Receipt (Qty.)", "Trans. Ord. Shipment (Qty.)");

        InventoryQty := Item.Inventory;
        SalesQty := Item."Qty. on Sales Order";
        OutboundTransferQty := Item."Trans. Ord. Shipment (Qty.)";
        InboundTransferQty := Item."Trans. Ord. Receipt (Qty.)";

        //calculate available inventory
        Supply := PurchaseQty + InboundTransferQty;
        Demand := SalesQty + OutboundTransferQty;
        AvailQty := InventoryQty + Supply - Demand;
    end;

    local procedure GetVendor()
    begin
        Clear(Vendor);
        if Vendor.Get(Item."Vendor No.") then begin
            PurchaseVendorName := Vendor.Name;
            if Vendor."Name 2" <> '' then begin
                PurchaseVendorName := Vendor.Name + ' ' + Vendor."Name 2";
                if Vendor.Name = '' then
                    PurchaseVendorName := Vendor."Name 2";
            end;
        end;
    end;

    local procedure GetItemVendor()
    begin
        Clear(ItemVendor);
        if Item."Vendor No." <> '' then begin
            ItemVendor.SetRange("Vendor No.", Item."Vendor No.");
            ItemVendor.SetRange("Item No.", Item."No.");
            ItemVendor.SetRange("Variant Code", '');
            if not ItemVendor.FindFirst() then begin
                ItemVendor.SetRange("Variant Code");
                if ItemVendor.FindFirst() then;
            end;
        end;
    end;

    local procedure GetPurchPrice()
    begin
        Clear(PurchasePrice);

        if Item."Vendor No." = '' then
            exit;

        PurchasePrice.SetCurrentKey("Item No.", "Vendor No.", "Starting Date");
        PurchasePrice.SetRange("Item No.", Item."No.");
        PurchasePrice.SetRange("Vendor No.", Item."Vendor No.");
        PurchasePrice.SetFilter("Ending Date", '%1|>=%2', 0D, CalculateDate);
        PurchasePrice.SetRange("Starting Date", 0D, CalculateDate);
        if PurchasePrice.FindLast() then;
    end;

    local procedure GetCreatedAt()
    var
        PFLW_ProcessFlowLogEntry: Record "PFLW_Process Flow Log Entry";
    begin
        Clear(CreatedAt);
        PFLW_ProcessFlowLogEntry.SetCurrentKey("Source No.", "Functional Area No.");
        PFLW_ProcessFlowLogEntry.SetRange("Source No.", Item."No.");
        PFLW_ProcessFlowLogEntry.SetRange("Functional Area No.", 1);
        PFLW_ProcessFlowLogEntry.SetRange(Direction, PFLW_ProcessFlowLogEntry.Direction::Start);
        if PFLW_ProcessFlowLogEntry.FindFirst() then
            CreatedAt := DT2Date(PFLW_ProcessFlowLogEntry."Changed At");
    end;
}

