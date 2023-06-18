# Week 3

## Lecture to-do
Implement a Matrix class supporting the following operations for matrices of any dimension:
* Matrix addition
* Matrix subtraction
* Matrix negation (i.e., multiplication by -1)
* Scalar multiplication
* Scalar division
* Matrix equality

## Homework
1. Write your own Matrix class. Try it without looking at the lecture code first!
2. In this exercise, you will prove why the sum of two matrices is defined by summing entrywise.

Let $T:\mathbb{R}^n\to \mathbb{R}^m$ and $S:\mathbb{R}^n\to\mathbb{R}^m$ be linear transformations represented by the matrices
```math
\begin{pmatrix} T_{11} & \cdots & T_{1n} \\ \vdots & \ddots & \vdots \\ T_{m1} & \cdots & T_{mn}\end{pmatrix}
\text{ and }
\begin{pmatrix} S_{11} & \cdots & S_{1n} \\ \vdots & \ddots & \vdots \\ S_{m1} & \cdots & S_{mn}\end{pmatrix}
```
respectively. Define the function $(T + S):\mathbb{R}^n\to\mathbb{R}^m$ to have the rule that
```math
(T + S)(x) = T(x) + S(x).
```
Show that
* $T+S$ is linear *(optional but encouraged)*
* $T+S$ is represented by the matrix
```math
\begin{pmatrix} T_{11} + S_{11} & \cdots & T_{1n} + S_{1n} \\ \vdots & \ddots & \vdots \\ T_{m1} + S_{m1} & \cdots & T_{mn} + S_{mn}\end{pmatrix}.
```
Here is a similar proof as an example.
