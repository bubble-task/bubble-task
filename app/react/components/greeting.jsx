import React from 'react';

class Greeing extends React.Component {
  render() {
    return (
      <div className="greeting">
        Hello, {this.props.name}
      </div>
    );
  }
}

export default Greeing;
