pageextension 50002 "PageExtension50002" extends "Warehouse Receipt"
{
    actions
    {
        addlast(Reporting)
        {
            action(WhseRcptLabel)
            {
                ApplicationArea = Warehouse;
                Caption = '&Labels';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Prepare to print the labels. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    WhseRcptHdr: Record "Warehouse Receipt Header";
                    WhseRcptLabel: Report "Whse. Rcpt. Dim. Label";
                begin
                    WhseRcptHdr.SetRange("No.", "No.");
                    clear(WhseRcptLabel);
                    WhseRcptLabel.SetTableView(WhseRcptHdr);
                    WhseRcptLabel.UseRequestPage(true);
                    WhseRcptLabel.Run();
                end;

            }
        }
    }


}