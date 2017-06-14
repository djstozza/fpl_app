$(document).ready ->
  $('.js-generate-code').click ->
    $('.js-league-code').val(Math.random().toString(36).substr(2))
