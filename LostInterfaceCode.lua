local LostHub = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local userId = player.UserId

-- User Authentication Configuration
local allowedUsers = {3925482109, 470684482}
local imageId = "rbxassetid://100772368653603"

local function isUserAllowed()
    for _, id in ipairs(allowedUsers) do
        if userId == id then
            return true
        end
    end
    return false
end

if not isUserAllowed() then
    return
end

-- Prevent Multiple Executions
if _G.LostHubInterfaceLoaded then return end
_G.LostHubInterfaceLoaded = true

-- Main Interface Class
local LostHubInterface = {}
LostHubInterface.__index = LostHubInterface

function LostHubInterface.new()
    local self = setmetatable({}, LostHubInterface)
    
    -- Create Interface Container
    self.Container = Instance.new("ScreenGui")
    self.Container.Parent = CoreGui
    
    -- State Variables
    self.menuOpen = false
    self.introComplete = false
    self.initialOpenComplete = false
    self.currentTween = nil
    
    -- Interaction Blocker
    self.interactionBlocker = Instance.new("Frame")
    self.interactionBlocker.Size = UDim2.new(1, 0, 1, 0)
    self.interactionBlocker.BackgroundTransparency = 1
    self.interactionBlocker.Parent = self.Container
    
    -- Create Frames
    self:createIntroFrame()
    self:createMainFrame()
    self:setupTabs()
    self:setupDragging()
    self:setupKeyboardToggle()
    
    return self
end

function LostHubInterface:createIntroFrame()
    self.introFrame = Instance.new("Frame")
    self.introFrame.Size = UDim2.new(1, 0, 1, 0)
    self.introFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    self.introFrame.BackgroundTransparency = 1
    self.introFrame.Parent = self.Container
    
    self.introImage = Instance.new("ImageLabel")
    self.introImage.Size = UDim2.new(0, 150, 0, 150)
    self.introImage.Position = UDim2.new(0.5, -75, 0.25, 0)
    self.introImage.Image = imageId
    self.introImage.BackgroundTransparency = 1
    self.introImage.ImageTransparency = 1
    self.introImage.Parent = self.introFrame
    
    self.introText = Instance.new("TextLabel")
    self.introText.Size = UDim2.new(0, 300, 0, 50)
    self.introText.Position = UDim2.new(0.5, -150, 0.45, 0)
    self.introText.BackgroundTransparency = 1
    self.introText.Text = "Made by [ Lost_JBL | jofer223 ]"
    self.introText.TextColor3 = Color3.fromRGB(255, 0, 0)
    self.introText.TextSize = 24
    self.introText.TextTransparency = 1
    self.introText.Parent = self.introFrame
    
    spawn(function()
        self:animateIntro()
    end)
end


function LostHubInterface:createMainFrame()
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0, 400, 0, 0)
    self.mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    self.mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Visible = false
    self.mainFrame.Parent = self.Container
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = self.mainFrame
    
    -- Drag Area
    self.dragArea = Instance.new("Frame")
    self.dragArea.Size = UDim2.new(1, 0, 0, 50)
    self.dragArea.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    self.dragArea.ClipsDescendants = true
    self.dragArea.Parent = self.mainFrame
    
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 20)
    dragCorner.Parent = self.dragArea

    -- Hub Image
    local hubImage = Instance.new("ImageLabel")
    hubImage.Size = UDim2.new(0, 30, 0, 30)
    hubImage.Position = UDim2.new(0, 15, 0.5, -15)
    hubImage.Image = imageId
    hubImage.BackgroundTransparency = 1
    hubImage.Parent = self.dragArea

    -- LostHub Text
    local lostHubText = Instance.new("TextLabel")
    lostHubText.Size = UDim2.new(0, 200, 0, 40)
    lostHubText.Position = UDim2.new(0, 0, 0.5, -20)
    lostHubText.BackgroundTransparency = 1
    lostHubText.Text = "LostHub"
    lostHubText.TextColor3 = Color3.fromRGB(255, 0, 0)
    lostHubText.TextSize = 30
    lostHubText.Font = Enum.Font.SourceSansBold
    lostHubText.Parent = self.dragArea

    -- JBL Text
    local jblText = Instance.new("TextLabel")
    jblText.Name = "JBLText"
    jblText.Size = UDim2.new(0, 100, 0, 30)
    jblText.Position = UDim2.new(0.75, 0, 0, 0)
    jblText.BackgroundTransparency = 1
    jblText.Text = "JBL"
    jblText.TextColor3 = Color3.fromRGB(255, 0, 0)
    jblText.TextSize = 24
    jblText.Font = Enum.Font.SourceSansBold
    jblText.Parent = self.dragArea

    -- Clan Text
    local clanText = Instance.new("TextLabel")
    clanText.Name = "ClanText"
    clanText.Size = UDim2.new(0, 100, 0, 30)
    clanText.Position = UDim2.new(0.75, 0, 0, 20)
    clanText.BackgroundTransparency = 1
    clanText.Text = "Clan"
    clanText.TextColor3 = Color3.fromRGB(255, 0, 0)
    clanText.TextSize = 20
    clanText.Font = Enum.Font.SourceSansBold
    clanText.Parent = self.dragArea
end

function LostHubInterface:setupTabs()
    -- Placeholder for tab setup
end

function LostHubInterface:setupDragging()
    local dragging = false
    local dragInput, dragStart, startPos
    
    self.dragArea.InputBegan:Connect(function(input)
        if not self.initialOpenComplete then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.dragArea.InputChanged:Connect(function(input)
        if not self.initialOpenComplete then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if not self.initialOpenComplete then return end
        
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function LostHubInterface:setupKeyboardToggle()
    UserInputService.InputBegan:Connect(function(input)
        if not self.initialOpenComplete then return end
        
        if input.KeyCode == Enum.KeyCode.Q then
            self:toggleMenu()
        end
    end)
end

function LostHubInterface:toggleMenu()
    if not self.introComplete or not self.initialOpenComplete then return end
    
    -- Cancela tweens em andamento
    if self.currentMainFrameTween then
        self.currentMainFrameTween:Cancel()
    end
    if self.currentDragAreaTween then
        self.currentDragAreaTween:Cancel()
    end
    
    -- Referências aos textos JBL e Clan
    local jblText = self.dragArea:FindFirstChild("JBLText")
    local clanText = self.dragArea:FindFirstChild("ClanText")
    
    if self.menuOpen then
        -- Fechar o menu
        self.currentMainFrameTween = TweenService:Create(self.mainFrame, TweenInfo.new(0.6), {
            Size = UDim2.new(0, 400, 0, 0)
        })
        
        self.currentDragAreaTween = TweenService:Create(self.dragArea, TweenInfo.new(0.6), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        
        -- Tween para os textos JBL e Clan
        local jblTextTween = TweenService:Create(jblText, TweenInfo.new(0.6), {
            Position = UDim2.new(0.75, 0, 0, 0)
        })
        
        local clanTextTween = TweenService:Create(clanText, TweenInfo.new(0.6), {
            Position = UDim2.new(0.75, 0, 0, 0)
        })
        
        self.currentMainFrameTween:Play()
        self.currentDragAreaTween:Play()
        jblTextTween:Play()
        clanTextTween:Play()
        
        self.currentMainFrameTween.Completed:Connect(function()
            self.mainFrame.Visible = false
        end)
    else
        -- Abrir o menu
        self.mainFrame.Visible = true
        
        self.currentMainFrameTween = TweenService:Create(self.mainFrame, TweenInfo.new(0.8), {
            Size = UDim2.new(0, 400, 0, 550)
        })
        
        self.currentDragAreaTween = TweenService:Create(self.dragArea, TweenInfo.new(0.8), {
            Size = UDim2.new(1, 0, 0, 50)
        })
        
        -- Tween para os textos JBL e Clan
        local jblTextTween = TweenService:Create(jblText, TweenInfo.new(0.8), {
            Position = UDim2.new(0.75, 0, 0, 0)
        })
        
        local clanTextTween = TweenService:Create(clanText, TweenInfo.new(0.8), {
            Position = UDim2.new(0.75, 0, 0, 20)
        })
        
        self.currentMainFrameTween:Play()
        self.currentDragAreaTween:Play()
        jblTextTween:Play()
        clanTextTween:Play()
    end
    
    self.menuOpen = not self.menuOpen
end


function LostHubInterface:animateIntro()
    local fadeIn = TweenService:Create(self.introFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0.5})
    local imageFadeIn = TweenService:Create(self.introImage, TweenInfo.new(1.5), {ImageTransparency = 0})
    local textFadeIn = TweenService:Create(self.introText, TweenInfo.new(1.5), {TextTransparency = 0})
    
    fadeIn:Play()
    imageFadeIn:Play()
    textFadeIn:Play()
    imageFadeIn.Completed:Wait()
    
    wait(2)
    
    local fadeOut = TweenService:Create(self.introFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1})
    local imageFadeOut = TweenService:Create(self.introImage, TweenInfo.new(1.5), {ImageTransparency = 1})
    local textFadeOut = TweenService:Create(self.introText, TweenInfo.new(1.5), {TextTransparency = 1})
    
    fadeOut:Play()
    imageFadeOut:Play()
    textFadeOut:Play()
    fadeOut.Completed:Wait()
    
    self.introFrame:Destroy()
    
    -- Automatically open the menu after intro
    self.introComplete = true
    self:autoOpenInitialMenu()
end

function LostHubInterface:autoOpenInitialMenu()
    self.mainFrame.Visible = true
    
    local openTween = TweenService:Create(self.mainFrame, TweenInfo.new(1), {Size = UDim2.new(0, 400, 0, 550)})
    local openDragAreaTween = TweenService:Create(self.dragArea, TweenInfo.new(1), {Size = UDim2.new(1, 0, 0, 50)})
    
    openTween:Play()
    openDragAreaTween:Play()
    
    openTween.Completed:Connect(function()
        -- Remove interaction blocker
        self.interactionBlocker:Destroy()
        
        -- Enable interactions
        self.initialOpenComplete = true
        self.menuOpen = true
    end)
end

-- Create and Launch Interface
local lostHubInterface = LostHubInterface.new()

return LostHub
