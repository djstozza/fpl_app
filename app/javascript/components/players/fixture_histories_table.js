import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import _ from 'underscore';

export default class FixtureHistoriesTable extends Component {
  constructor(props) {
    super(props)

    this.data = this.data.bind(this);
    this.state = {
      data: this.data()
    }

    this.roundTableHeaderColumn = this.roundTableHeaderColumn.bind(this);
    this.seasonTeableHeaderColumn = this.seasonTeableHeaderColumn.bind(this);
  }

  data () {
    if (this.props.player_fixture_histories != null) {
      return this.props.player_fixture_histories
    } else {
      return this.props.player_past_histories
    }
  }

  roundTableHeaderColumn () {
    if (this.state.data == this.props.player_fixture_histories) {
      return (
        <TableHeaderColumn
          dataField='round'
          dataAlign='center'
          dataSort
          dataFormat={ this.linkCellText }
          filter={ { type: 'TextFilter', placeholder: ' ' } }
          isKey>
          <span data-tip='Round'>R</span>
        </TableHeaderColumn>
      )
    }
  }

  seasonTeableHeaderColumn () {
    if (this.state.data == this.props.player_past_histories) {
      return (
        <TableHeaderColumn
          dataField='season_name'
          dataAlign='center'
          dataSort
          filter={ { type: 'TextFilter', placeholder: ' ' } }
          isKey>
          <span data-tip='Season'>S</span>
        </TableHeaderColumn>
      )
    }
  }

  linkCellText (cell, row) {
    return (<Link to={`/rounds/${row.round}` } >{cell}</Link>);
  }

  render () {
    return (
      <div>
        <BootstrapTable data={this.state.data}>
          { this.roundTableHeaderColumn() }
          { this.seasonTeableHeaderColumn() }
          <TableHeaderColumn
            dataField='minutes'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Minutes'>Min</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_scored'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals'>G</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='assists'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Assists'>A</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='clean_sheets'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Clean Sheets'>CS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_conceded'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals Conceded'>GC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='yellow_cards'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Yellow Cards'>YC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='red_cards'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Red Cards'>RC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='own_goals'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Own Goals'>OG</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='saves'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Saves'>S</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_saved'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Saved'>PS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_missed'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Missed'>PM</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='bonus'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Bonus'>B</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Points'>Pts</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
