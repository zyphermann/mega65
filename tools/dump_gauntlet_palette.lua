-- Run Gauntlet for a few seconds, then dump its 1024 big-endian IRGB4444 words.
-- Usage is documented in reverse-engineering/gauntlet/findings.md.

local frames = 0
local output_name = os.getenv("GAUNTLET_PALETTE_FILE") or "gauntlet-palette.bin"
local dump_frame = tonumber(os.getenv("GAUNTLET_PALETTE_FRAME")) or 900
local autostart = os.getenv("GAUNTLET_AUTOSTART") == "1"
local snapshot_name = os.getenv("GAUNTLET_SNAPSHOT_FILE")
local playfield_name = os.getenv("GAUNTLET_PLAYFIELD_FILE")
local motion_object_name = os.getenv("GAUNTLET_MOTION_OBJECT_FILE")
local main_ram_name = os.getenv("GAUNTLET_MAIN_RAM_FILE")
local spare_video_name = os.getenv("GAUNTLET_SPARE_VIDEO_FILE")
local video_state_name = os.getenv("GAUNTLET_VIDEO_STATE_FILE")
local forced_xscroll = tonumber(os.getenv("GAUNTLET_XSCROLL"))
local forced_yscroll_word = tonumber(os.getenv("GAUNTLET_YSCROLL_WORD"))
local main_memory = manager.machine.devices[":maincpu"].spaces["program"]

local function force_video_state()
    if forced_xscroll then
        main_memory:write_u16(0x904008, forced_xscroll)
        main_memory:write_u16(0x930000, forced_xscroll)
    end
    if forced_yscroll_word then
        main_memory:write_u16(0x90400a, math.floor(forced_yscroll_word / 128))
        main_memory:write_u16(0x905f6e, forced_yscroll_word)
    end
end

local function dump_range(memory, filename, first, last)
    local output = assert(io.open(filename, "wb"))
    for address = first, last do
        output:write(string.char(memory:read_u8(address)))
    end
    output:close()
    print("Wrote " .. filename)
end

local function set_input(port_tag, field_name, active)
    local field = manager.machine.ioport.ports[port_tag].fields[field_name]
    if active then
        field:set_value(1)
    else
        -- MAME 0.227 lacks clear_value(); zero is the inactive digital state
        -- and also works with current MAME releases.
        field:set_value(0)
    end
end

function dump_palette()
    frames = frames + 1
    local memory = main_memory
    -- Gauntlet has no separate start button: a coin enables a player and one
    -- of that player's action buttons joins the running game.  This optional
    -- sequence captures an actual level palette instead of the attract screen.
    if autostart then
        if frames == 960 then set_input(":COIN", "Coin 1", true) end
        if frames == 966 then set_input(":COIN", "Coin 1", false) end
        if frames == 1020 then set_input(":803000", "P1 Button 1", true) end
        if frames == 1026 then set_input(":803000", "P1 Button 1", false) end
        if frames == 1320 then set_input(":803000", "P1 Right", true) end
        if frames == 1326 then set_input(":803000", "P1 Right", false) end
        if frames == 1380 then set_input(":803000", "P1 Button 2", true) end
        if frames == 1386 then set_input(":803000", "P1 Button 2", false) end
    end

    if frames == dump_frame then
        if forced_xscroll then memory:write_u16(0x930000, forced_xscroll) end
        if forced_yscroll_word then memory:write_u16(0x905f6e, forced_yscroll_word) end
    end
    if frames ~= dump_frame then return end

    local output = assert(io.open(output_name, "wb"))
    for address = 0x910000, 0x9107ff do
        output:write(string.char(memory:read_u8(address)))
    end
    output:close()
    print("Wrote " .. output_name)
    if playfield_name then
        dump_range(memory, playfield_name, 0x900000, 0x901fff)
    end
    if motion_object_name then
        dump_range(memory, motion_object_name, 0x902000, 0x903fff)
    end
    if main_ram_name then
        dump_range(memory, main_ram_name, 0x800000, 0x801fff)
    end
    if spare_video_name then
        dump_range(memory, spare_video_name, 0x904000, 0x904fff)
    end
    if video_state_name then
        local output = assert(io.open(video_state_name, "wb"))
        local xscroll = memory:read_u16(0x930000)
        local yscroll = memory:read_u16(0x905f6e)
        output:write(string.char(math.floor(xscroll / 256), xscroll % 256))
        output:write(string.char(math.floor(yscroll / 256), yscroll % 256))
        output:close()
        print("Wrote " .. video_state_name)
    end
    if snapshot_name then
        manager.machine.screens[":screen"]:snapshot(snapshot_name)
        print("Wrote " .. snapshot_name)
    end
end

emu.register_frame_done(dump_palette, "gauntlet_palette_dump")
if forced_xscroll or forced_yscroll_word then
    emu.register_frame(force_video_state, "gauntlet_force_video")
    emu.register_periodic(force_video_state, 0.0001)
end
