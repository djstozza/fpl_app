import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import { Row, Col, Button } from 'react-bootstrap';

export default class InTradeGroupTable extends Component {
  constructor(props) {
    super(props);

    this.buttonCol = this.buttonCol.bind(this);
    this.tradeGroupButtons = this.tradeGroupButtons.bind(this);
    this.approveTrade = this.approveTrade.bind(this);
    this.declineTrade = this.declineTrade.bind(this);
  }

  buttonCol () {
    if (this.props.status == null) {
      return;
    }

    if (this.props.tradeGroup.status == 'submitted') {
      return (
        <TableHeaderColumn
          row='0'
          colSpan='5'
          dataAlign='center'
        >
          <div>
            { this.tradeGroupButtons() }
          </div>
        </TableHeaderColumn>
      );
    }
  }

  tradeGroupButtons () {
    const tradeGroup = this.props.tradeGroup;
    if (tradeGroup.status == 'submitted') {
      return [
        <Button
          key={ `trade-group-${tradeGroup.id}-approve` }
          bsStyle='success' onClick={ () => this.approveTrade() }
        >
          Approve
        </Button>,
        <Button
          key={`trade-group-${tradeGroup.id}-decline` }
          bsStyle='danger' onClick={ () => this.declineTrade(this.props.tradeGr) }
        >
          Deciline
        </Button>
      ]
    }
  }

  approveTrade () {
    this.props.approveTradeGroupAction(this.props.tradeGroup);
  }

  declineTrade () {
    this.props.declineTradeGroupAction(this.props.tradeGroup);
  }

  render () {
    let tradeGroupStatus = this.props.tradeGroup.status;
    let capitalisedTradeGroupStatus = tradeGroupStatus.charAt(0).toUpperCase() + tradeGroupStatus.slice(1);

    return (
      <div>
        <BootstrapTable
          data={ this.props.tradeGroup.trades }
          striped
          hover
        >
          { this.buttonCol() }
          <TableHeaderColumn dataField='out_player_id' dataAlign='center' isKey hidden/>
          <TableHeaderColumn row='1' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='Out'>{ this.props.tradeGroup.out_fpl_team.name }</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            rowSpan='1'
            dataField='out_player_last_name'
            dataAlign='center'
          >
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            rowSpan='1'
            dataField='out_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='1' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='In'>{ this.props.fpl_team.name } (Me)</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            dataField='in_player_last_name'
            dataAlign='center'
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            dataField='in_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            rowSpan='2'
            dataField='singular_name_short'
            dataAlign='center'
          >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
        <hr/>
      </div>
    );
  }
}
