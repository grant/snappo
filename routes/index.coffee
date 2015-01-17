express = require 'express'
router = express.Router()

routes =
  # GET home page.
  index: router.get '/', (req, res) ->
    res.render 'index'

  # List of images
  list: (req, res) ->
    console.log 'list'
    console.log req.user
    res.json req.user

  # FB auth error
  authError: (req, res) ->
    res.send 'error'

  # FB auth success
  authSuccess: (req, res) ->
    # res.json req.user
    res.redirect '/list'

module.exports = routes