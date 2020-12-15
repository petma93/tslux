codeunit 50003 "Custom Report Management"
{
    var
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        Selection: Integer;
        ShipInvoiceQst: Label '&Ship,Ship &and Invoice';

    [EventSubscriber(ObjectType::"Codeunit", Codeunit::"Whse.-Post Shipment + Print", 'OnBeforeCode', '', false, false)]
    local procedure PostAndPrintPostedShptOnly(VAR WhseShptLine: Record "Warehouse Shipment Line"; VAR HideDialog: Boolean; VAR Invoice: Boolean; VAR IsPosted: Boolean)
    var
        RepSelWhse: Record "Report Selection Warehouse";
        ReportSelectionMgt: Codeunit "Report Selection Mgt.";
    begin
        HideDialog := FALSE;

        WITH WhseShptLine DO BEGIN
            IF FIND() THEN
                IF NOT HideDialog THEN BEGIN
                    Selection := STRMENU(ShipInvoiceQst, 1);
                    IF Selection = 0 THEN
                        EXIT;
                    Invoice := (Selection = 2);
                END;

            WhsePostShipment.SetPostingSettings(Invoice);
            WhsePostShipment.SetPrint(FALSE);
            WhsePostShipment.RUN(WhseShptLine);
            WhsePostShipment.GetResultMessage();

            IsPosted := true;
            CLEAR(WhsePostShipment);

            PostedWhseShptHeader.SETRANGE("Whse. Shipment No.", "No.");
            PostedWhseShptHeader.SETRANGE("Location Code", "Location Code");
            PostedWhseShptHeader.FINDLAST();
            PostedWhseshptHeader.SETRANGE("No.", PostedWhseshptHeader."No.");
            //REPORT.RUN(REPORT::"Comb. Posted Whse. Shpt.", FALSE, FALSE, PostedWhseShptHeader);
            RepSelWhse.SETRANGE(Usage, RepSelWhse.Usage::"Posted Shipment");
            IF RepSelWhse.ISEMPTY() THEN
                ReportSelectionMgt.InitReportUsageWhse(RepSelWhse.Usage);
            IF RepSelWhse.FINDSET() THEN
                REPEAT
                    REPORT.RUN(RepSelWhse."Report ID", false, FALSE, PostedWhseshptHeader);
                UNTIL RepSelWhse.NEXT() = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', false, false)]
    local procedure SkipPrintingOfSalesShipment(SalesHeader: Record "Sales Header"; VAR IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    procedure AssemblyInfoFromPurchOrder(var PurchaseHeader: record "Purchase Header")
    var
        ReservationEntry: record "Reservation Entry";
        ReservationEntry2: record "Reservation Entry";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        PurchaseLine: Record "Purchase Line";
        ExcelBuffer: Record "Excel Buffer" temporary;
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        PrevId: code[20];
        PrevLineNo: Integer;
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.reset();
        //Main
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Purchase Order'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Date'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Supplier'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Purchase Item'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Purchase Quantity'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Unit of Measure'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Order'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Item'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Description'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Component'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Description'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Quantity To Consume'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Unit of Measure'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                ReservationEntry.Reset();
                ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", 1);
                ReservationEntry.SetRange("Source ID", PurchaseHeader."No.");
                ReservationEntry.SetRange("Source Ref. No.", PurchaseLine."Line No.");
                ReservationEntry.SetRange(Positive, true);
                If ReservationEntry.findset() then
                    repeat
                        Reservationentry2.Reset();
                        ReservationEntry2.SetRange("Entry No.", ReservationEntry."Entry No.");
                        ReservationEntry2.SetRange(Positive, false);
                        ReservationEntry2.SetRange("Source Type", 901);
                        ReservationEntry2.SetRange("Source Subtype", 1);
                        ReservationEntry2.SetRange(Positive, false);
                        If ReservationEntry2.findset() then
                            repeat
                                ReservationEntry2.Mark(true);
                            until ReservationEntry2.next() = 0;
                        Reservationentry2.MarkedOnly(true);
                        Reservationentry2.SetCurrentKey("Source ID");
                        if reservationentry2.findfirst() then
                            repeat
                                AssemblyHeader.reset();
                                AssemblyHeader.SetRange("No.", ReservationEntry2."Source ID");
                                if AssemblyHeader.FindFirst() then begin
                                    //Header  
                                    if (ReservationEntry."Source ID" = PrevId)
                                    and (ReservationEntry."Source Ref. No." = PrevLineNo) then begin
                                        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    end else begin
                                        PurchaseLine.CalcFields("Reserved Quantity");
                                        ExcelBuffer.AddColumn(PurchaseLine."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(PurchaseLine."Reserved Quantity", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                        ExcelBuffer.AddColumn(PurchaseLine."Unit of Measure Code", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        PrevId := ReservationEntry."Source ID";
                                        PrevLineNo := ReservationEntry."Source Ref. No.";
                                    end;
                                    ExcelBuffer.AddColumn(AssemblyHeader."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(AssemblyHeader."Item No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(getVendorDescription(AssemblyHeader."Item No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.NewRow();

                                    AssemblyLine.reset();
                                    AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                                    If AssemblyLine.FindSet() then
                                        repeat
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AssemblyLine."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AssemblyLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AssemblyLine."Quantity to Consume", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn(AssemblyLine."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.NewRow();
                                        until AssemblyLine.next() = 0;

                                end;
                            until ReservationEntry2.next() = 0;
                    until ReservationEntry.next() = 0;
            until PurchaseLine.Next() = 0;
        ExcelBuffer.CreateBookAndOpenExcel('', 'Assemblage', 'Inkoop order - Assemblage info', CompanyName(), '');
    end;

    procedure SalesHeaderShipFrom(VAR AddrArray: ARRAY[8] OF Text; VAR SalesHeader: Record "Sales Header"): Boolean
    var
        FormatAddress: Codeunit "Format Address";
    begin

        WITH SalesHeader DO BEGIN
            CalcFields("Ship-From Name", "Ship-From Address 2", "Ship-From Country", "Ship-From Address", "Ship-From City", "Ship-From Post Code");
            if "Ship-From Address" <> '' then begin
                FormatAddress.FormatAddr(
                AddrArray, "Ship-From Name", '', '', "Ship-from Address" + '' + "Ship-From Address 2", '',
                "Ship-from City", "Ship-from Post Code", '', "Ship-From Country");
                EXIT(TRUE);
            end else begin
                FormatAddress.FormatAddr(
                AddrArray, "Sell-to Customer Name", '', '', "Sell-to Address" + '' + "Sell-to Address 2", '',
                "Sell-to City", "Sell-to Post Code", '', "Sell-to Country/Region Code");
                EXIT(TRUE);
            end;
        END;

    end;

    procedure AssemblyInfoFromWarehouseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        ReservationEntry: record "Reservation Entry";
        ReservationEntry2: record "Reservation Entry";
        ReservationEntry3: record "Reservation Entry";
        ReservationEntry4: record "Reservation Entry";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseShipmentLineTemp: Record "Warehouse Shipment Line" temporary;
        TransferLine: Record "Transfer Line";
        ExcelBuffer: Record "Excel Buffer" temporary;
        Item: Record Item;
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        PrevItemNo: Code[20];
        ReservationSourceFound: Boolean;
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.reset();
        //Main
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Warehouse Shipment'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(WarehouseShipmentHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Date'), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(WarehouseShipmentHeader."Shipment Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Fabric'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Total'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Unit of Measure'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Order'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Item'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Description'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Assembly Component'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Description'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('PO No.'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('TO No.'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Quantity To Consume'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(STDR_ReportManagement.GetTranslCurrRep('Unit of Measure'), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();

        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
        WarehouseShipmentLine.SetRange("Source Document", WarehouseShipmentLine."Source Document"::"Outbound Transfer");
        if WarehouseShipmentLine.FindSet() then
            repeat
                WarehouseShipmentLineTemp.Reset();
                ;
                WarehouseShipmentLineTemp.SetRange("No.", WarehouseShipmentHeader."No.");
                WarehouseShipmentLineTemp.SetRange("Source Document", WarehouseShipmentLine."Source Document"::"Outbound Transfer");
                WarehouseShipmentLineTemp.SetRange("Item No.", WarehouseShipmentLine."Item No.");
                if not WarehouseShipmentLineTemp.FindSet() then begin
                    WarehouseShipmentLineTemp.TransferFields(WarehouseShipmentLine);
                    WarehouseShipmentLineTemp.insert();
                end else begin
                    WarehouseShipmentLineTemp.Quantity += WarehouseShipmentLine.Quantity;
                    WarehouseShipmentLineTemp.Modify();
                end;
            until WarehouseShipmentLine.Next() < 1;

        WarehouseShipmentLine.Reset();
        WarehouseShipmentLine.SetCurrentKey("Item No.");
        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
        WarehouseShipmentLine.SetRange("Source Document", WarehouseShipmentLine."Source Document"::"Outbound Transfer");
        if WarehouseShipmentLine.FindSet() then
            repeat
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", WarehouseShipmentLine."Source No.");
                TransferLine.SetRange("Line No.", WarehouseShipmentLine."Source Line No.");
                if TransferLine.FindFirst() then begin

                    ReservationEntry.Reset();
                    ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                    ReservationEntry.SetRange("Source Type", 5741);
                    ReservationEntry.SetRange("Source Subtype", 1);
                    ReservationEntry.SetRange("Source ID", TransferLine."Document No.");
                    ReservationEntry.SetRange("Source Ref. No.", TransferLine."Line No.");
                    ReservationEntry.SetRange(Positive, true);
                    If ReservationEntry.findset() then
                        repeat
                            Reservationentry2.Reset();
                            ReservationEntry2.SetRange("Entry No.", ReservationEntry."Entry No.");
                            ReservationEntry2.SetRange(Positive, false);
                            ReservationEntry2.SetRange("Source Type", 901);
                            ReservationEntry2.SetRange("Source Subtype", 1);
                            ReservationEntry2.SetRange(Positive, false);
                            If ReservationEntry2.findset() then
                                repeat
                                    ReservationEntry2.Mark(true);
                                until ReservationEntry2.next() = 0;
                            Reservationentry2.MarkedOnly(true);
                            Reservationentry2.SetCurrentKey("Source ID");
                            if reservationentry2.findfirst() then
                                repeat
                                    AssemblyHeader.reset();
                                    AssemblyHeader.SetRange("No.", ReservationEntry2."Source ID");
                                    if AssemblyHeader.FindFirst() then begin
                                        //Header  
                                        WarehouseShipmentLineTemp.Reset();
                                        WarehouseShipmentLineTemp.SetRange("No.", WarehouseShipmentLine."No.");
                                        WarehouseShipmentLineTemp.SetRange("Item No.", WarehouseShipmentLine."Item No.");
                                        if WarehouseShipmentLineTemp.FindSet() then
                                            if WarehouseShipmentLineTemp."Item No." = PrevItemNo then begin
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                            end else begin
                                                ExcelBuffer.AddColumn(WarehouseShipmentLineTemp."Item No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn(WarehouseShipmentLineTemp.Quantity, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                                ExcelBuffer.AddColumn(WarehouseShipmentLineTemp."Unit of Measure Code", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                PrevItemNo := WarehouseShipmentLineTemp."Item No.";
                                            end;
                                        ExcelBuffer.AddColumn(AssemblyHeader."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(AssemblyHeader."Item No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(getVendorDescription(AssemblyHeader."Item No."), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.NewRow();

                                        AssemblyLine.reset();
                                        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                                        If AssemblyLine.FindSet() then
                                            repeat
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn(AssemblyLine."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.AddColumn(AssemblyLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                                                ReservationSourceFound := false;
                                                ReservationEntry3.Reset();
                                                ReservationEntry3.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                                                ReservationEntry3.SetRange("Source Type", 901);
                                                ReservationEntry3.SetRange("Source Subtype", 1);
                                                ReservationEntry3.SetRange("Source ID", AssemblyLine."Document No.");
                                                ReservationEntry3.SetRange("Source Ref. No.", AssemblyLine."Line No.");
                                                ReservationEntry3.SetRange(Positive, false);
                                                if ReservationEntry3.FindFirst() then begin
                                                    Reservationentry4.Reset();
                                                    ReservationEntry4.SetRange("Entry No.", ReservationEntry3."Entry No.");
                                                    ReservationEntry4.SetRange(Positive, true);
                                                    if ReservationEntry4.FindFirst() then begin
                                                        if ReservationEntry4."Source Type" = 39 then begin
                                                            ExcelBuffer.AddColumn(ReservationEntry4."Source ID", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                            ReservationSourceFound := true;
                                                        end;
                                                        if ReservationEntry4."Source Type" = 5741 then begin
                                                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                            ExcelBuffer.AddColumn(ReservationEntry4."Source ID", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                            ReservationSourceFound := true;
                                                        end;
                                                    end;

                                                end;
                                                if ReservationSourceFound = false then begin
                                                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                    ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                end;
                                                ExcelBuffer.AddColumn(AssemblyLine."Quantity to Consume", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                                ExcelBuffer.AddColumn(AssemblyLine."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                                ExcelBuffer.NewRow();
                                            until AssemblyLine.next() = 0;

                                    end;
                                until ReservationEntry2.next() = 0;
                        until ReservationEntry.next() = 0;
                end;
            until WarehouseShipmentLine.Next() < 1;
        ExcelBuffer.CreateBookAndOpenExcel('', 'Assembly', 'Transfer order - Assembly Overview', CompanyName(), '');
    end;


    local procedure getVendorDescription(ItemNo: Code[20]): text
    var
        Item: Record Item;
        ItemCrossReference: Record "Item Cross Reference";
    begin
        ItemCrossReference.SetRange("Item No.", ItemNo);
        ItemCrossReference.SetRange("Cross-Reference Type", ItemCrossReference."Cross-Reference Type"::Vendor);
        if ItemCrossReference.FindFirst() then
            exit(ItemCrossReference.Description);

        if Item.Get(ItemNo) then
            exit(Item.Description);

    end;

    procedure GenerateBarcode(var itemPicBuf: record "Item Picture Buffer" temporary; Barcode: text; TypeBarcode: text; Ext: text;
           Size: Integer; Resolution: integer; Margin: integer; ShowText: Boolean; TextSize: Integer;
            DrawBorder: Boolean; reverseCol: Boolean);

    var
        requeststring: text;
        TextBld: TextBuilder;

    begin
        clear(TextBld);
        IF Size = 0 THEN
            Size := 4;
        TextBld.Append('http://barcodes4.me/barcode/qr/');
        TextBld.Append(Barcode + '.' + Ext + '?');
        TextBld.Append('?size=' + format(Size));
        if Resolution <> 0 then
            TextBld.Append('&ecclevel=' + format(Resolution));
        if Margin <> 0 then
            TextBld.Append('&margin=' + Format(Margin));
        // if ShowText = true then begin
        //     TextBld.Append('&IsTextDrawn=1');
        //  if TextSize <> 0 then
        //      TextBld.Append('&TextSize=' + Format(TextSize));
        // end;
        if DrawBorder = true then
            TextBld.Append('&IsBorderDrawn=1');
        // if reverseCol = true then
        //     TextBld.Append('&IsReverseColor=1');

        if TextBld.ToText() <> '' then
            CallWebService(itemPicBuf, TextBld.ToText(), Ext);
    end;



    local procedure CallWebService(var itemPicbuf: Record "Item Picture Buffer" temporary; RequestStr: Text; ext: Text)
    var
        HttpClt: HttpClient;
        HttpRspContent: HttpContent;
        HttpRspMessage: HttpResponseMessage;
        instr: InStream;
        tempPict: Record "Item Picture Buffer" temporary;


    begin
        Clear(HttpClt);
        HttpClt.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');

        if not HttpClt.Get(RequestStr, HttpRspMessage) then
            Error('The call to the web service failed.');
        if not HttpRspMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', HttpRspMessage.HttpStatusCode, HttpRspMessage.ReasonPhrase);

        HttpRspContent := HttpRspMessage.Content;
        if not HttpRspContent.ReadAs(instr) then
            exit;

        TempPict.INIT;
        TempPict."File Name" := 'Pict';

        TempPict.Picture.ImportStream(instr, '', ext);
        TempPict.Insert(false);



    end;
}
