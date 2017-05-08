import React from 'react'
import FixtureGroup from './fixture_group.js.jsx';

export default class FixtureGroups extends React.Component {
  render () {
    var self = this;
    return (
      <div>
      {
        self.props.fixtureGroups.map(function (fixtureGroup, key) {
          return(
            < FixtureGroup key={'game-day-' + key} gameDay={fixtureGroup.game_day} fixtures={fixtureGroup.fixtures} />
          )
        })
      }
      </div>
    );
  }
}
