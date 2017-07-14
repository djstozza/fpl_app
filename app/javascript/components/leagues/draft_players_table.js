import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import Alert from 'react-s-alert';
import { Icon } from 'react-fa';
import _ from 'underscore';

export default class DraftPlayersTable extends Component {
  constructor(props) {
    super(props)
    this.options = {
      paginationShowsTotal: true,
      defaultSortName: 'ict_index',
      defaultSortOrder: 'desc'
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
    if (this.props.current_draft_pick && this.props.current_draft_pick.fpl_team_id == this.props.fpl_team.id) {
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

  componentWillReceiveProps (nextProps) {
    if (nextProps.current_draft_pick) {
      this.yourTurn(nextProps.current_draft_pick.fpl_team_id, nextProps.fpl_team.id);
    }
  }

  yourTurn (curren_pick_fpl_team_id, fpl_team_id) {
    if (curren_pick_fpl_team_id == fpl_team_id) {
      return (
        Alert.info("It's your turn to pick a player", {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        })
      )
    }
  }

  columnClassNameFormat (fieldValue, row, rowIdx, colIdx) {
    return `player-status-${row.status}`
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

    const statuses = {
      a: { name: 'check', title: 'Available' },
      n: { name: 'warning', title: 'Unavailable' },
      u: { name: 'plane', title: 'On Loan' },
      d: { name: 'question', title: 'In Doubt' },
      s: { name: 'gavel', title: 'Suspended' },
      i: { name: 'ambulance', title: 'Injured' }
    }

    const statusText = _.mapObject(statuses, (val, key) => {
      return val['title']
    })

    let statusIconCell = function (cell, row) {
      return (
        <Icon size='lg' name={ statuses[cell].name } />
      )
    }

    let ictSort = (a, b, order) => {
      if (order == 'desc') {
        return b.ict_index - a.ict_index
      } else {
        return a.ict_index - b.ict_index
      }
    }

    return (
      <div>
        <BootstrapTable
          data={ this.props.players }
          options={ this.options }
          striped
          hover
          ignoreSinglePage
          options={ this.options }
          pagination={ this.props.teams != null && this.state.pagination == true }>
          <TableHeaderColumn
            dataField='first_name'
            dataAlign='center'
            dataSort
            dataFormat={ this.linkCellText }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='First Name'>FN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            dataSort
            dataFormat={ this.linkCellText }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Name'>LN</span>
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
          <TableHeaderColumn
            dataField='ict_index'
            dataAlign='center'
            dataSort
            sortFunc={ ictSort }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='ICT Index'>ICT</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='status'
            dataAlign='center'
            dataSort
            columnClassName={ this.columnClassNameFormat }
            dataFormat={ statusIconCell }
            filter={ { type: 'SelectFilter', options: statusText, placeholder: ' ' } }>
            <span data-tip='Status'>S</span>
          </TableHeaderColumn>
          { this.showDraftCol() }
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
