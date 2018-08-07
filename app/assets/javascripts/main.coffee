window["alertQueue"] = []

window.addEventListener "turbolinks:load", (e) ->
  window.setTimeout ( ->
    alerts = document.querySelectorAll ".alert:not(.test)"

    window["alertQueue"].push alert for alert in alerts

    if window["alertQueue"].length != 0
      runAlerts()
    ), 250

runAlerts = ->
  if window["alertQueue"].length == 0
    return

  alert = window["alertQueue"].pop();

  alert.classList.add("active");

  window.setTimeout ((e) ->
    e.classList.remove("active");

    window.setTimeout ((f) ->
        f.parentNode.removeChild f

        runAlerts()
    ).bind(null, e),
    300
  ).bind(null, alert),
  10000