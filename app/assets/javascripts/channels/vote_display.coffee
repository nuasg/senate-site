App.vote_display = App.cable.subscriptions.create "VoteDisplayChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log "CONNECTED"

  disconnected: ->
    # Called when the subscription has been terminated by the server

  total_votes: ->
    sum = 0

    total = (x) ->
      parseInt x.textContent

    sum += total z for z in document.querySelectorAll "span.display"
    sum

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log data
    if data["action"] == "change_document"
      @change_document data["new_document"], data["new_document_name"], data["votes"]
    else if data["action"] == "receive_vote"
      return if parseInt(data["document_id"]) != parseInt(document.querySelector("#document").dataset.documentId)
      @receive_vote data["affiliation_id"], data["vote"], data["old_vote"]
    else if data["action"] == "remove_vote"
      return if parseInt(data["document_id"]) != parseInt(document.querySelector("#document").dataset.documentId)
      @remove_vote data["vote"]

  remove_vote: (vote) ->
    obj = document.querySelector("##{vote.replace "_", "-"}s")
    bar = document.querySelector("##{vote.replace "_", "-"}s-bar")

    x = parseInt obj.textContent
    x--

    obj.textContent = x.toString()

    @update_heights()

  update_heights: ->
    tot = @total_votes()
    document.querySelectorAll("span.display").forEach ((total, e) ->
      if total == 0
        total = 1

      bar = e.nextElementSibling
      x = parseInt e.textContent
      bar.style.height = ((x * 100) / total) + "%"
      console.log "x: #{x}, total: #{total}"
    ).bind(this, tot)

  change_document: (new_id, new_name, votes) ->
    doc = document.querySelector("#document")

    if new_id == -1
      ayes = parseInt document.querySelector("#ayes").textContent
      nays = parseInt document.querySelector("#nays").textContent
      if ayes > nays
        doc.textContent += " (Passed)"
      else if ayes < nays
        doc.textContent += " (Failed)"

      doc.dataset.documentId = "-1"
      return

    doc.textContent = new_name
    doc.dataset.documentId = "#{new_id}"

    total_votes = 0

    g = (x) -> x[1]

    total_votes += g y for y in votes

    @load_votes total_votes, votes

  load_votes: (total_votes, votes) ->
    votes.forEach (v) ->
      document.querySelector("##{v[0].replace "_", "-"}s").textContent = v[1].toString()
      document.querySelector("##{v[0].replace "_", "-"}s-bar").style.height = ((v[1] * 100) / total_votes) + "%"

  zero_votes: ->
    document.querySelectorAll("span.display").forEach (e) ->
      e.textContent = "0"

    document.querySelectorAll("span.bar").forEach (e) ->
      e.style.height = "0%"

  receive_vote: (affiliation, vote, old_vote) ->
    if old_vote != null
      old_obj = document.querySelector("##{old_vote.replace "_", "-"}s")
      old_bar = document.querySelector("##{old_vote.replace "_", "-" }s-bar")

      x = parseInt old_obj.textContent
      x--
      old_obj.textContent = x.toString()
      old_bar.style.height = (x * 100 / @total_votes()) + "%"

    obj = document.querySelector("##{vote.replace "_", "-"}s")
    bar = document.querySelector("##{vote.replace "_", "-"}s-bar")

    y = parseInt obj.textContent
    y++
    obj.textContent = y.toString()
    console.log(@total_votes())
    bar.style.height = (y * 100 / @total_votes()) + "%"
