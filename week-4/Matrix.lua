local Matrix = {}
Matrix.__index = Matrix

local function isInteger(x)
	return type(x) == "number" and x % 1 == 0
end

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

-- Used internally when performing matrix operations
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

function Matrix.isMatrix(matrix)
	return getmetatable(matrix) == Matrix
end

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

function Matrix:Transpose()
	local matrix = Matrix.empty(self.cols, self.rows)

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			matrix[i][j] = self[j][i]
		end
	end

	return matrix
end

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

function Matrix.__unm(matrix)
	local newMatrix = Matrix.empty(matrix.rows, matrix.cols)

	for i = 1, matrix.rows do
		for j = 1, matrix.cols do
			newMatrix[i][j] = -matrix[i][j]
		end
	end

	return newMatrix
end

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
	else
		error("Bad inputs")
	end
end

function Matrix.__eq(a, b)
	assert(Matrix.isMatrix(a))
	assert(Matrix.isMatrix(b))
	assert(a.rows == b.rows)
	assert(a.cols == b.cols)

	for i = 1, #a.rows do
		for j = 1, #a.cols do
			if a[i][j] ~= b[i][j] then
				return false
			end
		end
	end

	return true
end

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
