tableextension 50002 "TableExtension50002" extends "Registered Whse. Activity Line"
{
    fields
    {
        field(50000; "No. of Packages"; Integer)
        {
            Caption = 'No. of Packages';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50001; DestinationName; Text[100])
        {
            Caption = 'Destination Name';
            DataClassification = CustomerContent;
        }
    }
}