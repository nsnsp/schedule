# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  return unless $('#calendar').length
  $('.day h2').click ->
    $('input#date').focus().click()
  $('input[type=date]').change ->
    window.location = window.location.pathname + '?date=' + $(this).val()
  $('#calendar').fullCalendar
    dayClick: (date, jsEvent, view) ->
      dateString = date.format('YYYY-MM-DD')
      window.location = window.location.pathname + '?date=' + dateString
    dayRender: (date, cell) ->
      cell.addClass('selected') if date.isSame(NSNSP.commitments.defaultDate)
    eventClick: (event, jsEvent, view) ->
      dateString = event.start.format('YYYY-MM-DD')
      window.location = window.location.pathname + '?date=' + dateString
    defaultDate: NSNSP.commitments.defaultDate
    eventAfterAllRender: (view) ->
      $('#calendar-container').removeClass('invisible')
    events: NSNSP.commitments.events
    timezone: NSNSP.commitments.timezone
