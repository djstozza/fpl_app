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
          <td key={ `round-${teamList.round_id}-total-score`}>{ teamList.list_score }</td>,
          <td key={ `round-${teamList.round_id}-overall-rank`}>{ teamList.overall_rank }</td>
        ]
      })
    )
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
    )

  }

  render () {
    return (
      <div>
        <Table className='league-list-table' bordered striped hover>
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
