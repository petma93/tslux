pageextension 50002 "ExportStatusCustParam" extends "NVT Cust. param - General"
{
    layout
    {
        addlast(General)
        {
            field("Status Weborder"; "Status Weborder")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Status Weborder';
            }
        }
    }
}
