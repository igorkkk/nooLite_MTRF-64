M={}
M.publ = function(answer, call)
    answer.heap = ""..node.heap()
    local sendMQ
    local getd = coroutine.create(function()
        for k, v in pairs(answer) do
            sendMQ(k, v)
            coroutine.yield()
        end
            collectgarbage()
			-- 29.04.2017 clear table to send fot MQTT broker
			answer = {}
            if call then
                M.publ,sendMQ, getd, M  = nil, nil, nil, nil
                package.loaded["pubmqtt"]=nil
                call()                      
            end
    end)
    sendMQ = function(k, v)
        m:publish("from"..myClient.."/"..k,v,0,0, 
            function(con) 
                -- print("Send "..k.." = "..v)
                coroutine.resume(getd)
        end)
    end
    coroutine.resume(getd)
end
return M
