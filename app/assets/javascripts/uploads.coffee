# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  'use strict'

  $('#fileupload_dda_example').fileupload
      url: '/uploads/'
      dropZone: $('#dropzone')


  $('#fileupload').fileupload url: '/uploads/'
  $('#fileupload, #fileupload_dda_example').fileupload 'option', 'redirect', window.location.href.replace(/\/[^\/]*$/, '/cors/result.html?%s')
  if window.location.hostname == 'localhost:3000'
    $('#fileupload, #fileupload_dda_example').fileupload 'option',
      url: '//uploads/'
      disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent)
      maxFileSize: 5000000
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    if $.support.cors
      $.ajax(
        url: '//uploads/'
        type: 'HEAD').fail ->
        $('<div class="alert alert-danger"/>').text('Upload server currently unavailable - ' + new Date).appendTo '#fileupload'
        return
  else
    $('#fileupload, #fileupload_dda_example').addClass 'fileupload-processing'
    $.ajax(
      url: $('#fileupload, #fileupload_dda_example').fileupload('option', 'url')
      dataType: 'json'
      context: $('#fileupload')[0]).always(->
      $(this).removeClass 'fileupload-processing'
      return
    ).done (result) ->
      $(this).fileupload('option', 'done').call this, $.Event('done'), result: result
      return
  return



# Script to provide required effects when user dops any files


$(document).bind 'dragover', (e) ->
  dropZone = $('#dropzone')
  timeout = window.dropZoneTimeout
  if !timeout
    dropZone.addClass 'in'
  else
    clearTimeout timeout
  found = false
  node = e.target
  loop
    if node == dropZone[0]
      found = true
      break
    node = node.parentNode
    unless node != null
      break
  if found
    dropZone.addClass 'hover'
  else
    dropZone.removeClass 'hover'
  window.dropZoneTimeout = setTimeout((->
    window.dropZoneTimeout = null
    dropZone.removeClass 'in hover'
    return
  ), 1000)
  return
