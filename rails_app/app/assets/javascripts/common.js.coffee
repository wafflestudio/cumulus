Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

Array::empty = ->
  @.length is 0

window.intersection = (a, b) ->
  [a, b] = [b, a] if a.length > b.length
  value for value in a when value in b
