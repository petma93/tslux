pageextension 50001 "ItemListExt2" extends "Item List"
{
    actions
    {
        addlast(Reporting)
        {
            action(ItemLabel)
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
                    ItemLabel: Report "Item Dim. Label";
                begin
                    Item.SetRange("No.", "No.");
                    clear(ItemLabel);
                    ItemLabel.SetTableView(Item);
                    ItemLabel.UseRequestPage(true);
                    ItemLabel.Run();
                end;

            }
        }
    }
}