initMeetings = ->
  x = document.querySelector "#term-select"

  if x?
    x.addEventListener "change", () ->
      Turbolinks.visit(this.options[this.selectedIndex].dataset.url)

initCheckboxes = ->
  x = document.querySelectorAll "input[data-affiliation]"

  assign = (obj) ->
    obj.addEventListener "change", ->
      aff = this.dataset.affiliation
      id1 = "#sub-name-#{aff}"
      id2 = "#sub-netid-#{aff}"
      document.querySelector(id1).removeAttribute "disabled" if this.checked
      document.querySelector(id1).setAttribute("disabled","") unless this.checked
      document.querySelector(id2).removeAttribute "disabled" if this.checked
      document.querySelector(id2).setAttribute("disabled","") unless this.checked

  assign obj for obj in x

initAll = ->
  initMeetings()
  initCheckboxes()


$(document).on "turbolinks:load", initAll