local EigenSolver = require("EigenSolver")
local Matrix = require("Matrix")

local testCases = {
	-- {matrix, largest eigenvalue}
	{ Matrix.id(10), 1 },
	{ Matrix.new({ { 1, 2, 3 }, { 2, 1, 2 }, { 3, 3, 1 } }), 6 },
	{ Matrix.new({ { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } }), 16.1168 },
	{
		Matrix.new({
			{ 0.507753, 0.952484, 0.953477 },
			{ 0.368869, 0.434773, 0.975389 },
			{ 0.930721, 0.907804, 0.197934 },
		}),
		2.05321,
	},
	{
		Matrix.new({
			{ 0.960855, 0.991353, 0.47641 },
			{ 0.519444, 0.420871, 0.509017 },
			{
				0.825909,
				0.373356,
				0.686999,
			},
		}),
		1.96069,
	},
	{
		Matrix.new({
			{ 0.0609396, 0.778421, 0.325231, 0.266966 },
			{ 0.551922, 0.952512, 0.951875, 0.579967 },
			{ 0.372993, 0.848931, 0.96674, 0.00340134 },
			{ 0.436503, 0.317428, 0.489358, 0.37932 },
		}),
		2.28383,
	},
	{
		Matrix.new({
			{ 5.67789, 6.52749, 0.864024, -4.72215 },
			{ 9.91117, 3.1469, -5.63534, -8.63931 },
			{ 1.60429, -3.25507, 7.2001, 7.51155 },
			{ 2.02748, -3.30849, 9.82271, -8.75118 },
		}),
		15.6018,
	},
	{
		Matrix.new({
			{ -8.47954, -0.266057, 1.38032, 9.59865, 9.0374, 0.775624, 4.97942, 8.80429, -6.64048, 4.24813 },
			{ -5.8846, 3.52644, -6.55165, -8.89877, 9.75074, 2.16575, 1.84406, 4.3563, -7.44936, 4.65419 },
			{ 9.81658, -2.33521, -7.27208, 3.40538, 8.29612, 7.93085, 1.3476, 3.80673, 9.25872, -2.84477 },
			{ 6.36818, 5.00244, 5.8992, 2.9071, 2.25278, -8.52399, 2.45085, 1.80587, 2.50205, -0.689743 },
			{ -9.3932, 7.44957, -0.0485914, 4.65606, -9.20978, -0.215228, -2.77652, -8.74931, -7.5059, 1.85392 },
			{ 5.87588, -2.55604, -6.76462, -5.30131, 9.5077, 2.44151, -2.66382, 1.7916, -2.74509, 0.965509 },
			{ 4.88533, 9.98573, 4.75287, -8.34475, 4.27854, -7.46383, -5.19854, -3.00081, 3.48832, 2.75139 },
			{ 7.57798, -4.2515, 0.994222, -9.10253, -8.2979, 8.30455, -2.24116, 6.19878, -7.8056, -4.13697 },
			{ -9.57734, -5.59282, 4.93949, 4.89752, -4.46268, -5.57855, -9.81338, 3.24227, 1.25879, -8.11472 },
			{ 5.38516, -3.75692, 7.77047, -0.86611, 7.80718, -9.50542, -3.22375, -1.76358, 6.10509, -7.80997 },
		}),
		-19.8241,
	},
}

for _, testCase in testCases do
	local matrix = testCase[1]
	local largestEigenvalue = testCase[2]
	local eigenvalue = EigenSolver.PowerMethod(matrix)

	print(matrix)
	print("Expected: ", largestEigenvalue)
	print("Actual: ", eigenvalue)
	print("PASS: ", math.abs(largestEigenvalue - eigenvalue) < 1e-4)
	print()
end
