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
        previd: code[20];
        ReservationEntry: record "Reservation Entry";
        ReservationEntry2: record "Reservation Entry";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.reset;
        //Main
        ExcelBuffer.AddColumn('Inkooporder', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Datum', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Leverancier', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Assemblage artikel', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Assemblage component', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Aantal', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Eenheid', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ReservationEntry.Reset();
        Reservationentry2.Reset();
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange("Source Type", 39);
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Source ID", PurchaseHeader."No.");
        ReservationEntry.SetRange(Positive, true);
        If ReservationEntry.findset then
            repeat
                ReservationEntry2.SetRange("Entry No.", ReservationEntry."Entry No.");
                ReservationEntry2.SetRange(Positive, false);
                ReservationEntry2.SetRange("Source Type", 901);
                ReservationEntry2.SetRange("Source Subtype", 1);
                ReservationEntry2.SetRange(Positive, false);
                If ReservationEntry2.findset then
                    repeat
                        ReservationEntry2.Mark(true);
                    until ReservationEntry2.next = 0;
            until ReservationEntry.next = 0;
        Reservationentry2.MarkedOnly(true);
        Reservationentry2.SetCurrentKey("Source ID");
        if reservationentry2.findfirst then
            repeat
                if ReservationEntry2."Source ID" <> previd then begin
                    AssemblyHeader.reset;
                    AssemblyHeader.SetRange("No.", ReservationEntry2."Source ID");
                    if AssemblyHeader.FindFirst() then begin
                        //Header
                        ExcelBuffer.NewRow();
                        ExcelBuffer.NewRow();
                        ExcelBuffer.AddColumn(AssemblyHeader."Item No." + ' ' + AssemblyHeader.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(AssemblyHeader."Quantity to Assemble", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(AssemblyHeader."Unit of Measure Code", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.NewRow();

                        AssemblyLine.reset();
                        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                        If AssemblyLine.FindSet() then
                            repeat
                                ExcelBuffer.AddColumn(AssemblyHeader."Item No." + ' ' + AssemblyHeader.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(AssemblyLine."No." + ' ' + AssemblyLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(-AssemblyLine."Quantity to Consume", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AssemblyLine."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.NewRow();
                            until AssemblyLine.next = 0;

                    end;
                end;
                PrevId := ReservationEntry2."Source ID";
            until ReservationEntry2.next = 0;
        ExcelBuffer.CreateBookAndOpenExcel('', 'Assemblage', 'Inkoop order - Assemblage info', CompanyName, '');
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




}
