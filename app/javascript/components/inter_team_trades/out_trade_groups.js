import React, { Component } from 'react';
import { Row, Col, Button, Accordion, Panel } from 'react-bootstrap';

import OutTradeGroupTable from './out_trade_group_table.js';

export default class OutTradeGroups extends Component {
  constructor(props) {
    super(props);

    this.addToTradeGroupAction = this.addToTradeGroupAction.bind(this);
    this.submitTradeGroupAction = this.submitTradeGroupAction.bind(this);
    this.deleteTradeGroupAction = this.deleteTradeGroupAction.bind(this);
    this.removeTradeAction = this.removeTradeAction.bind(this);
    this.outTradeGroupStatusArr = this.outTradeGroupStatusArr.bind(this);
    this.outTradeGroupsArr = this.outTradeGroupsArr.bind(this);
  }

  submitTradeGroupAction (tradeGroup) {
    this.props.submitTradeGroupAction(tradeGroup);
  }

  addToTradeGroupAction (tradeGroup, out_player, in_player) {
    this.props.completeTradeAction(tradeGroup, out_player, in_player);
  }

  deleteTradeGroupAction (tradeGroup) {
    this.props.deleteTradeGroupAction(tradeGroup);
  }

  removeTradeAction (tradeGroup, tradeId) {
    this.props.removeTradeAction(tradeGroup, tradeId);
  }

  outTradeGroupStatusArr () {
    return (
      this.props.out_trade_groups.map( (tradeGroupStatusArr, i) => {
        let status = tradeGroupStatusArr.status
        let key=`out-trade-group-${status}`

        return (
          <Panel key={ key } header={ status } eventKey={i} bsStyle={ this.tradeGroupPanelStyle(status) }>
            { this.outTradeGroupsArr(tradeGroupStatusArr.trade_groups) }
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

  outTradeGroupsArr (tradeGroups) {
    return (
      tradeGroups.map( (tradeGroup) => {
        let key=`out-trade-group-${tradeGroup.id}`
        return (
          <div key={ key }>
            <OutTradeGroupTable
              selector={ key }
              tradeGroup={ tradeGroup }
              fpl_team={ this.props.fpl_team }
              fpl_teams={ this.props.fpl_teams }
              current_user={ this.props.current_user }
              status={ this.props.status }
              teams={ this.props.teams }
              positions={ this.props.positions }
              completeTradeAction={ this.addToTradeGroupAction }
              submitTradeGroupAction={ this.submitTradeGroupAction }
              deleteTradeGroupAction={ this.deleteTradeGroupAction }
              removeTradeAction={ this.removeTradeAction }
            />
          </div>
        )
      })
    )
  }

  render () {
    return (
      <div>
        <h3>Proposed Trades</h3>
        <Accordion>
          { this.outTradeGroupStatusArr() }
        </Accordion>
      </div>
    )
  }
}
