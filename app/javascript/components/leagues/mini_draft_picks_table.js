import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import Alert from 'react-s-alert';
import { Icon } from 'react-fa';
import _ from 'underscore';

export default class MiniDraftPicksTable extends Component {
  constructor (props) {
    super(props);
    this.options = {
      defaultSortName: 'pick_number',
      defaultSortOrder: 'asc'
    }
  }

  render () {
    const selectFplTeamText = _.object(_.map(this.props.fpl_teams, function (obj) {
      return [obj.name, obj.name]
    }).sort());

    return (
      <div>
        <BootstrapTable
          data={ this.props.draft_picks }
          striped
          hover
          options={ this.options }>
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='pick_number'
            dataAlign='center'
            filter={ { type: 'TextFilter', placeholder: ' ', condition: 'eq' } }
            dataSort
            isKey>
            <span data-tip='Pick Number'>PN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='fpl_team_name'
            dataAlign='center'
            filter={ { type: 'SelectFilter', placeholder: ' ', options: selectFplTeamText } }
            dataSort>
            <span data-tip='Fpl Team'>Fpl T</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='0' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='Out'>Out</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            colSpan='1'
            rowSpan='1'
            dataField='out_last_name'
            dataAlign='center'
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            colSpan='1'
            rowSpan='1'
            dataField='out_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='0' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='In'>In</span>
          </TableHeaderColumn>

          <TableHeaderColumn
            row='1'
            colSpan='1'
            dataField='in_last_name'
            dataAlign='center'
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            colSpan='1'
            dataField='in_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='singular_name_short'
            dataAlign='center'
          >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
