report 50010 "Transport Journey Document"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Transport Journey Document.rdlc';
    Caption = 'Transport Journey Document';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(OUCT_TransportInformation; "OUCT_Transport Information")
        {
            column(DocumentNo_; "No.")
            {
            }
            column(CompInfoPicture; CompanyInfo.Picture)
            { }
            column(BillofLadingNo; "Bill of Lading No.")
            {
            }
            column(ActualDateofArrival; "Actual Date of Arrival")
            {
            }
            column(CarrierName; "Carrier Name")
            {
            }
            column(ContainerID; "Container ID")
            {
            }
            column(ContainerType; "Container Type")
            {
            }
            column(PlannedDepartureDate; "Planned Departure Date")
            {
            }
            column(DepartureDate; "Departure Date")
            {
            }
            column(ExpectedDateofArrival; "Expected Date of Arrival")
            {
            }
            column(GrossWeight; "Gross Weight")
            {
            }
            column(NetWeight; "Net Weight")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(PortofDischarge; "Port of Discharge")
            {
            }
            column(PortofLoading; "Port of Loading")
            {
            }
            column(SealNo; "Seal No.")
            {
            }
            column(TareWeight; "Tare Weight")
            {
            }
            column(ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(ShippingAgentCode; "Shipping Agent Code")
            {
            }
            column(ShippingAgentServiceCode; "Shipping Agent Service Code")
            {
            }
            column(TrackingNo; "Tracking No.")
            {
            }
            column(Cubage; Cubage)
            {
            }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(ReportTitleCopyText; STRSUBSTNO(Text001Txt, CopyText))
                    { }
                    column(CurrRepPageNo; Text002Txt)
                    { }
                    column(CompanyAddr1; CompanyAddr[1])
                    { }
                    column(CompanyAddr2; CompanyAddr[2])
                    { }
                    column(CompanyAddr3; CompanyAddr[3])
                    { }
                    column(CompanyAddr4; CompanyAddr[4])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    { }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    { }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    { }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    { }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    { }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PageCaption; PageCaptionLbl)
                    { }
                    column(DocumentNoCaption; DocumentNoLbl)
                    { }
                    column(OrderNoCaption; OrderNoLbl)
                    { }
                    column(ShipToNameCaption; shiptonameLbl)
                    { }
                    column(ShipToAddressCaption; ShipToAddressLbl)
                    { }
                    column(PhoneNoCaption; PhoneNoLbl)
                    { }
                    column(PackagedVolumeCaption; PackagedVolumeLbl)
                    { }
                    column(NoOfPackagesCaption; NoOfPackagesLbl)
                    { }
                    column(PlannedDepartureDateCaption; PlannedDepartureDateLbl)
                    { }
                    column(ExpedtedDateCaption; ExpedtedDateLbl)
                    { }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    { }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                    { }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    { }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    { }
                    column(CompanyInfoBankAccNoCaption; CompanyInfoBankAccNoCaptionLbl)
                    { }
                    column(CurrentDateCaption; CurrentDateLbl)
                    { }
                    column(CurrentDate; CurrentDate)
                    { }
                    column(TotalLbl; totalLbl)
                    { }
                    dataitem(OUCT_TransportContent; "OUCT_Transport Content")
                    {
                        DataItemLink = "Transport No." = field("No.");
                        DataItemLinkReference = OUCT_TransportInformation;
                        DataItemTableView = SORTING("Source No.", "Source Line No.") ORDER(Ascending);
                        column(LineNo; "Line No.")
                        { }
                        column(SourceNo; "Source No.")
                        { }
                        column(ShipToName; ShipToName)
                        { }
                        column(ShipToAddress; ShipToAddress)
                        { }
                        column(ShipToPostCodeCity; ShipToPostCodeCity)
                        { }
                        column(FullShipToAddress; FullShipToAddress)
                        { }
                        column(ShipToPhoneNo; ShipToPhoneNo)
                        { }
                        column(CustTptComments; CustTptComments)
                        { }
                        column(LineVolume; LineVolume)
                        {
                            DecimalPlaces = 0 : 3;
                        }
                        column(LinePackages; LinePackages)
                        { }
                        column(TotalPackages; TotalPackages)
                        { }
                        column(TotalVolume; TotalVolume)
                        {
                            DecimalPlaces = 0 : 3;
                        }
                        trigger OnAfterGetRecord()
                        var
                            ItemUOM: Record "Item Unit of Measure";
                            WhseActLine: Record "Warehouse Activity Line";
                            RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
                            WhseShipmentLine: Record "Warehouse Shipment Line";
                        begin
                            GetSourceInformation();

                            if not WhseShipmentLine.Get("Whse. Document No.", "Whse. Document Line No.") then
                                exit;

                            If ItemUOM.Get("Item No.", "Unit of Measure Code") then
                                if WhseShipmentLine."Qty. to Ship" > 0 then
                                    LineVolume := ItemUOM."Loading Volume" * WhseShipmentLine."Qty. to Ship"
                                else
                                    LineVolume := ItemUOM."Loading Volume" * WhseShipmentLine.Quantity
                            else
                                LineVolume := 0;

                            TotalVolume := TotalVolume + LineVolume;

                            LinePackages := 0;
                            WhseActLine.reset();
                            WhseActLine.Setrange("Activity Type", WhseActLine."Activity Type"::Pick);
                            WhseActLine.SetRange("Whse. Document Type", WhseActLine."Whse. Document Type"::Shipment);
                            WhseActLine.SetRange("Whse. Document No.", WhseShipmentLine."No.");
                            WhseActLine.SetRange("Whse. Document Line No.", WhseShipmentLine."Line No.");
                            WhseActLine.Setrange("Action Type", WhseActLine."Action Type"::Take);
                            if WhseActLine.FindSet() then
                                repeat
                                    LinePackages := LinePackages + WhseActLine."No. of Packages"
                                until WhseActLine.next() = 0
                            else begin
                                RegisteredWhseActivityLine.Reset();
                                RegisteredWhseActivityLine.Setrange("Activity Type", RegisteredWhseActivityLine."Activity Type"::Pick);
                                RegisteredWhseActivityLine.SetRange("Whse. Document Type", RegisteredWhseActivityLine."Whse. Document Type"::Shipment);
                                RegisteredWhseActivityLine.SetRange("Whse. Document No.", WhseShipmentLine."No.");
                                RegisteredWhseActivityLine.SetRange("Whse. Document Line No.", WhseShipmentLine."Line No.");
                                RegisteredWhseActivityLine.Setrange("Action Type", RegisteredWhseActivityLine."Action Type"::Take);
                                if RegisteredWhseActivityLine.FindSet() then
                                    repeat
                                        LinePackages := LinePackages + RegisteredWhseActivityLine."No. of Packages";
                                    until RegisteredWhseActivityLine.next() = 0;
                            end;

                            TotalPackages := +TotalPackages + LinePackages;
                        end;
                    }

                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        clear(CompanyInfo.Picture);
                    end else
                        CompanyInfo.CalcFields(Picture);

                    OutputNo := OutputNo + 1;
                    TotalVolume := 0;
                    TotalPackages := 0;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                FormatAddressFields();
            end;

            trigger OnPreDataItem()
            begin
                if LanguageCode <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID(LanguageCode);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(Language; LanguageCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Language';
                        TableRelation = Language;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.GET();
        CurrentDate := TODAY();
    end;

    var
        Language: Record Language;
        CompanyInfo: Record "Company Information";
        FormatDocument: Codeunit "Format Document";
        FormatAddr: Codeunit "Format Address";
        LineVolume: Decimal;
        LinePackages: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        CompanyAddr: array[8] of Text[50];
        ShippingAddr: array[8] of Text[50];
        CurrentDate: Date;
        CopyText: Text;
        ShipToName: text;
        ShipToAddress: text;
        ShipToPostCodeCity: text;
        FullShipToAddress: text;
        CustTptComments: text;
        ShipToPhoneNo: text;
        LanguageCode: Code[10];
        Text001Txt: Label 'Transport Journey Document %1', Comment = '%1 = Document No.';
        Text002Txt: Label 'Page %1', Comment = '%1 = Page No.';
        PageCaptionLbl: Label 'Page';
        PackagedVolumeLbl: Label 'Packaged Volume';
        NoOfPackagesLbl: Label 'No. of Packages';
        DocumentNoLbl: Label 'Transport No.';
        OrderNoLbl: label 'Order No.';
        ShipToNameLbl: Label 'Name';
        ShipToAddressLbl: label 'Ship-to Address';
        PhoneNoLbl: Label 'Phone No.';
        PlannedDepartureDateLbl: Label 'Planned Departure Date';
        ExpedtedDateLbl: Label 'Expected Date of Arrival';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Registration No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: Label 'Account No.';
        CurrentDateLbl: Label 'Date';
        TotalLbl: Label 'Total';
        TotalVolume: Decimal;
        TotalPackages: Decimal;

    local procedure InitializeRequest(NewNoOfCopies: Integer)
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    local procedure FormatAddressFields()
    var
        RespCenter: Record "Responsibility Center";
    begin
        FormatAddr.GetCompanyAddr('', RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.FormatAddr(ShippingAddr,
          CompanyInfo."Ship-to Name",
          CompanyInfo."Ship-to Name 2",
          CompanyInfo."Ship-to Contact",
          CompanyInfo."Ship-to Address",
          CompanyInfo."Ship-to Address 2",
          CompanyInfo."Ship-to City",
          CompanyInfo."Ship-to Post Code",
          CompanyInfo."Ship-to County",
          CompanyInfo."Ship-to Country/Region Code");
    end;

    local procedure GetSourceInformation()
    var
        SalesHeader: Record "Sales Header";
        ShipToAddr: Record "Ship-to Address";
        SellToCont: Record Contact;
        SellToCust: Record Customer;
        Printcode: record "STDR_Print Code";
        CustComm: record "Comment Line";
        TransferHeader: Record "Transfer Header";
    begin
        ShipToName := '';
        ShipToAddress := '';
        ShipToPostCodeCity := '';
        FullShipToAddress := '';
        ShipToPhoneNo := '';
        CustTptComments := '';

        with OUCT_TransportContent do
            IF SalesHeader.Get(SalesHeader."Document Type"::Order, "Source No.") then begin
                ShipToName := SalesHeader."Ship-to Name";
                ShipToAddress := SalesHeader."Ship-to Address";
                ShipToPostCodeCity := DELCHR(SalesHeader."Ship-to Post Code" + ' ' + SalesHeader."Ship-to City", '<', ' ');
                FullShipToAddress := ShipToName + ShiptoAddress + ShipToPostCodeCity;

                If ShipToAddr.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN
                    ShipToPhoneNo := ShipToAddr."Phone No."
                else
                    If SellTocont.Get(Salesheader."Sell-to Contact No.") and (SalesHeader."Sell-to Contact No." <> '') THEN
                        ShipToPhoneNo := SellToCont."Phone No."
                    else
                        if SellToCust.Get(Salesheader."Sell-to Customer No.") then
                            ShipToPhoneNo := SellToCust."Phone No.";

                Printcode.setrange("Transport Information", true);
                IF Printcode.FindSet() then begin
                    CustComm.SetRange("Table Name", CustComm."Table Name"::Customer);
                    CustComm.setrange("No.", SalesHeader."Sell-to Customer No.");
                    repeat
                        CustComm.setrange("STDR_Print Code", Printcode.Code);
                        If CustComm.FindSet() then
                            repeat
                                CustTptComments := CustTptComments + CustComm.Comment;
                            until CustComm.next() = 0;
                    until Printcode.Next() = 0;
                end;
            end else begin
                if TransferHeader.Get("Source No.") then begin
                    ShipToName := TransferHeader."Transfer-to Name";
                    ShipToAddress := TransferHeader."Transfer-to Address";
                    ShipToPostCodeCity := DELCHR(TransferHeader."Transfer-to Post Code" + ' ' + TransferHeader."Transfer-to City", '<', ' ');
                    FullShipToAddress := ShipToName + ShiptoAddress + ShipToPostCodeCity;
                end;
            end;


    end;
}
