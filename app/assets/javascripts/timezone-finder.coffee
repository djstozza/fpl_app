$(document).ready ->
  tz = jstz.determine()
  $.cookie 'timezone', tz.name(), path: '/'
