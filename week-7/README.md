# Week 7

## Lecture to-do
1. Refactor code: Move `SystemSolver` and `EigenSolver` methods into `Matrix`
2. Compute the inverse of a matrix

## Homework
1. Add the following methods to your Matrix class:
* `Matrix:Submatrix(topLeftRow, topLeftCol, bottomRightRow, bottomRightCol)`: Returns a submatrix of the matrix
* `Matrix:FrobeniusNorm()`: Computes the Frobenius norm *(you can copy this from lecture)*
* `Matrix:Inverse()`: Computes the inverse of the matrix via row reduction
* `Matrix:Determinant()`: Computes the determinant of the matrix via cofactor expansion
2. *(Optional)* Prove that a function is invertible if and only if it is bijective.
