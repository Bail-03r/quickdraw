
--made by 0x8q11 aka Свиногор

local Players = game:GetService("Players")

whitelist = {5163870455,3133503266,4310880766}

local debug = false

local function DebugPart(Position): Part?
	task.spawn(function()
		local Part = Instance.new('Part', workspace)
		Part.Size = Vector3.new(.5,.5,.5)
		Part.CanTouch = false
		Part.CanCollide = false
		Part.CanQuery = false
		Part.Position = Position

		Instance.new('Highlight', Part)

		game:GetService("RunService").Heartbeat:Wait()

		Part:Destroy()
	end)
end

local function FindPlayerOnRay(): Player?

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character:GetChildren(), workspace.Map:GetChildren()}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local RayNew = workspace:Spherecast(workspace.CurrentCamera.CFrame.Position, 3, game.Players.LocalPlayer:GetMouse().UnitRay.Direction*1000, raycastParams)
	
	if debug then
		if RayNew then
			DebugPart(RayNew.Position)
		end
	end

	if RayNew and RayNew.Instance.Parent:FindFirstChild('Humanoid') then
		local Char = RayNew.Instance.Parent
		return game.Players:GetPlayerFromCharacter(Char)
	end
	return nil
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)

	game.Players.LocalPlayer.Character.Acceleration:Destroy()
end)

--game.Players.LocalPlayer.Character.Acceleration:Destroy()

game:GetService'RunService'.Heartbeat:Connect(function()

	local Char = game.Players.LocalPlayer.Character

    local CurrentGun = Char:FindFirstChild('Revolver')
	if CurrentGun then

		local GunPoint = CurrentGun.ToolModel.Handle.GunPoint

		local LookVectorGunPoint = GunPoint.WorldCFrame.lookVector * 500

		local NearestPlayer = FindPlayerOnRay()

		if NearestPlayer then
			GunPoint.WorldCFrame = CFrame.lookAt(GunPoint.WorldCFrame.Position, NearestPlayer.Character.Head.Position)
		else
			GunPoint.WorldCFrame = CFrame.lookAt(GunPoint.WorldCFrame.Position, game.Players.LocalPlayer:GetMouse().Hit.Position)
		end

		local RayNew = workspace:Raycast(GunPoint.WorldCFrame.Position, LookVectorGunPoint)

		if RayNew then

			if debug then
				DebugPart( RayNew.Position )
				DebugPart( RayNew.Position + Vector3.new(0, (Char.HumanoidRootPart.Position - RayNew.Position ).magnitude / 30 ,0) )
			end

		end

	end
end)