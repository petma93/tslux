pageextension 50027 "PageExtension50027" extends "Purchase Order"
{
    actions
    {
        addlast(Reporting)
        {
            action("Purchase Assembly Information")
            {
                ApplicationArea = Warehouse;
                Caption = '&Purchase-Assembly';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Get assembly information from this purchase in excel';

                trigger OnAction()
                var
                    CustomReportMgt: Codeunit "Custom Report Management";
                begin
                    CustomReportMgt.AssemblyInfoFromPurchOrder(rec);
                end;

            }
        }
    }
}