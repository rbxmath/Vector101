local Matrix = require("Matrix")
local Vector = require("Vector")

local TOLERANCE = 1e-13

local SystemSolver = {}

-- Partial pivoting
-- Gets the row whose element in the column has the greatest magnitude.
local function getBestRow(matrix, pivotRowIndex, pivotColIndex)
	local pivot = matrix[pivotRowIndex][pivotColIndex]
	local maxPivotMagnitude = math.abs(pivot)
	local bestRowIndex = pivotRowIndex

	for j = pivotRowIndex + 1, matrix.rows do
		local magnitude = math.abs(matrix[j][pivotColIndex])

		if magnitude > maxPivotMagnitude then
			maxPivotMagnitude = magnitude
			bestRowIndex = j
		end
	end

	return bestRowIndex
end

local function eliminateRow(pivotRow, victimRow, pivotColIndex)
	local pivot = pivotRow[pivotColIndex]
	local victim = victimRow[pivotColIndex]

	-- Early exit: Nothing to eliminate
	if victim == 0 then
		return
	end

	local scaleFactor = victim / pivot

	for k = pivotColIndex, #victimRow do
		victimRow[k] -= scaleFactor * pivotRow[k]

		if math.abs(victimRow[k]) < TOLERANCE then
			victimRow[k] = 0
		end
	end
end

-- Brings a matrix to RREF using row reduction with partial pivoting.
function SystemSolver.RowReduce(matrix)
	assert(Matrix.isMatrix(matrix))

	matrix = Matrix.copy(matrix)

	local pivotRowIndex = 1
	local pivotColIndex = 1

	while pivotRowIndex <= matrix.rows and pivotColIndex <= matrix.cols do
		-- Partial pivoting
		local bestRowIndex = getBestRow(matrix, pivotRowIndex, pivotColIndex)

		-- Swap pivot row if needed
		if bestRowIndex ~= pivotRowIndex then
			matrix[pivotRowIndex], matrix[bestRowIndex] = matrix[bestRowIndex], matrix[pivotRowIndex]
		end

		local pivotRow = matrix[pivotRowIndex]
		local pivot = pivotRow[pivotColIndex]

		-- Early exit: Nothing to eliminate
		if pivot == 0 then
			pivotColIndex += 1
			continue
		end

		-- Eliminate other rows
		for j = 1, matrix.rows do
			if j ~= pivotRowIndex then
				eliminateRow(pivotRow, matrix[j], pivotColIndex)
			end
		end

		-- Normalize the pivot row
		for k = pivotRowIndex, matrix.cols do
			pivotRow[k] /= pivot
		end

		pivotRowIndex += 1
		pivotColIndex += 1
	end

	return matrix
end

-- Counts the number of solutions to a linear system in RREF. Returns either
-- 0, 1, or math.huge.
function SystemSolver.CountSolutions(matrix): number
	assert(Matrix.isMatrix(matrix))

	local pivots = 0

	for _, row in ipairs(matrix) do
		local foundPivot = false

		-- Search for a pivot in all but the last entry
		for i = 1, matrix.cols - 1 do
			if row[i] ~= 0 then
				foundPivot = true
				break
			end
		end

		if foundPivot then
			pivots += 1
		else
			-- If there is no pivot, check for a lie (i.e. a row of zeros
			-- augmented with something nonzero)
			if row[matrix.cols] ~= 0 then
				return 0
			end
		end
	end

	return pivots == matrix.cols - 1 and 1 or math.huge
end

-- Returns a set of vectors that span the nullspace of a matrix.
-- See page 10 of lecture 9 for the algorithm and notation.
function SystemSolver.ComputeNullspaceSpan(matrix)
	assert(Matrix.isMatrix(matrix))

	local transpose = matrix:Transpose()

	-- C = (A^T | I)
	local augmentedMatrix = transpose:AugmentWith(Matrix.id(transpose.rows))

	-- C' = (B | C'')
	local reduced = SystemSolver.RowReduce(augmentedMatrix)

	-- {(r^1)^T, ..., (r^k)^T}
	local spanningSet = {}

	for _, row in ipairs(reduced) do
		local rowIsZero = true

		for i = 1, transpose.cols do
			if row[i] ~= 0 then
				rowIsZero = false
				break
			end
		end

		if rowIsZero then
			local augmentedRow = table.create(transpose.rows)

			for i = 1, transpose.rows do
				augmentedRow[i] = row[i + transpose.cols]
			end

			table.insert(spanningSet, Vector.new(augmentedRow))
		end
	end

	return spanningSet
end

return SystemSolver
