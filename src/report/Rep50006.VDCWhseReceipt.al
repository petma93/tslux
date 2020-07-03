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
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_WhseRcptHeader; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
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
                    DataItemLink = "No." = field("No.");
                    DataItemLinkReference = "Warehouse Receipt Header";
                    DataItemTableView = sorting("No.", "Item No.");
                    column(Line_No_; "Line No.")
                    { }
                    column(LineEntryNo; LineEntryNo)
                    { }
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
                    dataitem(DetailLineLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(DetailLineEntryNo; TempDetailBuffer."Entry No.")
                        {
                        }
                        column(DetailLineType; DetLineTypeNo)
                        {
                        }
                        column(DetailLineTxt01; DetLineTxt[1])
                        {
                        }
                        column(DetailLineTxt02; DetLineTxt[2])
                        {
                        }
                        column(DetailLineTxt03; DetLineTxt[3])
                        {
                        }
                        column(DetailLineTxt04; DetLineTxt[4])
                        {
                        }
                        column(DetailLineTxt05; DetLineTxt[5])
                        {
                        }
                        column(DetailLineTxt06; DetLineTxt[6])
                        {
                        }
                        column(DetailLineTxt07; DetLineTxt[7])
                        {
                        }
                        column(DetailLineTxt08; DetLineTxt[8])
                        {
                        }
                        column(DetailLineTxt09; DetLineTxt[9])
                        {
                        }
                        column(DetailLineTxt10; DetLineTxt[10])
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            with TempDetailBuffer do
                                if Number = 1 then
                                    FINDSET()
                                else
                                    NEXT();

                            // fill detailline fields
                            FillDetailLineFds();
                            firstDetailLine := false;
                        end;

                        trigger OnPreDataItem()
                        begin

                            GetBinInformation(TempDetailBuffer);

                            SetRange(Number, 1, TempDetailBuffer.Count);
                            SETRANGE(Number, 1, TempDetailBuffer.COUNT());
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");

                        // reset detail buffer line
                        CLEAR(TempDetailBuffer);
                        TempDetailBuffer.DELETEALL();
                        LineEntryNo += 1;
                        firstDetailLine := true;

                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                aRecRef: RecordRef;
            begin
                GetLocation("Location Code");
                //CurrReport.Language := 2067; //=nlb
                STDR_ReportManagement.SetCurrentRec('NLB', '', Today(), '', "Warehouse Receipt Header");
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();
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
        TempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        STDR_ReportSetup: Record "STDR_Report Setup";
        DetLineTxt: array[20] of Text;
        DetLineTypeNo: Integer;
        LineIndent: Integer;
        LineEntryNo: Integer;
        firstDetailLine: Boolean;
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

    procedure FillDetailLineFds()
    var
        CrossDockMark: Text;
        CurrentBin: Label 'Current bins';
    begin
        with TempDetailBuffer do begin
            DetLineTypeNo := Type;
            CLEAR(DetLineTxt);
            DetLineTxt[1] := STDR_ReportManagement.GetLineNo2(LineIndent, "No.", "Variant Code", "Cross-Reference No.", "Vendor Item No.", "Vendor No.", "Location Code");
            DetLineTxt[2] := STDR_ReportManagement.GetDescFromTempDetailBuffer(TempDetailBuffer, LineIndent);
            if firstDetailLine then
                DetLineTxt[3] := CurrentBin
            else
                DetLineTxt[3] := '';
            DetLineTxt[7] := TempDetailBuffer."Bin Code";
            DetLineTxt[8] := STDR_ReportManagement.FormatQuantityDecimal(Quantity);
            DetLineTxt[9] := "Unit of Measure Code";
            DetLineTxt[10] := '';
        end; /*with do*/

    end;

    procedure GetBinInformation(var TheTempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary)
    var
        BinContent: Record "Bin Content";
        QtyAvailToTake: Decimal;
    begin
        // Opzoeken op welke locaties het artikel ligt en deze weergeven in rapport
        BinContent.SetRange("Location Code", "Warehouse Receipt Line"."Location Code");
        BinContent.SetRange("Item No.", "Warehouse Receipt Line"."Item No.");
        if BinContent.FindSet() then
            repeat
                STDR_ReportManagement.DetailLineAdd(TheTempDetailBuffer, "Warehouse Receipt Header"."No.", "Warehouse Receipt Line"."Line No.");
                TheTempDetailBuffer.Type := TheTempDetailBuffer.Type::Resource;
                TheTempDetailBuffer."Bin Code" := BinContent."Bin Code";
                QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
                TheTempDetailBuffer.Quantity := QtyAvailToTake;
                TheTempDetailBuffer."Unit of Measure Code" := BinContent."Unit of Measure Code";
                if QtyAvailToTake <> 0 then
                    TheTempDetailBuffer.INSERT();
            until BinContent.Next() < 1;
    end;
}

