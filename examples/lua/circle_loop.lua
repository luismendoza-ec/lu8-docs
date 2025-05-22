-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Circle loop example

function update()
    -- Move the circle from left to right
    for i = 1, 128 do
        cls()
        circle(i, 50, 5)
        vsync() -- Wait for the next frame
    end

    -- Move the circle from right to left
    for i = 1, 128 do
        cls()
        circle(128 - i, 50, 5)
        vsync() -- Wait for the next frame
    end
end

-- Main loop
while true do
    -- Update the circle position
    update()
end