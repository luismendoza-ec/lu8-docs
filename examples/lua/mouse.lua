-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Move the red circle with the mouse

function game_loop()
    setcolor(8)

    while true do
        cls()

        mouse_x = peek(0xFF16)
        mouse_y = peek(0xFF17)

        circle(mouse_x, mouse_y, 5)
        vsync()
    end
end

game_loop()