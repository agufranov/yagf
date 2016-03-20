gulp = require 'gulp'

settings =
  jade:
    # 'test/src/test-jade/jade/**/*.jade': 'test/build'
    # 'test/src/test-jade/other-jade/**/*.jade': 'test/build/otherjade'
    'test/integration/src/**/*.jade': 'test/integration/build'
  client_coffee:
    # 'test/src/coffeescript/app.coffee': 'test/build/main/app.bundle.js'
    # 'test/src/debug/lib/debug.coffee': 'test/build/lib/debug/bundle.js'
    'test/integration/src/coffeescript/app.coffee': 'test/integration/build/js/app.bundle.js'
  cleanup: 'test/integration/build'
  server:
    type: 'static'
    root: 'test/integration/build'
    port: 5040

require('./gulp/jade') settings
require('./gulp/client-coffee') settings
require('./gulp/cleanup') settings
require('./gulp/live-server') settings

gulp.task 'watch', ['watch:jade', 'watch:client-coffee']
gulp.task 'build', ['build:jade', 'build:client-coffee']
gulp.task 'serve', ['watch', 'run-server']
