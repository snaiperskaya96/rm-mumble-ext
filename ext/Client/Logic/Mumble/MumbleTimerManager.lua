class "MumbleTimerManager" 

local FunctionUtilities = require 'Logic/Utilities/FunctionUtilities'

function MumbleTimerManager:__init()
    self.Events = {}
    self.Time = 0
end

function MumbleTimerManager:Update(deltaTime)
    if self.Time > 999999999 then
        for index, event in pairs(self.Events) do
            event.LastRun = event.Timeout - self.Time - self.LastRun
        end
        self.Time = 0
    end

    self.Time = self.Time + deltaTime
    for index, event in pairs(self.Events) do
        if event.LastRun == -1 then
            event.LastRun = self.Time
        end
        
        if self.Time - event.LastRun >= event.Timeout then
            event.LastRun = self.Time
            event:TriggerEvent()
            if event.RunOnce then
                table.remove(self.Events, index)
            end
        end

    end
end

function MumbleTimerManager:AddEvent(newEvent)
    if not FunctionUtilities:IsFunction(newEvent.TriggerEvent) then
        print('MumbleEventManager:AddEvent: The passed value is not a valid Event (TriggerEvent() not available)')
        return
    end

    if newEvent.Timeout == nil then
        print('MumbleEventManager:AddEvent: The passed value is not a valid Event (Timeout not available)')
        return
    end

    if newEvent.RunOnce == nil then
        print('MumbleEventManager:AddEvent: The passed value is not a valid Event (RunOnce not available)')
        return
    end

    newEvent.LastRun = -1;

    table.insert(self.Events, newEvent)
end

Instance = MumbleTimerManager()
return Instance