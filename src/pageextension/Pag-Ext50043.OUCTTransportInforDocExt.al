pageextension 50043 "OUCTTransportInforDocExt" extends "OUCT_Transport Infor. Document"
{

    actions
    {
        addlast(Reporting)
        {
            action(TransportJourneyDocument)
            {
                ApplicationArea = Warehouse;
                Caption = 'Transport Journey Document';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    OUCT_TransportInformation: Record "OUCT_Transport Information";
                    TransportJourneyDocument: Report "Transport Journey Document";

                begin
                    OUCT_TransportInformation.SetRange("No.", "No.");
                    clear(TransportJourneyDocument);
                    TransportJourneyDocument.SetTableView(OUCT_TransportInformation);
                    TransportJourneyDocument.UseRequestPage(true);
                    TransportJourneyDocument.Run();
                end;

            }
        }
    }

}