-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Circle loop example
function move_circle(x, y)
    cls()
    circle(x, y, 5)
    vsync() -- Wait for the next frame
end

function update()
    local pos = 0
    
    -- Move the circle from left to right
    while pos < 128 do
        pos = pos + 1
        move_circle(pos, 50)
    end

    -- Move the circle from right to left
    while pos > 0 do
        pos = pos - 1
        move_circle(pos, 50)
    end
end

-- Main loop
while true do
    update()
end