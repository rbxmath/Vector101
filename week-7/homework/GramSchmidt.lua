local Vector = require("Vector")

local SMALL_NUMBER = 1e-8 -- 1e-8 = 1 * 10^(-8) = 0.0000001

local function GramSchmidt(vectors)
	local orthonormalVectors = {}

	for _, vector in vectors do
		for _, orthonormalVector in orthonormalVectors do
			vector -= vector:ProjectOnto(orthonormalVector)
		end

		if vector:Magnitude() > SMALL_NUMBER then
			table.insert(orthonormalVectors, vector:Unit())
		else
			-- If the vector's magnitude is now (very close to) 0, then it can
			-- be written as a linear combination of the prior vectors. Thus, it
			-- cannot be made orthogonal to every other vector, so we do not
			-- include it.
		end
	end

	return orthonormalVectors
end

return GramSchmidt
