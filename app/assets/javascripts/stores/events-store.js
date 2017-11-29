var AppDispatcher = require('../dispatchers/app-dispatcher.js');
var EventsConstants = require('../constants/events-constants.js');
var assign = require('object-assign');
var EventEmitter = require('events').EventEmitter;
var _ = require('underscore');
var moment = require('moment');
var CHANGE_EVENT = 'change';
var _events = [];
var _cities = [];
var _filter = {};
var _topics = [];
var _filteredEvents = [];

function loadInitialData() {
  if (gon.filter) _filter = gon.filter;
  if (gon.cities) _cities = gon.cities;
  if (gon.topics) _topics = gon.topics;
  if (gon.events) {
    _events = gon.events;
    filterEvents();
  }
  if (gon.notifications && gon.notifications.length > 0) {
    var event = getEvent(gon.notifications[0].event_id);
    var noty = new EventNotification(event);
    noty.notifyUser();
  }
};

function saveFilter() {
  $.ajax({
    url: '/api/local/filters/create_or_update',
    method: 'post',
    data: { filter: _filter },
    success: function(resp) {
    }.bind(this),
    error: function(xhr, status, error) {
      console.log("saveFilter failure", error);
    }.bind(this)
  });
};

function filterEvents() {
  _.sample([filterEventsOnBack, filterEventsOnFront]).call();
};

function getEvent(id) {
  return _.find(_events, function(event) { return event.id === id });
};

function filterEventsOnBack() {
  console.log('filterEventsOnBack');
  if ( (_filter.city_ids && _filter.city_ids.length > 0) ||
       (_filter.topic_ids && _filter.topic_ids.length > 0) ||
       (_filter.started_at && _filter.started_at.length > 0) ||
       (_filter.finished_at && _filter.finished_at.length > 0)
     ) {
    $.ajax({
      url: '/api/local/events',
      method: 'get',
      data: {filter: _filter},
      success: function(resp) {
        _filteredEvents = resp;
        EventsStore.emitChange();
      }.bind(this),
      error: function(xhr, status, error) {
        console.log("filterEventsOnBack failure", error);
      }.bind(this)
    });
  } else {
    _filteredEvents = _events;
  }
};

function filterEventsOnFront() {
  console.log('filterEventsOnFront');
  var filtered = _.map(_events, _.clone);
  if (_filter.city_ids && _filter.city_ids.length > 0) {
    var cityIdsArr = _filter.city_ids.split(', ');
    filtered = _.filter(filtered, function(event) { return cityIdsArr.indexOf(event.city.id) >= 0 })
  };

  if (_filter.topic_ids && _filter.topic_ids.length > 0) {
    var topicIdsArr = _filter.topic_ids.split(', ');
    filtered = _.filter(filtered, function(event) {
      var eventTopicIds = _.pluck(event.topics, 'id');
      if (_.intersection(eventTopicIds, topicIdsArr).length > 0) {
        event.topics = _.filter(event.topics, function(topic) { return topicIdsArr.indexOf(topic.id) >= 0 });
        return true
      } else {
        return false
      }
    });
  };

  if (_filter.started_at) {
    startedAt = moment(_filter.started_at);
    filtered = _.filter(filtered, function(event) { return moment(event.started_at) >= startedAt });
  };

  if (_filter.finished_at) {
    finishedAt = moment(_filter.finished_at);
    filtered = _.filter(filtered, function(event) { return moment(event.finished_at) <= finishedAt });
  }

  _filteredEvents = filtered;
};

function changeFilter(value) {
  _.extend(_filter, value);
  filterEvents();
};

function visitEventPage(eventId) {
  window.location = '/events/' + eventId;
};

var EventsStore = assign({}, EventEmitter.prototype, {
  emitChange: function() {
    this.emit(CHANGE_EVENT);
  },

  addChangeListener: function(callback) {
    this.on(CHANGE_EVENT, callback);
  },

  removeChangeListener: function(callback) {
    this.removeListener(CHANGE_EVENT, callback);
  },

  getEvents: function() {
    return _filteredEvents;
  },

  getCities: function() {
    return _cities;
  },

  getFilter: function() {
    return _filter;
  },

  getTopics: function() {
    return _topics;
  },

  dispatcherIndex: AppDispatcher.register(function (payload) {
    var action = payload.action;
    switch (action.actionType) {
      case EventsConstants.VISIT_EVENT_PAGE:
        visitEventPage(action.eventId);
        break;
      case EventsConstants.CHANGE_FILTER:
        changeFilter(action.value);
        break;
      case EventsConstants.SAVE_FILTER:
        saveFilter();
        break;
      case EventsConstants.LOAD_INITIAL_DATA:
        loadInitialData();
        break;
    }
    EventsStore.emitChange();

    return true;
  })
});

module.exports = EventsStore;
