import React, { Component } from 'react';
import { Row, Col, Button, Accordion, Panel } from 'react-bootstrap';

import InTradeGroupTable from './in_trade_group_table.js';

export default class InTradeGroups extends Component {
  constructor(props) {
    super(props);

    this.inTradeGroupStatusArr = this.inTradeGroupStatusArr.bind(this);
    this.inTradeGroupsArr = this.inTradeGroupsArr.bind(this);
    this.approveTradeGroupAction = this.approveTradeGroupAction.bind(this);
    this.declineTradeGroupAction = this.declineTradeGroupAction.bind(this);
  }

  inTradeGroupStatusArr () {
    return (
      this.props.in_trade_groups.map( (tradeGroupStatusArr, i) => {
        let status = tradeGroupStatusArr.status
        let key=`in-trade-group-${status}`

        return (
          <Panel key={ key } header={ status } eventKey={i} bsStyle={ this.tradeGroupPanelStyle(status) }>
            { this.inTradeGroupsArr(tradeGroupStatusArr.trade_groups) }
          </Panel>
        )
      })
    )
  }

  tradeGroupPanelStyle(status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'info';
      case 'submitted':
        return 'primary';
      case 'approved':
        return 'success';
      case 'declined':
        return 'danger';
      case 'expired':
        return 'warning';
    }
  }

  inTradeGroupsArr (tradeGroups) {
    return (
      tradeGroups.map( (tradeGroup) => {
        let key=`in-trade-group-${tradeGroup.id}`
        return (
          <div key={ key }>
            <InTradeGroupTable
              selector={ key }
              tradeGroup={ tradeGroup }
              fpl_team={ this.props.fpl_team }
              fpl_teams={ this.props.fpl_teams }
              current_user={ this.props.current_user }
              status={ this.props.status }
              approveTradeGroupAction={ this.approveTradeGroupAction }
              declineTradeGroupAction={ this.declineTradeGroupAction }
            />
          </div>
        )
      })
    )
  }

  approveTradeGroupAction (tradeGroup) {
    this.props.approveTradeGroupAction(tradeGroup);
  }

  declineTradeGroupAction (tradeGroup) {
    this.props.declineTradeGroupAction(tradeGroup);
  }

  render () {
    return (
      <div>
        <h3>Received Trades</h3>
        <Accordion>
          { this.inTradeGroupStatusArr() }
        </Accordion>
      </div>
    )
  }
}
