local GramSchmidt = require("GramSchmidt")
local Vector = require("Vector")

local TOLERANCE = 1e-8

local Subspace = {}
Subspace.__index = Subspace

function Subspace.new(vectors)
	local basis = GramSchmidt(vectors)

	return setmetatable({
		Basis = basis,
		Dimension = #basis,
	}, Subspace)
end

function Subspace.isSubspace(object)
	return getmetatable(object) == Subspace
end

function Subspace:ProjectVector(vector)
	assert(Vector.isVector(vector))
	assert(#self.Basis > 0)
	assert(#vector == #self.Basis[1])

	local projection = Vector.zero(#vector)

	for _, basisVector in self.Basis do
		projection += vector:ProjectOnto(basisVector)
	end

	return projection
end

-- Checks if the subspace contains a vector by performing one iteration of
-- Gram-Schmidt. If, by the end, the vector is now (very close to) the zero
-- vector, then it is contained in the subspace. In other words, it is in the
-- span of the `self.Basis` vectors.
function Subspace:Contains(vector)
	assert(Vector.isVector(vector))
	assert(#self.Basis > 0)
	assert(#vector == #self.Basis[1])

	for _, basisVector in self.Basis do
		vector -= vector:ProjectOnto(basisVector)
	end

	return vector:Magnitude() < TOLERANCE
end

return Subspace
