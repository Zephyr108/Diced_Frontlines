local player = {
    class = "None"
}

function player.setClass(className)
    player.class = className
end

function player.getClass()
    return player.class
end

return player
