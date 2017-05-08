do
local dealnow
dealnow = function()
    pat[5] = itm

    if func == "comm" then pat[2] = 0
        if comm == "ON" then pat[6] = 2
        else pat[6] = 0
        end
    end

    if func == "comf" then pat[2] = 2
        if comm == "ON" then pat[6] = 2
        else pat[6] = 0
        end
    end

    if func == "coft" then pat[2] = 2
        pat[6] = 25
        local time = tonumber(comm) or 0
        if time < 256 then 
            pat[7] = 5
            pat[8] = time 
        elseif time < 65535 then 
            pat[7] = 6
            pat[8] = bit.band(time, 0xFF)
            pat[9] = bit.rshift(time, 8)
        else
            return
        end
    end

    if func == "askf" then
        pat[2] = 2
        pat[6] =128    
    end
    
    if func == "bitr" then 
       pat[2] = 0
       pat[3] = 0
       if comm == "ON" then pat[6] = 15 
       else pat[6] = 9
       end  
    end

    if func == "bitf" then 
       pat[2] = 2
       pat[3] = 0
       if comm == "ON" then pat[6] = 15 
       else pat[6] = 9
       end  
    end
    
    if func == "birc" then 
       pat[2] = 1 
       pat[3] = 3 
       if comm == "ON" then pat[6] = 15
       else pat[6] = 9
       end  
    end
	dofile('writeMTRF.lua')
end
dealnow()
end
