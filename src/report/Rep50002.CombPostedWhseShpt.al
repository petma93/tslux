report 50002 "Comb. Posted Whse. Shpt."
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Comb. Posted Whse. Shpt.rdlc';
    Caption = 'Combined Posted Whse. Shipment';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(PostedWhseShptHdr; "Posted Whse. Shipment Header")
        {

            RequestFilterFields = "No.", "Whse. Shipment No.", "External Document No.";
            dataitem(PostedWhseShptLine; "Posted Whse. Shipment Line")
            {
                DataItemLink = "No." = FIELD ("No.");
                DataItemTableView = SORTING ("No.", "Line No.");

                trigger OnAfterGetRecord()
                begin

                    CreateTempData();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not TmpWhseShpt.GET("Whse. Shipment No.") then begin
                    TmpWhseShpt."No." := "Whse. Shipment No.";
                    TmpWhseShpt.INSERT();
                end else
                    CurrReport.SKIP();
            end;

            trigger OnPreDataItem()
            begin
                TmpWhseShpt.RESET();
                TmpWhseShpt.DELETEALL();
                TmpHeader.RESET();
                TmpHeader.DELETEALL();
                TmpLine.RESET();
                TmpLine.DELETEALL();
                TmpHeader2.RESET();
                TmpHeader2.DELETEALL();
                TmpLine2.RESET();
                TmpLine2.DELETEALL();
            end;
        }

        dataitem(HeaderLoop; "Integer")
        {
            DataItemTableView = SORTING (Number);
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                column(GroupCode; GroupCode)
                {
                }
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
                    DataItemLinkReference = HeaderLoop;
                    DataItemTableView = SORTING (Number);
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
                    column(OrderNo; OrderNo)
                    {
                    }
                    column(OrderRef; OrderRef)
                    {
                    }
                    dataitem(DetailLineLoop; "Integer")
                    {
                        DataItemTableView = SORTING (Number);
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

                        end;

                        trigger OnPreDataItem()
                        var
                            STDR_ReportDetailMgt: Codeunit "STDR_Report Detail Mgt";
                        begin
                            // don`t print detaillines on coverpage
                            if (CopyLoop.Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                                CurrReport.BREAK();

                            If HeaderLoop.Number <= TmpHeaders then begin
                                STDR_ReportDetailMgt.DetailLineAddExtraNo(STDR_ReportSetup, TempDetailBuffer, Line."Document No.", Line."Line No.", Line."Cross-Reference No.");
                                STDR_ReportManagement.CollectLineLinkedLines(TempDetailBuffer, Line."Document No.", Line."Line No.");
                                if Line.Type = Line.Type::Item then begin
                                    STDR_ReportManagement.CollectLineItemTracking(TempDetailBuffer, Line."Document No.", Line."Line No.", Line."No.", Line."Unit of Measure Code");
                                    STDR_ReportManagement.CollectAsmInfo(TempDetailBuffer, Line."Document No.", Line."Line No.");
                                    STDR_ReportManagement.DetailLineAddIntrastat(TempDetailBuffer, TempDetailBuffer2, Line."Document No.", Line."Line No.", Line."No.", Line."Unit of Measure Code", Line."Quantity (Base)", Line.STDR_Amount);
                                end;
                                STDR_ReportManagement.CollectLineComments(TempDetailBuffer, Line."Document No.", Line."Line No.");
                                STDR_ReportManagement.CollectItemResourceComments(TempDetailBuffer, Line."Document No.", Line."Line No.", Line.Type, Line."No.");
                            end else begin
                                STDR_ReportDetailMgt.DetailLineAddExtraNo(STDR_ReportSetup, TempDetailBuffer, Line2."Document No.", Line2."Line No.", ''); //Line2."Cross-Reference No.");
                                STDR_ReportManagement.CollectLineLinkedLines(TempDetailBuffer, Line2."Document No.", Line2."Line No.");
                                STDR_ReportManagement.CollectLineItemTracking(TempDetailBuffer, Line2."Document No.", Line2."Line No.", Line2."item No.", Line2."Unit of Measure Code");
                                STDR_ReportManagement.CollectAsmInfo(TempDetailBuffer, Line2."Document No.", Line2."Line No.");
                                STDR_ReportManagement.DetailLineAddIntrastat(TempDetailBuffer, TempDetailBuffer2, Line2."Document No.", Line2."Line No.", Line2."item No.", Line2."Unit of Measure Code", Line2."Quantity (Base)", 0); //Line2.STDR_Amount);
                                STDR_ReportManagement.CollectLineComments(TempDetailBuffer, Line2."Document No.", Line2."Line No.");
                                STDR_ReportManagement.CollectItemResourceComments(TempDetailBuffer, Line2."Document No.", Line2."Line No.", 1, Line2."item No.");
                            end;
                            SETRANGE(Number, 1, TempDetailBuffer.COUNT());
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //Synchronize temp data
                        if HeaderLoop.Number <= TmpHeaders then begin
                            if Number > 1 then
                                TmpLine.NEXT()
                            else
                                TmpLine.FINDSET();
                            Line.TRANSFERFIELDS(TmpLine);
                        end else begin
                            if Number > 1 then
                                TmpLine2.NEXT()
                            else
                                TmpLine2.FINDSET();
                            Line2.TRANSFERFIELDS(TmpLine2);
                        end;


                        // reset detail buffer line
                        CLEAR(TempDetailBuffer);
                        TempDetailBuffer.DELETEALL();

                        // don`t print lines on coverpage
                        if (CopyLoop.Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                            if LineEntryNo = 0 then begin
                                LineEntryNo := 1;
                                LineTypeNo := 0;
                                CLEAR(LineTxt);
                                CLEAR(LineFormatTxt);
                                exit;
                            end else
                                CurrReport.BREAK();

                        If HeaderLoop.Number <= TmpHeaders then begin
                            //GLaccount should be presented out side the company
                            if Line.Type = Line.Type::"G/L Account" then
                                Line."No." := '';

                            // skip line if quantity is zerro
                            if (not STDR_ReportSetup."Show Lines Zerro Qty") and
                            (Line.Quantity = 0) and
                            //(Line.Type <> Line.Type::" ") and
                            (not STDR_ReportManagement.ShowZerroLineBecauseOfLinkedLines(Line."Document No.", Line."Line No."))
                            then
                                CurrReport.SKIP();

                            // skip linked or attached lines. They will be printen in de detaillineloop
                            if STDR_ReportManagement.RecSkipLineBecauseIsShownAsLinkedToOtherLine(Line) then
                                CurrReport.SKIP();
                        end else begin
                            if (not STDR_ReportSetup."Show Lines Zerro Qty") and
                                (Line2.Quantity = 0) and
                                //(Line.Type <> Line.Type::" ") and
                                (not STDR_ReportManagement.ShowZerroLineBecauseOfLinkedLines(Line2."Document No.", Line2."Line No."))
                            then
                                CurrReport.SKIP();

                            // skip linked or attached lines. They will be printen in de detaillineloop
                            if STDR_ReportManagement.RecSkipLineBecauseIsShownAsLinkedToOtherLine(Line2) then
                                CurrReport.SKIP();
                        end;
                        // fill line fields
                        FillLineFds();

                        // fix performance problem
                        // clear picture after first line, otherwise every line and every vatdetailline will have the picture
                        // which results in an realy big xml file
                        if LineEntryNo > 1 then begin
                            CLEAR(STDR_ReportSetup.Picture);
                            CLEAR(STDR_ReportSetup."Picture 2");
                            CLEAR(STDR_ReportSetup."Picture 3");
                            CLEAR(STDR_ReportSetup."Picture 4");
                        end;
                    end;

                    trigger OnPreDataItem()
                    var
                        MoreLines: Boolean;
                    begin
                        // Reset vars en buffer tables
                        LineEntryNo := 0;
                        CLEAR(TempDetailBuffer2);
                        TempDetailBuffer2.DELETEALL();

                        if HeaderLoop.Number <= TmpHeaders then begin
                            TmpLine.RESET();
                            TmpLine.SETRANGE("Document No.", Header."No.");

                            //skip empty lines at the end
                            MoreLines := TmpLine.FIND('+');
                            while MoreLines and (TmpLine.Description = '') and (TmpLine."No." = '') and (TmpLine.Quantity = 0) do
                                MoreLines := TmpLine.NEXT(-1) <> 0;
                            if not MoreLines then
                                CurrReport.BREAK();
                            TmpLine.SETRANGE("Line No.", 0, TmpLine."Line No.");
                            SETRANGE(Number, 1, TmpLine.COUNT());

                            TmpLine.SETCURRENTKEY("Order No.", "Order Line No.");
                        end else begin
                            TmpLine2.RESET();
                            TmpLine2.SETRANGE("Document No.", Header2."No.");

                            //skip empty lines at the end
                            MoreLines := TmpLine2.FIND('+');
                            while MoreLines and (TmpLine2.Description = '') and (TmpLine2."item No." = '') and (TmpLine2.Quantity = 0) do
                                MoreLines := TmpLine2.NEXT(-1) <> 0;
                            if not MoreLines then
                                CurrReport.BREAK();
                            TmpLine2.SETRANGE("Line No.", 0, TmpLine2."Line No.");
                            SETRANGE(Number, 1, TmpLine2.COUNT());

                            TmpLine2.SETCURRENTKEY("Transfer Order No.", "Item No.", "Shipment Date");
                        end;
                    end;

                    trigger OnPostDataItem()
                    var
                        STDR_RepFmtMgt: Codeunit "STDR_Report Format Mgt";
                    begin
                        if TotalNoOfPackages <> 0 then begin

                            totalPackageslbl := STDR_ReportManagement.GetTranslCurrRep('Total Packages');
                            TotalPackagesTxt := Format(TotalNoOfPackages);
                        end else begin
                            TotalPackagesLbl := '';
                            TotalPackagesTxt := '';
                        end;
                        If TotalVolume <> 0 then begin
                            totalvolumelbl := STDR_ReportManagement.GetTranslCurrRep('Total Volume');
                            if HeaderLoop.Number <= TmpHeaders then
                                TotalVolumeTxt := STDR_RepFmtMgt.FormatDecimal(TotalVolume, 0, 3, header."Language Code", STDR_ReportManagement.GetReportNo())
                            else
                                TotalVolumeTxt := STDR_RepFmtMgt.FormatDecimal(TotalVolume, 0, 3, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo())
                        end else begin
                            TotalVolumeLbl := '';
                            TotalVolumeTxt := '';
                        end;
                        if TotalRemboursAmount <> 0 then begin
                            TotalRemboursLbl := STDR_ReportManagement.GetTranslCurrRep('Rembours');
                            TotalRemboursTxt := '€ ' + STDR_RepFmtMgt.FormatDecimal(TotalRemboursAmount, 0, 2, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo()) + STDR_ReportManagement.GetTranslCurrRep('Incl. BTW');
                        end;
                    end;
                }

                dataitem(Total; Integer)
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(TotalVolumeLbl; TotalVolumeLbl)
                    { }
                    column(TotalVolumeTxt; TotalVolumeTxt)
                    { }
                    column(TotalRemboursLbl; TotalRemboursLbl)
                    { }
                    column(TotalRemboursTxt; TotalRemboursTxt)
                    { }
                    column(TotalPackagesLbl; TotalPackagesLbl)
                    { }
                    column(TotalPackagesTxt; TotalPackagesTxt)
                    { }


                }
                dataitem(IntrastatTotal; "Integer")
                {
                    DataItemTableView = SORTING (Number);
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
                    column(Intrastat_GrossWeight; STDR_ReportManagement.FormatDecimal(GrossWeight, 2, 2))
                    {
                    }

                    trigger OnAfterGetRecord()

                    begin
                        if Number > 1 then
                            TempDetailBuffer2.NEXT()
                        else
                            TempDetailBuffer2.FINDSET();

                        GrossWeight := 0;
                        TempIntraGrossBuffer.reset;
                        TempIntraGrossBuffer.setrange("No.", TempDetailBuffer2."No.");
                        If TempIntraGrossBuffer.FindFirst() then
                            GrossWeight := TempIntraGrossBuffer.Quantity;
                    end;

                    trigger OnPreDataItem()
                    begin
                        TempDetailBuffer2.RESET();
                        SETRANGE(Number, 1, TempDetailBuffer2.COUNT());
                    end;
                }

                trigger OnAfterGetRecord()

                begin
                    //set outputno
                    if Number > 1 then begin
                        OutputNo += 1;
                        CLEAR(STDR_ReportSetup.Picture); //because of performance
                        CLEAR(STDR_ReportSetup."Picture 2");
                        CLEAR(STDR_ReportSetup."Picture 3");
                        CLEAR(STDR_ReportSetup."Picture 4");
                    end;

                    // fill header fields
                    if (Number = 1) and STDR_ReportManagement.PrintPACoverPage() then
                        FillPACoverPageHeaderFds()
                    else begin
                        FillHeaderFds();
                        //determine document name and add copy text if number is bigger then one
                        DocName := STDR_ReportManagement.GetTranslCurrRep('Combined Whse. Shipment');
                        STDR_ReportManagement.AddTxtValue(1, HeaderFds[4], DocName);
                    end;
                end;

                trigger OnPostDataItem()

                begin
                    if not CurrReport.PREVIEW() then
                        // Update field "No. Printed" in header
                        STDR_ReportManagement.HeaderCountPrinted();
                end;

                trigger OnPreDataItem()

                begin
                    //determine no of copies of this document
                    SETRANGE(Number, 1, STDR_ReportManagement.GetNoOfLoops(NoOfExtraCopies));
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()

            begin
                //Synchronize temp data
                if Number <= TmpHeaders then
                    IF Number > 1 then
                        TmpHeader.NEXT()
                    else
                        TmpHeader.findset()
                else
                    If number > TmpHeaders + 1 then
                        TmpHeader2.Next()
                    else
                        TmpHeader2.FindSet();

                IF Number <= TmpHeaders then begin
                    Header.TRANSFERFIELDS(TmpHeader);
                    //GroupCode := Header."No.";
                    GroupCode := Header."Ship-to Name" + header."Ship-to Address";
                    STDR_ReportManagement.SetCurrentRec(Header."Language Code", '', Header."Document Date", Header."Currency Code", Header);

                end else begin
                    Header2.TRANSFERFIELDS(TmpHeader2);
                    //GroupCode := Header2."No.";
                    GroupCode := Header2."Transfer-to Code";
                    STDR_ReportManagement.SetCurrentRec('', '', Header2."posting Date", '', Header2);
                end;


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
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();

                // possibly Archive Document and/or Log Interaction
                if not CurrReport.PREVIEW() then begin
                    STDR_ReportManagement.ArchiveDocument();
                    STDR_ReportManagement.LogInteraction();
                end;
            end;

            trigger OnPreDataItem()

            begin
                TmpHeader.RESET();
                TmpHeader2.Reset();
                TmpHeaders := TmpHeader.count();
                TmpHeader2s := TmpHeader2.count();
                setrange(Number, 1, TmpHeaders + TmpHeader2s);
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
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    field(NoOfExtraCopies; NoOfExtraCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Extra Copies';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        OptionCaption = 'Default,Yes,No';
                        Visible = LogInteractionVisible;
                    }
                    field(ShowAsmInformation; ShowAssemblyInfo)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        OptionCaption = 'Default,Yes,No';
                        Visible = ShowAssemblyInfoVisible;
                    }
                    field(ShowItemTracking; ShowItemTracking)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Show Serial/Lot Number';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowLineComments; ShowLineComments)
                    {
                        ApplicationArea = Comments;
                        Caption = 'Show Line Comments';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowLinkedLineInDetails; ShowLinkedLineInDetails)
                    {
                        ApplicationArea = Advanced, Suite;
                        Caption = 'Show Linked Line in Details';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(ShowZerroLines; ShowLinesZerroQty)
                    {
                        ApplicationArea = Advanced, Suite;
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
        STDR_ReportManagement.InitReport(CurrReport.OBJECTID(false));

        // get default values for request page
        STDR_ReportManagement.InitReportReqPageLogInteract(LogInteraction, LogInteractionVisible);
        STDR_ReportManagement.InitReportReqPageArchiveDoc(ArchiveDoc, ArchiveDocVisible);
        STDR_ReportManagement.InitReportReqPageAssemblyInfo(ShowAssemblyInfo, ShowAssemblyInfoVisible);
    end;

    trigger OnPreReport()
    begin
        // setup report management codeunit with preview
        STDR_ReportManagement.SetPreview(CurrReport.PREVIEW());
    end;

    var
        TempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        TempDetailBuffer2: Record "STDR_Report Detail Line Buffer";
        TempIntraGrossBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        STDR_ReportSetup: Record "STDR_Report Setup";
        TmpWhseShpt: Record "Warehouse Shipment Header" temporary;
        TmpHeader: Record "Sales Shipment Header" temporary;
        TmpLine: Record "Sales Shipment Line" temporary;
        TmpHeader2: Record "Transfer Shipment Header" temporary;
        TmpLine2: Record "Transfer Shipment Line" temporary;
        Header: Record "Sales Shipment Header";
        Line: Record "Sales Shipment Line";
        Header2: record "Transfer Shipment Header";
        Line2: Record "Transfer Shipment Line";
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        STDR_CommonFunctions: Codeunit "STDR_Common Functions";
        GroupCode: Code[200];
        DocName: Text;
        HeaderFds: array[5] of Text;
        FontFamily: Text;
        LineFormatTxt: Text;
        LineTxt: array[20] of Text;
        DetLineTxt: array[20] of Text;
        OrderNo: Text;
        OrderRef: Text;
        TotalVolumeLbl: text;
        TotalPackagesLbl: text;
        TotalVolumeTxt: text;
        TotalRemboursLbl: text;
        TotalRemboursAmount: Decimal;
        TotalRemboursTxt: text;
        TotalPackagesTxt: Text;
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
        TotalVolume: Decimal;
        TotalNoOfPackages: Integer;
        GrossWeight: Decimal;
        OutputNo: Integer;
        LineEntryNo: Integer;
        NoOfExtraCopies: Integer;
        LineTypeNo: Integer;
        DetLineTypeNo: Integer;
        NextLineNo: Integer;
        TmpHeaders: Integer;
        TmpHeader2s: Integer;
        NextIntraGrossBufferEntryNo: Integer;
        FontArray: array[8] of Text;

    procedure FillHeaderFds()
    var

        CompanyInfo: Record "STDR_Report Setup";
        FormatAddress: Codeunit "Format Address";
        LeftAddr: array[8] of Text[80];
        RightAddr: array[8] of Text[80];
        ExtraAddr: array[8] of Text[80];
        CompanyAddr: array[8] of Text[80];
        OurVatNoOrEnterpriseNoCap: Text;
        OurVatNoOrEnterpriseNo: Text;
        VatNoOrEnterpriseNoCap: Text;
        VatNoOrEnterpriseNo: Text;
        ExtDocCap: Text;
        ExtDocNo: Text;
        CustVendCap: Text;
        CustVendNo: Text;
        i: Integer;
        t: array[10] of Text;
    begin
        TotalVolume := 0;
        TotalNoOfPackages := 0;
        TotalRemboursAmount := 0;
        TotalRemboursTxt := '';
        TotalRemboursLbl := '';
        TotalPackagesLbl := '';
        TotalPackagesTxt := '';
        TempIntraGrossBuffer.reset;
        TempIntraGrossBuffer.DeleteAll();
        NextIntraGrossBufferEntryNo := 0;

        //sometime the companyinfo is overrulled by the responsibilycenter or report setup code.
        //So we use the report_setup var. The report_mgt codeunit has filled/copied this var with the correct values
        CompanyInfo := STDR_ReportSetup;
        STDR_ReportManagement.FormatAddresses(LeftAddr, RightAddr, ExtraAddr, CompanyAddr);
        if HeaderLoop.Number > TmpHeaders then begin
            CASE STDR_ReportSetup."Left Address" of
                STDR_ReportSetup."Left Address"::"Ship-To":
                    begin
                        FormatAddress.TransferShptTransferTo(LeftAddr, Header2);
                        clear(RightAddr);
                    end;
            END;
            CASE STDR_ReportSetup."Right Address" of
                STDR_ReportSetup."Right Address"::"Ship-To":
                    begin
                        FormatAddress.TransferShptTransferTo(RightAddr, Header2);
                        Clear(LeftAddr);
                    end;
            END;
        end;

        STDR_ReportManagement.GetOurVatNoOrEnterpriseNo(CompanyInfo, OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);

        //Set per document:fontfamily, fontname, fontsize
        FontFamily := STDR_ReportManagement.GetFontFamily();
        STDR_ReportManagement.GetFontArray(FontArray);

        // 1= Customer Address and ship-to address
        CLEAR(HeaderFds);
        case STDR_ReportSetup."Left Address" of
            STDR_ReportSetup."Left Address"::"Bill-To/Pay-To":
                if HeaderLoop.Number <= TmpHeaders then
                    STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Bill-to Address');
            STDR_ReportSetup."Left Address"::"Ship-To":
                STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Ship-to Address');
            STDR_ReportSetup."Left Address"::"Sell-To/Buy-From":
                STDR_ReportManagement.AddTranslValue(1, HeaderFds[1], 'Sell-to Address');
        end; /*case*/
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
                if HeaderLoop.Number <= TmpHeaders then
                    STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Bill-to Address');
            STDR_ReportSetup."Right Address"::"Ship-To":
                STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Ship-to Address');
            STDR_ReportSetup."Right Address"::"Sell-To/Buy-From":
                STDR_ReportManagement.AddTranslValue(10, HeaderFds[1], 'Sell-to Address');
        end; /*case*/
        STDR_ReportManagement.AddTxtValue(11, HeaderFds[1], RightAddr[1]);
        STDR_ReportManagement.AddTxtValue(12, HeaderFds[1], RightAddr[2]);
        STDR_ReportManagement.AddTxtValue(13, HeaderFds[1], RightAddr[3]);
        STDR_ReportManagement.AddTxtValue(14, HeaderFds[1], RightAddr[4]);
        STDR_ReportManagement.AddTxtValue(15, HeaderFds[1], RightAddr[5]);
        STDR_ReportManagement.AddTxtValue(16, HeaderFds[1], RightAddr[6]);
        STDR_ReportManagement.AddTxtValue(17, HeaderFds[1], RightAddr[7]);
        STDR_ReportManagement.AddTxtValue(18, HeaderFds[1], RightAddr[8]);

        // 2= Company info
        STDR_ReportManagement.AddTxtValue(1, HeaderFds[2], CompanyAddr[1]);
        STDR_ReportManagement.AddTxtValue(2, HeaderFds[2], CompanyAddr[2]);
        STDR_ReportManagement.AddTxtValue(3, HeaderFds[2], CompanyAddr[3]);
        if CompanyAddr[4] <> '' then begin
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[2], CompanyAddr[4]);
            i := 1;
        end;
        //added 4+1 for lines below
        if CompanyAddr[5] <> '' then begin
            STDR_ReportManagement.AddTxtValue(4 + i, HeaderFds[2], CompanyAddr[5]);
            i += 1;
        end;
        if CompanyInfo."Phone No." <> '' then begin
            STDR_ReportManagement.AddTranslValue2(4 + i, HeaderFds[2], 'Phone No.', ' : ', CompanyInfo."Phone No.");
            i += 1;
        end;
        if CompanyInfo."Fax No." <> '' then begin
            STDR_ReportManagement.AddTranslValue2(4 + i, HeaderFds[2], 'Fax No.', ' : ', CompanyInfo."Fax No.");
            i += 1;
        end;
        if OurVatNoOrEnterpriseNo <> '' then begin
            STDR_ReportManagement.AddTxtValue(4 + i, HeaderFds[2], OurVatNoOrEnterpriseNoCap + ' : ' + OurVatNoOrEnterpriseNo);
            i += 1;
        end;
        if CompanyInfo."Registration No." <> '' then begin
            STDR_ReportManagement.AddTranslValue2(4 + i, HeaderFds[2], 'Registration No.', ' : ', CompanyInfo."Registration No.");
            i += 1;
        end;

        // 3= document and vat
        STDR_ReportManagement.GetCustVendNo(CustVendCap, CustVendNo, 1);
        STDR_ReportManagement.AddTxtValue(1, HeaderFds[3], CustVendCap);
        STDR_ReportManagement.AddTxtValue(2, HeaderFds[3], CustVendNo);
        STDR_ReportManagement.AddTxtValue(3, HeaderFds[3], STDR_ReportManagement.GetDocNoCap());
        if HeaderLoop.Number <= TmpHeaders then
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[3], Header."Shortcut Dimension 2 Code")
        else
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[3], Header2."Shortcut Dimension 2 Code");
        STDR_ReportManagement.GetExtDocOrVendDocNo(ExtDocCap, ExtDocNo);
        if ExtDocNo <> '' then begin
            STDR_ReportManagement.AddTxtValue(5, HeaderFds[3], ExtDocCap);
            STDR_ReportManagement.AddTxtValue(6, HeaderFds[3], ExtDocNo);
        end;
        if HeaderLoop.Number <= TmpHeaders then
            STDR_ReportManagement.RecGetVatNoOrEnterpriseNo(Header, VatNoOrEnterpriseNoCap, VatNoOrEnterpriseNo)
        else
            STDR_ReportManagement.RecGetVatNoOrEnterpriseNo(Header2, VatNoOrEnterpriseNoCap, VatNoOrEnterpriseNo);
        STDR_ReportManagement.AddTxtValue(15, HeaderFds[3], VatNoOrEnterpriseNoCap);
        STDR_ReportManagement.AddTxtValue(16, HeaderFds[3], VatNoOrEnterpriseNo);
        STDR_ReportManagement.AddTranslValue(9, HeaderFds[3], 'Date');
        if HeaderLoop.Number <= TmpHeaders then
            STDR_ReportManagement.AddDateValue(10, HeaderFds[3], Header."Document Date")
        else
            STDR_ReportManagement.AddDateValue(10, HeaderFds[3], HEader2."posting Date");
        STDR_ReportManagement.AddTranslValue(22, HeaderFds[3], 'Shipment Method');
        STDR_ReportManagement.AddTranslValue(30, HeaderFds[3], 'Order No.');

        if HeaderLoop.Number <= TmpHeaders then begin
            STDR_ReportManagement.AddTranslValue(20, HeaderFds[3], 'Payment Terms');
            STDR_ReportManagement.AddTxtValue(21, HeaderFds[3], STDR_ReportManagement.GetPaymentTerms(header."Payment Terms Code"));
            STDR_ReportManagement.AddTxtValue(23, HeaderFds[3], STDR_ReportManagement.GetShipmentMethod(Header."Shipment Method Code"));
        end else
            STDR_ReportManagement.AddTxtValue(23, HeaderFds[3], STDR_ReportManagement.GetShipmentMethod(Header2."Shipment Method Code"));

        // 4= Other Header fields
        if STDR_ReportSetup."Show Page No." then
            STDR_ReportManagement.AddTranslValue(2, HeaderFds[4], 'Page %1 of %2');
        //header text
        STDR_ReportManagement.AddTxtValue(3, HeaderFds[4], STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(1));
        //bottom lines 1..3
        if STDR_ReportSetup.IBAN <> '' then
            t[1] := STRSUBSTNO('%1 %2 %3',
                STDR_ReportSetup."Bank Name", STDR_ReportManagement.GetTranslCurrRep('Account No.'), STDR_ReportSetup.IBAN);
        if (STDR_ReportSetup.IBAN <> '') and (STDR_ReportSetup."SWIFT Code" <> '') then
            t[1] := STRSUBSTNO('%1 %2 %3 %4 %5',
                STDR_ReportSetup."Bank Name", STDR_ReportManagement.GetTranslCurrRep('BIC'), STDR_ReportSetup."SWIFT Code",
                STDR_ReportManagement.GetTranslCurrRep('Account No.'), STDR_ReportSetup.IBAN);
        t[2] := STRSUBSTNO('%1 %2', OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);
        STDR_ReportManagement.AddTxtValue(5, HeaderFds[4], STDR_CommonFunctions.AddMultiTextToText(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], '%1', 0));
        CLEAR(t);
        //Combine header Text with Customer or Vendor Comment text
        t[1] := STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(1);
        t[2] := STDR_ReportManagement.GetCommAsLongStringForCurrentReport();
        t[3] := STDR_CommonFunctions.Add2TextsToText(t[1], t[2], '%1', 0);
        if t[3] <> '' then
            t[3] += '%1';
        STDR_ReportManagement.AddTxtValue(10, HeaderFds[4], t[3]);
        CLEAR(t);
        //footer text
        t[1] := STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(2);
        if t[1] <> '' then
            t[1] := '%1' + t[1];
        STDR_ReportManagement.AddTxtValue(4, HeaderFds[4], t[1]);
        CLEAR(t);

        // 5= Line Header Fields and vat
        STDR_ReportManagement.AddTranslValue(1, HeaderFds[5], 'No.');
        STDR_ReportManagement.AddTranslValue(2, HeaderFds[5], 'Description');
        STDR_ReportManagement.AddTranslValue(3, HeaderFds[5], 'Quantity');
        STDR_ReportManagement.AddTranslValue(4, HeaderFds[5], 'Unit of Measure');
        STDR_ReportManagement.AddTranslValue(5, HeaderFds[5], 'Order Quantity');
        STDR_ReportManagement.AddTranslValue(6, HeaderFds[5], 'Remaining Quantity');
        STDR_ReportManagement.AddTranslValue(8, HeaderFds[5], 'Unit Volume');
        STDR_ReportManagement.AddTranslValue(9, HeaderFds[5], 'Packages');

        // Intrastat totals block
        STDR_ReportManagement.AddTranslValue(10, HeaderFds[5], 'Intrastat Code');
        if STDR_ReportSetup."Show Intrastat in Total Block" in [STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeight, STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeightAmt] then
            STDR_ReportManagement.AddTranslValue(11, HeaderFds[5], 'Description');
        STDR_ReportManagement.AddTranslValue(12, HeaderFds[5], 'Net Weight');
        if STDR_ReportSetup."Show Intrastat in Total Block" in [STDR_ReportSetup."Show Intrastat in Total Block"::NoWeightAmt, STDR_ReportSetup."Show Intrastat in Total Block"::NoDescrWeightAmt] then
            STDR_ReportManagement.AddTranslValue(13, HeaderFds[5], 'Amount');

        IF STDR_ReportSetup."Show Intrastat in Details" <> STDR_ReportSetup."Show Intrastat in Details"::" " then
            STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], 'Gross Weight');
        STDR_ReportManagement.AddTranslValue(14, HeaderFds[5], 'Gross Weight');

        FillExtraHeaderfields();

    end;

    procedure FillPACoverPageHeaderFds()
    begin
        FontFamily := STDR_ReportManagement.GetFontFamily();
        STDR_ReportManagement.GetFontArray(FontArray);
        STDR_ReportManagement.AddTxtValue(11, FontFamily, 'White');
        STDR_ReportManagement.FormatPACoverPageAddresses(HeaderFds);

        if HeaderLoop.Number <= TmpHeaders then
            STDR_ReportManagement.OnAfterFillPACoverPageHeaderFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, FontArray, HeaderFds)
        else
            STDR_ReportManagement.OnAfterFillPACoverPageHeaderFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header2, FontArray, HeaderFds);

    end;

    procedure FillLineFds()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PaymentMethod: Record "Payment Method";
        item: Record Item;
        ItemUOM: Record "Item Unit of Measure";
        ItemLedgEntry: Record "Item Ledger Entry";
        TransferLine: Record "Transfer Line";
        LineDisc: Text;
        UoMtxt: Text;
        LinePrice: Decimal;
        Qty: Decimal;
        OrderQty: Decimal;
        RemainingQty: Decimal;
        QuantityPriceUnit: Decimal;
        QtyFactorPriceUoM: Decimal;
        PriceUnitofMeasure: Text;
    begin
        if HeaderLoop.Number <= TmpHeaders then
            with Line do begin
                LineEntryNo += 1;
                LineTypeNo := Type;
                LineFormatTxt := STDR_ReportManagement.GetLineFormat(STDR_Bold, STDR_Indent);
                STDR_ReportManagement.GetQtyPriceUoM(Line, QuantityPriceUnit, QtyFactorPriceUoM, PriceUnitofMeasure);
                STDR_ReportManagement.GetLineQtyPriceDisc(LinePrice, LineDisc, Qty, UoMtxt, "Unit Price", "Line Discount %",
                "STDR_Line Discount Amount", Quantity, QuantityPriceUnit, "Unit of Measure", PriceUnitofMeasure);   //was/is prev shipped io amount??
                STDR_ReportManagement.GetLineQtyPriceDisc(LinePrice, LineDisc, Qty, UoMtxt, "Unit Price", "Line Discount %",
                0, Quantity, Quantity, "Unit of Measure", "Unit of Measure");
                OrderQty := Line."STDR_Order Quantity";
                RemainingQty := Line."STDR_Order Quantity" - Line."STDR_Quantity Prev. Shipped" - Line.Quantity;
                if STDR_ReportSetup."Show Unit of Measure" = STDR_ReportSetup."Show Unit of Measure"::"Price UoM" then begin
                    OrderQty := OrderQty * QtyFactorPriceUoM;
                    RemainingQty := RemainingQty * QtyFactorPriceUoM;
                end;
                CLEAR(LineTxt);
                LineTxt[1] := STDR_ReportManagement.GetLineNo2(STDR_Indent, "No.", "Variant Code", "Cross-Reference No.", '', '', "Location Code");
                LineTxt[2] := STDR_ReportManagement.GetLineDesc(STDR_Indent, Description, "Description 2");
                if Type > Type::" " then begin
                    LineTxt[3] := STDR_ReportManagement.FormatQuantityDecimal(Qty);
                    LineTxt[4] := UoMtxt;
                    if OrderQty <> 0 then begin
                        LineTxt[5] := STDR_ReportManagement.FormatQuantityDecimal(OrderQty);
                        if RemainingQty <> 0 then
                            LineTxt[6] := STDR_ReportManagement.FormatQuantityDecimal(RemainingQty);
                    end;
                    IF STDR_ReportSetup."Show Intrastat in Details" <> STDR_ReportSetup."Show Intrastat in Details"::" " then
                        LineTxt[7] := STDR_ReportManagement.FormatDecimal("Gross Weight", 2, 2);

                    If type = Type::Item then begin
                        Item.get("No.");
                        AddGrossWeight("No.", Item."Gross Weight" * "Quantity (Base)");
                        ItemUOM.get("No.", "Unit of Measure Code");
                        IF ItemUOM.Cubage <> 0 THEN BEGIN
                            Linetxt[8] := STDR_ReportManagement.FormatQuantityDecimal(Quantity * ItemUOM.Cubage);
                            TotalVolume := TotalVolume + (Quantity * ItemUOM.Cubage);
                        END;
                    end;

                    TotalNoOfPackages += "Dimension Set ID";

                    LineTxt[9] := Format("Dimension Set ID"); //colli
                    LineTxt[10] := '';
                end;

                OrderRef := '';
                if "Order No." <> '' then
                    if SalesHeader.GET(1, "Order No.") then begin
                        if SalesHeader."Your Reference" <> '' then
                            OrderRef := SalesHeader."Your Reference";
                        if SalesHeader."Payment Method Code" = 'REMBOURS' then begin
                            TotalRemboursAmount += "STDR_Amount Including VAT";
                        end;
                    end;
                OrderNo := "Order No.";
                if OrderRef <> '' then
                    OrderNo := OrderNo + ':%1' + OrderRef;
            end /*with do*/
        else
            with Line2 do begin
                LineEntryNo += 1;
                LineTypeNo := 1;
                LineFormatTxt := STDR_ReportManagement.GetLineFormat(false, 0); //STDR_Bold, STDR_Indent);
                STDR_ReportManagement.GetQtyPriceUoM(Line2, QuantityPriceUnit, QtyFactorPriceUoM, PriceUnitofMeasure);
                STDR_ReportManagement.GetLineQtyPriceDisc(LinePrice, LineDisc, Qty, UoMtxt, 0, 0, GetQtyPrevTransfer(), Quantity, QuantityPriceUnit, "Unit of Measure", PriceUnitofMeasure);
                STDR_ReportManagement.GetLineQtyPriceDisc(LinePrice, LineDisc, Qty, UoMtxt, 0, 0, 0, Quantity, Quantity, "Unit of Measure", "Unit of Measure");

                ItemLedgEntry.get("Item Shpt. Entry No.");
                If TransferLine.get(ItemLedgEntry."Order No.", ItemLedgEntry."Order Line No.") then begin
                    OrderQty := transferline.Quantity; //Line2."STDR_Order Quantity";
                    RemainingQty := TransferLine."Outstanding Quantity"; //Line2."STDR_Order Quantity" - Line2."STDR_Quantity Prev. Shipped" - Line2.Quantity;
                end else begin
                    OrderQty := 0;  //TODO
                    RemainingQty := 0;  //TODO
                end;

                if STDR_ReportSetup."Show Unit of Measure" = STDR_ReportSetup."Show Unit of Measure"::"Price UoM" then begin
                    OrderQty := OrderQty * QtyFactorPriceUoM;
                    RemainingQty := RemainingQty * QtyFactorPriceUoM;
                end;
                CLEAR(LineTxt);
                LineTxt[1] := STDR_ReportManagement.GetLineNo2(0, "item No.", "Variant Code", '', '', '', line2."Transfer-to Code");
                LineTxt[2] := STDR_ReportManagement.GetLineDesc(0, Description, "Description 2");

                LineTxt[3] := STDR_ReportManagement.FormatQuantityDecimal(Qty);
                LineTxt[4] := UoMtxt;
                if OrderQty <> 0 then begin
                    LineTxt[5] := STDR_ReportManagement.FormatQuantityDecimal(OrderQty);
                    if RemainingQty <> 0 then
                        LineTxt[6] := STDR_ReportManagement.FormatQuantityDecimal(RemainingQty);
                end;
                IF STDR_ReportSetup."Show Intrastat in Details" <> STDR_ReportSetup."Show Intrastat in Details"::" " then
                    LineTxt[7] := STDR_ReportManagement.FormatDecimal("Gross Weight", 2, 2);

                Item.get("Item No.");
                AddGrossWeight("Item No.", Item."Gross Weight" * "Quantity (Base)");
                ItemUOM.get("item No.", "Unit of Measure Code");
                IF ItemUOM.Cubage <> 0 THEN BEGIN
                    Linetxt[8] := STDR_ReportManagement.FormatQuantityDecimal(Quantity * ItemUOM.Cubage);
                    TotalVolume := TotalVolume + (Quantity * ItemUOM.Cubage);
                END;

                TotalNoOfPackages += "Dimension Set ID";

                LineTxt[9] := Format("Dimension Set ID"); //colli
                LineTxt[10] := '';

                OrderRef := '';
                if "transfer Order No." <> '' then
                    if SalesHeader.GET(1, "transfer Order No.") then
                        if SalesHeader."Your Reference" <> '' then
                            OrderRef := SalesHeader."Your Reference";

                OrderNo := "transfer Order No.";
                if OrderRef <> '' then
                    OrderNo := OrderNo + ':%1' + OrderRef;
            end;
    end;

    procedure FillDetailLineFds()
    var
        DetLineDisc: Text;
        DetLineUoMtxt: Text;
        DetLinePrice: Decimal;
        DetLineQty: Decimal;
        RemainingQty: Decimal;
    begin
        with TempDetailBuffer do begin
            STDR_ReportManagement.GetLineQtyPriceDisc(DetLinePrice, DetLineDisc, DetLineQty, DetLineUoMtxt, Price, "Line Discount %",
              "Line Discount Amount", Quantity, "Quantity (Price Unit)", "Unit of Measure", "Price Unit of Measure");
            DetLineTypeNo := Type;
            CLEAR(DetLineTxt);
            DetLineTxt[1] := STDR_ReportManagement.GetLineNo2(Line.STDR_Indent, "No.", "Variant Code", "Cross-Reference No.", "Vendor Item No.", "Vendor No.", "Location Code");
            DetLineTxt[2] := STDR_ReportManagement.GetDescFromTempDetailBuffer(TempDetailBuffer, Line.STDR_Indent);
            if Type > Type::" " then begin
                DetLineTxt[3] := STDR_ReportManagement.FormatQuantityDecimal(DetLineQty);
                DetLineTxt[4] := DetLineUoMtxt;
                if "Order Quantity" <> 0 then begin
                    DetLineTxt[5] := STDR_ReportManagement.FormatQuantityDecimal("Order Quantity");
                    RemainingQty := "Order Quantity" - "Quantity Prev. Shipped" - Quantity;
                    if RemainingQty <> 0 then
                        DetLineTxt[6] := STDR_ReportManagement.FormatQuantityDecimal(RemainingQty);
                end;
                DetLineTxt[7] := '';
                DetLineTxt[8] := '';
                DetLineTxt[9] := '';
                DetLineTxt[10] := '';
            end;
        end; /*with do*/
    end;

    local procedure CreateTempData()
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        TransferShptHdr: record "Transfer shipment header";
        TransfershptLine: record "Transfer Shipment Line";
        RegWhseActLine: Record "Registered Whse. Activity Line";
        PostedWhseShptLine2: Record "Posted Whse. Shipment Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        NoOfPackages: Integer;

    begin
        SalesShptHeader.SETRANGE("No.", PostedWhseShptLine."Posted Source No.");
        if SalesShptHeader.FINDSET() then
            repeat
                TmpHeader.RESET();
                TmpHeader.SETRANGE("Sell-to Customer No.", SalesShptHeader."Sell-to Customer No.");
                TmpHeader.SETRANGE("Shipment Method Code", SalesShptHeader."Shipment Method Code");
                TmpHeader.SETRANGE("Ship-to Address", SalesShptHeader."Ship-to Address");
                TmpHeader.SETRANGE("Ship-to Address 2", SalesShptHeader."Ship-to Address 2");
                TmpHeader.SETRANGE("Ship-to City", SalesShptHeader."Ship-to City");
                TmpHeader.SETRANGE("Ship-to Post Code", SalesShptHeader."Ship-to Post Code");
                TmpHeader.SETRANGE("Ship-to County", SalesShptHeader."Ship-to County");
                TmpHeader.SETRANGE("Ship-to Country/Region Code", SalesShptHeader."Ship-to Country/Region Code");
                TmpHeader.SETRANGE("Shortcut Dimension 1 Code", PostedWhseShptLine."Whse. Shipment No.");
                if not TmpHeader.FINDFIRST() then begin
                    TmpHeader.RESET();
                    TmpHeader.INIT();
                    TmpHeader := SalesShptHeader;
                    TmpHeader."Shortcut Dimension 1 Code" := PostedWhseShptLine."Whse. Shipment No.";
                    TmpHeader."Shortcut Dimension 2 Code" := PostedWhseShptLine."No.";
                    TmpHeader."Dimension Set ID" := 0;
                    TmpHeader.INSERT();
                end;

                SalesShptLine.RESET();
                SalesShptLine.SETRANGE("Document No.", SalesShptHeader."No.");
                if SalesShptLine.FINDSET() then begin
                    NextLineNo := TmpHeader."Dimension Set ID";  //Abuse
                    repeat
                        //Get colli from pick lines
                        NoOfPackages := 0;
                        PostedWhseShptLine2.setrange("Posted Source Document", PostedWhseShptLine2."Posted Source Document"::"Posted Shipment");
                        PostedWhseShptLine2.Setrange("Posted Source No.", SalesShptLine."Document No.");
                        PostedWhseShptLine2.Setrange("Source No.", SalesShptLine."Order No.");
                        postedwhseshptline2.Setrange("Source Line No.", SalesShptLine."Order Line No.");
                        If PostedWhseShptLine2.FindSet() then
                            repeat
                                RegWhseActLine.setrange("Whse. Document Type", RegWhseActLine."Whse. Document Type"::Shipment);
                                RegWhseActLine.setrange("Whse. Document NO.", PostedWhseShptLine2."Whse. Shipment No.");
                                RegWhseActLine.setrange("Whse. Document Line No.", PostedWhseShptLine2."Whse Shipment Line No.");
                                RegWhseActLine.Setrange("Action Type", RegWhseActLine."Action Type"::Take);
                                IF RegWhseActLine.FindSet() then
                                    repeat
                                        NoOfPackages := NoOfPackages + RegWhseActLine."No. of Packages";
                                    until RegWhseActLine.Next() = 0;
                            until PostedWhseShptLine2.Next() = 0;
                        //TmpHeader."Shipping Agent Code" := format(TotalNoOfPackages); //abuse
                        tmpheader.modify;
                        TmpLine.RESET();
                        TmpLine.SETRANGE("Document No.", TmpHeader."No.");
                        TmpLine.SETRANGE("Order No.", SalesShptLine."Order No.");
                        //TmpLine.SETRANGE(Type, SalesShptLine.Type);
                        //TmpLine.SETRANGE("No.", SalesShptLine."No.");
                        TmpLine.SETRANGE("Variant Code", SalesShptLine."Variant Code");
                        TmpLine.SETRANGE("Unit of Measure Code", SalesShptLine."Unit of Measure Code");
                        TmpLine.SetRange("Order Line No.", SalesShptLine."Order Line No.");
                        if not TmpLine.FINDFIRST() then begin
                            NextLineNo := NextLineNo + 10000;
                            TmpLine.RESET();
                            TmpLine.INIT();
                            TmpLine.TRANSFERFIELDS(SalesShptLine);
                            TmpLine."Document No." := TmpHeader."No.";
                            TmpLine."Line No." := NextLineNo;
                            Tmpline."Dimension Set ID" := NoOfPackages; //Abuse
                            TmpLine.INSERT();

                            TmpHeader."Dimension Set ID" := NextLineNo;
                            TmpHeader.MODIFY();

                        end;
                    until SalesShptLine.NEXT() = 0;
                end;
            until SalesShptHeader.NEXT() = 0
        else begin
            //transfers
            TransferShptHdr.SETRANGE("No.", PostedWhseShptLine."Posted Source No.");


            if TransferShptHdr.FINDSET() then
                repeat
                    TmpHeader2.RESET();
                    TmpHeader2.SETRANGE("Transfer-to Code", TransferShptHdr."transfer-to code");
                    TmpHeader2.SETRANGE("Shipment Method Code", TransferShptHdr."Shipment Method Code");
                    TmpHeader2.SETRANGE("Transfer-to Address", TransferShptHdr."transfer-to Address");
                    TmpHeader2.SETRANGE("Transfer-to Address 2", TransferShptHdr."transfer-to Address 2");
                    TmpHeader2.SETRANGE("Transfer-to City", TransferShptHdr."transfer-to City");
                    TmpHeader2.SETRANGE("Transfer-to Post Code", TransferShptHdr."transfer-to Post Code");
                    TmpHeader2.SETRANGE("Transfer-to County", TransferShptHdr."transfer-to County");
                    TmpHeader2.SETRANGE("Trsf.-to Country/Region Code", TransferShptHdr."Trsf.-to Country/Region Code");
                    TmpHeader2.SETRANGE("Shortcut Dimension 1 Code", PostedWhseShptLine."Whse. Shipment No.");
                    TmpHeader2.SetRange("No.", TransferShptHdr."No.");
                    if not TmpHeader2.FINDFIRST() then begin
                        TmpHeader2.RESET();
                        TmpHeader2.INIT();
                        TmpHeader2 := TransferShptHdr;

                        TmpHeader2."Shortcut Dimension 1 Code" := PostedWhseShptLine."Whse. Shipment No.";
                        TmpHeader2."Shortcut Dimension 2 Code" := PostedWhseShptLine."No.";
                        TmpHeader2."Dimension Set ID" := 0;
                        TmpHeader2.INSERT();
                    end else
                        exit;








                    TransfershptLine.RESET();
                    TransfershptLine.SETRANGE("Document No.", TransferShptHdr."No.");

                    TransfershptLine.setfilter("Item Shpt. Entry No.", '<>%1', 0);
                    if TransfershptLine.FINDSET() then
                        repeat
                            //get item ledger entry to have the source line no
                            ItemLedgEntry.get(TransfershptLine."Item Shpt. Entry No.");

                            NextLineNo := TmpHeader2."Dimension Set ID";  //Abuse
                            NoOfPackages := 0;
                            PostedWhseShptLine2.setrange("Posted Source Document", PostedWhseShptLine2."Posted Source Document"::"Posted Transfer Shipment");
                            PostedWhseShptLine2.Setrange("Posted Source No.", TransfershptLine."Document No.");
                            PostedWhseShptLine2.Setrange("Source No.", TransfershptLine."Transfer Order No.");
                            postedwhseshptline2.Setrange("Source Line No.", TransfershptLine."Line No.");



                            If PostedWhseShptLine2.findset() then
                                repeat
                                    RegWhseActLine.setrange("Whse. Document Type", RegWhseActLine."Whse. Document Type"::Shipment);
                                    RegWhseActLine.setrange("Whse. Document NO.", PostedWhseShptLine2."Whse. Shipment No.");
                                    RegWhseActLine.setrange("Whse. Document Line No.", PostedWhseShptLine2."Whse Shipment Line No.");
                                    RegWhseActLine.Setrange("Action Type", RegWhseActLine."Action Type"::Take);
                                    IF RegWhseActLine.FindSet() then
                                        repeat
                                            NoOfPackages := NoOfPackages + RegWhseActLine."No. of Packages";
                                        until RegWhseActLine.Next() = 0;
                                until PostedWhseShptLine2.Next() = 0;
                            //tmpHeader2."Shipping Agent Code" := FORMAT(TotalNoOfPackages);
                            tmpheader2.Modify();
                            TmpLine2.RESET();
                            TmpLine2.SETRANGE("Document No.", TmpHeader."No.");
                            TmpLine2.SETRANGE("transfer Order No.", TransfershptLine."transfer Order No.");
                            TmpLine2.SETRANGE("item No.", TransfershptLine."item No.");
                            TmpLine2.SETRANGE("Variant Code", TransfershptLine."Variant Code");
                            TmpLine2.SETRANGE("Unit of Measure Code", TransfershptLine."Unit of Measure Code");
                            TmpLine2.SETRANGE("Transfer Order No.", TransferShptHdr."No.");
                            if not TmpLine2.FINDFIRST() then begin
                                NextLineNo := NextLineNo + 10000;
                                TmpLine2.RESET();
                                TmpLine2.INIT();
                                TmpLine2.TRANSFERFIELDS(TransfershptLine);
                                TmpLine2."Document No." := TmpHeader2."No.";
                                TmpLine2."Line No." := NextLineNo;
                                tmpline2."Dimension Set ID" := NoOfPackages; //Abuse
                                TmpLine2.INSERT();

                                TmpHeader2."Dimension Set ID" := NextLineNo;
                                TmpHeader2.MODIFY();
                            end;
                        until TransfershptLine.NEXT() = 0;
                until TransferShptHdr.NEXT() = 0;
        end;
        TmpHeader.RESET();
        TmpHeader2.Reset();
    end;

    local procedure FillExtraHeaderfields()
    var
        ShipToAddr: Record "Ship-to Address";
        SellToCust: Record "Customer";
        SellToCont: Record "Contact";
        ShipToPhoneNo: Text;
        ShipToFaxNo: text;
        ShipToEmail: text;
        i: Integer;
    begin
        If ShipToAddr.Get(Header."Sell-to Customer No.", Header."Ship-to Code") THEN begin
            ShipToPhoneNo := ShipToAddr."Phone No.";
            ShipToFaxNo := ShipToAddr."Fax No.";
            ShipToEmail := ShipToAddr."E-Mail";
        end else
            If SellTocont.Get(header."Sell-to Contact No.") and (Header."Sell-to Contact No." <> '') THEN begin
                ShipToPhoneNo := SellToCont."Phone No.";
                ShipToFaxNo := SellToCont."Fax No.";
                ShipToEmail := SellToCont."E-Mail";
            end else
                if SellToCust.Get(header."Sell-to Customer No.") then begin
                    ShipToPhoneNo := SellToCust."Phone No.";
                    ShipToFaxNo := SellToCust."Fax No.";
                    ShipToEmail := SellToCust."E-Mail";
                end;

        i := 35;
        if ShipToPhoneNo <> '' then begin
            STDR_ReportManagement.AddTranslValue(i, HeaderFds[3], 'Phone No.');
            STDR_ReportManagement.AddTxtValue(i + 1, HeaderFds[3], ShipToPhoneNo);
            i := i + 2;
        end;

        if ShipTofaxNo <> '' then begin
            STDR_ReportManagement.AddTranslValue(i, HeaderFds[3], 'Fax No.');
            STDR_ReportManagement.AddTxtValue(i + 1, HeaderFds[3], ShipToFaxNo);
            i := i + 2;
        END;

        if ShipToPhoneNo <> '' then begin
            STDR_ReportManagement.AddTranslValue(i, HeaderFds[3], 'E-Mail');
            STDR_ReportManagement.AddTxtValue(i + 1, HeaderFds[3], ShipToEmail);
        end;
    end;

    local procedure GetQtyPrevTransfer() PrevTransferQty: Decimal
    begin
        exit(0);
    end;

    local procedure AddGrossWeight(ItemNo: Code[20]; Weight: Decimal)
    var
        Item: Record "Item";
    begin
        if STDR_ReportSetup."Show Intrastat in Total Block" = STDR_ReportSetup."Show Intrastat in Total Block"::" " then
            exit;

        IF item.get(ItemNo) then begin
            if item."tariff No." <> '' then begin
                TempIntraGrossBuffer.reset;
                TempIntraGrossBuffer.Setrange("No.", item."Tariff No.");
                If not TempIntraGrossBuffer.FindFirst() then begin
                    TempIntraGrossBuffer.init;
                    TempIntraGrossBuffer."Entry No." := NextIntraGrossBufferEntryNo;
                    TempIntraGrossBuffer."No." := item."Tariff No.";
                    TempIntraGrossBuffer.Quantity := Weight;
                    TempIntraGrossBuffer.Insert();
                    NextIntraGrossBufferEntryNo := NextIntraGrossBufferEntryNo + 1;
                end else begin
                    TempIntraGrossBuffer.Quantity := TempIntraGrossBuffer.Quantity + Weight;
                    TempIntraGrossBuffer.Modify();
                end;
            end;
        end;
    end;
}