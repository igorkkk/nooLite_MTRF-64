do
 local cr = 0
    for i = 1, 15 do
        cr = cr + pat[i]     
    end
    cr = bit.band(cr, 0xFF)
    pat[16] = cr
    pat[17] = 172
    --[[
    for k,v in pairs(pat) do
        print(k, v)
    end
  --]]  
    for i=1,17 do
        uart.write(0, pat[i])
    end
    comm, itm, func = "", "", ""
end