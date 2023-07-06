local Matrix = require("Matrix")
local Vector = require("Vector")

local MAX_ITERATIONS = 50
local TOLERANCE = 1e-13

local EigenSolver = {}

function EigenSolver.PowerMethod(matrix)
	assert(Matrix.isMatrix(matrix))
	assert(matrix.rows == matrix.cols)

	local eigenvector = Vector.new(table.create(matrix.rows, 1))
	local iterations = 0

	repeat
		iterations += 1
		local prevEigenvector = eigenvector
		eigenvector = (matrix * eigenvector):Unit()
	until (eigenvector - prevEigenvector):Magnitude() < TOLERANCE or iterations == MAX_ITERATIONS

	local eigenvalue = (matrix * eigenvector)[1] / eigenvector[1]

	return eigenvalue, eigenvector
end

return EigenSolver
