local M={}
M.publ = function(answer, call)
	mod.publish = false
	local tobr = {}
	local senddat = function()
    	tobr.heap = ""..node.heap()
    	local sendMQ
    	local kkk,vvv
    	local getd = coroutine.create(function()
    		for kkk, vvv in pairs(tobr) do
    			sendMQ(kkk, vvv)
    			coroutine.yield()
    		end
         
    		-- collectgarbage()
    		if #_G.answer ~= 0 then
    	        maketb()	    
    		elseif call then
    			uart.alt(1)
                uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    			M.publ,sendMQ, getd, M  = nil, nil, nil, nil
    			mod.publish = true
    			package.loaded["pubmqtt"]=nil
    			call()                      
    		end
    	end)
    	sendMQ = function(k, v)
    		m:publish("from"..myClient.."/"..k,v,0,0, 
    			function(con) 
    			coroutine.resume(getd)
    		end)
    	end
    	coroutine.resume(getd)
    end
    local maketb = function()
        local k,v,kk,vv
        for k, v in pairs(_G.answer) do
           for kk,vv in pairs(v) do
               tobr[kk] = vv
                print(kk, vv)
           end
           _G.answer[k] = nil 
        end
        senddat()
    end
    maketb()

end
return M
