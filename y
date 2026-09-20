local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local VirtualInputManager=game:GetService("VirtualInputManager")

local lp=Players.LocalPlayer
local vehicleUtils=require(ReplicatedStorage:WaitForChild("Vehicle"):WaitForChild("VehicleUtils"))
local UI=require(ReplicatedStorage.Module.UI)
local invSys=require(ReplicatedStorage.Inventory.InventoryItemSystem)

local Config={
    WaypointDelay=0.2,
    PostPathDelay=1,
    VehicleSearchDistance=15,
    TargetSearchHeight=500,
    ReturnHeight=50,
    TargetEngageDistance=20,
    TargetLockDistance=5,
    TargetTpOffset=CFrame.new(0,0,-2),
    TargetApproachSpeed=100,
    FallbackDistance=300,
    FallbackAwayDistance=300,
    EnemySpawnClearance=200,
    ObstacleCheckDistance=75,
    AscendSpeed=100,
    DescendSpeed=100,
    ArrestTimeout=10,
    TirePopCheckDelay=0.2,
    UndergroundYThreshold=-10,
    CruiseSpeed=100,
    VehicleEntryTimeout=5
}

local PoliceData={
    ["Custom Main Station Path"]={
        Base=Vector3.new(-1173.24,39.42,-1583.77),
        Path={
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
    ["Fourth Station"]={
        Base=Vector3.new(1786.66,24.05,-4019.01),
        Path={
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
    ["Main Police Station Ground"]={
        Base=Vector3.new(-1171.10,18.80,-1579.22),
        Path={
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
    ["Museum Police Station"]={
        Base=Vector3.new(738.20,44.96,1120.53),
        Path={
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
    ["Military Base"]={
        Base=Vector3.new(1801.00,25.54,-891.02),
        Path={
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
    ["Fifth Station"]={
        Base=Vector3.new(1822.10,25.55,-636.60),
        Path={
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

local currentVehicle=nil
local lastExitedVehicle=nil
local targetVehicle=nil
local targetPlayer=nil
local targetCharacter=nil
local targetRoot=nil
local rememberedCar=nil
local bodyVelocity=nil
local bodyGyro=nil
local character=nil
local humanoid=nil
local rootPart=nil
local cycleId=0
local phase=0
local phaseRunning=false
local phase1Complete=false
local arrestedBlacklist={}
local targetLoopToken=0
local connections={}
local attemptArrest=nil

local function alive(id)
    return id==cycleId and character and character.Parent and humanoid and humanoid.Health>0 and rootPart and rootPart.Parent
end

local function clearFlight()
    if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) end
    if bodyGyro then pcall(function() bodyGyro:Destroy() end) end
    bodyVelocity=nil
    bodyGyro=nil
end

local function clearPhysicsRep()
    if rootPart then
        pcall(function() sethiddenproperty(rootPart,"PhysicsRepRootPart",nil) end)
    end
end

local function clearTarget()
    targetLoopToken=targetLoopToken+1
    clearPhysicsRep()
    targetVehicle=nil
    targetPlayer=nil
    targetCharacter=nil
    targetRoot=nil
end

local function clearConnections()
    for _,c in pairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(connections)
end

local function resetCycle()
    cycleId=cycleId+1
    phase=0
    phaseRunning=false
    phase1Complete=false
    clearFlight()
    clearPhysicsRep()
    clearTarget()
    currentVehicle=nil
    lastExitedVehicle=nil
    rememberedCar=nil
end

local function setupFlight()
    if not rootPart then return false end
    clearFlight()
    bodyVelocity=Instance.new("BodyVelocity")
    bodyVelocity.Name="PoliceAutomationVelocity"
    bodyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    bodyVelocity.P=30000
    bodyVelocity.Velocity=Vector3.zero
    bodyVelocity.Parent=rootPart
    bodyGyro=Instance.new("BodyGyro")
    bodyGyro.Name="PoliceAutomationGyro"
    bodyGyro.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
    bodyGyro.P=30000
    bodyGyro.D=1000
    bodyGyro.CFrame=rootPart.CFrame
    bodyGyro.Parent=rootPart
    return true
end

local function getVehicleRoot(v)
    if not v or not v.Parent then return nil end
    return v.PrimaryPart or v:FindFirstChild("Seat") or v:FindFirstChild("VehicleSeat") or v:FindFirstChildWhichIsA("BasePart",true)
end

local function isPoliceVehicle(v)
    if not v or not v:IsA("Model") then return false end
    local n=v.Name:lower()
    return n:find("camaro")~=nil or n:find("jeep")~=nil
end

local function getDriverSeat(v)
    if not v then return nil end
    return v:FindFirstChild("Seat") or v:FindFirstChild("VehicleSeat") or v:FindFirstChildWhichIsA("VehicleSeat",true)
end

local function vehicleDriverOccupiedByOther(v)
    local seat=getDriverSeat(v)
    if not seat then return true end
    local occ=seat.Occupant
    if not occ then return false end
    local p=Players:GetPlayerFromCharacter(occ.Parent)
    return p~=nil and p~=lp
end

local function validLocalVehicle(v)
    if not isPoliceVehicle(v) then return false end
    if not getVehicleRoot(v) then return false end
    if vehicleDriverOccupiedByOther(v) then return false end
    return true
end

local function getInVehicle()
    if not character or not humanoid then return false end
    return character:GetAttribute("InVehicle")==true or humanoid.SeatPart~=nil
end

local function getTargetInVehicle(char)
    if not char then return false end
    local x=char:GetAttribute("InVehicle")
    return x~=nil and x~=false
end

local function findStation()
    if not rootPart then return nil end
    local best,bestDist=nil,math.huge
    for _,data in pairs(PoliceData) do
        local d=(rootPart.Position-data.Base).Magnitude
        if d<bestDist then
            bestDist=d
            best=data
        end
    end
    return best
end

local function phase1(id)
    if not alive(id) or phase~=0 then return false end
    phaseRunning=true
    phase=1
    local station=findStation()
    if not station then
        phaseRunning=false
        return false
    end
    for _,pos in ipairs(station.Path) do
        if not alive(id) or phase~=1 then
            phaseRunning=false
            return false
        end
        rootPart.CFrame=CFrame.new(pos)
        task.wait(Config.WaypointDelay)
    end
    task.wait(Config.PostPathDelay)
    if not alive(id) or phase~=1 then
        phaseRunning=false
        return false
    end
    phase1Complete=true
    phaseRunning=false
    return true
end

local function updateRememberedCar()
    local ok,m=pcall(vehicleUtils.GetLocalVehicleModel)
    if ok and m and m~="" and m~=false then
        local car=typeof(m)=="Instance" and m or Workspace:FindFirstChild(m,true)
        if car and isPoliceVehicle(car) then rememberedCar=car end
    end
end

getgenv().GetMyCar=function()
    updateRememberedCar()
    return rememberedCar
end

task.spawn(function()
    while task.wait(0.5) do
        if character and character.Parent then updateRememberedCar() end
    end
end)

local function findLocalVehicle()
    if not rootPart then return nil end
    updateRememberedCar()
    local best,bestDist=nil,Config.VehicleSearchDistance
    local vehicles=Workspace:FindFirstChild("Vehicles")
    if not vehicles then return nil end
    for _,v in ipairs(vehicles:GetChildren()) do
        if validLocalVehicle(v) then
            local r=getVehicleRoot(v)
            if r then
                local d=(r.Position-rootPart.Position).Magnitude
                if d<=bestDist then
                    bestDist=d
                    best=v
                end
            end
        end
    end
    if validLocalVehicle(rememberedCar) then
        local r=getVehicleRoot(rememberedCar)
        if r and (r.Position-rootPart.Position).Magnitude<=Config.VehicleSearchDistance then
            best=rememberedCar
        end
    end
    return best
end

local function triggerEntry(v)
    if not v or not UI or not UI.CircleAction or not UI.CircleAction.Specs then return false end
    local seat=getDriverSeat(v) or v:FindFirstChild("Seat")
    if not seat then return false end
    for _,spec in pairs(UI.CircleAction.Specs) do
        if spec.Part and (spec.Part==seat or spec.Part:IsDescendantOf(v)) then
            local text=tostring(spec.Text or ""):lower()
            if text:find("enter") or text:find("driver") or spec.Part==seat then
                pcall(function() spec:Callback(true) end)
                return true
            end
        end
    end
    return false
end

local function enterVehicle(v,id)
    if not v or not alive(id) then return false end
    local untilTime=os.clock()+Config.VehicleEntryTimeout
    while os.clock()<untilTime do
        if not alive(id) then return false end
        if getInVehicle() then
            currentVehicle=v
            rememberedCar=v
            return true
        end
        triggerEntry(v)
        task.wait(0.2)
    end
    return getInVehicle()
end

local function rayBlocked(origin,direction,ignore)
    if direction.Magnitude<=0 then return false end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local list={character}
    if currentVehicle then table.insert(list,currentVehicle) end
    if ignore then table.insert(list,ignore) end
    params.FilterDescendantsInstances=list
    local hit=Workspace:Raycast(origin,direction,params)
    return hit~=nil,hit
end

local function unsafeVertical(targetY)
    if not rootPart then return true end
    local dy=targetY-rootPart.Position.Y
    if math.abs(dy)<1 then return false end
    local dir=Vector3.new(0,dy>0 and Config.ObstacleCheckDistance or -Config.ObstacleCheckDistance,0)
    local blocked=rayBlocked(rootPart.Position,dir,nil)
    return blocked
end

local function killForFlight()
    clearFlight()
    if humanoid and humanoid.Health>0 then
        humanoid.Health=0
    end
end

local function moveToPosition(pos,speed,id,ignoreTarget)
    if not alive(id) then return false end
    if not setupFlight() then return false end
    local started=os.clock()
    while alive(id) do
        local delta=pos-rootPart.Position
        if delta.Magnitude<=5 then
            bodyVelocity.Velocity=Vector3.zero
            return true
        end
        if os.clock()-started>15 then
            return false
        end
        local dir=delta.Unit
        bodyVelocity.Velocity=dir*math.min(speed,delta.Magnitude*4)
        local flat=Vector3.new(delta.X,0,delta.Z)
        if flat.Magnitude>0.1 then
            bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,rootPart.Position+flat)
        end
        task.wait()
        pos=pos
    end
    return false
end

local function ascendTo(y,id)
    if not alive(id) then return false end
    if y<=rootPart.Position.Y then return true end
    if not setupFlight() then return false end
    while alive(id) and rootPart.Position.Y<y-4 do
        if unsafeVertical(math.min(y,rootPart.Position.Y+Config.ObstacleCheckDistance)) then
            killForFlight()
            return false
        end
        bodyVelocity.Velocity=Vector3.new(0,Config.AscendSpeed,0)
        bodyGyro.CFrame=CFrame.new(rootPart.Position)*CFrame.Angles(0,0,0)
        task.wait()
    end
    bodyVelocity.Velocity=Vector3.zero
    return alive(id)
end

local function descendTo(y,id)
    if not alive(id) then return false end
    if y>=rootPart.Position.Y then return true end
    if not setupFlight() then return false end
    while alive(id) and rootPart.Position.Y>y+4 do
        if unsafeVertical(math.max(y,rootPart.Position.Y-Config.ObstacleCheckDistance)) then
            killForFlight()
            return false
        end
        bodyVelocity.Velocity=Vector3.new(0,-Config.DescendSpeed,0)
        bodyGyro.CFrame=CFrame.new(rootPart.Position)*CFrame.Angles(0,0,0)
        task.wait()
    end
    bodyVelocity.Velocity=Vector3.zero
    return alive(id)
end

local function phase2(id)
    if not alive(id) or not phase1Complete or phase~=1 then return false end
    phaseRunning=true
    phase=2
    local v=findLocalVehicle()
    if not v then
        phaseRunning=false
        return false
    end
    if not enterVehicle(v,id) then
        phaseRunning=false
        return false
    end
    phaseRunning=false
    return true
end

local function phase3(id)
    if not alive(id) or phase~=2 or not getInVehicle() then return false end
    phaseRunning=true
    phase=3
    local y=rootPart.Position.Y+Config.TargetSearchHeight
    local ok=ascendTo(y,id)
    if ok then
        clearFlight()
    end
    phaseRunning=false
    return ok
end

local function isSpecialVehicle(v)
    if not v then return false end
    local n=v.Name:lower()
    return n:find("heli") or n:find("ufo") or n:find("blackhawk") or n:find("drone") or n:find("blimp")
end

local function getVehicleNearRoot(root)
    local vehicles=Workspace:FindFirstChild("Vehicles")
    if not vehicles or not root then return nil end
    local best,bestDist=nil,25
    for _,v in ipairs(vehicles:GetChildren()) do
        if v:IsA("Model") then
            local r=getVehicleRoot(v)
            if r then
                local d=(r.Position-root.Position).Magnitude
                if d<bestDist then
                    bestDist=d
                    best=v
                end
            end
        end
    end
    return best
end

local function isTargetCovered(root)
    if not root then return true end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={character,root.Parent}
    local origin=root.Position+Vector3.new(0,2,0)
    local hit=Workspace:Raycast(origin,Vector3.new(0,20,0),params)
    return hit~=nil
end

local function validTarget(p)
    if not p or p==lp or arrestedBlacklist[p] then return false end
    local char=p.Character
    if not char then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local root=char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health<=0 or not root then return false end
    if not p.Team or p.Team.Name~="Criminal" then
        if arrestedBlacklist[p] then arrestedBlacklist[p]=nil end
        return false
    end
    if char:GetAttribute("HasHandcuffs") then return false end
    if root.Position.Y<Config.UndergroundYThreshold then return false end
    if isTargetCovered(root) then return false end
    if getTargetInVehicle(char) then
        local v=getVehicleNearRoot(root)
        if v and isSpecialVehicle(v) then return false end
    end
    return true
end

local function findTarget()
    if not rootPart then return nil end
    local best,bestDist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if validTarget(p) then
            local r=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d=(r.Position-rootPart.Position).Magnitude
                if d<bestDist then
                    bestDist=d
                    best=p
                end
            end
        end
    end
    return best
end

local function setTarget(p)
    clearTarget()
    if not p then return false end
    targetPlayer=p
    targetCharacter=p.Character
    targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    targetVehicle=getVehicleNearRoot(targetRoot)
    return targetRoot~=nil
end

local function targetStillValid()
    return targetPlayer and validTarget(targetPlayer) and targetPlayer.Character==targetCharacter and targetRoot and targetRoot.Parent
end

local function closeTargetLock(id)
    if not targetStillValid() or not alive(id) then return false end
    clearFlight()
    targetLoopToken=targetLoopToken+1
    local token=targetLoopToken
    while alive(id) and targetStillValid() and token==targetLoopToken do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then break end
        local d=(rootPart.Position-targetRoot.Position).Magnitude
        if d>Config.TargetLockDistance+0.5 then return true end
        pcall(function()
            sethiddenproperty(rootPart,"PhysicsRepRootPart",targetRoot)
        end)
        rootPart.CFrame=targetRoot.CFrame*Config.TargetTpOffset
        task.wait()
    end
    clearPhysicsRep()
    return alive(id)
end

local function approachTarget(id)
    if not targetStillValid() then return false end
    while alive(id) and targetStillValid() do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        local d=(rootPart.Position-targetRoot.Position).Magnitude
        if d<=Config.TargetLockDistance then
            closeTargetLock(id)
            return targetStillValid()
        end
        if not setupFlight() then return false end
        local delta=targetRoot.Position-rootPart.Position
        if delta.Magnitude>0 then
            bodyVelocity.Velocity=delta.Unit*Config.TargetApproachSpeed
            bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,targetRoot.Position)
        end
        task.wait()
    end
    clearFlight()
    return false
end

local function cruiseAboveTarget(id)
    if not targetStillValid() then return false end
    if not setupFlight() then return false end
    while alive(id) and targetStillValid() do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        local desired=Vector3.new(targetRoot.Position.X,rootPart.Position.Y,targetRoot.Position.Z)
        local flat=Vector3.new(desired.X-rootPart.Position.X,0,desired.Z-rootPart.Position.Z)
        if flat.Magnitude<=8 then
            bodyVelocity.Velocity=Vector3.zero
            return true
        end
        bodyVelocity.Velocity=flat.Unit*Config.CruiseSpeed
        bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,desired)
        task.wait()
    end
    return false
end

local function descendTrackTarget(id)
    if not targetStillValid() then return false end
    if not setupFlight() then return false end
    while alive(id) and targetStillValid() do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        local desiredY=targetRoot.Position.Y+6
        if rootPart.Position.Y<=desiredY+2 then
            bodyVelocity.Velocity=Vector3.zero
            return true
        end
        local delta=Vector3.new(targetRoot.Position.X-rootPart.Position.X,desiredY-rootPart.Position.Y,targetRoot.Position.Z-rootPart.Position.Z)
        if unsafeVertical(math.max(desiredY,rootPart.Position.Y-Config.ObstacleCheckDistance)) then
            killForFlight()
            return false
        end
        bodyVelocity.Velocity=delta.Unit*Config.DescendSpeed
        bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,Vector3.new(targetRoot.Position.X,rootPart.Position.Y,targetRoot.Position.Z))
        task.wait()
    end
    return false
end

local function EquipHandcuffs()
    for _,item in pairs(invSys.getInventoryItemsFor(lp)) do
        if item.obj and item.obj.Name=="Handcuffs" then
            pcall(function() item:AttemptSetEquipped(true) end)
            return true
        end
    end
    return false
end

local function unmount(id)
    if not alive(id) then return false end
    if not getInVehicle() then return true end
    for _=1,5 do
        if not alive(id) then return false end
        if not getInVehicle() then return true end
        pcall(function()
            VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
            VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
        end)
        task.wait(0.3)
    end
    return not getInVehicle()
end

local function findAttemptArrest()
    if attemptArrest then return attemptArrest end
    for _,v in pairs(getgc(true)) do
        if type(v)=="function" and islclosure(v) then
            pcall(function()
                if tostring(getinfo(v).name)=="AttemptArrest" then
                    attemptArrest=v
                end
            end)
            if attemptArrest then break end
        end
    end
    return attemptArrest
end

local function targetSpecificEject(id)
    if not targetPlayer or not targetCharacter then return true end
    while alive(id) and targetStillValid() and getTargetInVehicle(targetCharacter) do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        targetVehicle=getVehicleNearRoot(targetRoot)
        if not targetVehicle or not targetVehicle.Parent then
            return false
        end
        if not setupFlight() then return false end
        local d=(rootPart.Position-targetRoot.Position).Magnitude
        if d>Config.TargetLockDistance then
            local delta=targetRoot.Position-rootPart.Position
            bodyVelocity.Velocity=delta.Unit*Config.TargetApproachSpeed
            bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,targetRoot.Position)
        else
            bodyVelocity.Velocity=Vector3.zero
            clearPhysicsRep()
            pcall(function()
                sethiddenproperty(rootPart,"PhysicsRepRootPart",targetRoot)
            end)
            rootPart.CFrame=targetRoot.CFrame*Config.TargetTpOffset
        end
        local specs=UI and UI.CircleAction and UI.CircleAction.Specs
        if specs then
            for _,spec in pairs(specs) do
                local match=false
                if spec.Part and spec.Part:IsDescendantOf(targetVehicle) then
                    match=true
                elseif spec.Text then
                    local t=tostring(spec.Text):lower()
                    if (t:find("eject") or t:find("passenger")) and targetVehicle:IsAncestorOf(spec.Part or targetVehicle) then
                        match=true
                    end
                end
                if match then
                    pcall(function() spec:Callback(true) end)
                end
            end
        end
        task.wait(0.15)
    end
    clearPhysicsRep()
    return alive(id) and targetCharacter and not getTargetInVehicle(targetCharacter)
end

local function tirePop(id)
    if not targetStillValid() then return false end
    targetVehicle=getVehicleNearRoot(targetRoot)
    if not targetVehicle then return false end
    local initialPop=targetVehicle:GetAttribute("VehicleTiresLastPop")
    local token=targetLoopToken+1
    targetLoopToken=token
    clearFlight()
    while alive(id) and token==targetLoopToken and targetStillValid() do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        if not getTargetInVehicle(targetCharacter) then
            return "exited"
        end
        targetVehicle=getVehicleNearRoot(targetRoot)
        if not targetVehicle then return false end
        pcall(function()
            sethiddenproperty(rootPart,"PhysicsRepRootPart",targetRoot)
        end)
        rootPart.CFrame=targetRoot.CFrame*Config.TargetTpOffset
        local newPop=targetVehicle:GetAttribute("VehicleTiresLastPop")
        if newPop~=initialPop then
            clearPhysicsRep()
            return true
        end
        task.wait(Config.TirePopCheckDelay)
    end
    clearPhysicsRep()
    return false
end

local function arrestTarget(id)
    if not targetStillValid() then return false end
    if getTargetInVehicle(targetCharacter) then
        if not targetSpecificEject(id) then
            return false
        end
    end
    EquipHandcuffs()
    local fn=findAttemptArrest()
    if not fn then return false end
    local start=os.clock()
    while alive(id) and targetStillValid() and os.clock()-start<Config.ArrestTimeout do
        targetCharacter=targetPlayer.Character
        targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return false end
        if getTargetInVehicle(targetCharacter) then
            targetSpecificEject(id)
        end
        if targetCharacter:GetAttribute("HasHandcuffs")==true then
            arrestedBlacklist[targetPlayer]=true
            clearPhysicsRep()
            clearFlight()
            print("[HANDCUFFED]",targetPlayer.Name)
            return true
        end
        local d=(rootPart.Position-targetRoot.Position).Magnitude
        if d>Config.TargetLockDistance then
            if not setupFlight() then return false end
            local delta=targetRoot.Position-rootPart.Position
            bodyVelocity.Velocity=delta.Unit*Config.TargetApproachSpeed
            bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,targetRoot.Position)
        else
            clearFlight()
            pcall(function()
                sethiddenproperty(rootPart,"PhysicsRepRootPart",targetRoot)
            end)
            rootPart.CFrame=targetRoot.CFrame*Config.TargetTpOffset
        end
        pcall(function() fn(targetPlayer) end)
        task.wait(0.1)
    end
    clearPhysicsRep()
    clearFlight()
    return false
end

local function vehicleUsable(v)
    return v and v.Parent and isPoliceVehicle(v) and getVehicleRoot(v) and not vehicleDriverOccupiedByOther(v)
end

local function findFallbackVehicle()
    local vehicles=Workspace:FindFirstChild("Vehicles")
    if not vehicles or not rootPart then return nil end
    local best,bestDist=nil,math.huge
    for _,v in ipairs(vehicles:GetChildren()) do
        if validLocalVehicle(v) then
            local r=getVehicleRoot(v)
            if r then
                local d=(r.Position-rootPart.Position).Magnitude
                if d<bestDist then
                    bestDist=d
                    best=v
                end
            end
        end
    end
    return best
end

local function criminalNearby(pos)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp and p.Team and p.Team.Name=="Criminal" then
            local r=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if r and (r.Position-pos).Magnitude<Config.EnemySpawnClearance then
                return true
            end
        end
    end
    return false
end

local function spawnVehicle(kind,id)
    if not alive(id) then return nil end
    if criminalNearby(rootPart.Position) then return nil end
    clearFlight()
    local remote=ReplicatedStorage:FindFirstChild("GarageSpawnVehicle",true)
    if not remote then return nil end
    pcall(function() remote:FireServer("Chassis",kind) end)
    local untilTime=os.clock()+6
    while alive(id) and os.clock()<untilTime do
        updateRememberedCar()
        local v=findLocalVehicle()
        if v then return v end
        if rememberedCar and validLocalVehicle(rememberedCar) then return rememberedCar end
        task.wait(0.2)
    end
    return nil
end

local function returnToVehicle(id)
    if not alive(id) then return false end
    phase=10
    phaseRunning=true
    local saved=lastExitedVehicle
    if vehicleUsable(saved) then
        local r=getVehicleRoot(saved)
        local d=(r.Position-rootPart.Position).Magnitude
        if d<=Config.FallbackDistance then
            if not ascendTo(math.max(rootPart.Position.Y, r.Position.Y+Config.ReturnHeight),id) then
                phaseRunning=false
                return false
            end
            local above=Vector3.new(r.Position.X,r.Position.Y+Config.ReturnHeight,r.Position.Z)
            if not setupFlight() then
                phaseRunning=false
                return false
            end
            while alive(id) and (Vector3.new(rootPart.Position.X,0,rootPart.Position.Z)-Vector3.new(above.X,0,above.Z)).Magnitude>6 do
                local flat=Vector3.new(above.X-rootPart.Position.X,0,above.Z-rootPart.Position.Z)
                bodyVelocity.Velocity=flat.Unit*Config.CruiseSpeed
                bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,above)
                task.wait()
            end
            clearFlight()
            if not descendTo(r.Position.Y+8,id) then
                phaseRunning=false
                return false
            end
            if enterVehicle(saved,id) then
                currentVehicle=saved
                phaseRunning=false
                return true
            end
        end
    end
    phase=10
    if not ascendTo(rootPart.Position.Y+100,id) then
        phaseRunning=false
        return false
    end
    local startPos=rootPart.Position
    local away=Vector3.new(startPos.X+Config.FallbackAwayDistance,startPos.Y,startPos.Z)
    if not moveToPosition(away,Config.CruiseSpeed,id) then
        phaseRunning=false
        return false
    end
    clearFlight()
    if criminalNearby(rootPart.Position) then
        phaseRunning=false
        return false
    end
    local vehicle=findFallbackVehicle()
    if not vehicle then
        vehicle=spawnVehicle("Camaro",id)
    end
    if not vehicle then
        vehicle=spawnVehicle("Jeep",id)
    end
    if not vehicle then
        phaseRunning=false
        return false
    end
    local vr=getVehicleRoot(vehicle)
    if not vr then
        phaseRunning=false
        return false
    end
    if not ascendTo(math.max(rootPart.Position.Y,vr.Position.Y+100),id) then
        phaseRunning=false
        return false
    end
    if not setupFlight() then
        phaseRunning=false
        return false
    end
    while alive(id) and (Vector3.new(rootPart.Position.X,0,rootPart.Position.Z)-Vector3.new(vr.Position.X,0,vr.Position.Z)).Magnitude>6 do
        local flat=Vector3.new(vr.Position.X-rootPart.Position.X,0,vr.Position.Z-rootPart.Position.Z)
        if flat.Magnitude>0 then
            bodyVelocity.Velocity=flat.Unit*Config.CruiseSpeed
            bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,vr.Position)
        end
        task.wait()
    end
    clearFlight()
    if not descendTo(vr.Position.Y+8,id) then
        phaseRunning=false
        return false
    end
    local ok=enterVehicle(vehicle,id)
    phaseRunning=false
    return ok
end

local function phase4to9(id)
    if not alive(id) or phase~=3 or not getInVehicle() then return false end
    phase=4
    phaseRunning=true
    local p=findTarget()
    if not p or not setTarget(p) then
        phaseRunning=false
        return false
    end
    phase=5
    if not cruiseAboveTarget(id) then
        clearTarget()
        phaseRunning=false
        return false
    end
    if not targetStillValid() then
        clearTarget()
        phaseRunning=false
        return false
    end
    targetCharacter=targetPlayer.Character
    targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    if getTargetInVehicle(targetCharacter) then
        phase=6
        local d=(rootPart.Position-targetRoot.Position).Magnitude
        while alive(id) and targetStillValid() and d>Config.TargetEngageDistance do
            targetCharacter=targetPlayer.Character
            targetRoot=targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetRoot then break end
            local desired=Vector3.new(targetRoot.Position.X,rootPart.Position.Y,targetRoot.Position.Z)
            local delta=desired-rootPart.Position
            if delta.Magnitude>0 then
                bodyVelocity.Velocity=delta.Unit*Config.CruiseSpeed
                bodyGyro.CFrame=CFrame.lookAt(rootPart.Position,desired)
            end
            d=(rootPart.Position-targetRoot.Position).Magnitude
            task.wait()
        end
        clearFlight()
        if not alive(id) or not targetStillValid() then
            clearTarget()
            phaseRunning=false
            return false
        end
        local pop=tirePop(id)
        if pop=="exited" then
            lastExitedVehicle=currentVehicle
        elseif pop~=true then
            clearTarget()
            phaseRunning=false
            return false
        else
            lastExitedVehicle=currentVehicle
        end
    else
        phase=6
        if not descendTrackTarget(id) then
            clearTarget()
            phaseRunning=false
            return false
        end
        lastExitedVehicle=currentVehicle
    end
    phase=7
    clearFlight()
    clearPhysicsRep()
    if not unmount(id) then
        clearTarget()
        phaseRunning=false
        return false
    end
    currentVehicle=nil
    EquipHandcuffs()
    if targetStillValid() then
        targetCharacter=targetPlayer.Character
        if getTargetInVehicle(targetCharacter) then
            targetSpecificEject(id)
        end
    end
    phase=8
    local arrested=arrestTarget(id)
    if arrested then
        phase=9
        clearFlight()
        clearPhysicsRep()
        local saved=lastExitedVehicle
        local returned=returnToVehicle(id)
        if returned then
            phase=11
            phaseRunning=false
            clearTarget()
            return true
        end
    end
    clearFlight()
    clearPhysicsRep()
    clearTarget()
    phaseRunning=false
    return false
end

local function runCycle()
    local id=cycleId
    if not alive(id) then return end
    if not phase1(id) then return end
    if not alive(id) then return end
    if not phase2(id) then return end
    if not alive(id) then return end
    if not phase3(id) then return end
    if not alive(id) then return end
    if phase4to9(id) then return end
    if alive(id) then
        phase=11
        phaseRunning=false
        clearFlight()
        clearPhysicsRep()
        clearTarget()
        if currentVehicle and getInVehicle() then
            ascendTo(rootPart.Position.Y+Config.TargetSearchHeight,id)
        end
    end
end

local function bindCharacter(char)
    clearConnections()
    resetCycle()
    character=char
    humanoid=char:WaitForChild("Humanoid")
    rootPart=char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    local id=cycleId
    table.insert(connections,humanoid.Died:Connect(function()
        if id==cycleId then
            resetCycle()
            clearConnections()
        end
    end))
    table.insert(connections,char.AncestryChanged:Connect(function(_,parent)
        if not parent and id==cycleId then
            resetCycle()
            clearConnections()
        end
    end))
    table.insert(connections,char:GetAttributeChangedSignal("InVehicle"):Connect(function()
        if id~=cycleId then return end
    end))
    task.spawn(function()
        task.wait(0.2)
        if alive(id) then
            runCycle()
        end
    end)
end

if lp.Character then
    task.spawn(function()
        bindCharacter(lp.Character)
    end)
end

lp.CharacterAdded:Connect(function(char)
    task.wait()
    bindCharacter(char)
end)
