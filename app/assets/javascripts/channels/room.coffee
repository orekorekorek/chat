channel = null

jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')

  console.log(channel)

  messages.scrollTop(messages.prop('scrollHeight'))

  if messages.length > 0
    channel = createRoomChannel messages.data('room-id')
  else
    channel?.unsubscribe()
    return

  $(document).on 'keypress', '#message_body', (event) ->
    message = event.target.value
    if event.keyCode is 13
      App.room.speak(message) if message != ''
      event.target.value = ""
      event.preventDefault()

createRoomChannel = (roomId) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", roomId: roomId},
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#messages').append data['message']
      scrollDown()

    speak: (message) ->
      @perform 'speak', message: message

scrollDown = ->
  messages = $('#messages')

  scrollHeight = messages.prop('scrollHeight')

  currentUserId = $('.card-body').data('user-id')

  lastMessage = messages.children().last()

  if lastMessage.data('user-id') == currentUserId
    messages.scrollTop scrollHeight
    return

  lastElementHeight = lastMessage.outerHeight(true)
  if scrollHeight - Math.round(messages.scrollTop()) == lastElementHeight + messages.prop('clientHeight')
    messages.scrollTop scrollHeight
