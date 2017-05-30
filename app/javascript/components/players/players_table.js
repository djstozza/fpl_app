import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Button, Modal, Checkbox } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import ReactTooltip from 'react-tooltip';
import _ from 'underscore';
require('../../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

export default class PlayersTable extends Component {
  constructor(props) {
    super(props)
    this.options = {
      defaultSortName: 'total_points',
      defaultSortOrder: 'desc',
      paginationShowsTotal: true
    }

    this.state = {
      showColumnVisibilityModal: false,
      hiddenColumns: {},
      pagination: true,
      dreamTeamButtonText: 'Show Dream Team'
    };

    this.openColumnDialog = this.openColumnDialog.bind(this);
    this.closeColumnDialog = this.closeColumnDialog.bind(this);
    this.changeColumn = this.changeColumn.bind(this);
    this.dreamTeamButton = this.dreamTeamButton.bind(this);
    this.handleBtnClick = this.handleBtnClick.bind(this);
  }

  closeColumnDialog() {
    this.setState({ showColumnVisibilityModal: false });
  }

  openColumnDialog() {
    this.setState({ showColumnVisibilityModal: true });
  }

  changeColumn(id) {
    return () => {
      this.setState({
        hiddenColumns: Object.assign(this.state.hiddenColumns, { [id]: !this.state.hiddenColumns[id] })
      });
    };
  }

  dreamTeamButton () {
    if (this.props.teams != null) {
      return (<Button onClick={ this.handleBtnClick }>{ this.state.dreamTeamButtonText }</Button>);
    }
  }

  handleBtnClick () {
    if (this.refs.showDreamTeamCol == null || this.refs.showDreamTeamCol == false) {
      this.refs.dreamTeamCol.applyFilter('true');
      this.refs.showDreamTeamCol = true;
      this.setState({
        pagination: false,
        dreamTeamButtonText: 'Show All Players'
      });
    } else {
      this.refs.dreamTeamCol.applyFilter('');
      this.refs.showDreamTeamCol = false;
      this.setState({
        pagination: true,
        dreamTeamButtonText: 'Show Dream Team'
      });
    }
  }

  linkCellText (cell, row) {
    return (<Link to={`/players/${row.id}` } >{cell}</Link>);
  }

  render () {
    const positionText = { 1: 'GKP', 2: 'DEF', 3: 'MID', 4: 'FWD' }
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
        <Button onClick={this.openColumnDialog}>Show/Hide Columns</Button>
        { this.dreamTeamButton() }

        <Modal show={ this.state.showColumnVisibilityModal } onHide={ this.closeColumnDialog }>
          <Modal.Header closeButton><b>Show/Hide Columns</b></Modal.Header>
          <Modal.Body>
            <Checkbox
              inline
              onChange={ this.changeColumn('minutes') }
              checked={ !this.state.hiddenColumns.minutes } >
              Minutes
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('goals_scored') }
              checked={ !this.state.hiddenColumns.goals_scored } >
              Goals
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('assists') }
              checked={ !this.state.hiddenColumns.assists } >
              Assists
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('yellow_cards') }
              checked={ !this.state.hiddenColumns.yellow_cards } >
              Yellow Cards
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('red_cards') }
              checked={ !this.state.hiddenColumns.red_cards } >
              Red Cards
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('total_points') }
              checked={ !this.state.hiddenColumns.total_points } >
              Total Points
            </Checkbox>

            <br/>

            <Checkbox
              inline
              onChange={ this.changeColumn('form') }
              checked={ this.state.hiddenColumns.form } >
              Form
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('points_per_game') }
              checked={ this.state.hiddenColumns.points_per_game } >
              Points Per Game
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('saves') }
              checked={ this.state.hiddenColumns.saves } >
              Saves
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('clean_sheets') }
              checked={ this.state.hiddenColumns.clean_sheets } >
              Clean Sheets
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('penalties_saved') }
              checked={ this.state.hiddenColumns.penalties_saved } >
              Penalties Saved
            </Checkbox>

            <br/>

            <Checkbox
              inline
              onChange={ this.changeColumn('goals_conceded') }
              checked={ this.state.hiddenColumns.goals_conceded } >
              Goals Conceded
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('penalties_missed') }
              checked={ this.state.hiddenColumns.penalties_missed } >
              Penalties Missed
            </Checkbox>
            <Checkbox
              inline
              onChange={ this.changeColumn('winning_goals') }
              checked={ this.state.hiddenColumns.winning_goals } >
              Winning Goals
            </Checkbox>

          </Modal.Body>
        </Modal>
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
            dataFormat={this.linkCellText}
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='id' isKey={ true } hidden/>
          <TableHeaderColumn
            dataField='team_id'
            dataAlign='center'
            dataSort
            hidden={ this.props.teams == null }
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
            dataField='minutes'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.minutes }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Minutes'>Min</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_scored'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.goals_scored }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals'>G</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='winning_goals'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.winning_goals }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Winning Goals'>WG</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='assists'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.assists }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Assists'>A</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='saves'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.saves }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Saves'>S</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='clean_sheets'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.clean_sheets }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Clean Sheets'>CS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='goals_conceded'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.goals_conceded }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Goals Conceded'>GC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_saved'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.penalties_saved }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Saved'>PS</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='penalties_missed'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.penalties_missed }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Penalties Missed'>PM</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='yellow_cards'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.yellow_cards }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Yellow Cards'>YC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='red_cards'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.red_cards }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Red Cards'>RC</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='form'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.form }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Form'>F</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='points_per_game'
            dataAlign='center'
            dataSort
            hidden={ !this.state.hiddenColumns.points_per_game }
            filter={ { type: 'TextFilter', placeholder: ' ' } }>
            <span data-tip='Points Per Game'>PPG</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='in_dreamteam'
            ref='dreamTeamCol'
            dataAlign='center'
            dataSort
            hidden
            filter={ { type: 'SelectFilter', options: { true: true, false: false }, placeholder: ' ' } }/>
          <TableHeaderColumn
            dataField='total_points'
            dataAlign='center'
            dataSort
            hidden={ this.state.hiddenColumns.total_points }
            filter={ { type: 'TextFilter', placeholder: ' ' } } >
            <span data-tip='Total Points'>TP</span>
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
