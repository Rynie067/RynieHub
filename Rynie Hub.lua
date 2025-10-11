local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
local function createButton(name, action)
	local button = Instance.new("TextButton", SettingsPanel)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.Text = name

	button.MouseButton1Click:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		button.Text = name .. " Aktif ✅"
		pcall(action)
		task.delay(1.5, function()
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			button.Text = name
		end)
	end)
end

createButton("Fly GUI'yi Aç", function()
	local plr = Players.LocalPlayer
	local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
	gui.Name = "FlyGUIV3"
	local fly = Instance.new("BodyVelocity")
	local gyro = Instance.new("BodyGyro")
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	fly.Velocity = Vector3.new(0,0,0)
	fly.MaxForce = Vector3.new(1e5,1e5,1e5)
	fly.Parent = hrp
	gyro.CFrame = hrp.CFrame
	gyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
	gyro.P = 1e4
	gyro.Parent = hrp
	RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
		fly.Velocity = dir.Unit * 50
		gyro.CFrame = cam.CFrame
	end)
end)

createButton("AutoKill'i Başlat", function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.Health = 0
		end
	end
end)

createButton("CoinFarm'i Başlat", function()
	for _, coin in ipairs(workspace:GetDescendants()) do
		if coin.Name:lower():find("coin") and coin:IsA("BasePart") then
			coin.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	end
end)

createButton("MM2 ESP'yi Aç", function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local billboard = Instance.new("BillboardGui", player.Character.HumanoidRootPart)
			billboard.Size = UDim2.new(0, 100, 0, 40)
			billboard.AlwaysOnTop = true
			local label = Instance.new("TextLabel", billboard)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 0, 0)
			label.Text = player.Name
			label.Font = Enum.Font.SourceSansBold
			label.TextSize = 14
		end
	end
end)
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

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

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType ==UserInputService.InputChanged:Connect(function(input)
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
