import React, { Component } from 'react';
import { selectTabClick, centerItVariableWidth } from '../../utils/nav_tab.js';
import { Row, Col, Nav, NavItem } from 'react-bootstrap';
import imgSrc from '../../../assets/images/badges-sprite.jpeg';

export default class TeamsNav extends Component {
  componentDidMount () {
    centerItVariableWidth('li.active', '.scrollable-nav');
  }

  render () {
    var self = this;
    var teamId = this.props.team.id;
    var teamList = this.props.teams.map(function (team) {
      var teamTabClass = `team-tab-${team.id}`
      return (
        <NavItem key={team.id}
         className={ `${team.id == teamId ? 'active' : ''} ${teamTabClass}` }
         onClick={ function () {selectTabClick(teamTabClass, team.id, self.props) } }>
          <span>
            <img className = {`crest ${team.short_name.toLowerCase()} teams-nav`} src={imgSrc}/> { team.short_name }
          </span>
        </NavItem>
      );
    });
    return (
      <Row className='clearfix'>
        <Col sm={12}>
          <Nav bsStyle='tabs' className='js-scrollable-nav'>
            { teamList }
          </Nav>
        </Col>
      </Row>
    )
  }
}
