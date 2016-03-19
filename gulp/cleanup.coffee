gulp = require 'gulp'
del = require 'del'

module.exports = (settings) ->
  gulp.task 'cleanup', ->
    del settings.cleanup
