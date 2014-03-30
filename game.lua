require "enemy"

function love.turris.newGame()
	local o = {}
	o.map = {}
	o.ground = {}
	o.tower = {}
	o.enemies = {}
	o.enemyCount = 1
	o.dayTime = 0
	local creepImg = G.newImage("gfx/creep00_diffuse.png")
	for i=1, o.enemyCount do
		o.enemies[i]= love.turris.newEnemy(creepImg)
		o.enemies[i].x = (i-1)*60
		o.enemies[i].y = 300
	end
	o.init = function()
		o.newGround("gfx/ground01.png")
		o.newTower("gfx/tower00")
		o.newTower("gfx/tower01")
		o.newTower("gfx/tower02")
		o.newTower("gfx/tower03")
		o.setMap(turMap.getMap())
		o.map.setState(2, 2, 1)
		o.map.setState(2, 3, 1)
		o.map.setState(2, 9, 2)
		o.map.setState(7, 3, 3)
		local baseX = math.floor(o.map.width / 2 + 0.5)
		local baseY = math.floor(o.map.height / 2 + 0.5)
		o.map.setState(baseX, baseY, 4)
	end
	o.update = function(dt)
		o.dayTime = o.dayTime + dt * 0.2
		for i = 1, o.enemyCount do
			o.enemies[i].x = o.enemies[i].x+o.enemies[i].xVel*dt
		end
	end
	o.drawMap = function()
		local dayTime = math.abs(math.sin(o.dayTime))
		lightWorld.setAmbientColor(dayTime * 239 + 15, dayTime * 191 + 31, dayTime * 175 + 63)

		lightMouse.setPosition(love.mouse.getX(), love.mouse.getY(), 63)
		lightWorld.update()

		if o.map and o.map.width and o.map.height then
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					G.setColor(255, 255, 255)
					G.draw(o.ground[1], i * o.map.tileWidth, k * o.map.tileHeight)
				end
			end
			lightWorld.drawShadow()
			for i = 0, o.map.width - 1 do
				for k = 0, o.map.height - 1 do
					if o.map.map[i + 1][k + 1] > 0 then
						local img = o.tower[o.map.map[i + 1][k + 1]].img
						G.setColor(255, 255, 255)
						G.draw(img, i * o.map.tileWidth, k * o.map.tileHeight - (img:getHeight() - o.map.tileHeight))
					end
				end
			end
			lightWorld.drawPixelShadow()
			lightWorld.drawGlow()
		end
	end
	o.draw = function()
		o.drawMap()
		o.drawEnemies()
		o.drawPaths()
	end
	o.drawPaths = function()
	--    for i = 1, o.entryCount do
	--      local entry = enemyEntrances[i]
	--    end
	--local mx, my = love.mouse.getPosition()  -- current position of the mouse
	--G.line(0,300, mx, my)
	end
	o.drawEnemies = function()
		for i = 1, o.enemyCount do
			local e = o.enemies[i]
			local x = e.x
			local y = e.y
			local img = e.img
			G.setColor(255, 255, 255)
			G.draw(img, x, y, 0, -1.0 / img:getWidth() * 40, 1.0 / img:getHeight() * 32)
			-- G.circle("fill", o.enemies[i].x, o.enemies[i].y, 16, 16 )
		end
	end
	o.newGround = function(img)
		o.ground[#o.ground + 1] = G.newImage(img)
		return o.ground[#o.ground]
	end
	o.newTower = function(img)
		o.tower[#o.tower + 1] = love.turris.newTower(img)
		return o.tower[#o.tower]
	end
	o.getTower = function(n)
		return o.tower[n]
	end
	o.setMap = function(map)
		o.map = map
	end

	-- set font
	font = G.newImageFont("gfx/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	G.setFont(font)
	
	-- create light world
	lightWorld = love.light.newWorld()
	lightWorld.setNormalInvert(true)
	lightWorld.setAmbientColor(15, 15, 31)
	lightWorld.setRefractionStrength(32.0)

	-- create light
	lightMouse = lightWorld.newLight(0, 0, 31, 191, 63, 300)
	--lightMouse.setGlowStrength(0.3)
	--lightMouse.setSmooth(0.01)
	lightMouse.setRange(300)

	return o
end