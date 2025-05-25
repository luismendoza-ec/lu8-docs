-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- pget() example

cls()

pset(10, 10, 12) -- set a pixel at (10, 10) with color 12

color = pget(10, 10) -- get the color of the pixel at (10, 10)

print(color) -- print the color to the console