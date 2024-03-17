$(function() {


$(".archive-btn").click(function(e) {
  if ( !confirm('Are you sure?') ) { return; }

  const jwt_token = $("#Config").data('jwt-token')
  const action_path = $(this).data('url')
  const out = []

  $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
    let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
    out.push(val)
  })

  $.ajax({
    url: action_path,
    type: 'POST',
    data: {
      ids: out,
      jwt_token: jwt_token,
    },
    success: e => {
      logg((e||{}).responseText, 'archived Ok')
      location.reload()
    },
    error: e => {
      logg((e||{}).responseText, 'archived Err')
    },
  })

})

$(".add-tag-btn").click(function(e) {
  if ( !confirm('Are you sure?') ) { return; }

  const jwt_token = $("#Config").data('jwt-token')
  const action_path = $(this).data('url')
  const emailtag = $("select[name='emailtag']").val()
  const out = []

  $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
    let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
    out.push(val)
  })

  let data = {
    ids: out,
    jwt_token: jwt_token,
    slug: emailtag,
  }
  if ($("#is_move").prop('checked')) {
    data.is_move = true
  }
  $.ajax({
    url: action_path,
    type: 'POST',
    data: data,
    success: e => {
      logg((e||{}).responseText, 'Ok')
      location.reload()
    },
    error: e => {
      logg((e||{}).responseText, 'Err')
      location.reload()
    },
  })

})

$(".remove-tag-btn").click(function(e) {
  if ( !confirm('Are you sure?') ) { return; }

  const jwt_token = $("#Config").data('jwt-token')
  const action_path = $(this).data('url')
  const emailtag = $("select[name='emailtag']").val()
  const out = []

  $( $(".conversations-list input[type='checkbox'].i-sel:checked") ).each( idx => {
    let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
    out.push(val)
  })

  $.ajax({
    url: action_path,
    type: 'POST',
    data: {
      ids: out,
      jwt_token: jwt_token,
      slug: emailtag,
    },
    success: e => {
      logg((e||{}).responseText, 'Ok')
      location.reload()
    },
    error: e => {
      logg((e||{}).responseText, 'Err')
      location.reload()
    },
  })

})

$(".delete-btn").click(function(e) {
  if ( !confirm('Are you sure?') ) { return; }

  const jwt_token = $("#Config").data('jwt-token')
  const action_path = $(this).data('url')
  const out = []

  $( $("input[type='checkbox'].i-sel:checked") ).each( idx => {
    let val = $($("input[type='checkbox'].i-sel:checked")[idx]).val()
    out.push(val)
  })

  $.ajax({
    url: action_path,
    type: 'DELETE',
    data: {
      ids: out,
      jwt_token: jwt_token,
    },
    success: e => {
      logg((e||{}).responseText, 'deleted Ok')
      location.reload()
    },
    error: e => {
      logg((e||{}).responseText, 'deleted Err')
    },
  })

})






}); // END

