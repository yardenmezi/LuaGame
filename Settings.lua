startSound = love.audio.newSource('sounds/birdTutorial.mp3', 'static')

sounds = {
  ['gameMusic'] = love.audio.newSource('sounds/backround_music.mp3', 'static'),
  ['gameOver'] = love.audio.newSource('sounds/lookAtMeNow.wav', 'static'),
  ['scaryNoise'] = love.audio.newSource('sounds/toodoom.wav', 'static'),
  ['bark'] = love.audio.newSource('sounds/bark.wav', 'static'),
  ['jump'] =love.audio.newSource('sounds/woop.wav', 'static'),
  ['eat'] = love.audio.newSource('sounds/leaf.wav', 'static'),
  ['coinTaking'] = love.audio.newSource('sounds/leaf.wav', 'static')
}

images = {
  ['bird'] = love.graphics.newImage('images/bird.png'),
  ['worm'] =  love.graphics.newImage('images/wormFrames.png'),
  ['butterfly'] = love.graphics.newImage('images/spriteButterfly.png'),
  ['giraffe'] = love.graphics.newImage('images/tmpGiff.png'),
  ['backround'] = love.graphics.newImage('images/clouds.png'),
  ['coin'] = love.graphics.newImage('images/leaf.png'),
  ['grass'] = love.graphics.newImage('images/GreenGrass.png')
}

fonts = {
  ['instruction'] = love.graphics.setNewFont(20),
  ['title'] = love.graphics.setNewFont(50),
  ['game'] = love.graphics.setNewFont(40)
}

messages ={
  ['startStateTitle']='Welcome!',
  ['gameInstructions'] =  {"Press arrows to move", "Press 'w' to jump", "Press 'q' to move butterfly when your'e on it (action takes a leaf)", "Beware of birds!", "Press ENTER to start game!"}
}

