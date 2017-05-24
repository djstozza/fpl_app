import React from 'react';
import FixtureGroups from './fixture_groups.js';

export default class Round extends React.Component {

  render () {
    return (
      <div className='container'>
        <div className='row'>
          <div className='col-md-offset-3 col-md-6'>
            < FixtureGroups fixtureGroups={this.props.fixtures} />
          </div>
        </div>
      </div>
    );
  }
}
