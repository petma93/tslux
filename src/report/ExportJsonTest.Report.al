report 50002 ExportJsonTest
{
    Caption = 'ExportJsonTest';
    ApplicationArea = Basic, Suite;

    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = SORTING(number) WHERE(number = CONST(1));

            trigger OnPreDataItem()
            begin

                codeunit.Run(50001);


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
