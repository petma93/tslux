pageextension 50004 "PageExtension50004" extends "STDR_Print Codes"
{
    layout
    {
        addbefore(Shipment)
        {
            field(TransportInformation; "Transport Information")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if data should be printed on the Transport Information';
            }
        }
    }
}