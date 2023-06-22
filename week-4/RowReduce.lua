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
local function getRowWithLargestPivot(matrix, i)
	local pivotRowIndex = i
	local maxPivotMagnitude = math.abs(matrix[i][i])

	for j = i + 1, matrix.rows do
		local pivotMagnitude = math.abs(matrix[j][i])

		if pivotMagnitude > maxPivotMagnitude then
			pivotRowIndex = j
			maxPivotMagnitude = pivotMagnitude
		end
	end

	return pivotRowIndex
end

local function eliminateRow(pivotRow, victimRow, i)
	local pivot = pivotRow[i]
	local victimEntry = victimRow[i]

	-- Early exit: Nothing to eliminate
	if victimEntry == 0 then
		return
	end

	local scaleFactor = victimEntry / pivot

	for k = i, #victimRow do
		victimRow[k] -= scaleFactor * pivotRow[k]

		if math.abs(victimRow[k]) < TOLERANCE then
			victimRow[k] = 0
		end
	end
end

local function RowReduce(matrix)
	matrix = Matrix.copy(matrix)
	print(matrix)

	for i = 1, math.min(matrix.rows, matrix.cols) do
		print(i)
		-- Partial pivoting
		local pivotRowIndex = getRowWithLargestPivot(matrix, i)

		-- Swap pivot row if needed
		if pivotRowIndex ~= i then
			print("swapping " .. i .. " with " .. pivotRowIndex)
			matrix[i], matrix[pivotRowIndex] = matrix[pivotRowIndex], matrix[i]
		end

		local pivotRow = matrix[i]
		local pivot = pivotRow[i]

		-- Early exit: Nothing to eliminate
		if pivot == 0 then
			print("skipping due to 0 pivot")
			continue
		end

		-- Eliminate
		for j = 1, matrix.rows do
			if i == j then
				continue
			end

			eliminateRow(pivotRow, matrix[j], i)
		end

		-- Normalize the pivot row
		for k = i, matrix.cols do
			pivotRow[k] /= pivot
		end

		print("done")
		print(matrix)
	end

	return matrix
end

return RowReduce
