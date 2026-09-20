local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Workspace = workspace
local getgenv = getgenv or function() return _G end
local Global = getgenv()

Global.AutoArrestActive = Global.AutoArrestActive ~= false

local Config = {
    ascentHeight = 500,
    returnAltitude = 50,
    spawnDisplacement = 300,
    rememberedVehicleMaxDistance = 500,
    vehicleInteractionDistance = 15,
    ejectSearchDistance = 25,
    targetEngagementDistance = 20,
    targetHorizontalTolerance = 8,
    targetVerticalDistance = 10,
    pathDelay = 0.2,
    vehicleEntryTimeout = 8,
    vehicleFindTimeout = 6,
    arrestTimeout = 5,
    handcuffWaitTimeout = 8,
    tirePopTimeout = 6,
    targetApproachTimeout = 15,
    horizontalFlightTimeout = 20,
    flightStep = 0.05,
    flightSpeed = 95,
    ascentSpeed = 90,
    descentSpeed = 65,
    approachSpeed = 90,
    returnSpeed = 95,
    flightResponsiveness = 1500000000,
    flightDamping = 50000,
    obstacleLookAhead = 55,
    obstacleUpDownCheck = 35,
    obstacleRadius = 4,
    tpOffset = CFrame.new(0, 2.5, -5),
    aircraftKeywords = {
        "heli",
        "helicopter",
        "ufo",
        "blackhawk",
        "drone",
        "blimp"
    }
}

local PoliceData = {
    ["Custom Main Station Path"] = {
        Base = Vector3.new(-1173.24,39.42,-1583.77),
        Path = {
            Vector3.new(-1173.24,39.42,-1583.77),
            Vector3.new(-1177.93,39.42,-1580.66),
            Vector3.new(-1184.32,39.42,-1575.63),
            Vector3.new(-1188.49,39.42,-1568.75),
            Vector3.new(-1187.33,39.42,-1560.60),
            Vector3.new(-1184.78,39.42,-1552.89),
            Vector3.new(-1182.62,39.42,-1546.72),
            Vector3.new(-1175.61,34.97,-1546.03),
            Vector3.new(-1168.76,30.16,-1546.55),
            Vector3.new(-1161.44,27.15,-1547.99),
            Vector3.new(-1156.07,23.25,-1551.89),
            Vector3.new(-1154.36,21.12,-1559.06),
            Vector3.new(-1157.26,19.07,-1566.29),
            Vector3.new(-1162.58,19.02,-1572.38),
            Vector3.new(-1169.74,19.02,-1576.19),
            Vector3.new(-1177.62,19.02,-1578.67),
            Vector3.new(-1185.61,19.07,-1580.14),
            Vector3.new(-1193.86,19.07,-1580.63),
            Vector3.new(-1201.85,19.07,-1580.43),
            Vector3.new(-1209.98,19.07,-1580.09),
            Vector3.new(-1218.11,19.07,-1580.18),
            Vector3.new(-1226.36,19.07,-1579.78),
            Vector3.new(-1234.43,19.02,-1578.75),
            Vector3.new(-1239.75,19.07,-1573.05),
            Vector3.new(-1243.11,19.07,-1565.64),
            Vector3.new(-1248.50,19.02,-1559.53),
            Vector3.new(-1256.50,19.02,-1558.65),
            Vector3.new(-1262.43,19.02,-1554.62),
            Vector3.new(-1259.15,18.71,-1549.22),
            Vector3.new(-1251.26,18.62,-1547.54),
            Vector3.new(-1244.88,18.62,-1546.87)
        }
    },
    ["Fourth Station"] = {
        Base = Vector3.new(1786.66,24.05,-4019.01),
        Path = {
            Vector3.new(1762.26,24.00,-4024.93),
            Vector3.new(1765.20,24.02,-4026.29),
            Vector3.new(1772.61,24.05,-4029.64),
            Vector3.new(1779.17,24.00,-4034.16),
            Vector3.new(1785.04,24.00,-4040.16),
            Vector3.new(1790.33,24.25,-4046.51),
            Vector3.new(1792.76,24.50,-4049.68),
            Vector3.new(1793.25,24.50,-4053.24),
            Vector3.new(1790.91,24.09,-4061.18),
            Vector3.new(1786.38,24.10,-4068.25),
            Vector3.new(1784.77,24.10,-4076.59),
            Vector3.new(1781.65,23.80,-4084.53),
            Vector3.new(1778.85,23.80,-4092.15),
            Vector3.new(1778.73,23.80,-4093.07)
        }
    },
    ["Main Police Station Ground"] = {
        Base = Vector3.new(-1171.10,18.80,-1579.22),
        Path = {
            Vector3.new(-1142.16,18.85,-1586.02),
            Vector3.new(-1146.80,18.85,-1585.55),
            Vector3.new(-1155.16,18.85,-1584.71),
            Vector3.new(-1163.53,18.85,-1583.90),
            Vector3.new(-1171.65,18.85,-1583.56),
            Vector3.new(-1179.64,18.85,-1583.26),
            Vector3.new(-1188.04,18.85,-1582.97),
            Vector3.new(-1196.30,18.85,-1582.68),
            Vector3.new(-1204.70,18.85,-1582.39),
            Vector3.new(-1212.83,18.85,-1582.11),
            Vector3.new(-1220.96,18.85,-1581.82),
            Vector3.new(-1229.09,18.85,-1581.42),
            Vector3.new(-1236.90,18.80,-1579.45),
            Vector3.new(-1241.89,18.85,-1573.22),
            Vector3.new(-1244.30,18.85,-1565.59),
            Vector3.new(-1249.61,18.80,-1559.48),
            Vector3.new(-1257.60,18.80,-1559.35),
            Vector3.new(-1263.00,18.79,-1555.37),
            Vector3.new(-1260.26,18.40,-1547.61),
            Vector3.new(-1252.41,18.40,-1546.17),
            Vector3.new(-1244.15,18.40,-1546.12),
            Vector3.new(-1244.08,18.40,-1546.12)
        }
    },
    ["Museum Police Station"] = {
        Base = Vector3.new(738.20,44.96,1120.53),
        Path = {
            Vector3.new(732.75,44.96,1125.10),
            Vector3.new(733.10,44.96,1122.05),
            Vector3.new(733.02,44.96,1113.69),
            Vector3.new(731.74,44.96,1105.80),
            Vector3.new(730.05,44.96,1097.57),
            Vector3.new(728.25,44.95,1089.37),
            Vector3.new(730.33,44.94,1081.29),
            Vector3.new(735.58,44.37,1075.00),
            Vector3.new(741.75,44.77,1069.30),
            Vector3.new(744.70,44.96,1066.60)
        }
    },
    ["Military Base"] = {
        Base = Vector3.new(1801.00,25.54,-891.02),
        Path = {
            Vector3.new(1805.17,25.54,-900.65),
            Vector3.new(1805.17,25.54,-900.65),
            Vector3.new(1799.38,25.54,-901.80),
            Vector3.new(1791.31,25.57,-902.75),
            Vector3.new(1783.10,25.60,-903.71),
            Vector3.new(1775.02,25.54,-904.70),
            Vector3.new(1766.97,25.54,-905.80),
            Vector3.new(1758.94,25.54,-907.13),
            Vector3.new(1753.12,25.54,-908.27),
            Vector3.new(1753.12,25.54,-908.27)
        }
    },
    ["Fifth Station"] = {
        Base = Vector3.new(1822.10,25.55,-636.60),
        Path = {
            Vector3.new(1820.55,25.54,-607.59),
            Vector3.new(1822.75,25.54,-616.20),
            Vector3.new(1827.02,25.54,-623.28),
            Vector3.new(1831.25,25.54,-630.38),
            Vector3.new(1835.55,25.08,-637.60),
            Vector3.new(1844.01,25.00,-651.80),
            Vector3.new(1848.31,25.00,-659.02)
        }
    }
}

local State = {
    INITIALIZING = "INITIALIZING",
    EXITING_BUILDING = "EXITING_BUILDING",
    FINDING_VEHICLE = "FINDING_VEHICLE",
    ENTERING_VEHICLE = "ENTERING_VEHICLE",
    VERIFYING_VEHICLE = "VERIFYING_VEHICLE",
    ASCENDING = "ASCENDING",
    SEARCHING_TARGET = "SEARCHING_TARGET",
    APPROACHING_TARGET = "APPROACHING_TARGET",
    TIRE_POP = "TIRE_POP",
    EJECTING_TARGET = "EJECTING_TARGET",
    ARRESTING_TARGET = "ARRESTING_TARGET",
    WAITING_FOR_HANDCUFF = "WAITING_FOR_HANDCUFF",
    RETURNING_TO_VEHICLE = "RETURNING_TO_VEHICLE",
    SPAWNING_VEHICLE = "SPAWNING_VEHICLE",
    RESETTING = "RESETTING",
    DEAD = "DEAD",
    STOPPED = "STOPPED"
}

local Session = {
    id = 0,
    character = nil,
    humanoid = nil,
    root = nil,
    state = State.STOPPED,
    cancelled = true,
    vehicleEntered = false,
    currentVehicle = nil,
    rememberedCar = nil,
    selectedTarget = nil,
    selectedTargetCharacter = nil,
    selectedTargetRoot = nil,
    flightActive = false,
    bodyGyro = nil,
    bodyVelocity = nil,
    flightConnection = nil,
    connections = {},
    targetConnections = {},
    vehicleMemoryTask = nil,
    flightToken = 0
}

local arrestedBlacklist = Global.__AutoArrestBlacklist or {}
Global.__AutoArrestBlacklist = arrestedBlacklist
Global.GetMyCar = function()
    return Session.rememberedCar
end

local function addConnection(bucket, connection)
    if connection then
        table.insert(bucket, connection)
    end
    return connection
end

local function disconnectBucket(bucket)
    for i = #bucket, 1, -1 do
        local c = bucket[i]
        bucket[i] = nil
        if c then
            pcall(function() c:Disconnect() end)
        end
    end
end

local function validSession(sessionId, character)
    return Global.AutoArrestActive
        and Session.id == sessionId
        and not Session.cancelled
        and Session.character
        and Session.character == character
        and Session.character == LocalPlayer.Character
end

local function isAlive(character, humanoid)
    if not character or not character.Parent then
        return false
    end
    humanoid = humanoid or character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    return root ~= nil and root.Parent ~= nil
end

local function getCharacterState()
    local character = LocalPlayer.Character
    if not character then
        return nil, nil, nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    return character, humanoid, root
end

local function setState(newState, sessionId)
    if sessionId and Session.id ~= sessionId then
        return
    end
    Session.state = newState
end

local function findModule(path)
    local obj = ReplicatedStorage
    for part in string.gmatch(path, "[^%.]+") do
        obj = obj and obj:FindFirstChild(part)
        if not obj then
            return nil
        end
    end
    return obj
end

local VehicleUtils
local UISource
local CircleActionSpecs

do
    local mod = findModule("Vehicle.VehicleUtils")
    if mod and mod:IsA("ModuleScript") then
        pcall(function()
            VehicleUtils = require(mod)
        end)
    end
    local ui = findModule("Module.UI")
    if ui and ui:IsA("ModuleScript") then
        pcall(function()
            UISource = require(ui)
            if UISource and UISource.CircleAction then
                CircleActionSpecs = UISource.CircleAction.Specs
            end
        end)
    end
end

local InventorySystem
do
    local mod = ReplicatedStorage:FindFirstChild("Inventory")
    mod = mod and mod:FindFirstChild("InventoryItemSystem")
    if mod and mod:IsA("ModuleScript") then
        pcall(function()
            InventorySystem = require(mod)
        end)
    end
end

local attemptArrest
local function discoverArrestFunction()
    attemptArrest = nil
    local gc = rawget(_G, "getgc")
    local isLClosure = rawget(_G, "islclosure")
    local getInfo = rawget(_G, "getinfo")
    if not gc or not isLClosure or not getInfo then
        return nil
    end
    local ok, objects = pcall(function()
        return gc(true)
    end)
    if not ok or type(objects) ~= "table" then
        return nil
    end
    for _, v in pairs(objects) do
        if type(v) == "function" then
            local lok = false
            pcall(function()
                lok = isLClosure(v)
            end)
            if lok then
                local name
                pcall(function()
                    local info = getInfo(v)
                    name = info and info.name
                end)
                if tostring(name) == "AttemptArrest" then
                    attemptArrest = v
                    break
                end
            end
        end
    end
    return attemptArrest
end

local function safeCharacter()
    local c, h, r = getCharacterState()
    if c ~= Session.character or h ~= Session.humanoid or r ~= Session.root then
        return false
    end
    return isAlive(c, h)
end

local function getSeat(vehicle)
    if not vehicle or not vehicle.Parent then
        return nil
    end
    return vehicle:FindFirstChild("Seat")
        or vehicle:FindFirstChild("VehicleSeat")
        or vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        or vehicle:FindFirstChildWhichIsA("Seat", true)
end

local function isVehicleValid(vehicle, requireUsableSeat)
    if not vehicle or not vehicle.Parent then
        return false
    end
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if vehicles and not vehicle:IsDescendantOf(vehicles) then
        return false
    end
    local seat = getSeat(vehicle)
    if not seat or not seat.Parent then
        return false
    end
    if requireUsableSeat and seat.Occupant then
        return false
    end
    return true
end

local function isVehicleOccupiedByLocal(vehicle)
    local seat = getSeat(vehicle)
    return seat and seat.Occupant == Session.humanoid
end

local function findVehicleFromSeat(seat)
    if not seat then
        return nil
    end
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then
        return nil
    end
    local current = seat
    while current and current ~= vehicles do
        if current.Parent == vehicles then
            return current
        end
        current = current.Parent
    end
    return nil
end

local function getLocalVehicle()
    if VehicleUtils and type(VehicleUtils.GetLocalVehicleModel) == "function" then
        local ok, m = pcall(VehicleUtils.GetLocalVehicleModel)
        if ok and m and m ~= false and m ~= "" then
            if typeof(m) == "Instance" then
                return m
            end
            local found = Workspace:FindFirstChild(tostring(m), true)
            if found then
                return found
            end
        end
    end
    local h = Session.humanoid
    if h and h.SeatPart then
        return findVehicleFromSeat(h.SeatPart)
    end
    return nil
end

local function updateRememberedVehicle()
    if not safeCharacter() then
        return
    end
    local car = getLocalVehicle()
    if car and isVehicleValid(car, false) and isVehicleOccupiedByLocal(car) then
        Session.rememberedCar = car
        Session.currentVehicle = car
        Session.vehicleEntered = true
    end
end

local function startVehicleMemory(sessionId)
    if Session.vehicleMemoryTask then
        return
    end
    Session.vehicleMemoryTask = task.spawn(function()
        while validSession(sessionId, Session.character) do
            updateRememberedVehicle()
            task.wait(0.5)
        end
        Session.vehicleMemoryTask = nil
    end)
end

local function selectedTargetValid()
    local player = Session.selectedTarget
    local character = Session.selectedTargetCharacter
    local root = Session.selectedTargetRoot
    if not player or player == LocalPlayer then
        return false
    end
    if not player.Parent or player ~= Players:FindFirstChild(player.Name) then
        return false
    end
    if not character or not character.Parent then
        return false
    end
    if player.Character ~= character then
        return false
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    if not root or not root.Parent or root ~= character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    if player.Team == nil or player.Team.Name ~= "Criminal" then
        return false
    end
    if arrestedBlacklist[player] then
        return false
    end
    return true
end

local function clearTarget()
    disconnectBucket(Session.targetConnections)
    Session.selectedTarget = nil
    Session.selectedTargetCharacter = nil
    Session.selectedTargetRoot = nil
end

local function getTargetVehicle(player)
    if not player or not player.Character then
        return nil
    end
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then
        return nil
    end

    if humanoid and humanoid.SeatPart then
        local vehicle = findVehicleFromSeat(humanoid.SeatPart)
        if vehicle then
            return vehicle
        end
    end

    for _, vehicle in ipairs(vehicles:GetChildren()) do
        local seat = getSeat(vehicle)
        if seat and root and (seat.Position - root.Position).Magnitude <= Config.targetEngagementDistance then
            local occupant = seat.Occupant
            if occupant == humanoid then
                return vehicle
            end
        end
    end

    for _, vehicle in ipairs(vehicles:GetChildren()) do
        local seat = getSeat(vehicle)
        if seat and root and (seat.Position - root.Position).Magnitude <= 5 then
            return vehicle
        end
    end

    return nil
end

local function isAircraftVehicle(vehicle)
    if not vehicle then
        return false
    end
    local text = string.lower(vehicle.Name)
    for _, keyword in ipairs(Config.aircraftKeywords) do
        if string.find(text, string.lower(keyword), 1, true) then
            return true
        end
    end
    return false
end

local function targetCanBeSelected(player)
    if player == LocalPlayer or not player.Parent or arrestedBlacklist[player] then
        return false
    end
    if not player.Character then
        return false
    end
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not root then
        return false
    end
    if not player.Team or player.Team.Name ~= "Criminal" then
        return false
    end
    local targetVehicle = getTargetVehicle(player)
    if targetVehicle and isAircraftVehicle(targetVehicle) then
        return false
    end
    return true
end

local function selectNearestTarget(sessionId)
    if not validSession(sessionId, Session.character) or not safeCharacter() then
        return nil
    end
    local root = Session.root
    local nearest
    local nearestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if targetCanBeSelected(player) then
            local tr = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local distance = (tr.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearest = player
                end
            end
        end
    end

    if nearest then
        Session.selectedTarget = nearest
        Session.selectedTargetCharacter = nearest.Character
        Session.selectedTargetRoot = nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart")
        disconnectBucket(Session.targetConnections)
        addConnection(Session.targetConnections, nearest.CharacterAdded:Connect(function()
            if Session.selectedTarget == nearest then
                clearTarget()
            end
        end))
        addConnection(Session.targetConnections, nearest:GetPropertyChangedSignal("Team"):Connect(function()
            if Session.selectedTarget == nearest and (not nearest.Team or nearest.Team.Name ~= "Criminal") then
                clearTarget()
            end
        end))
        return nearest
    end

    return nil
end

local function getCircleSpecs()
    if CircleActionSpecs then
        return CircleActionSpecs
    end
    if UISource and UISource.CircleAction then
        CircleActionSpecs = UISource.CircleAction.Specs
    end
    return CircleActionSpecs
end

local function triggerVehicleInteraction(vehicle)
    if not vehicle or not vehicle.Parent then
        return false
    end
    local seat = getSeat(vehicle)
    if not seat then
        return false
    end

    local specs = getCircleSpecs()
    if not specs then
        return false
    end

    for _, spec in pairs(specs) do
        if spec.Part and (spec.Part == seat or spec.Part:IsDescendantOf(vehicle) or vehicle:IsAncestorOf(spec.Part)) then
            local ok = pcall(function()
                spec:Callback(true)
            end)
            if ok then
                return true
            end
        end
    end
    return false
end

local function findNearestUsableVehicle()
    if not safeCharacter() then
        return nil
    end
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then
        return nil
    end
    local nearest
    local nearestDistance = math.huge
    for _, vehicle in ipairs(vehicles:GetChildren()) do
        if isVehicleValid(vehicle, true) then
            local seat = getSeat(vehicle)
            if seat then
                local d = (Session.root.Position - seat.Position).Magnitude
                if d <= Config.vehicleInteractionDistance and d < nearestDistance then
                    nearestDistance = d
                    nearest = vehicle
                end
            end
        end
    end
    return nearest
end

local function waitForVehicleEntry(sessionId, vehicle)
    local start = os.clock()
    while validSession(sessionId, Session.character) and safeCharacter() and os.clock() - start < Config.vehicleEntryTimeout do
        local char = Session.character
        local hum = Session.humanoid
        if char:GetAttribute("InVehicle") == true or (hum and hum.SeatPart ~= nil) then
            local actual = getLocalVehicle()
            if actual then
                Session.currentVehicle = actual
                Session.rememberedCar = actual
            else
                Session.currentVehicle = vehicle
                Session.rememberedCar = vehicle
            end
            Session.vehicleEntered = true
            return true
        end
        task.wait(0.1)
    end
    Session.vehicleEntered = false
    return false
end

local function enterVehicle(sessionId, vehicle)
    if not isVehicleValid(vehicle, true) then
        return false
    end
    triggerVehicleInteraction(vehicle)
    return waitForVehicleEntry(sessionId, vehicle)
end

local function pressSpace()
    local success = false
    local kp = rawget(_G, "keypress")
    local kr = rawget(_G, "keyrelease")
    if kp and kr then
        pcall(function()
            kp(0x20)
            task.wait(0.05)
            kr(0x20)
            success = true
        end)
    end
    if not success then
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            success = true
        end)
    end
    if Session.humanoid then
        pcall(function()
            Session.humanoid.Jump = true
        end)
    end
    return success
end

local function cleanupFlight()
    Session.flightToken += 1
    Session.flightActive = false
    Session.vehicleEntered = Session.vehicleEntered and Session.humanoid and Session.humanoid.SeatPart ~= nil or false

    if Session.flightConnection then
        pcall(function() Session.flightConnection:Disconnect() end)
        Session.flightConnection = nil
    end

    if Session.bodyGyro then
        pcall(function() Session.bodyGyro:Destroy() end)
        Session.bodyGyro = nil
    end

    if Session.bodyVelocity then
        pcall(function() Session.bodyVelocity:Destroy() end)
        Session.bodyVelocity = nil
    end

    local camera = Workspace.CurrentCamera
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
        end)
    end
end

local function obstacleDetected(origin, direction, ignoreList)
    if direction.Magnitude <= 0 then
        return false
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList or {Session.character, Session.currentVehicle}
    params.IgnoreWater = false

    local result = Workspace:Raycast(origin, direction, params)
    if not result then
        return false
    end

    if result.Instance and result.Instance:IsDescendantOf(Session.character) then
        return false
    end

    if Session.currentVehicle and result.Instance and result.Instance:IsDescendantOf(Session.currentVehicle) then
        return false
    end

    return true
end

local function flightObstacleCheck(moveVector)
    if not Session.root then
        return true
    end

    local pos = Session.root.Position
    local horizontal = Vector3.new(moveVector.X, 0, moveVector.Z)
    local ahead = horizontal.Magnitude > 0 and horizontal.Unit * math.min(Config.obstacleLookAhead, math.max(20, horizontal.Magnitude)) or Vector3.zero

    if ahead.Magnitude > 0 and obstacleDetected(pos, ahead, {Session.character, Session.currentVehicle}) then
        return true
    end

    if moveVector.Y > 0 and obstacleDetected(pos, Vector3.new(0, math.min(Config.obstacleUpDownCheck, math.max(10, moveVector.Y)), 0), {Session.character, Session.currentVehicle}) then
        return true
    end

    if moveVector.Y < 0 and obstacleDetected(pos, Vector3.new(0, -math.min(Config.obstacleUpDownCheck, math.max(10, math.abs(moveVector.Y))), 0), {Session.character, Session.currentVehicle}) then
        return true
    end

    return false
end

local function createFlightControllers()
    cleanupFlight()
    if not safeCharacter() then
        return false
    end

    local root = Session.root
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")

    bodyGyro.Name = "AutoArrestFlightGyro"
    bodyVelocity.Name = "AutoArrestFlightVelocity"
    bodyGyro.Parent = root
    bodyVelocity.Parent = root

    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.D = Config.flightResponsiveness == 0 and Config.flightDamping or Config.flightDamping
    bodyGyro.P = Config.flightResponsiveness

    Session.bodyGyro = bodyGyro
    Session.bodyVelocity = bodyVelocity
    Session.flightActive = true
    Session.flightToken += 1

    local camera = Workspace.CurrentCamera
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Track
        end)
    end

    return true
end

local function setFlightMovement(direction, speed, sessionId)
    if not validSession(sessionId, Session.character) or not safeCharacter() then
        return false
    end
    if not Session.flightActive or not Session.bodyVelocity or not Session.bodyGyro then
        return false
    end

    local camera = Workspace.CurrentCamera
    if not camera then
        return false
    end

    local dir = direction
    if dir.Magnitude > 1 then
        dir = dir.Unit
    end

    if flightObstacleCheck(dir * speed) then
        return false, true
    end

    local gyroCFrame
    if dir.Magnitude > 0.05 then
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude > 0 then
            gyroCFrame = CFrame.lookAt(Session.root.Position, Session.root.Position + flat.Unit)
        else
            gyroCFrame = camera.CFrame
        end
    else
        gyroCFrame = camera.CFrame
    end

    Session.bodyGyro.CFrame = gyroCFrame
    Session.bodyVelocity.Velocity = dir * speed
    return true, false
end

local function automatedFlightTo(sessionId, destination, speed, tolerance, timeout, maintainY, allowVertical)
    if not createFlightControllers() then
        return false, true
    end

    local started = os.clock()
    local token = Session.flightToken
    local ok = true
    local obstacle = false

    while validSession(sessionId, Session.character) and safeCharacter() and Session.flightActive and Session.flightToken == token do
        if os.clock() - started > timeout then
            ok = false
            break
        end

        local position = Session.root.Position
        local target = destination

        if maintainY then
            target = Vector3.new(destination.X, position.Y, destination.Z)
        end

        local delta = target - position
        if delta.Magnitude <= tolerance then
            break
        end

        if not allowVertical then
            delta = Vector3.new(delta.X, 0, delta.Z)
        end

        local direction = delta.Magnitude > 0 and delta.Unit or Vector3.zero
        local moved, hit = setFlightMovement(direction, speed, sessionId)
        if not moved then
            if hit then
                obstacle = true
            else
                ok = false
            end
            break
        end

        task.wait(Config.flightStep)
    end

    cleanupFlight()
    return ok, obstacle
end

local function automatedAscend(sessionId)
    if not safeCharacter() then
        return false
    end

    local startY = Session.root.Position.Y
    local targetY = startY + Config.ascentHeight

    if not createFlightControllers() then
        return false
    end

    local token = Session.flightToken
    local obstacle = false
    local success = false

    while validSession(sessionId, Session.character) and safeCharacter() and Session.flightActive and Session.flightToken == token do
        local current = Session.root.Position
        local difference = targetY - current.Y

        if difference <= 4 then
            success = true
            break
        end

        local direction = Vector3.new(0, 1, 0)
        local moved, hit = setFlightMovement(direction, Config.ascentSpeed, sessionId)
        if not moved then
            if hit then
                obstacle = true
            end
            break
        end

        task.wait(Config.flightStep)
    end

    cleanupFlight()
    return success, obstacle
end

local function controlledDescendTo(sessionId, targetPosition, timeout)
    if not safeCharacter() then
        return false, false
    end

    local started = os.clock()
    if not createFlightControllers() then
        return false, false
    end

    local token = Session.flightToken
    local obstacle = false
    local success = false

    while validSession(sessionId, Session.character) and safeCharacter() and Session.flightActive and Session.flightToken == token do
        if os.clock() - started > timeout then
            break
        end

        local current = Session.root.Position
        local desired = Vector3.new(targetPosition.X, targetPosition.Y + Config.targetVerticalDistance, targetPosition.Z)
        local delta = desired - current

        if delta.Magnitude <= 4 then
            success = true
            break
        end

        local direction = delta.Unit
        local moved, hit = setFlightMovement(direction, Config.descentSpeed, sessionId)
        if not moved then
            if hit then
                obstacle = true
            end
            break
        end

        task.wait(Config.flightStep)
    end

    cleanupFlight()
    return success, obstacle
end

local function getCurrentStation()
    if not Session.root then
        return nil
    end

    local nearestName
    local nearestDistance = math.huge

    for name, data in pairs(PoliceData) do
        local distance = (Session.root.Position - data.Base).Magnitude
        if distance < nearestDistance then
            nearestDistance = distance
            nearestName = name
        end
    end

    return nearestName and PoliceData[nearestName] or nil
end

local function exitBuilding(sessionId)
    local station = getCurrentStation()
    if not station then
        return false
    end

    setState(State.EXITING_BUILDING, sessionId)

    for _, waypoint in ipairs(station.Path) do
        if not validSession(sessionId, Session.character) or not safeCharacter() then
            return false
        end
        Session.root.CFrame = CFrame.new(waypoint)
        task.wait(Config.pathDelay)
    end

    return true
end

local function EquipHandcuffs()
    if not InventorySystem or type(InventorySystem.getInventoryItemsFor) ~= "function" then
        return false
    end

    local ok, items = pcall(function()
        return InventorySystem.getInventoryItemsFor(LocalPlayer)
    end)
    if not ok or type(items) ~= "table" then
        return false
    end

    for _, item in pairs(items) do
        if item and item.obj and item.obj.Name == "Handcuffs" then
            pcall(function()
                item:AttemptSetEquipped(true)
            end)

            local equipStart = os.clock()
            while os.clock() - equipStart < 2 do
                local equipped = false

                pcall(function()
                    if item.equipped == true then
                        equipped = true
                    elseif item.Equipped == true then
                        equipped = true
                    elseif item.obj:GetAttribute("Equipped") == true then
                        equipped = true
                    end
                end)

                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Handcuffs") then
                    equipped = true
                end

                if equipped then
                    return true
                end

                task.wait(0.1)
            end

            return true
        end
    end

    return false
end

local function getTargetEjectSpec(targetVehicle)
    local specs = getCircleSpecs()
    if not specs or not targetVehicle then
        return nil
    end

    for _, spec in pairs(specs) do
        local isMatch = false

        if spec.Part then
            if spec.Part == targetVehicle
                or spec.Part:IsDescendantOf(targetVehicle)
                or targetVehicle:IsAncestorOf(spec.Part) then
                isMatch = true
            end
        end

        if not isMatch and spec.Text then
            local text = string.lower(tostring(spec.Text))
            if string.find(text, "eject", 1, true)
                or string.find(text, "passenger", 1, true) then
                if spec.Part and (
                    spec.Part:IsDescendantOf(targetVehicle)
                    or targetVehicle:IsAncestorOf(spec.Part)
                    or spec.Part == getSeat(targetVehicle)
                ) then
                    isMatch = true
                end
            end
        end

        if isMatch then
            return spec
        end
    end

    return nil
end

local function ejectSelectedTarget()
    if not selectedTargetValid() then
        return false
    end

    local target = Session.selectedTarget
    local targetCharacter = Session.selectedTargetCharacter
    local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
    local targetVehicle = getTargetVehicle(target)

    if not targetVehicle then
        return false
    end

    local spec = getTargetEjectSpec(targetVehicle)
    if not spec then
        return false
    end

    local beforeSeat = targetHumanoid and targetHumanoid.SeatPart

    pcall(function()
        spec:Callback(true)
    end)

    local start = os.clock()
    while selectedTargetValid() and os.clock() - start < 2 do
        local char = Session.selectedTargetCharacter
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local stillIn = char and char:GetAttribute("InVehicle") == true
        local seat = hum and hum.SeatPart

        if not stillIn and not seat then
            return true
        end

        if beforeSeat and seat and seat ~= beforeSeat then
            targetVehicle = getTargetVehicle(target)
        end

        task.wait(0.1)
    end

    return false
end

local function dismountLocalVehicle()
    if not safeCharacter() then
        return false
    end

    local char = Session.character
    local hum = Session.humanoid

    if char:GetAttribute("InVehicle") == true or (hum and hum.SeatPart) then
        pressSpace()
        local started = os.clock()
        while safeCharacter() and os.clock() - started < 2 do
            if char:GetAttribute("InVehicle") ~= true and not hum.SeatPart then
                Session.vehicleEntered = false
                return true
            end
            task.wait(0.1)
        end
        Session.vehicleEntered = false
        return char:GetAttribute("InVehicle") ~= true and hum.SeatPart == nil
    end

    Session.vehicleEntered = false
    return true
end

local function targetOutsideVehicle()
    if not selectedTargetValid() then
        return false
    end

    local char = Session.selectedTargetCharacter
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local inVehicle = char:GetAttribute("InVehicle") == true
    local seat = hum and hum.SeatPart

    return not inVehicle and seat == nil
end

local function targetApproach(sessionId)
    if not selectedTargetValid() then
        return false, false
    end

    setState(State.APPROACHING_TARGET, sessionId)

    local started = os.clock()

    while validSession(sessionId, Session.character) and safeCharacter() and selectedTargetValid() do
        if os.clock() - started > Config.targetApproachTimeout then
            return false, false
        end

        local targetRoot = Session.selectedTargetRoot
        if not targetRoot or not targetRoot.Parent then
            return false, false
        end

        local targetPos = targetRoot.Position
        local currentPos = Session.root.Position
        local desiredXz = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
        local horizontalDistance = (desiredXz - currentPos).Magnitude

        if horizontalDistance <= Config.targetHorizontalTolerance then
            break
        end

        local ok, obstacle = automatedFlightTo(
            sessionId,
            targetPos,
            Config.approachSpeed,
            Config.targetHorizontalTolerance,
            math.min(5, Config.targetApproachTimeout),
            true,
            false
        )

        if obstacle then
            return false, true
        end
        if not ok and not selectedTargetValid() then
            return false, false
        end
    end

    if not selectedTargetValid() then
        return false, false
    end

    local targetRoot = Session.selectedTargetRoot
    local targetPos = targetRoot.Position

    local descentDestination = Vector3.new(
        targetPos.X,
        targetPos.Y + Config.targetVerticalDistance,
        targetPos.Z
    )

    local success, obstacle = controlledDescendTo(sessionId, descentDestination, Config.targetApproachTimeout)
    if obstacle then
        return false, true
    end

    if not success and selectedTargetValid() then
        if safeCharacter() then
            local horizontal = Vector3.new(
                targetRoot.Position.X,
                Session.root.Position.Y,
                targetRoot.Position.Z
            )
            local delta = horizontal - Session.root.Position
            if delta.Magnitude > Config.targetEngagementDistance then
                local _, blocked = automatedFlightTo(
                    sessionId,
                    horizontal,
                    Config.approachSpeed,
                    Config.targetEngagementDistance,
                    5,
                    true,
                    false
                )
                if blocked then
                    return false, true
                end
            end
        end
    end

    return selectedTargetValid(), false
end

local function tirePopObjective(sessionId)
    if not selectedTargetValid() then
        return false, false
    end

    local target = Session.selectedTarget
    local targetCharacter = Session.selectedTargetCharacter
    local targetRoot = Session.selectedTargetRoot
    local targetVehicle = getTargetVehicle(target)

    if not targetVehicle then
        return true, false
    end

    local initialPop = targetVehicle:GetAttribute("VehicleTiresLastPop")
    local started = os.clock()

    setState(State.TIRE_POP, sessionId)

    while validSession(sessionId, Session.character)
        and safeCharacter()
        and selectedTargetValid()
        and os.clock() - started < Config.tirePopTimeout do

        targetCharacter = Session.selectedTargetCharacter
        targetRoot = Session.selectedTargetRoot
        if not targetCharacter or not targetRoot then
            return false, false
        end

        targetVehicle = getTargetVehicle(target)
        if not targetVehicle then
            return true, false
        end

        local currentPop = targetVehicle:GetAttribute("VehicleTiresLastPop")
        if currentPop ~= initialPop then
            return true, false
        end

        if targetCharacter:GetAttribute("InVehicle") ~= true then
            return true, false
        end

        local root = Session.root
        local targetOffset = Config.tpOffset

        pcall(function()
            local setter = rawget(_G, "sethiddenproperty")
            if setter then
                setter(root, "PhysicsRepRootPart", targetRoot)
            end
        end)

        if safeCharacter() and selectedTargetValid() and targetRoot.Parent then
            root.CFrame = targetRoot.CFrame * targetOffset
        end

        if Session.bodyVelocity then
            Session.bodyVelocity.Velocity = Vector3.zero
        end

        task.wait(0.08)
    end

    if targetVehicle and targetVehicle.Parent then
        local finalPop = targetVehicle:GetAttribute("VehicleTiresLastPop")
        if finalPop ~= initialPop then
            return true, false
        end
    end

    if selectedTargetValid() then
        local targetChar = Session.selectedTargetCharacter
        if targetChar and targetChar:GetAttribute("InVehicle") ~= true then
            return true, false
        end
    end

    return false, false
end

local function arrestTarget(sessionId)
    if not selectedTargetValid() then
        return false
    end

    setState(State.ARRESTING_TARGET, sessionId)

    EquipHandcuffs()

    if not attemptArrest then
        discoverArrestFunction()
    end

    if not attemptArrest then
        return false
    end

    local selected = Session.selectedTarget
    local targetCharacter = Session.selectedTargetCharacter
    local targetRoot = Session.selectedTargetRoot

    if not selected or not targetCharacter or not targetRoot then
        return false
    end

    if targetCharacter:GetAttribute("InVehicle") == true then
        return false
    end

    local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
    if targetPlayer ~= selected then
        return false
    end

    pcall(function()
        attemptArrest(targetPlayer)
    end)

    local started = os.clock()
    while validSession(sessionId, Session.character) and os.clock() - started < Config.handcuffWaitTimeout do
        if targetPlayer.Character ~= targetCharacter then
            return false
        end

        if targetCharacter:GetAttribute("HasHandcuffs") == true then
            return true
        end

        task.wait(0.1)
    end

    return false
end

local function monitorSelectedTarget(sessionId)
    disconnectBucket(Session.targetConnections)

    local target = Session.selectedTarget
    local char = Session.selectedTargetCharacter
    if not target or not char then
        return
    end

    addConnection(Session.targetConnections, char:GetAttributeChangedSignal("HasHandcuffs"):Connect(function()
        if not validSession(sessionId, Session.character) then
            return
        end
        if Session.selectedTarget == target and char:GetAttribute("HasHandcuffs") == true then
            arrestedBlacklist[target] = true
        end
    end))

    addConnection(Session.targetConnections, target.CharacterAdded:Connect(function()
        if Session.selectedTarget == target then
            clearTarget()
        end
    end))
end

local function findVehicleForReturn()
    local remembered = Session.rememberedCar
    if remembered and isVehicleValid(remembered, false) then
        local seat = getSeat(remembered)
        if seat and not seat.Occupant then
            return remembered
        end
    end

    local current = getLocalVehicle()
    if current and isVehicleValid(current, false) then
        Session.rememberedCar = current
        return current
    end

    return nil
end

local function spawnCamaro(sessionId)
    if not validSession(sessionId, Session.character) or not safeCharacter() then
        return nil
    end

    setState(State.SPAWNING_VEHICLE, sessionId)

    local vehicles = Workspace:FindFirstChild("Vehicles")
    local before = {}
    if vehicles then
        for _, vehicle in ipairs(vehicles:GetChildren()) do
            before[vehicle] = true
        end
    end

    local spawnRemote = ReplicatedStorage:FindFirstChild("GarageSpawnVehicle", true)
    if not spawnRemote then
        return nil
    end

    pcall(function()
        spawnRemote:FireServer("Chassis", "Camaro")
    end)

    local started = os.clock()
    while validSession(sessionId, Session.character) and safeCharacter() and os.clock() - started < Config.vehicleFindTimeout do
        local best
        local bestDistance = math.huge

        if vehicles then
            for _, vehicle in ipairs(vehicles:GetChildren()) do
                local name = string.lower(vehicle.Name)
                if string.find(name, "camaro", 1, true) or not before[vehicle] then
                    local seat = getSeat(vehicle)
                    if seat and not seat.Occupant then
                        local d = (Session.root.Position - seat.Position).Magnitude
                        if d < bestDistance and d <= 35 then
                            bestDistance = d
                            best = vehicle
                        end
                    end
                end
            end
        end

        if best then
            return best
        end

        task.wait(0.2)
    end

    return nil
end

local function returnToVehicle(sessionId, cuffedPosition)
    if not selectedTargetValid() and not cuffedPosition then
        return false, false
    end

    setState(State.RETURNING_TO_VEHICLE, sessionId)

    local vehicle = findVehicleForReturn()

    if not vehicle then
        if not cuffedPosition then
            return false, false
        end

        local riseDestination = Session.root.Position + Vector3.new(0, Config.returnAltitude, 0)
        local riseOk, riseObstacle = automatedFlightTo(
            sessionId,
            riseDestination,
            Config.returnSpeed,
            4,
            8,
            false,
            true
        )

        if riseObstacle then
            return false, true
        end
        if not riseOk then
            return false, false
        end

        local current = Session.root.Position
        local away = current - cuffedPosition
        local horizontalAway = Vector3.new(away.X, 0, away.Z)
        if horizontalAway.Magnitude < 1 then
            local camera = Workspace.CurrentCamera
            horizontalAway = camera and Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z) or Vector3.new(1, 0, 0)
        end
        horizontalAway = horizontalAway.Unit
        local displacementDestination = current + horizontalAway * Config.spawnDisplacement

        local moveOk, moveObstacle = automatedFlightTo(
            sessionId,
            displacementDestination,
            Config.returnSpeed,
            8,
            Config.horizontalFlightTimeout,
            true,
            false
        )

        if moveObstacle then
            return false, true
        end
        if not moveOk then
            return false, false
        end

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {Session.character, Session.currentVehicle}
        rayParams.IgnoreWater = false

        local rayOrigin = Session.root.Position + Vector3.new(0, 10, 0)
        local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
        local groundY = rayResult and rayResult.Position.Y or current.Y

        local descendOk, descendObstacle = controlledDescendTo(
            sessionId,
            Vector3.new(Session.root.Position.X, groundY + 4, Session.root.Position.Z),
            12
        )

        if descendObstacle then
            return false, true
        end
        if not descendOk then
            return false, false
        end

        vehicle = spawnCamaro(sessionId)
        if not vehicle then
            return false, false
        end
    else
        local distance = (vehicle:GetPivot().Position - Session.root.Position).Magnitude
        if distance > Config.rememberedVehicleMaxDistance then
            if not cuffedPosition then
                return false, false
            end

            local riseDestination = Session.root.Position + Vector3.new(0, Config.returnAltitude, 0)
            local riseOk, riseObstacle = automatedFlightTo(
                sessionId,
                riseDestination,
                Config.returnSpeed,
                4,
                8,
                false,
                true
            )

            if riseObstacle then
                return false, true
            end
            if not riseOk then
                return false, false
            end

            local current = Session.root.Position
            local away = current - cuffedPosition
            local horizontalAway = Vector3.new(away.X, 0, away.Z)
            if horizontalAway.Magnitude < 1 then
                horizontalAway = Vector3.new(1, 0, 0)
            end
            local displacementDestination = current + horizontalAway.Unit * Config.spawnDisplacement

            local moveOk, moveObstacle = automatedFlightTo(
                sessionId,
                displacementDestination,
                Config.returnSpeed,
                8,
                Config.horizontalFlightTimeout,
                true,
                false
            )

            if moveObstacle then
                return false, true
            end
            if not moveOk then
                return false, false
            end

            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {Session.character, Session.currentVehicle}
            rayParams.IgnoreWater = false

            local rayOrigin = Session.root.Position + Vector3.new(0, 10, 0)
            local rayResult = Workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), rayParams)
            local groundY = rayResult and rayResult.Position.Y or Session.root.Position.Y

            local descendOk, descendObstacle = controlledDescendTo(
                sessionId,
                Vector3.new(Session.root.Position.X, groundY + 4, Session.root.Position.Z),
                12
            )

            if descendObstacle then
                return false, true
            end
            if not descendOk then
                return false, false
            end

            vehicle = spawnCamaro(sessionId)
            if not vehicle then
                return false, false
            end
        else
            local vehiclePosition = getSeat(vehicle) and getSeat(vehicle).Position or vehicle:GetPivot().Position
            local riseDestination = Session.root.Position + Vector3.new(0, Config.returnAltitude, 0)

            local riseOk, riseObstacle = automatedFlightTo(
                sessionId,
                riseDestination,
                Config.returnSpeed,
                4,
                8,
                false,
                true
            )

            if riseObstacle then
                return false, true
            end
            if not riseOk then
                return false, false
            end

            local targetHorizontal = Vector3.new(vehiclePosition.X, Session.root.Position.Y, vehiclePosition.Z)
            local moveOk, moveObstacle = automatedFlightTo(
                sessionId,
                targetHorizontal,
                Config.returnSpeed,
                8,
                Config.horizontalFlightTimeout,
                true,
                false
            )

            if moveObstacle then
                return false, true
            end
            if not moveOk then
                return false, false
            end
        end
    end

    if not vehicle or not isVehicleValid(vehicle, false) then
        return false, false
    end

    local seat = getSeat(vehicle)
    if not seat then
        return false, false
    end

    local descentY = seat.Position.Y + 3
    local descentOk, descentObstacle = controlledDescendTo(
        sessionId,
        Vector3.new(seat.Position.X, descentY, seat.Position.Z),
        12
    )

    if descentObstacle then
        return false, true
    end
    if not descentOk then
        local flatOk, flatObstacle = automatedFlightTo(
            sessionId,
            Vector3.new(seat.Position.X, Session.root.Position.Y, seat.Position.Z),
            Config.returnSpeed,
            5,
            6,
            true,
            false
        )
        if flatObstacle then
            return false, true
        end
        if not flatOk then
            return false, false
        end
    end

    setState(State.ENTERING_VEHICLE, sessionId)

    local entryStart = os.clock()
    while validSession(sessionId, Session.character) and safeCharacter() and os.clock() - entryStart < Config.vehicleEntryTimeout do
        if Session.root and seat and (Session.root.Position - seat.Position).Magnitude <= Config.vehicleInteractionDistance + 5 then
            triggerVehicleInteraction(vehicle)
        end

        if Session.character:GetAttribute("InVehicle") == true or (Session.humanoid and Session.humanoid.SeatPart) then
            Session.currentVehicle = getLocalVehicle() or vehicle
            Session.rememberedCar = Session.currentVehicle
            Session.vehicleEntered = true
            return true, false
        end

        task.wait(0.15)
    end

    Session.vehicleEntered = false
    return false, false
end

local function clearSessionObjects()
    cleanupFlight()
    disconnectBucket(Session.connections)
    disconnectBucket(Session.targetConnections)
    Session.currentVehicle = nil
    Session.selectedTarget = nil
    Session.selectedTargetCharacter = nil
    Session.selectedTargetRoot = nil
    Session.vehicleEntered = false
    Session.humanoid = nil
    Session.root = nil
    Session.character = nil
    Session.rememberedCar = nil
    Session.vehicleMemoryTask = nil
end

local function stopSession(reason, preserveBlacklist)
    Session.cancelled = true
    setState(reason or State.STOPPED)
    cleanupFlight()
    disconnectBucket(Session.connections)
    disconnectBucket(Session.targetConnections)
    Session.currentVehicle = nil
    Session.selectedTarget = nil
    Session.selectedTargetCharacter = nil
    Session.selectedTargetRoot = nil
    Session.vehicleEntered = false
    Session.humanoid = nil
    Session.root = nil
    Session.character = nil
    if not preserveBlacklist then
        arrestedBlacklist = {}
        Global.__AutoArrestBlacklist = arrestedBlacklist
    end
end

local function safetyReset(sessionId)
    if Session.id ~= sessionId then
        return
    end

    setState(State.RESETTING, sessionId)
    Session.cancelled = true
    cleanupFlight()
    disconnectBucket(Session.connections)
    disconnectBucket(Session.targetConnections)

    local character = Session.character
    local humanoid = Session.humanoid

    Session.currentVehicle = nil
    Session.selectedTarget = nil
    Session.selectedTargetCharacter = nil
    Session.selectedTargetRoot = nil
    Session.vehicleEntered = false

    if character and character.Parent and humanoid and humanoid.Health > 0 then
        pcall(function()
            humanoid.Health = 0
        end)
    end
end

local function runSession(character)
    Session.id += 1
    local sessionId = Session.id

    Session.cancelled = false
    Session.character = character
    Session.humanoid = character:WaitForChild("Humanoid", 10)
    Session.root = character:WaitForChild("HumanoidRootPart", 10)
    Session.state = State.INITIALIZING
    Session.vehicleEntered = false
    Session.currentVehicle = nil
    Session.rememberedCar = nil
    Session.selectedTarget = nil
    Session.selectedTargetCharacter = nil
    Session.selectedTargetRoot = nil
    Session.flightToken = 0

    if not Session.humanoid or not Session.root or not isAlive(character, Session.humanoid) then
        stopSession(State.STOPPED, true)
        return
    end

    addConnection(Session.connections, Session.humanoid.Died:Connect(function()
        if Session.id == sessionId then
            Session.cancelled = true
            cleanupFlight()
            disconnectBucket(Session.targetConnections)
            setState(State.DEAD, sessionId)
        end
    end))

    addConnection(Session.connections, character.AncestryChanged:Connect(function(_, parent)
        if Session.id ~= sessionId then
            return
        end
        if parent == nil or LocalPlayer.Character ~= character then
            Session.cancelled = true
            cleanupFlight()
            disconnectBucket(Session.targetConnections)
            setState(State.DEAD, sessionId)
        end
    end))

    startVehicleMemory(sessionId)

    setState(State.EXITING_BUILDING, sessionId)
    if not exitBuilding(sessionId) then
        return
    end

    if not validSession(sessionId, character) or not safeCharacter() then
        return
    end

    setState(State.FINDING_VEHICLE, sessionId)
    local vehicle = findNearestUsableVehicle()
    local findStart = os.clock()

    while not vehicle and validSession(sessionId, character) and safeCharacter() and os.clock() - findStart < Config.vehicleFindTimeout do
        task.wait(0.2)
        vehicle = findNearestUsableVehicle()
    end

    if not vehicle then
        local spawned = spawnCamaro(sessionId)
        if spawned then
            vehicle = spawned
        else
            safetyReset(sessionId)
            return
        end
    end

    setState(State.ENTERING_VEHICLE, sessionId)
    if not enterVehicle(sessionId, vehicle) then
        local retry = findNearestUsableVehicle()
        if retry and retry ~= vehicle then
            if not enterVehicle(sessionId, retry) then
                safetyReset(sessionId)
                return
            end
        else
            safetyReset(sessionId)
            return
        end
    end

    setState(State.VERIFYING_VEHICLE, sessionId)
    if not Session.vehicleEntered
        or not safeCharacter()
        or not Session.humanoid
        or not (Session.character:GetAttribute("InVehicle") == true or Session.humanoid.SeatPart ~= nil) then
        safetyReset(sessionId)
        return
    end

    Session.currentVehicle = getLocalVehicle() or Session.currentVehicle or vehicle
    Session.rememberedCar = Session.currentVehicle

    while validSession(sessionId, character) and safeCharacter() do
        setState(State.ASCENDING, sessionId)

        local ascentOk, ascentObstacle = automatedAscend(sessionId)
        if ascentObstacle then
            safetyReset(sessionId)
            return
        end
        if not ascentOk then
            if not validSession(sessionId, character) then
                return
            end
            safetyReset(sessionId)
            return
        end

        setState(State.SEARCHING_TARGET, sessionId)
        clearTarget()

        local target
        local targetSearchStart = os.clock()

        while validSession(sessionId, character) and safeCharacter() and os.clock() - targetSearchStart < 4 do
            target = selectNearestTarget(sessionId)
            if target then
                break
            end
            task.wait(0.4)
        end

        if not target then
            task.wait(0.5)
            continue
        end

        monitorSelectedTarget(sessionId)

        if not selectedTargetValid() then
            clearTarget()
            continue
        end

        local approached, approachObstacle = targetApproach(sessionId)
        if approachObstacle then
            safetyReset(sessionId)
            return
        end
        if not approached or not selectedTargetValid() then
            clearTarget()
            continue
        end

        if getTargetVehicle(target) then
            local popOk, popObstacle = tirePopObjective(sessionId)
            cleanupFlight()
            if popObstacle then
                safetyReset(sessionId)
                return
            end
            if not popOk or not selectedTargetValid() then
                clearTarget()
                continue
            end
        end

        setState(State.EJECTING_TARGET, sessionId)

        if Session.character:GetAttribute("InVehicle") == true or Session.humanoid.SeatPart then
            if not dismountLocalVehicle() then
                safetyReset(sessionId)
                return
            end
        end

        if not selectedTargetValid() then
            clearTarget()
            continue
        end

        EquipHandcuffs()

        local ejectStart = os.clock()
        while selectedTargetValid()
            and not targetOutsideVehicle()
            and os.clock() - ejectStart < Config.arrestTimeout do

            local targetVehicle = getTargetVehicle(Session.selectedTarget)
            if not targetVehicle then
                break
            end

            if not ejectSelectedTarget() then
                task.wait(0.2)
            else
                task.wait(0.1)
            end
        end

        if not selectedTargetValid() then
            clearTarget()
            continue
        end

        if not targetOutsideVehicle() then
            clearTarget()
            continue
        end

        setState(State.ARRESTING_TARGET, sessionId)
        local arrestOk = arrestTarget(sessionId)

        if not arrestOk then
            clearTarget()
            continue
        end

        setState(State.WAITING_FOR_HANDCUFF, sessionId)

        local cuffedPlayer = Session.selectedTarget
        local cuffedCharacter = Session.selectedTargetCharacter
        local cuffStart = os.clock()
        local cuffConfirmed = false

        while validSession(sessionId, character) and safeCharacter() and os.clock() - cuffStart < Config.handcuffWaitTimeout do
            if cuffedPlayer
                and cuffedCharacter
                and cuffedPlayer.Character == cuffedCharacter
                and cuffedCharacter:GetAttribute("HasHandcuffs") == true then
                cuffConfirmed = true
                break
            end
            task.wait(0.1)
        end

        if not cuffConfirmed then
            clearTarget()
            continue
        end

        if cuffedPlayer then
            arrestedBlacklist[cuffedPlayer] = true
        end

        local cuffedPosition = cuffedCharacter
            and cuffedCharacter:FindFirstChild("HumanoidRootPart")
            and cuffedCharacter.HumanoidRootPart.Position
            or Session.root.Position

        clearTarget()

        local returned, returnObstacle = returnToVehicle(sessionId, cuffedPosition)
        if returnObstacle then
            safetyReset(sessionId)
            return
        end

        if not returned then
            local fallbackVehicle = spawnCamaro(sessionId)
            if not fallbackVehicle then
                safetyReset(sessionId)
                return
            end

            local fallbackEntered = enterVehicle(sessionId, fallbackVehicle)
            if not fallbackEntered then
                safetyReset(sessionId)
                return
            end
        end

        setState(State.VERIFYING_VEHICLE, sessionId)

        if not Session.humanoid
            or not safeCharacter()
            or not (Session.character:GetAttribute("InVehicle") == true or Session.humanoid.SeatPart ~= nil) then
            safetyReset(sessionId)
            return
        end

        Session.currentVehicle = getLocalVehicle() or Session.currentVehicle
        Session.rememberedCar = Session.currentVehicle
        Session.vehicleEntered = true

        task.wait(0.2)
    end
end

local CharacterHandlerGeneration = 0
local function handleCharacter(character)
    CharacterHandlerGeneration += 1
    local generation = CharacterHandlerGeneration

    if Session.character and Session.character ~= character then
        Session.cancelled = true
        cleanupFlight()
        disconnectBucket(Session.connections)
        disconnectBucket(Session.targetConnections)
    end

    task.spawn(function()
        local humanoid = character:WaitForChild("Humanoid", 15)
        local root = character:WaitForChild("HumanoidRootPart", 15)

        if generation ~= CharacterHandlerGeneration or not Global.AutoArrestActive then
            return
        end

        if not humanoid or not root then
            return
        end

        local waitStart = os.clock()
        while generation == CharacterHandlerGeneration
            and Global.AutoArrestActive
            and character.Parent
            and humanoid.Health > 0
            and os.clock() - waitStart < 10 do

            if character:FindFirstChild("HumanoidRootPart") then
                break
            end
            task.wait(0.1)
        end

        if generation ~= CharacterHandlerGeneration or not Global.AutoArrestActive then
            return
        end

        if character ~= LocalPlayer.Character then
            return
        end

        runSession(character)
    end)
end

if Global.__AutoArrestController then
    pcall(function()
        if Global.__AutoArrestController.Stop then
            Global.__AutoArrestController.Stop()
        end
    end)
end

Global.__AutoArrestController = {
    Stop = function()
        Global.AutoArrestActive = false
        CharacterHandlerGeneration += 1
        Session.cancelled = true
        cleanupFlight()
        disconnectBucket(Session.connections)
        disconnectBucket(Session.targetConnections)
        setState(State.STOPPED)
    end,
    State = function()
        return Session.state
    end
}

Global.AutoArrestActive = true

LocalPlayer.CharacterAdded:Connect(function(character)
    if not Global.AutoArrestActive then
        return
    end
    handleCharacter(character)
end)

LocalPlayer.CharacterRemoving:Connect(function(character)
    if Session.character == character then
        Session.cancelled = true
        cleanupFlight()
        disconnectBucket(Session.connections)
        disconnectBucket(Session.targetConnections)
        Session.currentVehicle = nil
        Session.selectedTarget = nil
        Session.selectedTargetCharacter = nil
        Session.selectedTargetRoot = nil
        Session.vehicleEntered = false
        setState(State.DEAD)
    end
end)

if LocalPlayer.Character then
    handleCharacter(LocalPlayer.Character)
end
