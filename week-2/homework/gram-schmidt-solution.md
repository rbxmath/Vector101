## Homework exercise
Put `n+1` vectors of dimension `n` into Gram-Schmidt. Do this for different values of `n`. What do you observe? Can you explain why this happens?

## Answer
Given `n+1` vectors of dimension `n`, we observe that Gram-Schmidt always returns at most `n` orthonormal vectors.

Intuitively, this is because at most `n` vectors can be mutually orthogonal in `R^n`. To see this, think about the look/right/up vectors of a CFrame: These form an orthonormal basis for `R^3`, and we cannot find a fourth vector that is orthogonal to each of them. Formally, this is a result of the fact that, given `n+1` vectors in `R^n`, at least one must be a linear combination of the rest. Hence Gram-Schmidt will discard this vector.