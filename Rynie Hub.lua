-- RYNIE HUB - TAM KOD (V1.2)
-- Kalıcı ESP, Fly GUI ve Menü Kapanma Düzeltmeleri

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera -- Fly lojiği için eklendi
local mouse = LocalPlayer:GetMouse()

-- === ANA GUI VE ÇERÇEVELER ===
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

-- === YARDIMCI FONKSİYONLAR ===

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
	local label = Instance.new("TextLabel", parent)
	label.Size = UDim2.new(0, 60, 0, 25)
	label.Position = UDim2.new(0, 140, 0, yPos + 5)
	label.Text = name .. ":"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Right
	
	local input = Instance.new("TextBox", parent)
	input.Size = UDim2.new(0, 50, 0, 25)
	input.Position = UDim2.new(0, 205, 0, yPos + 5)
	input.Text = tostring(defaultValue)
	input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	input.TextColor3 = Color3.new(1, 1, 1)
	input.BorderSizePixel = 0

	input.FocusLost:Connect(function()
		local val = tonumber(input.Text)
		if val then onChange(val) end
	end)
end

-- === PANEL VE BUTON TANIMLAMALARI ===
local homePanel = createPanel("Rynie Hub - Home")
local mm2Panel = createPanel("Rynie Hub - MM2")

local homeBtn = createTabButton("Home", 0)
local mm2Btn = createTabButton("MM2", 50)

-- === MENÜ KONTROL LOJİĞİ (Çift Tıklama Kapatma) ===
homeBtn.MouseButton1Click:Connect(function()
    if homePanel.Visible then
        homePanel.Visible = false
        mm2Panel.Visible = false
        menu.Visible = false
    else
        homePanel.Visible = true
        mm2Panel.Visible = false
        menu.Visible = true
    end
end)

mm2Btn.MouseButton1Click:Connect(function()
    if mm2Panel.Visible then
        mm2Panel.Visible = false
        homePanel.Visible = false
        menu.Visible = false
    else
        mm2Panel.Visible = true
        homePanel.Visible = false
        menu.Visible = true
    end
end)

openBtn.MouseButton1Click:Connect(function()
	if menu.Visible then
		menu.Visible = false
		homePanel.Visible = false
		mm2Panel.Visible = false
	else
		menu.Visible = true
		homePanel.Visible = true
	end
end)

-- === ÖZELLİK DEĞİŞKENLERİ ===
local speedValue = 50
local jumpValue = 100
local flyActive = false -- Bu, ana menüdeki fly toggle'ı temsil eder.
local teleportMode = false
local noclipActive = false
local espEnabled = false
local mm2EspEnabled = false
local coinFarmEnabled = false
local autoKillEnabled = false

-- Yeni Fly GUI için değişkenler
local currentFlySpeed = 20
local flyEnabled = false -- Bu, yeni Fly GUI'nin kendi toggle'ını temsil eder.

-- === HOME SEKME ÖZELLİKLERİ ===
createToggle("ESP", 40, homePanel, function(state)
	espEnabled = state
end)

createToggle("Speed", 80, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = state and speedValue or 16 end
end)
createInput("Hız", 80, homePanel, speedValue, function(val)
	speedValue = val
end)

createToggle("Jump", 120, homePanel, function(state)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = state and jumpValue or 50 end
end)
createInput("Güç", 120, homePanel, jumpValue, function(val)
	jumpValue = val
end)

createToggle("Fly", 160, homePanel, function(state)
	flyActive = state -- Bu toggle sadece Fly GUI'yi açıp kapatmak için kullanılabilir veya ana fly'ı kontrol edebilir.
    flyEnabled = state
end)

createToggle("Teleport", 200, homePanel, function(state)
	teleportMode = state
end)

createToggle("NoClip", 240, homePanel, function(state)
	noclipActive = state
end)

-- === MM2 SEKME ÖZELLİKLERİ ===
createToggle("MM2 ESP", 40, mm2Panel, function(state)
	mm2EspEnabled = state
end)

createToggle("CoinFarm", 80, mm2Panel, function(state)
	coinFarmEnabled = state
end)

createToggle("AutoKill", 120, mm2Panel, function(state)
	autoKillEnabled = state
end)

-- === KALICI ESP LOJİĞİ (Highlight Metodu) ===

local function updateEsp(player, highlightName, color)
    local char = player.Character
    if char then
        local highlight = char:FindFirstChild(highlightName)
        
        if color then
            -- ESP ACIK: Highlight yoksa oluştur, varsa rengini güncelle
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = highlightName
                highlight.Adornee = char
                highlight.FillColor = color
                highlight.OutlineColor = color
                highlight.FillTransparency = 0.5
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Duvar arkası görünürlük
                highlight.Parent = char
            else
                highlight.FillColor = color
                highlight.OutlineColor = color
            end
        else
            -- ESP KAPALI: Highlight varsa yok et
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Home ESP (Yeşil)
RunService.RenderStepped:Connect(function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			if espEnabled then
				updateEsp(p, "ESP_Highlight", Color3.fromRGB(0, 255, 0))
			else
				updateEsp(p, "ESP_Highlight", nil)
			end
		end
	end
end)

-- MM2 ESP (Renkli)
RunService.RenderStepped:Connect(function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			if mm2EspEnabled then
				local role = nil
				if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then
					role = "Murderer"
				elseif p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
					role = "Sheriff"
				else
					role = "Innocent"
				end

				local color = Color3.fromRGB(0, 255, 0)
				if role == "Murderer" then
					color = Color3.fromRGB(255, 0, 0)
				elseif role == "Sheriff" then
					color = Color3.fromRGB(0, 0, 255)
				end
				
				updateEsp(p, "MM2_Highlight", color)
			else
				updateEsp(p, "MM2_Highlight", nil)
			end
		end
	end
end)

-- === OYUN HİLE LOJİĞİ ===

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
	else -- NoClip kapalıysa çarpışmayı geri aç
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

-- === YENİ GÖRÜNÜMLÜ FLY GUI LOJİĞİ ===
local NewFlyFrame = Instance.new("Frame")
NewFlyFrame.Name = "NewFlyGUI"
NewFlyFrame.Size = UDim2.new(0, 180, 0, 120)
NewFlyFrame.Position = UDim2.new(0.5, -90, 0.2, 0)
NewFlyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NewFlyFrame.BorderSizePixel = 0
NewFlyFrame.Visible = true -- Başlangıçta görünür
NewFlyFrame.Active = true
NewFlyFrame.Draggable = true
NewFlyFrame.Parent = gui

local TitleBar = Instance.new("Frame", NewFlyFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -25, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "FLIGHT CONTROL"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

local FlyCloseBtn = Instance.new("TextButton", TitleBar)
FlyCloseBtn.Size = UDim2.new(0, 25, 1, 0)
FlyCloseBtn.Position = UDim2.new(1, -25, 0, 0)
FlyCloseBtn.Text = "X"
FlyCloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FlyCloseBtn.TextColor3 = Color3.new(1, 1, 1)
FlyCloseBtn.Font = Enum.Font.SourceSansBold
FlyCloseBtn.TextSize = 18

local GridFrame = Instance.new("Frame", NewFlyFrame)
GridFrame.Size = UDim2.new(1, -20, 0, 65)
GridFrame.Position = UDim2.new(0, 10, 0, 35)
GridFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GridFrame.BackgroundTransparency = 0 -- Görseldeki gibi arka plan rengi

local UP_Btn = Instance.new("TextButton", GridFrame)
UP_Btn.Size = UDim2.new(0.4, 0, 0.45, 0)
UP_Btn.Position = UDim2.new(0.05, 0, 0.05, 0)
UP_Btn.Text = "UP"
UP_Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
UP_Btn.TextColor3 = Color3.new(1, 1, 1)
UP_Btn.Font = Enum.Font.SourceSansBold

local DOWN_Btn = Instance.new("TextButton", GridFrame)
DOWN_Btn.Size = UDim2.new(0.4, 0, 0.45, 0)
DOWN_Btn.Position = UDim2.new(0.05, 0, 0.5, 0)
DOWN_Btn.Text = "DOWN"
DOWN_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
DOWN_Btn.TextColor3 = Color3.new(1, 1, 1)
DOWN_Btn.Font = Enum.Font.SourceSansBold

local PLUS_Btn = Instance.new("TextButton", GridFrame)
PLUS_Btn.Size = UDim2.new(0.4, 0, 0.45, 0)
PLUS_Btn.Position = UDim2.new(0.55, 0, 0.05, 0)
PLUS_Btn.Text = "+"
PLUS_Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
PLUS_Btn.TextColor3 = Color3.new(1, 1, 1)
PLUS_Btn.Font = Enum.Font.SourceSansBold

local MINUS_Btn = Instance.new("TextButton", GridFrame)
MINUS_Btn.Size = UDim2.new(0.4, 0, 0.45, 0)
MINUS_Btn.Position = UDim2.new(0.55, 0, 0.5, 0)
MINUS_Btn.Text = "-"
MINUS_Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MINUS_Btn.TextColor3 = Color3.new(1, 1, 1)
MINUS_Btn.Font = Enum.Font.SourceSansBold

local FlyToggleBtn = Instance.new("TextButton", NewFlyFrame)
FlyToggleBtn.Size = UDim2.new(1, 0, 0, 20)
FlyToggleBtn.Position = UDim2.new(0, 0, 0, 100)
FlyToggleBtn.Text = "FLY: OFF"
FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyToggleBtn.TextColor3 = Color3.new(1, 1, 1)
FlyToggleBtn.Font = Enum.Font.SourceSansBold

-- Fly Hız Yönetimi
local function updateFlyText()
    FlyToggleBtn.Text = "FLY: " .. (flyEnabled and "ON" or "OFF") .. " (" .. currentFlySpeed .. " speed)"
    FlyToggleBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end
updateFlyText()

FlyCloseBtn.MouseButton1Click:Connect(function()
    NewFlyFrame.Visible = false
end)

FlyToggleBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyActive = flyEnabled
    updateFlyText()
end)

PLUS_Btn.MouseButton1Click:Connect(function()
    currentFlySpeed = math.min(150, currentFlySpeed + 10)
    updateFlyText()
end)

MINUS_Btn.MouseButton1Click:Connect(function()
    currentFlySpeed = math.max(10, currentFlySpeed - 10)
    updateFlyText()
end)

-- Fly Lojiği
RunService.RenderStepped:Connect(function()
	if flyEnabled then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = true end

            local moveVector = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.lookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.lookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.rightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.rightVector end
            
            local speedMultiplier = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2 or 1
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UP_Btn:IsPressed() then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or DOWN_Btn:IsPressed() then moveVector = moveVector - Vector3.new(0, 1, 0) end
            
			root.CFrame = root.CFrame + (moveVector.unit * currentFlySpeed * 0.05 * speedMultiplier)
            
		else
            -- Karakter yoksa uçuşu kapat
            flyEnabled = false
            flyActive = false
            updateFlyText()
        end
	else
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end)
