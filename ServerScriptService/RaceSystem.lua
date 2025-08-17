local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RaceSystem = {}

-- Race configuration
local RACE_INTERVAL = 60 -- Race every 60 seconds
local RACE_LENGTH = 300 -- 300 studs long
local RACE_WIDTH = 50 -- 50 studs wide
local COUNTDOWN_TIME = 10 -- 10 seconds to join
local RACE_TIME_LIMIT = 30 -- 30 seconds to complete race

-- Race state
local isRaceActive = false
local isCountdownActive = false
local raceParticipants = {}
local raceResults = {}
local raceTrack = nil

-- Remote Events
local joinRaceEvent = Instance.new("RemoteEvent")
joinRaceEvent.Name = "JoinRace"
joinRaceEvent.Parent = ReplicatedStorage

local raceUpdateEvent = Instance.new("RemoteEvent")
raceUpdateEvent.Name = "RaceUpdate"
raceUpdateEvent.Parent = ReplicatedStorage

function RaceSystem.createRaceTrack()
    if raceTrack then
        raceTrack:Destroy()
    end
    
    -- Create race track folder
    raceTrack = Instance.new("Folder")
    raceTrack.Name = "RaceTrack"
    raceTrack.Parent = workspace
    
    -- Race track position (away from main map)
    local trackStartX = 500 -- Far from main game area
    local trackY = 10
    local trackZ = 0
    
    -- Create visible barrier to prevent early movement
    local barrier = Instance.new("Part")
    barrier.Name = "StartBarrier"
    barrier.Size = Vector3.new(RACE_WIDTH, 20, 3)
    barrier.Position = Vector3.new(trackStartX + (RACE_LENGTH/6), trackY + 10, trackZ) -- Same position as first yellow checkpoint
    barrier.Rotation = Vector3.new(0, 90, 0) -- Rotate 90 degrees
    barrier.Anchored = true
    barrier.CanCollide = true
    barrier.Material = Enum.Material.ForceField
    barrier.Color = Color3.fromRGB(255, 0, 0) -- Red barrier
    barrier.Transparency = 0.3 -- Semi-transparent so players can see it
    barrier.Parent = raceTrack
    
    -- Add barrier glow
    local barrierGlow = Instance.new("PointLight")
    barrierGlow.Color = Color3.fromRGB(255, 0, 0)
    barrierGlow.Brightness = 2
    barrierGlow.Range = 25
    barrierGlow.Parent = barrier
    
    -- Create starting line
    local startLine = Instance.new("Part")
    startLine.Name = "StartLine"
    startLine.Size = Vector3.new(RACE_WIDTH, 1, 5)
    startLine.Position = Vector3.new(trackStartX, trackY, trackZ)
    startLine.Anchored = true
    startLine.CanCollide = false
    startLine.Material = Enum.Material.Plastic
    startLine.Color = Color3.fromRGB(0, 255, 0) -- Green start line
    startLine.Transparency = 1 -- Invisible
    startLine.Parent = raceTrack
    
    -- Start line glow removed for cleaner look
    
    -- Create visible wall behind starting line to prevent falling off
    local startWall = Instance.new("Part")
    startWall.Name = "StartWall"
    startWall.Size = Vector3.new(RACE_WIDTH, 20, 3)
    startWall.Position = Vector3.new(trackStartX - 2, trackY + 10, trackZ)
    startWall.Rotation = Vector3.new(0, 90, 0) -- Rotate 90 degrees
    startWall.Anchored = true
    startWall.CanCollide = true
    startWall.Material = Enum.Material.Metal
    startWall.Color = Color3.fromRGB(100, 100, 100) -- Gray metal wall
    startWall.Parent = raceTrack
    
    -- Create finish line
    local finishLine = Instance.new("Part")
    finishLine.Name = "FinishLine"
    finishLine.Size = Vector3.new(RACE_WIDTH, 1, 5)
    finishLine.Position = Vector3.new(trackStartX + RACE_LENGTH, trackY, trackZ)
    finishLine.Anchored = true
    finishLine.CanCollide = false
    finishLine.Material = Enum.Material.Plastic
    finishLine.Color = Color3.fromRGB(255, 0, 0) -- Red finish line
    finishLine.Transparency = 1 -- Invisible
    finishLine.Parent = raceTrack
    
    -- Finish line glow removed for cleaner look
    
    -- Create end wall to stop players from running past
    local endWall = Instance.new("Part")
    endWall.Name = "EndWall"
    endWall.Size = Vector3.new(RACE_WIDTH, 20, 3)
    endWall.Position = Vector3.new(trackStartX + RACE_LENGTH + 2, trackY + 10, trackZ)
    endWall.Rotation = Vector3.new(0, 90, 0) -- Rotate 90 degrees
    endWall.Anchored = true
    endWall.CanCollide = true
    endWall.Material = Enum.Material.Metal
    endWall.Color = Color3.fromRGB(100, 100, 100) -- Gray metal wall
    endWall.Parent = raceTrack
    
    -- Create race ground
    local ground = Instance.new("Part")
    ground.Name = "RaceGround"
    ground.Size = Vector3.new(RACE_LENGTH, 1, RACE_WIDTH)
    ground.Position = Vector3.new(trackStartX + RACE_LENGTH/2, trackY - 1, trackZ)
    ground.Anchored = true
    ground.CanCollide = true
    ground.Material = Enum.Material.Asphalt
    ground.Color = Color3.fromRGB(64, 64, 64) -- Dark gray asphalt
    ground.Parent = raceTrack
    
    -- Create track barriers
    for i = 1, 2 do
        local barrier = Instance.new("Part")
        barrier.Name = "Barrier" .. i
        barrier.Size = Vector3.new(RACE_LENGTH, 10, 2)
        barrier.Position = Vector3.new(
            trackStartX + RACE_LENGTH/2, 
            trackY + 5, 
            trackZ + (i == 1 and RACE_WIDTH/2 + 1 or -RACE_WIDTH/2 - 1)
        )
        barrier.Anchored = true
        barrier.CanCollide = true
        barrier.Material = Enum.Material.Metal
        barrier.Color = Color3.fromRGB(255, 140, 0) -- Automotive amber
        barrier.Parent = raceTrack
    end
    
    -- Add checkpoint markers along the track
    for i = 1, 5 do
        local checkpoint = Instance.new("Part")
        checkpoint.Name = "Checkpoint" .. i
        checkpoint.Size = Vector3.new(2, 15, RACE_WIDTH)
        checkpoint.Position = Vector3.new(trackStartX + (i * RACE_LENGTH/6), trackY + 7, trackZ)
        checkpoint.Anchored = true
        checkpoint.CanCollide = false
        checkpoint.Material = Enum.Material.Plastic
        checkpoint.Color = Color3.fromRGB(255, 255, 0) -- Yellow checkpoints
        checkpoint.Transparency = 1 -- Invisible
        checkpoint.Parent = raceTrack
        
        -- Checkpoint glow removed for cleaner look
    end
    
    print("🏁 Race track created!")
end

function RaceSystem.teleportToStart(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local startX = 500 -- Match track start position
    local startY = 15 -- Above ground
    local startZ = math.random(-15, 15) -- Random position across start line
    
    player.Character.HumanoidRootPart.CFrame = CFrame.new(startX, startY, startZ)
    return true
end

function RaceSystem.announceRace()
    -- Send race announcement to all players
    raceUpdateEvent:FireAllClients("announcement", {
        message = "🏁 RACE STARTING IN " .. COUNTDOWN_TIME .. " SECONDS!",
        countdown = COUNTDOWN_TIME
    })
    
    print("🏁 Race announced! Countdown: " .. COUNTDOWN_TIME .. " seconds")
end

function RaceSystem.startCountdown()
    isCountdownActive = true
    raceParticipants = {}
    
    RaceSystem.announceRace()
    
    -- Join countdown loop
    for i = COUNTDOWN_TIME, 1, -1 do
        wait(1)
        raceUpdateEvent:FireAllClients("countdown", {
            timeLeft = i,
            participants = #raceParticipants
        })
    end
    
    isCountdownActive = false
    
    if #raceParticipants > 0 then
        -- 5-second race start countdown
        raceUpdateEvent:FireAllClients("raceStartCountdown", {
            participants = raceParticipants
        })
        
        for i = 5, 1, -1 do
            wait(1)
            raceUpdateEvent:FireAllClients("startCountdown", {
                timeLeft = i
            })
        end
        
        -- Show GO! message
        raceUpdateEvent:FireAllClients("startCountdown", {
            timeLeft = 0,
            go = true
        })
        wait(1)
        
        -- Change barrier to green and make it passable
        local barrier = raceTrack:FindFirstChild("StartBarrier")
        if barrier then
            barrier.CanCollide = false -- Allow players through
            barrier.Color = Color3.fromRGB(0, 255, 0) -- Change to green
            local barrierGlow = barrier:FindFirstChild("PointLight")
            if barrierGlow then
                barrierGlow.Color = Color3.fromRGB(0, 255, 0) -- Green glow
            end
        end
        
        RaceSystem.startRace()
    else
        print("🏁 No participants joined the race")
        raceUpdateEvent:FireAllClients("cancelled", {message = "Race cancelled - no participants"})
    end
end

function RaceSystem.startRace()
    if #raceParticipants == 0 then return end
    
    isRaceActive = true
    raceResults = {}
    
    print("🏁 Race started with " .. #raceParticipants .. " participants!")
    
    -- Notify all participants race has started
    raceUpdateEvent:FireAllClients("raceStart", {
        participants = raceParticipants,
        timeLimit = RACE_TIME_LIMIT
    })
    
    -- Set up finish line detection
    local finishLine = raceTrack:FindFirstChild("FinishLine")
    if finishLine then
        local connection
        connection = finishLine.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local player = Players:GetPlayerFromCharacter(hit.Parent)
                if player and table.find(raceParticipants, player) then
                    RaceSystem.playerFinished(player)
                end
            end
        end)
        
        -- Clean up connection after race
        spawn(function()
            wait(RACE_TIME_LIMIT + 5)
            if connection then
                connection:Disconnect()
            end
        end)
    end
    
    -- Race timer with countdown updates
    spawn(function()
        for timeLeft = RACE_TIME_LIMIT, 1, -1 do
            wait(1)
            raceUpdateEvent:FireAllClients("raceTimer", {
                timeLeft = timeLeft,
                participants = #raceParticipants
            })
        end
        RaceSystem.endRace()
    end)
end

function RaceSystem.playerFinished(player)
    -- Check if player already finished
    for _, result in ipairs(raceResults) do
        if result.player == player then
            return -- Already finished
        end
    end
    
    local position = #raceResults + 1
    table.insert(raceResults, {
        player = player,
        position = position,
        finishTime = tick()
    })
    
    print("🏁 " .. player.Name .. " finished in position " .. position)
    
    -- Notify all players of finish
    raceUpdateEvent:FireAllClients("playerFinished", {
        playerName = player.Name,
        position = position
    })
    
    -- End race if all participants finished
    if #raceResults >= #raceParticipants then
        RaceSystem.endRace()
    end
end

function RaceSystem.endRace()
    if not isRaceActive then return end
    
    isRaceActive = false
    
    print("🏁 Race ended! Results:")
    
    -- Display results
    for i, result in ipairs(raceResults) do
        print(i .. ". " .. result.player.Name)
    end
    
    -- Give rewards (placeholder for now)
    RaceSystem.giveRewards()
    
    -- Send final results to all players
    raceUpdateEvent:FireAllClients("raceEnd", {
        results = raceResults
    })
    
    -- Reset barrier to red and solid for next race
    local barrier = raceTrack:FindFirstChild("StartBarrier")
    if barrier then
        barrier.CanCollide = true -- Block players again
        barrier.Color = Color3.fromRGB(255, 0, 0) -- Back to red
        local barrierGlow = barrier:FindFirstChild("PointLight")
        if barrierGlow then
            barrierGlow.Color = Color3.fromRGB(255, 0, 0) -- Red glow
        end
    end
    
    -- Teleport participants back to main area
    spawn(function()
        wait(5) -- Let them see results
        for _, player in ipairs(raceParticipants) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0) -- Main spawn area
            end
        end
    end)
end

function RaceSystem.giveRewards()
    -- Placeholder reward system - can be expanded later
    local rewards = {
        [1] = {coins = 1000, message = "🥇 1st Place!"},
        [2] = {coins = 500, message = "🥈 2nd Place!"},
        [3] = {coins = 250, message = "🥉 3rd Place!"}
    }
    
    for i, result in ipairs(raceResults) do
        if i <= 3 and rewards[i] then
            -- Give rewards (integrate with your coin system)
            local leaderstats = result.player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("Coins") then
                leaderstats.Coins.Value = leaderstats.Coins.Value + rewards[i].coins
            end
            
            -- Send reward notification
            raceUpdateEvent:FireClient(result.player, "reward", {
                message = rewards[i].message,
                coins = rewards[i].coins
            })
        end
    end
end

function RaceSystem.joinRace(player)
    if not isCountdownActive then
        return false, "No race currently accepting participants"
    end
    
    -- Check if already joined
    if table.find(raceParticipants, player) then
        return false, "Already joined this race"
    end
    
    -- Teleport to starting line
    if not RaceSystem.teleportToStart(player) then
        return false, "Failed to teleport to race"
    end
    
    table.insert(raceParticipants, player)
    print("🏁 " .. player.Name .. " joined the race! (" .. #raceParticipants .. " total)")
    
    return true, "Successfully joined race!"
end

function RaceSystem.startRaceLoop()
    print("🏁 Race system started! Races every " .. RACE_INTERVAL .. " seconds")
    
    spawn(function()
        while true do
            wait(RACE_INTERVAL)
            
            if not isRaceActive and not isCountdownActive then
                spawn(function()
                    RaceSystem.startCountdown()
                end)
            end
        end
    end)
end

-- Event handlers
joinRaceEvent.OnServerEvent:Connect(function(player)
    local success, message = RaceSystem.joinRace(player)
    raceUpdateEvent:FireClient(player, "joinResult", {
        success = success,
        message = message
    })
end)

function RaceSystem.start()
    -- Create the race track
    RaceSystem.createRaceTrack()
    
    -- Start the race loop
    RaceSystem.startRaceLoop()
    
    print("🏁 Race System initialized!")
end

return RaceSystem