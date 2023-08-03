-- Performs 3D affine transformations using a 4D matrix in homogeneous coordinates

local Matrix = require("Matrix")
local Vector = require("Vector")

local AffineMap = setmetatable({}, Matrix)
AffineMap.__index = AffineMap

-- Mimics CFrame.new(x, y, z)
function AffineMap.new(x, y, z)
	return setmetatable(
		Matrix.new({
			{ 1, 0, 0, x },
			{ 0, 1, 0, y },
			{ 0, 0, 1, z },
			{ 0, 0, 0, 1 },
		}),
		AffineMap
	)
end

-- Mimics CFrame.fromMatrix(pos, right, up, back)
function AffineMap.fromMatrix(pos, right, up, back)
	return setmetatable(
		Matrix.new({
			{ right[1], up[1], back[1], pos[1] },
			{ right[2], up[2], back[2], pos[2] },
			{ right[3], up[3], back[3], pos[3] },
			{ 0, 0, 0, 1 },
		}),
		AffineMap
	)
end

function AffineMap.isAffineMap(affineMap)
	-- Jank: AffineMap inherits the __eq from Matrix, but we don't want to
	-- compare AffineMap as a matrix. This lets us compare it as a table.
	return rawequal(getmetatable(affineMap), AffineMap)
end

function AffineMap:ToCFrame()
	-- stylua: ignore
	return CFrame.new(
		-- Position
		self[1][4], self[2][4], self[3][4],
		-- First row
		self[1][1], self[1][2], self[1][3],
		-- Second row
		self[2][1], self[2][2], self[2][3],
		-- -Third row
		self[3][1], self[3][2], self[3][3]
	)
end

function AffineMap.__mul(a, b)
	-- AffineMap * AffineMap
	if AffineMap.isAffineMap(a) and AffineMap.isAffineMap(b) then
		return setmetatable(Matrix.__mul(a, b), AffineMap)
	else
		return Matrix.__mul(a, b)
	end
end

return AffineMap
