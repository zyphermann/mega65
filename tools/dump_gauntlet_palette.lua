-- Run Gauntlet for a few seconds, then dump its 1024 big-endian IRGB4444 words.
-- Usage is documented in reverse-engineering/gauntlet/findings.md.

local frames = 0

function dump_palette()
    frames = frames + 1
    -- After 15 seconds the power-on RAM/ROM tests and title setup are complete.
    if frames ~= 900 then return end

    local memory = manager.machine.devices[":maincpu"].spaces["program"]
    local output = assert(io.open("gauntlet-palette.bin", "wb"))
    for address = 0x910000, 0x9107ff do
        output:write(string.char(memory:read_u8(address)))
    end
    output:close()
    print("Wrote gauntlet-palette.bin")
end

emu.register_frame_done(dump_palette, "gauntlet_palette_dump")
