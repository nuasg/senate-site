# Refresh whenever the server says to refresh
if $('meta[name="user"]').length
  App.refresh = App.cable.subscriptions.create "RefreshChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      location.reload()
