window.addEventListener "turbolinks:load", ->
  menu_openers = document.querySelectorAll("[data-toggle='menu']")

  menu_openers.forEach (opener) ->
    opener.addEventListener(
      "click",
      () ->
        menu = this.parentElement.parentElement.querySelector(".context-menu")
        ht = menu.scrollHeight

        menu.classList.toggle "open"

        if menu.classList.contains "open"
          menu.style.height = "#{ht}px"
        else
          menu.style.height = "0"
    )

  document.addEventListener(
    "click",
    (e) ->
      clicked = e.target

      menus = document.querySelectorAll(".context-menu")

      menus.forEach ((clicked, menu) ->
        return if clicked.dataset.toggle == "menu"

        unless menu.contains clicked || !menu.classList.contains "open"
          menu.classList.remove "open"
          menu.style.height = "0"
      ).bind this, clicked
  )