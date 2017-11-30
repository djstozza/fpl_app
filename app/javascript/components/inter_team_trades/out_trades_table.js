import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import _ from 'underscore';

export default class OutTradesTable extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: '',
      options: []
    }
    this.onRowSelect = this.onRowSelect.bind(this);
    this.trClassFormat = this.trClassFormat.bind(this);
  }

  onRowSelect (row, isSelected, e) {
    if (this.props.fpl_team.user_id != this.props.current_user.id || this.props.status == null) {
      return false
    }

    return this.tradePlayers(row);
  }

  trClassFormat (row) {
    if (this.state.selected == row.out_player_id) {
      return 'selected-player'
    } else {
      return ''
    }
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.clearSelection) {
      this.setState( {selected: ''} )
    }
  }

  tradePlayers (row) {
    if (this.state.selected != row.out_player_id) {
      this.props.setOutPlayer(row);
      this.setState({
        selected: row.out_player_id
      });
    } else if (this.state.selected == row.out_player_id) {
      this.setState({
        selected: ''
      });
      this.props.setOutPlayer(null);
    }
  }

  render () {
    const selectRowProp = {
      mode: 'checkbox',
      hideSelectColumn: true,
      clickToSelect: true,
      onSelect: this.onRowSelect,
    };


    return (
      <div>
        <BootstrapTable
          data={ this.props.out_players_tradeable }
          selectRow={ selectRowProp }
          trClassName={ this.trClassFormat }
          striped
          hover
        >
          <TableHeaderColumn dataField='out_player_id' dataAlign='center' isKey hidden>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='last_name' dataAlign='center'>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='short_name' dataAlign='center'>
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='singular_name_short' dataAlign='center'>
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='event_points' dataAlign='center' >
            <span data-tip='Last Round'>LR</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='total_points' dataAlign='center' >
            <span data-tip='Total Points'>TP</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
