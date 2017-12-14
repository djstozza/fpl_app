import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Table } from 'react-bootstrap';
import _ from 'underscore';

export default class TeamListsTable extends Component {
  constructor (props) {
    super(props);
    this.teamList = this.teamList.bind(this);
    this.listDetails = this.listDetails.bind(this);
    this.roundHeaders = this.roundHeaders.bind(this);
    this.listHeaders = this.listHeaders.bind(this);
    this.rankClass = this.rankClass.bind(this);
    this.scrollClass = this.scrollClass.bind(this);
  }

  teamList () {
    const self = this;
    return (
      this.props.fpl_team_list_arr.map(function ([team, teamLists], i) {
        return(
          <tr key={ i }><td>{ team }</td>{ self.listDetails(teamLists) }</tr>

        )
      })
    )
  }

  listDetails (teamLists) {
    return (
      teamLists.map( (teamList) => {
        return [
          <td key={ `round-${teamList.round_id}-total-score`} className={ this.rankClass(teamList.list_rank) }>
            { teamList.list_score }
          </td>,
          <td key={ `round-${teamList.round_id}-overall-rank`} className={ this.rankClass(teamList.overall_rank) }>
            { teamList.overall_rank }
          </td>
        ]
      })
    )
  }

  rankClass (rank) {
    if (rank == 1) {
      return 'rank-first';
    } else if (rank == 2) {
      return 'rank-second';
    } else if (rank == 3) {
      return 'rank-third';
    } else if (rank == this.props.fpl_team_list_arr.length) {
      return 'rank-last';
    }
  }

  roundHeaders () {
    return (
      this.props.fpl_team_list_arr[0][1].map( (teamList) => {
        let roundId = teamList.round_id
        return (
          <th key={ `round-${roundId}` } colSpan='2' rowSpan='1' row='0'>
            <span data-tip={ `Round ${roundId}` }>R{ roundId }</span>
          </th>
        )
      })
    )
  }

  listHeaders () {
    return (
      this.props.fpl_team_list_arr[0][1].map( (teamList) => {
        return [
          <th key={ `round-${teamList.round_id}-scores` } colSpan='1' rowSpan='1' row='1'>
            <span data-tip='Score'>S</span>
          </th>,
          <th key={ `round-${teamList.round_id}-rank-header` } colSpan='1' rowSpan='1' row='1'>
            <span data-tip='Rank'>R</span>
          </th>
        ]
      })
    );
  }

  scrollClass () {
    if (this.props.fpl_team_list_arr[0][1].length > 15) {
      return 'scroll-table'
    }
  }

  render () {
    return (
      <div>
        <h3>League History</h3>
        <Table className={ `league-list-table ${this.scrollClass()}` } bordered striped hover>
          <thead>
            <tr>
              <th rowSpan='2'><span data-tip='Team'>T</span></th>
              { this.roundHeaders() }
            </tr>
            <tr>
              { this.listHeaders() }
            </tr>
          </thead>
          <tbody>
            { this.teamList() }
          </tbody>
        </Table>
        <ReactTooltip/>
      </div>
    );
  }
}
