pageextension 50000 "Web Status Ext" extends "NVT Statuses"
{
    layout
    {
        addlast(RepeaterControl)
        {
            field(ExportWoei; "ExportWoei")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Export Web';
            }


            field("Code Woei"; "Code Woei")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Code Web';

            }
            field("Description Woei"; "Description Woei")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Description Web';

            }
        }
    }
}
