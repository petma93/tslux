pageextension 50001 "WebStatsLog ext" extends "NVT StatusLog List"
{
    layout
    {
        addlast(RepeaterControl)
        {
            field(Exp2Woei; Exp2Woei)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Exp2Web';
            }
            field("Exp2Woei datetime"; "Exp2Woei datetime")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Exp2Web datetime';
            }

        }
    }
}
