import React from 'react';
import { selectTabClick, centerItVariableWidth } from '../../utils/nav_tab.js';
import imgSrc from '../../../assets/images/badges-sprite.jpeg';

export default class TeamsNav extends React.Component {
  componentDidMount () {
    centerItVariableWidth('li.active', '.js-scrollable-nav');
  }

  render () {
    var self = this;
    var teamId = this.props.team.id;
    var teamList = this.props.teams.map(function (team) {
      var teamTabClass = `team-tab-${team.id}`
      return (
        <li key={team.id} className={`${team.id == teamId ? 'active' : ''} presenter ${teamTabClass}`}>
          <a href="javascript:;" onClick={ function () {selectTabClick(teamTabClass, team.id, self.props) } }>
            <span>
              <img className={`crest ${team.short_name.toLowerCase()} teams-nav`} src={imgSrc}/> {team.short_name}
            </span>
          </a>
        </li>
      );
    });
    return (
      <div className='row'>
        <div className= 'col-sm-12'>
          <ul className='nav nav-tabs js-scrollable-nav' role='tablist'>
            { teamList }
          </ul>
        </div>
      </div>
    )
  }
}
