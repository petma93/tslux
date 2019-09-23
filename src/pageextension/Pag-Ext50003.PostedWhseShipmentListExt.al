pageextension 50003 "PostedWhse.ShipmentListExt" extends "Posted Whse. Shipment List"
{
    actions
    {
        addlast(Reporting)
        {
            action("CombinedPostedWhseShpt")
            {
                ApplicationArea = Warehouse;
                Caption = 'Combined Posted Whse. Shipment';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Prepare to print the combined shipment. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PostedWhseRcptHdr: Record "Posted Whse. Shipment Header";
                    CombPostedWhseShpt: Report "Comb. Posted Whse. Shpt.";
                begin
                    If rec.GetFilters() = '' then
                        PostedWhseRcptHdr.SetRange("No.", "No.")
                    else
                        postedWhseRcptHdr.Copy(Rec);
                    clear(CombPostedWhseShpt);
                    CombPostedWhseShpt.SetTableView(postedWhseRcptHdr);
                    CombPostedWhseShpt.UseRequestPage(true);
                    CombPostedWhseShpt.Run();
                end;
            }
        }
    }
}