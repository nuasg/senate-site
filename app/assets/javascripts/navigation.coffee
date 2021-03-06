# Setup the navigation panes when loading the page
document.addEventListener "turbolinks:load", ->
  navs = document.querySelectorAll "ul.app-navigation[data-target]"

  activateNav nav for nav in navs

# If the location's hash changes, open the corresponding tab
window.addEventListener "hashchange", ->
  tab = location.hash.substr 1
  tabEl = document.querySelector "[data-target='#{tab}']"

  if tabEl
    nav = tabEl.parentElement
    container = document.getElementById nav.dataset.target

    window.clickNavLink container, nav, tabEl

# Setup script for the navigation panes
activateNav = (nav) ->
  container = document.getElementById nav.dataset.target
  navLinks = nav.querySelectorAll "li[data-target]"

  # Add a specialized copy of +clickNavLink+ to each navigation link
  navLink.addEventListener("click", window.clickNavLink.bind(null, container, nav, navLink)) for navLink in navLinks

  activate = navLinks[0]

  tab = location.hash.substr 1
  tabEl = document.querySelector "[data-target='#{tab}']"

  activate = tabEl if tabEl

  window.clickNavLink container, nav, activate

# Simulate a click on a navigation link
window.clickNavLink = (container, nav, navLink) ->
  disableContentPanes container
  disableNavLinks nav

  contentPane = document.querySelector "[data-name='#{navLink.dataset.target}']"

  navLink.classList.add "active"
  contentPane.classList.add "active"

  location.hash = "##{navLink.dataset.target}"

# Close all content panes in a container; make it display nothing
disableContentPanes = (container) ->
  panes = container.querySelectorAll ".tab-sec"

  pane.classList.remove "active" for pane in panes

# Make all navigation links in a navigation pane inactive
disableNavLinks = (nav) ->
  navLinks = nav.querySelectorAll "li[data-target]"

  navLink.classList.remove "active" for navLink in navLinks