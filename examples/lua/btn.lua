-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Input handling example

-- Button constants
BUTTON_A      = 0x01
BUTTON_B      = 0x02
BUTTON_SELECT = 0x04
BUTTON_START  = 0x08
BUTTON_UP     = 0x10
BUTTON_DOWN   = 0x20
BUTTON_LEFT   = 0x40
BUTTON_RIGHT  = 0x80

-- Main loop
while true do
    -- Check if the LEFT button is held
    if btn(BUTTON_LEFT) then
        cls(2)
    -- Check if the RIGHT button is held
    elseif btn(BUTTON_RIGHT) then
        cls(3)
    -- Check if the UP button is held
    elseif btn(BUTTON_UP) then
        cls(4)
    -- Check if the DOWN button is held
    elseif btn(BUTTON_DOWN) then
        cls(5)
    end
    -- Wait for the next frame
    vsync()
end