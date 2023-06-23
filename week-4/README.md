# Week 4

## Lecture to-do
* Add matrix-matrix multiplication to the Matrix class [(code)](https://github.com/rbxmath/Vector101/blob/a45ff5c90f23a6b5ee4b8815dc8bcc4091860efc/week-4/lecture/Matrix.lua#L119-L137)
* Implement row reduction (did not finish)

## Homework
1. Add the following methods to your Matrix class:
* Matrix-vector multiplication
* `Matrix:Transpose()`: Transposes a matrix
* `Matrix.copy(matrix)`: Constructor that returns a copy of a matrix
* Matrix.zero(rows, cols)`: Constructor that returns a matrix of 0s
* `Matrix.id(n)`: Constructor that returns an nxn identity matrix
 
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
Do the same for a CFrame `B` and matrix `N`. Now compare the right/up/look vectors of the CFrame `A*B` with the columns of the matrix `M*N`. What do you notice?
