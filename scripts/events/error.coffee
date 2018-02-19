path = require 'path'
natural = require 'natural'

{ getMessage } = require path.join '..', 'lib', 'common.coffee'

answers = {}

class Error
  constructor: (@interaction) ->
  process: (msg) =>
    msg.sendWithNaturalDelay getMessage(@interaction, msg)

module.exports = Error
