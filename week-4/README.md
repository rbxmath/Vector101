# Week 4

## Lecture to-do
* Add matrix-matrix multiplication to the Matrix class [(code)](https://github.com/rbxmath/Vector101/blob/a45ff5c90f23a6b5ee4b8815dc8bcc4091860efc/week-4/lecture/Matrix.lua#L119-L137)
* Implement row reduction (did not finish)

## Homework
1. Add the following methods to your Matrix class:
* Matrix-matrix multiplication [(solution)](https://github.com/rbxmath/Vector101/blob/cc22ae9a6e8d0514d6f1e4d5280ec0677a31749e/week-4/homework/Matrix.lua#L209-L227)
* `Matrix:Transpose()`: Transposes a matrix [(solution)](https://github.com/rbxmath/Vector101/blob/cc22ae9a6e8d0514d6f1e4d5280ec0677a31749e/week-4/homework/Matrix.lua#L110-L120)
* `Matrix.copy(matrix)`: Constructor that returns a copy of a matrix [(solution)](https://github.com/rbxmath/Vector101/blob/cc22ae9a6e8d0514d6f1e4d5280ec0677a31749e/week-4/homework/Matrix.lua#L88-L101)
* `Matrix.zero(rows, cols)`: Constructor that returns a matrix of 0s [(solution)](https://github.com/rbxmath/Vector101/blob/cc22ae9a6e8d0514d6f1e4d5280ec0677a31749e/week-4/homework/Matrix.lua#L35-L50)
* `Matrix.id(n)`: Constructor that returns an nxn identity matrix [(solution)](https://github.com/rbxmath/Vector101/blob/cc22ae9a6e8d0514d6f1e4d5280ec0677a31749e/week-4/homework/Matrix.lua#L52-L69)
 
2. Create a CFrame `A` and a matrix `M` such that the columns of `M` are `A.RightVector`, `A.UpVector`, and `-A.LookVector`:
```lua
local A = CFrame.Angles(1, 2, 3) -- or your favorite CFrame constructor
local Right = A.RightVector
local Up = A.UpVector
local Look = A.LookVector
local M = Matrix.new({{Right.X, Up.X, -Look.X}, {Right.Y, Up.Y, -Look.Y}, {Right.Z, Up.Z, -Look.Z}})
```
Or in math typesetting,
```math
M = \begin{pmatrix} Right.X & Up.X & -Look.X \\ Right.Y & Up.Y & -Look.Y \\ Right.Z & Up.Z & -Look.Z \end{pmatrix}.
```
Do the same for a CFrame `B` and matrix `N`. Now compare the right/up/-look vectors of the CFrame `A*B` with the columns of the matrix `M*N`. What do you notice? [(solution)](https://github.com/rbxmath/Vector101/blob/main/week-4/homework/cframe-solution.md#answer)
