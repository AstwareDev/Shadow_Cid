local Debris = workspace:WaitForChild("Thrown")
local TweenService = game:GetService("TweenService")

local rockModule = {}

function rockModule:OnGround(position, size, raw)
	local Orientation = 0
	local TimeToWait = 14
	local TotalNumberOfRocks = 3
	local ExtraOrientation = 25

	if size <= 4 then
		TotalNumberOfRocks = math.random(7,8)
	elseif size < 6 then
		TotalNumberOfRocks = math.random(7,10)
	elseif size < 12  then
		TotalNumberOfRocks = math.random(9,11)
	else
		TotalNumberOfRocks = math.random(6,7)
	end

	for i = 1, TotalNumberOfRocks do
		local RoomBetweenRocks = size
		local cframe = position * CFrame.fromEulerAnglesXYZ(0,math.rad(Orientation),0) * CFrame.new(RoomBetweenRocks,0,RoomBetweenRocks)
		local CFramePosition = cframe.Position

		local NewPart = Instance.new("Part")
		NewPart.Anchored = true
		NewPart.Name = "Rock"
		NewPart.CanCollide = false
		NewPart.Transparency = 0
		NewPart.Parent = workspace.Thrown
		NewPart.Shape = Enum.PartType.Block

		if math.random(1,3) == 5 then
			NewPart.Shape = "Wedge"
		end

		NewPart.CFrame = cframe
		NewPart.CFrame = CFrame.lookAt(Vector3.new(CFramePosition.X,0,CFramePosition.Z), Vector3.new(position.Position.X,0,position.Position.Z))

		local ignoreFolder = game.Workspace.Thrown

		local ignoreList = {}

		for _, part in ipairs(ignoreFolder:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
				table.insert(ignoreList, part)
			end
		end

		table.insert(ignoreList, NewPart)
		table.insert(ignoreList, Debris)

		local Params = RaycastParams.new()
		Params.FilterType = Enum.RaycastFilterType.Blacklist
		Params.FilterDescendantsInstances = ignoreList
		Params.IgnoreWater = true

		local NewRay = workspace:Raycast(CFramePosition+Vector3.new(0,500,0),Vector3.new(0,-1000,0),Params)

		if NewRay and NewRay.Instance then
			NewPart.Material = NewRay.Instance.Material
			NewPart.Color = NewRay.Instance.Color
			NewPart.Transparency = NewRay.Instance.Transparency
		end

		local TotalNewOrientation = Vector3.new(-math.random(ExtraOrientation-10,ExtraOrientation+10),0,0)

		if NewPart.Shape == Enum.PartType.Wedge then
			TotalNewOrientation = TotalNewOrientation + Vector3.new(0,180,0)
		end

		NewPart.Orientation += TotalNewOrientation

		local NewSize = Vector3.new(math.random(math.round(size*0.7),math.round(size*1.5)),1,math.random(size*0.5,size*1.5))
		NewPart.Size = NewSize + Vector3.new(0,size*1.5,0)
		NewPart.CFrame = NewPart.CFrame * CFrame.new(0,(NewSize.Y - NewPart.Size.Y)/2,0)

		Orientation += 360 / TotalNumberOfRocks

		task.spawn(function()
			task.wait(math.random(TimeToWait-1, TimeToWait+5))

			local info = TweenInfo.new(4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
			local Tween = TweenService:Create(NewPart,info,{Position = NewPart.Position - Vector3.new(0,NewPart.Size.Y,0)})
			Tween:Play()

			task.wait(0.5)

			NewPart:Destroy()
		end)
	end

	if raw == true then
		local function flightPart(PartFlinging)
			local initialHeight = 8 
			local velocitySpread = 32 
			local upwardForce = 22

			local velocity = Vector3.new(
				math.random(-velocitySpread, velocitySpread),
				upwardForce,
				math.random(-velocitySpread, velocitySpread)
			)

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = velocity
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.P = 5000
			bodyVelocity.Parent = PartFlinging

			task.wait(0.25)

			bodyVelocity:Destroy()
		end

		local function DestroyingPart(PartToDestroy)
			task.wait(math.random(4,7))
			local multiplier = 0.25

			local NewInfo = TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
			local PartTween = TweenService:Create(PartToDestroy,NewInfo,{Transparency = 1,Size = Vector3.new(PartToDestroy.Size.X*multiplier,PartToDestroy.Size.Y*multiplier,PartToDestroy.Size.Z*multiplier)})
			PartTween:Play()

			task.wait(1.5)

			PartToDestroy:Destroy()
		end
	end
end

function rockModule:TableFlip(Part)
	local upwardForce = 190

	local function flightPart(PartFlinging)
		local initialHeight = 9 
		local velocitySpread = 3

		local velocity = Vector3.new(
			math.random(-velocitySpread, velocitySpread),
			upwardForce,
			math.random(-velocitySpread, velocitySpread)
		)

		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = velocity
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.P = 5000
		bodyVelocity.Parent = PartFlinging

		task.wait(0.8)

		bodyVelocity:Destroy()
	end

	local function CreateCube(AnotherSize,Amount,position)
		for i=1, Amount do
			task.wait(0.25)

			task.spawn(function()
				local NewCube = Instance.new("Part")
				NewCube.Anchored = false
				NewCube.CanCollide = true
				NewCube.Shape = Enum.PartType.Block
				NewCube.Parent = Debris
				NewCube.Name = "TableFlip Part"
				NewCube.Size = AnotherSize
				NewCube.Position = position.Position
				NewCube.Orientation = Vector3.new(math.random(0,360),math.random(0,360),math.random(0,360))


				local ignoreFolder = game.Workspace.Visuals

				local ignoreList = {}

				for _, part in ipairs(ignoreFolder:GetDescendants()) do
					if part:IsA("BasePart") or part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
						table.insert(ignoreList, part)
					end
				end

				table.insert(ignoreList, NewCube)
				table.insert(ignoreList, Part)
				table.insert(ignoreList, Debris)

				local Params = RaycastParams.new()
				Params.FilterType = Enum.RaycastFilterType.Blacklist
				Params.FilterDescendantsInstances = ignoreList
				Params.IgnoreWater = true

				local NewRay = workspace:Raycast(position.Position+Vector3.new(0,500,0),Vector3.new(0,-1000,0),Params)

				if NewRay and NewRay.Instance then
					NewCube.Material = NewRay.Instance.Material
					NewCube.Color = NewRay.Instance.Color
					NewCube.Transparency = NewRay.Instance.Transparency
				end

				flightPart(NewCube)

				task.wait(10)

				NewCube:Destroy()
			end)
		end
	end

	local OldCFrames = {}
	local SortedCFrames = {}
	local grid = 12
	local TotalSmokeParts

	local startPosition = Part.Position - Vector3.new(Part.Size.X / 2, 0, Part.Size.Z / 2)

	for X = 1,(Part.Size.X) do
		if X % grid == 0 then
			for Z = 1,(Part.Size.Z) do
				if Z % grid == 0 then
					table.insert(OldCFrames, CFrame.new(startPosition + Vector3.new(X, 0, Z)))
				end
			end
		end
	end

	for i=1, #OldCFrames do
		local BestCFrame = nil
		local BestDistance = 10000000

		for b, newCFrame in ipairs(OldCFrames) do
			local Distance = (startPosition - newCFrame.Position).Magnitude

			if Distance < BestDistance then
				BestDistance = Distance
				BestCFrame = newCFrame
			end
		end

		table.insert(SortedCFrames,BestCFrame)
		table.remove(OldCFrames,table.find(OldCFrames,BestCFrame))
	end

	for i=1, #SortedCFrames do
		local cframe = SortedCFrames[i]

		task.spawn(function()
			task.wait((i+100)/100)

			for g=1, 3 do
				task.wait(0.3)

				task.spawn(function()
					local RandomNumber = math.random(1,4)

					if RandomNumber == 1 or RandomNumber == 4 then
						CreateCube(Vector3.new(9,9,9),math.random(1,2),cframe)
					elseif RandomNumber == 2 then
						CreateCube(Vector3.new(6,6,6),math.random(1,2),cframe)
					elseif RandomNumber == 3 then
						CreateCube(Vector3.new(8,2,4),math.random(1,2),cframe)
					end
				end)
			end
		end)
	end
end

function rockModule:Trail(Part,Time)
	local function CreateCubeUnderPart(Direction)
		local Params = RaycastParams.new()
		Params.FilterType = Enum.RaycastFilterType.Blacklist
		Params.FilterDescendantsInstances = {Debris,Part.Parent}
		Params.IgnoreWater = true

		local NewRay = workspace:Raycast(Part.Position+Vector3.new(0,500,0),Vector3.new(0,-1000,0),Params)

		local Y = Part.Position.Y
		local NewCube = Instance.new("Part")		

		if NewRay and NewRay.Instance then
			NewCube.Material = NewRay.Instance.Material
			NewCube.Color = NewRay.Instance.Color
			NewCube.Transparency = NewRay.Instance.Transparency

			Y = NewRay.Instance.Position.Y + NewRay.Instance.Size.Y/2 
		end

		local AnotherPosition = CFrame.new(Part.Position.X,Y,Part.Position.Z)

		if Direction == "Left" then
			AnotherPosition = AnotherPosition * CFrame.new(2,0,0)
		else
			AnotherPosition = AnotherPosition * CFrame.new(-2,0,0)
		end

		NewCube.Anchored = true
		NewCube.CanCollide = true
		NewCube.Name = "TrailRock"
		NewCube.Shape = Enum.PartType.Block
		NewCube.Parent = Debris
		NewCube.Transparency = 0
		NewCube.Size = Vector3.new(0.5,0.5,0.5)
		NewCube.CFrame = AnotherPosition
		NewCube.Orientation = Vector3.new(math.random(1,360),math.random(1,360),math.random(1,360))

		if NewRay and NewRay.Instance then
			NewCube.Material = NewRay.Instance.Material
			NewCube.Color = NewRay.Instance.Color
			NewCube.Transparency = NewRay.Instance.Transparency
		end
	end

	local PerSecond = 4

	for i=1, Time*PerSecond do
		task.wait(0.25)

		CreateCubeUnderPart("Right")
		CreateCubeUnderPart("Left")
	end
end

return rockModule
