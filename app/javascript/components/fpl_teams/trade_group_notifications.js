import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button, ListGroup, ListGroupItem } from 'react-bootstrap';

export default class TradeGroupNotifications extends Component {
  constructor(props) {
    super(props);
    this.submittedNotification = this.submittedNotification.bind(this);
    this.approvedNotification = this.approvedNotification.bind(this);
    this.declinedNotification = this.declinedNotification.bind(this);
  }

  submittedNotification () {
    const count = this.props.submitted_in_trade_group_count;
    const string = (count > 1 ? 'trades' : 'trade');
    if (count > 0) {
      return (
        <ListGroupItem bsStyle='info' href={`/fpl_teams/${this.props.fplTeamId}/inter_team_trade_groups` }>
          You have { count } { string } awaiting your approval.
        </ListGroupItem>
      )
    }
  }

  approvedNotification () {
    const count = this.props.approved_out_trade_group_count;
    const string = (count > 1 ? 'have' : 'has');
    if (count > 0) {
      return (
        <ListGroupItem bsStyle='success' href={`/fpl_teams/${this.props.fplTeamId}/inter_team_trade_groups` }>
          { count } of your proposed trades { string } been approved.
        </ListGroupItem>
      )
    }
  }

  declinedNotification () {
    const count = this.props.declined_out_trade_group_count;
    const string = (count > 1 ? 'have' : 'has')
    if (count > 0) {
      return (
        <ListGroupItem bsStyle='danger' href={`/fpl_teams/${this.props.fplTeamId}/inter_team_trade_groups` }>
          { count } of your proposed trades { string } been declined.
        </ListGroupItem>
      )
    }
  }

  render () {
    return (
      <div>
        <ListGroup>
          { this.submittedNotification() }
          { this.approvedNotification() }
          { this.declinedNotification() }
        </ListGroup>
      </div>
    );
  }
}
