gulp = require 'gulp'

settings =
  jade:
    'test/src/test-jade/jade/**/*.jade': 'test/build'
    'test/src/test-jade/other-jade/**/*.jade': 'test/build/otherjade'
  cleanup: 'test/build'
  server:
    type: 'static'
    root: 'test/build'
    port: 5040

require('./gulp/jade') settings
require('./gulp/cleanup') settings
require('./gulp/live-server') settings

gulp.task 'watch', ['watch:jade']
gulp.task 'build', ['build:jade']
gulp.task 'serve', ['watch', 'run-server']
