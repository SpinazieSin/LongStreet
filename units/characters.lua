local default = {}

local pim_dialogue = {}
pim_dialogue[1] = {
    "Why are you talking to me?",
    "..."
}

function getdialogue(character)
    -- nothing
    if character == 1 then
        return default
    end

    -- pim
    if character == 2 then
        return pim_dialogue
    end
end

