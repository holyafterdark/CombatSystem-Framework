local HitboxModule = {}

-- { constants }
local DEFAULT_SIZE = Vector3.new(7, 6, 6)
local DEFAULT_OFFSET = Vector3.new(0, 0, -4)
local MAX_RANGE = 20

-- { functions }
local function getOverlapParams(ignore)
	local op = OverlapParams.new()
	op.FilterType = Enum.RaycastFilterType.Exclude
	op.FilterDescendantsInstances = ignore
	op.MaxParts = 50
	return op
end

function HitboxModule.Cast(attackerChar, opts)
	opts = opts or {}
	local size = opts.Size or DEFAULT_SIZE
	local offset = opts.Offset or DEFAULT_OFFSET

	local hrp = attackerChar and attackerChar:FindFirstChild("HumanoidRootPart")
	if not hrp then return {} end

	local cf = hrp.CFrame * CFrame.new(offset)
	local parts = workspace:GetPartBoundsInBox(cf, size, getOverlapParams({ attackerChar }))

	local hits = {}
	local seen = {}
	for _, part in pairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")
		if model and not seen[model] then
			local hum = model:FindFirstChildOfClass("Humanoid")
			local mhrp = model:FindFirstChild("HumanoidRootPart")
			if hum and mhrp and hum.Health > 0 and model ~= attackerChar then
				if (mhrp.Position - hrp.Position).Magnitude <= MAX_RANGE then
					seen[model] = true
					table.insert(hits, model)
				end
			end
		end
	end
	return hits
end

return HitboxModule
