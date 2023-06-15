--[[

Matrix format:
{
	{a11, a12, ..., a1n},
 	{a21, a22, ..., a2n},
 	...
 	{am1, am2, ..., amn}
 }

--]]

local Matrix = {}
Matrix.__index = Matrix

function Matrix.isMatrix(matrix)
	return getmetatable(matrix) == Matrix
end

function Matrix.new(matrix: { { number } })
	local rows = #matrix
	local cols = #matrix[1]

	local copy = table.clone(matrix)
	copy.rows = rows
	copy.cols = cols

	return setmetatable(copy, Matrix)
end

local function isInteger(x)
	return type(x) == "number" and x % 1 == 0
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
	else
		error("Bad inputs")
	end
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
