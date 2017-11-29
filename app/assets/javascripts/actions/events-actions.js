var EventsConstants = require('../constants/events-constants.js');
var AppDispatcher = require('../dispatchers/app-dispatcher.js');

var EventsActions = {
  visitEventPage: function(eventId) {
    AppDispatcher.handleViewAction({
      actionType: EventsConstants.VISIT_EVENT_PAGE,
      eventId: eventId
    });
  },
  changeFilter: function(value) {
    AppDispatcher.handleViewAction({
      actionType: EventsConstants.CHANGE_FILTER,
      value: value
    });
  },
  saveFilter: function() {
    AppDispatcher.handleViewAction({
      actionType: EventsConstants.SAVE_FILTER
    });
  },
  loadInitialData: function() {
    AppDispatcher.handleViewAction({
      actionType: EventsConstants.LOAD_INITIAL_DATA
    });
  },
};

module.exports = EventsActions;
