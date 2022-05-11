codeunit 50001 "WebOrder Export Status"
{
    trigger OnRun()
    var
        NvtStatus: Record "NVT Status";
        CustParam: Record "NVT Customer Tpt Parameter";

    begin
        CustParam.reset;
        CustParam.setrange("Status Weborder", true);
        IF CustParam.FindFirst() then begin
            repeat
                NvtStatus.RESET;
                NvtStatus.SetRange(Type, NvtStatus.type::Operational);
                NvtStatus.SETRANGE(ExportWebOrder, true);
                IF NvtStatus.FINDSET Then begin
                    repeat
                        CreateJsonDoc(CustParam."Customer No.", NvtStatus.Code, NvtStatus."Description Status WebOrder");
                    until NvtStatus.next = 0;
                End;
            until CustParam.next = 0;
        end;
    end;




    PROCEDURE CreateJsonDoc(customer: code[20]; status: code[10]; stdesc: Text);
    var
        tempStatus: Record "NVT Status Log" temporary;
        shipment: Record "NVT Shipment";
        ShipGoods: Record "NVT Shipment Goods";
        json: JsonObject;
        jarray: JsonArray;
        str: Text;
        idummy: integer;
        goods: array[4] of Decimal;





        nvtStLog: Record "NVT Status Log";

        HttpCont: HttpContent;


    begin
        tempStatus.Reset();
        if tempStatus.IsTemporary Then
            tempStatus.DeleteAll();

        nvtStLog.reset;

        nvtStLog.SetCurrentKey("No. customer");
        nvtStLog.SetRange("No. customer", customer);
        nvtStLog.SetRange("Status type", nvtStLog."Status type"::Operational);
        nvtStLog.setrange("Code status", status);
        nvtStLog.SetFilter("Shipment No.", '<>%1', 0);
        nvtStLog.SetRange(ExpJson, false);
        nvtStLog.SETFILTER("Date status", '%1..', CALCDATE('-6M', TODAY));
        IF nvtStLog.FindFirst() THEN BEGIN
            repeat
                tempStatus.init;
                tempStatus.TransferFields(nvtStLog);
                tempStatus.insert;

            until nvtStLog.next = 0;
        end;



        Clear(jarray);

        tempStatus.Reset();
        IF tempStatus.FindFirst() Then begin
            repeat
                Clear(json);
                if shipment.GET(tempStatus."Shipment No.") then begin
                    IF evaluate(idummy, shipment."EDI Reference") then
                        json.add('OrderID', idummy)
                    else
                        json.add('OrderID', 0);
                    json.add('CustomerID', tempStatus."No. customer");
                    //json.add('CustomerID', '123456'); //testen
                    json.add('Reference', shipment."File reference");
                    json.add('ShipmentID', shipment."Shipment No.");
                    json.add('DossierID', shipment."File No.");
                    json.add('StatusCode', status);
                    json.add('StatusDescription', stdesc);
                    json.add('ShipmentType', 'Delivery');
                    json.add('LoadingName', shipment."Load address Name");
                    json.add('LoadingAddress', shipment."Load address adress");
                    json.add('LoadingZipcode', shipment."Load address Post Code");
                    json.add('LoadingCity', shipment."Load address city");
                    json.add('LoadingCountryCode', shipment."Load address Country");
                    json.add('LoadingDate', FormatDate(shipment."Loading date"));
                    json.add('LoadingReference', shipment."Load reference");
                    json.add('UnloadingName', shipment."Unload address Name");
                    json.add('UnloadingAddress', shipment."Unload Address address");
                    json.add('UnloadingZipcode', shipment."Unload address Post Code");
                    json.add('UnloadingCity', shipment."Unload address city");
                    json.add('UnloadingCountryCode', shipment."Unload address Country");
                    json.add('UnloadingDate', FormatDate(shipment."Unloading date"));
                    json.add('UnloadingReference', shipment."Unload reference");

                    Clear(goods);
                    goods[1] := 0;
                    goods[2] := 0;
                    goods[3] := 0;
                    goods[4] := 0;
                    ShipGoods.Reset();
                    ShipGoods.SETRANGe("Shipment No.", shipment."Shipment No.");
                    IF ShipGoods.FindFirst() THEN BEGIN
                        repeat
                            goods[1] += ShipGoods.Quantity;
                            goods[2] += ShipGoods.Weight;
                            goods[3] += ShipGoods."Loading Length";
                            goods[4] += ShipGoods.Volume;
                        until ShipGoods.next = 0;
                    End;

                    json.add('TotQuantityGoods', goods[1]);
                    json.add('TotWeight', goods[2]);
                    json.add('TotLM', goods[3]);
                    json.add('TotVolume', goods[4]);

                    json.add('StatusDate', FormatDate(tempStatus."Date status"));
                    json.add('StatusTime', FormatTime(tempStatus."Time status"));
                    json.Add('ErrorCode', tempStatus."Problem Code");
                    json.Add('ErrorDescription', tempStatus."Text problem");

                    jarray.Add(json);



                END;
            until tempStatus.next = 0;





        end;

        Clear(str);
        jarray.WriteTo(str);
        SendWebReq(str);

        tempStatus.RESET;
        IF tempStatus.FindFirst() Then begin
            repeat
                if nvtStLog.get(tempStatus."Log No.") then begin
                    nvtStLog.ExpJson := true;
                    nvtStLog."ExpJson datetime" := CurrentDateTime;
                    nvtStLog.Modify(false);
                end;
            until tempStatus.next = 0;
        end;


    end;




    PROCEDURE SendWebReq(stringvalue: Text);
    var
        uri: text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        typeHelper: Codeunit "Base64 Convert";
        httpcont: HttpContent;
        contentHeaders: HttpHeaders;
        AuthString: Text;
        jsonText: Text;



    begin
        uri := 'https://lux.tlcc.eu/api/upload/statuses';
        Clear(HttpCont);
        HttpCont.WriteFrom(stringvalue);


        AuthString := StrSubstNo('%1:%2', 'marcela.petrosova@tlcc.be', 'M@rc3L@4st@5535INlux03');
        AuthString := typeHelper.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);

        httpcont.GetHeaders(contentHeaders);
        contentHeaders.Clear();

        contentHeaders.Add('Content-Type', 'application/json');
        // contentHeaders.Add('Authorization', AuthString);

        Request.Content := httpcont;
        Request.SetRequestUri(uri);
        Request.Method := 'POST';

        Client.DefaultRequestHeaders.Add('Authorization', AuthString);
        Client.Send(Request, ResponseMessage);
        IF FORMAt(ResponseMessage.HttpStatusCode) <> '200' THEN BEGIN
            message(FORMAt(ResponseMessage.HttpStatusCode) + '\' + ResponseMessage.ReasonPhrase);
            ResponseMessage.Content.ReadAs(jsontext);
            Message(jsonText);
        END

        /*
        
   

        if not HttpCl.Post(, httpcont, ResponseMessage) THEN
            error('The call to the web service failed')
        else begin
            message(FORMAt(ResponseMessage.HttpStatusCode) + '\' + ResponseMessage.ReasonPhrase);
            ResponseMessage.Content.ReadAs(jsontext);
            Message(jsonText);
        end;
        */

    end;

    procedure FormatDate(datevalue: date): Text
    begin
        EXIT(FORMAT(datevalue, 0, '<Year4,4>-<Month,2><Filler Character,0>-<Day,2><Filler Character,0>'));
    end;

    PROCEDURE FormatTime(pTime: Time): Text[10];
    BEGIN
        EXIT(FORMAT(pTime, 0, '<Hours24,2><Filler Character,0>:<Minutes,2><Filler Character,0>:<Second,2><Filler Character,0>'));
    END;
}
