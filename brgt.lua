do
local dealnow = function()
    function map(s)
        if  s <= 0 then return s end
        local d = 35 + s*120/100
        return math.floor(d)
    end
    pat[5] = itm
    local dd = tonumber(comm) or 100
    if dd > 100 then dd = 100 end
    pat[6] = 6
    pat[7] = 1
    pat[8] = map(dd)
    dofile('writeMTRF.lua')
end
dealnow()
end
