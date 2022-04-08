pageextension 50001 "WebStatsLog ext" extends "NVT StatusLog List"
{
    layout
    {
        addlast(RepeaterControl)
        {
            field(Exp2Woei; Exp2Web)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Exp2Web';
            }
            field("Exp2Woei datetime"; "Exp2Web datetime")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Exp2Web datetime';
            }
            field(ExpJson; ExpJson)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'ExpJson';
            }
            field("ExpJson datetime"; "ExpJson datetime")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'ExpJson datetime';
            }

        }
    }
}
