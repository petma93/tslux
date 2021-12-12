tableextension 50001 "Web Export Status Log" extends "NVT Status Log"
{
    fields
    {
        field(50000; Exp2Woei; Boolean)
        {
            Caption = 'Exp2Web';
            DataClassification = ToBeClassified;
        }
        field(50001; "Exp2Woei datetime"; DateTime)
        {
            Caption = 'Exp2Web datetime';
            DataClassification = ToBeClassified;
        }
    }
}
