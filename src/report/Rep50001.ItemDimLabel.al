report 50001 "Item Dim. Label"
{
    Caption = 'Item Dimension Label';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Item Dim. Label.rdlc';

    dataset
    {
        dataitem(Item; "Item")
        {
            RequestFilterFields = "No.";

            column(ItemNo; "No.")
            { }
            column(Description; Description)
            { }
            column(DimensionString; DimensionString)
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
            column(ItemPicture; TmpBlob.Blob)
            { }
            column(SmallPicture; stdr_ReportSetup."Picture 4")
            { }

            dataitem(Copyloop; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(OutputNo; OutputNo)
                {
                }
                dataitem(QtyLoop; Integer)
                {
                    DataItemTableView = SORTING (Number);

                    column(DocNo; DocNo)
                    { }

                    column(LineEntryNo; LineEntryNo)
                    { }

                    column(QtyPurchUOM; QtyPurchUOM)
                    {
                    }
                    column(Qty__to_Receive; LabelQty)
                    { }

                    column(LabelNo; Number)
                    { }

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, LabelQty);
                        LineEntryNo := 0;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        LineEntryNo := LineEntryNo + 1;
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
                STDR_ReportManagement.SetCurrentRec('', '', Today(), '', Item);
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();

                //PFRN_CallPerfionMgt.TempBlobLoadPerfionItemImageName('Image', "No.", "PRFN_Record ID", 'size=400x400', TmpBlob, false);
                PFRN_CallPerfionMgt.TempBlobLoadPerfionItemImageName(stdr_ReportSetup."Custom Parameter1", "No.", "PRFN_Record ID", 'size=400x400', TmpBlob, false);
                STDR_ReportSetup.CalcFields("Picture 4");

                GetDimensions();
                GetTranslations();
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(options)
                {
                    field(QtyPackedColli; QtyPurchUOM)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Qty. Packed in Colli';

                    }

                    field(LabelQty; LabelQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Labels';
                    }
                    field(NoOfExtraCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Extra Copies';
                    }
                }
            }
        }

    }

    var
        stdr_ReportSetup: Record "STDR_Report Setup";
        CompanyInfo: Record "Company Information";
        TmpBlob: Record TempBlob temporary;

        STDR_ReportManagement: Codeunit "STDR_Report Management";
        PFRN_CallPerfionMgt: codeunit "PRFN_Call Perfion Mgt";
        DocNo: Code[20];
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
        QtyPurchUOM: Integer;
        LineEntryNo: Integer;
        Height: Decimal;
        Width: Decimal;
        Length: Decimal;


    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure GetDimensions()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        Height := 0;
        width := 0;
        Length := 0;
        DimensionString := '';

        itemUOM.get(Item."No.", Item."Base Unit of Measure");
        Height := ItemUOM.Height;
        Width := ItemUOM.Width;
        Length := ItemUOM.Length;

        DimensionString := strsubstno(STDR_ReportManagement.GetTranslCurrRep('H %1 * W %2 * D %3'), format(Height), format(Width), Format(Length));
    end;

    local procedure GetTranslations()
    begin
        ItemNoCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Item No.'));
        DescriptionCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Description'));
        DimensionCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Dimension'));
        ColliCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Qty. Packed in Colli'));
        PackagingCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Packing Code'));
        FrontBackCaption := UpperCase(STDR_ReportManagement.GetTranslCurrRep('Front/Back'));
    end;
}