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
      defaultSortName: 'total_points',
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
    return <Button onClick={ () => this.draftPlayer(row.id) }>Draft</Button>
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

  yourTurn (current_pick_fpl_team_id, fpl_team_id) {
    if (current_pick_fpl_team_id == fpl_team_id) {
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
    const selectPositionText = _.object(_.map(this.props.positions, function (obj) {
      return [obj.singular_name_short, obj.singular_name_short]
    }))

    const selectTeamText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.short_name, obj.name]
    }).sort());

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
            dataField='short_name'
            dataAlign='center'
            dataSort
            filter={ { type: 'SelectFilter', options: selectTeamText, placeholder: ' ' } }>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='singular_name_short'
            dataAlign='center'
            dataSort
            filter={ { type: 'SelectFilter', options: selectPositionText, placeholder: ' ' } }>
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            filter={ { type: 'NumberFilter', placeholder: ' ' } }>
            <span data-tip='Total Point'>TP</span>
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
