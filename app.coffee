express = require 'express'
path = require 'path'
mongoose = require 'mongoose'
favicon = require 'serve-favicon'
logger = require 'morgan'
passport = require 'passport'
login = require('./private/coffee/login') passport
cookieParser = require 'cookie-parser'
session = require("express-session")
MongoStore = require("connect-mongo")(session)
bodyParser = require 'body-parser'
multer = require 'multer'
routes = require './routes'

app = express()
mongoose.connect(process.env.MONGOLAB_URI);

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use multer dest: './public/uploads'
app.use logger('dev')
app.use bodyParser.json(limit: '50mb')
app.use bodyParser.urlencoded
  extended: false
  limit: '50mb'
app.use cookieParser()
app.use session(
  secret: "foo"
  store: new MongoStore(url: process.env.MONGOLAB_URI)
)
app.use passport.initialize()
app.use passport.session()
app.use express.static(path.join(__dirname, 'public'))

# Routes
app.use '/', routes.index
app.use '/auth/error', routes.authError
app.get '/auth/facebook', passport.authenticate('facebook',
  scope: 'email'
)
app.get '/auth/facebook/callback', passport.authenticate('facebook',
  failureRedirect: '/auth/error'
), routes.authSuccess

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}

module.exports = app