local Trail = Class:extend()

function Trail:new(type, x, y, opts)
    self.type = type
    self.x, self.y = x, y
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end
    self.dead = false

    timer:tween(0.3, self, {r = 0}, 'linear', function()
        self.dead = true
    end)
end

function Trail:update(dt)
end

function Trail:draw()
    love.graphics.circle('fill', self.x, self.y, self.r + randomp(-2.5, 2.5))
end

return Trail
