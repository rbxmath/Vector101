local GramSchmidt = require("GramSchmidt")
local Vector = require("Vector")

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
	local projection = Vector.zero(#vector)

	for _, basisVector in self.Basis do
		projection += vector:ProjectOnto(basisVector)
	end

	return projection
end

function Subspace:Contains(vector)
	-- Homework!
end

return Subspace
