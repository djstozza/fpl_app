import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';

export default class UserFplTeamsTable extends Component {
  constructor (props) {
    super(props);
  }

  fplTeamLinkCellText (cell, row) {
    return (<Link to={`/fpl_teams/${row.id}` } >{cell}</Link>);
  }

  leagueLinkCellText (cell, row) {
    return (<Link to={`/leagues/${row.league_id}` } >{cell}</Link>);
  }

  render () {
    return (
      <div>
        <BootstrapTable data={ this.props.fpl_teams } striped hover>
          <TableHeaderColumn dataField='name' dataAlign='center' dataFormat={ this.leagueLinkCellText } isKey >
            <span data-tip='Team Name'>TN</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='league_name' dataAlign='center' dataFormat={ this.leagueLinkCellText } >
            <span data-tip='League Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='total_score' dataAlign='center' >
            <span data-tip='Total Score'>TS</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='rank' dataAlign='center' >
            <span data-tip='Rank'>R</span>
          </TableHeaderColumn>
        </BootstrapTable>
      </div>
    )
  }
}
