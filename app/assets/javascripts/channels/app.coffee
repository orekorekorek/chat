App.app = App.cable.subscriptions.create "AppChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    updatePage data['message']

updatePage = (json) ->
  online_users_element = document.getElementById('online_list')
  if !online_users_element
    return

  data = JSON.parse json
  { id, nickname, online } = data

  user = online_users_element.querySelector("[data-user-id=\"#{id}\"]")

  if user && !online
    user.remove()
  else if !user && online
    online_users_element.innerHTML += "<p data-user-id=\"#{id}\">#{nickname}</p>"
