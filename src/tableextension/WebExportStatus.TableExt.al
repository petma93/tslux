tableextension 50000 "Web Export Status" extends "NVT Status"
{
    fields
    {
        field(50001; "Code Woei"; Option)
        {
            Caption = 'Code Export Web';
            OptionCaption = ' ,1,2,3,4,5,6';
            OptionMembers = " ","1","2","3","4","5","6";
            DataClassification = ToBeClassified;
        }
        field(50000; "ExportWoei"; Boolean)
        {
            caption = 'Export Web';
            DataClassification = ToBeClassified;
        }
        field(50002; "Description Woei"; Text[30])
        {
            Caption = 'Description Web';
            DataClassification = ToBeClassified;
        }
    }
}
