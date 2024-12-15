-- Quest System Module
local QuestSystem = {}

-- Quest class to represent a single quest
local Quest = {}
Quest.__index = Quest

function Quest.new(name)
    local self = setmetatable({}, Quest)
    self.name = name
    self.steps = {}
    self.current_step_index = 1
    print("New Quest Created: " .. name)
    return self
end

-- Step class to represent each step in the quest
local Step = {}
Step.__index = Step

function Step.new(name, description, location, reward)
    local self = setmetatable({}, Step)
    self.name = name
    self.description = description
    self.location = location -- Location is a table representing a vector
    self.reward = reward
    self.completed = false
    print("New Step Added: " .. name)
    return self
end

-- Function to add a step to the quest
function Quest:addStep(name, description, location, reward)
    local step = Step.new(name, description, location, reward)
    table.insert(self.steps, step)
end

-- Function to check if all steps are completed
function Quest:isCompleted()
    for _, step in ipairs(self.steps) do
        if not step.completed then
            return false
        end
    end
    return true
end

-- Function to handle step completion, called from Unreal Engine
function QuestSystem:completed_step(step)
    if self.current_quest then
        local current_step = self.current_quest.steps[self.current_quest.current_step_index]
        if current_step and current_step.name == step then
            current_step.completed = true
            print("Step '" .. step .. "' completed!")
            if self.current_quest.current_step_index < #self.current_quest.steps then
                self.current_quest.current_step_index = self.current_quest.current_step_index + 1
                print("Moving to next step: " .. self.current_quest.steps[self.current_quest.current_step_index].name)
            else
                -- Quest completed, handle rewards or any other end-of-quest logic here
                print("Quest '" .. self.current_quest.name .. "' completed!")
            end
        else
            print("Error: Step '" .. step .. "' not found or not current.")
        end
    else
        print("Error: No active quest.")
    end
end

-- Function to get current step details, including location as a vector
function QuestSystem:getCurrentStepDetails()
    if self.current_quest and self.current_quest.current_step_index <= #self.current_quest.steps then
        local current_step = self.current_quest.steps[self.current_quest.current_step_index]
        print("Current Step Details: " .. current_step.name)
        return {
            name = current_step.name,
            description = current_step.description,
            location = current_step.location, -- This will be a table {x, y, z}
            reward = current_step.reward
        }
    else
        print("No more steps or no active quest.")
        return nil -- No more steps or no active quest
    end
end

-- Initialization function to set up a new quest
function QuestSystem:initializeQuest(name)
    self.current_quest = Quest.new(name)
    print("Quest '" .. name .. "' initialized.")
end

-- Method to add a step from Blueprint
function QuestSystem:addStep(name, description, locationX, locationY, locationZ, reward)
    if self.current_quest then
        self.current_quest:addStep(name, description, {locationX, locationY, locationZ}, reward)
    else
        print("Error: Cannot add step, no active quest.")
    end
end

--Example
--QuestSystem:initializeQuest("The First Day")
--QuestSystem:addStep("Buy a Turret Seed", "desc", 0.1, 0.3, 0.4, "5 Gold")

return QuestSystem