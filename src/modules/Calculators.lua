local Calculators = {}

function Calculators.Training(equipment, currentValue, targetValue, multiplier)
    currentValue = math.max(0, tonumber(currentValue) or 0)
    targetValue = math.max(0, tonumber(targetValue) or 0)
    multiplier = math.max(0, tonumber(multiplier) or 1)
    if not equipment then return nil, "Select equipment" end
    if currentValue < (equipment.requirement or 0) then
        return { available = false, requirement = equipment.requirement, remaining = (equipment.requirement or 0) - currentValue }
    end
    local gainKey = ({ Strength = "strengthGain", Durability = "durabilityGain", Agility = "agilityGain" })[equipment.attribute]
    local gain = (gainKey and equipment[gainKey] or 0) * multiplier
    if gain <= 0 then return nil, "No verified gain value for this equipment" end
    local needed = math.max(0, targetValue - currentValue)
    local reps = math.ceil(needed / gain)
    local seconds = equipment.repTime and reps * equipment.repTime or nil
    return { available = true, gainPerRep = gain, reps = reps, seconds = seconds, minutes = seconds and seconds / 60 or nil }
end

function Calculators.BestEquipment(equipmentList, currentValue, targetValue, multiplier)
    local candidates = {}
    for _, equipment in ipairs(equipmentList) do
        local result = Calculators.Training(equipment, currentValue, targetValue, multiplier)
        if result and result.available and result.seconds then
            table.insert(candidates, { equipment = equipment, result = result })
        end
    end
    table.sort(candidates, function(a, b) return a.result.seconds < b.result.seconds end)
    return candidates
end

function Calculators.PetScore(pet, profile)
    local weights = profile or { strength = 1, durability = 1, agility = 1, damage = 1 }
    local score = 0
    local available = false
    for stat, weight in pairs(weights) do
        local value = pet[stat]
        if type(value) == "number" then
            score += value * weight
            available = true
        end
    end
    return available and score or nil
end

return Calculators
