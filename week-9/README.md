# Week 9

## Lecture to-do
Implement an AffineMap class for 3D affine transformations with the following methods:
* `AffineMap.new(x, y, z)`: Constructor that mimics `CFrame.new(x, y, z)`
* `AffineMap.fromMatrix(pos, right, up, back)`: Constructor that mimics `CFrame.fromMatrix(...)`
* `AffineMap:ToCFrame()`: Converts the AffineMap to a CFrame
* `AffineMap.__mul(a, b)`: Multiplies two AffineMaps

## Homework
1. Create your own AffineMap class with the methods from lecture.
2. Add the following methods to your AffineMap class:
    1. `AffineMap.__add(a, b)`: Sums the AffineMaps. Be careful that the result is still an affine transormation!
    2. `AffineMap.__sub(a, b)`: Subtracts the AffineMaps. Be careful that the result is still an affine transformation!
