return {
    throwstring = function(cutscene, battler, enemy)
        local last_positions = {}

        local werewires = {enemy}
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            last_positions[enemy] = {x = enemy.x, y = enemy.y}
            enemy:slideTo(enemy.x, 502, 0.5)
        end

        cutscene:wait(0.5)

        local thrower = WerewireThrowAct(werewires)
        Game.battle:addChild(thrower)

        thrower:setup()

        cutscene:text("* Press [bind:menu] to throw, aim for the weakpoint!", {wait = false, advance = false})

        cutscene:wait(function()
            if Input.pressed("menu") then
                Input.clear("menu")
                return true
            end
        end)

        cutscene:text("", {wait = false})

        local hit = cutscene:wait(thrower:throw())

        thrower:clear()

        if hit == 0 then
            cutscene:text("* Missed!")
        else
            cutscene:text("* The strings greatly loosened!")
        end

        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            enemy:slideTo(last_positions[enemy].x, last_positions[enemy].y, 0.5)
        end

        cutscene:wait(0.5)

        enemy:addMercy(2 * hit)
        enemy.sprite:snapStrings(hit)
        enemy.sprite:setStringCount(math.max(0,(100-enemy.mercy)/2))
    end
}