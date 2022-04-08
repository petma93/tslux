pageextension 50000 "Web Status Ext" extends "NVT Statuses"
{
    layout
    {
        addlast(RepeaterControl)
        {
            field(ExportWeb; "ExportWeb")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Export Web';
            }


            field("Code Web"; "Code Web")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Code Web';

            }
            field("Description Web"; "Description Web")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Description Web';

            }
            field(ExportWebOrder; ExportWebOrder)
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Export WebOrder';

            }
            field("Description Status WebOrder"; "Description Status WebOrder")
            {
                ApplicationArea = All;
                Visible = bolOperationalStatus;
                Caption = 'Description Status WebOrder';

            }
        }
    }
}
