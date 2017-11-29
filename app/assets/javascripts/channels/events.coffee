App.events = App.cable.subscriptions.create { channel: "EventsChannel" },

  received: (data) ->
    id = parseInt(window.current_user_id)
    if data.for_user_ids.indexOf(id) >= 0
      noty = new EventNotification(data.event)
      noty.notifyUser()


