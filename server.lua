local random = Random.new()
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}

function getRandomLetter()
	return letters[random:NextInteger(1,#letters)]
end

function getRandomString(length, includeCapitals)
	local length = length or 10
	local str = ''
	for i=1,length do
		local randomLetter = getRandomLetter()
		if includeCapitals and random:NextNumber() > .5 then
			randomLetter = string.upper(randomLetter)
		end
		str = str .. randomLetter
	end
	return str
end
script.Parent.ID.Value = getRandomString(10, true)
local weld
local plr
game.ReplicatedStorage.DisconnectVehicleSocket.OnServerEvent:Connect(function(player, id)
	if id == script.Parent.ID.Value then
		weld:Destroy()
		script.Parent.Throttle.Value = 0
		script.Parent.SteeringAngle.Value = 0

		script.Parent.Parent.FLP.SurfaceGui.TextLabel.Text = ""
		script.Parent.Parent.RLP.SurfaceGui.TextLabel.Text = ""
		wait(2)
		script.Parent.ProximityPrompt.Enabled = true
	end
end)
while true do
	plr = script.Parent.ProximityPrompt.Triggered:Wait()
	script.Parent.ProximityPrompt.Enabled = false
	local chr = plr.Character
	script.Parent.Parent.FLP.SurfaceGui.TextLabel.Text = plr.Name
	script.Parent.Parent.RLP.SurfaceGui.TextLabel.Text = plr.Name
	weld = Instance.new("WeldConstraint", chr)
	weld.Part0 = chr.HumanoidRootPart
	weld.Part1 = script.Parent
	chr.Humanoid.Sit = true
	chr.HumanoidRootPart.Position = script.Parent.Position
	chr.HumanoidRootPart.Orientation = script.Parent.Orientation
	game.ReplicatedStorage.ConnectVehicleSocket:FireClient(plr, script.Parent)
end

