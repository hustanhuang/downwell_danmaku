local Bullet = Class:extend()

function Bullet:new(type, x, y, opts)
    self.type = type
    self.x, self.y = x, y
    self.v = math.random(80, 320)
    local opts = opts or {}
    for k,v in pairs(opts) do
        self[k] = v
    end
    self.dead = false

    self.hit = false
end

function Bullet:update(dt)
    self.x = self.x - self.v * dt
    if not self.hit and
        math.sqrt(math.pow(self.x - player.x, 2) +
                  math.pow(self.y - player.y, 2)) < player.r then
        self.hit = true
        self.v = self.v * 8
        hit_counter = hit_counter + 1
    end
end

function Bullet:draw()
    if self.hit then
        love.graphics.setColor(255, 0, 0)
    end

    love.graphics.rectangle("fill", self.x - 2, self.y, 4, 1)

    love.graphics.setColor(255, 255, 255)
end

return Bullet
