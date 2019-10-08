pageextension 50011 "WarehouseShipmentExt" extends "Warehouse Shipment"
{
    actions
    {
        addlast(Reporting)
        {
            action("TransportDocument")
            {
                ApplicationArea = All;
                Caption = 'Transport Document';
                Image = PrintCover;

                trigger OnAction()
                var
                    WhseShptHdr: Record "Warehouse Shipment Header";
                    TransportDocument: Report "Transport Document";
                begin
                    WhseShptHdr.SetRange("No.", "No.");
                    clear(TransportDocument);
                    TransportDocument.SetTableView(WhseShptHdr);
                    TransportDocument.UseRequestPage(true);
                    TransportDocument.Run();
                end;
            }
            action("Transfer Assembly Overview")
            {
                ApplicationArea = Warehouse;
                Caption = '&Transfer-Assembly Overview';
                Ellipsis = true;
                Image = PrintReport;
                ToolTip = 'Get assembly information from this purchase in excel';

                trigger OnAction()
                var
                    CustomReportMgt: Codeunit "Custom Report Management";
                begin
                    CustomReportMgt.AssemblyInfoFromWarehouseShipment(rec);
                end;
            }

        }
    }
}