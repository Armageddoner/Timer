# Timer
A timer class written in ROBLOX's LUAU with several methods for optimal, adjustable functionality.

## User Preferences

Adjustable on the spot, it is easy to create new methods that meet your needs

## Class Framework
- Technology: ROBLOX
- Rationale: To create an abstract way that allows you to delay code without needing to touch the `coroutine` library.

### Structure
- `Timer.new()` :: Class Constructor; Takes in several parameters, `Minutes: number`, `Seconds: number?`, `Displayer: StringValue?`, `Callback: () -> ()?`. Returns `Timer` Object
- `Timer:Start()` :: Method; Takes in one optional parameter, `Yield: boolean?`, which determines whether any code after this method call should yield until the timer is not running. Returns `Timer` Object
- `Timer:Pause()` :: Method; Pauses the timer (Does not call the callback function). Returns `nil`
- `Timer:GetStatus()` :: Method; Returns type `TimerStatus`
- `Timer:Cancel()` :: Method; Cancels and Destroys the `Timer` Object. Returns `nil`.

## Implementation
- Inside ROBLOX Studio, create a new, empty `Module Script` inside `ReplicatedStorage` or `ServerScriptService` (Whichever meets your needs best)
- Copy the contents of `Timer.lua` and paste it into your `Module Script`

### Download Directly
- Alternatively, you may download the code as a `.RBXM` (Roblox Model) and drag-n-drop directly into your studio.
