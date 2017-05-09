do
--sendRAW = {}
sendRAW = {171,2,8,0,1,2,0,0,0,0,0,0,0,32,80}
answer = {}

crcR = 0
gotRAW = {}
counter = 1
startUART = false


function ptrANSW()
    tmr.create():alarm(1000, 0, function() 
        print(answer.raw)
        table.foreach(gotRAW, print)
    end)
end

function gotMTRF()
    uart.alt(1)
    uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    uart.on("data",1,
        function(data)
            local bt = string.byte(data, 1) or 0
            if (startUART == false and bt == 0xAD) or startUART == true  then
            startUART = true
            table.insert(gotRAW, bt)
            if counter < 16 then
                crcR = crcR + bt 
            end
            counter = counter + 1
        end
        
        if counter == 18 then
            if gotRAW[1] == 0xAD and gotRAW[17] == 0xAE and (gotRAW[16]) == bit.band(crcR, 0xFF) then 
                local s = ""
                for _, v in pairs(gotRAW) do
                    s = s.."$"..string.format("%02X", v)
                end
                answer.raw = s
                --uart.on("data")
                uart.alt(0)
                uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
                ptrANSW()
            end
        end
    end, 0)
    if #sendRAW == 15 then
        local cr = 0
        for i = 1, 15 do
            cr = cr + sendRAW[i]     
        end
        cr = bit.band(cr, 0xFF)
        sendRAW[16] = cr
        sendRAW[17] = 172
        for i=1,17 do
            uart.write(0, sendRAW[i])
        end
     end
end
gotMTRF()
--
tmr.create():alarm(15000, 0, function() 
    uart.on("data")
    uart.alt(0)
    uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)

end)
--]]
end
