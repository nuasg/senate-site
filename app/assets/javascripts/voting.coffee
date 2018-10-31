# Enable voting form alert response if form exists
$(document).on "ajax:success",
  (event) ->
    console.log event
    console.log event.detail
    [data, status, xhr] = event.detail
    id = $(event.target).closest('[data-model="document"]')[0].dataset['documentId'];

    $("div[data-document-id='#{id}'] .voting").replaceWith(data['new_content'])
    newAlert 'Your vote has been cast.'

$('div.voting form').on "ajax:error",
  (e) ->
    console.log e.detail[0]
    newAlert 'There was an error casting your vote. Please see the speaker of the senate.'