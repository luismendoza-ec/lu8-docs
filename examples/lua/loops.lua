-- This examples are still experimental, please don't expect them to work
-- I am just implementing a simple Lua transpiler to ASM for fun
-- Luis Mendoza

-- Loops example

-- While loop
count = 0
while count < 5 do
    print(count)  -- Will print 0, 1, 2, 3, 4
    count = count + 1
end

-- Counter loop
for i = 1, 5 do
    print(i)  -- Will print 1, 2, 3, 4, 5
end