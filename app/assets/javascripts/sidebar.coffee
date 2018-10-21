# Activate dropdowns and sidebar animations
window.addEventListener "turbolinks:load", ->
  dropdowns = document.querySelectorAll "nav li.dropdown > a"

  initDropdown = (e) ->
    # Prevent page refresh
    e.removeAttribute "href"

    e.addEventListener "click", ->
      this.parentElement.classList.toggle "open"

      ul = this.parentElement.querySelector "ul"
      if this.parentElement.classList.contains "open"
        # Require height != auto for animations to work
        ul.style.height = ul.scrollHeight + "px"
      else
        ul.style.height = ""

  initDropdown dropdown for dropdown in dropdowns

  # Find sidebar open button (appears on mobile)
  openSidebar = document.querySelector "#open-sidebar"
  if openSidebar
    openSidebar.addEventListener "click", ->
      sidebar = document.querySelector "section#sidebar"
      shade = document.querySelector "div#shade"

      sidebar.classList.toggle "open"

      if sidebar.classList.contains "open"
        shade.classList.add "open"
        document.body.classList.add "shade"
      else
        shade.classList.remove "open"
        document.body.classList.remove "shade"

  # Setup screen shade
  shade = document.querySelector "div#shade"
  if shade
    shade.addEventListener "click", ->
      sidebar = document.querySelector "section#sidebar"

      sidebar.classList.remove "open"
      this.classList.remove "open"
      document.body.classList.remove "shade"