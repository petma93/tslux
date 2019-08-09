pageextension 50024 "PageExtension50024" extends "Assembly Order"
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
                    AssemblyHeader: record "Assembly Header";
                    Item: Record "Item";
                    AssemblyLabel: Report "Assembly Label";
                begin
                    CopyFilters(AssemblyHeader);
                    AssemblyHeader.FindSet();
                    AssemblyHeader.SetRecFilter();
                    clear(AssemblyLabel);
                    AssemblyLabel.SetTableView(AssemblyHeader);
                    AssemblyLabel.UseRequestPage(true);
                    AssemblyLabel.Run();
                end;

            }
        }
    }
}