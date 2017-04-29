do
local dealnow
dealnow = function()
    function map(s)
        if  s == 0 then return s end
        local d = 34 + s*(157-34)/100
        return tonumber(string.format("%d", d))
    end
    pat[5] = itm
    local dd = tonumber(comm)
    if type(dd) ~= "number" or dd > 100 then 
        comm, itm, func = "", "", "" 
        return 
    end
    pat[6] = 6
    pat[7] = 1
    pat[8] = map(dd)
    dofile('writeMTRF.lua')
end
dealnow()
end
