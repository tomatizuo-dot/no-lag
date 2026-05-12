local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local camera = workspace.CurrentCamera
local guiParent = gethui and gethui() or game:GetService("CoreGui")

pcall(function()
	guiParent:FindFirstChild("FriHubNoLag"):Destroy()
end)

-- =========================
-- GUI
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FriHubNoLag"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = guiParent

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.Size = UDim2.new(0.45,0,0.6,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

-- =========================
-- TOP
-- =========================
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundColor3 = Color3.fromRGB(30,30,30)
Top.Parent = Main
Top.Active = true
Instance.new("UICorner", Top).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-120,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FriHub | No Lag"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-70,0.5,-15)
MinBtn.Text = "–"
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Parent = Top
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0.5,-15)
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Top
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

-- =========================
-- SCROLL
-- =========================
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1,0,1,-40)
Container.Position = UDim2.new(0,0,0,40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0,0,0,0)
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,6)
Layout.Parent = Container

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Container.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

-- =========================
-- BUTTON
-- =========================
local function Button(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,45)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = Container
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(callback)
end

-- =========================
-- LIGHT OPTIMIZER
-- =========================
local function clear(v)
	if v:IsA("ParticleEmitter")
	or v:IsA("Trail")
	or v:IsA("Beam")
	or v:IsA("Smoke")
	or v:IsA("Fire")
	or v:IsA("Sparkles")
	or v:IsA("Highlight") then
		v:Destroy()
	end
end

local function Ultra()

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0

	if camera then
		camera.FieldOfView = 60
	end

	-- 1回だけ処理
	for _,v in ipairs(workspace:GetDescendants()) do

		-- エフェクト停止
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then

			v.Enabled = false
		end

		-- パーツ軽量化
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.Plastic
		end

		-- テクスチャ削除
		if v:IsA("Texture")
		or v:IsA("Decal") then
			v:Destroy()
		end
	end
end

local function Balanced()
	Lighting.GlobalShadows = false
	if camera then camera.FieldOfView = 60 end
end

local function Low()
	Lighting.GlobalShadows = false
end

local function Restore()
	Lighting.GlobalShadows = true
	if camera then camera.FieldOfView = 70 end
end

-- =========================
-- BUTTONS
-- =========================
Button("Ultra Mode", Ultra)
Button("Balanced Mode", Balanced)
Button("Low Mode", Low)
Button("Restore Mode", Restore)

-- =========================
-- DRAG
-- =========================
local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end

	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end)

UserInputService.InputEnded:Connect(function()
	dragging = false
end)

-- =========================
-- ⭐ 完全丸最小化（修正版）
-- =========================
local minimized = false

local function setMin(state)

	minimized = state

	if state then
		-- 完全丸モード
		Container.Visible = false
		Top.Visible = false

		Main.Size = UDim2.new(0,44,0,44)
		Main.BackgroundTransparency = 1

		MinBtn.Parent = Main
		MinBtn.Size = UDim2.new(1,0,1,0)
		MinBtn.Position = UDim2.new(0,0,0,0)
		MinBtn.Text = "+"

		CloseBtn.Visible = false

	else
		-- 復帰
		Top.Visible = true
		Container.Visible = true

		Main.Size = UDim2.new(0.45,0,0.6,0)
		Main.BackgroundTransparency = 0

		MinBtn.Parent = Top
		MinBtn.Size = UDim2.new(0,30,0,30)
		MinBtn.Position = UDim2.new(1,-70,0.5,-15)
		MinBtn.Text = "–"

		CloseBtn.Visible = true
	end
end

MinBtn.MouseButton1Click:Connect(function()
	setMin(not minimized)
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
