window.addEventListener "turbolinks:load", ->
  dropdowns = document.querySelectorAll "nav li.dropdown > a"

  initDropdown = (e) ->
    e.removeAttribute "href"

    e.addEventListener "click", ->
      this.parentElement.classList.toggle "open"

      ul = this.parentElement.querySelector "ul"
      if this.parentElement.classList.contains "open"
        ul.style.height = ul.scrollHeight + "px"
      else
        ul.style.height = ""

  initDropdown dropdown for dropdown in dropdowns

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

  shade = document.querySelector "div#shade"
  if shade
    shade.addEventListener "click", ->
      sidebar = document.querySelector "section#sidebar"

      sidebar.classList.remove "open"
      this.classList.remove "open"
      document.body.classList.remove "shade"

  meetingNav = document.querySelector "ul.meeting-navigation"
  if meetingNav
    tabLinks = meetingNav.querySelectorAll "li"

    tabLinkActivate = (e) ->
      e.addEventListener "click", ->
        tab = this

        tab.classList.add "active"

        tabs = tab.parentElement.querySelectorAll "li"

        temp = (a, f) ->
          if a != f
            f.classList.remove "active"

        temp this, tab for tab in tabs

    tabLinkActivate tabLink for tabLink in tabLinks