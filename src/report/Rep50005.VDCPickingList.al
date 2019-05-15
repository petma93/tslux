report 50005 "VDC Picking List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/VDC Picking List.rdlc';
    Caption = 'VDC Picking List';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(Header; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING (Type, "No.") WHERE (Type = FILTER (Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(DocNo; "No.")
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
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                column(OutputNo; OutputNo)
                {
                }
                dataitem(Line; "Integer")
                {
                    DataItemLinkReference = Header;
                    DataItemTableView = SORTING (Number);
                    column(LineEntryNo; LineEntryNo)
                    {
                    }
                    column(LineFormatTxt; LineFormatTxt)
                    {
                    }
                    column(LineType; LineTypeNo)
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
                        begin
                            STDR_ReportManagement.CollectLineComments(TempDetailBuffer, TmpLine."No.", TmpLine."Line No.");
                            STDR_ReportManagement.CollectItemResourceComments(TempDetailBuffer, TmpLine."No.", TmpLine."Line No.", 2, TmpLine."Item No.");
                            SETRANGE(Number, 1, TempDetailBuffer.COUNT());
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TmpLine.FINDSET()
                        else
                            TmpLine.NEXT();

                        // reset detail buffer line
                        CLEAR(TempDetailBuffer);
                        TempDetailBuffer.DELETEALL();

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
                    begin
                        SETRANGE(Number, 1, TmpLine.COUNT());
                        LineEntryNo := 0;
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

                    //determine document name and add copy text if number is bigger then one
                    DocName := STDR_ReportManagement.GetDocName(Number);
                    STDR_ReportManagement.AddTxtValue(1, HeaderFds[4], DocName);
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
                // setup report management codeunit with current record values
                STDR_ReportManagement.SetCurrentRec("Language Code", '', WORKDATE(), '', Header);

                // Set the options set by user on the requestpage
                STDR_ReportManagement.SetReportOptionItemTracking(ShowItemTracking);
                STDR_ReportManagement.SetReportOptionSumUpLines(SumUpLines);
                STDR_ReportManagement.SetReportOptionBreakBulk(BreakbulkFilter);

                // get report setup record
                STDR_ReportManagement.GetReportSetup(STDR_ReportSetup);

                // set CurrReport.Language
                CurrReport.LANGUAGE := STDR_ReportManagement.GetLanguageID();

                // fill buffer with all lines to print. If no lines exists also skip header
                if not FillWhseActLineBuffer(TmpLine, Header) then
                    CurrReport.SKIP();

                // fill header fields
                FillHeaderFds();
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
                    field(NoOfExtraCopies; NoOfExtraCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Extra Copies';
                    }
                    field(ShowItemTracking; ShowItemTracking)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Show Serial/Lot Number';
                        OptionCaption = 'Default,Yes,No';
                    }
                    field(Breakbulk; BreakbulkFilter)
                    {
                        ApplicationArea = Advanced, Suite;
                        Caption = 'Set Breakbulk Filter';
                        OptionCaption = 'Default,Yes,No';
                        Visible = BreakbulkFilterVisible;
                    }
                    field(SumUpLines; SumUpLines)
                    {
                        ApplicationArea = Advanced, Suite;
                        Caption = 'Sum up Lines';
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
        STDR_ReportManagement.InitReportReqPageBreakBulk(BreakbulkFilter, BreakbulkFilterVisible, FromInventory);
    end;

    trigger OnPreReport()
    begin
        // setup report management codeunit with preview
        STDR_ReportManagement.SetPreview(CurrReport.PREVIEW());
    end;

    var
        TempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary;
        TmpLine: Record "Warehouse Activity Line" temporary;
        STDR_ReportSetup: Record "STDR_Report Setup";
        STDR_ReportManagement: Codeunit "STDR_Report Management";
        STDR_CommonFunctions: Codeunit "STDR_Common Functions";
        ShowItemTracking: Option Default,Yes,No;
        SumUpLines: Option Default,Yes,No;
        BreakbulkFilter: Option Default,Yes,No;
        [InDataSet]
        BreakbulkFilterVisible: Boolean;
        FromInventory: Boolean;
        DocName: Text;
        HeaderFds: array[5] of Text;
        FontFamily: Text;
        LineFormatTxt: Text;
        NoOfExtraCopies: Integer;
        OutputNo: Integer;
        LineEntryNo: Integer;
        LineIndent: Integer;
        LineBold: Boolean;
        LineTxt: array[20] of Text;
        DetLineTxt: array[20] of Text;
        ItemTrackingType: Option "None",Lot,SN,Both;
        "Language Code": Code[20];
        LineTypeNo: Integer;
        DetLineTypeNo: Integer;
        FontArray: array[8] of Text;

    procedure SetInventory(NewValue: Boolean)
    begin
        FromInventory := NewValue;
    end;

    procedure FillWhseActLineBuffer(var TmpLineBuffer2: Record "Warehouse Activity Line" temporary; Header2: Record "Warehouse Activity Header") LinesExist: Boolean
    var
        WhseActLine: Record "Warehouse Activity Line";
        SerialNoExists: Boolean;
        LotNoExists: Boolean;
    begin
        with WhseActLine do begin
            TmpLineBuffer2.RESET();
            TmpLineBuffer2.DELETEALL();
            SETCURRENTKEY("Activity Type", "No.", "Sorting Sequence No.");
            SETRANGE("Activity Type", Header.Type);
            SETRANGE("No.", Header."No.");
            SetRange("Action Type", "Action Type"::Take);
            if STDR_ReportSetup."Set Breakbulk Filter" then
                SETRANGE("Original Breakbulk", false);
            if FINDSET() then
                repeat
                    if STDR_ReportSetup."Sum up Lines" then begin
                        TmpLineBuffer2.SETCURRENTKEY("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                        TmpLineBuffer2.SETRANGE("Activity Type", "Activity Type");
                        TmpLineBuffer2.SETRANGE("No.", "No.");
                        TmpLineBuffer2.SETRANGE("Action Type", "Action Type");
                        TmpLineBuffer2.SETRANGE("Zone Code", "Zone Code");
                        TmpLineBuffer2.SETRANGE("Bin Code", "Bin Code");
                        TmpLineBuffer2.SETRANGE("Item No.", "Item No.");
                        TmpLineBuffer2.SETRANGE("Variant Code", "Variant Code");
                        TmpLineBuffer2.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
                        TmpLineBuffer2.SETRANGE("Due Date", "Due Date");
                        TmpLineBuffer2.SETRANGE("Lot No.", "Lot No.");
                        TmpLineBuffer2.SETRANGE("Serial No.", "Serial No.");
                        if Header."Sorting Method" = Header."Sorting Method"::"Ship-To" then begin
                            TmpLineBuffer2.SETRANGE("Destination Type", "Destination Type");
                            TmpLineBuffer2.SETRANGE("Destination No.", "Destination No.");
                        end;
                        if TmpLineBuffer2.FINDFIRST() then begin
                            TmpLineBuffer2.Quantity += Quantity;
                            TmpLineBuffer2."Qty. (Base)" += "Qty. (Base)";
                            TmpLineBuffer2."Qty. Outstanding" += "Qty. Outstanding";
                            TmpLineBuffer2."Qty. Outstanding (Base)" += "Qty. Outstanding (Base)";
                            TmpLineBuffer2."Qty. to Handle" += "Qty. to Handle";
                            TmpLineBuffer2."Qty. to Handle (Base)" += "Qty. to Handle (Base)";
                            TmpLineBuffer2."Qty. Handled" += "Qty. Handled";
                            TmpLineBuffer2."Qty. Handled (Base)" += "Qty. Handled (Base)";
                            TmpLineBuffer2."Source No." := '';
                            if Header."Sorting Method" <> Header."Sorting Method"::"Ship-To" then begin
                                TmpLineBuffer2."Destination Type" := TmpLineBuffer2."Destination Type"::" ";
                                TmpLineBuffer2."Destination No." := '';
                            end;
                            TmpLineBuffer2.MODIFY();
                        end else begin
                            TmpLineBuffer2 := WhseActLine;
                            TmpLineBuffer2.INSERT();
                        end;
                    end else begin
                        TmpLineBuffer2 := WhseActLine;
                        TmpLineBuffer2.INSERT();
                    end;
                    SerialNoExists := SerialNoExists or (TmpLineBuffer2."Serial No." <> '');
                    LotNoExists := LotNoExists or (TmpLineBuffer2."Lot No." <> '');
                until NEXT() = 0;

            if (not LotNoExists) and (not SerialNoExists) then
                ItemTrackingType := ItemTrackingType::None;
            if (LotNoExists) and (not SerialNoExists) then
                ItemTrackingType := ItemTrackingType::Lot;
            if (not LotNoExists) and (SerialNoExists) then
                ItemTrackingType := ItemTrackingType::SN;
            if (LotNoExists) and (SerialNoExists) then
                ItemTrackingType := ItemTrackingType::Both;

            TmpLineBuffer2.RESET();
            exit(not TmpLineBuffer2.ISEMPTY());
        end; /*with do*/

    end;

    procedure ExamplAddDetailLines(var TheTempDetailBuffer: Record "STDR_Report Detail Line Buffer" temporary)
    var
        SpecialEquip: Record "Special Equipment";
    begin
        if (TmpLine."Special Equipment Code" = '') or
           (not SpecialEquip.GET(TmpLine."Special Equipment Code"))
        then
            exit;

        STDR_ReportManagement.DetailLineAdd(TheTempDetailBuffer, TmpLine."No.", TmpLine."Line No.");
        TheTempDetailBuffer."Detail Line Type" := TheTempDetailBuffer."Detail Line Type"::Comment;
        TheTempDetailBuffer.Description := copystr(STDR_ReportManagement.GetLineDesc(1, SpecialEquip.Description, ''), 1, MaxStrLen(TheTempDetailBuffer.Description));
        TheTempDetailBuffer.INSERT();
    end;

    procedure FillHeaderFds()
    var
        CompanyInfo: Record "STDR_Report Setup";
        LeftAddr: array[8] of Text[80];
        RightAddr: array[8] of Text[80];
        ExtraAddr: array[8] of Text[80];
        CompanyAddr: array[8] of Text[80];
        OurVatNoOrEnterpriseNoCap: Text;
        OurVatNoOrEnterpriseNo: Text;
        i: Integer;
        t: array[10] of Text;
    begin
        with Header do begin
            //sometime the companyinfo is overrulled by the responsibilycenter or report setup code.
            //So we use the report_setup var. The report_mgt codeunit has filled/copied this var with the correct values
            CompanyInfo := STDR_ReportSetup;
            STDR_ReportManagement.FormatAddresses(LeftAddr, RightAddr, ExtraAddr, CompanyAddr);
            STDR_ReportManagement.GetOurVatNoOrEnterpriseNo(CompanyInfo, OurVatNoOrEnterpriseNoCap, OurVatNoOrEnterpriseNo);

            //Set per document:fontfamily, fontname, fontsize
            FontFamily := STDR_ReportManagement.GetFontFamily();
            STDR_ReportManagement.GetFontArray(FontArray);

            // 1= Customer Address and ship-to address
            CLEAR(HeaderFds);

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


            // 3= document
            STDR_ReportManagement.AddTranslValue(1, HeaderFds[3], 'No.');
            STDR_ReportManagement.AddTxtValue(2, HeaderFds[3], "No.");
            STDR_ReportManagement.AddTranslValue(3, HeaderFds[3], 'Filter');
            STDR_ReportManagement.AddTxtValue(4, HeaderFds[3], Header.GETFILTERS());

            if "Assigned User ID" <> '' then begin
                STDR_ReportManagement.AddTranslValue(5, HeaderFds[3], 'Assigned User ID');
                STDR_ReportManagement.AddTxtValue(6, HeaderFds[3], STDR_CommonFunctions.UserIDToFullname("Assigned User ID"));
                STDR_ReportManagement.AddTxtValue(6, HeaderFds[3], "Assigned User ID");
            end;
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
            STDR_ReportManagement.AddTxtValue(10, HeaderFds[4], COMPANYNAME());
            STDR_ReportManagement.AddTxtValue(11, HeaderFds[4], STDR_CommonFunctions.UserIDToFullname(COPYSTR(USERID(), 1, 250)));
            STDR_ReportManagement.AddTxtValue(11, HeaderFds[4], USERID());
            STDR_ReportManagement.AddTxtValue(12, HeaderFds[4], FORMAT(CURRENTDATETIME(), 0, 0));
            //Combine header Text with Customer or Vendor Comment text
            t[1] := STDR_ReportManagement.GetExtTxtAsLongStringForCurrentReport(1);
            t[2] := STDR_ReportManagement.GetCommAsLongStringForCurrentReport();
            t[3] := STDR_CommonFunctions.Add2TextsToText(t[1], t[2], '%1', 0);
            if t[3] <> '' then
                t[3] += '%1';
            STDR_ReportManagement.AddTxtValue(13, HeaderFds[4], t[3]);
            CLEAR(t);

            // 5= Line Header Fields
            STDR_ReportManagement.AddTranslValue(1, HeaderFds[5], 'Item No.');
            STDR_ReportManagement.AddTranslValue(2, HeaderFds[5], 'Description');
            STDR_ReportManagement.AddTranslValue(3, HeaderFds[5], 'Source No.');
            if Header.Type in [Header.Type::"Put-away", Header.Type::Pick, Header.Type::Movement] then
                STDR_ReportManagement.AddTranslValue(4, HeaderFds[5], 'Action Type');
            case STDR_ReportSetup."Show Bin Code" of
                STDR_ReportSetup."Show Bin Code"::"Shelf No.":
                    STDR_ReportManagement.AddTranslValue(5, HeaderFds[5], 'Shelf No.');
                STDR_ReportSetup."Show Bin Code"::"Bin Code":
                    STDR_ReportManagement.AddTranslValue(5, HeaderFds[5], 'Bin Code');
            end; /*case*/
            case ItemTrackingType of
                ItemTrackingType::None:
                    STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], '');
                ItemTrackingType::Lot:
                    STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], 'Lot No.');
                ItemTrackingType::SN:
                    STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], 'Serial No.');
                ItemTrackingType::Both:
                    begin
                        STDR_ReportManagement.AddTranslValue(6, HeaderFds[5], 'Lot No.');
                        STDR_ReportManagement.AddTranslValue(7, HeaderFds[5], 'Serial No.');
                    end;
            end; /*case*/
            STDR_ReportManagement.AddTranslValue(8, HeaderFds[5], 'Quantity');
            STDR_ReportManagement.AddTranslValue(9, HeaderFds[5], 'Unit of Measure');
            STDR_ReportManagement.AddTranslValue(10, HeaderFds[5], 'Quantity Handled');
        end; /*with do*/

        GetExtraHeaderInformation();

        STDR_ReportManagement.OnAfterFillHeaderFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, FontArray, HeaderFds);

    end;

    procedure FillLineFds()
    var
        CrossDockMark: Text;
    begin
        with TmpLine do begin
            LineEntryNo += 1;
            LineTypeNo := "Action Type";
            LineFormatTxt := STDR_ReportManagement.GetLineFormat(LineBold, LineIndent);
            CLEAR(LineTxt);
            LineTxt[1] := STDR_ReportManagement.GetLineNo2(LineIndent, "Item No.", "Variant Code", '', '', '', "Location Code");
            LineTxt[2] := STDR_ReportManagement.GetLineDesc(LineIndent, Description, "Description 2");
            LineTxt[3] := "Source No.";
            CrossDockMark := STDR_ReportManagement.SetCrossDockMark(TmpLine."Cross-Dock Information");
            if Header.Type in [Header.Type::"Put-away", Header.Type::Pick, Header.Type::Movement] then
                LineTxt[4] := FORMAT("Action Type");
            case STDR_ReportSetup."Show Bin Code" of
                STDR_ReportSetup."Show Bin Code"::"Shelf No.":
                    LineTxt[5] := "Shelf No.";
                STDR_ReportSetup."Show Bin Code"::"Bin Code":
                    LineTxt[5] := "Bin Code";
            end; /*case*/
            case ItemTrackingType of
                ItemTrackingType::Lot:
                    LineTxt[7] := "Lot No.";
                ItemTrackingType::SN:
                    LineTxt[7] := "Serial No.";
                ItemTrackingType::Both:
                    begin
                        LineTxt[6] := "Lot No.";
                        LineTxt[7] := "Serial No.";
                    end;
            end; /*case*/
            LineTxt[8] := STDR_ReportManagement.FormatQuantityDecimal(Quantity);
            LineTxt[9] := STDR_ReportManagement.GetUOMText("Unit of Measure Code");
            LineTxt[10] := '';
        end; /*with do*/
        STDR_ReportManagement.OnAfterFillLineFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, HeaderFds, Line, LineEntryNo, LineTypeNo, LineTxt, LineFormatTxt);

    end;

    procedure FillDetailLineFds()
    var
        CrossDockMark: Text;
    begin
        with TempDetailBuffer do begin
            DetLineTypeNo := Type;
            CLEAR(DetLineTxt);
            DetLineTxt[1] := STDR_ReportManagement.GetLineNo2(LineIndent, "No.", "Variant Code", "Cross-Reference No.", "Vendor Item No.", "Vendor No.", "Location Code");
            DetLineTxt[2] := STDR_ReportManagement.GetDescFromTempDetailBuffer(TempDetailBuffer, LineIndent);
            DetLineTxt[3] := "Source No.";
            CrossDockMark := STDR_ReportManagement.SetCrossDockMark(TmpLine."Cross-Dock Information");
            if Header.Type in [Header.Type::"Put-away", Header.Type::Pick, Header.Type::Movement] then
                DetLineTxt[4] := FORMAT("Action Type");
            DetLineTxt[5] := "Bin Code";
            case ItemTrackingType of
                ItemTrackingType::Lot:
                    DetLineTxt[7] := "Lot No.";
                ItemTrackingType::SN:
                    DetLineTxt[7] := "Serial No.";
                ItemTrackingType::Both:
                    begin
                        DetLineTxt[6] := "Lot No.";
                        DetLineTxt[7] := "Serial No.";
                    end;
            end; /*case*/
            DetLineTxt[8] := STDR_ReportManagement.FormatQuantityDecimal(Quantity);
            DetLineTxt[9] := STDR_ReportManagement.GetUOMText("Unit of Measure Code");
            DetLineTxt[10] := '';
        end; /*with do*/
        STDR_ReportManagement.OnAfterFillDetailLineFds(STDR_ReportSetup, STDR_ReportManagement.GetLanguageCode(), STDR_ReportManagement.GetReportNo(), Header, HeaderFds, Line, LineEntryNo, LineTypeNo, LineTxt, LineFormatTxt, TempDetailBuffer, DetLineTypeNo, DetLineTxt);

    end;

    local procedure GetExtraHeaderInformation()
    var
        SalesHeader: Record "Sales Header";
        WhseActLine: Record "Warehouse Activity Line";
        ShippingAgent: Record "Shipping Agent";
    begin
        WhseActLine.SetRange("Activity Type", Header.Type);
        WhseActLine.SetRange("No.", header."No.");
        WhseActLine.SetRange("Source Type", Database::"Sales Line");
        If WhseActLine.FindFirst() then begin
            STDR_ReportManagement.AddTranslValue(9, HeaderFds[3], 'Whse. - Shipment');
            STDR_ReportManagement.AddTxtValue(10, HeaderFds[3], WhseActLine."Whse. Document No.");

            if SalesHeader.Get(WhseActLine."Source Subtype", WhseActLine."Source No.") then
                IF SalesHeader."Shipping Agent Code" <> '' THEN begin
                    STDR_ReportManagement.AddTranslValue(11, HeaderFds[3], 'Shipping Agent');
                    If not ShippingAgent.get(SalesHeader."Shipping Agent Code") then
                        Clear(ShippingAgent);
                    If ShippingAgent.Name <> '' then
                        STDR_ReportManagement.AddTxtValue(12, HeaderFds[3], ShippingAgent.Name)
                    else
                        STDR_ReportManagement.AddTxtValue(12, HeaderFds[3], SalesHeader."Shipping Agent Code");
                end;
        end;

        STDR_ReportManagement.AddTranslValue(10, HeaderFds[5], 'No. of Packages');
    end;
}

