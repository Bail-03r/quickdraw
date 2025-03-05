local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")

whitelist = {5163870455,3133503266,4310880766}

local debug = true

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


local function nearestPlayerToPart(Position): Player?
	local nearestPlayer = nil
	local nearestDistance = math.huge
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer and not table.find(whitelist,player.UserId) then
			local character = player.Character
			
			if character and character:FindFirstChild('Humanoid') and character.Humanoid.Health>0  then
				local rootPart = character.PrimaryPart
				
				if rootPart then
					local distance = (Position - rootPart.Position).Magnitude
					
					if distance < nearestDistance then
						nearestPlayer = player
						nearestDistance = distance
					end
				end
			end	
		end	
	end
	
	return nearestPlayer
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)

    char.ChildAdded:Connect(function(part)
        if part.Name == 'Revolver_Backpack' or part.Name == 'Winchester_Backpack' or part.Name == 'Acceleration' then
            part:Destroy()
        elseif part.Name == 'Revolver' then
            part.ToolModel.Model:FindFirstChild('Drum'):Destroy()
            part.ToolModel.Model:FindFirstChild('Hammer'):Destroy()
        end
    end)

end)


--game.Players.LocalPlayer.Character.Acceleration:Destroy()

function fire()
    -- mouse1press()
    -- task.wait(.2)
    -- mouse1release()
    -- task.wait(.2)
end

--Модуль Ёж
-- game:GetService'RunService'.Heartbeat:Connect(function()

--     if not game.Players.LocalPlayer.Character:FindFirstChild'Revolver' then return end

--     for i,v in pairs(game.Players:GetPlayers()) do

--         if v~=game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild'Humanoid' and v.Character:FindFirstChild'Humanoid'.Health>0 and v.Character:FindFirstChild'Revolver' then

            
--             local GunPoint = v.Character:FindFirstChild'Revolver'.ToolModel.Handle.GunPoint

--             local raycastParams = RaycastParams.new()
--             raycastParams.FilterDescendantsInstances = {v.Character:GetChildren()}
--             raycastParams.FilterType = Enum.RaycastFilterType.Exclude

--             local LookVectorGunPoint = GunPoint.WorldCFrame.lookVector * 500
--             local RayNew = workspace:Spherecast(GunPoint.WorldCFrame.Position, 1, LookVectorGunPoint, raycastParams)

--             if RayNew then 

--                 DebugPart(RayNew.Position)

--                 if RayNew.Instance:IsDescendantOf(game.Players.LocalPlayer.Character) then  

--                     for i=0,.5,.01 do
--                         if v.Character.Humanoid.Health<=0 then break end
--                         workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.lookAt(workspace.CurrentCamera.CFrame.p, v.Character.Torso.Position),i)
--                         task.wait(.01)
--                     end

--                     -- local rotate = Tween:Create(workspace.CurrentCamera, TweenInfo.new(.3), {CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.p, v.Character.Torso.Position)})
--                     -- rotate:Play()
--                     -- rotate.Ended:Wait()
                    
--                     fire()

--                     task.wait(1)

--                 end
--             end
        
--         end

--     end

-- end)

--aimbot
game:GetService'RunService'.Heartbeat:Connect(function()

	local Char = game.Players.LocalPlayer.Character

    local CurrentGun = Char:FindFirstChild('Revolver')
    if not CurrentGun then return end
    local GunPoint = CurrentGun.ToolModel.Handle.GunPoint

    local LookVectorGunPoint = GunPoint.WorldCFrame.lookVector * 500

    local NearestPlayer = nearestPlayerToPart(game.Players.LocalPlayer:GetMouse().Hit.Position)

    GunPoint.WorldCFrame = CFrame.lookAt(GunPoint.WorldCFrame.Position, NearestPlayer.Character.Head.Position)

    local RayNew = workspace:Raycast(GunPoint.WorldCFrame.Position, LookVectorGunPoint)

    if RayNew then

        if debug then
            DebugPart( RayNew.Position )
            DebugPart( RayNew.Position + Vector3.new(0, (Char.HumanoidRootPart.Position - RayNew.Position ).magnitude / 30 ,0) )
        end

    end

end)