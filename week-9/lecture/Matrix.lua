local Vector = require("Vector")

local MAX_POWER_METHOD_ITERATIONS = 100
local TOLERANCE = 1e-13

local Matrix = {}
Matrix.__index = Matrix

-- Creates a matrix from a 2D array
function Matrix.new(matrix: { { number } })
	local rows = #matrix

	assert(rows > 0)

	for _, row in matrix do
		assert(typeof(row) == "table")
	end

	local cols = #matrix[1]

	for _, row in matrix do
		assert(#row == cols)

		for _, number in row do
			assert(type(number) == "number")
		end
	end

	local copy = table.clone(matrix)
	copy.rows = rows
	copy.cols = cols

	return setmetatable(copy, Matrix)
end

local function isInteger(x)
	return type(x) == "number" and x % 1 == 0
end

-- Creates a matrix of all zeros
function Matrix.zero(rows: number, cols: number)
	assert(isInteger(rows) and rows > 0)
	assert(isInteger(cols) and cols > 0)

	local matrix = table.create(rows)

	for i = 1, rows do
		matrix[i] = table.create(cols, 0)
	end

	matrix.rows = rows
	matrix.cols = cols

	return setmetatable(matrix, Matrix)
end

-- Creates an identity matrix, i.e., a square n x n matrix of all zeros but with
-- ones along the diagonal
function Matrix.id(n: number)
	assert(isInteger(n) and n > 0)

	local matrix = table.create(n)

	for i = 1, n do
		local row = table.create(n, 0)
		row[i] = 1
		matrix[i] = row
	end

	matrix.rows = n
	matrix.cols = n

	return setmetatable(matrix, Matrix)
end

-- Creates an empty matrix; used internally when performing matrix operations
function Matrix.empty(rows: number, cols: number)
	assert(isInteger(rows) and rows > 0)
	assert(isInteger(cols) and cols > 0)

	local matrix = table.create(rows)

	for i = 1, rows do
		matrix[i] = table.create(cols)
	end

	matrix.rows = rows
	matrix.cols = cols

	return setmetatable(matrix, Matrix)
end

-- Creates a column matrix from a vector
function Matrix.fromVector(vector)
	assert(Vector.isVector(vector))

	local matrix = table.create(#vector)

	for i, coordinate in vector do
		matrix[i] = { coordinate }
	end

	matrix.rows = #vector
	matrix.cols = 1

	return setmetatable(matrix, Matrix)
end

-- Copies a matrix
function Matrix.copy(matrix)
	assert(Matrix.isMatrix(matrix))

	local copy = Matrix.empty(matrix.rows, matrix.cols)

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			copy[i][j] = matrix[i][j]
		end
	end

	return copy
end

-- Checks whether the input is a Matrix object
function Matrix.isMatrix(matrix)
	return getmetatable(matrix) == Matrix
end

-- Flips rows and columns such that the first row becomes the first column,
-- the second row becomes the second column, etc.
function Matrix:Transpose()
	local matrix = Matrix.empty(self.cols, self.rows)

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			matrix[i][j] = self[j][i]
		end
	end

	return matrix
end

-- Appends a matrix of the same height to the right side of the current matrix
function Matrix:AugmentWith(matrix)
	assert(Matrix.isMatrix(matrix))
	assert(matrix.rows == self.rows)

	local augmentedMatrix = Matrix.empty(self.rows, self.cols + matrix.cols)

	for i = 1, self.rows do
		for j = 1, self.cols do
			augmentedMatrix[i][j] = self[i][j]
		end
	end

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			augmentedMatrix[i][self.cols + j] = matrix[i][j]
		end
	end

	return augmentedMatrix
end

-- Gets the row whose element in the column has the greatest magnitude; used for
-- partial pivoting in row reduction
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

-- Used in row reduction to eliminate victimRow with pivotRow
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

-- Brings a matrix to RREF using row reduction with partial pivoting
function Matrix:RowReduce()
	local matrix = Matrix.copy(self)

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
function Matrix:CountSolutions(): number
	local pivots = 0

	for _, row in ipairs(self) do
		local foundPivot = false

		-- Search for a pivot in all but the last entry
		for i = 1, self.cols - 1 do
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
			if row[self.cols] ~= 0 then
				return 0
			end
		end
	end

	return pivots == self.cols - 1 and 1 or math.huge
end

-- Returns a set of vectors that span the nullspace of the matrix.
-- See page 10 of lecture 9 for the algorithm and notation.
function Matrix:ComputeNullspaceSpan()
	local transpose = self:Transpose()

	-- C = (A^T | I)
	local augmentedMatrix = transpose:AugmentWith(Matrix.id(transpose.rows))

	-- C' = (B | C'')
	local reduced = augmentedMatrix:RowReduce()

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

-- Uses the power method to return the largest eigenvalue (in absolute value)
-- and an associated eigenvector
function Matrix:PowerMethod()
	assert(self.rows == self.cols)

	-- Use the vector (1, 1, ..., 1) for our initial guess
	local eigenvector = Vector.new(table.create(self.rows, 1))

	local iterations = 0

	repeat
		iterations += 1

		-- Apply one iteration of the power method
		local newEigenvector = (self * eigenvector):Unit()

		-- Stop when the new eigenvector is sufficiently close to the previous
		-- eigenvector
		local canStop = (newEigenvector - eigenvector):Magnitude() < TOLERANCE

		eigenvector = newEigenvector

	until canStop or iterations == MAX_POWER_METHOD_ITERATIONS

	return getEigenvalueFromEigenvector(self, eigenvector), eigenvector
end

-- Computes the Frobenius norm of the matrix
function Matrix:FrobeniusNorm()
	local sum = 0

	for i = 1, self.rows do
		for j = 1, self.cols do
			sum += self[i][j] ^ 2
		end
	end

	return math.sqrt(sum)
end

-- Returns a submatrix
function Matrix:Submatrix(topLeftRow, topLeftCol, bottomRightRow, bottomRightCol)
	assert(isInteger(topLeftRow) and topLeftRow >= 1 and topLeftRow <= self.rows)
	assert(isInteger(topLeftCol) and topLeftCol >= 1 and topLeftCol <= self.cols)
	assert(isInteger(bottomRightRow) and bottomRightRow >= topLeftRow and bottomRightRow <= self.rows)
	assert(isInteger(bottomRightCol) and bottomRightCol >= topLeftCol and bottomRightCol <= self.cols)

	local rows = bottomRightRow - topLeftRow + 1
	local cols = bottomRightCol - topLeftCol + 1

	local matrix = Matrix.empty(rows, cols)

	for i = 1, rows do
		for j = 1, cols do
			matrix[i][j] = self[i + topLeftRow - 1][j + topLeftCol - 1]
		end
	end

	return matrix
end

-- Computes the inverse of the matrix via row reduction
function Matrix:Inverse()
	assert(self.rows == self.cols)

	local augmentedMatrix = self:AugmentWith(Matrix.id(self.rows))
	local reduced = augmentedMatrix:RowReduce()
	local left = reduced:Submatrix(1, 1, self.rows, self.rows)
	local right = reduced:Submatrix(1, self.rows + 1, self.rows, 2 * self.rows)

	if left == Matrix.id(self.rows) then
		return right
	else
		return nil
	end
end

-- Returns the submatrix with the first row and excludedCol column removed
local function getPrincipalSubmatrix(matrix, excludedCol)
	local n = matrix.rows - 1
	local principalSubmatrix = Matrix.empty(n, n)

	for i = 1, n do
		for j = 1, n do
			local row = i + 1
			local col = j + (j >= excludedCol and 1 or 0)
			principalSubmatrix[i][j] = matrix[row][col]
		end
	end

	return principalSubmatrix
end

-- Computes the determinant by performing cofactor expansion on the first row
function Matrix:Determinant(): number
	assert(self.rows == self.cols)

	-- Base cases
	if self.rows == 1 then
		return self[1][1]
	elseif self.rows == 2 then
		return self[1][1] * self[2][2] - self[1][2] * self[2][1]
	end

	local determinant = 0

	for col = 1, self.cols do
		local principalSubmatrix = getPrincipalSubmatrix(self, col)
		local sign = col % 2 == 0 and -1 or 1
		determinant += sign * self[1][col] * principalSubmatrix:Determinant()
	end

	return determinant
end

-- Sums matrices entrywise
function Matrix.__add(a, b)
	assert(Matrix.isMatrix(a))
	assert(Matrix.isMatrix(b))
	assert(a.rows == b.rows)
	assert(a.cols == b.cols)

	local matrix = Matrix.empty(a.rows, a.cols)

	for i = 1, a.rows do
		for j = 1, a.cols do
			matrix[i][j] = a[i][j] + b[i][j]
		end
	end

	return matrix
end

-- Subtracts matrix b from matrix a entrywise
function Matrix.__sub(a, b)
	assert(Matrix.isMatrix(a))
	assert(Matrix.isMatrix(b))
	assert(a.rows == b.rows)
	assert(a.cols == b.cols)

	local newMatrix = Matrix.empty(a.rows, a.cols)

	for i = 1, a.rows do
		for j = 1, a.cols do
			newMatrix[i][j] = a[i][j] - b[i][j]
		end
	end

	return newMatrix
end

-- Negates each entry of the matrix
function Matrix.__unm(matrix)
	local newMatrix = Matrix.empty(matrix.rows, matrix.cols)

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			newMatrix[i][j] = -matrix[i][j]
		end
	end

	return newMatrix
end

-- Divides each entry of the matrix by a scalar
function Matrix.__div(matrix, scalar)
	assert(Matrix.isMatrix(matrix))
	assert(type(scalar) == "number")

	local newMatrix = Matrix.empty(matrix.rows, matrix.cols)

	for i, row in ipairs(matrix) do
		for j, element in ipairs(row) do
			newMatrix[i][j] = element / scalar
		end
	end

	return newMatrix
end

-- Performs matrix-matrix and matrix-scalar multiplication
function Matrix.__mul(a, b)
	if Matrix.isMatrix(a) and type(b) == "number" then
		local newMatrix = Matrix.empty(a.rows, a.cols)

		for i, row in ipairs(a) do
			for j, element in ipairs(row) do
				newMatrix[i][j] = element * b
			end
		end

		return newMatrix
	elseif type(a) == "number" and Matrix.isMatrix(b) then
		local newMatrix = Matrix.empty(b.rows, b.cols)

		for i, row in ipairs(b) do
			for j, element in ipairs(row) do
				newMatrix[i][j] = element * a
			end
		end

		return newMatrix
	elseif Matrix.isMatrix(a) and Matrix.isMatrix(b) then
		assert(a.cols == b.rows)

		local newMatrix = Matrix.empty(a.rows, b.cols)

		for i = 1, a.rows do
			for j = 1, b.cols do
				local sum = 0

				for k = 1, a.cols do
					sum += a[i][k] * b[k][j]
				end

				newMatrix[i][j] = sum
			end
		end

		return newMatrix
	elseif Matrix.isMatrix(a) and Vector.isVector(b) then
		assert(a.cols == #b)

		local coordinates = table.create(a.rows)

		for i = 1, a.rows do
			local sum = 0

			for j = 1, a.cols do
				sum += a[i][j] * b[j]
			end

			coordinates[i] = sum
		end

		return Vector.new(coordinates)
	else
		error("Bad inputs")
	end
end

-- Checks for matrix equality entrywise
function Matrix.__eq(a, b)
	assert(Matrix.isMatrix(a))
	assert(Matrix.isMatrix(b))
	assert(a.rows == b.rows)
	assert(a.cols == b.cols)

	for i = 1, a.rows do
		for j = 1, a.cols do
			if a[i][j] ~= b[i][j] then
				return false
			end
		end
	end

	return true
end

-- Pretty-prints the matrix
function Matrix.__tostring(matrix)
	local colLengths = table.create(matrix.cols, 0)

	for i, row in ipairs(matrix) do
		for j, value in ipairs(row) do
			colLengths[j] = math.max(colLengths[j], #tostring(value))
		end
	end

	local strings = table.create(matrix.rows + 1)

	for i, row in ipairs(matrix) do
		local rowStr = ""

		for j, value in ipairs(row) do
			rowStr = rowStr .. value .. " " .. string.rep(" ", colLengths[j] - #tostring(value))
		end

		strings[i] = "| " .. rowStr .. "|"
	end

	table.insert(strings, "")

	return table.concat(strings, "\n")
end

return Matrix
