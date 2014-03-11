Simple shooter game that shows how to use the Gosu library to create a game with Ruby. This example game uses a small simple framework which allows the programmer to create and handle custom sprites and game states (ie, game screens such as the main menu, the play screen, etc).

Running
=======

__Linux__

install dependencies for gosu :

    apt-get install build-essential freeglut3-dev libfreeimage-dev libgl1-mesa-dev libopenal-dev libpango1.0-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsndfile-dev libxinerama-dev

install bundler and dependencies :

    gem install bundler
	bundle install --path vendor

Then run the invaderoids.rb file:

    bundle exec ruby invaderoids.rb

__OSX__

install ruby 1.9. Install bundler and dependencies :

    gem install bundler
	bundle install --path vendor

Then run the invaderoids.rb file:

    bundle exec ruby invaderoids.rb

__Windows__

install ruby 1.9 from [ruby installer](http://rubyinstaller.org/downloads/)

install bundler and dependencies :

    gem install bundler
	bundle install

Then run the invaderoids.rb file:

    bundle exec ruby invaderoids.rb


How to play
===========

Menu controls:

* Use the arrow keys (up and down) to browse the different menu options
* Press Enter or the space bar to select the highlighted option
* Press Esc to quit the game or go back to the main menu screen 

In game controls:

* Use the arrow keys to move the space ship horizontally and vertically
* Hit the space bar to shoot the aliens
* Avoid colliding with aliens!
* Press Esc to go back to the main menu

Credits & copying
=================

This game is based on [Space Shooters by (c) 2009 Belén Albeza González](https://github.com/belen-albeza/space-shooter).
I changed the gameplay to look like Asteroids instead of a Space Invaders game and added some public domain & free music and sound samples :

* Music Credits
    - Menu Screen : [Strobe & Rebb – Melonia](http://www.milkytracker.org/?download)
	- In game     : [Reed - Civilian](http://www.cvgm.net/demovibes/song/4224/)
	- Gameover    : [Tim Wright - Shadow of the Beast II](http://www.exotica.org.uk/wiki/Shadow_of_the_Beast_II)
* [Sound samples](http://soundbible.com/free-sound-effects-1.html)

Graphics and source code released under the MIT license. See LICENSE for details.
