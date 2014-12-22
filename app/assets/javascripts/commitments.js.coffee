# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $('#calendar').fullCalendar
    dayClick: (date, jsEvent, view) ->
      dateString = date.format('YYYY-MM-DD')
      window.location = window.location.pathname + '?date=' + dateString
    dayRender: (date, cell) ->
      cell.addClass('selected') if date.isSame(NSNSP.commitments.defaultDate)
    defaultDate: NSNSP.commitments.defaultDate
    timezone: NSNSP.commitments.timezone
