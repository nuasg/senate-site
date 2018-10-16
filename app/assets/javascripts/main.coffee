window["alertQueue"] = []

window.addEventListener "turbolinks:load", (e) ->
  window.setTimeout ( ->
    alerts = document.querySelectorAll ".alert:not(.test)"

    window["alertQueue"].push alert for alert in alerts

    if window["alertQueue"].length != 0
      runAlerts()
    ), 250

window.runAlerts = ->
  if window["alertQueue"].length == 0
    window.alertsRunning = false
    return

  window.alertsRunning = true

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

window.newAlert = (x) ->
  cont = document.createElement "div"
  cont.classList.add "alert"
  cont.textContent = x

  document.body.appendChild(cont)

  window.alertQueue.push cont

  window.setTimeout(runAlerts, 250) unless window.alertsRunning == true