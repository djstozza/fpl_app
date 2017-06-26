import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import Alert from 'react-s-alert';
import _ from 'underscore';

export default class DraftPlayersTable extends Component {
  constructor(props) {
    super(props)
    this.options = {
      paginationShowsTotal: true
    }

    this.state = {
      pagination: true
    };
    this.draftButton = this.draftButton.bind(this);
    this.showDraftCol = this.showDraftCol.bind(this);
  }

  draftPlayer (playerId) {
    this.props.onChange(playerId)
  }

  linkCellText (cell, row) {
    return (<Link to={`/players/${row.id}` } >{cell}</Link>);
  }

  draftButton (cell, row) {
    return <Button onClick={ () => this.draftPlayer(row.id) }>Draft Player</Button>
  }

  showDraftCol () {
    if (this.props.current_draft_pick.fpl_team_id == this.props.fpl_team.id) {
      return (
        <TableHeaderColumn
          dataField='id'
          dataAlign='center'
          dataFormat={ this.draftButton }>
          <span data-tip='Draft Player'>DP</span>
        </TableHeaderColumn>
      )
    }
  }

  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state || nextProps !== this.props;
  }

  render () {
    const positionText = _.object(_.map(this.props.positions, function (obj) {
      return [obj.id, obj.singular_name_short]
    }))

    const teamText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.id, obj.short_name]
    }));

    const selectTeamText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.short_name, obj.name]
    }).sort());

    let positionTextCell = function (cell, row) {
      return positionText[cell]
    }

    let teamTextCell = function (cell, row) {
      return teamText[cell]
    }

    function filterType (cell, row) {
      return teamText[cell]
    }

    return (
      <div>
        <BootstrapTable
          data={ this.props.players }
          striped
          hover
          ignoreSinglePage
          options={ this.options }
          pagination={ this.props.teams != null && this.state.pagination == true }>
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            dataSort
            dataFormat={ this.linkCellText }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='id' isKey={ true } hidden/>
          <TableHeaderColumn
            dataField='team_id'
            dataAlign='center'
            dataSort
            dataFormat={ teamTextCell }
            filterValue={ filterType }
            filter={ { type: 'SelectFilter', options: selectTeamText, placeholder: ' ' } }>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='position_id'
            dataAlign='center'
            dataSort
            dataFormat={ positionTextCell }
            filter={ { type: 'SelectFilter', options: positionText, placeholder: ' ' } }>
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          { this.showDraftCol() }
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
