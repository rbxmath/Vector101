--[[

| 4 2 4 6 7 2 |
| 2 1 3 7 9 1 |
| 0 0 8 2 9 4 |
| 0 0 6 2 1 1 |
| 0 0 0 0 0 5 |

--]]

local Matrix = require("Matrix")

local TOLERANCE = 1e-13

-- Partial pivoting
local function getBestRow(matrix, pivotRowIndex, pivotColIndex)
	local pivot = matrix[pivotRowIndex][pivotColIndex]
	local maxPivotMagnitude = math.abs(pivot)

	for j = pivotRowIndex + 1, matrix.rows do
		local pivotMagnitude = math.abs(matrix[j][pivotColIndex])

		if pivotMagnitude > maxPivotMagnitude then
			pivotRowIndex = j
			maxPivotMagnitude = pivotMagnitude
		end
	end

	return pivotRowIndex
end

local function eliminateRow(pivotRow, victimRow, pivotColIndex)
	local pivot = pivotRow[pivotColIndex]
	local victimEntry = victimRow[pivotColIndex]

	-- Early exit: Nothing to eliminate
	if victimEntry == 0 then
		return
	end

	local scaleFactor = victimEntry / pivot

	for k = pivotColIndex, #victimRow do
		victimRow[k] -= scaleFactor * pivotRow[k]

		if math.abs(victimRow[k]) < TOLERANCE then
			victimRow[k] = 0
		end
	end
end

local function RowReduce(matrix)
	matrix = Matrix.copy(matrix)
	print(matrix)

	local pivotRowIndex = 1
	local pivotColIndex = 1

	while pivotRowIndex <= matrix.rows and pivotColIndex <= matrix.cols do
		print("pivotRowIndex:", pivotRowIndex, "pivotCol:", pivotColIndex)
		-- Partial pivoting
		local bestRowIndex = getBestRow(matrix, pivotRowIndex, pivotColIndex)

		-- Swap pivot row if needed
		if bestRowIndex ~= pivotRowIndex then
			print("swapping " .. pivotRowIndex .. " with " .. bestRowIndex)
			matrix[pivotRowIndex], matrix[bestRowIndex] = matrix[bestRowIndex], matrix[pivotRowIndex]
		end

		local pivotRow = matrix[pivotRowIndex]
		local pivot = pivotRow[pivotColIndex]

		-- Early exit: Nothing to eliminate
		if pivot == 0 then
			pivotColIndex += 1
			print("skipping due to 0 pivot")
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

		print("done")
		print(matrix)
	end

	return matrix
end

return RowReduce
