# Initialize the "three dot" menus that appear next to some rendered models
window.addEventListener "turbolinks:load", ->
  menu_openers = document.querySelectorAll("[data-toggle='menu']")

  # Enable all three dot menus to open their respective menu
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

  # Close the menu if the document is clicked anywhere outside the menu
  document.addEventListener(
    "click",
    (e) ->
      clicked = e.target

      menus = document.querySelectorAll(".context-menu")

      menus.forEach ((clicked, menu) ->
        return if clicked.dataset.toggle == "menu" && menu.parentElement.contains clicked

        unless menu.contains clicked || !menu.classList.contains "open"
          menu.classList.remove "open"
          menu.style.height = "0"
      ).bind this, clicked
  )