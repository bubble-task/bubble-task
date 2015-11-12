const React = require('react');
const RaisedButton = require('material-ui/lib/raised-button');

export default React.createClass({
  render: function() {
    return (
      <RaisedButton label={this.props.name} />
    );
  }
});
