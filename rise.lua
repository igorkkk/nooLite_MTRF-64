do
    --uart.alt(0)
    --uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
	--print("rize!")
local setbrgt = function(iitm)
    local risesteptime = 10
	local patt = {171,0,0,0,0,6,1,0,0,0,0,0,0,0,0,0,172}
    local brgtnow = 35
	patt[5] = iitm
    patt[8] = brgtnow
    local incr = 6
    
    local sendcom = function(brgtnow)
        patt[8] = brgtnow
        local cr = 0
        local i
        for i = 1, 15 do
            cr = cr + patt[i]     
        end
        patt[16] = bit.band(cr, 0xFF)
        --uart.alt(1)
		--uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
		for i=1,17 do
            uart.write(0, patt[i])
        end
    end
    sendcom(brgtnow)
    return function(call)
        tmr.create():alarm(risesteptime * 1000, 1, function(t)
            brgtnow = brgtnow + incr
			if brgtnow > 155 or _G.runbrt[iitm].stopbr == 1 then
                tmr.stop(t)
                tmr.unregister(t)
                brgtnow, incr, sendcom, iitm = nil, nil, nil, nil
                if call then call() end
			else
                sendcom(brgtnow)
            end
        end)
    end
end

local z = function()
    local litm = itm
	if _G.runbrt[litm] then return end
	
	local ttp = string.format("%02d",litm).."/state"
    local top ={}
    top[ttp] = "ON"
	table.insert(answer,top)
	publ()
	_G.runbrt[litm] = {}
	_G.runbrt[litm].stopbr = 0
	---[[
	local r = function()
		_G.runbrt[litm].func = nil
		_G.runbrt[litm].stopbr = nil
		_G.runbrt[litm] = nil
	end
	--]]
	
	_G.runbrt[litm].func = setbrgt(litm)
    _G.runbrt[litm].func(r)

end
z()
end
