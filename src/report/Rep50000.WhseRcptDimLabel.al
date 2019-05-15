report 50000 "Whse. Rcpt. Dim. Label"
{
    Caption = 'Whse. Receipt Dimension Label';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Whse. Rcpt. Dim. Label.rdlc';

    dataset
    {
        dataitem(WhseReceiptHdr; "Warehouse Receipt Header")
        {
            RequestFilterFields = "No.";

            Column(PurchNoCaption; PurchNoCaption)
            { }
            column(ItemNoCaption; ItemNoCaption)
            { }
            column(DescriptionCaption; DescriptionCaption)
            { }
            column(DimensionCaption; DimensionCaption)
            { }
            column(ColliCaption; ColliCaption)
            { }
            column(PackagingCaption; PackagingCaption)
            { }
            column(FrontBackCaption; FrontBackCaption)
            { }
            column(CompInfoPicture; CompanyInfo.Picture)
            { }
            column(SmallPicture; stdr_ReportSetup."Picture 4")
            { }

            dataitem(Copyloop; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(OutputNo; OutputNo)
                {
                }
                dataitem(whseReceiptLine; "Warehouse Receipt Line")
                {
                    DataItemTableView = SORTING ("No.", "Line No.");
                    DataItemLinkReference = "WhseReceiptHdr";
                    DataItemLink = "No." = field ("No.");
                    RequestFilterFields = "Line No.", "Item No.";
                    column(DocNo; DocNo)
                    { }
                    column(LineEntryNo; LineEntryNo)
                    { }
                    column(ItemNo; "Item No.")
                    { }
                    column(Description; Description)
                    { }
                    column(DimensionString; DimensionString)
                    { }
                    column(QtyPurchUOM; QtyPurchUOM)
                    {
                        DecimalPlaces = 0 : 2;
                    }
                    column(Qty__to_Receive; "Qty. to Receive")
                    { }

                    column(ItemPicture; TmpBlob.Blob)
                    { }

                    dataitem(QtyLoop; Integer)
                    {
                        DataItemTableView = SORTING (Number);
                        column(LabelNo; Number)
                        { }


                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, LabelQty);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        LineEntryNo := LineEntryNo + 1;

                        if ("Source Type" = 39) and ("Source Subtype" = PurchHdr."Document Type"::Order) then
                            DocNo := "Source No."
                        else
                            DocNo := '';

                        LabelQty := round("Qty. to Receive", 1, '>');
                        GetDimensions();
                        GetTranslations();

                        if item."No." <> '' then
                            //PFRN_CallPerfionMgt.TempBlobLoadPerfionItemImageName('Image', "Item No.", item."PRFN_Record ID", '&Size=10x10', TmpBlob, false);
                            PFRN_CallPerfionMgt.TempBlobLoadPerfionItemImageName(stdr_ReportSetup."Custom Parameter1", "Item No.", item."PRFN_Record ID", '&Size=10x10', TmpBlob, false);

                    end;


                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoCopies + 1);
                    OutputNo := 1;
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then
                        OutputNo := OutputNo + 1;
                    LineEntryNo := 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                STDR_ReportManagement.InitReport(CurrReport.OBJECTID(FALSE));
            end;

            trigger OnAfterGetRecord()
            begin
                STDR_ReportManagement.SetCurrentRec('', '', "Posting Date", '', WhseReceiptHdr);
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();
                STDR_ReportSetup.CalcFields("Picture 4");
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;

                    }
                }
            }
        }

    }

    var
        stdr_ReportSetup: Record "STDR_Report Setup";
        CompanyInfo: Record "Company Information";
        Item: record Item;
        TmpBlob: Record TempBlob temporary;
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        PFRN_CallPerfionMgt: codeunit "PRFN_Call Perfion Mgt";

        DocNo: Code[20];
        PurchNoCaption: text;
        ItemNoCaption: text;
        DescriptionCaption: Text;
        DimensionCaption: text;
        DimensionString: text;
        ColliCaption: text;
        PackagingCaption: text;
        FrontBackCaption: text;
        NoCopies: Integer;
        OutputNo: Integer;
        LabelQty: Integer;
        LineEntryNo: Integer;
        Height: Decimal;
        Width: Decimal;
        Length: Decimal;
        QtyPurchUOM: Decimal;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure GetDimensions()
    var
        ItemUOM: Record "Item Unit of Measure";
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        Height := 0;
        width := 0;
        Length := 0;
        QtyPurchUOM := 0;
        DimensionString := '';

        if Item.Get(whseReceiptLine."item No.") then begin
            itemUOM.get(whseReceiptLine."Item No.", item."Base Unit of Measure");
            Height := ItemUOM.Height;
            Width := ItemUOM.Width;
            Length := ItemUOM.Length;

            /*
            if whseReceiptLine."Unit of Measure Code" = item."Purch. Unit of Measure" then
                QtyPurchUOM := whseReceiptLine."Qty. to Receive"
            else begin
                ItemUOM.Get(item."No.", item."Purch. Unit of Measure");
                QtyPurchUOM := UOMMgt.CalcQtyFromBase(whseReceiptLine."Qty. to Receive (Base)", ItemUOM."Qty. per Unit of Measure");
            end;
            */
            QtyPurchUOM := whseReceiptLine."Qty. per Unit of Measure";
        end else
            clear(Item);

        DimensionString := strsubstno(STDR_ReportManagement.GetTranslCurrRep('H %1 * W %2 * D %3'), format(Height), format(Width), Format(Length));
    end;

    local procedure GetTranslations()
    begin
        PurchNoCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Purchase Order No.'));
        ItemNoCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Item No.'));
        DescriptionCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Description'));
        DimensionCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Dimension'));
        ColliCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Qty. Packed in Colli'));
        PackagingCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Packing Code'));
        FrontBackCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Front/Back'));
    end;
}