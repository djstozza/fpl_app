import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
require('../../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

export default class TeamFixtures extends Component {
  constructor(props) {
    super(props)
  }

  dataSource (teamId) {
    this.props.onChange(teamId);
  }

  cellAdvantageClass (cell, row) {
    return (<div className={row.fixture_advantage}>{cell}</div>);
  }

  columnClassNameFormat (fieldValue, row, rowIdx, colIdx) {
    return row.fixture_advantage
  }

  opponentLinkCellText (cell, row) {
    return (<Link to={ `/teams/${row.opponent_id}` } onClick={ () => this.dataSource(row.opponent_id) }>{cell}</Link>);
  }

  roundLinkCellText (cell, row) {
    return (<Link to={ `/rounds/${row.round_id}` }>{cell}</Link>);
  }

  render () {
    return (
      <div>
        <BootstrapTable data={this.props.team_fixtures} striped hover>
          <TableHeaderColumn
            dataField='round_id'
            dataAlign='center'
            dataSort
            dataFormat={this.roundLinkCellText}
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            isKey>
            <span data-tip='Round'>R</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='kickoff_time'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Kickoff Time'>KT</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='opponent'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataFormat={this.opponentLinkCellText}
            dataSort>
            <span data-tip='Opponent'>O</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='result'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Result'>R</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='leg'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Home/Away'>H/A</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='score'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Score'>S</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='advantage'
            dataAlign='center'
            columnClassName={ this.columnClassNameFormat }
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Advantage'>A</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
