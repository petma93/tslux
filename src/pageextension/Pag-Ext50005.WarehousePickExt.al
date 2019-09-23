pageextension 50005 "WarehousePickExt" extends "Warehouse Pick"
{
    actions
    {
        addlast(Reporting)
        {
            action(ShippingLabel)
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
                    WhseActHdr: Record "Warehouse Activity Header";
                    ShippingLabel: Report "Shipping Label";
                begin
                    WhseActHdr.setrange(Type, Type);
                    WhseActHdr.SetRange("No.", "No.");
                    clear(ShippingLabel);
                    ShippingLabel.SetTableView(WhseActHdr);
                    ShippingLabel.UseRequestPage(true);
                    ShippingLabel.Run();
                end;

            }
        }
    }


}