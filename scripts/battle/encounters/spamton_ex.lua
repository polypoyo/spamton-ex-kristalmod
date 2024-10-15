---@class Sencounter: Encounter
local Sencounter, super = Class(Encounter)

local function triangle(t)
    return ((math.abs(((t*100) % 100) - 50))/50)-.5
end

function Sencounter:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "[face:susie/teeth_b][voice:susie]* Kris, what the hell??\nWe're going backwards?"

    -- Battle music ("battle" is rude buster)
    self.music = nil--
    self.music = "battle"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self:addEnemy("spamton_ex", 511, 259)

    self.time_left = 715

    self.krishead = Sprite("party/kris/icon/head",68,7)
    self.turns = 0
    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function Sencounter:onBattleStart()
    local reference = Sprite("reference")
    reference.alpha = .5
    reference.layer = -1000
    reference:setScale(0.71)
    Game.battle:addChild(reference)
    Game.battle:addChild(self.krishead)
end

function Sencounter:onActionsStart()
    self.turns = self.turns + 1
end

function Sencounter:beforeStateChange(old,new) 
    if new == "ENEMYDIALOGUE" and #Game.battle.enemies > 0 then
		local cutscene = Game.battle:startCutscene("spamton_ex.master")
		cutscene:after(function()
            Game.battle:setState("DIALOGUEEND")
		end)
	end
end
function Sencounter:update()
    super.update(self)
    self.time_left = self.time_left - DT
    self.krishead.x = 68 + ((715 - self.time_left)/1.35)
    if self.time_left < 0 then
        Assets.playSound("drive")
        Game:gameOver()
        -- Game.battle.music:seek(12)
        -- self.time_left = self.time_left + .1
    end
end

function Sencounter:createSoul(x,y,color)
    return YellowSoul(x,y)
end

function Sencounter:draw(fade)
    super:draw(self, fade)
    if not Game.battle.seen_encounter_text then return end -- janky ass way to do this check but whatever
    local font = Assets.getFont("main", 16)
    ---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        "Time left:\n    ".. (string.format("%.2f", self.time_left)), 0, 0
    )
    
end

return Sencounter