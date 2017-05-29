tmr.create():alarm(22000, 0, function()
    if file.exists("main9.lua") then
        dofile("main9.lua")
    else
        print("No main.lua, Rename init.lua!")
            if file.exists("init.lua") then
            file.rename("init.lua","_init.lua")
            node.restart()
        end
    end
end)
