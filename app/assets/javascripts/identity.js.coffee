# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $('.identity .suggested-users').on 'click', 'a', ->
    $('#identity_user_id').val $(this).data('userId')
