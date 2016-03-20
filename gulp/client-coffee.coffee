gulp = require 'gulp'
browserify = require 'browserify'
watchify = require 'watchify'
coffeeify = require 'coffeeify'
watch = require 'gulp-watch'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
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

  bundleFn = (dest, src, isWatch, debug) ->
    args =
      entries: [src]
      extensions: ['.coffee']
      transform: [coffeeify]
      debug: debug

    b = if isWatch
      watchify browserify _.assign {}, watchify.args, args
    else
      browserify args

    doBundle = ->
      t1 = Date.now()
      b
        .bundle()
        .on 'error', onError
        .pipe source dest
        .pipe buffer()
        .pipe sourcemaps.init loadMaps: true
        .pipe uglify()
        .pipe sourcemaps.write()
        .pipe gulp.dest '.'
        .on 'end', ->
          t2 = Date.now()
          console.log "Browserify finished in #{t2 - t1} ms"

    if isWatch
      b.on 'update', doBundle

    doBundle()

  gulp.task 'build:client-coffee', ->
    es.merge _.map settings.client_coffee, (dest, src) ->
      bundleFn dest, src, false, true

  gulp.task 'watch:client-coffee', ->
    es.merge _.map settings.client_coffee, (dest, src) ->
      bundleFn dest, src, true, true
