-- Sample unit tests.

local Vector = require("Vector")
local GramSchmidt = require("GramSchmidt")

local SMALL_NUMBER = 1e-8

local GramSchmidtTests = {}

-- We will use this under the (very probable) assumption that if
-- numVectors <= dimension, then the returned list of vectors is linearly
-- independent.
local function getListOfVectors(numVectors, dimension)
	local vectors = table.create(numVectors)

	for i = 1, numVectors do
		local coordinates = table.create(dimension)

		for j = 1, dimension do
			coordinates[j] = math.random() * 10
		end

		vectors[i] = Vector.new(coordinates)
	end

	return vectors
end

-- Runs Gram-Schmidt on eight 8-dimensional vectors and checks that they are
-- all mutually perpendicular and unit-length.
function GramSchmidtTests.VectorsAreOrthonormal()
	local vectors = getListOfVectors(8, 8)
	local orthonormalVectors = GramSchmidt(vectors)

	-- Check that the magnitude of every vector is (very close to) 1.
	for _, orthonormalVector in orthonormalVectors do
		assert(math.abs(orthonormalVector:Magnitude() - 1) < SMALL_NUMBER, "Not unit length")
	end

	-- Check that the angle between every pair of vectors is (very close to) 90
	-- degrees.
	for i = 1, 8 do
		for j = i + 1, 8 do
			local angle = orthonormalVectors[i]:Angle(orthonormalVectors[j])

			assert(math.abs(math.deg(angle) - 90) < SMALL_NUMBER, "Not orthogonal")
		end
	end
end

function GramSchmidtTests.CorrectDimensions()
	for dimension = 1, 10 do
		for numVectors = 1, dimension + 1 do
			local vectors = getListOfVectors(numVectors, dimension)
			local orthonormalVectors = GramSchmidt(vectors)

			assert(
				#orthonormalVectors == math.min(numVectors, dimension),
				"Expected " .. math.min(numVectors, dimension) .. " vectors, got " .. #orthonormalVectors
			)
		end
	end
end

for testName, testFunction in GramSchmidtTests do
	local ok, message = pcall(testFunction)

	if ok then
		print("[SUCCESS] GramSchmidtTests." .. testName)
	else
		print("[FAIL] GramSchmidtTests." .. testName .. ": " .. message)
	end
end
