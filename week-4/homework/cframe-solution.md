## Homework exercise
Create a CFrame `A` and a matrix `M` such that the columns of `M` are `A.RightVector`, `A.UpVector`, and `-A.LookVector`:
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
Do the same for a CFrame `B` and matrix `N`. Now compare the right/up/-look vectors of the CFrame `A*B` with the columns of the matrix `M*N`. What do you notice?

## Answer
You should notice that the right/up/-look vectors of the CFrame `A*B` are equal to the columns of the matrix `M*N`. Now we know how CFrames (with no position) multiply!