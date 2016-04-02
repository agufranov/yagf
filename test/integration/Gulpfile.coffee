gulp = require 'gulp'

settings =
  jade:
    'src/**/*.jade': 'build'
  coffee:
    'src/server/**/*.coffee': 'build/server'
    'src/coffeescript/**/debug/**/*.coffee': 'build/client/debug-panel'
  client_coffee:
    'src/coffeescript/app.coffee': 'build/js/app.bundle.js'
  cleanup: 'build'
  server:
    type: 'static'
    root: 'build'
    port: 5040

require('../../gulp/jade') settings
require('../../gulp/client-coffee') settings
require('../../gulp/coffee') settings
require('../../gulp/cleanup') settings
require('../../gulp/live-server') settings

gulp.task 'watch', ['watch:jade', 'watch:client-coffee', 'watch:coffee']
gulp.task 'build', ['build:jade', 'build:client-coffee', 'build:coffee']
gulp.task 'serve', ['watch', 'run-server']
