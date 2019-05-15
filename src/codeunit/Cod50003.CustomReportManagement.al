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
}