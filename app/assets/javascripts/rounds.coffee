$(document).ready ->
  # Adapted from https://gist.github.com/tim-reynolds/3019761
  centerItVariableWidth = (target, outer) ->
    out = $(outer)
    tar = $(target)
    x = out.width()
    y = tar.outerWidth(true)
    z = tar.index()
    q = 0
    m = out.find('li')
    i = 0
    while i < z
      q += $(m[i]).outerWidth(true)
      i++
    out.scrollLeft Math.max(0, q - ((x - y) / 2))

  # Sets the active tab as the centre of the horizontal scroll nav bar
  centerItVariableWidth('li.active', '.js-scrollable-nav')
