//
// trash: require rails-ujs
//
//= require ./contexts
//= require ./conversations
//

$(function () {

if ($(".tinymce").length > 0) {
  $(".tinymce").summernote()
}

logg('loaded wco_email/application.js')
}) // END

