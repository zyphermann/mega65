-- Capture two phases after the cartridge has initialized the LSPC.

local frame = 0
local capture_frame = tonumber(os.getenv("NEOGEO_DEMO_CAPTURE_FRAME")) or 180
local phase_frame = tonumber(os.getenv("NEOGEO_DEMO_PHASE_FRAME")) or capture_frame + 6
local cycle_frame = tonumber(os.getenv("NEOGEO_DEMO_CYCLE_FRAME")) or capture_frame + 486
local output = os.getenv("NEOGEO_DEMO_SNAPSHOT") or "gauntlet-neogeo-demo.png"
local phase_output = os.getenv("NEOGEO_DEMO_PHASE_SNAPSHOT") or "gauntlet-neogeo-demo-phase.png"
local cycle_output = os.getenv("NEOGEO_DEMO_CYCLE_SNAPSHOT") or "gauntlet-neogeo-demo-cycle.png"
local screen = manager.machine.screens[":screen"]
local cpu = manager.machine.devices[":maincpu"]
local memory = cpu.spaces["program"]

local function capture(path)
        local pc = cpu.state["PC"].value
        local request = memory:read_u8(0x10fdae)
        local palette16 = memory:read_u16(0x400202)
        local marker = memory:read_u16(0x400442)
        print(string.format(
            "Gauntlet demo state: frame=%d PC=%06X request=%02X palette16.1=%04X marker34.1=%04X USER=%04X/%08X code=%04X",
            frame, pc, request, palette16, marker, memory:read_u16(0x122),
            memory:read_u32(0x124), memory:read_u16(0x200)))
        screen:snapshot(path)
        print("Wrote " .. path)
end

local function capture_demo()
    frame = frame + 1
    if frame == capture_frame then
        capture(output)
    elseif frame == phase_frame then
        capture(phase_output)
    elseif frame == cycle_frame then
        capture(cycle_output)
    end
end

emu.register_frame_done(capture_demo, "gauntlet_neogeo_demo_capture")
