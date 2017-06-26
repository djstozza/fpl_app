import React from 'react';
import { Row, Col } from 'react-bootstrap';
import FixtureGroups from './fixture_groups.js';

export default class Round extends React.Component {

  render () {
    return (
      <Row className='clearfix'>
        <Col mdOffset={3} md={6}>
          <h3>{ this.props.round.name }</h3>
          <FixtureGroups fixtureGroups={this.props.fixtures} />
        </Col>
      </Row>
    );
  }
}
