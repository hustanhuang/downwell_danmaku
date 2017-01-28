Class = require "classic/classic"
GameObject = require "GameObject"
Trail = require "Trail"
Bullet = require "Bullet"
Timer = require "hump/timer"

function loadResource()
    bgm = love.audio.newSource("music/bgm.mp3", "static")
    bgm:setLooping(true)
end

function love.load(arg)
    loadResource()

    timer = Timer()
    game_objects = {}

    main_canvas = love.graphics.newCanvas(320, 240)
    main_canvas:setFilter("nearest", "nearest")
    game_object_canvas = love.graphics.newCanvas(320, 240)
    game_object_canvas:setFilter("nearest", "nearest")
    bullet_canvas = love.graphics.newCanvas(320, 240)
    bullet_canvas:setFilter("nearest", "nearest")
    trail_canvas = love.graphics.newCanvas(320, 240)
    trail_canvas:setFilter("nearest", "nearest")

    love.window.setMode(960, 720)

    love.mouse.setVisible(false)
    love.graphics.setLineStyle('rough')

    player = createGameObject('GameObject', 160, 220)

    hit_counter = 0

    love.audio.play(bgm)
end

function love.update(dt)
    if love.keyboard.isDown('p') then
        dt = dt / 10
    end

    timer:update(dt)

    if math.random(1, 5) > 3 then
        createGameObject("Bullet", 320, math.random(0, 240))
    end

    for i = #game_objects, 1, -1 do
        local game_object = game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            table.remove(game_objects, i)
        end
    end
end

function love.draw()
    -- trail canvas
    love.graphics.setCanvas(trail_canvas)
    love.graphics.clear()

    love.graphics.setColor(128, 64, 255)
    for _, game_object in ipairs(game_objects) do
        if game_object.type == 'Trail' then
            game_object:draw()
        end
    end
    love.graphics.setColor(255, 255, 255)

    love.graphics.setBlendMode('subtract')
    for i = 0, 240, 2 do
        love.graphics.line(0, i, 320, i)
    end

    love.graphics.setBlendMode('alpha')
    love.graphics.setCanvas()

    -- bullet canvas
    love.graphics.setCanvas(bullet_canvas)
    love.graphics.clear()

    for _, game_object in ipairs(game_objects) do
        if game_object.type == 'Bullet' then
            game_object:draw()
        end
    end

    love.graphics.setCanvas()

    -- game_object canvas
    love.graphics.setCanvas(game_object_canvas)
    love.graphics.clear()

    for _, game_object in ipairs(game_objects) do
        if game_object.type == 'GameObject' then
            game_object:draw()
        end
    end

    love.graphics.setCanvas()

    -- main canvas
    love.graphics.setCanvas(main_canvas)
    love.graphics.clear()

    love.graphics.draw(trail_canvas, 0, 0)
    love.graphics.draw(bullet_canvas, 0, 0)
    love.graphics.draw(game_object_canvas, 0, 0)

    love.graphics.setCanvas()

    -- draw canvases
    love.graphics.draw(main_canvas, 0, 0, 0, 3, 3)

    -- display hud
    love.graphics.print("fps = "..love.timer.getFPS(), 16, 16)

    love.graphics.print("time = "..os.date(), 320, 16)
    love.graphics.print("hit_counter = "..hit_counter, 320, 32)
end

function createGameObject(type, x, y, opts)
    local game_object = _G[type](type, x, y, opts)
    table.insert(game_objects, game_object)
    return game_object
end

function randomp(min, max)
    return love.math.random()*(max - min) + min
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'j' then
        timer:tween(0.3, player, {r = 0}, 'linear', function()
            timer:tween(0.3, player, {r = player.original_r}, 'linear', nil)
        end)
    end

    if key == 'p' then
        bgm:setPitch(0.25)
    end
end

function love.keyreleased(key)
    if key == 'p' then
        bgm:setPitch(1)
    end
end
