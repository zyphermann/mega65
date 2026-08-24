-- Capture Gauntlet's completely drawn large illustrated title screen.

local frame = 0
-- Frame 9510 matches the gold/red GAUNTLET logo phase of the arcade artwork.
local capture_frame = tonumber(os.getenv("GAUNTLET_TITLE_FRAME")) or 9510
local phase_frame = tonumber(os.getenv("GAUNTLET_TITLE_PHASE_FRAME")) or 9540
local screen = manager.machine.screens[":screen"]

local function capture_title_screen()
    frame = frame + 1
    if frame == capture_frame then
        screen:snapshot("title-screen.png")
    elseif frame == phase_frame then
        screen:snapshot("title-screen-phase.png")
    end
end

emu.register_frame_done(capture_title_screen, "gauntlet_title_screen_capture")
