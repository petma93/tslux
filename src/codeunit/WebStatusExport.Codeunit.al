codeunit 50000 "Web Status Export"
{
    TableNo = "NVT EDI Import/Export Code";

    trigger OnRun()
    var
        Status: Record "NVT Status";
        WinDia: Dialog;
        ref: text;
        FileName: Text;
        PathName: text;
        ComTools: Codeunit "NVT EDI Communication Tools";


    begin
        IF GUIALLOWED THEN
            IF NOT CONFIRM('Export Status uitvoeren? ', FALSE) THEN
                ERROR('');



        IF GUIALLOWED THEN
            WinDia.OPEN('Export Status');
        //IF COPYSTR("Path New Files", strlen("Path New Files") - 1) <> '\' then
        //   PathName := GetNewRelFilePath() + '\'
        //else
        PathName := GetNewRelFilePath;

        Status.RESET;
        Status.SETRANGE(Type, Status.Type::Operational);
        Status.SETRANGE("ExportWeb", TRUE);
        IF Status.FINDFIRST THEN BEGIN
            REPEAT
                ref := 'tracktrace_' + Status.Code + '_';
                filename := ComTools.GetNewFilename(1, Code, '', ref, '');
                //filename := ComTools.GetFileName(filename, "Path New Files");
                IF Status.Code = '10' THEN BEGIN

                    CreateXmlDoc(Status.Code, PathName, filename);
                    ref := 'tracktraceDet_' + Status.Code;
                    filename := ComTools.GetNewFilename(1, Code, '', ref, '');
                    //filename := ComTools.GetFileName(filename, "Path New Files");

                    CreateXmlDocDetail(Status.Code, format(Status."Code Web"), status."Description Web", pathname, FileName);
                END ELSE
                    CreateXmlDocDetail(Status.Code, format(Status."Code Web"), status."Description Web", PathName, FileName);

            UNTIL Status.NEXT = 0;
        END;






        IF GUIALLOWED THEN
            WinDia.CLOSE;


    end;

    PROCEDURE CreateXmlDoc(pStatus: Code[10]; PathName: text; clientFileName: text);
    VAR
        StatusLog: Record "NVT Status Log";
        StatusLog2: Record "NVT Status Log";
        Shp: Record "NVT Shipment";
        St: Record "NVT Status Log";
        ShipGoods: Record "NVT Shipment Goods";
        Unit: Record "Unit of Measure";
        TransportAddress: Record "NVT Transportaddress";
        CalenderMgmt: Codeunit "Calendar Management";
        XmlMgt: Codeunit "XML DOM Management";
        xmlcreated: Boolean;
        dummydate: Date;
        Collection: Boolean;
        FileMgt: Codeunit "File Management";


        XMLDoc: XmlDocument;
        RootNode: XmlElement;
        RecordsEl: XmlElement;
        RecordEl: XmlElement;
        ShipEl: XmlElement;


        NamespaceMgt: XmlNamespaceManager;
        xmlDecl: XmlDeclaration;
        Namespace: Text;
        pal: decimal;
        col: decimal;
        PlanDate: Date;
        instr: InStream;
        outstr: OutStream;
        TempBlob: Record TempBlob;
        OutputFile: File;
        FileName: text;

    begin
        Filename := PathName + clientFileName;
        StatusLog.RESET;
        StatusLog.SETCURRENTKEY("Status type");
        StatusLog.SETRANGE("Status type", StatusLog."Status type"::Operational);
        StatusLog.SETRANGE("Code status", pStatus);
        StatusLog.SETRANGE(Exp2Web, FALSE);
        StatusLog.SETFILTER("Date status", '%1..', CALCDATE('-1M', TODAY));
        IF StatusLog.FINDFIRST THEN BEGIN
            REPEAT
                IF Shp.GET(StatusLog."Shipment No.") THEN BEGIN
                    IF Shp."Unload Address Code" <> '' THEN BEGIN

                        IF NOT xmlcreated THEN BEGIN
                            XMLDoc := XmlDocument.Create();
                            Namespace := 'http://www.w3.org/2001/XMLSchema-instance';
                            xmlDecl := xmlDeclaration.Create('1.0', 'UTF-8', 'no');
                            xmlDoc.SetDeclaration(xmlDecl);


                            RecordsEl := XmlElement.Create('Records');
                            xmlcreated := TRUE;
                        END;

                        pal := 0;
                        col := 0;

                        ShipGoods.RESET;
                        ShipGoods.SETRANGE("Shipment No.", Shp."Shipment No.");
                        IF ShipGoods.FINDFIRST THEN BEGIN
                            REPEAT
                                IF Unit.GET(ShipGoods."Unit of measure") THEN BEGIN
                                    IF Unit."NVT Plan Unit" = Unit."NVT Plan Unit"::Pallet THEN
                                        pal += ShipGoods.Quantity
                                    ELSE
                                        col += ShipGoods.Quantity;
                                END;
                            UNTIL ShipGoods.NEXT = 0;
                        END;

                        //Indien het losadres = transportadres van klant => afhaling
                        //=========================================
                        Collection := FALSE;

                        TransportAddress.RESET;
                        Transportaddress.SETCURRENTKEY("Customer No.");
                        Transportaddress.SETRANGE("Customer No.", Shp."Code customer");
                        IF Transportaddress.FINDFIRST THEN
                            IF Transportaddress."Address code" = Shp."Unload Address Code" THEN
                                Collection := TRUE;




                        Shp.CALCFIELDS(Weight, Volume, LL);
                        RecordEl := XmlElement.Create('Record');
                        ShipEl := xmlElement.Create('Z');
                        ShipEl.Add(xmlText.Create('1'));
                        RecordEl.Add(ShipEl);

                        ShipEl := xmlElement.Create('Zid');
                        ShipEl.Add(xmlText.Create(FORMAT(Shp."Shipment No.")));
                        RecordEl.Add(ShipEl);

                        ShipEl := xmlElement.Create('Zklantnummer');
                        ShipEl.Add(xmlText.Create(Shp."Code customer"));
                        RecordEl.Add(ShipEl);

                        ShipEl := xmlElement.Create('Zreferentie');
                        ShipEl.Add(xmlText.Create(Shp."File No."));
                        RecordEl.Add(ShipEl);

                        ShipEl := xmlElement.Create('Zvrachtbriefnr');
                        ShipEl.Add(xmlText.Create(COPYSTR(Shp."File reference", 1, 25)));
                        RecordEl.Add(ShipEl);

                        ShipEl := xmlElement.Create('Zorderdatum');
                        ShipEl.Add(xmlText.Create(FORMAT(Shp."File date", 0, '<day,2>-<month,2>-<year,2>')));
                        RecordEl.Add(ShipEl);

                        PlanDate := Shp."Loading date";
                        IF PlanDate <> 0D THEN BEGIN
                            REPEAT
                                // Substract one (working) day from loading date to calculate plan date. Keep substracting to skip weekends.
                                PlanDate := CalcDate('<-1D>', PlanDate);
                            UNTIL DATE2DWY(PlanDate, 1) < 6;
                        END
                        ELSE
                            PlanDate := Shp."File date";

                        ShipEl := xmlElement.Create('Zplandatum');
                        ShipEl.Add(xmlText.Create(FORMAT(PlanDate, 0, '<day,2>-<month,2>-<year,2>')));
                        RecordEl.Add(ShipEl);


                        IF Collection THEN BEGIN
                            ShipEl := xmlElement.Create('Za_naam');
                            ShipEl.Add(xmlText.Create(Shp."Load address Name"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_adres');
                            ShipEl.Add(xmlText.Create(Shp."Load address adress"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_postcode');
                            ShipEl.Add(xmlText.Create(Shp."Load address Post Code"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_plaats');
                            ShipEl.Add(xmlText.Create(Shp."Load address city"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_land');
                            ShipEl.Add(xmlText.Create(Shp."Load address Country"));
                            RecordEl.Add(ShipEl);

                        END ELSE BEGIN
                            ShipEl := xmlElement.Create('Za_naam');
                            ShipEl.Add(xmlText.Create(Shp."UnLoad address Name"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_adres');
                            ShipEl.Add(xmlText.Create(Shp."UnLoad address address"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_postcode');
                            ShipEl.Add(xmlText.Create(Shp."UnLoad address Post Code"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_plaats');
                            ShipEl.Add(xmlText.Create(Shp."UnLoad address city"));
                            RecordEl.Add(ShipEl);
                            ShipEl := xmlElement.Create('Za_land');
                            ShipEl.Add(xmlText.Create(Shp."UnLoad address Country"));
                            RecordEl.Add(ShipEl);


                        END;

                        ShipEl := xmlElement.Create('Zaantalcolli');
                        ShipEl.Add(xmlText.Create(FORMAT(col)));
                        RecordEl.Add(ShipEl);
                        ShipEl := xmlElement.Create('Zgewicht');
                        ShipEl.Add(xmlText.Create(FORMAT(Shp.Weight)));
                        RecordEl.Add(ShipEl);
                        ShipEl := xmlElement.Create('Zlaadmeter');
                        ShipEl.Add(xmlText.Create(FORMAT(Shp.LL)));
                        RecordEl.Add(ShipEl);
                        ShipEl := xmlElement.Create('Zvolume');
                        ShipEl.Add(xmlText.Create(FORMAT(Shp.Volume)));
                        RecordEl.Add(ShipEl);
                        ShipEl := xmlElement.Create('Zpallets');
                        ShipEl.Add(xmlText.Create(FORMAT(pal)));
                        RecordEl.Add(ShipEl);

                        IF Collection THEN begin
                            ShipEl := xmlElement.Create('Ztype');
                            ShipEl.Add(xmlText.Create('1'));
                            RecordEl.Add(ShipEl);
                        end ELSE begin
                            ShipEl := xmlElement.Create('Ztype');
                            ShipEl.Add(xmlText.Create('0'));
                            RecordEl.Add(ShipEl);
                        end;
                        ShipEl := xmlElement.Create('Zzndtype');
                        ShipEl.Add(xmlText.Create('1'));
                        RecordEl.Add(ShipEl);

                        RecordsEl.Add(RecordEl);
                    END;
                END;





            UNTIL StatusLog.NEXT = 0;
        END;


        IF xmlcreated THEN begin
            XMLDoc.add(RecordsEl);
            Clear(OutputFile);
            OutputFile.TextMode(true);
            OutputFile.WriteMode(true);
            OutputFile.Create(FileName);

            OutputFile.CreateOutStream(OutStr);
            //TempBlob.Blob.CreateOutStream(outStr, TextEncoding::UTF8);
            xmlDoc.WriteTo(outStr);
            OutputFile.Close
            //TempBlob.Blob.CreateInStream(inStr, TextEncoding::UTF8);

            //File.DownloadFromStream(inStr, '', PathName, '', clientfileName);

        end;

    end;

    PROCEDURE CreateXmlDocDetail(Status: Code[10]; woeiCode: text; woeiDesc: text; pathname: text; ClientFileName: Text);
    VAR
        StatusLog: Record "NVT Status Log";
        StatusLog2: Record "NVT Status Log";
        Shp: Record "NVT Shipment";
        St: Record "NVT Status Log";
        ShipGoods: Record "NVT Shipment Goods";
        Unit: Record "Unit of Measure";
        RouteDet: Record "NVT Route Detail";
        Route: Record "NVT Route";
        TransportAddress: Record "NVT Transportaddress";
        CalenderMgmt: Codeunit "Calendar Management";
        XmlMgt: Codeunit "XML DOM Management";
        xmlcreated: Boolean;
        dummydate: Date;
        Collection: Boolean;


        XMLDoc: XmlDocument;
        RootNode: XmlElement;
        RecordsEl: XmlElement;
        RecordEl: XmlElement;
        ShipEl: XmlElement;


        NamespaceMgt: XmlNamespaceManager;
        xmlDecl: XmlDeclaration;
        Namespace: Text;
        pal: Integer;
        col: Integer;
        PlanDate: Date;
        instr: InStream;
        outstr: OutStream;
        TempBlob: Record TempBlob;
        OutputFile: File;
        Filename: text;



    BEGIN
        xmlcreated := FALSE;
        Filename := PathName + clientFileName;
        StatusLog.RESET;
        StatusLog.SETCURRENTKEY("Status type");
        StatusLog.SETRANGE("Status type", StatusLog."Status type"::Operational);
        StatusLog.SETRANGE("Code status", Status);
        StatusLog.SETRANGE(Exp2Web, FALSE);
        StatusLog.SETFILTER("Date status", '%1..', CALCDATE('-1M', TODAY));
        IF StatusLog.FINDFIRST THEN BEGIN
            REPEAT
                IF Shp.GET(StatusLog."Shipment No.") THEN BEGIN

                    IF NOT xmlcreated THEN BEGIN
                        XMLDoc := XmlDocument.Create();
                        Namespace := 'http://www.w3.org/2001/XMLSchema-instance';
                        xmlDecl := xmlDeclaration.Create('1.0', 'UTF-8', 'no');
                        xmlDoc.SetDeclaration(xmlDecl);


                        RecordsEl := XmlElement.Create('Records');
                        xmlcreated := TRUE;
                    END;

                    RecordEl := XmlElement.Create('Record');
                    ShipEl := xmlElement.Create('Z');
                    ShipEl.Add(xmlText.Create('2'));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('SZid');
                    ShipEl.Add(xmlText.Create(FORMAT(Shp."Shipment No.")));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('SZklantnummer');
                    ShipEl.Add(xmlText.Create(Shp."Code customer"));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('SZreferentie');
                    ShipEl.Add(xmlText.Create(Shp."File No."));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('SZvrachtbriefnr');
                    ShipEl.Add(xmlText.Create(COPYSTR(Shp."File reference", 1, 25)));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('Sdatumtijd');
                    ShipEl.Add(xmlText.Create(GetCorrectDateFormat(StatusLog."Date status") +
                                         'T' + GetCorrectTimeFormat(StatusLog."Time status")));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('Sstid');
                    ShipEl.Add(xmlText.Create(woeiCode));
                    RecordEl.Add(ShipEl);

                    ShipEl := xmlElement.Create('Sstatus');
                    ShipEl.Add(xmlText.Create(woeiDesc));
                    RecordEl.Add(ShipEl);

                    IF (woeiCode = '1') THEN BEGIN
                        RouteDet.RESET;
                        RouteDet.SETCURRENTKEY("Shipment No.");
                        RouteDet.SETRANGE("Shipment No.", Shp."Shipment No.");
                        IF RouteDet.FINDLAST THEN BEGIN
                            RouteDet.CALCFIELDS("Starting Date");
                            ShipEl := xmlElement.Create('Seta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Srta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sdatum');
                            ShipEl.Add(xmlText.Create(FORMAT(RouteDet."Starting Date", 0, '<day,2>-<month,2>-<year,2>')));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Stijd');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Snaam');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sritnummer');
                            ShipEl.Add(xmlText.Create(RouteDet."Trip No."));
                            RecordEl.Add(ShipEl);


                        END ELSE BEGIN
                            ShipEl := xmlElement.Create('Seta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Srta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sdatum');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Stijd');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Snaam');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sritnummer');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);
                        END;
                    END ELSE BEGIN
                        IF woeiCode = '6' THEN BEGIN
                            RouteDet.RESET;
                            RouteDet.SETCURRENTKEY("Shipment No.");
                            RouteDet.SETRANGE("Shipment No.", Shp."Shipment No.");
                            IF RouteDet.FINDLAST THEN BEGIN
                                Route.GET(RouteDet."Trip No.", RouteDet."Partial trip Line No.", RouteDet."Route Line No.");
                                ShipEl := xmlElement.Create('Seta');
                                ShipEl.Add(xmlText.Create(GetCorrectTimeFormat(Route."Arrival Time")));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Srta');
                                ShipEl.Add(xmlText.Create(GetCorrectTimeFormat(Route."Arrival Time")));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Sdatum');
                                ShipEl.Add(xmlText.Create(GetCorrectDateFormat(Route."Arrival Date")));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Stijd');
                                ShipEl.Add(xmlText.Create(GetCorrectTimeFormat(Route."Arrival Time")));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Snaam');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Sritnummer');
                                ShipEl.Add(xmlText.Create(RouteDet."Trip No."));
                                RecordEl.Add(ShipEl);


                            END ELSE BEGIN
                                ShipEl := xmlElement.Create('Seta');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Srta');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Sdatum');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Stijd');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Snaam');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);

                                ShipEl := xmlElement.Create('Sritnummer');
                                ShipEl.Add(xmlText.Create(''));
                                RecordEl.Add(ShipEl);
                            END;
                        END ELSE BEGIN
                            ShipEl := xmlElement.Create('Seta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Srta');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sdatum');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Stijd');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Snaam');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);

                            ShipEl := xmlElement.Create('Sritnummer');
                            ShipEl.Add(xmlText.Create(''));
                            RecordEl.Add(ShipEl);
                        END;
                    END;

                    ShipEl := xmlElement.Create('Sbehandelaar');
                    ShipEl.Add(xmlText.Create(StatusLog.User));
                    RecordEl.Add(ShipEl);


                    IF (woeiCode = '3') OR (woeiCode = '4') THEN begin

                        ShipEl := xmlElement.Create('Sreden');
                        ShipEl.Add(xmlText.Create(StatusLog."Text problem"));
                        RecordEl.Add(ShipEl);

                    end else begin
                        ShipEl := xmlElement.Create('Sreden');
                        ShipEl.Add(xmlText.Create(''));
                        RecordEl.Add(ShipEl);
                    end;



                    RecordsEl.Add(RecordEl);
                END;




                IF StatusLog2.GET(StatusLog."Log No.") THEN BEGIN
                    StatusLog2.Exp2Web := TRUE;
                    StatusLog2."Exp2Web datetime" := CURRENTDATETIME;
                    StatusLog2.MODIFY;
                    COMMIT;
                END;


            UNTIL StatusLog.NEXT = 0;
        END;


        IF xmlcreated THEN begin

            XMLDoc.add(RecordsEl);
            OutputFile.TextMode(true);
            OutputFile.WriteMode(true);
            OutputFile.Create(FileName);

            OutputFile.CreateOutStream(OutStr);
            //TempBlob.Blob.CreateOutStream(outStr, TextEncoding::UTF8);
            xmlDoc.WriteTo(outStr);

            OutputFile.Close;
            //TempBlob.Blob.CreateInStream(inStr, TextEncoding::UTF8);

            //File.DownloadFromStream(inStr, '', PathName, '', clientfileName);


        end;

    end;







    PROCEDURE GetCorrectDateFormat(pDate: Date): Text[10];
    BEGIN
        EXIT(FORMAT(pDate, 0, '<Year,2>-<Month,2><Filler Character,0>-<Day,2><Filler Character,0>'));
    END;

    PROCEDURE GetCorrectTimeFormat(pTime: Time): Text[10];
    BEGIN
        EXIT(FORMAT(pTime, 0, '<Hours24,2><Filler Character,0>:<Minutes,2><Filler Character,0>:<Second,2><Filler Character,0>'));
    END;

    PROCEDURE FormatDecimal(pDecimal: Decimal; pDec: Integer) DecimalText: Text[30];
    VAR
        Precision: Decimal;
        Pos: Integer;
        Counter: Integer;
        WholeNumber: Text[30];
        Decimals: Text[30];
    BEGIN
        // FormatDecimal
        //
        //     Format decimal
        // =============

        Precision := 1;
        IF pDec > 0 THEN
            Precision := 1 / POWER(10, pDec);

        pDecimal := ROUND(pDecimal, Precision, '=');

        DecimalText := FORMAT(pDecimal, 0, '<Sign><Integer><Decimals>');

        Pos := STRPOS(DecimalText, ',');
        IF Pos = 0 THEN
            Pos := STRPOS(DecimalText, '.');

        IF Pos > 0 THEN BEGIN
            WholeNumber := COPYSTR(DecimalText, 1, Pos - 1);
            Decimals := COPYSTR(DecimalText, Pos + 1);
            DecimalText := WholeNumber + ',' + Decimals
        END;
    END;



}
