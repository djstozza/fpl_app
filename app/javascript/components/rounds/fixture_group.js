import React from 'react'
import Match from './match.js';

export default class FixtureGroup extends React.Component {
  matches () {
    var self = this;
    return (
      self.props.fixtures.map(function (match) {
        return (
          < Match key={`match-${match.fixture.id}`} match={match} />
        )
      })
    );
  }

  render () {
    var self = this;
    return(
      <div>
        <b>{this.props.gameDay}</b>
        <div>{self.matches()}</div>
      </div>
    )
  }
}
