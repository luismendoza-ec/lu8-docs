-- Change color index 3 to lime green
setpal(3, 0, 255, 0)

-- Set background to black and clear screen
cls(0)

-- Set draw color to index 3 (now lime green)
setcolor(3)

-- Draw a filled rectangle with the new color
fillrect(20, 20, 80, 80)

-- Wait for a while (simulate ~60 frames)
i = 0
while i < 60 do
  vsync()
  i = i + 1
end

-- Restore default palette
resetpal()

-- Clear screen again
cls(0)

-- Draw same rectangle again using color 3 (should now be dark green again)
setcolor(3)
fillrect(20, 20, 80, 80)

-- Infinite loop
while true do
  vsync()
end
