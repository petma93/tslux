Report 50006 "VDC Whse. - Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Rdlc/VDC Whse. - Receipt.rdlc';
    ApplicationArea = Warehouse;
    Caption = 'VDC Warehouse Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Receipt Header"; "Warehouse Receipt Header")
        {
            DataItemTableView = sorting ("No.");
            RequestFilterFields = "No.";
            column(No_WhseRcptHeader; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting (Number) where (Number = const (1));
                column(CompanyName; CompanyProperty.DisplayName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(AssignedUserID_WhseRcptHeader; "Warehouse Receipt Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_WhseRcptHeader; "Warehouse Receipt Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(No1_WhseRcptHeader; "Warehouse Receipt Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Show1; not Location."Bin Mandatory")
                {
                }
                column(Show2; Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehouseReceiptCaption; WarehouseReceiptCaptionLbl)
                {
                }
                dataitem("Warehouse Receipt Line"; "Warehouse Receipt Line")
                {
                    DataItemLink = "No." = field ("No.");
                    DataItemLinkReference = "Warehouse Receipt Header";
                    DataItemTableView = sorting ("No.", "Item No.");
                    column(ShelfNo_WhseRcptLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_WhseRcptLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_WhseRcptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitofMeasureCode_WhseRcptLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_WhseRcptLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_WhseRcptLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_WhseRcptLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDocument_WhseRcptLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_WhseRcptLine; "Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseRcptLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Posted Receipt';

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Location: Record Location;
        CurrReportPageNoCaptionLbl: label 'Page';
        WarehouseReceiptCaptionLbl: label 'Warehouse - Receipt';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

