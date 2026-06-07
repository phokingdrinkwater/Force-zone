#version 2

respectGame = GetBoolParam("respect-game-starting", true)
waittime = GetFloatParam("wait", 3)
speed = GetFloatParam("speed", 1)
offset = GetFloatParam("offset", 0)

function server.init()
    joint = FindJoint("") -- finds the joint on the Anc voxbox
    min, max = GetJointLimits(joint)
    middle = (min + max) / 2
    scale = max - middle
    time = 0 + offset
    waitTimer = 0
    waitCooldown = 0.5
end

function server.tick(dt)
    local gameStarted = GetBool("level.gameStarted", false)
    if (respectGame and not gameStarted) then return end

    waitTimer = waitTimer - dt
    if waitTimer <= 0 then
        waitCooldown = waitCooldown - dt
        local step = (5 * math.pi) / 2
        time = time + (dt * speed)
        local target = math.sin((time - step) / 3) * scale
        SetJointMotorTarget(joint, middle + target)
        if (isWithin(GetJointMovement(joint), max, 0.1, 0.1) or isWithin(GetJointMovement(joint), min, 0.1, 0.1)) and (waitCooldown <= 0) then
            waitTimer = waittime
            waitCooldown = 1
        end
    end
end

function isWithin(amount, target, min, max)
    if (amount <= target + max) and (amount >= target - math.abs(min)) then
        return true
    end
    return false
end
