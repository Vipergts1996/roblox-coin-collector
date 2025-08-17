local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RaceGui = {}

-- GUI elements
local raceScreenGui = nil
local joinPrompt = nil
local raceHud = nil
local resultsGui = nil

-- Track if player joined the race
local playerJoinedRace = false

function RaceGui.createJoinPrompt()
    if joinPrompt then
        joinPrompt:Destroy()
    end
    
    -- Reset join status for new race
    playerJoinedRace = false
    
    -- Main race prompt GUI
    raceScreenGui = Instance.new("ScreenGui")
    raceScreenGui.Name = "RaceGui"
    raceScreenGui.Parent = playerGui
    
    -- Join prompt frame - automotive styled
    joinPrompt = Instance.new("Frame")
    joinPrompt.Name = "JoinPrompt"
    joinPrompt.Size = UDim2.new(0.4, 0, 0.2, 0)
    joinPrompt.Position = UDim2.new(0.5, 0, 0.3, 0)
    joinPrompt.AnchorPoint = Vector2.new(0.5, 0.5)
    joinPrompt.BackgroundColor3 = Color3.fromRGB(40, 35, 30) -- Dark automotive color
    joinPrompt.BorderSizePixel = 0
    joinPrompt.Parent = raceScreenGui
    
    -- Automotive border
    local promptBorder = Instance.new("UIStroke")
    promptBorder.Thickness = 2
    promptBorder.Color = Color3.fromRGB(255, 140, 0) -- Amber accent
    promptBorder.Parent = joinPrompt
    
    local promptCorner = Instance.new("UICorner")
    promptCorner.CornerRadius = UDim.new(0.02, 0)
    promptCorner.Parent = joinPrompt
    
    -- Race title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🏁 RACE STARTING!"
    titleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.Highway
    titleLabel.Parent = joinPrompt
    
    -- Countdown label
    local countdownLabel = Instance.new("TextLabel")
    countdownLabel.Name = "CountdownLabel"
    countdownLabel.Size = UDim2.new(1, 0, 0.3, 0)
    countdownLabel.Position = UDim2.new(0, 0, 0.35, 0)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Text = "Time to join: 10s"
    countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    countdownLabel.TextScaled = true
    countdownLabel.Font = Enum.Font.Highway
    countdownLabel.Parent = joinPrompt
    
    -- Join button
    local joinButton = Instance.new("TextButton")
    joinButton.Name = "JoinButton"
    joinButton.Size = UDim2.new(0.35, 0, 0.25, 0)
    joinButton.Position = UDim2.new(0.02, 0, 0.7, 0)
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Green join button
    joinButton.BorderSizePixel = 0
    joinButton.Text = "JOIN RACE"
    joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinButton.TextScaled = true
    joinButton.Font = Enum.Font.Highway
    joinButton.Parent = joinPrompt
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.05, 0)
    buttonCorner.Parent = joinButton
    
    -- Cancel button
    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.35, 0, 0.25, 0)
    cancelButton.Position = UDim2.new(0.65, 0, 0.7, 0)
    cancelButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- Red cancel button
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "CANCEL"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextScaled = true
    cancelButton.Font = Enum.Font.Highway
    cancelButton.Parent = joinPrompt
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0.05, 0)
    cancelCorner.Parent = cancelButton
    
    -- Button click animation and functionality
    joinButton.MouseButton1Click:Connect(function()
        -- Click animation
        local clickTween = TweenService:Create(joinButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0.55, 0, 0.22, 0)}
        )
        local returnTween = TweenService:Create(joinButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0.6, 0, 0.25, 0)}
        )
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            returnTween:Play()
        end)
        
        -- Join race
        local joinRaceEvent = ReplicatedStorage:FindFirstChild("JoinRace")
        if joinRaceEvent then
            joinRaceEvent:FireServer()
        end
    end)
    
    -- Cancel button click functionality
    cancelButton.MouseButton1Click:Connect(function()
        -- Click animation
        local clickTween = TweenService:Create(cancelButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0.32, 0, 0.22, 0)}
        )
        local returnTween = TweenService:Create(cancelButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0.35, 0, 0.25, 0)}
        )
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            returnTween:Play()
        end)
        
        -- Close the GUI
        RaceGui.hideAllGuis()
    end)
    
    -- Animate in
    joinPrompt.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(joinPrompt,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.4, 0, 0.2, 0)}
    )
    openTween:Play()
end

function RaceGui.createRaceHud()
    -- Only show to players who joined the race
    if not playerJoinedRace then return end
    
    if raceHud then
        raceHud:Destroy()
    end
    
    -- Race HUD during active race
    raceHud = Instance.new("Frame")
    raceHud.Name = "RaceHud"
    raceHud.Size = UDim2.new(0.3, 0, 0.15, 0)
    raceHud.Position = UDim2.new(0.02, 0, 0.02, 0)
    raceHud.BackgroundColor3 = Color3.fromRGB(40, 35, 30)
    raceHud.BorderSizePixel = 0
    raceHud.Parent = raceScreenGui
    
    local hudBorder = Instance.new("UIStroke")
    hudBorder.Thickness = 1
    hudBorder.Color = Color3.fromRGB(80, 80, 80)
    hudBorder.Parent = raceHud
    
    local hudCorner = Instance.new("UICorner")
    hudCorner.CornerRadius = UDim.new(0.05, 0)
    hudCorner.Parent = raceHud
    
    -- Race status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0.4, 0)
    statusLabel.Position = UDim2.new(0, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🏁 RACE IN PROGRESS"
    statusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Highway
    statusLabel.Parent = raceHud
    
    -- Timer label
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(1, 0, 0.3, 0)
    timerLabel.Position = UDim2.new(0, 0, 0.4, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Time: 30s"
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.Highway
    timerLabel.Parent = raceHud
    
    -- Participants label
    local participantsLabel = Instance.new("TextLabel")
    participantsLabel.Name = "ParticipantsLabel"
    participantsLabel.Size = UDim2.new(1, 0, 0.3, 0)
    participantsLabel.Position = UDim2.new(0, 0, 0.7, 0)
    participantsLabel.BackgroundTransparency = 1
    participantsLabel.Text = "Racers: 0"
    participantsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    participantsLabel.TextScaled = true
    participantsLabel.Font = Enum.Font.Highway
    participantsLabel.Parent = raceHud
end

function RaceGui.showResults(results)
    if resultsGui then
        resultsGui:Destroy()
    end
    
    -- Results display
    resultsGui = Instance.new("Frame")
    resultsGui.Name = "ResultsGui"
    resultsGui.Size = UDim2.new(0.5, 0, 0.6, 0)
    resultsGui.Position = UDim2.new(0.5, 0, 0.5, 0)
    resultsGui.AnchorPoint = Vector2.new(0.5, 0.5)
    resultsGui.BackgroundColor3 = Color3.fromRGB(40, 35, 30)
    resultsGui.BorderSizePixel = 0
    resultsGui.Parent = raceScreenGui
    
    local resultsBorder = Instance.new("UIStroke")
    resultsBorder.Thickness = 2
    resultsBorder.Color = Color3.fromRGB(255, 140, 0)
    resultsBorder.Parent = resultsGui
    
    local resultsCorner = Instance.new("UICorner")
    resultsCorner.CornerRadius = UDim.new(0.02, 0)
    resultsCorner.Parent = resultsGui
    
    -- Results title
    local resultsTitle = Instance.new("TextLabel")
    resultsTitle.Size = UDim2.new(1, 0, 0.15, 0)
    resultsTitle.Position = UDim2.new(0, 0, 0, 0)
    resultsTitle.BackgroundTransparency = 1
    resultsTitle.Text = "🏁 RACE RESULTS"
    resultsTitle.TextColor3 = Color3.fromRGB(255, 140, 0)
    resultsTitle.TextScaled = true
    resultsTitle.Font = Enum.Font.Highway
    resultsTitle.Parent = resultsGui
    
    -- Results list
    local resultsList = Instance.new("ScrollingFrame")
    resultsList.Size = UDim2.new(0.9, 0, 0.7, 0)
    resultsList.Position = UDim2.new(0.05, 0, 0.2, 0)
    resultsList.BackgroundColor3 = Color3.fromRGB(30, 25, 20)
    resultsList.BorderSizePixel = 0
    resultsList.ScrollBarThickness = 8
    resultsList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    resultsList.Parent = resultsGui
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0.02, 0)
    listCorner.Parent = resultsList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = resultsList
    
    -- Display results
    local medals = {"🥇", "🥈", "🥉"}
    for i, result in ipairs(results) do
        local resultFrame = Instance.new("Frame")
        resultFrame.Size = UDim2.new(1, 0, 0, 40)
        resultFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        resultFrame.BorderSizePixel = 0
        resultFrame.LayoutOrder = i
        resultFrame.Parent = resultsList
        
        local resultCorner = Instance.new("UICorner")
        resultCorner.CornerRadius = UDim.new(0.05, 0)
        resultCorner.Parent = resultFrame
        
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, 0, 1, 0)
        resultLabel.BackgroundTransparency = 1
        resultLabel.Text = (medals[i] or (i .. ".")) .. " " .. result.player.Name
        resultLabel.TextColor3 = i <= 3 and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(255, 255, 255)
        resultLabel.TextScaled = true
        resultLabel.Font = Enum.Font.Highway
        resultLabel.Parent = resultFrame
    end
    
    -- Update canvas size
    resultsList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.3, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "CLOSE"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.Highway
    closeButton.Parent = resultsGui
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.05, 0)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        RaceGui.hideAllGuis()
    end)
    
    -- Auto close after 10 seconds
    spawn(function()
        wait(10)
        RaceGui.hideAllGuis()
    end)
end

function RaceGui.hideAllGuis()
    if raceScreenGui then
        raceScreenGui:Destroy()
        raceScreenGui = nil
        joinPrompt = nil
        raceHud = nil
        resultsGui = nil
    end
end

function RaceGui.updateCountdown(timeLeft, participants)
    if joinPrompt then
        local countdownLabel = joinPrompt:FindFirstChild("CountdownLabel")
        if countdownLabel then
            countdownLabel.Text = "Time to join: " .. timeLeft .. "s | Racers: " .. participants
        end
    end
end

function RaceGui.createStartCountdown()
    -- Only show to players who joined the race
    if not playerJoinedRace then return end
    
    -- Start countdown display (5-second countdown before race begins)
    local startCountdown = Instance.new("Frame")
    startCountdown.Name = "StartCountdown"
    startCountdown.Size = UDim2.new(0.3, 0, 0.15, 0)
    startCountdown.Position = UDim2.new(0.5, 0, 0.4, 0)
    startCountdown.AnchorPoint = Vector2.new(0.5, 0.5)
    startCountdown.BackgroundColor3 = Color3.fromRGB(40, 35, 30)
    startCountdown.BorderSizePixel = 0
    startCountdown.Parent = raceScreenGui
    
    local countdownBorder = Instance.new("UIStroke")
    countdownBorder.Thickness = 2
    countdownBorder.Color = Color3.fromRGB(255, 140, 0)
    countdownBorder.Parent = startCountdown
    
    local countdownCorner = Instance.new("UICorner")
    countdownCorner.CornerRadius = UDim.new(0.02, 0)
    countdownCorner.Parent = startCountdown
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🏁 GET READY!"
    titleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.Highway
    titleLabel.Parent = startCountdown
    
    -- Countdown number
    local countdownNumber = Instance.new("TextLabel")
    countdownNumber.Name = "CountdownNumber"
    countdownNumber.Size = UDim2.new(1, 0, 0.6, 0)
    countdownNumber.Position = UDim2.new(0, 0, 0.4, 0)
    countdownNumber.BackgroundTransparency = 1
    countdownNumber.Text = "5"
    countdownNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
    countdownNumber.TextScaled = true
    countdownNumber.Font = Enum.Font.Highway
    countdownNumber.Parent = startCountdown
end

function RaceGui.updateStartCountdown(timeLeft, isGo)
    -- Only update for players who joined the race
    if not playerJoinedRace then return end
    
    if raceScreenGui then
        local startCountdown = raceScreenGui:FindFirstChild("StartCountdown")
        if startCountdown then
            local countdownNumber = startCountdown:FindFirstChild("CountdownNumber")
            if countdownNumber then
                if isGo or timeLeft == 0 then
                    countdownNumber.Text = "GO!"
                    countdownNumber.TextColor3 = Color3.fromRGB(0, 255, 0)
                    -- Make GO! bigger and more dramatic
                    countdownNumber.TextStrokeTransparency = 0
                    countdownNumber.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                else
                    countdownNumber.Text = tostring(timeLeft)
                    countdownNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

function RaceGui.updateRaceTimer(timeLeft, participants)
    -- Only update for players who joined the race
    if not playerJoinedRace then return end
    
    if raceHud then
        local timerLabel = raceHud:FindFirstChild("TimerLabel")
        local participantsLabel = raceHud:FindFirstChild("ParticipantsLabel")
        if timerLabel then
            timerLabel.Text = "Time: " .. timeLeft .. "s"
        end
        if participantsLabel then
            participantsLabel.Text = "Racers: " .. participants
        end
    end
end

function RaceGui.setupEventListeners()
    local raceUpdateEvent = ReplicatedStorage:WaitForChild("RaceUpdate", 10)
    if raceUpdateEvent then
        raceUpdateEvent.OnClientEvent:Connect(function(eventType, data)
            if eventType == "announcement" then
                RaceGui.createJoinPrompt()
                
            elseif eventType == "countdown" then
                RaceGui.updateCountdown(data.timeLeft, data.participants)
                
            elseif eventType == "raceStartCountdown" then
                if joinPrompt then joinPrompt:Destroy() end
                RaceGui.createStartCountdown()
                
            elseif eventType == "startCountdown" then
                RaceGui.updateStartCountdown(data.timeLeft, data.go)
                
            elseif eventType == "raceStart" then
                if raceScreenGui and raceScreenGui:FindFirstChild("StartCountdown") then
                    raceScreenGui.StartCountdown:Destroy()
                end
                RaceGui.createRaceHud()
                local statusLabel = raceHud:FindFirstChild("StatusLabel")
                local participantsLabel = raceHud:FindFirstChild("ParticipantsLabel")
                if statusLabel then statusLabel.Text = "🏁 RACE STARTED!" end
                if participantsLabel then participantsLabel.Text = "Racers: " .. #data.participants end
                
            elseif eventType == "raceTimer" then
                RaceGui.updateRaceTimer(data.timeLeft, data.participants)
                
            elseif eventType == "playerFinished" then
                -- Could add live finish notifications here
                
            elseif eventType == "raceEnd" then
                if raceHud then raceHud:Destroy() end
                RaceGui.showResults(data.results)
                
            elseif eventType == "cancelled" then
                RaceGui.hideAllGuis()
                
            elseif eventType == "joinResult" then
                if data.success then
                    playerJoinedRace = true -- Mark player as joined
                    if joinPrompt then
                        local joinButton = joinPrompt:FindFirstChild("JoinButton")
                        if joinButton then
                            joinButton.Text = "JOINED!"
                            joinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                            joinButton.Active = false
                        end
                    end
                end
                
            elseif eventType == "reward" then
                -- Show reward notification
                print("🏆 " .. data.message .. " Earned " .. data.coins .. " coins!")
            end
        end)
    end
end

-- Initialize when script loads
spawn(function()
    RaceGui.setupEventListeners()
end)

return RaceGui