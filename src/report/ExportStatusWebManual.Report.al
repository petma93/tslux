report 50000 "Export Status Web Manual"
{
    Caption = 'Export Status Web Manual';
    ApplicationArea = Basic, Suite;

    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(NVTEDIImportExportCode; "NVT EDI Import/Export Code")
        {
            DataItemTableView = SORTING(Type, Code);
            RequestFilterFields = Code;




            trigger OnAfterGetRecord()
            begin

                codeunit.run(50000, NVTEDIImportExportCode);
            end;

            trigger OnPreDataItem()
            var

                typeenum: enum "NVT Import/Export";

            begin
                setrange(type, typeenum::Export);
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
