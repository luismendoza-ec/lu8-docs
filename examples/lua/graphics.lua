-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Graphics example

-- Clear screen with black background
cls(0)

-- Draw a red circle
setcolor(1)  -- Red
circle(160, 120, 50)  -- Center of screen

-- Draw a blue rectangle
setcolor(2)  -- Blue
rect(100, 100, 200, 100)

-- Draw a green line
setcolor(3)  -- Green
line(0, 0, 320, 240)  -- Diagonal line

-- Draw a filled yellow circle
setcolor(4)  -- Yellow
fillcircle(80, 80, 30)

-- Draw a filled purple rectangle
setcolor(5)  -- Purple
fillrect(200, 200, 100, 50)

-- Wait for next frame
vsync() 