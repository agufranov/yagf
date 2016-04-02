gulp = require 'gulp'
watch = require 'gulp-watch'
jade = require 'gulp-jade'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
path = require 'path'
es = require 'event-stream'
_ = require 'lodash'

module.exports = (settings) ->
  onError = (err) ->
    filename = path.relative process.cwd(), err.path
    at = err.message.match(/:([\w]+)/)[1]
    notify.onError(
      title: 'Jade error'
      message: "#{filename}:#{at}"
    )(err)

  pipeToJade = (p, dest) ->
    p
      .pipe plumber(errorHandler: onError)
      .pipe jade()
      .pipe gulp.dest dest

  gulp.task 'build:jade', ->
    es.merge _.map settings.jade, (dest, src) ->
      pipeToJade gulp.src(src), dest

  gulp.task 'watch:jade', ['build:jade'], ->
    es.merge _.map settings.jade, (dest, src) ->
      pipeToJade watch(src, verbose: true, name: 'Jade'), dest
