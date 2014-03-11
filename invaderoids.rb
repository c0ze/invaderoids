require 'rubygems'
require 'gosu'

ASSETS_DIR = Pathname.new "./assets"
GFX_DIR = ASSETS_DIR + "gfx"
AUDIO_DIR = ASSETS_DIR + "audio"

LIB_DIR = Pathname.new "./lib"

LIBS = ['engine', 
        'zorder',
        'alien',
        'bullet',
        'energy_bar',
        'explosion',
        'hud',
        'ship']

LIBS.each{|lib| require_relative LIB_DIR + lib}


game = Engine::Game.instance
game.show
