initCheckboxes = ->
  x = document.querySelectorAll "input[data-affiliation]"

  # Require that a sub be set if sub is checked for an affiliation
  assign = (obj) ->
    obj.addEventListener "change", ->
      aff = this.dataset.affiliation
      id1 = "#sub-name-#{aff}"
      id2 = "#sub-netid-#{aff}"
      document.querySelector(id1).removeAttribute "readonly" if this.checked
      document.querySelector(id1).setAttribute("readonly","readonly") unless this.checked
      document.querySelector(id2).removeAttribute "readonly" if this.checked
      document.querySelector(id2).setAttribute("readonly","readonly") unless this.checked

  assign obj for obj in x

initAll = ->
  initCheckboxes()

$(document).on "turbolinks:load", initAll