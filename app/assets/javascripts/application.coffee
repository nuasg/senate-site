#= require jquery3
#= require popper
#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require cable
#= require_tree .

# Deletes all elements that wouldn't show up on a page refresh so that
# Turbolinks doesn't show them if the user re-visits this page
$(document).on "turbolinks:before-cache", ->
  # Currently, the only elements are .alerts, and they can be specified to stay by adding the
  # .persist class
  arr = document.querySelectorAll(".alert:not(.persist)")

  kill = (el) ->
    el.parentElement.removeChild(el)

  kill el for el in arr

  menus = document.querySelectorAll ".context-menu.open"

  close = (menu) ->
    menu.style.height = "0"
    menu.classList.remove "open"

  # If any navigation tabs exist, navigate to the first one, because otherwise
  # it will "jump" from the last tab to the first tab if the user navigates back to this page.
  firsts = document.querySelectorAll "ul.app-navigation li:first-child"

  window.clickNavLink(document.getElementById(li.parentElement.dataset.target), li.parentElement, li) for li in firsts
