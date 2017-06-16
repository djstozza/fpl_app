import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import _ from 'underscore';

export default class FplTeamsTable extends Component {
  constructor(props) {
    super(props)
  }

  render () {
    const userText = _.object(_.map(this.props.users, function (obj) {
      return [obj.id, obj.username]
    }));

    let picks = _.sortBy(this.props.draft_picks, function(obj) {
      return obj.pick_number
    })
    let firstPicks = _.first(picks, this.props.fpl_teams.length);

    let firstPicksText = _.object(_.map(firstPicks, function (obj) {
      return [obj.fpl_team_id, obj.pick_number]
    }));

    let userTextCell = function (cell, row) {
      return userText[cell]
    }

    let pickTextCell = function (cell, row) {
      return firstPicksText[cell]
    }

    function pickSortFunc (a, b, order) {
      if (order == 'desc') {
        return  firstPicksText[b.id] - firstPicksText[a.id]
      } else {
        return firstPicksText[a.id] - firstPicksText[b.id]
      }
    }

    function getDraftPicksColumn (draftPicks) {
      if (draftPicks.length > 0) {
        return (
          <TableHeaderColumn
            dataField='id'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataFormat={ pickTextCell }
            dataSort
            sortFunc={ pickSortFunc }>
            <span data-tip='Pick Number'>PN</span>
          </TableHeaderColumn>

        )
      }
    }

    return (
      <div>
        <BootstrapTable
          data={ this.props.fpl_teams }
          striped
          hover >
          <TableHeaderColumn
            dataField='name'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort
            isKey>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='user_id'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataFormat={ userTextCell }
            dataSort>
            <span data-tip='Username'>U</span>
          </TableHeaderColumn>
          { getDraftPicksColumn(this.props.draft_picks) }
          <TableHeaderColumn
            dataField='total_score'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataFormat={ userTextCell }
            dataSort>
            <span data-tip='Total Score'>TS</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    );

  }
}
