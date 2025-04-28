local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}

Module.Settings = {
    Color = Color3.fromRGB(80, 0, 130),
    TransparencyStart = 0.4,
    Lifetime = 0.3,
    Material = Enum.Material.ForceField,
    IgnoreParts = {"HumanoidRootPart"},
}

function Module.AfterImage()
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and not table.find(Module.Settings.IgnoreParts, part.Name) then
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
