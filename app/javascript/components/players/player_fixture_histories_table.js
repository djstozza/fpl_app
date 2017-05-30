import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import _ from 'underscore';
require('../../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

export default class PlayerFixtureHistoriesTable extends Component {
  constructor(props) {
    super(props)
    console.log(this.props);
  }

  linkCellText (cell, row) {
    return (<Link to={`/rounds/${row.round}` } >{cell}</Link>);
  }

  render () {
    return (
      <div>
        <BootstrapTable data={this.props.player_fixture_histories}>
          <TableHeaderColumn
            dataField='round'
            dataAlign='center'
            dataSort
            dataFormat={ this.linkCellText }
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            isKey>
            <span data-tip='Round'>R</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='minutes'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Minutes'>Min</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_scored'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals'>G</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='assists'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Assists'>A</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_conceded'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals Conceded'>GC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='yellow_cards'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Yellow Cards'>YC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='red_cards'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Red Cards'>RC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='own_goals'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Own Goals'>OG</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='saves'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Saves'>S</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_saved'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Saved'>PS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_missed'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Missed'>PM</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='bonus'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Bonus'>B</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Points'>Pts</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
