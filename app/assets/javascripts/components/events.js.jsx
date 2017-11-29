import EventsStore from '../stores/events-store.js';
import EventsActions from '../actions/events-actions.js';
import Table from 'react-bootstrap/lib/Table';
import {NotificationContainer, NotificationManager} from 'react-notifications';

window.Events = React.createClass({
  getInitialState() {
    return {
      events: EventsStore.getEvents(),
      cities: EventsStore.getCities(),
      topics: EventsStore.getTopics(),
      filter: EventsStore.getFilter()
    }
  },

  componentDidMount() {
    EventsStore.addChangeListener(this.handleChange);
    EventsActions.loadInitialData();
  },

  componentWillUnmount() {
    EventsStore.removeChangeListener(this.handleChange);
  },

  handleChange() {
    this.setState({
      events: EventsStore.getEvents(),
      cities: EventsStore.getCities(),
      topics: EventsStore.getTopics(),
      filter: EventsStore.getFilter()
    });
  },

  handleChangeFilter(value) {
    EventsActions.changeFilter(value);
  },

  handleSaveFilterClick() {
    EventsActions.saveFilter();
    NotificationManager.success('Filter was saved');
  },

  handleTrClick(eventId) {
    EventsActions.visitEventPage(eventId);
  },

  renderTbody() {
    const events = this.state.events || [];
    const rows = events.map(function(event, index) {
      return <EventRow key={index} onClick={this.handleTrClick} {...event} />
    }.bind(this));
    return <tbody>{rows}</tbody>
  },

  render() {
    return (
      <div>
        <h1>Events</h1>
        <EventsFilter cities={this.state.cities}
                      filter={this.state.filter}
                      topics={this.state.topics}
                      handleSaveFilterClick={this.handleSaveFilterClick}
                      handleChangeFilter={this.handleChangeFilter} />
        <Table responsive bordered condensed hover>
          <thead>
            <tr>
              <th>id</th>
              <th>title</th>
              <th>city</th>
              <th>started_at</th>
              <th>finished_at</th>
              <th>topics</th>
            </tr>
          </thead>
          {this.renderTbody()}
        </Table>
        <NotificationContainer/>
      </div>
    )
  }
});
