-- Tests the example linear systems from lecture 10

local LinearAlgebra = require("LinearAlgebra")

local Matrix = LinearAlgebra.Matrix
local SystemSolver = LinearAlgebra.SystemSolver
local Vector = LinearAlgebra.Vector

local function Test(matrix, vector)
	local augmented = matrix:AugmentWith(Matrix.fromVector(vector))
	local reduced = SystemSolver.RowReduce(augmented)
	print("RREF:\n", reduced)
	print("Solutions:", SystemSolver.CountSolutions(reduced))
	print("Nullspace span:", SystemSolver.ComputeNullspaceSpan(matrix))
end

print("Example 1")
Test(Matrix.new({ { 1, -1 }, { 3, 6 } }), Vector.new({ 0, 18 }))

print("Example 2")
Test(Matrix.new({ { 2, 1, 1 }, { 4, 1, 0 }, { -2, 2, 1 } }), Vector.new({ 1, -2, 7 }))

print("Example 3")
Test(Matrix.new({ { 2, -1, 0, 0 }, { -1, 2, -1, 0 }, { 0, -1, 2, -1 }, { 0, 0, -1, 2 } }), Vector.new({ 0, 0, 0, 5 }))

print("Example 4")
Test(Matrix.new({ { 1, 1, 1 }, { 3, 3, -1 }, { 1, -1, 1 } }), Vector.new({ -2, 6, -1 }))

print("Example 5")
Test(
	Matrix.new({ { 1, 1, -4, 2, 1 }, { 0, 2, 2, -3, 7 }, { 0, 0, 0, 1, 4 }, { 0, 0, 0, -9, -1 } }),
	Vector.new({ 8, 0, 6, 5 })
)
