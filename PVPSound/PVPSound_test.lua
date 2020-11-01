local L={}
local test={}
local testframe = CreateFrame("Frame", nil)
testframe:RegisterEvent("UPDATE_UI_WIDGET")
testframe:RegisterEvent("PVP_TIMER_UPDATE")
testframe:RegisterEvent("PVP_MATCH_COMPLETE")

function test:OnEvent(event,...)
	--local a=string.find("ddddd", L["1"])
	--print(a)
	if event=="UPDATE_UI_WIDGET" then 
		info=...
		--print("11")
		for k,v in pairs(info) do
			
			--print(k," ",v)
		end
	end
	
	if event=="PVP_TIMER_UPDATE" then 
		info=...
		--print(info)
	end
	if event=="PVP_MATCH_COMPLETE" then 
		print("completed")
		info=...
		print(info)
	end
end
testframe:SetScript("OnEvent",test.OnEvent)