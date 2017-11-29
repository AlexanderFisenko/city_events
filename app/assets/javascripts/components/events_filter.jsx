import EventsStore from '../stores/events-store.js';
import EventsActions from '../actions/events-actions.js';
var moment = require('moment');
import Datetime from 'react-datetime';


import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import FormControl from 'react-bootstrap/lib/FormControl';
import Button from 'react-bootstrap/lib/Button';
import Select from 'react-select';

window.EventsFilter = React.createClass({

  handleChangeCityFilter(value) {
    value = value.split(',').join(', ')
    this.props.handleChangeFilter({city_ids: value});
  },

  handleChangeTopicFilter(value) {
    value = value.split(',').join(', ')
    this.props.handleChangeFilter({topic_ids: value});
  },

  handleChangeDateTimeFilter(type, moment) {
    const value = moment === '' ? moment : moment.format('YYYY-MM-DD HH:mm');
    console.log(value);
    const data = {};
    data[type] = value;
    this.props.handleChangeFilter(data);
  },

  handleSaveFilterClick(e) {
    e.preventDefault();
    this.props.handleSaveFilterClick();
  },

  handleChangeTextSearchFilter(e) {
    this.props.handleChangeFilter({text: e.target.value});
  },

  renderCityFilter() {
    const value = this.props.filter.city_ids ? this.props.filter.city_ids.split(', ').join(',') : null;
    return <Select multi
                   simpleValue
                   removeSelected={true}
                   closeOnSelect={false}
                   placeholder="filter by cities"
                   value={value}
                   onChange={this.handleChangeCityFilter}
                   options={this.props.cities} />
  },

  renderDateTimeFilter() {
    const startedAtValue = this.props.filter.started_at ? moment(this.props.filter.started_at).format("DD.MM.YYYY HH:mm") : '';
    const finishedAtValue = this.props.filter.finished_at ? moment(this.props.filter.finished_at).format("DD.MM.YYYY HH:mm") : '';
    return [
      <Datetime key={startedAtValue || 1}
                defaultValue={startedAtValue}
                dateFormat="DD.MM.YYYY"
                timeFormat={"HH:mm"}
                inputProps={{ placeholder: 'select started_at range' }}
                onBlur={this.handleChangeDateTimeFilter.bind(this, 'started_at')}
                utc={true}
                />,
      <Datetime key={finishedAtValue || 2}
                defaultValue={finishedAtValue}
                dateFormat="DD.MM.YYYY"
                timeFormat={"HH:mm"}
                inputProps={{ placeholder: 'select finished_at range' }}
                onBlur={this.handleChangeDateTimeFilter.bind(this, 'finished_at')}
                />
    ]
  },

  renderTopicFilter() {
    const value = this.props.filter.topic_ids ? this.props.filter.topic_ids.split(', ').join(',') : null;
    return <Select multi
                   simpleValue
                   removeSelected={true}
                   closeOnSelect={false}
                   placeholder="filter by topics"
                   value={value}
                   onChange={this.handleChangeTopicFilter}
                   options={this.props.topics} />
  },

  render() {
    return (
      <section>
        <Grid>
          <Row className="show-grid">
            <Col md={3}>{this.renderCityFilter()}</Col>
            <Col md={3}>{this.renderDateTimeFilter()}</Col>
            <Col md={3}>{this.renderTopicFilter()}</Col>
            <Col md={1}><p><Button bsStyle="success" onClick={this.handleSaveFilterClick}>save filters</Button></p></Col>
          </Row>
        </Grid>
        <br/>
        <br/>
        <br/>
      </section>
    )
  }
});
