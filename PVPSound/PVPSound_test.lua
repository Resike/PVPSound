
local test={}
local testframe = CreateFrame("Frame", nil)
testframe:RegisterEvent("UPDATE_UI_WIDGET")

function test:OnEvent(event,...)
	if event=="UPDATE_UI_WIDGET" then 
		info=...
		--print("11")
		for k,v in pairs(info) do
			
			--print(k," ",v)
		end
	end
end
testframe:SetScript("OnEvent",test.OnEvent)