App.documents = []

$(document).on 'turbolinks:load', ->
  $("[data-model='document']").each((index, document) ->
    id = document.dataset['documentId']
    App.documents.push(
      App.cable.subscriptions.create {channel: "DocumentsChannel", id: id},
        connected: ->
        # Called when the subscription is ready for use on the server
          console.log "Streaming for document #{id}"

        disconnected: ->
        # Called when the subscription has been terminated by the server

        received: (data) ->
        # Called when there's incoming data on the websocket for this channel
          console.log "Data received (document #{id})."
          console.log data
          if data['voting_open'] == true
            @enable_voting()
          else if data['voting_open'] == false
            @disable_voting()

          if data['updated_status']
            @update_status data['updated_status']

        update_status: (status) ->
          console.log "Vote received. Updating document status."
          $("[data-document-id='#{id}'] .middle .result").text status

        enable_voting: ->
          console.log "Enabling voting for document #{id}"
          $("[data-document-id='#{id}'] .voting input[type='submit']").removeAttr 'disabled'

        disable_voting: ->
          console.log "Disabling voting for document #{id}"
          $("[data-document-id='#{id}'] .voting input[type='submit']").attr 'disabled', 'disabled'
    );
  )
