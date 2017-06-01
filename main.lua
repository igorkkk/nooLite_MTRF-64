do
uart.alt(1)
uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
answer = {}
myClient = "noo01"
mod = {} 
mod.publish = true
mod.broker = false
stop25 = {}
runbrt = {}
-- UART
crcR = 0
gotRAW = {}
UARTbyte = 1
startUART = false
--------
pat = {171,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,172}
comm = "" 
itm = "" 
func = ""

publ = function()
    if mod.publish == true and mod.broker == true then
        local pu = require('pubmqtt')
        local unload = function () pu = nil end
        pu.publ(answer, unload)
    else
		tmr.create():alarm(2500,0, function() 
			sendMQ, getd, M  = nil, nil, nil, nil
    		mod.publish = true
    		package.loaded["pubmqtt"]=nil
			publ()
		end)
	
	end
end

function clearUART()
    UARTbyte = 1
    crcR = 0
end
--
uart.on("data",1,
    function(data)
        local bt = string.byte(data, 1) or 0
        if (startUART == false and bt == 0xAD) or startUART == true  then
        startUART = true
        table.insert(gotRAW, bt)
        if UARTbyte < 16 then
            crcR = crcR + bt 
        end
        if UARTbyte == 1 then
            stUART = tmr.create()   
            stUART:alarm(1000, 0, function() 
               clearUART()
            end) 
        end
        UARTbyte = UARTbyte + 1
    end
    
    if UARTbyte == 18 then
        if gotRAW[1] == 0xAD and gotRAW[17] == 0xAE and (gotRAW[16]) == bit.band(crcR, 0xFF) then 
            tmr.stop(stUART)
            tmr.unregister(stUART)
            local s = ""
            for n, v in ipairs(gotRAW) do
                s = s..(n-1)..":"..string.format("%d", v).." "
            end
            s = string.sub(s, 1, #s - 1)
            table.insert(answer,{raw = s})
            --uart.alt(0)
            --uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
            dofile('analize.lua')
            clearUART()
        end
    end
end, 0)
--]]
function newdeal()
	for i=2, 16 do pat[i] = 0 end
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
tmr.create():alarm(60000,1,function()
	--[[
	uart.alt(0)
    uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
    tmr.create():alarm(2000,0,function()
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n=========== _G table: ===========")
        table.foreach(_G, print)
        print("===== package.loaded table: =====")
        table.foreach(_G.package.loaded, print)
        print("=================================")
    --]]
        tmr.create():alarm(7000,0,function()
        --    uart.alt(1)
        --    uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
        	publ()
        end)
    -- end)

end)

end
