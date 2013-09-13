# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

client = new Dropbox.Client(key: 'ka8heojsz0ho4is')

client.authenticate
  interactive: false
  , (error) ->
    alert "Authentication error: " + error  if error

client.isAuthenticated()
