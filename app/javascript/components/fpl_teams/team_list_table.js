import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';

export default class TeamListTable extends Component {
  constructor (props) {
    super(props);
    this.state = {
      selected: '',
      options: []
    }
    this.substitutePlayer = this.substitutePlayer.bind(this);
    this.onRowSelect = this.onRowSelect.bind(this);
    this.trClassFormat = this.trClassFormat.bind(this);
  }

  linkCellText (cell, row) {
    return (<Link to={`/players/${row.player_id}` } >{cell}</Link>);
  }

  substitutePlayer (target) {
    this.props.substitutePlayer(this.state.selected, target);
  }

  selectLineUp (row) {
    if (this.state.selected == '') {
      axios.get(`/list_positions/${row.id}.json`).then(res => {
        if (this.props.action == 'selectLineUp') {
          this.setState({
            selected: row.player_id,
            options: res.data.options
          });
        }
      })
    } else if (this.state.selected == row.player_id) {
      this.setState({
        selected: '',
        options: []
      });
    } else if (_.contains(this.state.options, row.player_id)) {
      this.substitutePlayer(row.player_id);
      this.setState({
        selected: '',
        options: []
      });
    }
  }

  tradePlayers (row) {
    if (this.state.selected != row.player_id) {
      this.props.setlistPosition(row);
      this.setState({
        selected: row.player_id
      });
    } else if (this.state.selected == row.player_id) {
      this.setState({
        selected: ''
      });
      this.props.setlistPosition(null);
    }
  }

  onRowSelect (row, isSelected, e) {
    if (this.props.fpl_team.user_id != this.props.current_user.id || this.props.status == null) {
      return false
    }

    if (this.props.action == 'selectLineUp') {
      return this.selectLineUp(row);
    } else {
      return this.tradePlayers(row);
    }
  }

  trClassFormat (row) {
    if (this.state.selected == row.player_id) {
      return 'selected-player'
    }

    if (_.contains(this.state.options, row.player_id)) {
      return 'substitute-option'
    }
  }

  descriptionText () {
    if (this.props.fpl_team.user_id != this.props.current_user.id || this.props.status == null) {
      return
    }

    const selectLineUpText = () => {
      return (
        <div>
          <h3>Choose your starting line up</h3>
          <p>
            Click the row of the player you wish to sub out. Once clicked, the player you wish to substitute will
              be highlighted in red and all valid substitutions will appear in green. Click one of the green rows to
              enact the substitution. Click the red row to clear your selection.
          </p>
        </div>
      )
    }

    switch (this.props.action) {
      case 'selectLineUp':
        return selectLineUpText();

      case 'tradePlayers':
        return (
          <div>
            <h3>Trade Out Player</h3>
            <p>(1) Click the row of the player you wish to trade out.</p>
          </div>
        );

      case 'waiverPicks':
        return (
          <div>
            <h3>Waiver (Out)</h3>
            <p>(1) Click the row of the player you wish to trade out for this waiver pick</p>
          </div>
        );

      case 'miniDraft':
        return (
          <div>
            <h3>Mini Draft (Out)</h3>
            <p>(1) Click the row of the player you wish to trade out for this mini draft pick</p>
          </div>
        );

      default: selectLineUpText();
    }
  }

  componentWillReceiveProps (nextProps) {
    if (this.props.action != nextProps.action) {
      this.setState({
        selected: '',
        options: []
      })
    }
  }

  render () {
    const self = this;

    let playerLastNameText = _.object(_.map(this.props.line_up, function(obj) {
      return [obj.id, obj.last_name]
    }))

    let playerLastNameCell = (cell, row) => {
      return <Link to={`/players/${cell}` } >{ playerLastNameText[cell] }</Link>
    }

    const statuses = {
      a: { name: 'check', title: 'Available' },
      n: { name: 'warning', title: 'Unavailable' },
      u: { name: 'plane', title: 'On Loan' },
      d: { name: 'question', title: 'In Doubt' },
      s: { name: 'gavel', title: 'Suspended' },
      i: { name: 'ambulance', title: 'Injured' }
    }

    let statusColumnClassNameFormat = (fieldValue, row, rowIdx, colIdx) => {
      return `player-status-${row.status}`
    }

    let statusIconCell = function (cell, row) {
      return (
        <Icon size='lg' name={ statuses[row.status].name } />
      )
    }

    const roleText = {
      starting: 'Starting',
      substitute_1: 'S1',
      substitute_2: 'S2',
      substitute_3: 'S3',
      substitute_gkp: 'SGKP'
    }

    let roleTextCell = (cell, row) => {
      return roleText[cell]
    }

    let playerFixtureHistories = _.object(_.map(this.props.line_up, (obj) => {
      return [
        obj.id,
        _.filter(obj.player_fixture_histories, (obj) => {
          return obj.round == self.props.round.id
        })
      ]
    }));

    let pointsText = (cell, row) => {
      return (
        _.reduce(_.map(playerFixtureHistories[row.id], (obj) => {
          return obj.total_points
        }), (x, y) => { return x + y; }, 0)
      );
    }

    let pointsColumn = () => {
      if (this.props.action == 'pastRound') {
        return (
          <TableHeaderColumn dataField='player_fixture_histories' dataAlign='center' dataFormat={ pointsText } >
            <span data-tip='Points'>Pts</span>
          </TableHeaderColumn>
        );
      } else {
        return [
          <TableHeaderColumn dataField='event_points' dataAlign='center' >
            <span data-tip='Last Round'>LR</span>
          </TableHeaderColumn>,
          <TableHeaderColumn dataField='total_points' dataAlign='center' >
            <span data-tip='Total Points'>TP</span>
          </TableHeaderColumn>
        ]
      }
    }

    let statusColumn = () => {
      if (this.props.round.is_current || this.props.action != 'pastRound') {
        return (
          <TableHeaderColumn
            dataField='status'
            dataAlign='center'
            columnClassName={ statusColumnClassNameFormat }
            dataFormat={ statusIconCell }
          >
            <span data-tip='Status'>S</span>
          </TableHeaderColumn>
        );
      }
    }

    let opponentColumnClassNameFormat = (fieldValue, row, rowIdx, colIdx) => {
      return row.difficulty_class
    }

    const selectRowProp = {
      mode: 'checkbox',
      hideSelectColumn: true,
      clickToSelect: true,
      onSelect: this.onRowSelect
    };

    return (
      <div id='team-list-table'>
        { this.descriptionText() }
        <BootstrapTable
          data={ this.props.line_up }
          selectRow={ selectRowProp }
          striped
          trClassName={ this.trClassFormat }
          hover
        >
          <TableHeaderColumn dataField='id' hidden isKey/>
          <TableHeaderColumn dataField='role' dataAlign='center' dataFormat={ roleTextCell }>
            <span data-tip='Role'>R</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='singular_name_short' dataAlign='center' >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='last_name' dataAlign='center' dataFormat={ this.linkCellText } >
            <span data-tip='Player'>P</span>
          </TableHeaderColumn>
          <TableHeaderColumn dataField='team_short_name' dataAlign='center' >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField='opponent_short_name'
            dataAlign='center'
            columnClassName={ opponentColumnClassNameFormat }
          >
            <span data-tip='Opponent'>O</span>
          </TableHeaderColumn>
          { pointsColumn() }
          { statusColumn() }
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}
