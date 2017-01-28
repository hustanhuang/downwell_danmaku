local GameObject = Class:extend()

function GameObject:new(type, x, y, opts)
    self.type = type
    self.r = 8
    self.x, self.y = x, y
    self.vx, self.vy = 0, 0
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end
    self.dead = false

    self.original_r = self.r

    timer:every(0.01, function()
        createGameObject('Trail', self.x, self.y, {r = self.r})
    end)
end

function GameObject:update(dt)
    local impulse = 50
    if love.keyboard.isDown('w') then
        self.vy = self.vy - impulse
    end

    if love.keyboard.isDown('a') then
        self.vx = self.vx - impulse
    elseif love.keyboard.isDown('d') then
        self.vx = self.vx + impulse
    end

    -- damping
    self.vx = self.vx * 0.95
    self.vy = self.vy * 0.99
    -- gravity
    if self.y ~= 240 - self.r then
        self.vy = self.vy + 500 * dt
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.x < -self.r then
        self.x = 320 + self.r
    elseif self.x > 320 + self.r then
        self.x = -self.r
    end

    if self.y < self.r then
        self.y = self.r
        self.vy = 0
    elseif self.y > 240 - self.r then
        self.y = 240 - self.r
        self.vy = -self.vy
    end
end

function GameObject:draw()
    love.graphics.circle("fill", self.x + randomp(-1, 1), self.y + randomp(-1, 1), self.r)
end

return GameObject
