-- Just test, no project!
tmr.create():alarm(5000, 1, function() 
	print("Alarm")
	collectgarbage()
end)