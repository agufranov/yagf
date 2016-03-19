gulp = require 'gulp'
watch = require 'gulp-watch'
gls = require 'gulp-live-server'
path = require 'path'

module.exports = (settings) ->
  gulp.task 'run-server', ['build'], ->
    if settings.server.type is 'static'
      server = gls.static settings.server.root, settings.server.port
      server.start()
      watch path.join(settings.server.root, '**'), verbose: true, name: 'Static server', (file) ->
        server.notify path: file.relative
