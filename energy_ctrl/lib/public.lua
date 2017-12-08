--local event = require ("event")
local component = require("component")
--local computer = require('computer')
--local term =require('term')
local unicode = require('unicode')
gpu = component.gpu
screen_depth=gpu.getDepth
screen_resolution=gpu.getResolution
--gpu.setResolution(50,15)
black = 0x000000
red = 0xFF0000
yellow = 0xFFFF00
white = 0xFFFFFF
gray = 0xC0C0C0
green= 0x008000
screen_x,screen_y=screen_resolution()
screen_x_half=screen_x/2
screen_y_start=3
