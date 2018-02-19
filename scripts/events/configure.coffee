require 'coffeescript/register'
path = require 'path'
natural = require 'natural'

{
  msgVariables,
  stringElseRandomKey,
  loadConfigfile,
  getConfigFilePath,
  getMessage
} = require '../lib/common'

{ checkRole } = require '../lib/security.coffee'

answers = {}

class Configure
  constructor: (@interaction) ->

  process: (msg) =>
    if @interaction.role?
      if checkRole(msg, @interaction.role)
        @act(msg)
      else
        denied_msg = "*Acces Denied* Action requires role #{@interaction.role}"
        msg.sendWithNaturalDelay denied_msg
    else
      @act(msg)

  setVariable: (msg) ->
    configurationBlock = msg.message.text.replace(msg.robot.name + ' ', '')
      .split(' ')[-1..].toString()

    configKeyValue = configurationBlock.split('=')
    configKey = configKeyValue[0]
    configValue = configKeyValue[1]

    key = 'configure_' + configKey + '_' + msg.envelope.room

    msg.robot.brain.set(key, configValue)
    msg.sendWithNaturalDelay getMessage(@interaction, msg)
    return

  retrain: (msg) ->
    console.log 'Inside retrain'
    scriptPath = path.join __dirname, '..'

    global.config = loadConfigfile getConfigFilePath()
    global.train()

    msg.sendWithNaturalDelay getMessage(@interaction, msg)
    return

  act: (msg) ->
    action = @interaction.action or 'setVariable'
    console.log action
    switch action
      when 'setVariable'
        @setVariable(msg)
      when 'train'
        @retrain(msg)
    return

module.exports = Configure