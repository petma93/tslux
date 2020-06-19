report 50004 "Shipping Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Shipping Label.rdlc';
    Caption = 'Shipping Label';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(Header; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING(Type, "No.") WHERE(Type = FILTER(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(DocNo; "No.")
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
            column(RefCaption; RefCaption)
            { }
            column(HeaderFds1; HeaderFds[1])
            {
            }
            column(HeaderFds2; HeaderFds[2])
            {
            }
            column(HeaderFds3; HeaderFds[3])
            {
            }
            column(HeaderFds4; HeaderFds[4])
            {
            }
            column(HeaderFds5; HeaderFds[5])
            {
            }
            column(FontFamily; FontFamily)
            {
            }
            column(Font; FontArray[1])
            {
            }
            column(FontSize1; FontArray[2])
            {
            }
            column(FontSize2; FontArray[3])
            {
            }
            column(FontSize3; FontArray[4])
            {
            }
            column(FontSize4; FontArray[5])
            {
            }
            column(FontSize5; FontArray[6])
            {
            }
            column(FontSize6; FontArray[7])
            {
            }

            dataitem(LineFilter; "Warehouse Activity Line")
            {
                RequestFilterFields = "Line No.", "Item No.";
                DataItemTableView = SORTING("Activity Type", "No.", "Line No.") WHERE("Action Type" = CONST(Take));
                DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                trigger OnPreDataItem()
                begin
                    CurrReport.Break();
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(OutputNo; OutputNo)
                {
                }
                dataitem(Line; "Integer")
                {
                    DataItemLinkReference = Header;
                    DataItemTableView = SORTING(Number);
                    column(LineEntryNo; LineEntryNo)
                    {
                    }
                    column(LineFormatTxt; LineFormatTxt)
                    {
                    }
                    column(LineType; LineTypeNo)
                    {
                    }
                    column(DestName; DestName)
                    { }
                    column(DestAddress; DestAddress)
                    { }
                    column(DestAddress2; DestAddress2)
                    { }
                    column(DestPostCodeCity; DestPostCodeCity)
                    { }
                    column(DestCountryCode; DestCountryCode)
                    { }
                    column(DestCountryName; DestCountryName)
                    { }
                    column(ItemNo; tmpLine."Item No.")
                    { }
                    column(ItemDescr; STDR_ReportManagement.GetLineDesc(LineIndent, tmpLine.Description, tmpLine."Description 2"))
                    { }
                    column(OrderNo; TmpLine."Source No.")
                    { }
                    column(SourceRef; SourceRef)
                    { }
                    column(AssemblyRef; AssemblyRef)
                    { }
                    column(AssemblyQty; AssemblyQty)
                    { }
                    column(Qty; NoOfPackages)
                    { }

                    dataitem(DetailLineLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(DetailLineEntryNo; Number)
                        {
                            //
                        }
                        column(DetailLineType; DetLineTypeNo)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, NoOfPackages);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TmpLine.FINDSET()
                        else
                            TmpLine.NEXT();

                        // reset detail buffer line
                        CLEAR(TempDetailBuffer);
                        TempDetailBuffer.DELETEALL();

                        // fill line fields
                        FillLineFds();

                        NoOfPackages := TmpLine."No. of Packages";
                        IF NoOfPackages = 0 then
                            NoOfPackages := 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, TmpLine.COUNT());
                        LineEntryNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //set outputno
                    if Number > 1 then
                        OutputNo += 1;

                    //determine document name and add copy text if number is bigger then one
                    DocName := STDR_ReportManagement.GetDocName(Number);
                    STDR_ReportManagement.AddTxtValue(1, HeaderFds[4], DocName);
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.PREVIEW() then
                        // Update field "No. Printed" in header
                        STDR_ReportManagement.HeaderCountPrinted();
                end;

                trigger OnPreDataItem()
                begin
                    //determine no of copies of this document
                    SETRANGE(Number, 1, STDR_ReportManagement.GetNoOfLoops(NoOfExtraCopies));
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // setup report management codeunit with current record values
                STDR_ReportManagement.SetCurrentRec("Language Code", '', WORKDATE(), '', Header);

                // Set the options set by user on the requestpage
                STDR_ReportManagement.SetReportOptionItemTracking(ShowItemTracking);
                STDR_ReportManagement.SetReportOptionSumUpLines(SumUpLines);
                STDR_ReportManagement.SetReportOptionBreakBulk(BreakbulkFilter);

                // get report setup record
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);

                // set CurrReport.Language
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();

                // fill buffer with all lines to print. If no lines exists also skip header
                if not FillWhseActLineBuffer(TmpLine, Header) then
                    CurrReport.SKIP();

                TmpLine.SetCurrentKey(DestinationName, "Source No.");

                // fill header fields
                FillHeaderFds();
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
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfExtraCopies; NoOfExtraCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Extra Copies';
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
        // setup report management codeunit with current reportid
        STDR_ReportManagement.InitReport(CurrReport.OBJECTID(false));

        // get default values for request page
        STDR_ReportManagement.InitReportReqPageBreakBulk(BreakbulkFilter, BreakbulkFilterVisible, FromInventory);
    end;

    trigger OnPreReport()
    begin
        // setup report management codeunit with preview
        STDR_ReportManagement.SetPreview(CurrReport.PREVIEW());
    end;

    var
        TempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        TmpLine: Record "Warehouse Activity Line" temporary;
        STDR_ReportSetup: Record "STDR_Report Setup";
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        ShowItemTracking: Option Default,Yes,No;
        SumUpLines: Option Default,Yes,No;
        BreakbulkFilter: Option Default,Yes,No;
        [InDataSet]
        BreakbulkFilterVisible: Boolean;
        FromInventory: Boolean;
        DocName: Text;
        HeaderFds: array[5] of Text;
        CompanyAddr: array[8] of Text[80];
        FontFamily: Text;
        LineFormatTxt: Text;
        SourceRef: text;
        AssemblyRef: text;
        DestName: text;
        DestAddress: text;
        DestAddress2: text;
        DestPostCodeCity: text[100];
        RefCaption: text;
        DestCountryCode: code[10];
        DestCountryName: text[50];
        NoOfExtraCopies: Integer;
        NoOfPackages: Integer;
        OutputNo: Integer;
        LineEntryNo: Integer;
        LineIndent: Integer;
        LineBold: Boolean;
        LineTxt: array[20] of Text;
        "Language Code": Code[20];
        LineTypeNo: Integer;
        DetLineTypeNo: Integer;
        AssemblyQty: Text;
        FontArray: array[8] of Text;

    procedure SetInventory(NewValue: Boolean)
    begin
        FromInventory := NewValue;
    end;

    procedure FillWhseActLineBuffer(var TmpLineBuffer2: Record "Warehouse Activity Line" temporary; Header2: Record "Warehouse Activity Header") LinesExist: Boolean
    var
        WhseActLine: Record "Warehouse Activity Line";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        Location: Record Location;
    begin
        with WhseActLine do begin
            TmpLineBuffer2.RESET();
            TmpLineBuffer2.DELETEALL();
            CopyFilters(LineFilter);
            SETCURRENTKEY("Activity Type", "No.", "Sorting Sequence No.");
            SETRANGE("Activity Type", Header.Type);
            SETRANGE("No.", Header."No.");
            SetRange("Action Type", "Action Type"::Take);
            if STDR_ReportSetup."Set Breakbulk Filter" then
                SETRANGE("Original Breakbulk", false);
            if FINDSET() then
                repeat
                    if STDR_ReportSetup."Sum up Lines" then begin
                        TmpLineBuffer2.SETCURRENTKEY("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                        TmpLineBuffer2.SETRANGE("Activity Type", "Activity Type");
                        TmpLineBuffer2.SETRANGE("No.", "No.");
                        TmpLineBuffer2.SETRANGE("Action Type", "Action Type");
                        TmpLineBuffer2.SETRANGE("Zone Code", "Zone Code");
                        TmpLineBuffer2.SETRANGE("Bin Code", "Bin Code");
                        TmpLineBuffer2.SETRANGE("Item No.", "Item No.");
                        TmpLineBuffer2.SETRANGE("Variant Code", "Variant Code");
                        TmpLineBuffer2.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
                        TmpLineBuffer2.SETRANGE("Due Date", "Due Date");
                        TmpLineBuffer2.SETRANGE("Lot No.", "Lot No.");
                        TmpLineBuffer2.SETRANGE("Serial No.", "Serial No.");
                        if Header."Sorting Method" = Header."Sorting Method"::"Ship-To" then begin
                            TmpLineBuffer2.SETRANGE("Destination Type", "Destination Type");
                            TmpLineBuffer2.SETRANGE("Destination No.", "Destination No.");
                        end;
                        if TmpLineBuffer2.FINDFIRST() then begin
                            TmpLineBuffer2.Quantity += Quantity;
                            TmpLineBuffer2."Qty. (Base)" += "Qty. (Base)";
                            TmpLineBuffer2."Qty. Outstanding" += "Qty. Outstanding";
                            TmpLineBuffer2."Qty. Outstanding (Base)" += "Qty. Outstanding (Base)";
                            TmpLineBuffer2."Qty. to Handle" += "Qty. to Handle";
                            TmpLineBuffer2."Qty. to Handle (Base)" += "Qty. to Handle (Base)";
                            TmpLineBuffer2."Qty. Handled" += "Qty. Handled";
                            TmpLineBuffer2."Qty. Handled (Base)" += "Qty. Handled (Base)";
                            TmpLineBuffer2."No. of Packages" += "No. of Packages";
                            TmpLineBuffer2."Source No." := '';
                            if Header."Sorting Method" <> Header."Sorting Method"::"Ship-To" then begin
                                TmpLineBuffer2."Destination Type" := TmpLineBuffer2."Destination Type"::" ";
                                TmpLineBuffer2."Destination No." := '';
                            end;
                            TmpLineBuffer2.MODIFY();
                        end else begin
                            TmpLineBuffer2 := WhseActLine;
                            TmpLineBuffer2.INSERT();
                        end;
                    end else begin
                        TmpLineBuffer2 := WhseActLine;
                        TmpLineBuffer2.INSERT();
                    end;
                until NEXT() = 0;

            TmpLineBuffer2.RESET();
            if TmpLineBuffer2.FindSet() then
                repeat
                    case TmpLineBuffer2."Source Type" OF
                        Database::"Sales Line":
                            IF SalesHeader.Get(TmpLineBuffer2."Source Subtype", TmpLineBuffer2."Source No.") then
                                TmpLineBuffer2.DestinationName := SalesHeader."Ship-to Name";
                        Database::"Transfer Line":
                            IF TransferHeader.Get(TmpLineBuffer2."Source No.") then begin
                                location.Get(TransferHeader."Transfer-to Code");
                                TmpLineBuffer2.DestinationName := location."Name";
                            end;
                    end;
                    TmpLineBuffer2.Modify();
                until TmpLineBuffer2.Next() = 0;

            TmpLineBuffer2.RESET();
            exit(not TmpLineBuffer2.ISEMPTY());
        end; /*with do*/
    end;

    procedure ExamplAddDetailLines(var TheTempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary)
    var
        SpecialEquip: Record "Special Equipment";
    begin
        if (TmpLine."Special Equipment Code" = '') or
           (not SpecialEquip.GET(TmpLine."Special Equipment Code"))
        then
            exit;

        STDR_ReportManagement.DetailLineAdd(TheTempDetailBuffer, TmpLine."No.", TmpLine."Line No.");
        TheTempDetailBuffer."Detail Line Type" := TheTempDetailBuffer."Detail Line Type"::Comment;
        TheTempDetailBuffer.Description := COPYSTR(STDR_ReportManagement.GetLineDesc(1, SpecialEquip.Description, ''), 1, MaxStrLen(TheTempDetailBuffer.Description));
        TheTempDetailBuffer.INSERT();
    end;

    procedure FillHeaderFds()
    var
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "STDR_Report Setup";
        LeftAddr: array[8] of Text[80];
        RightAddr: array[8] of Text[80];
        ExtraAddr: array[8] of Text[80];
        i: Integer;
        Done: Boolean;
    begin
        with Header do begin
            //sometime the companyinfo is overrulled by the responsibilycenter or report setup code.
            //So we use the report_setup var. The report_mgt codeunit has filled/copied this var with the correct values
            CompanyInfo := STDR_ReportSetup;
            STDR_ReportManagement.FormatAddresses(LeftAddr, RightAddr, ExtraAddr, CompanyAddr);

            for i := 1 TO 5 do
                if (CompanyAddr[i] = '') and (not done) then begin
                    IF not CountryRegion.Get(STDR_ReportSetup."Country/Region Code") then
                        clear(CountryRegion);
                    IF CountryRegion.Name <> '' then
                        CompanyAddr[i] := CountryRegion.Name
                    else
                        CompanyAddr[i] := CountryRegion.Code;
                    done := true;
                end;

            //Set per document:fontfamily, fontname, fontsize
            FontFamily := STDR_ReportManagement.GetFontFamily();
            STDR_ReportManagement.GetFontArray(FontArray);

            CLEAR(HeaderFds);

            Refcaption := STDR_ReportManagement.GetTranslCurrRep('Your Reference');

            // 4= Other Header fields
            if STDR_ReportSetup."Show Page No." then
                STDR_ReportManagement.AddTranslValue(2, HeaderFds[4], 'Page %1 of %2');
        end;
    end;

    procedure FillLineFds()
    var
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntryAssembly: record "Reservation Entry";
        AssemblyOrder: record "Assembly Header";
        Location: record Location;
        Country: Record "Country/Region";
        CountryTransl: Record "Country/Region Translation";
        FormatAddr: Codeunit "Format Address";
        County: text[50];
    begin
        SourceRef := '';
        AssemblyRef := '';
        DestName := '';
        DestAddress := '';
        DestAddress2 := '';
        DestPostCodeCity := '';
        DestCountryCode := '';
        DestCountryName := '';
        AssemblyQty := '';

        case TmpLine."Source Type" OF
            Database::"Sales Line":
                IF SalesHeader.Get(tmpLine."Source Subtype", tmpLine."Source No.") then begin
                    DestName := SalesHeader."Ship-to Name";
                    DestAddress := SalesHeader."Ship-to Address";
                    DestAddress2 := SalesHeader."Ship-to Address 2";
                    FormatAddr.FormatPostCodeCity(DestPostCodeCity, county,
                        SalesHeader."Ship-to City", SalesHeader."Ship-to Post Code", SalesHeader."Ship-to County", SalesHeader."Ship-to Country/Region Code");

                    DestCountryCode := SalesHeader."Ship-to Country/Region Code";
                    If CountryTransl.Get(SalesHeader."Ship-to Country/Region Code", STDR_ReportManagement.GetLanguageCode()) then
                        DestCountryName := CountryTransl.Name
                    else
                        if Country.Get(SalesHeader."Ship-to Country/Region Code") then
                            DestCountryName := Country.Name;

                    SourceRef := SalesHeader."Your Reference";
                end;
            Database::"Transfer Line":
                IF TransferHeader.Get(tmpLine."Source No.") then begin
                    location.Get(TransferHeader."Transfer-to Code");
                    DestName := location."Name";
                    DestAddress := location."Address";
                    DestAddress2 := location."Address 2";
                    FormatAddr.FormatPostCodeCity(DestPostCodeCity, county,
                        location."City", location."Post Code", location."County", location."Country/Region Code");

                    DestCountryCode := location."Country/Region Code";
                    If CountryTransl.Get(location."Country/Region Code", STDR_ReportManagement.GetLanguageCode()) then
                        DestCountryName := CountryTransl.Name
                    else
                        if Country.Get(location."Country/Region Code") then
                            DestCountryName := Country.Name;

                    SourceRef := TransferHeader."External Document No.";
                    //Get Assembly Information
                    AssemblyRef := '';
                    ReservationEntry.reset;
                    ReservationEntry.SetRange("Source Type", 5741);
                    ReservationEntry.SetRange("Source ID", TmpLine."Source No.");
                    ReservationEntry.SetRange("Source Ref. No.", TmpLine."Source Line No.");
                    If ReservationEntry.FindFirst then begin
                        ReservationEntryAssembly.reset;
                        ReservationEntryAssembly.SetRange("Entry No.", ReservationEntry."Entry No.");
                        ReservationEntryAssembly.SetRange("Source Type", 901);
                        if ReservationEntryAssembly.findfirst then begin
                            AssemblyOrder.reset;
                            AssemblyOrder.SetRange("Document Type", AssemblyOrder."Document Type"::Order);
                            AssemblyOrder.SetRange("No.", ReservationEntryAssembly."Source ID");
                            if AssemblyOrder.findfirst then begin
                                AssemblyRef := 'assembly: ' + AssemblyOrder."No." + ' ' + AssemblyOrder."Item No.";
                                AssemblyQty := StrSubstNo('%1 %2', tmpLine.Quantity, tmpLine."Unit of Measure Code");
                            end;

                        end;

                    end;

                end;
        end;
        /*
        case tmpLine."Destination Type" of
            tmpLine."Destination Type"::Customer:
                begin

                end;
            tmpLine."Destination Type"::"Sales Order":
                begin

                end;
        end;
        */
        with TmpLine do begin
            LineEntryNo += 1;
            LineTypeNo := "Action Type";
            LineFormatTxt := STDR_ReportManagement.GetLineFormat(LineBold, LineIndent);
            CLEAR(LineTxt);
        end;
    end;
}

