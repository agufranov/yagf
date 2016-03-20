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
  watchify.args.verbose = true
  onError = (err) ->
    # filename = path.relative process.cwd(), err.filename
    # at = err.location.first_line + 1
    # notify.onError(
    #   title: "#{err.name} [#{err.message}]"
    #   message: "#{filename}:#{at}"
    # )(err)
    notify.onError({ title: 'Title', message: 'Message' })(err)
  onError = notify.onError()

  m = (dest, src, isWatch, debug) ->
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
      doBundle()
      b.on 'update', doBundle
      # gulp.watch src, (file) ->
      #   console.log "watchify watch: #{file.relative} changed"
      watch src, verbose: true, name: 'watchify watch'
    else
      doBundle()

  gulp.task 'build:client-coffee', ->
    es.merge _.map settings.client_coffee, (dest, src) ->
      m dest, src, false, true

  gulp.task 'watch:client-coffee', ->
    es.merge _.map settings.client_coffee, (dest, src) ->
      m dest, src, true, true
