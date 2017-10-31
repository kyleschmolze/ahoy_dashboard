$ =>
  # Load event names immediately
  $('#name').html('<option>Loading</option>')
  $.get('events/names').then (names) ->
    options = '<option></option>'
    for name in names
      options += "<option value='#{name}'>#{name}</option>"
    $('#name').html(options)

  $('#name').change ->
    name = $(this).val()
    $('#key').html('<option>Loading</option>')
    $.get("events/keys?name=#{name}").then (keys) ->
      options = '<option></option>'
      for key in keys
        options += "<option value='#{key}'>#{key}</option>"
      $('#key').html(options)

  $('#key').change ->
    key = $(this).val()
    name = $('#name').val()
    $('#value').html('<option>Loading</option>')
    $.get("events/values?name=#{name}&key=#{key}").then (values) ->
      options = '<option></option>'
      for value in values
        options += "<option value='#{value}'>#{value}</option>"
      $('#value').html(options)
      
  $('.event-form').submit (e) ->
    e.preventDefault()
    $('.event-form input[type="submit"]').val('Loading...').prop('disabled', true)
    $.get("events/data?#{$(this).serialize()}").then (html) ->
      $('.data').html html
      $('.event-form input[type="submit"]').val('Load').prop('disabled', false)

