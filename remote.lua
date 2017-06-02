do
local dealnow
dealnow = function()
	local locitm = itm
	local loccomm = comm
	pat[5] = locitm
	pat[2] = 2
	pat[6] = 131
	pat[7] = 1
	if loccomm == "ON" then 
		pat[8] = 1
	else
		pat[8] = 0
	end
	dofile('writeMTRF.lua')
--[[
    if loccomm == "OFF" then
    	tmr.create():alarm(20000, 0, function()
    		local pt = {171,2,0,0,0,9,0,0,0,0,0,0,0,0,0,0,172}
    		pt[5] = locitm
    		local cr = 0
    		local i
    		for i = 1, 15 do
    			cr = cr + pt[i]     
    		end
    		cr = bit.band(cr, 0xFF)
    		pt[16] = cr
    		pt[17] = 172
    
    		for i=1,17 do
    			uart.write(0, pt[i])
    		end
    	end)
    end
--]]	
end
dealnow()
end
