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
* Implement a subspace object with the following methods:
    * A constructor that takes a list of vectors and reduces the list to an orthonormal basis
    * `Subspace:ProjectVector()`: Returns the projection of a vector onto the subspace

## Homework
You may start from the provided code, but you are strongly encouraged to redo the lecture activities on your own!
* Add a `Subspace:Contains()` method that checks if the subspace contains a vector
* Put `n+1` vectors of dimension `n` into Gram-Schmidt. Do this for different values of `n`. What do you observe? Can you explain why this happens?
* **Optional:** Expand on the sample unit tests provided. Add unit tests for Subspace
