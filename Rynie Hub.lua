-- Rynie Hub Tam Kod
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

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 120, 0, 200)
menu.Position = UDim2.new(0, 10, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Visible = false

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

local function createPanel(titleText)
	local panel = Instance.new("Frame", gui)
	panel.Size = UDim2.new(0, 260, 0, 400)
	panel.Position = UDim2.new(0, 140, 0, 60)
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

	local closeBtn = Instance.new("TextButton", panel)
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 0)
	closeBtn.Text = "X"
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	closeBtn.TextColor3 = Color3.new(1, 1, 1)
	closeBtn.BorderSizePixel = 0
	closeBtn.MouseButton1Click:Connect(function()
		panel.Visible = false
	end)

	return panel
end

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

local homePanel = createPanel("Rynie Hub - Home")
local mm2Panel = createPanel("Rynie Hub - MM2")

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

openBtn.MouseButton1Click:Connect(function()
	menu.Visible = true
	homePanel.Visible = true
end)
-- Özellik değişkenleri
local speedValue = 50
local jumpValue = 100
local flyActive = false
local teleportMode = false
local noclipActive = false
local espEnabled = false
local mm2EspEnabled = false
local coinFarmEnabled = false
local autoKillEnabled = false

-- Home sekmesi
createToggle("ESP", 40, homePanel, function(state)
	espEnabled = state
end)

createToggle("Speed", 80, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = state and speedValue or 16 end
end)
createInput("Speed", 80, homePanel, speedValue, function(val)
	speedValue = val
end)

createToggle("Jump", 120, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = state and jumpValue or 50 end
end)
createInput("Jump", 120, homePanel, jumpValue, function(val)
	jumpValue = val
end)

createToggle("Fly", 160, homePanel, function(state)
	flyActive = state
end)

createToggle("Teleport", 200, homePanel, function(state)
	teleportMode = state
end)

createToggle("NoClip", 240, homePanel, function(state)
	noclipActive = state
end)

-- MM2 sekmesi
createToggle("MM2 ESP", 40, mm2Panel, function(state)
	mm2EspEnabled = state
end)

createToggle("CoinFarm", 80, mm2Panel, function(state)
	coinFarmEnabled = state
end)

createToggle("AutoKill", 120, mm2Panel, function(state)
	autoKillEnabled = state
end)
-- ESP (Home sekmesi)
RunService.RenderStepped:Connect(function()
	if espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				if not p.Character:FindFirstChild("ESP_Highlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "ESP_Highlight"
					hl.Adornee = p.Character
					hl.FillColor = Color3.fromRGB(0, 255, 255)
					hl.OutlineColor = Color3.fromRGB(0, 255, 255)
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

-- MM2 ESP (renkli)
RunService.RenderStepped:Connect(function()
	if mm2EspEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local role = nil
				if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
					role = "Murderer"
				elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
					role = "Sheriff"
				else
					role = "Innocent"
				end

				local color = Color3.fromRGB(0, 255, 0) -- Innocent (yeşil)
				if role == "Murderer" then
					color = Color3.fromRGB(255, 0, 0) -- Kırmızı
				elseif role == "Sheriff" then
					color = Color3.fromRGB(0, 0, 255) -- Mavi
				end

				if not p.Character:FindFirstChild("MM2_Highlight") then
					local hl = Instance.new("Highlight")
					hl.Name = "MM2_Highlight"
					hl.Adornee = p.Character
					hl.FillColor = color
					hl.OutlineColor = color
					hl.FillTransparency = 0.5
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = p.Character
				else
					p.Character.MM2_Highlight.FillColor = color
					p.Character.MM2_Highlight.OutlineColor = color
				end
			end
		end
	else
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local h = p.Character:FindFirstChild("MM2_Highlight")
				if h then h:Destroy() end
			end
		end
	end
end)

-- CoinFarm
RunService.RenderStepped:Connect(function()
	if coinFarmEnabled then
		for _, coin in ipairs(workspace:GetDescendants()) do
			if coin.Name == "Coin" and coin:IsA("Part") then
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = coin.CFrame + Vector3.new(0, 3, 0)
				end
			end
		end
	end
end)

-- AutoKill
RunService.RenderStepped:Connect(function()
	if autoKillEnabled then
		local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife"))
		if knife then
			local closest = nil
			local shortest = math.huge
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
					if dist < shortest then
						shortest = dist
						closest = p
					end
				end
			end
			if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
end)
-- Fly sistemi
RunService.RenderStepped:Connect(function()
	if flyActive then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				root.Velocity = Vector3.new(0, 50, 0)
			elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				root.Velocity = Vector3.new(0, -50, 0)
			else
				root.Velocity = Vector3.new(0, 0, 0)
			end
		end
	end
end)

-- Teleport sistemi
mouse.Button1Down:Connect(function()
	if teleportMode then
		local pos = mouse.Hit.Position
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		end
	end
end)

-- NoClip sistemi
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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- GUI Oluştur
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FlyGUIv3"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "FLY GUI V3"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Hız ayarı
local speed = 50
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.Size = UDim2.new(0, 180, 0, 20)
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

local upBtn = Instance.new("TextButton", frame)
upBtn.Position = UDim2.new(0, 10, 0, 70)
upBtn.Size = UDim2.new(0, 80, 0, 30)
upBtn.Text = "UP +"
upBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.MouseButton1Click:Connect(function()
	speed = speed + 10
	speedLabel.Text = "Speed: " .. speed
end)

local downBtn = Instance.new("TextButton", frame)
downBtn.Position = UDim2.new(0, 110, 0, 70)
downBtn.Size = UDim2.new(0, 80, 0, 30)
downBtn.Text = "DOWN -"
downBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedLabel.Text = "Speed: " .. speed
end)

-- Fly butonu
local flying = false
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Position = UDim2.new(0, 10, 0, 110)
flyBtn.Size = UDim2.new(0, 180, 0, 30)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
flyBtn.TextColor3 = Color3.new(1, 1, 1)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

-- Fly sistemi
RunService.RenderStepped:Connect(function()
	if flying then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				root.Velocity = Vector3.new(0, speed, 0)
			elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				root.Velocity = Vector3.new(0, -speed, 0)
			else
				root.Velocity = Vector3.new(0, 0, 0)
			end
		end
	end
end)
