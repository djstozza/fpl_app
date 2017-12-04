import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import { Button } from 'react-bootstrap';

export default class InTradesTable extends Component {
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

  componentWillReceiveProps (nextProps) {
    if (nextProps.out_player == null) {
      if (this.refs.position) {
        this.refs.position.cleanFiltered();
      }

      this.setState({
        selected: ''
      });

      return;
    }

    this.refs.position.applyFilter(nextProps.out_player.singular_name_short);

    if (
        this.props.out_player &&
        this.props.out_player.singular_name_short != nextProps.out_player.singular_name_short
      ) {
      this.setState({
        selected: ''
      });
    }
  }

  onRowSelect (row, isSelected, e) {
    if (this.props.status == null) {
      return;
    }

    return this.selectPlayerToTrade(row);
  }

  selectPlayerToTrade (row) {
    if (this.props.out_player == null) {
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

  trClassFormat (row) {
    if (this.state.selected == row) {
      return 'substitute-option'
    }
  }

  completeTradeAction () {
    this.props.completeTradeAction(this.state.selected);
    this.setState({
      selected: ''
    })
  }

  completeTradeActionButton () {
      if (this.props.fpl_team.user_id != this.props.current_user.id || this.props.status == null) {
        return;
      }

      if (this.state.selected && this.props.out_player) {
        return (
          <div>
            <p>(3) Click the button below to complete.</p>
            <Button bsStyle='success' onClick={ () => this.completeTradeAction() }>
              Complete
            </Button>
          </div>
        )
      }
    }

  render () {
    const selectTeamText = _.object(_.map(this.props.teams, function (obj) {
      return [obj.short_name, obj.name]
    }).sort());

    const selectFplTeamText = _.object(_.map(this.props.fpl_teams, function (obj) {
      return [obj.name, obj.name]
    }).sort());

    const positionText= _.object(_.map(this.props.positions, function (obj) {
      return [obj.singular_name_short, obj.singular_name_short]
    }));

    const selectRowProp = {
      mode: 'checkbox',
      hideSelectColumn: true,
      clickToSelect: true,
      onSelect: this.onRowSelect
    };

    return (
      <div>
        <BootstrapTable
          data={ this.props.in_players_tradeable }
          options={ this.options }
          selectRow={ selectRowProp }
          trClassName={ this.trClassFormat }
          striped
          hover
          pagination
        >
          <TableHeaderColumn dataField='in_player_id' dataAlign='center' isKey hidden>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='last_name'
            dataAlign='center'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }
          >
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='short_name'
            dataAlign='center'
            dataSort
            filter={ { type: 'SelectFilter', options: selectTeamText, placeholder: ' ' } }
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='in_fpl_team_name'
            dataAlign='center'
            filter={ { type: 'SelectFilter', options: selectFplTeamText, placeholder: ' ' } }
          >
            <span data-tip='Fpl Team'>Fpl T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='singular_name_short'
            dataAlign='center'
            ref='position'
            filter={ { type: 'SelectFilter', options: positionText, placeholder: ' ' } }
          >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='event_points'
            dataAlign='center'
            filter={ { type: 'NumberFilter', placeholder: ' ' } }
          >
            <span data-tip='Last Round'>LR</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            filter={ { type: 'NumberFilter', placeholder: ' ' } }
          >
            <span data-tip='Total Points'>TP</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
        { this.completeTradeActionButton() }
      </div>
    )
  }
}
