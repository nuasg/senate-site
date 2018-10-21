if !window.location.pathname.startsWith("/display") && $('meta[name="user"]').length
  App.voting = App.cable.subscriptions.create "VotingChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      console.log data
      doc = data['new_document']

      if doc == -1
        $(".voting[data-voting-enabled]").attr('data-voting-enabled', 'false')
        $(".voting[data-voting-enabled] input[type='submit']").attr('disabled', 'disabled')
      else
        console.log doc
        $(".voting[data-voting-enabled][data-document-id='#{doc}']").attr('data-voting-enabled', 'true')
        $(".voting[data-voting-enabled][data-document-id='#{doc}'] input[type='submit']").removeAttr('disabled')
