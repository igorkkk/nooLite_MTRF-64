function setmqtt(myClient)
    mod = {} 
    mod.publish = false
    local begin = function()
        local pass = "superpassword" -- Меняем!!
        m = mqtt.Client(myClient, 30, myClient, pass)
        m:lwt(myClient, 0, 0, 0)
        connecting = function ()
            connect = require('getmqtt')
	    -- Ниже "iot.eclipse.org" заменить на свой брокер, если есть. Или оставить.
            connect.connecting(m, "iot.eclipse.org", 1883, myClient, mod, function() connect = nil end)
            begin, setmqtt = nil, nil
        end
        m:on("offline", function(con)
            mod.publish = false
            m:close()
            connecting()
        end)
        m:on("message", function(conn, topic, data) 
            local item = tonumber(topic:sub(-2, -1)) or 65
            local deal = string.match(topic, "/(%a+)/")
            if item >= 0 and  item < 65 then
                comm, itm, func = data, item, deal
				newdeal()
            end
            collectgarbage()
        end)
        connecting()
    end
    begin()
end
