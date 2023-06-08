local Vector = {}
local mt = {}
mt.__index = Vector

function Vector.new(coordinates: { number })
	return setmetatable(coordinates, mt)
end

function Vector.isVector(v)
	return getmetatable(v) == mt
end

function Vector.Dot(a, b)
	assert(Vector.isVector(a))
	assert(Vector.isVector(b))
	assert(#a == #b)

	local sum = 0

	for i = 1, #a do
		sum += a[i] * b[i]
	end

	return sum
end

function Vector.Cross(a, b)
	assert(Vector.isVector(a))
	assert(Vector.isVector(b))
	assert(#a == 3 and #b == 3)

	return Vector.new({
		a[2] * b[3] - a[3] * b[2],
		a[3] * b[1] - a[1] * b[3],
		a[1] * b[2] - a[2] * b[1],
	})
end

function Vector.Magnitude(v)
	local sum = 0

	for _, coordinate in v do
		sum += coordinate * coordinate
	end

	return math.sqrt(sum)
end

function mt.__add(a, b)
	assert(Vector.isVector(a))
	assert(Vector.isVector(b))
	assert(#a == #b)

	local coordinates = {}

	for i = 1, #a do
		coordinates[i] = a[i] + b[i]
	end

	return Vector.new(coordinates)
end

function mt.__sub(a, b)
	assert(Vector.isVector(a))
	assert(Vector.isVector(b))
	assert(#a == #b)

	local coordinates = {}

	for i = 1, #a do
		coordinates[i] = a[i] - b[i]
	end

	return Vector.new(coordinates)
end

function mt.__mul(a, b)
	if typeof(a) == "number" and Vector.isVector(b) then
		local coordinates = {}

		for i = 1, #b do
			coordinates[i] = a * b[i]
		end

		return Vector.new(coordinates)
	elseif Vector.isVector(a) and typeof(b) == "number" then
		local coordinates = {}

		for i = 1, #a do
			coordinates[i] = b * a[i]
		end

		return Vector.new(coordinates)
	elseif Vector.isVector(a) and Vector.isVector(b) then
		local coordinates = {}

		for i = 1, #a do
			coordinates[i] = a[i] * b[i]
		end

		return Vector.new(coordinates)
	else
		error("Bad multiplication")
	end
end

function mt.__unm(v)
	local coordinates = {}

	for i = 1, #v do
		coordinates[i] = -v[i]
	end

	return Vector.new(coordinates)
end

function mt.__tostring(v)
	return "(" .. table.concat(v, ", ") .. ")"
end

return Vector
