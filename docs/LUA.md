# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lua Programming Guide for Lu8 Mini Console

This guide covers the Lua programming features supported by the Lu8 Mini Console. The implementation is based on Lua 5.1 with some specific features and limitations.

## Table of Contents
- [Basic Syntax](#basic-syntax)
- [Variables and Data Types](#variables-and-data-types)
- [Control Structures](#control-structures)
- [Functions](#functions)
- [Graphics Functions](#graphics-functions)
- [Built-in Functions](#built-in-functions)

## Basic Syntax

Lua is a lightweight, high-level programming language. Here's the basic syntax:

```lua
-- This is a comment
x = 10  -- Variable declaration and assignment
y = 20  -- Variable assignment
```

## Variables and Data Types

The Lu8 Mini Console currently supports only numeric values:

- **Numbers**: Integer values
  ```lua
  x = 42
  y = -10
  ```

## Control Structures

### If Statements

The console supports if-elseif-else statements:

```lua
if condition then
    -- code
elseif another_condition then
    -- code
else
    -- code
end
```

Supported comparison operators:
- `==` (equal to)
- `~=` (not equal to)
- `>` (greater than)
- `<` (less than)
- `>=` (greater than or equal to)
- `<=` (less than or equal to)

### Loops

#### For Loop
Numeric for loops are supported:

```lua
for i = start, end, step do
    -- code
end
```

The step parameter is optional and defaults to 1.

#### While Loop
```lua
while condition do
    -- code
end
```

## Functions

### Function Declaration
```lua
function name(parameter1, parameter2)
    -- function body
    return value
end
```

### Function Call
```lua
result = functionName(arg1, arg2)
```

## Graphics Functions

The Lu8 Mini Console provides several graphics functions for creating visual output:

### Basic Drawing
- `pset(x, y, color)`: Set a pixel at coordinates (x,y) with specified color
  ```lua
  pset(10, 20, 1)  -- Draw a pixel at (10,20) with color 1
  ```

- `line(x1, y1, x2, y2)`: Draw a line from (x1,y1) to (x2,y2)
  ```lua
  line(0, 0, 100, 100)  -- Draw a diagonal line
  ```

### Shapes
- `rect(x, y, width, height)`: Draw an unfilled rectangle
  ```lua
  rect(10, 10, 50, 30)  -- Draw a 50x30 rectangle
  ```

- `fillrect(x, y, width, height)`: Draw a filled rectangle
  ```lua
  fillrect(10, 10, 50, 30)  -- Draw a filled 50x30 rectangle
  ```

- `circle(x, y, radius)`: Draw an unfilled circle
  ```lua
  circle(50, 50, 20)  -- Draw a circle with radius 20
  ```

- `fillcircle(x, y, radius)`: Draw a filled circle
  ```lua
  fillcircle(50, 50, 20)  -- Draw a filled circle with radius 20
  ```

### Screen Management
- `cls([color])`: Clear the screen with optional background color
  ```lua
  cls()     -- Clear screen with default color
  cls(1)    -- Clear screen with color 1
  ```

- `vsync()`: Wait for vertical sync
  ```lua
  vsync()  -- Synchronize with screen refresh
  ```

### Color Management
- `setcolor(color)`: Set the current drawing color
  ```lua
  setcolor(2)  -- Set color to 2
  ```

- `resetpal()`: Reset the color palette to default values
  ```lua
  resetpal()  -- Reset colors
  ```

### `setpal(index, r, g, b)`

Changes the color at the specified palette index to a new RGB value.
Each component (`r`, `g`, `b`) must be an integer between `0` and `255`.

* **index**: Palette index (0–15)
* **r**: Red component (0–255)
* **g**: Green component (0–255)
* **b**: Blue component (0–255)

```lua
-- Set palette index 3 to lime green
setpal(3, 0, 255, 0)
```

> ⚠️ The index must be a constant value between 0 and 15. Dynamic expressions or variables are not supported.

> This affects all future drawings using this color index, until `resetpal()` is called.

### Text
- `drawchar(charIndex)`: Draw a character from the font set
  ```lua
  drawchar(65)  -- Draw character 'A'
  ```

## Built-in Functions

### Print
- `print(value)`: Print a numeric value to the console
  ```lua
  print(42)  -- Output: 42
  ```

### Random
- `rnd()`: Generates a random number between 0 and 255
  ```lua
  x = rnd()           -- Store random number in x
  if rnd() == 2 then  -- Use in condition
      -- do something
  end
  y = rnd() + 1      -- Use in expression
  ```

## Input Functions

Lu8 provides an easy-to-use function to check button states:

### `btn(mask [, player])`

Returns `true` if the specified button (or combination) is currently pressed.
If the `player` is not provided, it defaults to Player 1.

```lua
if btn(BUTTON_RIGHT) then
  print("Player 1 is moving right!")
end

if btn(BUTTON_A, PLAYER_2) then
  print("Player 2 pressed A")
end
```

## Input Constants

### Button Masks

```lua
BUTTON_A      = 0x01  -- Bit 0
BUTTON_B      = 0x02  -- Bit 1
BUTTON_SELECT = 0x04  -- Bit 2
BUTTON_START  = 0x08  -- Bit 3
BUTTON_UP     = 0x10  -- Bit 4
BUTTON_DOWN   = 0x20  -- Bit 5
BUTTON_LEFT   = 0x40  -- Bit 6
BUTTON_RIGHT  = 0x80  -- Bit 7
```

### Player Constants

```lua
PLAYER_1 = 0
PLAYER_2 = 1
```

## Example Programs

### Simple Animation
```lua
function update()
    cls()
    for i = 0, 10 do
        circle(50 + i * 5, 50, 5)
    end
    vsync()
end

while true do
    update()
end
```

### Interactive Drawing
```lua
x = 0
y = 0

function update()
    if x < 100 then
        x = x + 1
        pset(x, y, 1)
    end
    vsync()
end

while true do
    update()
end
```

## Limitations

1. Only numeric values are supported
2. No string support
3. Local variables are supported now but this implementation has not been fully tested
4. No support for tables or complex data structures
5. Limited memory management
6. No support for coroutines or metatables

## Best Practices

1. Use `vsync()` for smooth animations
2. Clear the screen with `cls()` at the start of each frame
3. Keep functions small and focused
4. Use meaningful variable names
5. Comment your code for better readability 