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
    const selectPositionText = _.object(_.map(this.props.positions, function (obj) {
      return [obj.singular_name_short, obj.singular_name_short]
    }))

    const selectTeamText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.short_name, obj.name]
    }).sort());

    const selectFplTeamText = _.object(_.map(this.props.fpl_teams, function (obj) {
      return [obj.name, obj.name]
    }).sort());

    let fplTeamTextCell = function (cell, row) {
      return fplTeamText[cell]
    }

    let teamNameTextCell = (cell, row) => {
      return teamNameText[cell]
    }

    let positionTextCell = (cell, row) => {
      return positionText[cell]
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
            dataField='fpl_team_name'
            dataAlign='center'
            filter={ { type: 'SelectFilter', placeholder: ' ', options: selectFplTeamText } }
            dataSort>
            <span data-tip='Fpl Team'>Fpl T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='first_name'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='First Name'>FN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            dataSort>
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='short_name'
            dataAlign='center'
            filter={ { type: 'SelectFilter', options: selectTeamText, placeholder: ' ', condition: 'eq' } }
            dataSort>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='singular_name_short'
            dataAlign='center'
            filter={ { type: 'SelectFilter', options: selectPositionText, placeholder: ' ', condition: 'eq' } }
            dataSort>
            <span data-tip='Position'>P</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
