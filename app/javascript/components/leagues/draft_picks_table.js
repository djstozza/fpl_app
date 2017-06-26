import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import _ from 'underscore';


export default class DraftPicksTable extends Component {
  constructor(props) {
    super(props)
    this.options = {
      defaultSortName: 'pick_number',
      defaultSortOrder: 'asc'
    }
  }

  render () {
    const fplTeamText = _.object(_.map(this.props.fpl_teams, function (obj) {
      return [obj.id, obj.name]
    }));

    const playerFirstNameText = _.object(_.map(this.props.players, function(obj) {
      return [obj.id, obj.first_name]
    }))

    const playerLastNameText = _.object(_.map(this.props.players, function(obj) {
      return [obj.id, obj.last_name]
    }))

    const teamNameText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.id, obj.short_name]
    }))

    const positionText = _.object(_.map(this.props.positions, function (obj) {
      return [obj.id, obj.singular_name_short]
    }))

    const positionIdText = _.object(_.map(this.props.players, (obj) => {
      return [obj.id, obj.position_id]
    }))

    const teamIdText = _.object(_.map(this.props.players, (obj) => {
      return [obj.id, obj.team_id]
    }))

    const selectFplTeamText = _.object(_.map(this.props.fpl_teams, function (obj) {
      return [obj.id, obj.name]
    }).sort());

    let playerFirstNameCell = (cell, row) => {
      return playerFirstNameText[cell]
    }

    let fplTeamTextCell = function (cell, row) {
      return fplTeamText[cell]
    }

    let playerLastNameCell = (cell, row) => {
      return playerLastNameText[cell]
    }

    let teamNameTextCell = (cell, row) => {
      return teamNameText[teamIdText[cell]]
    }

    let positionTextCell = (cell, row) => {
      return positionText[positionIdText[cell]]
    }

    return (
      <div>
        <BootstrapTable
          data={ this.props.draft_picks }
          striped
          hover
          options={ this.options }>
          <TableHeaderColumn
            dataField='pick_number'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ', condition: 'eq' } }
            dataSort
            isKey>
            <span data-tip='Pick Number'>PN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='fpl_team_id'
            dataAlign='center'
            filter={ { type: 'SelectFilter', placeholder: ' ', options: selectFplTeamText } }
            dataFormat={ fplTeamTextCell }
            dataSort>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='player_id'
            dataAlign='center'
            dataFormat= { playerFirstNameCell }
            dataSort>
            <span data-tip='First Name'>FN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='player_id'
            dataAlign='center'
            dataFormat= { playerLastNameCell }
            dataSort>
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='player_id'
            dataAlign='center'
            dataFormat= { teamNameTextCell }
            dataSort>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='player_id'
            dataAlign='center'
            dataFormat= { positionTextCell }
            dataSort>
            <span data-tip='Position'>P</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
