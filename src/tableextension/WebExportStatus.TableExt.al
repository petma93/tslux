tableextension 50000 "Web Export Status" extends "NVT Status"
{
    fields
    {
        field(50001; "Code Web"; Option)
        {
            Caption = 'Code Export Web';
            OptionCaption = ' ,1,2,3,4,5,6';
            OptionMembers = " ","1","2","3","4","5","6";
            DataClassification = ToBeClassified;
        }
        field(50000; "ExportWeb"; Boolean)
        {
            caption = 'Export Web';
            DataClassification = ToBeClassified;
        }
        field(50002; "Description Web"; Text[30])
        {
            Caption = 'Description Web';
            DataClassification = ToBeClassified;
        }
        field(50003; "ExportWebOrder"; Boolean)
        {
            caption = 'Export WebOrder';
            DataClassification = ToBeClassified;
        }
        field(50004; "Description Status WebOrder"; Text[30])
        {
            Caption = 'Description Status WebOrder';
            DataClassification = ToBeClassified;
        }
    }
}
