# Week 7

## Lecture to-do
1. Refactor code: Move `SystemSolver` and `EigenSolver` methods into `Matrix`
2. Compute the inverse of a matrix

## Homework
1. Add the following methods to your Matrix class:
* `Matrix:Submatrix(topLeftRow, topLeftCol, bottomRightRow, bottomRightCol)`: Returns a submatrix of the matrix [(solution)](https://github.com/rbxmath/Vector101/blob/f237c6370f0dc3ec5772ef8042d7f47132dd83e6/week-7/homework/Matrix.lua#L377-L396)
* `Matrix:FrobeniusNorm()`: Computes the Frobenius norm *(you can copy this from lecture)* [(solution)](https://github.com/rbxmath/Vector101/blob/f237c6370f0dc3ec5772ef8042d7f47132dd83e6/week-7/homework/Matrix.lua#L364-L375)
* `Matrix:Inverse()`: Computes the inverse of the matrix via row reduction [(solution)](https://github.com/rbxmath/Vector101/blob/f237c6370f0dc3ec5772ef8042d7f47132dd83e6/week-7/homework/Matrix.lua#L398-L412)
* `Matrix:Determinant()`: Computes the determinant of the matrix via cofactor expansion [(solution)](https://github.com/rbxmath/Vector101/blob/f237c6370f0dc3ec5772ef8042d7f47132dd83e6/week-7/homework/Matrix.lua#L414-L450)
2. *(Optional)* Prove that a function is invertible if and only if it is bijective.
