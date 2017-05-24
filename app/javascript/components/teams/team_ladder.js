import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
require('../../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

export default class TeamLadder extends Component {
  constructor(props) {
    super(props)
  }

  dataSource (teamId) {
    this.props.onChange(teamId);
  }

  linkCellText (cell, row) {
    return (<Link to={`/teams/${row.id}` } onClick={ () => this.dataSource(row.id) }>{cell}</Link>);
  }

  render () {
    return (
      <div>
        <BootstrapTable data={this.props.teams} striped hover>
          <TableHeaderColumn
            dataField='position'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            isKey>
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='short_name'
            dataAlign='center'
            dataFormat={this.linkCellText}
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='played'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Matches'>M</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='wins'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Wins'>W</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='losses'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Losses'>L</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='draws'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Draws'>D</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='form'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Form'>F</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_for'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals For'>GF</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_against'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals Against'>GA</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goal_difference'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goal Difference'>GD</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='points'
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
