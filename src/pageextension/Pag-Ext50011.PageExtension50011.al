pageextension 50011 "PageExtension50011" extends "Warehouse Shipment"
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


        }
    }
}