do
if comm == "OFF" then node.restart() end
local gotraw = function()
    local rawk = 1
    local itm = ""
    local dat = ""
    local dig = 0
    for i = 1, #comm do
        itm = string.sub(comm, i,i)
        if itm ~= "," then
            dat = dat..itm    
        else
            pat[rawk] = tonumber(dat) or 0
            rawk = rawk + 1
            dat = ""
        end
    end
    pat[rawk] = tonumber(dat) or 0
    if rawk < 15 then
        comm, itm, func = "", "", "" 
		return 
	else
		dofile('writeMTRF.lua')
	end
end
gotraw()
end
