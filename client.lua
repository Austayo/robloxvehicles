local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local inVehicle = false

local SteeringSensitivity = 1
local Acceleration = 10
local Speed = 40


if (UIS.TouchEnabled and not UIS.MouseEnabled) then
	RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
		while inVehicle do wait()
			inVehicle = true
			local GetIsJumping = player.Character.Humanoid.Jump
			local GetMoveVector = require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector()
			vehicle.SteeringAngle.Value = GetMoveVector.X
			vehicle.Throttle.Value = -GetMoveVector.Z
			if GetIsJumping then
				inVehicle = false
				player.Character.WeldConstraint:Destroy()
				vehicle.Throttle.Value = 0
				vehicle.SteeringAngle.Value = 0
				RS.DisconnectVehicleSocket:FireServer(vehicle.ID.Value)
				break;
			end
		end
	end)
else
	RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
		inVehicle = true
		while inVehicle do
			local inputEvent, gameProcessed = UIS.InputBegan:Wait()
			if not gameProcessed then 
				if inputEvent.UserInputType == Enum.UserInputType.Keyboard then
					if UIS:IsKeyDown(Enum.KeyCode.Space) then
						inVehicle = false
						player.Character.WeldConstraint:Destroy()
						vehicle.Throttle.Value = 0
						vehicle.SteeringAngle.Value = 0
						RS.DisconnectVehicleSocket:FireServer(vehicle.ID.Value)
						break;
					end
					if UIS:IsKeyDown(Enum.KeyCode.W) then
						vehicle.Throttle.Value = 1
					elseif UIS:IsKeyDown(Enum.KeyCode.S) then
						vehicle.Throttle.Value = -1
					end
					if UIS:IsKeyDown(Enum.KeyCode.A) then
						vehicle.SteeringAngle.Value = -1
					elseif UIS:IsKeyDown(Enum.KeyCode.D) then
						vehicle.SteeringAngle.Value = 1
					end
				elseif inputEvent.UserInputType == Enum.UserInputType.Gamepad1 then
					if inputEvent.KeyCode == Enum.KeyCode.ButtonA then
						inVehicle = false
						player.Character.WeldConstraint:Destroy()
						vehicle.Throttle.Value = 0
						vehicle.SteeringAngle.Value = 0
						RS.DisconnectVehicleSocket:FireServer(vehicle.ID.Value)
						break;
					end
				end
			end
		end
	end)
	RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
		inVehicle = true
		while inVehicle do
			local inputEvent = UIS.InputEnded:Wait()
			if inputEvent.UserInputType == Enum.UserInputType.Keyboard then
				if not UIS:IsKeyDown(Enum.KeyCode.W) and not UIS:IsKeyDown(Enum.KeyCode.S) then
					vehicle.Throttle.Value = 0
				end
				if not UIS:IsKeyDown(Enum.KeyCode.A) and not UIS:IsKeyDown(Enum.KeyCode.D) then
					vehicle.SteeringAngle.Value = 0
				end
			end
		end
	end)
	RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
		inVehicle = true
		while inVehicle do
			local input = UIS.InputChanged:Wait()
			if input.UserInputType == Enum.UserInputType.Gamepad1 then
				if input.KeyCode == Enum.KeyCode.Thumbstick1 then
					vehicle.SteeringAngle.Value = input.Position.X
				end
				if input.KeyCode == Enum.KeyCode.ButtonR2 then
					vehicle.Throttle.Value = input.Position.Z
				end
			end
		end
	end)
end


RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
	inVehicle = true
	while inVehicle do
		vehicle.Throttle.Changed:Wait()
		vehicle.Parent.MotorL.Motor.AngularVelocity = vehicle.Throttle.Value * 50
		vehicle.Parent.MotorR.Motor.AngularVelocity = -vehicle.Throttle.Value * 50
	end
end)
RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
	inVehicle = true
	while inVehicle do
		vehicle.SteeringAngle.Changed:Wait()
		vehicle.Parent.ServoL.Servo.TargetAngle = vehicle.SteeringAngle.Value * 40
		vehicle.Parent.ServoR.Servo.TargetAngle = vehicle.SteeringAngle.Value * 40
	end
end)
RS.ConnectVehicleSocket.OnClientEvent:Connect(function(vehicle)
	vehicle.Parent.ServoL.Servo.AngularSpeed = SteeringSensitivity
	vehicle.Parent.ServoR.Servo.AngularSpeed = SteeringSensitivity
	
end)
