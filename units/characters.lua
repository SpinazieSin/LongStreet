--
local default = {}

--
local pim_dialogue = {}
pim_dialogue[1] = {
    "Why are you talking to me?",
    "..."
}

--
local lampost_dialogue = {}
lampost_dialogue[1] = {
    "...",
    "....",
    ".....",
    "......",
    "... g o  a w a y."
}
lampost_dialogue[2] = {
    "y o u  a r e  s m a l l."
}

--
local bike_dialogue = {}
bike_dialogue[1] = {
    "I have a flat tire."
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

    -- lampost
    if character == 3 then
        return lampost_dialogue
    end

    -- bike
    if character == 4 then
        return bike_dialogue
    end
end

