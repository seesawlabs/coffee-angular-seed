gulp = require('gulp')
gutil = require('gulp-util')
plugins = require('gulp-load-plugins')()
runSequence = require('run-sequence')

paths = 
  styles: './app/**/*.sass'
  app: './app/**/*.coffee'
  templates: './app/**/*.jade'

  public: 
    css: './public/css/**.*'
    app: './public/js/**.*'
    templates: './public/templates/**/**.*'

config = require('./config')

gulp.task 'build', (done)->
  runSequence ['sass', 'coffee', 'jade'], done

gulp.task 'default', (done)->
  runSequence 'build', ['nodemon', 'watch'], done

gulp.task 'coffee', ->
  gulp.src paths.app
    .pipe plugins.coffee
      bare: true
    .on 'error', gutil.log
    .pipe plugins.concat('bundle.js')
    .pipe gulp.dest('./public/js/')
  return

gulp.task 'jade', ->
  gulp
    .src './app/**/*.jade'
    .pipe plugins.jade
      pretty: true
      locals:
        config: config
    .on 'error', gutil.log
    .pipe gulp.dest('./public')

gulp.task 'sass', (done)->
  gulp.src(paths.styles)
    .pipe plugins.sass()
    .on 'error', plugins.sass.logError
    .pipe plugins.minifyCss
      keepSpecialComments: 0
    .pipe plugins.concat('styles.css')
    .pipe plugins.rename
      extname: '.min.css'
    .pipe gulp.dest('./public/css/')
    .on 'end', done
  return

gulp.task 'watch', ->
  plugins.livereload.listen()

  gulp.watch(paths.styles, ['sass'])
  gulp.watch(paths.app, ['coffee'])
  gulp.watch(paths.templates, ['jade'])

  gulp.watch(paths.public.css).on 'change', plugins.livereload.changed
  gulp.watch(paths.public.app).on 'change', plugins.livereload.changed
  gulp.watch(paths.public.templates).on 'change', plugins.livereload.changed
  return

gulp.task 'nodemon', ->
  plugins.nodemon
    script: 'server.js'
    nodeArgs: ['--debug']
    ext: 'js,css,html'
    watch: './**/**.*'
    env: 
      NODE_ENV: 'development'
      port: config.port


gulp.task 'dev', ->
  gulp.src('template/app.settings.js')
  .pipe(plugins.preprocess(context:
    NODE_ENV: 'DEVELOPMENT'
    DEBUG: true))
  .pipe gulp.dest('www/js')
  return

gulp.task 'test_env', ->
  gulp.src('template/app.settings.js')
  .pipe(plugins.preprocess(context:
    NODE_ENV: 'TEST'
    DEBUG: true))
  .pipe gulp.dest('www/js')
  return

gulp.task 'prod', ->
  gulp.src('template/app.settings.js')
  .pipe(plugins.preprocess(context: NODE_ENV: 'PRODUCTION'))
  .pipe gulp.dest('www/js')
  return

