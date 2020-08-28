pageextension 50049 "Registered Pick Ext" extends "Registered Pick"
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
                    WhseActHdr: Record "Registered Whse. Activity Hdr.";
                    RegisteredPickShippingLabel: Report "Registered Pick Shipping Label";
                begin
                    WhseActHdr.setrange(Type, Type);
                    WhseActHdr.SetRange("No.", "No.");
                    clear(RegisteredPickShippingLabel);
                    RegisteredPickShippingLabel.SetTableView(WhseActHdr);
                    RegisteredPickShippingLabel.UseRequestPage(true);
                    RegisteredPickShippingLabel.Run();
                end;

            }
        }
    }
}