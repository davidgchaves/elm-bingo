var entryPoint = require('../dist/index.html');
var styles     = require('./style.css');
var Elm        = require('./Bingo');

Elm.embed(
  Elm.Bingo,
  document.getElementById('app')
);
