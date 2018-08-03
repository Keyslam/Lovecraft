local PATH = (...):gsub('%.init$', '')

local Systems = {
   meshRenderer = require(PATH..".meshRenderer"),
   cameraController = require(PATH..".cameraController"),
   controller = require(PATH..".controller"),
}

return Systems