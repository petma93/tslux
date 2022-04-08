report 50001 "reset web status export"
{
    Caption = 'Reset Web Export';
    ApplicationArea = Basic, Suite;

    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(NVTStatusLog; "NVT Status Log")
        {
            DataItemTableView = SORTING() WHERE(Exp2Web = CONST(True));

            trigger OnPreDataItem()
            begin

                ModifyAll(Exp2Web, false);

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}