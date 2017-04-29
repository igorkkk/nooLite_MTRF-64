do
uart.alt(1)
uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
answer = {}
myClient = "noo01"
mod = {} 
mod.publish = false
-- UART
crcR = 0
gotRAW = {}
counter = 1
startUART = false
--------
pat = {171,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,172}
comm = "" 
itm = "" 
func = ""

publ = function()
    if mod.publish then
        local pu = require('pubmqtt')
        local unload = function () pu = nil end
        pu.publ(answer, unload)
    end
end

function clearUART()
    counter = 1
    crcR = 0
end
--
uart.on("data",1,
    function(data)
        local bt = string.byte(data, 1) or 0
        if (startUART == false and bt == 0xAD) or startUART == true  then
        startUART = true
        table.insert(gotRAW, bt)
        if counter < 16 then
            crcR = crcR + bt 
        end
        if counter == 1 then
            stUART = tmr.create()   
            stUART:alarm(1000, 0, function() 
               clearUART()
            end) 
        end
        counter = counter + 1
    end
    
    if counter == 18 then
        if gotRAW[1] == 0xAD and gotRAW[17] == 0xAE and (gotRAW[16]) == bit.band(crcR, 0xFF) then 
            tmr.stop(stUART)
            tmr.unregister(stUART)
            local s = ""
            for _, v in pairs(gotRAW) do
                s = s.."$"..string.format("%02X", v)
            end
            -- 29.04.2017
            answer = {}
            answer.raw = s
            dofile('analize.lua')
            clearUART()
        end
    end
end, 0)
--]]
function newdeal()
    answer = {}
	for i=2, 16 do
		pat[i] = 0
	end
    local lis = file.list()
    local fl
    if func ~= nil then 
        fl = func..".lua"
    else 
        fl = 'run.lua'
    end
    for k,v in pairs(lis) do
        if k == fl then
            dofile(fl)
            return
        end
    end
    dofile('run.lua')
end

f = loadfile("setmqtt.lua")
f()
setmqtt(myClient)
f=nil
end
