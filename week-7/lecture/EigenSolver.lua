local Matrix = require("Matrix")
local Vector = require("Vector")

local MAX_ITERATIONS = 100
local TOLERANCE = 1e-13

local EigenSolver = {}

local function getEigenvalueFromEigenvector(matrix, eigenvector)
	-- Since Ax = λx, then by performing entry-wise division on Ax and λx, the
	-- resulting vector Ax / λx should have λ as its coordinates. However,
	-- we must be careful to not return NaN ("not a number") if any entries of
	-- x were 0.

	local Ax = matrix * eigenvector

	for i = 1, #Ax do
		local eigenvalue = Ax[i] / eigenvector[i]

		-- Return eigenvalue if it is not NaN
		if eigenvalue == eigenvalue then
			return eigenvalue
		end
	end

	error("Eigenvector was 0")
end

function EigenSolver.PowerMethod(matrix)
	assert(Matrix.isMatrix(matrix))
	assert(matrix.rows == matrix.cols)

	-- Use the vector (1, 1, ..., 1) for our initial guess
	local eigenvector = Vector.new(table.create(matrix.rows, 1))

	local iterations = 0

	repeat
		iterations += 1

		-- Apply one iteration of the power method
		local newEigenvector = (matrix * eigenvector):Unit()

		-- Stop when the new eigenvector is sufficiently close to the previous
		-- eigenvector
		local canStop = (newEigenvector - eigenvector):Magnitude() < TOLERANCE

		eigenvector = newEigenvector

	until canStop or iterations == MAX_ITERATIONS

	return getEigenvalueFromEigenvector(matrix, eigenvector), eigenvector
end

return EigenSolver
