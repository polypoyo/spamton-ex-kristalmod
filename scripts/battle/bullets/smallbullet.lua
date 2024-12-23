local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/smallbullet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self:setScale(2)

    self.rotation=0

end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)

    -- spin 3 full rotations per second
    self.rotation=self.rotation+math.rad((360*3)*DT)

end

return SmallBullet