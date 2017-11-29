import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import { Button } from 'react-bootstrap';

export default class TradeGroupsTable extends Component {
  constructor(props) {
    super(props);
  }

  render () {
    return (
      <div>
        <BootstrapTable
          data={ this.props.tradeGroup.trades }
          striped
          hover
          pagination
        >
          <TableHeaderColumn dataField='out_player_id' dataAlign='center' isKey hidden/>
          <TableHeaderColumn dataField='out_player_last_name' dataAlign='center'>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
