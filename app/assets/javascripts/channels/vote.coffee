for el in document.querySelectorAll("[data-votable]")
  App.cable.subscriptions.create { channel: "VoteChannel", document: el.dataset.documentId },
    received: (data) ->
      doc = document.querySelector("[data-votable][data-document-id=''")
      if (data["voting-enabled"])

      else