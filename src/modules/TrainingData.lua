-- Muscle Legends v3.7.3 observed training fixtures.
-- Values are client-visible inspection observations, not server guarantees.
return {
    Version = "3.7.3",
    Equipment = {
        { name = "Bench Press", attribute = "Strength", requirement = 10, strengthGain = 11, durabilityGain = 1, repTime = 1 },
        { name = "Squat Rack", attribute = "Strength", requirement = 1000, strengthGain = 12, durabilityGain = 2, repTime = 1 },
        { name = "Pullups", attribute = "Strength", requirement = 1000, strengthGain = 12, agilityGain = 1, repTime = 1 },
        { name = "Deadlift", attribute = "Strength", requirement = 8000, strengthGain = 21, repTime = 1.5 },
        { name = "Boulder Throw", attribute = "Strength", requirement = 25000, strengthGain = 26, durabilityGain = 13, repTime = 1 },
        { name = "Treadmill", attribute = "Agility", requirement = 100, agilityGain = 3, repTime = nil },
        { name = "Punching Rock", attribute = "Durability", requirement = 10, durabilityGain = 2, repTime = nil },
    },
    PetExamples = {
        { name = "Leaf Chameleon", strength = 415, durability = 470, agility = 360, damage = 4125 },
        { name = "Moonlight Fox", strength = 640, durability = 725, agility = 555, damage = 6375 },
        { name = "Prismcore Hound", strength = 800, durability = 600, agility = 625, damage = 8500 },
        { name = "Inferno Drake", strength = 10000, durability = 10000, agility = 10000, damage = nil },
    },
    GymUnlocks = {
        { name = "Eternal Gym", requirementType = "Rebirths", requirement = 15 },
        { name = "Industrial Gym", requirementType = "Rebirths", requirement = 150 },
    },
}
