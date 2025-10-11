local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === GUI ===
local HubGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
HubGui.Name = "RynieHubGui"
HubGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton", HubGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.5, 0)
ToggleButton.Text = "R Y N I E"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
local UICornerToggle = Instance.new("UICorner", ToggleButton)
UICornerToggle.CornerRadius = UDim.new(0, 8)

local MainFrame = Instance.new("Frame", HubGui)
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Visible = false

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Text = "Rynie Hub 😈"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local SettingsPanel = Instance.new("ScrollingFrame", MainFrame)
SettingsPanel.Size = UDim2.new(1, 0, 1, -30)
SettingsPanel.Position = UDim2.new(0, 0, 0, 30)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsPanel.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 30)
SettingsPanel.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", SettingsPanel)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

-- === Özellikler ===
local Features = {
	Fly = { State = false, Button = nil },
	AutoKill = { State = false, Button = nil },
	CoinFarm = { State = false, Button = nil },
	MM2ESP = { State = false, Button = nil }
}

local function createToggle(name, onFunction, offFunction)
	local button = Instance.new("TextButton", SettingsPanel)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14

	Features[name].Button = button

	local function updateText()
		button.Text = Features[name].State and name .. ": AÇIK" or name .. ": KAPALI"
		button.BackgroundColor3 = Features[name].State and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
	end

	button.MouseButton1Click:Connect(function()
		Features[name].State = not Features[name].State
		updateText()
		if Features[name].State then onFunction() else offFunction() end
	end)

	updateText()
end

-- === Fly ===
local function flyOn()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
	end)
end

local function flyOff()
	local gui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("FlyGUIV3")
	if gui then gui:Destroy() end
end

-- === AutoKill ===
local autoKillConn
local function autoKillOn()
	autoKillConn = RunService.Stepped:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local knife = char and (char:FindFirstChild("Knife") or char:FindFirstChild("FakeKnife"))
		if not (char and hrp and knife) then return end

		local closest, dist = nil, math.huge
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local d = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
				if d < dist then
					dist = d
					closest = p.Character.HumanoidRootPart
				end
			end
		end
		if closest then
			hrp.CFrame = closest.CFrame + Vector3.new(0, 2, 0)
		end
	end)
end

local function autoKillOff()
	if autoKillConn then autoKillConn:Disconnect() end
end

-- === CoinFarm ===
local coinFarmConn
local function coinFarmOn()
	coinFarmConn = RunService.Stepped:Connect(function()
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		for _, coin in ipairs(workspace:GetDescendants()) do
			if coin:IsA("Part") and (coin.Name == "Coin" or coin.Name == "CoinContainer") then
				hrp.CFrame = CFrame.new(coin.Position + Vector3.new(0, 2, 0))
			end
		end
	end)
end

local function coinFarmOff()
	if coinFarmConn then coinFarmConn:Disconnect() end
end

-- === MM2 ESP ===
local mm2EspConn
local function mm2EspOn()
	mm2EspConn = RunService.RenderStepped:Connect(function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local char = p.Character
				if not char:FindFirstChild("RynieRoleESP") then
					local hl = Instance.new("Highlight")
					hl.Name = "RynieRoleESP"
					hl.Adornee = char
					hl.FillTransparency = 0.5
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

					if char:FindFirstChild("Knife") or char:FindFirstChild("FakeKnife") then
						hl.FillColor = Color3.fromRGB(255, 0, 0)
					elseif char:FindFirstChild("Gun") then
						hl.FillColor = Color3.fromRGB(0, 0, 255)
					else
						hl.FillColor = Color3.fromRGB(0, 255, 0)
					end

					hl.Parent = char
				end
			end
		end
	end)
end

local function mm2EspOff()
	if mm2EspConn then mm2EspConn:Disconnect() end
	for _, p in ipairs(Players:GetPlayers()) do
		local char = p.Character
		if char and char:FindFirstChild("RynieRoleESP") then
			char.RynieRoleESP:Destroy()
		end
	end
end

-- === Toggle Bağlantıları ===
createToggle("Fly", flyOn, flyOff)
createToggle("AutoKill", autoKillOn, autoKillOff)
createToggle("CoinFarm", coinFarmOn, coinFarmOff)
createToggle("MM2ESP", mm2EspOn, mm2EspOff)

-- === Menü Kontrol ===
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
-- === Sürükleme: Toggle Buton ===
local isToggleDragging = false
local toggleDragStartPos = Vector2.new(0, 0)
local toggleDragStartOffset = UDim2.new(0, 0, 0, 0)

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isToggleDragging = true
		toggleDragStartPos = input.Position
		toggleDragStartOffset = ToggleButton.Position
	end
end)

ToggleButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isToggleDragging = false
	end
end)

-- === Sürükleme: Ana Panel ===
local isMainFrameDragging = false
local mainFrameDragStartPos = Vector2.new(0, 0)
local mainFrameDragStartOffset = UDim2.new(0, 0, 0, 0)

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isMainFrameDragging = true
		mainFrameDragStartPos = input.Position
		mainFrameDragStartOffset = MainFrame.Position
	end
end)

TitleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isMainFrameDragging = false
	end
end)

-- === Sürükleme Güncelleme ===
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if isToggleDragging then
			local delta = input.Position - toggleDragStartPos
			ToggleButton.Position = UDim2.new(
				toggleDragStartOffset.X.Scale,
				toggleDragStartOffset.X.Offset + delta.X,
				toggleDragStartOffset.Y.Scale,
				toggleDragStartOffset.Y.Offset + delta.Y
			)
		elseif isMainFrameDragging then
			local delta = input.Position - mainFrameDragStartPos
			MainFrame.Position = UDim2.new(
				mainFrameDragStartOffset.X.Scale,
				mainFrameDragStartOffset.X.Offset + delta.X,
				mainFrameDragStartOffset.Y.Scale,
				mainFrameDragStartOffset.Y.Offset + delta.Y
			)
		end
	end
end)
