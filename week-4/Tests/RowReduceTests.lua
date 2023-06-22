local Matrix = require("Matrix")
local RowReduce = require("RowReduce")

local function matrixToMathematica(matrix)
	local strings = table.create(matrix.rows + 2)
	strings[1] = "{"

	for i, row in ipairs(matrix) do
		strings[i + 1] = "{" .. table.concat(row, ", ") .. "},\n"
	end

	strings[matrix.rows + 1] = strings[matrix.rows + 1]:sub(1, -3)
	strings[matrix.rows + 2] = "}"

	return table.concat(strings)
end

function Matrix:ToTableString() end

local long = Matrix.new({
	{ 4, 2, 4, 6, 7, 2 },
	{ 2, 1, 3, 7, 9, 1 },
	{ 0, 0, 8, 2, 9, 4 },
	{ 0, 0, 10, 2, 1, 1 },
	{ 0, 0, 0, 0, 0, 5 },
})

local tall = Matrix.new({
	{ 4, 2, 4, 6, 7, 2 },
	{ 2, 1, 3, 7, 9, 1 },
	{ 0, 0, 8, 2, 9, 4 },
	{ 0, 0, 10, 2, 1, 1 },
	{ 0, 0, 0, 0, 0, 5 },
}):Transpose()

local invertible = Matrix.new({
	{ 4, 2, 4, 6, 7 },
	{ 2, 3, 3, 7, 9 },
	{ 0, 0, 8, 2, 9 },
	{ 0, 0, 10, 2, 1 },
	{ 0, 0, 0, 2, 2 },
})

local random = {}
for i = 1, 10 do
	local row = {}

	for j = 1, 20 do
		row[j] = math.random()
	end

	random[i] = row
end
random = Matrix.new(random)

print(RowReduce(random))
