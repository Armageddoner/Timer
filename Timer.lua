-- Class initiation
local Timer = {}
Timer.__index = Timer

-- Services
local RunService = game:GetService("RunService")

type TimerStatus = "Stasis" | "Counting" | "Paused" | "Dead"

--[[
	Creates a new "Timer" object which takes in the parameters of Minutes, Seconds, and Displayer
	If displayer is not provided, the timer will only act as a means to yield the thread.
]]
function Timer.new(Minutes : number, Seconds : number?, Displayer : StringValue?, Callback: () -> ()?)
	local TimeData = {
		Minutes = Minutes,
		Seconds = Seconds or 0,
		TimerRoutine = nil,
		_TimerStatus = "Stasis",
		_CountdownFunction = nil,
		Displayer = Displayer,
		Callback = Callback
	}
	TimeData._CountdownFunction = function()

		while true do
			if TimeData.Seconds == 0 then
				if TimeData.Minutes ~= 0 then
					TimeData.Minutes -= 1
					TimeData.Seconds = 60
				end
			end
			if TimeData.Minutes == 0 and TimeData.Seconds == 0 then
				if Callback and type(Callback) == "function" then
					Callback()
				end
				break
			end
			TimeData.Seconds -= 1
			task.wait(1)
			if TimeData.Seconds >= 10 then
				if Displayer then
					assert(Displayer)
					Displayer.Value = `{TimeData.Minutes}:{TimeData.Seconds}`
				end
			elseif TimeData.Seconds <= 9 then
				if Displayer then
					assert(Displayer)
					Displayer.Value = `{TimeData.Minutes}:0{TimeData.Seconds}`
				end
			end
		end
		TimeData._TimerStatus = "Dead"
	end
	TimeData.TimerRoutine = coroutine.create(TimeData._CountdownFunction)
	return setmetatable(TimeData, Timer)
end

-- Starts the timer in a new thread. Takes in one optional parameter <code>Yield</code>, which will halt the thread until the timer is complete, if true.
function Timer:Start(Yield : boolean?)
	if self._TimerStatus == "Dead" then
		error("Cannot start a dead timer.")
	end
	if self._TimerStatus == "Counting" then
		error("Cannot start a timer already counting.")
	end
	
	if coroutine.status(self.TimerRoutine) == "dead" and self._TimerStatus == "Paused" then -- For resuming a timer
		print("Resuming paused timer")
		self.TimerRoutine = coroutine.create(self._CountdownFunction)
	--else
		--print(coroutine.status(self.TimerRoutine), self._TimerStatus)
	end
	self._TimerStatus = "Counting"
	local Success = coroutine.resume(self.TimerRoutine)
	if Yield then
		repeat
			RunService.Heartbeat:Wait()
		until (coroutine.status(self.TimerRoutine) == "dead" and self._TimerStatus ~= "Paused") or self._TimerStatus == "Dead" -- stupid typing error
		print(Success)
	end
	return Timer
end

-- Pauses the timer. This does <em>not</em> call the callback function provided
function Timer:Pause()
	assert(typeof(self.TimerRoutine) == "thread", `The timer routine is not a thread! Here is what it is: {self.TimerRoutine}`)
	if self._TimerStatus == "Dead" then
		error("Cannot pause a dead timer.")
	end
	print("Pausing")
	self._TimerStatus = "Paused"
	coroutine.close(self.TimerRoutine)
end

-- Gets the state of the timer.
-- <code>"Stasis" | "Counting" | "Paused" | "Dead"</code>
function Timer:GetStatus() : TimerStatus
	return self._TimerStatus
end

--[[
	Cancels and Destroys the <code>Timer</code> object.
	This does not call the callback function provided.
]]
function Timer:Cancel()
	if self.Displayer then
		self.Displayer.Value = "0:00"
	end
	self._TimerStatus = "Dead"
	if typeof(self.TimerRoutine) == "thread" then
		coroutine.close(self.TimerRoutine)
	end
	self = nil
end


return Timer
