report 50003 "Transport Document"
{
    // version OUCT1.0.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Transport Document.rdlc';
    Caption = 'Transport Document';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(OUCTTransportInfo; "OUCT_Transport Information")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "No.", Status, "Carrier Name";
            RequestFilterHeading = 'Transport Document';
            column(DocumentNo_; "No.")
            {
            }
            column(PlannedDepartureDate; "Planned Departure Date")
            {
            }
            column(ExpectedDateofArrival; "Expected Date of Arrival")
            {
            }
            column(ShippingAgentCode; "Shipping Agent Code")
            {
            }
            column(CompInfoPicture; CompanyInfo.Picture)
            { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(ReportTitleCopyText; STRSUBSTNO(Text001Txt, CopyText))
                    {
                    }
                    column(CurrRepPageNo; Text002Txt)
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(DocumentNoCaption; DocumentNoLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoLbl)
                    {
                    }
                    column(ShipToNameCaption; shiptonameLbl)
                    {
                    }
                    column(ShipToAddressCaption; ShipToAddressLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoLbl)
                    {
                    }
                    column(PackagedVolumeCaption; PackagedVolumeLbl)
                    { }

                    column(PlannedDepartureDateCaption; PlannedDepartureDateLbl)
                    {
                    }
                    column(ExpedtedDateCaption; ExpedtedDateLbl)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCaption; CompanyInfoBankAccNoCaptionLbl)
                    {
                    }
                    column(CurrentDateCaption; CurrentDateLbl)
                    {
                    }
                    column(CurrentDate; CurrentDate)
                    {
                    }
                    dataitem(OUCTTransportCont; "OUCT_Transport Content")
                    {
                        DataItemLink = "Transport No." = FIELD ("No.");
                        DataItemLinkReference = OUCTTransportInfo;
                        DataItemTableView = SORTING ("Source No.", "Source Line No.") ORDER(Ascending);
                        column(LineNo; "Line No.")
                        {
                        }
                        column(SourceNo; "Source No.")
                        {
                        }
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

                        trigger OnAfterGetRecord()
                        var
                            ItemUOM: Record "Item Unit of Measure";
                        begin
                            GetSourceInformation();

                            If ItemUOM.Get("Item No.", "Unit of Measure Code") then begin
                                Calcfields("Quantity");
                                LineVolume := ItemUOM.Cubage * "Quantity";
                            end else
                                LineVolume := 0;
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
                FormatAddressFields(OUCTTransportInfo);
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
        }
    }

    labels
    {
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
        Text001Txt: Label 'Transport Document %1', Comment = '%1 = Document No.';
        Text002Txt: Label 'Page %1', Comment = '%1 = Page No.';
        PageCaptionLbl: Label 'Page';
        PackagedVolumeLbl: Label 'Packaged Volume';
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



    local procedure InitializeRequest(NewNoOfCopies: Integer)
    begin
        NoOfCopies := NewNoOfCopies;
    end;

    local procedure FormatAddressFields(TransportInformation: Record "OUCT_Transport Information")
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
    begin
        ShipToName := '';
        ShipToAddress := '';
        ShipToPostCodeCity := '';
        FullShipToAddress := '';
        ShipToPhoneNo := '';
        CustTptComments := '';

        with OUCTTransportCont do
            If SalesHeader.Get(SalesHeader."Document Type"::Order, "Source No.") then begin
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

            end;
    end;
}

