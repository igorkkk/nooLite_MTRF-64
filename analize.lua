do
local analize = function()
	local itm = gotRAW[5]
	local itms = string.format("%02d", gotRAW[5])
    local ttp = string.format("%02d",itms).."/state"
    local tp = {}
	local top ={}
    top[ttp] = "ON"
    
	local swOff = function(tttp, tm, it)
		return function()
			tmr.create():alarm(tm, 0, function()
				-- uart.alt(0)
                -- uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
				local an = {}
				an[tttp] = "OFF"
				table.insert(answer, an)
				publ()
				-- _G.stop25[it].func = nil
				-- _G.stop25[it] = nil
			end)
		end
	end
		
	if gotRAW[6] ~= 6 and _G.runbrt[itm] ~= nil then _G.runbrt[itm].stopbr = 1 end
	
	if gotRAW[6] == 0 then
        top[ttp] = "OFF"
		table.insert(answer,top)
	elseif gotRAW[6] == 1 or gotRAW[6] == 2 or gotRAW[6] == 3 or gotRAW[6] == 5  then	
		table.insert(answer,top)
	elseif gotRAW[6] == 4 then
		local d = itms.."/changed"
		tp[d] = "ON"
		table.insert(answer,tp)
	elseif gotRAW[6] == 130 or gotRAW[6] == 128  then
        if gotRAW[11] == 0 then
            top[ttp] = "OFF"
            table.insert(answer,top)
        else
            table.insert(answer,top)
        end
    elseif gotRAW[6] == 0x15 then
        local temp = 0
        local hempH = gotRAW[9]
        local hempL = gotRAW[8]
        temp = bit.lshift(bit.band(hempH, 0x0F),8) + hempL
        if (temp > 0x7FF) then
            temp = temp - 0x1000
        end
        temp = temp * 0.1
        local newitm = itms.."/temp"
        tp[newitm] = temp
        if gotRAW[10] ~= 0 then
            local newit = itms.."/humi"
            tp[newit] = gotRAW[10]
        end
        table.insert(answer,tp)
    elseif gotRAW[6] == 20 then
		tp.lowbat = itms
        table.insert(answer,tp)
    elseif gotRAW[6] == 25 then
            --uart.alt(0)
            --uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
		if stop25[itm] then
			stop25[itm].func = nil
			stop25[itm] = nil
		end
		table.insert(answer,top)
		local tm = gotRAW[8] * 5 * 1000
		if gotRAW[7] == 6 then
			tm = (bit.lshift(gotRAW[9], 8) + gotRAW[8]) * 5 * 1000
			if tm > 6870947 then tm = 6870947 end 
		end
		--local aa = {}
		--aa.time = tm
		--table.insert(answer,aa)
		
		if tm > 0 then
			stop25[itm] = {}
			stop25[itm].func = swOff(ttp, tm, itm)
			stop25[itm].func()
		end
	end
    gotRAW = {}
    publ()
end
analize()
end
