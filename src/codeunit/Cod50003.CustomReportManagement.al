codeunit 50003 "Custom Report Management"
{
    var
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        Selection: Integer;
        ShipInvoiceQst: Label '&Ship,Ship &and Invoice';

    [EventSubscriber(ObjectType::"Codeunit", Codeunit::"Whse.-Post Shipment + Print", 'OnBeforeCode', '', false, false)]
    local procedure PostAndPrintPostedShptOnly(VAR WhseShptLine: Record "Warehouse Shipment Line"; VAR HideDialog: Boolean; VAR Invoice: Boolean; VAR IsPosted: Boolean)
    var
        WhseDocPrint: Codeunit "Warehouse Document-Print";
        ReportSelectionMgt: Codeunit "Report Selection Mgt.";
        RepSelWhse: Record "Report Selection Warehouse";
    begin
        HideDialog := FALSE;

        WITH WhseShptLine DO BEGIN
            IF FIND THEN
                IF NOT HideDialog THEN BEGIN
                    Selection := STRMENU(ShipInvoiceQst, 1);
                    IF Selection = 0 THEN
                        EXIT;
                    Invoice := (Selection = 2);
                END;

            WhsePostShipment.SetPostingSettings(Invoice);
            WhsePostShipment.SetPrint(FALSE);
            WhsePostShipment.RUN(WhseShptLine);
            WhsePostShipment.GetResultMessage;

            IsPosted := true;
            CLEAR(WhsePostShipment);

            PostedWhseShptHeader.SETRANGE("Whse. Shipment No.", "No.");
            PostedWhseShptHeader.SETRANGE("Location Code", "Location Code");
            PostedWhseShptHeader.FINDLAST;
            PostedWhseshptHeader.SETRANGE("No.", PostedWhseshptHeader."No.");
            //REPORT.RUN(REPORT::"Comb. Posted Whse. Shpt.", FALSE, FALSE, PostedWhseShptHeader);
            with RepSelWhse do begin
                SETRANGE(Usage, Usage::"Posted Shipment");
                IF ISEMPTY THEN
                    ReportSelectionMgt.InitReportUsageWhse(Usage);
                IF FINDSET THEN
                    REPEAT
                        REPORT.RUN("Report ID", false, FALSE, PostedWhseshptHeader);
                    UNTIL NEXT = 0;
            end;


        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', false, false)]
    local procedure SkipPrintingOfSalesShipment(SalesHeader: Record "Sales Header"; VAR IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
}