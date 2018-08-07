# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery3
#= require popper
#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require_tree .

$(document).on "turbolinks:before-cache", ->
  arr = document.querySelectorAll(".alert:not(.persist)")

  kill = (el) ->
    el.parentElement.removeChild(el)

  kill el for el in arr

  firsts = document.querySelectorAll "ul.app-navigation li:first-child"

  window.clickNavLink(document.getElementById(li.parentElement.dataset.target), li.parentElement, li) for li in firsts
