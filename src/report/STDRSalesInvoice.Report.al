report 50011 "VDC Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Rdlc/VDC Sales Invoice.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Sales - Invoice';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(OutputNo; OutputNo)
                {
                }
                column(DocNo; Header."No.")
                {
                }
                column(CompanyInfo1Picture; STDR_ReportSetup.Picture)
                {
                }
                column(HeaderFds1; HeaderFds[1])
                {
                }
                column(HeaderFds2; HeaderFds[2])
                {
                }
                column(HeaderFds3; HeaderFds[3])
                {
                }
                column(HeaderFds4; HeaderFds[4])
                {
                }
                column(HeaderFds5; HeaderFds[5])
                {
                }
                column(FontFamily; FontFamily)
                {
                }
                column(Font; FontArray[1])
                {
                }
                column(FontSize1; FontArray[2])
                {
                }
                column(FontSize2; FontArray[3])
                {
                }
                column(FontSize3; FontArray[4])
                {
                }
                column(FontSize4; FontArray[5])
                {
                }
                column(FontSize5; FontArray[6])
                {
                }
                column(FontSize6; FontArray[7])
                {
                }
                dataitem(LineLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(LineEntryNo; LineEntryNo)
                    {
                    }
                    column(LineType; LineTypeNo)
                    {
                    }
                    column(LineFormatTxt; LineFormatTxt)
                    {
                    }
                    column(LineTxt01; LineTxt[1])
                    {
                    }
                    column(LineTxt02; LineTxt[2])
                    {
                    }
                    column(LineTxt03; LineTxt[3])
                    {
                    }
                    column(LineTxt04; LineTxt[4])
                    {
                    }
                    column(LineTxt05; LineTxt[5])
                    {
                    }
                    column(LineTxt06; LineTxt[6])
                    {
                    }
                    column(LineTxt07; LineTxt[7])
                    {
                    }
                    column(LineTxt08; LineTxt[8])
                    {
                    }
                    column(LineTxt09; LineTxt[9])
                    {
                    }
                    column(LineTxt10; LineTxt[10])
                    {
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
                                    FindSet()
                                else
                                    Next();

                            // fill detailline fields
                            FillDetailLineFds();

                        end;

                        trigger OnPreDataItem()
                        begin
                            // don`t print detaillines on coverpage
                            if (CopyLoop.Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                                CurrReport.Break();
                            STDR_ReportManagement.DetailLineAddExtraNo(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.", TempLineBuffer, TempLineBuffer."Cross-Reference No.");
                            STDR_ReportManagement.CollectLineLinkedLines(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.");
                            if TempLineBuffer.Type = TempLineBuffer.Type::Item then begin
                                STDR_ReportManagement.CollectLineItemTracking(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.", TempLineBuffer."No.", TempLineBuffer."Unit of Measure Code");
                                STDR_ReportManagement.CollectAsmInfo(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.");
                                STDR_ReportManagement.DetailLineAddIntrastat(TempDetailBuffer, TempDetailBuffer2, TempLineBuffer."Document No.", TempLineBuffer."Line No.", TempLineBuffer."No.", TempLineBuffer."Unit of Measure Code", TempLineBuffer."Quantity (Base)", TempLineBuffer.Amount);
                            end;
                            STDR_ReportManagement.CollectLineComments(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.");
                            STDR_ReportManagement.CollectItemResourceComments(TempDetailBuffer, TempLineBuffer."Document No.", TempLineBuffer."Line No.", TempLineBuffer.Type, TempLineBuffer."No.");
                            SetRange(Number, 1, TempDetailBuffer.Count());
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        with TempLineBuffer do begin
                            if Number = 1 then
                                FindSet()
                            else
                                Next();

                            //set current line rec
                            STDR_ReportManagement.SetCurrentLineRec(TempLineBuffer);

                            // reset detail buffer line
                            Clear(TempDetailBuffer);
                            TempDetailBuffer.DeleteAll();

                            // don`t print lines on coverpage
                            if (CopyLoop.Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                                if LineEntryNo = 0 then begin
                                    LineEntryNo := 1;
                                    LineTypeNo := 0;
                                    Clear(LineTxt);
                                    Clear(LineFormatTxt);
                                    exit;
                                end else
                                    CurrReport.Break();

                            //GLaccount should be presented out side the company
                            if Type = Type::"G/L Account" then
                                "No." := '';

                            // fill line fields
                            FillLineFds();

                            // fix performance problem
                            // clear picture after first line, otherwise every line and every vatdetailline will have the picture
                            // which results in an realy big xml file
                            if LineEntryNo > 1 then begin
                                Clear(STDR_ReportSetup.Picture);
                                Clear(STDR_ReportSetup."Picture 2");
                                Clear(STDR_ReportSetup."Picture 3");
                                Clear(STDR_ReportSetup."Picture 4");
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Reset vars and set filter on buffer table
                        FillLineBuffer();
                        LineEntryNo := 0;
                        SetRange(Number, 1, TempLineBuffer.Count());
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(LineTotalInvDiscAmount; TotalInvDiscAmount)
                    {
                    }
                    column(VatNoOfLines; TempVATLine.Count())
                    {
                    }
                    column(VatSpecificationTypeNo; VatSpecificationTypeNo)
                    {
                    }
                    column(VATid; TempVATLine."VAT Identifier")
                    {
                    }
                    column(Vatperc; STDR_ReportManagement.FormatInteger(TempVATLine."VAT %"))
                    {
                    }
                    column(VATLineAmount; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."Line Amount"))
                    {
                    }
                    column(VATInvDiscBaseAmount; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."Inv. Disc. Base Amount"))
                    {
                    }
                    column(VATInvDiscAmount; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."Invoice Discount Amount"))
                    {
                    }
                    column(VATBase; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."VAT Base"))
                    {
                    }
                    column(VATAmount; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."VAT Amount"))
                    {
                    }
                    column(VATAmountInclVat; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."Amount Including VAT"))
                    {
                    }
                    column(PmtDiscountAmount; STDR_ReportManagement.FormatAmountDecimal(TempVATLine."Pmt. Discount Amount"))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATLine.GetLine(Number);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempVATLine.Count());
                    end;
                }
                dataitem(IntrastatTotal; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(Intrastat_TariffNo; TempDetailBuffer2."No.")
                    {
                    }
                    column(Intrastat_Description; TempDetailBuffer2.Description)
                    {
                    }
                    column(Intrastat_Weight; STDR_ReportManagement.FormatDecimal(TempDetailBuffer2.Quantity, 2, 2))
                    {
                    }
                    column(Intrastat_Amount; STDR_ReportManagement.FormatAmountDecimal(TempDetailBuffer2.Amount))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number > 1 then
                            TempDetailBuffer2.Next()
                        else
                            TempDetailBuffer2.FindSet();
                    end;

                    trigger OnPreDataItem()
                    begin
                        TempDetailBuffer2.Reset();
                        SetRange(Number, 1, TempDetailBuffer2.Count());
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //set outputno
                    if Number > 1 then begin
                        OutputNo += 1;
                        Clear(STDR_ReportSetup.Picture); //because of performance
                        Clear(STDR_ReportSetup."Picture 2");
                        Clear(STDR_ReportSetup."Picture 3");
                        Clear(STDR_ReportSetup."Picture 4");
                    end;

                    // fill header fields
                    if (Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                        FillPACoverPageHeaderFds()
                    else begin
                        FillHeaderFds();
                        //determine document name and add copy text if number is bigger then one
                        DocName := STDR_ReportManagement.GetDocName(Number);
                        STDR_ReportManagement.AddTxtValue(1, HeaderFds[4], DocName);
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview() then
                        // Update field "No. Printed" in header
                        STDR_ReportManagement.HeaderCountPrinted();
                end;

                trigger OnPreDataItem()
                begin
                    //determine no of copies of this document
                    SetRange(Number, 1, STDR_ReportManagement.GetNoOfLoops(NoOfExtraCopies));
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // setup report management codeunit with current record values
                STDR_ReportManagement.SetCurrentRec("Language Code", '', "Document Date", "Currency Code", Header);

                // Set the options set by user on the requestpage
                STDR_ReportManagement.SetReportOptionLogInteract(LogInteraction);
                STDR_ReportManagement.SetReportOptionAssemblyInfo(ShowAssemblyInfo);
                STDR_ReportManagement.SetReportOptionComment(ShowLineComments);
                STDR_ReportManagement.SetReportOptionLinkedLineInDetail(ShowLinkedLineInDetails);
                STDR_ReportManagement.SetReportOptionZerroQty(ShowLinesZerroQty);
                STDR_ReportManagement.SetReportOptionArchiveDoc(ArchiveDoc);
                STDR_ReportManagement.SetReportOptionItemTracking(ShowItemTracking);

                // get report setup record
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);

                // set CurrReport.Language
                CurrReport.Language := STDR_ReportManagement.GetLanguageID();

                // possibly Archive Document and/or Log Interaction
                if not CurrReport.Preview() then begin
                    STDR_ReportManagement.ArchiveDocument();
                    STDR_ReportManagement.LogInteraction();
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfExtraCopiesCtrl; NoOfExtraCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Extra Copies';
                    }
                    field(LogInteractionCtrl; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        OptionCaption = 'Default,Yes,No';
                        Visible = LogInteractionVisible;
                    }
                    field(ArchiveDocCtrl; ArchiveDoc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        OptionCaption = 'Default,Yes,No';
                        Visible = ArchiveDocVisible;
                    }
                    field(ShowAsmInformationCtrl; ShowAssemblyInfo)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        OptionCaption = 'Default,Yes,No';
                        Visible = ShowAssemblyInfoVisible;
                    }
                    field(ShowItemTrackingCtrl; ShowItemTracking)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Show Serial/Lot Number';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowLineCommentsCtrl; ShowLineComments)
                    {
                        ApplicationArea = Comments;
                        Caption = 'Show Line Comments';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowLinkedLineInDetailsCtrl; ShowLinkedLineInDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Linked Line in Details';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowZerroLinesCtrl; ShowLinesZerroQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Lines Zerro Qty';
                        OptionCaption = 'Default,Yes,No';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        // setup report management codeunit with current reportid
        STDR_ReportManagement.InitReport(CurrReport.ObjectId(false));

        // get default values for request page
        STDR_ReportManagement.InitReportReqPageLogInteract(LogInteraction, LogInteractionVisible);
        STDR_ReportManagement.InitReportReqPageArchiveDoc(ArchiveDoc, ArchiveDocVisible);
        STDR_ReportManagement.InitReportReqPageAssemblyInfo(ShowAssemblyInfo, ShowAssemblyInfoVisible);
    end;

    trigger OnPreReport()
    begin
        // setup report management codeunit with preview
        STDR_ReportManagement.SetPreview(CurrReport.Preview());
    end;

    var
        TempVATLine: Record "VAT Amount Line" temporary;
        TempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        TempDetailBuffer2: Record "STDR_Report Detail Line Buffer" temporary;
        TempLineBuffer: Record "Sales invoice line" temporary;
        STDR_ReportSetup: Record "STDR_Report Setup";
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        STDR_CommonFunctions: Codeunit "STDR_Common Functions";
        DocName: Text;
        HeaderFds: array[5] of Text;
        FontFamily: Text;
        LineFormatTxt: Text;
        LineTxt: array[20] of Text;
        DetLineTxt: array[20] of Text;
        TotalSubTotal: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmountExclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalPmtDiscountAmount: Decimal;
        SumVatLineAmount: Decimal;
        SumVatInvDiscBaseAmount: Decimal;
        SumVatInvDiscAmount: Decimal;
        SumVatVatBaseAmount: Decimal;
        SumVatVatAmount: Decimal;
        SumVatAmountInclVat: Decimal;
        SumPmtDiscountAmount: Decimal;
        LogInteraction: Option Default,Yes,No;
        ShowAssemblyInfo: Option Default,Yes,No;
        ShowItemTracking: Option Default,Yes,No;
        ShowLineComments: Option Default,Yes,No;
        ShowLinkedLineInDetails: Option Default,Yes,No;
        ShowLinesZerroQty: Option Default,Yes,No;
        ArchiveDoc: Option Default,Yes,No;
        [InDataSet]
        ArchiveDocVisible: Boolean;
        [InDataSet]
        LogInteractionVisible: Boolean;
        [InDataSet]
        ShowAssemblyInfoVisible: Boolean;
        OutputNo: Integer;
        LineEntryNo: Integer;
        VatSpecificationTypeNo: Integer;
        NoOfExtraCopies: Integer;
        LineTypeNo: Integer;
        DetLineTypeNo: Integer;
        FontArray: array[8] of Text;

    procedure FillHeaderFds()
    var
        CompanyInfo: Record "STDR_Report Setup";
        LeftAddr: array[8] of Text[100];
        RightAddr: array[8] of Text[100];
        ExtraAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        OurVatNoOrEnterpriseNoCap: Text;
        OurVatNoOrEnterpriseNo: Text;
        VatNoOrEnterpriseNoCap: Text;
        VatNoOrEnterpriseNo: Text;
        ExtDocCap: Text;
        ExtDocNo: Text;
        CustVendCap: Text;
        CustVendNo: Text;
        SalesPersonCap: Text;
        SalesPersonNo: Text;
        SalesPersonTxt: Text;
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        VatTotalInclVATText: Text[50];
        VatTotalExclVATText: Text[50];
        VATHeaderCaption: Text[80];
        VATExchRate: Text[50];
        CalculatedExchRate: Decimal;
        t: array[10] of Text;
    begin
        with Header do begin
            Clear(HeaderFds);
            //sometime the companyinfo is overrulled by the responsibilycenter or report setup code.
            //So we use the report_setup var. The report_mgt codeunit has filled/copied this var with the correct values
            CompanyInfo := STDR_ReportSetup;
            STDR_ReportManagement.FormatAddresses(LeftAddr, RightAddr, ExtraAddr, CompanyAddr);
            STDR_ReportManagement.GetOurVatNoOrEnterpriseNo(CompanyInfo, OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);

            //Set per document:fontfamily, fontname, fontsize
            FontFamily := STDR_ReportManagement.GetFontFamily();
            STDR_ReportManagement.GetFontArray(FontArray);

            // calculate vat header caption fields
            STDR_ReportManagement.GetVatSetup(VatSpecificationTypeNo, TotalInclVATText, TotalExclVATText, VatTotalInclVATText,
              VatTotalExclVATText, VATHeaderCaption, VATExchRate, CalculatedExchRate, "Currency Factor", "Posting Date");
            STDR_ReportManagement.GetVatTotalAmounts("Currency Factor", TempVATLine, TotalSubTotal, TotalInvDiscAmount, TotalAmountExclVAT, TotalAmountVAT, TotalAmountInclVAT, TotalPmtDiscountAmount,
              SumVatLineAmount, SumVatInvDiscBaseAmount, SumVatInvDiscAmount, SumVatVatBaseAmount, SumVatVatAmount, SumVatAmountInclVat, SumPmtDiscountAmount);
            STDR_ReportManagement.AddDecimalCurrencyValue(43, HeaderFds[5], TotalSubTotal, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(44, HeaderFds[5], TotalInvDiscAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(45, HeaderFds[5], TotalAmountExclVAT, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(46, HeaderFds[5], TotalAmountVAT, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(47, HeaderFds[5], TotalAmountInclVAT, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(48, HeaderFds[5], TotalPmtDiscountAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(49, HeaderFds[5], SumVatLineAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(50, HeaderFds[5], SumVatInvDiscBaseAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(51, HeaderFds[5], SumVatInvDiscAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(52, HeaderFds[5], SumVatVatBaseAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(53, HeaderFds[5], SumVatVatAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(54, HeaderFds[5], SumVatAmountInclVat, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(55, HeaderFds[5], SumPmtDiscountAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(56, HeaderFds[5], TotalAmountExclVAT + TotalPmtDiscountAmount, false);
            STDR_ReportManagement.AddDecimalCurrencyValue(57, HeaderFds[5], TotalAmountExclVAT + TotalAmountVAT, false);
            STDR_ReportManagement.AddTxtValue(58, HeaderFds[5], Format(STDR_ReportSetup."Print Pmt. Discount", 0, '<Number>'));

            // 1= Customer Address and ship-to address
            case STDR_ReportSetup."Left Address" of
                STDR_ReportSetup."Left Address"::"Bill-To/Pay-To":
                    STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Bill-to Address');
                STDR_ReportSetup."Left Address"::"Ship-To":
                    STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Ship-to Address');
                STDR_ReportSetup."Left Address"::"Sell-To/Buy-From":
                    STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Sell-to Address');
            end;
            STDR_ReportManagement.AddTxtValue(2, HeaderFds[1], LeftAddr[1]);
            STDR_ReportManagement.AddTxtValue(3, HeaderFds[1], LeftAddr[2]);
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[1], LeftAddr[3]);
            STDR_ReportManagement.AddTxtValue(5, HeaderFds[1], LeftAddr[4]);
            STDR_ReportManagement.AddTxtValue(6, HeaderFds[1], LeftAddr[5]);
            STDR_ReportManagement.AddTxtValue(7, HeaderFds[1], LeftAddr[6]);
            STDR_ReportManagement.AddTxtValue(8, HeaderFds[1], LeftAddr[7]);
            STDR_ReportManagement.AddTxtValue(9, HeaderFds[1], LeftAddr[8]);
            case STDR_ReportSetup."Right Address" of
                STDR_ReportSetup."Right Address"::"Bill-To/Pay-To":
                    STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Bill-to Address');
                STDR_ReportSetup."Right Address"::"Ship-To":
                    STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Ship-to Address');
                STDR_ReportSetup."Right Address"::"Sell-To/Buy-From":
                    STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Sell-to Address');
            end;
            STDR_ReportManagement.AddTxtValue(11, HeaderFds[1], RightAddr[1]);
            STDR_ReportManagement.AddTxtValue(12, HeaderFds[1], RightAddr[2]);
            STDR_ReportManagement.AddTxtValue(13, HeaderFds[1], RightAddr[3]);
            STDR_ReportManagement.AddTxtValue(14, HeaderFds[1], RightAddr[4]);
            STDR_ReportManagement.AddTxtValue(15, HeaderFds[1], RightAddr[5]);
            STDR_ReportManagement.AddTxtValue(16, HeaderFds[1], RightAddr[6]);
            STDR_ReportManagement.AddTxtValue(17, HeaderFds[1], RightAddr[7]);
            STDR_ReportManagement.AddTxtValue(18, HeaderFds[1], RightAddr[8]);

            // 2= Company info
            STDR_ReportManagement.GetCompanyInfoBlock(HeaderFds, CompanyInfo, CompanyAddr, OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);

            // 3= document and vat
            STDR_ReportManagement.GetCustVendNo(CustVendCap, CustVendNo, 1);
            STDR_ReportManagement.AddTxtValue(1, HeaderFds[3], CustVendCap);
            STDR_ReportManagement.AddTxtValue(2, HeaderFds[3], CustVendNo);
            STDR_ReportManagement.AddTxtValue(3, HeaderFds[3], STDR_ReportManagement.GetDocNoCap());
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[3], "No.");
            STDR_ReportManagement.GetExtDocOrVendDocNo(ExtDocCap, ExtDocNo);
            STDR_ReportManagement.AddTxtValue(5, HeaderFds[3], ExtDocCap);
            STDR_ReportManagement.AddTxtValue(6, HeaderFds[3], ExtDocNo);
            STDR_ReportManagement.RecGetVatNoOrEnterpriseNo(Header, VatNoOrEnterpriseNoCap, VatNoOrEnterpriseNo);
            STDR_ReportManagement.AddTxtValue(15, HeaderFds[3], VatNoOrEnterpriseNoCap);
            STDR_ReportManagement.AddTxtValue(16, HeaderFds[3], VatNoOrEnterpriseNo);
            STDR_ReportManagement.AddTranslValue(9, HeaderFds[3], 'Date');
            STDR_ReportManagement.AddDateValue(10, HeaderFds[3], "Document Date");
            STDR_ReportManagement.AddTranslValue(11, HeaderFds[3], 'Due Date');
            STDR_ReportManagement.AddDateValue(12, HeaderFds[3], "Due Date");
            STDR_ReportManagement.GetSalesPersonPurchaserNo(SalesPersonCap, SalesPersonNo, SalesPersonTxt);
            STDR_ReportManagement.AddTxtValue(13, HeaderFds[3], SalesPersonCap);
            STDR_ReportManagement.AddTxtValue(14, HeaderFds[3], SalesPersonTxt);
            if "Your Reference" <> '' then begin
                STDR_ReportManagement.AddTranslValue(7, HeaderFds[3], 'Your Reference');
                STDR_ReportManagement.AddTxtValue(8, HeaderFds[3], "Your Reference");
            end;
            STDR_ReportManagement.AddTranslValue(20, HeaderFds[3], 'Payment Terms');
            STDR_ReportManagement.AddTxtValue(21, HeaderFds[3], STDR_ReportManagement.GetPaymentTerms("Payment Terms Code"));
            STDR_ReportManagement.AddTranslValue(22, HeaderFds[3], 'Shipment Method');
            STDR_ReportManagement.AddTxtValue(23, HeaderFds[3], STDR_ReportManagement.GetShipmentMethod("Shipment Method Code"));

            // 4= Other Header fields
            if STDR_ReportSetup."Show Page No." then
                STDR_ReportManagement.AddTranslValue(2, HeaderFds[4], 'Page %1 of %2');

            //header text
            STDR_ReportManagement.AddTxtValue(3, HeaderFds[4], STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(1));

            //bottom block
            STDR_ReportManagement.GetBottomBlock(HeaderFds, CompanyInfo, CompanyAddr, OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);

            //Combine header Text with Customer or Vendor Comment text
            Clear(t);
            t[1] := STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(1);
            t[2] := STDR_ReportManagement.GetCommAsLongStringForCurrentReport();
            t[3] := STDR_CommonFunctions.Add2TextsToText(t[1], t[2], '%1', 0);
            if t[3] <> '' then
                t[3] += '%1';
            STDR_ReportManagement.AddTxtValue(10, HeaderFds[4], t[3]);
            Clear(t);

            //footer text
            t[1] := STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(2);
            if t[1] <> '' then
                t[1] := '%1' + t[1];
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[4], t[1]);
            Clear(t);
            STDR_ReportManagement.AddDateValue(20, HeaderFds[4], Header."Pmt. Discount Date");
            STDR_ReportManagement."AddDecimal0:0Value"(21, HeaderFds[4], Header."Payment Discount %");

            // 5= Line Header Fields and vat
            STDR_ReportManagement.AddTranslValue(1, HeaderFds[5], 'No.');
            STDR_ReportManagement.AddTranslValue(2, HeaderFds[5], 'Description');
            STDR_ReportManagement.AddTranslValue(3, HeaderFds[5], 'Quantity');
            STDR_ReportManagement.AddTranslValue(4, HeaderFds[5], 'Unit of Measure');
            STDR_ReportManagement.AddTranslValue(5, HeaderFds[5], 'Price');
            if STDR_ReportManagement.LinesWithDiscountExists() then
                case STDR_ReportSetup."Show Discount" of
                    STDR_ReportSetup."Show Discount"::Percentage:
                        STDR_ReportManagement.AddTranslValue(6, HeaderFds[5], 'Discount %');
                    STDR_ReportSetup."Show Discount"::Amount:
                        STDR_ReportManagement.AddTranslValue(6, HeaderFds[5], 'Discount');
                end;
            if STDR_ReportSetup."Show Vat on Lines" <> STDR_ReportSetup."Show Vat on Lines"::" " then
                STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], 'VAT');
            STDR_ReportManagement.AddTranslValue(8, HeaderFds[5], 'Amount');

            // Intrastat totals block
            STDR_ReportManagement.AddTranslValue(10, HeaderFds[5], 'Intrastat Code');
            if STDR_ReportSetup."Show Intrastat in Total Block" in [STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeight, STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeightAmt] then
                STDR_ReportManagement.AddTranslValue(11, HeaderFds[5], 'Description');
            STDR_ReportManagement.AddTranslValue(12, HeaderFds[5], 'Weight');
            if STDR_ReportSetup."Show Intrastat in Total Block" in [STDR_ReportSetup."Show Intrastat in Total Block"::NoWeightAmt, STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeightAmt] then
                STDR_ReportManagement.AddTranslValue(13, HeaderFds[5], 'Amount');

            STDR_ReportManagement.AddTxtValue(21, HeaderFds[5], TotalExclVATText);
            STDR_ReportManagement.AddTranslValue(22, HeaderFds[5], 'VAT Amount');
            STDR_ReportManagement.AddTxtValue(23, HeaderFds[5], TotalInclVATText);
            STDR_ReportManagement.AddTxtValue(24, HeaderFds[5], VATHeaderCaption);
            STDR_ReportManagement.AddTxtValue(25, HeaderFds[5], VATExchRate);

            STDR_ReportManagement.AddTranslValue(26, HeaderFds[5], 'VAT Id');
            STDR_ReportManagement.AddTranslValue(27, HeaderFds[5], 'VAT %');
            STDR_ReportManagement.AddTranslValue(28, HeaderFds[5], 'Subtotal');
            STDR_ReportManagement.AddTranslValue(29, HeaderFds[5], 'Invoice Discount Amount');
            STDR_ReportManagement.AddTranslValue(30, HeaderFds[5], 'VAT Base');
            STDR_ReportManagement.AddTxtValue(31, HeaderFds[5], VatTotalInclVATText);
            STDR_ReportManagement.AddTranslValue(33, HeaderFds[5], 'Total');
            STDR_ReportManagement.AddTxtValue(34, HeaderFds[5], STDR_ReportManagement.GetVatClauseTxt());
            STDR_ReportManagement.AddTranslValue(35, HeaderFds[5], 'Pmt. Discount');
            STDR_ReportManagement.AddTranslValue(36, HeaderFds[5], 'Subtotal');
            STDR_ReportManagement.AddTranslValue(37, HeaderFds[5], 'Total incl. VAT - Pmt. Discount');
            STDR_ReportManagement.AddTranslValue(38, HeaderFds[5], 'Pmt. Discount Expiration Date');
        end;
        STDR_ReportManagement.OnAfterFillHeaderFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, FontArray, HeaderFds);

    end;

    procedure FillPACoverPageHeaderFds()
    begin
        with Header do begin
            FontFamily := STDR_ReportManagement.GetFontFamily();
            STDR_ReportManagement.GetFontArray(FontArray);
            STDR_ReportManagement.AddTxtValue(11, FontFamily, 'White');
            STDR_ReportManagement.FormatPACoverPageAddresses(HeaderFds);
        end;
        STDR_ReportManagement.OnAfterFillPACoverPageHeaderFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, FontArray, HeaderFds);

    end;

    procedure FillLineBuffer()
    var
        Line: Record "sales Invoice line";
        MoreLines: Boolean;
        AddLine: Boolean;
    begin
        //Set filters on lines
        line.SetRange("Document No.", Header."No.");

        //skip empty lines at the end
        MoreLines := line.Find('+');
        while MoreLines and (line.Description = '') and (line."No." = '') and (line.Quantity = 0) and (line.Amount = 0) do
            MoreLines := line.Next(-1) <> 0;
        line.SetRange("Line No.", 0, line."Line No.");

        //Fill Line Buffer 
        TempLineBuffer.Reset();
        if not TempLineBuffer.IsTemporary() then
            CurrReport.Quit();
        TempLineBuffer.DeleteAll();
        if line.FindSet() then
            repeat
                AddLine := true;
                // skip line if quantity is zerro
                if (not STDR_ReportSetup."Show Lines Zerro Qty") and
                   (line.Quantity = 0) and
                   (not STDR_ReportManagement.ShowZerroLineBecauseOfLinkedLines(line."Document No.", line."Line No."))
                then
                    AddLine := false;

                // skip linked or attached lines. They will be printen in de detaillineloop
                if STDR_ReportManagement.RecSkipLineBecauseIsShownAsLinkedToOtherLine(line) then
                    AddLine := false;

                TempLineBuffer.TransferFields(Line, true);
                STDR_ReportManagement.OnAddSalesInvoiceLineToBuffer(line, TempLineBuffer, AddLine);
                if AddLine then
                    if TempLineBuffer.Insert() then;
            until line.Next() = 0;

        //OnAfterFillLineBuffer call here extra lines can be added 
        STDR_ReportManagement.AfterFillSalesInvoiceLineBuffer(line, TempLineBuffer);
    end;

    procedure FillLineFds()
    var
        RecRef: RecordRef;
        LineDisc: Text;
        UoMtxt: Text;
        PriceUnitofMeasure: Text;
        LinePrice: Decimal;
        Qty: Decimal;
        QuantityPriceUnit: Decimal;
        QtyFactorPriceUoM: Decimal;
        Handled: Boolean;
    begin
        with TempLineBuffer do begin
            Clear(LineTxt);
            LineEntryNo += 1;
            LineTypeNo := Type;
            LineFormatTxt := STDR_ReportManagement.GetLineFormat(STDR_Bold, STDR_Indent);
            Recref.GetTable(TempLineBuffer);
            STDR_ReportManagement.PreFillLineFds(RecRef, LineEntryNo, LineTypeNo, LineFormatTxt, LineTxt, Handled);
            Recref.SetTable(TempLineBuffer);
            if Handled then
                exit;

            STDR_ReportManagement.GetQtyPriceUoM(TempLineBuffer, QuantityPriceUnit, QtyFactorPriceUoM, PriceUnitofMeasure);
            STDR_ReportManagement.GetLineQtyPriceDisc(TempLineBuffer, LinePrice, LineDisc, Qty, UoMtxt, "Unit Price", "Line Discount %",
              "Line Discount Amount", Quantity, QuantityPriceUnit, "Unit of Measure", PriceUnitofMeasure);
            LineTxt[1] := STDR_ReportManagement.GetLineNo2(STDR_Indent, "No.", "Variant Code", "Cross-Reference No.", '', '', "Location Code");
            LineTxt[2] := STDR_ReportManagement.GetLineDesc(STDR_Indent, Description, "Description 2");
            if Type > Type::" " then begin
                LineTxt[3] := STDR_ReportManagement.FormatQuantityDecimal(Qty);
                LineTxt[4] := UoMtxt;
                LineTxt[5] := STDR_ReportManagement.FormatPriceDecimal(LinePrice);
                LineTxt[6] := LineDisc;
                LineTxt[7] := STDR_ReportManagement.GetLineVat("VAT Identifier", "VAT %");
                LineTxt[8] := STDR_ReportManagement.FormatAmountDecimal("Line Amount");
                LineTxt[9] := '';
                LineTxt[10] := '';
            end;
        end;
        STDR_ReportManagement.OnAfterFillLineFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, HeaderFds, TempLineBuffer, LineEntryNo, LineTypeNo, LineTxt, LineFormatTxt);

    end;

    procedure FillDetailLineFds()
    var
        DetLineDisc: Text;
        DetLineUoMtxt: Text;
        DetLinePrice: Decimal;
        DetLineQty: Decimal;
        Handled: Boolean;
    begin
        with TempDetailBuffer do begin
            Clear(DetLineTxt);
            DetLineTypeNo := Type;
            STDR_ReportManagement.PreFillDetailLineFds(TempDetailBuffer, DetLineTypeNo, DetLineTxt, Handled);
            if Handled then
                exit;
            STDR_ReportManagement.GetLineQtyPriceDisc(TempDetailBuffer, DetLinePrice, DetLineDisc, DetLineQty, DetLineUoMtxt, Price, "Line Discount %",
              "Line Discount Amount", Quantity, "Quantity (Price Unit)", "Unit of Measure", "Price Unit of Measure");
            DetLineTxt[1] := STDR_ReportManagement.GetLineNo2(TempLineBuffer.STDR_Indent, "No.", "Variant Code", "Cross-Reference No.", "Vendor Item No.", "Vendor No.", "Location Code");
            DetLineTxt[2] := STDR_ReportManagement.GetDescFromTempDetailBuffer(TempDetailBuffer, TempLineBuffer.STDR_Indent);
            if Type > Type::" " then begin
                DetLineTxt[3] := STDR_ReportManagement.FormatQuantityDecimal(DetLineQty);
                DetLineTxt[4] := DetLineUoMtxt;
                if (DetLinePrice <> 0) or (Amount <> 0) then begin
                    DetLineTxt[5] := STDR_ReportManagement.FormatPriceDecimal(DetLinePrice);
                    DetLineTxt[6] := DetLineDisc;
                    DetLineTxt[7] := STDR_ReportManagement.GetLineVat("VAT Identifier", "VAT %");
                    DetLineTxt[8] := STDR_ReportManagement.FormatAmountDecimal(Amount);
                end;
                DetLineTxt[9] := '';
                DetLineTxt[10] := '';
            end;
        end;
        STDR_ReportManagement.OnAfterFillDetailLineFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, HeaderFds, TempLineBuffer, LineEntryNo, LineTypeNo, LineTxt, LineFormatTxt, TempDetailBuffer, DetLineTypeNo, DetLineTxt);

    end;
}

