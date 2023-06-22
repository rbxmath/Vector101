local Matrix = require("Matrix")

local m = Matrix.new({ { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } })

print(m)
print(m - m)
print(Matrix.zero(5, 10))
print(Matrix.empty(5, 10))
print(Matrix.id(7))
print(m * m)
print(5 * m)
print(m * 5)
print(m / 10)
print(m / 0)
print(-m)
print(m + m)

local t = {}
for i = 1, 50 do
	local s = {}
	for j = 1, 50 do
		s[j] = math.random()
	end
	t[i] = s
end
local M = Matrix.new(t)

print(M * M)
