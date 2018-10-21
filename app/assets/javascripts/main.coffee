window["alertQueue"] = []

# Find alerts in the DOM and activate them after a slight delay to allow the page to settle
window.addEventListener "turbolinks:load", (e) ->
  window.setTimeout ( ->
    alerts = document.querySelectorAll ".alert:not(.test)"

    window["alertQueue"].push alert for alert in alerts

    if window["alertQueue"].length != 0
      runAlerts()
    ), 250

# Show alerts in the queue
window.runAlerts = ->
  if window["alertQueue"].length == 0
    window.alertsRunning = false
    return

  window.alertsRunning = true

  alert = window["alertQueue"].pop();

  alert.classList.add("active");

  # Stop displaying alert after 10 seconds, remove from DOM after that
  window.setTimeout ((e) ->
    e.classList.remove("active");

    window.setTimeout ((f) ->
        f.parentNode.removeChild f

        runAlerts()
    ).bind(null, e),
    300
  ).bind(null, alert),
  10000

# Generate a new alert programmatically
window.newAlert = (x) ->
  cont = document.createElement "div"
  cont.classList.add "alert"
  cont.textContent = x

  document.body.appendChild(cont)

  window.alertQueue.push cont

  window.setTimeout(runAlerts, 250) unless window.alertsRunning == true