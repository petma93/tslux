pageextension 50025 "AssemblyOrdersExt" extends "Assembly Orders"
{
    actions
    {
        addlast(Reporting)
        {
            action(AssemblyLabel)
            {
                ApplicationArea = Warehouse;
                Caption = '&Label';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Prepare to print the label. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    Item: Record "Item";
                    AssemblyHeader: Record "Assembly Header";
                    AssemblyLabel: Report "Assembly Label";
                begin
                    AssemblyHeader.reset();
                    AssemblyHeader.CopyFilters(rec);
                    AssemblyHeader.FindSet();
                    clear(AssemblyLabel);
                    AssemblyLabel.SetTableView(AssemblyHeader);
                    AssemblyLabel.UseRequestPage(true);
                    AssemblyLabel.Run();
                end;

            }
        }
    }
}