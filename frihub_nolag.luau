local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local camera = workspace.CurrentCamera
local guiParent = gethui and gethui() or game:GetService("CoreGui")

pcall(function()
	guiParent:FindFirstChild("FriHubNoLag"):Destroy()
end)

--=========================
-- GUI
--=========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FriHubNoLag"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = guiParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,260,0,240)
Main.Position = UDim2.new(0.5,-130,0.5,-120)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

--=========================
-- TOP
--=========================
local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,36)
Top.BackgroundColor3 = Color3.fromRGB(35,35,35)
Top.BorderSizePixel = 0
Top.Active = true
Top.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,8,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FriHub | No Lag"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

-- minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,28,0,28)
MinBtn.Position = UDim2.new(1,-64,0.5,-14)
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Text = "–"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Top

-- close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-32,0.5,-14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Top

--=========================
-- CONTAINER
--=========================
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1,0,1,-36)
Container.Position = UDim2.new(0,0,0,36)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0,0,0,0)
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,5)
Layout.Parent = Container

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Container.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

--=========================
-- BUTTON
--=========================
local function Button(text, callback)

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,38)
	b.Position = UDim2.new(0,5,0,0)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.Parent = Container

	b.MouseButton1Click:Connect(callback)
end

--=========================
-- OPTIMIZER
--=========================
local optimized = false

local function UltraOptimize()

	if optimized then
		return
	end

	optimized = true

	-- Lighting
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.Technology = Enum.Technology.Compatibility

	-- Camera
	if camera then
		camera.FieldOfView = 50
	end

	-- Water
	if Terrain then
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 1
	end

	-- Effects
	for _,v in ipairs(Lighting:GetChildren()) do

		if v:IsA("BlurEffect")
		or v:IsA("BloomEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("ColorCorrectionEffect")
		or v:IsA("DepthOfFieldEffect") then

			v.Enabled = false
		end
	end

	-- Workspace optimize
	for _,v in ipairs(workspace:GetDescendants()) do

		if v:IsA("BasePart") then

			v.CastShadow = false
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0

			if v.Material == Enum.Material.Neon then
				v.Material = Enum.Material.Plastic
			end
		end

		if v:IsA("MeshPart") then
			v.RenderFidelity = Enum.RenderFidelity.Performance
		end

		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles")
		or v:IsA("Highlight") then

			v.Enabled = false
		end

		if v:IsA("Texture")
		or v:IsA("Decal") then
			v:Destroy()
		end
	end
end

local function Restore()

	optimized = false

	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	Lighting.Technology = Enum.Technology.Future

	if camera then
		camera.FieldOfView = 70
	end
end

--=========================
-- BUTTONS
--=========================
Button("Ultra Optimize", UltraOptimize)
Button("Restore", Restore)

--=========================
-- DRAG
--=========================
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

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function()
	dragging = false
end)

--=========================
-- MINIMIZE
--=========================
local minimized = false
local oldSize = Main.Size

MinBtn.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		oldSize = Main.Size

		Container.Visible = false
		Top.Visible = false

		Main.Size = UDim2.new(0,40,0,40)
		Main.BackgroundColor3 = Color3.fromRGB(40,40,40)

		MinBtn.Parent = Main
		MinBtn.Size = UDim2.new(1,0,1,0)
		MinBtn.Position = UDim2.new(0,0,0,0)
		MinBtn.Text = "+"

	else

		Main.Size = oldSize

		Container.Visible = true
		Top.Visible = true

		MinBtn.Parent = Top
		MinBtn.Size = UDim2.new(0,28,0,28)
		MinBtn.Position = UDim2.new(1,-64,0.5,-14)
		MinBtn.Text = "–"
	end
end)

--=========================
-- CLOSE
--=========================
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
