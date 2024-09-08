# LDtk importer for Defold

## WIP

## Installation
You can use the LDtk importer in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

https://github.com/iamnabholz/defold-ldtk-importer/archive/master.zip

Or point to the ZIP file of a [specific release](https://github.com/iamnabholz/defold-ldtk-importer/releases).

## Quick Start
Getting started with the LDtk importer is easy:

1. Right click on the LDtk file on your project tree view.
2. Click on `Generate Tilemaps` to generate a Defold tilemap from each level of your LDtk project.
3. You can also generate a Lua module for each `Entity layer` so you can use them in your game.

## Setup
In LDtk you can create a new value that holds the path for your `.tilesource` file in Defold, needed for every tilemap

- Create a new `string` property called `tileset`, and as a value add the path for your `.tilesource` file from your project tree