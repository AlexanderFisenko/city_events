import _ from 'underscore';
import moment from 'moment';

window.EventRow = React.createClass({
  handleTrClick(e) {
    e.preventDefault();
    this.props.onClick(this.props.id);
  },

  renderTopics() {
    return _.map(this.props.topics, 'title').join(", ")
  },

  render() {
    return (
      <tr onClick={this.handleTrClick}>
        <td>{this.props.id}</td>
        <td>{this.props.title}</td>
        <td>{this.props.city.name}</td>
        <td>{moment(this.props.started_at).format("DD-MM-YYYY HH:mm")}</td>
        <td>{moment(this.props.finished_at).format("DD-MM-YYYY HH:mm")}</td>
        <td>{this.renderTopics()}</td>
      </tr>
    )
  }
});
