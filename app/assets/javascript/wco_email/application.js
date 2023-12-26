//
//= require vendor/jquery.iframe-transport
//= require vendor/jquery.ui.widget
//= require vendor/jquery.fileupload
//= require vendor/jquery-ui.min
//
//= require rails-ujs
//= require ./shared
//= require_self
//
console.log('Loaded wco_email_rb/wco_email/application.js')
// console.log('v0.0.0')
$(function () {


$(".collapse-expand").each(function() {
  const thisId = $(this).attr('id')
  if (thisId) {
    const state = localStorage.getItem("collapse-expand#"+thisId)
    if (state === 'collapsed') {
      $(this).next().slideToggle()
      $(this).addClass('wco-collapse')
    }
  }
})
$(".collapse-expand").click(function (_e) {
  const thisId = $(this).attr('id')
  const state = localStorage.getItem("collapse-expand#"+thisId)
  if (state === 'collapsed') {
    localStorage.removeItem("collapse-expand#"+thisId)
    $(this).removeClass('wco-collapse')
  } else {
    localStorage.setItem("collapse-expand#"+thisId, "collapsed")
    $(this).addClass('wco-collapse')
  }
  $(this).next().slideToggle();
}).children().click(function (e) {
  e.stopPropagation()
})


var fileuploadCount = 0
$('#fileupload').fileupload({
  dataType: 'json',
  success: function(ev) {
    logg(ev, 'success')
    ev = ev[0]
    fileuploadCount += 1
    var el = $('<div class="item" />')
    var photosEl = $('#photos')
    $('<div/>').html(fileuploadCount).appendTo(el)
    $('<img/>').attr('src', ev.thumbnail_url).appendTo(el)
    $('<div/>').html(ev.name).appendTo(el)
    el.appendTo(photosEl)
  },
  error: function(err) {
    logg(err, 'error')
    err = err.responseJSON
    fileuploadCount += 1
    var el = $('<div class="item" />')
    var errorsEl = $('.photos--multinew .errors')
    $('<div/>').html(fileuploadCount).appendTo(el)
    $('<div />').html(err.filename).appendTo(el)
    $('<div />').html(err.message).appendTo(el)
    el.appendTo(errorsEl)
  },
});


})(); // END
