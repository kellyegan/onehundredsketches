---
layout: page
title: Tile generator
full-width: true
---

My first experiment using [paper.js](http://paperjs.org/). Each tile is generated from a stack of shapes which expose shapes below them. The idea came from a trip to the children's museum with my daughter. <strong>Click on a tile to enlarge that pattern.</strong>

<style>
/* Scale canvas with resize attribute to full size */
canvas[resize] {
  width: 100%;
  height: 630px;
}
</style>

<p style="text-align: right;"><a id="reset">Reset</a></p>
<canvas id="theCanvas" resize="true"></canvas>

<p>Find the source code <a href="https://gist.github.com/kellyegan/e2d57b7a1cb504688127a9af57cdda3d">here.</a></p>

<script type="text/javascript" src="libraries/paper-full.min.js" async></script>
<script type="text/paperscript" src="tile-generator.js" canvas="theCanvas" async></script>