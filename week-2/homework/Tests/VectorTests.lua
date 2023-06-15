--[[
	Sample unit tests.
	
	Not all test are implemented! You must implement some yourself, or they will
	fail.

	It is a good idea to add more test cases for each method, and to test code
	branches that you expect to fail (ex. VectorTests.CrossBadDimension).
--]]

local Vector = require("Vector")

local VectorTests = {}

function VectorTests.Zero()
	local zero = Vector.zero(10)

	assert(zero == Vector.new({ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }))
end

function VectorTests.Addition()
	local a = Vector.new({ 1, 2, 3, 4, 5 })
	local b = Vector.new({ 6, 7, 8, 9, 10 })

	assert(a + b == Vector.new({ 7, 9, 11, 13, 15 }))
end

function VectorTests.Subtraction()
	error("TODO")
end

function VectorTests.ScalarMultiplication()
	local a = Vector.new({ 3, 1, 4, 1, 5, 9 })

	assert(a * 11 == Vector.new({ 33, 11, 44, 11, 55, 99 }))
	assert(11 * a == Vector.new({ 33, 11, 44, 11, 55, 99 }))
end

function VectorTests.HadamardProduct()
	error("TODO")
end

function VectorTests.Division()
	error("TODO")
end

function VectorTests.Negation()
	error("TODO")
end

function VectorTests.Equality()
	local coordinates = table.create(50)

	for i = 1, 50 do
		coordinates[i] = math.random()
	end

	assert(Vector.new(coordinates) == Vector.new(coordinates))
end

function VectorTests.Dot()
	local a = Vector.new({ 2, 7, 1, 8, 2, 8, 1 })
	local b = Vector.new({ 1, 6, 1, 8, 0, 3, 3 })

	assert(a:Dot(b) == 136)
end

function VectorTests.Cross()
	error("TODO")
end

function VectorTests.CrossBadDimension()
	local a = Vector.zero(4)
	local b = Vector.zero(4)

	-- Use a pcall because we expect to receive an error!
	local ok = pcall(function()
		a:Cross(b)
	end)

	assert(not ok)
end

function VectorTests.Magnitude()
	error("TODO")
end

function VectorTests.Unit()
	local a = Vector.new({ 1, 6, 1, 8, 0, 3, 3 })

	-- Check if the magnitude of a:Unit() is between 0.99999999 and 1.00000001
	-- to account for floating point imprecision.
	assert(math.abs(a:Unit():Magnitude() - 1) < 1e-8)
end

function VectorTests.Angle()
	error("TODO")
end

function VectorTests.ProjectOnto()
	error("TODO")
end

for testName, testFunction in VectorTests do
	local ok, message = pcall(testFunction)

	if ok then
		print("[SUCCESS] VectorTests." .. testName)
	else
		print("[FAIL] VectorTests." .. testName .. ": " .. message)
	end
end
