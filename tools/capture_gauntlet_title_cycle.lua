-- Capture consecutive phases of Gauntlet's animated illustrated title screen.
-- The PNG sequence is an analysis input; only the moving logo pixels are used
-- to construct the hardware-ready Neo-Geo palette tables.

local frame = 0
local first_frame = tonumber(os.getenv("GAUNTLET_TITLE_CYCLE_FIRST")) or 9510
local last_frame = tonumber(os.getenv("GAUNTLET_TITLE_CYCLE_LAST")) or 9720
local frame_step = tonumber(os.getenv("GAUNTLET_TITLE_CYCLE_STEP")) or 3
local output_directory = os.getenv("GAUNTLET_TITLE_CYCLE_DIR") or "."
local screen = manager.machine.screens[":screen"]

local function capture_title_cycle()
    frame = frame + 1
    if frame < first_frame or frame > last_frame then return end
    if (frame - first_frame) % frame_step ~= 0 then return end
    local filename = string.format(
        "%s/title-cycle-%05d.png", output_directory, frame)
    screen:snapshot(filename)
    print("Wrote " .. filename)
end

emu.register_frame_done(capture_title_cycle, "gauntlet_title_cycle_capture")
