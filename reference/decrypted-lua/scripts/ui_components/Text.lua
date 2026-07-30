
---------------------------------------------
----- Text - component ripped from Rio and modified
----- to fit in Frame - baseclass
--------------------------------------------

Text = Frame:new()

function Text:init()
	self.text = self.text or ""
	self.group = self.group or "TEXTS_BASIC"
	self.textBoxSize = self.textBoxSize or gamelua.screenWidth
	self.hanchor = self.hanchor or "HCENTER"
	self.vanchor = self.vanchor or "VCENTER"
	self.font = self.font or "FONT_BASIC"
	self.scaleX = 1
	self.scaleY = 1
	self.visible = true
	self.floorCoordinates = true
	
	
	gamelua.setFont(self.font)
	
--	self.x = 0
--	self.y = 0
	local textContent = self.text
	if self.group ~= "" then
		textContent = _G.res.getString(self.group, self.text)
	end
	self.width = _G.res.getStringWidth(textContent)
end

function Text:clip()
	local scaleX, scaleY = self.scaleX or 1, self.scaleY or 1
	
	gamelua.setFont(self.font)
	gamelua.clipText(self.group, self.text, self.textBoxSize / scaleX)
	-- local xs, ys = self.xs or 1, self.ys or 1
	
	local fl = _G.res.getFontLeading() * scaleY
	self.textBlockHeight = #(gamelua.clippedText.lines) * fl
	self.widestLine = gamelua.clippedText.widestLine
	self.lines = {}
	
	local k = 1
	local yCorrection = 0
	if self.vanchor == "VCENTER" then
		yCorrection = (-self.textBlockHeight / 2) + (fl / 2)
	elseif self.vanchor == "BOTTOM" then
		yCorrection = -self.textBlockHeight + fl
	end
	while  k <= #gamelua.clippedText.lines do
		local l = gamelua.clippedText.lines[k]		-- x = self.localX, y = self.localY + yCorrection,
		local tmpItm = Text:new({font = self.font, text = l, y = yCorrection, scaleX = self.scaleX, scaleY = self.scaleY, hanchor = self.hanchor, vanchor = self.vanchor, height = fl})
		_G.table.insert(self.lines, tmpItm)
		k = k + 1
		yCorrection = yCorrection + fl
	end
	self.clipped = true
end

function Text:checkBounds(xCoord, yCoord)
	local w = _G.res.getStringWidth(_G.res.getString(self.group, self.text))
	if w > self.width then
		self.width = w
	end
	
	if self.clipped then
		for i = 1, #self.lines do
			if self.lines[i]:checkBounds(xCoord, yCoord) then
				return true
			end
		end
	else	
		local fl = _G.res.getFontLeading()
		local xCorrection, yCorrection = self:getCorrectionParams()
	
		return yCoord >= self.y + yCorrection and yCoord <= self.y + yCorrection + fl and
			xCoord >= self.x + xCorrection and xCoord <= self.x + xCorrection + self.width
	end
end

function Text:getCorrectionParams()
		local fl = _G.res.getFontLeading()
		local xCorrection, yCorrection = 0, 0
		if self.hanchor == "HCENTER" then
			xCorrection = -self.width / 2
		elseif self.hanchor == "RIGHT" then
			xCorrection = -self.width
		elseif self.hanchor == "LEFT" then
			xCorrection = 0
		end

		if self.vanchor == "VCENTER" then
			yCorrection = -fl / 2
		elseif self.vanchor == "BOTTOM" then
			yCorrection = -fl
		elseif self.vanchor == "TOP" then
			yCorrection = 0
		end
	return xCorrection, yCorrection
end

function Text:drawFast(x, y)
	gamelua.setFont(self.font)
	_G.res.drawString(self.group, self.text, _G.math.floor(self.x + x), _G.math.floor(self.y + y), self.hanchor, self.vanchor)
end

--[[
function Text:draw(x,y,scaleX,scaleY,angle)
	
	
	-- gamelua.print("\n text scales " ..self.name .. " " .. self.scaleX .. " " .. scaleX)
	x = x or 0
	y = y or 0
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	local finalScaleX = scaleX * self.scaleX
	local finalScaleY = scaleY * self.scaleY
	
	if self.visible ~= false then
		if(self.font ~= nil) then
				gamelua.setFont(self.font)
			else
				gamelua.setFont("FONT_BASIC")
		end

		if self.clipped then
			for i = 1, #self.lines do
				self.lines[i].scaleX = self.scaleX
				self.lines[i].scaleY = self.scaleY
				--if self.lines[i].y + y < gamelua.screenHeight + self.lines[i].height and self.lines[i].y + y > - self.lines[i].height then					
					self.lines[i]:draw(x + self.x, y + self.y, scaleX, scaleY, angle)
				--end
			end
		else
			local xCoord, yCoord = self.x + x,self.y + y
			-- local xs, ys = self.xs or 1, self.ys or 1
			local xCorrection, yCorrection = self:getCorrectionParams()
			
			-- local angle = self.angle or 0
			local px, py = self.pivotX or 0, self.pivotY or 0
			px = self.width / 2 
			py = _G.res.getFontLeading() / 2
			--print("font leading = "..py)
			local rotPx, rotPy = self.rotationPivotX or 0, self.rotationPivotY or 0
			if(self.floorCoordinates ~= false) then
				xCoord = _G.math.floor(xCoord / finalScaleX)
				yCoord = _G.math.floor(yCoord / finalScaleY)
			
			else
				xCoord = (xCoord / finalScaleX)
				yCoord = (yCoord / finalScaleY)			
			end
			if debugDraw then
				gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)			
				gamelua.drawRect(0.5, 1, 1, 0.5, self.x + xCorrection, self.y + yCorrection, self.x + xCorrection + self.width, self.y + yCorrection + self:getFontLeading(), true)
			end
			
			if self.alpha == nil then
				gamelua.setRenderState(0, 0, finalScaleX,finalScaleY, angle, rotPx, rotPy)	
			else
				gamelua.setRenderState(0, 0, finalScaleX,finalScaleY, angle, rotPx, rotPy, self.alpha)							
			end
			
			
			gamelua.setRenderState(0, 0, finalScaleX,finalScaleY, angle, rotPx, rotPy)			
			_G.res.drawString(self.group, self.text, xCoord, yCoord, self.hanchor, self.vanchor)	

			if self.alpha ~= nil then
				gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0, 1)	
			else
				gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
			end			
		end
	end
end
]]--

Text.draw = gamelua.drawUITextNative

function Text:getHeight()
	local scaleY = self.scaleY or 1
	if self.clipped then
		return (#self.lines) * self:getFontLeading() * scaleY		
	else
		return self:getFontLeading() * scaleY
	end
end

function Text:getWidth()
	return self.width
end

function Text:getFontLeading()
	--local tempFont = self.font
	gamelua.setFont(self.font)
	local h = _G.res.getFontLeading()
	--setFont(tempFont)
	return h
end

filename="Text.lua"
