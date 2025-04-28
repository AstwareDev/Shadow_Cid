local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}

Module.Settings = {
    Color = Color3.fromRGB(255, 0, 255),
    TransparencyStart = 0.4,
    Lifetime = 0.3,
    Material = Enum.Material.Neon,
    AllowedParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
}

function Module.AfterImage()
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and table.find(Module.Settings.AllowedParts, part.Name) then
            local clone = Instance.new("Part")
            clone.Size = part.Size
            clone.CFrame = part.CFrame
            clone.Color = Module.Settings.Color
            clone.Transparency = Module.Settings.TransparencyStart
            clone.Material = Module.Settings.Material
            clone.Anchored = true
            clone.CanCollide = false
            clone.Parent = workspace
            task.spawn(function()
                local start = tick()
                while tick() - start < Module.Settings.Lifetime do
                    local elapsed = tick() - start
                    clone.Transparency = Module.Settings.TransparencyStart + (elapsed / Module.Settings.Lifetime)
                    RunService.Heartbeat:Wait()
                end
                clone:Destroy()
            end)
        end
    end
end

return Module
