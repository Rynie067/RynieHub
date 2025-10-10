-- Rynie Hub GUI Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "RynieHub"
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "Rynie Hub"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 20
openBtn.BorderSizePixel = 0

local mainPanel = Instance.new("Frame", gui)
mainPanel.Size = UDim2.new(0, 260, 0, 400)
mainPanel.Position = UDim2.new(0.5, -130, 0.5, -200)
mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Active = true
mainPanel.Draggable = true

local title = Instance.new("TextLabel", mainPanel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Rynie Hub - Home"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BorderSizePixel = 0

local closeBtn = Instance.new("TextButton", mainPanel)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
end)

openBtn.MouseButton1Click:Connect(function()
	mainPanel.Visible = true
end)

local function createToggle(name, yPos, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 120, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = name .. ": OFF"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0

	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		btn.Text = name .. (active and ": ON" or ": OFF")
		btn.BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
		callback(active)
	end)
end

local function createInput(name, yPos, parent, defaultValue, onChange)
	local input = Instance.new("TextBox", parent)
	input.Size = UDim2.new(0, 60, 0, 25)
	input.Position = UDim2.new(0, 140, 0, yPos + 5)
	input.Text = tostring(defaultValue)
	input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	input.TextColor3 = Color3.new(1, 1, 1)
	input.BorderSizePixel = 0
	input.PlaceholderText = name

	input.FocusLost:Connect(function()
		local val = tonumber(input.Text)
		if val then onChange(val) end
	end)
end

-- Özellikler
local speedValue = 50
local jumpValue = 100
local flyActive = false
local teleportMode = false
local noclipActive = false
local espEnabled = false

-- ESP sürekli yenilenir
createToggle("ESP", 40, mainPanel, function(state)
	espEnabled = state
end)

RunService.RenderStepped:Connect(function()
	if espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				if not p.Character:FindFirstChild("ESP_Highlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "ESP_Highlight"
					hl.Adornee = p.Character
					hl.FillColor = Color3.fromRGB(0, 255, 0)
					hl.OutlineColor = Color3.fromRGB(0, 255, 0)
					hl.FillTransparency = 0.5
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = p.Character
				end
			end
		end
	else
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local h = p.Character:FindFirstChild("ESP_Highlight")
				if h then h:Destroy() end
			end
		end
	end
end)

-- Speed
createToggle("Speed", 80, mainPanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = state and speedValue or 16 end
end)
createInput("Speed", 80, mainPanel, speedValue, function(val) speedValue = val end)

-- Jump
createToggle("Jump", 120, mainPanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = state and jumpValue or 50 end
end)
createInput("Jump", 120, mainPanel, jumpValue, function(val) jumpValue = val end)

-- Fly
createToggle("Fly", 160, mainPanel, function(state) flyActive = state end)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp or not flyActive then return end
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		if input.KeyCode == Enum.KeyCode.E then
			root.CFrame = root.CFrame + Vector3.new(0, 3, 0)
		elseif input.KeyCode == Enum.KeyCode.Q then
			root.CFrame = root.CFrame - Vector3.new(0, 3, 0)
		end
	end
end)

-- Teleport
createToggle("Teleport", 200, mainPanel, function(state) teleportMode = state end)
mouse.Button1Down:Connect(function()
	if teleportMode then
		local hit = mouse.Hit
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and hit then
			root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
		end
	end
end)

-- NoClip
createToggle("NoClip", 240, mainPanel, function(state) noclipActive = state end)
RunService.Stepped:Connect(function()
	if noclipActive then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)
