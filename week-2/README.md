# Week 2

## Lecture to-do
* Tidy up the Vector class
    * Implement vector division by a scalar
    * Implement vector equality
    * Add `Vector.zero()` constructor to construct a vector of zeros
* Add geometric methods to the Vector class
    * `Vector:Unit()`: Returns the same vector but with a magnitude of 1
    * `Vector:Angle()`: Returns the angle between two vectors
    * `Vector:ProjectOnto()`: Returns the projection of the vector onto another
* Implement the Gram-Schmidt algorithm

## Homework
You may start from the provided code, but you are strongly encouraged to redo the lecture activities on your own!
* Put `n+1` vectors of dimension `n` into Gram-Schmidt. Do this for different values of `n`. What do you observe? Can you explain why this happens? [(solution)](https://github.com/rbxmath/Vector101/blob/main/week-2/homework/gram-schmidt-solution.md)
* Implement a subspace object with the following methods:
    * A constructor that takes a list of vectors and reduces the list to an orthonormal basis [(solution)](https://github.com/rbxmath/Vector101/blob/2857c46036fa557b0d0ddcbde3c797e9211fe32c/week-2/homework/Subspace.lua#L9-L16)
    * `Subspace:ProjectVector()`: Returns the projection of a vector onto the subspace [(solution)](https://github.com/rbxmath/Vector101/blob/2857c46036fa557b0d0ddcbde3c797e9211fe32c/week-2/homework/Subspace.lua#L22-L34) 
    * `Subspace:Contains()`: Checks if the subspace contains a vector [(solution)](https://github.com/rbxmath/Vector101/blob/2857c46036fa557b0d0ddcbde3c797e9211fe32c/week-2/homework/Subspace.lua#L36-L50)
* **Optional:** Expand on the sample unit tests provided. Add unit tests for Subspace.
