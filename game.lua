-- title:  tic80 bullet hell prototype
-- author: christopher stokes
-- desc:   simple bullet hell engine + demo
-- script: lua

-- engine code
player, entities, enemies, bullets, particles = {}, {}, {}, {}, {}
time = 0

function Particle(x, y, wid, hei, col, life, dir)
	local p = {}
	p.x, p.y, p.wid, p.hei, p.col = x, y, wid, hei, col 
	p.dir, p.life = dir or {0, 0}, life or 15

	function p:update()
		self.x = self.x + self.dir[1]
		self.y = self.y + self.dir[2]

		self.life = self.life - 1

		if self.life < 0 then table.remove(particles, self) end
	end

	function p:draw()
		if self.wid == 1 and self.hei == 1 then
			pix(self.x, self.y, self.col)
		elseif self.wid == self.hei then
			circ(self.x, self.y, self.wid/2, self.col)
		else
			rect(x, y, self.wid, self.hei, self.col)
		end
	end

	table.insert(particles, p)
	return p
end

function Bullet(x, y, dx, dy, dia, col)
	local b = {}
	b.x, b.y, b.dx, b.dy, b.dia, b.col = x, y, dx, dy, dia, col

	function b:update()
		self.x = self.x + self.dx
		self.y = self.y + self.dy
	end

	function b:draw()
		circ(self.x, self.y, self.dia, self.col)
	end

	return b
end

function Animation(frames, timing, t)
	local a = {}
	a.frames, a.timing, a.time = frames, timing, t
	a.currentFrame = 1

	function a:update () 
		if (time - self.time) % timing == 0 then
			if self.currentFrame < #frames then
				self.currentFrame = self.currentFrame + 1
			else
				self.currentFrame = 1
			end
		end
	end

	return a
end

function Entity(x, y, wid, hei, animations)
	local e = {}
	e.x, e.y, e.wid, e.hei, e.animations = x, y, wid, hei, animations
	e.currentAnimation = "idle"
	
	function e:draw ()
		self.animations[self.currentAnimation]:update()
		local anims, currAnim = self.animations, self.currentAnimation
		local currentFrame = anims[currAnim].currentFrame
		local frame = anims[currAnim].frames[currentFrame]
		spr(frame, self.x, self.y, 0, 1, 0, 0, self.wid/8, self.hei/8)
	end

	table.insert(entities, e)
	return e
end

-- game code

player = Entity(96, 96, 16, 16, {})
player.animations.idle = Animation({1, 3}, 30, time)

function player:update()
	if btn(0) then self.y=self.y-1 end
	if btn(1) then self.y=self.y+1 end
	if btn(2) then self.x=self.x-1 end
	if btn(3) then self.x=self.x+1 end
end


-- player["x"] = 96
-- player["y"] = 96

-- player["sp"] = 1

function TIC()

	cls(0)

	for e=#entities, 1, -1 do
		entities[e]:update()
		entities[e]:draw()
	end

	for b=#bullets, 1, -1 do
		bullets[b]:update()
		bullets[b]:draw()
	end

	-- spr(player["sp"]+time%60//30*2,player["x"],player["y"],0,1,0,0,2,2)
	time=time+1
end

-- <TILES>
-- 001:00000000000000ff000000ff000000ff000000f000000fff0000ffff0000ffff
-- 002:00000000f0000000f0000000f000000000000000f0000000ff000000ff000000
-- 003:00000000000000ff000000ff000000ff000000f000000fff0000ffff0000ffff
-- 004:00000000f0000000f0000000f000000000000000f0000000ff000000ff000000
-- 017:0000ffff0000ffff0000ff0000000f0000000f0000000f0000000f0000000f00
-- 018:ff000000ff000000ff000000f0000000f0000000f0000000f0000000f0000000
-- 019:0000ffff0000ffff0000ff0000000f0000000f0000000f0000000f0000000f00
-- 020:ff000000ff000000ff000000f0000000f0000000f0000000f0000000f0000000
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

