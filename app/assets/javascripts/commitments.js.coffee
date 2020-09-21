# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  onDateClick = (dateString) ->
    $('body').addClass 'wait'
    window.location = window.location.pathname + '?date=' + dateString
  return unless $('#calendar').length
  $('.day h2').click ->
    $('input#date').focus().click()
  $('.date-input-container button').click ->
    date = $('input[type=date]').val()
    window.location = window.location.pathname + '?date=' + date
  $('#calendar').fullCalendar
    dayClick: (date, jsEvent, view) ->
      onDateClick(date.format('YYYY-MM-DD'))
    dayRender: (date, cell) ->
      cell.addClass('selected') if date.isSame(NSNSP.commitments.defaultDate, 'day')
    eventClick: (event, jsEvent, view) ->
      onDateClick(event.start.format('YYYY-MM-DD'))
    defaultDate: NSNSP.commitments.defaultDate
    eventAfterAllRender: (view) ->
      $('#calendar-container').removeClass('invisible')
    events: NSNSP.commitments.events
    timezone: NSNSP.commitments.timezone
