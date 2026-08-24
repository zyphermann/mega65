-- Record every distinct active Gauntlet Motion Object descriptor and palette.
-- The output is an append-only CSV suitable for repeated MAME runs.

local frame = 0
local output_name = os.getenv("GAUNTLET_MO_TRACE_FILE") or "motion-object-trace.csv"
local start_frame = tonumber(os.getenv("GAUNTLET_MO_TRACE_START")) or 900
local autostart = os.getenv("GAUNTLET_AUTOSTART") == "1"
local main_memory = manager.machine.devices[":maincpu"].spaces["program"]
local seen = {}

local output = assert(io.open(output_name, "w"))
output:write("first_frame,slot,raw_code,decoded_code,width,height,xflip,palette,palette_words\n")
output:flush()

local function set_input(port_tag, field_name, active)
    local field = manager.machine.ioport.ports[port_tag].fields[field_name]
    field:set_value(active and 1 or 0)
end

local function palette_words(group)
    local words = {}
    local first = 0x910000 + (256 + group * 16) * 2
    for pen = 0, 15 do
        words[#words + 1] = string.format("%04X", main_memory:read_u16(first + pen * 2))
    end
    return table.concat(words, " ")
end

local function active_slots()
    local active = {}
    -- The SLIP table supplies one linked-list head per 8-pixel raster band.
    -- Follow each 10-bit chain exactly once; stop on a local cycle.
    for band = 0, 63 do
        local slot = main_memory:read_u16(0x905f80 + band * 2) % 0x400
        local followed = {}
        for _ = 1, 1024 do
            if followed[slot] then break end
            followed[slot] = true
            active[slot] = true
            slot = main_memory:read_u16(0x903800 + slot * 2) % 0x400
        end
    end
    return active
end

local function trace_motion_objects()
    frame = frame + 1
    if autostart then
        if frame == 960 then set_input(":COIN", "Coin 1", true) end
        if frame == 966 then set_input(":COIN", "Coin 1", false) end
        if frame == 1020 then set_input(":803000", "P1 Button 1", true) end
        if frame == 1026 then set_input(":803000", "P1 Button 1", false) end
        -- Keep the player moving and firing so walking, attacks, projectiles,
        -- impacts and nearby enemy states enter MO RAM during an unattended run.
        local phase = frame % 480
        set_input(":803000", "P1 Right", phase >= 0 and phase < 120)
        set_input(":803000", "P1 Down", phase >= 120 and phase < 240)
        set_input(":803000", "P1 Left", phase >= 240 and phase < 360)
        set_input(":803000", "P1 Up", phase >= 360 and phase < 480)
        set_input(":803000", "P1 Button 1", frame > 1080 and frame % 24 < 8)
    end
    if frame < start_frame then return end

    for slot, _ in pairs(active_slots()) do
        local raw_code = main_memory:read_u16(0x902000 + slot * 2) % 0x8000
        local x_palette = main_memory:read_u16(0x902800 + slot * 2)
        local y_size = main_memory:read_u16(0x903000 + slot * 2)
        local palette = x_palette % 16
        local width = math.floor(y_size / 8) % 8 + 1
        local height = y_size % 8 + 1
        local xflip = math.floor(y_size / 64) % 2
        if raw_code ~= 0 then
            local colours = palette_words(palette)
            local key = string.format("%04X,%d,%d,%d,%d,%s",
                raw_code, width, height, xflip, palette, colours)
            if not seen[key] then
                seen[key] = true
                local decoded_code = (raw_code ~ 0x0800) % 0x8000
                output:write(string.format("%d,%d,%04X,%04X,%d,%d,%d,%d,\"%s\"\n",
                    frame, slot, raw_code, decoded_code, width, height,
                    xflip, palette, colours))
                output:flush()
            end
        end
    end
end

emu.register_frame_done(trace_motion_objects, "gauntlet_motion_object_trace")
