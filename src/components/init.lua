local PATH = (...):gsub('%.init$', '')

local Components = {
   transform = require(PATH..".transform"),
   mesh = require(PATH..".mesh"),
   camera = require(PATH..".camera"),
   controllable = require(PATH..".controllable"),
}

return Components