gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
path = require 'path'
es = require 'event-stream'
_ = require 'lodash'

module.exports = (settings) ->
  onError = (err) ->
    if err.filename isnt undefined
      filename = path.relative process.cwd(), err.filename
      reason = err.message.replace ": #{err.filename}", ""
      message = "#{filename}:#{err.line} [#{reason}]"
    else
      message = err.message
    notify.onError(
      title: "CoffeeScript error"
      message: message
    )(err)

  pipeToCoffee = (p, dest) ->
    p
      .pipe plumber(errorHandler: onError)
      .pipe coffee()
      .pipe gulp.dest dest

  gulp.task 'build:coffee', ->
    es.merge _.map settings.coffee, (dest, src) ->
      pipeToCoffee gulp.src(src), dest

  gulp.task 'watch:coffee', ['build:coffee'], ->
    es.merge _.map settings.coffee, (dest, src) ->
      pipeToCoffee watch(src, verbose: true, name: 'Coffee'), dest
