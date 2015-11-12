const React = require('react');
const Mui = require('material-ui');
const AppBar = Mui.AppBar;
const LeftNav = Mui.LeftNav;

export default React.createClass({
  render: function() {
    return (
      <AppBar
        title="Bubble Task"
        iconClassNameRight="muidocs-icon-navigation-expand-more">
        <LeftNav docked={false} />
      </AppBar>
    )
  }
});
