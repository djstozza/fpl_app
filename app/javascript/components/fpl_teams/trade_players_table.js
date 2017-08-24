import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import _ from 'underscore';

export default class TradePlayersTable extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: ''
    }

    this.options = {
      hideSizePerPage: true,
      paginationShowsTotal: true,
    }
    this.onRowSelect = this.onRowSelect.bind(this);
    this.trClassFormat = this.trClassFormat.bind(this);
    this.completeTradeActionButton = this.completeTradeActionButton.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
  }

  descriptionText () {
    switch (this.props.action) {
      case 'tradePlayers':
        return (
          <div>
            <h3>Trade In Player</h3>
            <p>(2) Click the row of the player you wish to trade in.</p>
          </div>
        )
      case 'waiverPicks':
        return (
          <div>
            <h3>Waiver (In)</h3>
            <p>(2) Click the row of the player you wish to trade in for this waiver pick.</p>
          </div>
        );
      case 'pastRound':
        return;
    }
  }

  linkCellText (cell, row) {
    return (<Link to={`/players/${row.id}` } >{cell}</Link>);
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.listPosition == null) {
      this.refs.positionId.cleanFiltered();
      this.setState({
        selected: ''
      })
      return;
    }

    this.refs.position.applyFilter(nextProps.listPosition.singular_name_short);

    if (
        this.props.listPosition &&
        this.props.listPosition.singular_name_short != nextProps.listPosition.singular_name_short
      ) {
      this.setState({
        selected: ''
      })
    }
  }

  onRowSelect (row, isSelected, e) {
    if (this.props.action == 'pastRound') {
      return;
    }

    if (this.props.action == 'tradePlayers' || this.props.action == 'waiverPicks') {
      return this.selectPlayerToTrade(row);
    }
  }

  trClassFormat (row) {
    if (this.state.selected == row) {
      return 'substitute-option'
    }
  }

  selectPlayerToTrade (row) {
    if (this.props.listPosition == null) {
      return;
    }

    if (this.state.selected != row) {
      this.setState({
        selected: row
      });
    } else if (this.state.selected == row) {
      this.setState({
        selected: ''
      });
    }
  }

  completeTradeAction () {
    this.props.completeTradeAction(this.state.selected.id);
    this.setState({
      selected: ''
    })
  }

  completeTradeActionButton () {
    if (this.props.fpl_team.user_id != this.props.current_user.id || this.props.status == null) {
      return;
    }

    if (this.state.selected && this.props.listPosition) {
      return (
        <div>
          <p>(3) Click the button below to complete.</p>
          <Button onClick={ () => this.completeTradeAction() }>
            Complete
          </Button>
        </div>
      )
    }
  }

  render () {
    const positionText= _.object(_.map(this.props.positions, function (obj) {
      return [obj.singular_name_short, obj.singular_name_short]
    }));

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

    let columnClassNameFormat = (fieldValue, row, rowIdx, colIdx) => {
      return `player-status-${row.status}`
    }

    const statusText = _.mapObject(statuses, (val, key) => {
      return val['title']
    })

    let statusIconCell = function (cell, row) {
      return (
        <Icon size='lg' name={ statuses[cell].name } />
      )
    }

    const selectRowProp = {
      mode: 'checkbox',
      hideSelectColumn: true,
      clickToSelect: true,
      onSelect: this.onRowSelect
    };

    return (
      <div>
        { this.descriptionText() }
        <BootstrapTable
          data={ this.props.unpicked_players }
          selectRow={ selectRowProp }
          options={ this.options }
          trClassName={ this.trClassFormat }
          striped
          hover
          pagination >
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            dataSort
            dataFormat={ this.linkCellText }
            filter={ { type: 'TextFilter', placeholder: ' ' } }
            isKey>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='short_name'
            dataAlign='center'
            dataSort
            filter={ { type: 'SelectFilter', options: selectTeamText, placeholder: ' ' } }>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='singular_name_short'
            ref='position'
            dataAlign='center'
            dataSort
            filter={ {
              type: 'SelectFilter',
              options: positionText,
              placeholder: ' '
            }
          }>
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            filter={ { type: 'NumberFilter', placeholder: ' ' } }
          >
            <span data-tip='Total Points (last season)'>TP</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='status'
            dataAlign='center'
            columnClassName={ columnClassNameFormat }
            dataFormat={ statusIconCell }
            filter={ { type: 'SelectFilter', options: statusText, placeholder: ' ' } }>
            <span data-tip='Status'>S</span>
          </TableHeaderColumn>
        </BootstrapTable>
        { this.completeTradeActionButton() }
        <ReactTooltip />
      </div>
    )
  }
}
