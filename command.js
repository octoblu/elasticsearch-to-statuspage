#!/usr/bin/env node
require('coffee-script/register');
require('fs-cson/register');

module.exports = require('./command.coffee');
