local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

--========================
-- GUI
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "no lag"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,100)
frame.Position = UDim2.new(0.5,-110,0.5,-50)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = ScreenGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,-20,0,50)
btn.Position = UDim2.new(0,10,0,10)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.Text = "no lag OFF"
btn.Parent = frame

--========================
-- STATE
--========================
local enabled = false
local animLoopRunning = false

--========================
-- ANTI ANIMATION (30秒保険)
--========================
local function startAnimLock(char)

	if animLoopRunning then return end
	animLoopRunning = true

	local humanoid = char:WaitForChild("Humanoid")

	-- 即停止（初回）
	local animate = char:FindFirstChild("Animate")
	if animate then
		animate.Disabled = true
	end

	humanoid.AnimationPlayed:Connect(function(track)
		if enabled then
			track:Stop()
		end
	end)

	task.spawn(function()
		while char.Parent and enabled do
			task.wait(30)

			for _,track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				track:Stop()
			end
		end
	end)
end

--========================
-- ENABLE
--========================
local function Enable()

	-- Lighting軽量化（光ほぼゼロ）
	Lighting.GlobalShadows = false
	Lighting.Brightness = 0
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.FogEnd = 1e9
	Lighting.OutdoorAmbient = Color3.new(0,0,0)

	pcall(function()
		Lighting.Technology = Enum.Technology.Compatibility
	end)

	-- ポストエフェクト削除
	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("BloomEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("ColorCorrectionEffect")
		or v:IsA("DepthOfFieldEffect")
		or v:IsA("Atmosphere")
		or v:IsA("Sky") then
			v:Destroy()
		end
	end

	-- 初回軽量化
	for _,v in ipairs(game:GetDescendants()) do

		if v:IsA("ScreenGui") then
			v.Enabled = false
		end

		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v.Enabled = false
		end

		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		end

		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.SmoothPlastic
			v.Reflectance = 0
		end
	end

	-- 追加分監視
	workspace.DescendantAdded:Connect(function(v)

		if not enabled then return end

		if v:IsA("ScreenGui") then
			v.Enabled = false
		end

		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v.Enabled = false
		end

		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		end

		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.SmoothPlastic
		end
	end)

	-- キャラアニメ制御開始
	if player.Character then
		startAnimLock(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		if enabled then
			animLoopRunning = false
			startAnimLock(char)
		end
	end)
end

--========================
-- DISABLE
--========================
local function Disable()

	Lighting.GlobalShadows = true
	Lighting.Brightness = 2
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 1
	Lighting.FogEnd = 100000
	Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)

	pcall(function()
		Lighting.Technology = Enum.Technology.Future
	end)

	animLoopRunning = false
end

--========================
-- TOGGLE
--========================
btn.MouseButton1Click:Connect(function()

	enabled = not enabled

	if enabled then
		btn.Text = "no lag ON"
		btn.BackgroundColor3 = Color3.fromRGB(0,170,80)
		Enable()
	else
		btn.Text = "no lag OFF"
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		Disable()
	end
end)
