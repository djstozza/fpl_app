import React, { Component } from 'react';
import { Row, Col, Nav, NavItem } from 'react-bootstrap';
import { selectTabClick, centerItVariableWidth } from '../../utils/nav_tab.js';

export default class RoundsNav extends Component {
  componentDidMount () {
    centerItVariableWidth('li.active', '.js-scrollable-nav');
  }

  render () {
    var self = this;
    var roundId = this.props.round.id;
    var roundList = this.props.rounds.map(function (round) {
      var roundTabClass = `round-tab-${round.id}`
      return (
        <NavItem
          key={round.id}
          className={`${round.id == roundId ? 'active' : ''} ${roundTabClass}`}
          onClick={ function () { selectTabClick(roundTabClass, round.id, self.props) } }>
          {round.name}
        </NavItem>
      );
    });
    return (
      <Row className='clearfix'>
        <Col sm={12}>
          <Nav bsStyle='tabs' className='js-scrollable-nav'>
            { roundList }
          </Nav>
        </Col>
      </Row>
    )
  }
}
