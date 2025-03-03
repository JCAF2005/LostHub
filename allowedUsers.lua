local allowedUsers {}

-- User Authentication Configuration
local allowedUsers = {3925482109, 470684482}

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

return allowedUsers
