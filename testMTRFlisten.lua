do
function setvars()
    answer = {}
    crcR = 0
    gotRAW = {}
    counter = 1
    startUART = false
end

setvars()

function ptrANSW()
    tmr.create():alarm(100, 0, function() 
        print(answer.raw)
        tmr.create():alarm(100, 0, function() 
            setvars()
            gotMTRF()
        end)
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
                for k, v in ipairs(gotRAW) do
                    s = s..k..":"..string.format("%d", v).." "
                end
                answer.raw = s
                -- uart.on("data")
                uart.alt(0)
                uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
                ptrANSW()
            end
        end
    end, 0)
end
gotMTRF()

--
tmr.create():alarm(300000, 0, function() 
    uart.on("data")
    uart.alt(0)
    uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
    print("Stop The Listening!")
end)
--]]
end
