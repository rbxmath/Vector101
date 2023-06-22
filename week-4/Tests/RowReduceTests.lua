local Matrix = require("Matrix")
local RowReduce = require("RowReduce")

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

print(RowReduce(long))
