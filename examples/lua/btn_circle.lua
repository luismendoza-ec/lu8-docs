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

function draw_player(x, y)
    circle(x, y, 5)
end

function game_loop()
    local pos_x = 128 / 2
    local pos_y = 128 / 2

    while true do
        cls(0)

        if btn(BUTTON_LEFT) and pos_x > 0 then
            pos_x = pos_x - 1
        end

        if btn(BUTTON_RIGHT) and pos_x < 128 then
            pos_x = pos_x + 1
        end

        if btn(BUTTON_UP) and pos_y > 0 then
            pos_y = pos_y - 1
        end

        if btn(BUTTON_DOWN) and pos_y < 128 then
            pos_y = pos_y + 1
        end

        draw_player(pos_x, pos_y)
        vsync()
    end
end

game_loop()
