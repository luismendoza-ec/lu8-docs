-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Conditional statements example
x = 10
y = 20

-- Simple if statement
if x < y then
    print(1)
end

-- If-else statement
if x > y then
    print(1)  -- Will print 1 if x > y
else
    print(0)  -- Will print 0 if x <= y
end

-- Multiple conditions
if x == 10 and y == 20 then
    print(1)  -- Will print 1 if both conditions are true
end

if x == 10 or y == 30 then
    print(1)  -- Will print 1 if at least one condition is true
end

-- Minimal test
if x > 5 then
    print(1)
end 