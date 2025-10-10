local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

-- GUI Başlat
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "RynieHub"

-- Sol Menü
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 120, 0, 200)
menu.Position = UDim2.new(0, 10, 0, 100)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0

local function createTabButton(name, yPos)
	local btn = Instance.new("TextButton", menu)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	return btn
end

-- Panel Oluşturucu
local function createPanel(titleText)
	local panel = Instance.new("Frame", gui)
	panel.Size = UDim2.new(0, 220, 0, 400)
	panel.Position = UDim2.new(0, 140, 0, 100)
	panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Active = true
	panel.Draggable = true

	local title = Instance.new("TextLabel", panel)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = titleText
	title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 18
	title.BorderSizePixel = 0

	return panel
end

-- Toggle Buton Oluşturucu
local function createToggle(name, yPos, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 30)
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

-- Home Panel
local homePanel = createPanel("Rynie Hub - Home")

-- ESP
createToggle("ESP", 40, homePanel, function(state)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local h = p.Character:FindFirstChild("ESP_Highlight")
			if state and not h then
				local hl = Instance.new("Highlight")
				hl.Name = "ESP_Highlight"
				hl.Adornee = p.Character
				hl.FillColor = Color3.fromRGB(0, 255, 0)
				hl.OutlineColor = Color3.fromRGB(0, 255, 0)
				hl.FillTransparency = 0.5
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = p.Character
			elseif not state and h then
				h:Destroy()
			end
		end
	end
end)

-- Speed
local speedValue = 50
createToggle("Speed", 80, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = state and speedValue or 16 end
end)

-- Jump
local jumpValue = 100
createToggle("Jump", 120, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = state and jumpValue or 50 end
end)

-- Fly
local flyActive = false
local flySpeed = 3
createToggle("Fly", 160, homePanel, function(state)
	flyActive = state
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp or not flyActive then return end
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		if input.KeyCode == Enum.KeyCode.E then
			root.CFrame = root.CFrame + Vector3.new(0, flySpeed, 0)
		elseif input.KeyCode == Enum.KeyCode.Q then
			root.CFrame = root.CFrame - Vector3.new(0, flySpeed, 0)
		end
	end
end)

-- Teleport
local teleportMode = false
createToggle("Teleport", 200, homePanel, function(state)
	teleportMode = state
end)

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
local noclipActive = false
createToggle("NoClip", 240, homePanel, function(state)
	noclipActive = state
end)

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

-- MM2 Panel
local mm2Panel = createPanel("Rynie Hub - MM2")

-- Silent Aim
createToggle("Silent Aim", 40, mm2Panel, function(state)
	-- Silent aim tetikleyici, hedefleme sistemi ayrı eklenmeli
end)

-- Gelişmiş ESP
createToggle("MM2 ESP", 80, mm2Panel, function(state)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local role = "Innocent" -- örnek, gerçek rol sistemine bağlanmalı
			local color = Color3.fromRGB(0, 255, 0)
			if role == "Murderer" then
				color = Color3.fromRGB(255, 0, 0)
			elseif role == "Sheriff" then
				color = Color3.fromRGB(0, 0, 255)
			end

			if state then
				if not player.Character:FindFirstChild("MM2_Highlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "MM2_Highlight"
					hl.Adornee = player.Character
					hl.FillColor = color
					hl.OutlineColor = color
					hl.FillTransparency = 0.5
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = player.Character
				end
			else
				local hl = player.Character:FindFirstChild("MM2_Highlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

-- Sekme Butonları
local homeBtn = createTabButton("Home", 0)
local mm2Btn = createTabButton("MM2", 50)

homeBtn.MouseButton1Click:Connect(function()
	homePanel.Visible = true
	mm2Panel.Visible = false
end)

mm2Btn.MouseButton1Click:Connect(function()
	homePanel.Visible = false
	mm2Panel.Visible = true
end)

-- Varsayılan olarak Home açık
homePanel.Visible = true