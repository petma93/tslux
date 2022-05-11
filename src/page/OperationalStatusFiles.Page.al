page 50000 "Weborder Op. Status Files"
{
    ApplicationArea = All;
    Caption = 'Weborder operational Status Files';
    PageType = List;
    SourceTable = "NVT Status Log";
    SourceTableView = Where("Status type" = filter(Operational), "Shipment No." = filter(<> 0));
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("File Tpt"; Rec."File Tpt")
                {
                    ToolTip = 'Specifies the value of the File No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ToolTip = 'Specifies the value of the Shipment No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Code status"; Rec."Code status")
                {
                    ToolTip = 'Specifies the value of the Code status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date status"; Rec."Date status")
                {
                    ToolTip = 'Specifies the value of the Date status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description status"; Rec."Description status")
                {
                    ToolTip = 'Specifies the value of the Description status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Exp2Woei; Rec.Exp2Woei)
                {
                    ToolTip = 'Specifies the value of the Exp2Web field.';
                    ApplicationArea = All;
                }
                field("Exp2Woei datetime"; Rec."Exp2Woei datetime")
                {
                    ToolTip = 'Specifies the value of the Exp2Web datetime field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ExpJson; Rec.ExpJson)
                {
                    ToolTip = 'Specifies the value of the ExpJson field.';
                    ApplicationArea = All;
                }
                field("ExpJson datetime"; Rec."ExpJson datetime")
                {
                    ToolTip = 'Specifies the value of the ExpJson datetime field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No. customer"; Rec."No. customer")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Problem Code"; Rec."Problem Code")
                {
                    ToolTip = 'Specifies the value of the Problem Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Time status"; Rec."Time status")
                {
                    ToolTip = 'Specifies the value of the Time status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
