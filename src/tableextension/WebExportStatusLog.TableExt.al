tableextension 50001 "Web Export Status Log" extends "NVT Status Log"
{
    fields
    {
        field(50000; Exp2Web; Boolean)
        {
            Caption = 'Exp2Web';
            DataClassification = ToBeClassified;
        }
        field(50001; "Exp2Web datetime"; DateTime)
        {
            Caption = 'Exp2Web datetime';
            DataClassification = ToBeClassified;
        }
        field(50002; ExpJson; Boolean)
        {
            Caption = 'ExpJson';
            DataClassification = ToBeClassified;
        }
        field(50003; "ExpJson datetime"; DateTime)
        {
            Caption = 'ExpJson datetime';
            DataClassification = ToBeClassified;
        }
    }
}
