# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  input = $('#other-schedule-date').pickadate
    clear: false
    formatSubmit: 'yyyy-mm-dd'
    onSet: (e) ->
      return unless e.select
      $('.tab-content').remove()
      date = $('#other-schedule-date_hidden').val()
      window.location = window.location.pathname + '?date=' + date
  window.calendar = input.data('pickadate')
  $("#other-schedule").click (e) ->
    window.calendar.open()
    e.stopPropagation()
    e.preventDefault()
