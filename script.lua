--[[ 
  War Tycoon ULTRA PRO Script
  Desenvolvido por ChatGPT para Kaique (Flex971)
  Funções: Auto Farm, Auto Coletar, Auto Comprar, Teleportes, GUI com Abas
]]

local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WarTycoonPro"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 360)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Abas
local tabs, pages = {}, {}
local currentTab = ""

function createTab(name, posX)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 90, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do p.Visible = (n == name) end
        currentTab = name
    end)
end

function createPage(name)
    local pg = Instance.new("Frame", frame)
    pg.Size = UDim2.new(0, 280, 0, 310)
    pg.Position = UDim2.new(0, 10, 0, 40)
    pg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    pg.Visible = (name == "Farm")
    Instance.new("UICorner", pg).CornerRadius = UDim.new(0, 8)
    pages[name] = pg
    return pg
end

function createToggle(pg, name, callback)
    local btn = Instance.new("TextButton", pg)
    btn.Size = UDim2.new(0, 260, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #pg:GetChildren() * 0.11)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = "🔘 " .. name

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = (state and "🟢 " or "🔘 ") .. name
        callback(state)
    end)
end

-- Criar abas
createTab("Farm", 10)
createTab("Coleta", 105)
createTab("Util", 200)

-- Criar páginas
local pgFarm = createPage("Farm")
local pgColeta = createPage("Coleta")
local pgUtil = createPage("Util")

-- Auto Farm Inimigos
createToggle(pgFarm, "Auto Farm Inimigos", function(on)
    task.spawn(function()
        while on and wait(1) do
            local inimigos = workspace:FindFirstChild("Enemies")
            if inimigos then
                for _, e in pairs(inimigos:GetChildren()) do
                    if e:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        wait(0.5)
                    end
                end
            end
        end
    end)
end)

-- Auto Coletar Dinheiro
createToggle(pgFarm, "Auto Coletar Dinheiro", function(on)
    task.spawn(function()
        while on and wait(2) do
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name == "CashCollector" then
                    firetouchinterest(hrp, v.Parent, 0)
                    wait(0.1)
                    firetouchinterest(hrp, v.Parent, 1)
                end
            end
        end
    end)
end)

-- Auto Comprar
createToggle(pgFarm, "Auto Comprar", function(on)
    task.spawn(function()
        while on and wait(3) do
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("buy") then
                    firetouchinterest(hrp, v.Parent, 0)
                    wait(0.1)
                    firetouchinterest(hrp, v.Parent, 1)
                end
            end
        end
    end)
end)

-- Coletar Barris de Óleo
createToggle(pgColeta, "Coletar Barris de Óleo", function(on)
    task.spawn(function()
        while on and wait(2) do
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("barrel") then
                    firetouchinterest(hrp, v.Parent, 0)
                    wait(0.1)
                    firetouchinterest(hrp, v.Parent, 1)
                end
            end
        end
    end)
end)

-- Coletar Caixas de Ferramentas
createToggle(pgColeta, "Coletar Caixas de Ferramenta", function(on)
    task.spawn(function()
        while on and wait(2) do
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("tool") then
                    firetouchinterest(hrp, v.Parent, 0)
                    wait(0.1)
                    firetouchinterest(hrp, v.Parent, 1)
                end
            end
        end
    end)
end)

-- Teleporte para Base
local tpBtn = Instance.new("TextButton", pgUtil)
tpBtn.Size = UDim2.new(0, 260, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, 0.1)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
tpBtn.Text = "📦 Teleportar para Base"
tpBtn.MouseButton1Click:Connect(function()
    local base = workspace:FindFirstChild(plr.Name.."'s Tycoon")
    if base and base:FindFirstChild("Spawn") then
        hrp.CFrame = base.Spawn.CFrame
    end
end)
