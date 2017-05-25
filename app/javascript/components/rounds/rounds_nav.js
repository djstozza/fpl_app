import React from 'react';
import { centerItVariableWidth } from '../../utils/nav_tab.js';

export default class RoundsNav extends React.Component {
  selectRoundClick (roundTabClass, roundId) {
    document.querySelector('li.active').classList.remove('active');
    document.querySelector(`li.${roundTabClass}`).classList.add('active');
    centerItVariableWidth('li.active', '.js-scrollable-nav');
    this.dataSource(roundId);
  }

  dataSource (roundId) {
    this.props.onChange(roundId);
  }

  componentDidMount () {
    centerItVariableWidth('li.active', '.js-scrollable-nav');
  }

  render () {
    var self = this;
    var roundId = this.props.round.id;
    var roundList = this.props.rounds.map(function (round) {
      var roundTabClass = `round-tab-${round.id}`
      return (
        <li key={round.id} className={`${round.id == roundId ? 'active' : ''} presenter ${roundTabClass}`}>
          <a href="javascript:;" onClick={function () {self.selectRoundClick(roundTabClass, round.id)}}>
            {round.name}
          </a>
        </li>
      );
    });
    return (
      <div className='row'>
        <div className= 'col-sm-12'>
          <ul className='nav nav-tabs js-scrollable-nav' role='tablist'>
            { roundList }
          </ul>
        </div>
      </div>
    )
  }
}
