# **Giraffe Game**
<img width="700" alt="Screen Shot 2024-11-01 at 11 35 14 AM" src="https://github.com/user-attachments/assets/0730e38e-c484-4d63-8448-96a6149199ee">

Welcome to **Giraffe Game**! This game is built with **Lua** and **LÖVE 2D**. Jump, avoid obstacles, and gather collectibles to reach the highest score!

This game is a work in progress. It started a few years ago and is now actively maintained and improved. Expect regular updates as new features are added, bugs are fixed, and gameplay is refined!

---

### Features
- **Characters and Enemies**: Control a customizable avatar, and encounter butterflies, birds, and worms.
- **Sound and Animation**: Engaging music and sound effects, with sprite-based animations.
---

### Getting Started

To play this game, you’ll need:
- **Lua**: The scripting language used to build the game logic.
- **LÖVE 2D**: A framework for 2D game development in Lua.

1. **Download and Install LÖVE 2D**  
   Get LÖVE from [the official LÖVE website](https://love2d.org/), and follow installation instructions for your operating system.

2. **Clone the Repository**
3. **Run the Game with LÖVE**  
   Use the following command to launch the game:
   ```bash
   love .

Enjoy!

<img src="https://github.com/user-attachments/assets/642c23f4-c85e-46a9-bfc1-297e7ee7885d" alt="Description of image" width="700"/>

---
### Development

#### Class Structure in Lua

Since Lua does not have a built-in "class" construct, object-oriented programming concepts such as inheritance are achieved through metatables. For example, the `Butterfly` class is defined as follows:


```lua
Butterfly = {}
Butterfly.__index = Butterfly
setmetatable(Butterfly, {
  __index = Still,
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
```
---

### Bug Reporting
Everyone is free to report bugs, suggest fixes, and share ideas for improvements. Your feedback is invaluable in making this game better.
Please open an issue on GitHub for any bugs or suggestions.

### Credits:
* Starting music:
Music by <a href="https://pixabay.com/users/desifreemusic-28163210/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=243043">Omar Faruque</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=243043">Pixabay</a>
* backround music:
Music by <a href="https://pixabay.com/users/turtlebeats-46526702/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=251696">TurtleBeats</a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=251696">Pixabay</a>
* Ending music:
 Music by <a href="https://pixabay.com/users/marshallb-7250253/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=12023">MarshallB</a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=12023">Pixabay</a>


