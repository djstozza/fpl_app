import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
require('../../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

export default class TeamPlayers extends Component {
  constructor(props) {
    super(props)
    this.options = {
      defaultSortName: 'total_points',
      defaultSortOrder: 'desc'
    }
  }

  render () {
    const positionText = {
      1: 'GKP',
      2: 'DEF',
      3: 'MID',
      4: 'FWD'
    }

    var positionTextCell = function (cell, row) {
      return positionText[cell]
    }

    return (
      <div>
        <BootstrapTable data={this.props.team_players} striped hover options={ this.options }>
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            isKey>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='position_id'
            dataAlign='center'
            dataSort
            dataFormat={positionTextCell}
            filter={ { type: 'SelectFilter', options: positionText, placeholder: ' ' } }>
            <span data-tip='Position'>Pos</span>
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
            dataField='saves'
            dataAlign='center'
            dataSort
            hidden
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Saves'>S</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_saved'
            dataAlign='center'
            dataSort
            hidden
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Saved'>PS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_missed'
            dataAlign='center'
            dataSort
            hidden
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Missed'>PM</span>
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
            dataField='points_per_game'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Points Per Game'>PPG</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Total Points'>TP</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
