M={}
function M.connecting(m, Broker, port, myCl, mod, unload)
    local getConnect
    local count = 0
    getConnect = function()    
       if wifi.sta.status() == 5 then 
            m:connect(Broker, port, 0, 0,
                function(con)
                    tmr.stop(1)
                    --print("Connected to "..Broker.." at "..port)
                    m:subscribe(myCl.."/#",0, function(conn)
                        -- print("Subscribed.")
                     end)
                    if mod then mod.publish = true end
                    answer.getmqtt = "Got Broker now"
                    publ()
                    if unload then
                        getConnect, count = nil, nil
                        package.loaded["getmqtt"]=nil
                        unload()
                    end
            end)
        else
            -- print("Wating for WiFi "..count.." times")
            count = count + 1
            if count > 20 then node.restart() end
        end
    end
    tmr.alarm(1, 15000, 1, function()
        getConnect()
    end)
    getConnect()
end
return M
