class @EventNotification
  constructor: (event) ->
    @event = event

  notifyUser: () ->
    bootbox.confirm
      title: 'New event was created!'
      message: 'Do you want to watch it?'
      buttons:
        cancel: label: '<i class="fa fa-times"></i> Cancel'
        confirm: label: '<i class="fa fa-check"></i> Confirm'
      callback: (result) =>
        if result
          window.location = "/events/#{@event.id}"
        else
          @makeSeen()

  makeSeen: () ->
    $.ajax
      url: '/api/local/event_notifications/make_seen'
      method: 'patch'
      data: { user_id: window.current_user_id, event_id: @event.id }
