path = require 'path'
natural = require 'natural'

{ msgVariables, getMessage } = require path.join '..', 'lib', 'common.coffee'
answers = {}
livechat_department = (process.env.LIVECHAT_DEPARTMENT_ID || null )

class Respond
  constructor: (@interaction) ->
  process: (msg) =>
    lc_dept = @interaction.department or livechat_department
    no_online_agents_msg = 'Sorry, there is no online agents to transfer to.'
    offline_message = @interaction.offline or no_online_agents_msg

    msg.sendWithNaturalDelay getMessage(@interaction, msg)

    action = @interaction.action?.toLowerCase() or false
    switch action
      when 'transfer'
        @livechatTransfer(msg, 3000, lc_dept, offline_message, type)

  livechatTransfer: (msg, delay = 3000, lc_dept, offline_message, type) ->
    setTimeout((-> msg.robot.adapter.callMethod('livechat:transfer',
                  roomId: msg.envelope.room
                  departmentId: lc_dept
                ).then (result) ->
                  if result == true
                    console.log 'livechatTransfer executed!'
                  else
                    console.log 'livechatTransfer NOT executed!'
                    msg.sendWithNaturalDelay getMessage(offline_message, msg)
              ), delay)

module.exports = Respond