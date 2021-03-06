request = require 'request'
moment = require 'moment'
apiPath = 'http://104.236.41.161/'
DEFAULT_TOKEN = 'YreIoA-nX26yqbOrAz45CA'


# A wrapper for `https://github.com/rcchen/sh-server`
module.exports =
  get:
    photos: (sort="recency", cb) ->
      url = apiPath + 'api/photos'
      params =
        token: DEFAULT_TOKEN
        longitude: 75
        latitude: 39
        radius: 100
        sort: sort
      console.log("sorting by "+sort)
      request {url: url, qs: params}, (err, res, body) ->
        json = JSON.parse body
        for photo in json
          photo.created_at_text = moment(photo.created_at).fromNow()
        cb json
  post:
    users: (email, cb) ->
      url = apiPath + 'api/users'
      console.log email
      console.log url
      request.post
        url: url
        qs:
          email: email
      , (err, res, body) ->
        # Return user object
        cb JSON.parse body
    photos: (photo, token, lat, lng, cb) ->
      # TODO
      cb()
    heart: (photoId, token, cb) ->
      console.log "server!"
      console.log photoId
      console.log token
      url = apiPath + 'api/photos/' + photoId + '/heart'
      request.post
        url: url
        xhrFields:
          withCredentials: true
        form:
          token: token
      , (err, res, body) ->
        # Return the current state of the heart
        console.log body
        cb JSON.parse body