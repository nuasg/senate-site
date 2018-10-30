# Enable voting form alert response if form exists
window.addEventListener(
  "turbolinks:load",
  ->
    $('div.voting form').on("ajax:success",
      (e) ->
        console.log e.detail
        if e.detail[0].result == 'success'
          $("div[data-document-id='#{e.detail[0]['document_id']}'] .middle").replaceWith(e.detail[0]['new_content'])
          newAlert 'Your vote has been cast.'
        else
          newAlert e.detail[0].message
    )
    $('div.voting form').on("ajax:error",
      (e) ->
        console.log e.detail[0]
        newAlert 'There was an error casting your vote. Please see the speaker of the senate.'
    )
)