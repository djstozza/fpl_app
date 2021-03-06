import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import Alert from 'react-s-alert';
import _ from 'underscore';

import fetchFplTeam from '../actions/fpl_teams/action_fetch_fpl_team.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import fetchFplTeamLists from '../actions/fpl_team_lists/action_fetch_fpl_team_lists.js';
import fetchFplTeamList from '../actions/fpl_team_lists/action_fetch_fpl_team_list.js';
import updateFplTeamList from '../actions/fpl_team_lists/action_update_fpl_team_list.js';
import createWaiverPick from '../actions/waiver_picks/action_create_waiver_pick.js';
import fetchWaiverPicks from '../actions/waiver_picks/action_fetch_waiver_picks.js';
import deleteWaiverPick from '../actions/waiver_picks/action_delete_waiver_pick.js';
import updateWaiverPickOrder from '../actions/waiver_picks/action_update_waiver_pick_order.js';
import fetchCurrentRound from '../actions/action_fetch_current_round.js';

import tradePlayers from '../actions/action_trade_players.js';
import RoundsNav from '../components/rounds/rounds_nav.js';
import TeamListTable from '../components/fpl_teams/team_list_table.js';
import TradePlayersTable from '../components/fpl_teams/trade_players_table.js';
import WaiverPicksTable from '../components/fpl_teams/waiver_picks_table.js';
import StatusChart from '../components/fpl_teams/status_chart.js';
import TradeGroupNotifications from '../components/fpl_teams/trade_group_notifications.js';
import RoundCountdown from '../components/rounds/round_countdown.js';

class FplTeam extends Component {
  constructor(props) {
    super(props)
    this.showButtons = this.showButtons.bind(this);
    this.substitutePlayer = this.substitutePlayer.bind(this);
    this.setlistPosition = this.setlistPosition.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
    this.roundDataSource = this.roundDataSource.bind(this);
    this.tradePlayers = this.tradePlayers.bind(this);
    this.sortWaiverPicks = this.sortWaiverPicks.bind(this);
    this.waiverPicks = this.waiverPicks.bind(this);
    this.updateWaiverPickOrder = this.updateWaiverPickOrder.bind(this);
    this.deleteWaiverPick = this.deleteWaiverPick.bind(this);
    this.tradeGroupNotifications = this.tradeGroupNotifications.bind(this);
    this.roundsNav = this.roundsNav.bind(this);
    this.roundCountdown = this.roundCountdown.bind(this);
    this.teamListTable = this.teamListTable.bind(this);
    this.statusChart = this.statusChart.bind(this);

    this.state = {
      action: 'selectLineUp',
      clearSelection: false,
      fplTeamId: this.props.match.params.id
    }
  }

  roundDataSource (roundId) {
    let fplTeamList = _.find(this.state.fpl_team_lists, (obj) => {
      return obj.round_id == roundId
    });

    this.props.fetchFplTeamList(this.props.match.params.id, fplTeamList.id);
    this.props.fetchWaiverPicks(this.state.fplTeamId, roundId);
  }

  substitutePlayer (playerId, targetId) {
    this.props.updateFplTeamList(this.state.fplTeamId, this.state.fpl_team_list.id, playerId, targetId);
  }

  tradePlayers (targetId) {
    this.props.tradePlayers(this.state.fplTeamId, this.state.listPosition.id, targetId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
    window.scrollTo(0, 0);
    this.setState({
      listPosition: null,
      clearSelection: true
    });
  }

  waiverPicks (targetId) {
    this.props.createWaiverPick(
      this.state.fplTeamId,
      this.state.fpl_team_list.id,
      this.state.listPosition.id,
      targetId
    );
    window.scrollTo(0, 0);
    this.setState({
      listPosition: null,
      clearSelection: true
    });
  }

  completeTradeAction (targetId) {
    switch (this.state.action) {
      case 'tradePlayers':
        return this.tradePlayers(targetId);
      case 'waiverPicks':
        return this.waiverPicks(targetId);
    }
  }

  updateWaiverPickOrder (waiverPickId, newPickNumber) {
    this.props.updateWaiverPickOrder(this.state.fplTeamId, this.state.fpl_team_list.id, waiverPickId, newPickNumber);
  }

  deleteWaiverPick (waiverPickId) {
    this.props.deleteWaiverPick(this.state.fplTeamId, this.state.fpl_team_list.id, waiverPickId);
  }

  sortWaiverPicks () {
    if (this.state.waiver_picks == null) {
      return;
    }

    if (this.state.waiver_picks.length == 0 || this.state.fpl_team.user_id != this.state.current_user.id) {
      return;
    }

    return (
      <WaiverPicksTable
        waiver_picks={ this.state.waiver_picks }
        status={ this.state.status }
        line_up={ this.state.line_up }
        positions={ this.state.positions }
        teams={ this.state.teams }
        fpl_team={ this.state.fpl_team }
        round={ this.state.round }
        updateWaiverPickOrder={ this.updateWaiverPickOrder }
        deleteWaiverPick={ this.deleteWaiverPick }
      />
    )
  }

  setlistPosition (listPosition) {
    this.setState({
      listPosition: listPosition,
      clearSelection: false
    });
  }

  componentWillMount () {
    this.props.fetchCurrentRound();
    this.props.fetchFplTeam(this.state.fplTeamId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
    this.props.fetchWaiverPicks(this.state.fplTeamId, null);
    this.props.fetchTeams();
  }

  componentDidMount () {
    setInterval(function () {
      if (!this.state.fpl_team.active) {
        return;
      }

      if (!this.state.round.is_current && !this.state.round.is_next) {
        return;
      }

      if (this.state.round.data_checked) {
        return;
      }

      if (this.state.round.id != this.state.fpl_team_list.round_id) {
        return;
      }

      this.props.fetchFplTeamLists(this.state.fplTeamId);
    }.bind(this), 10000);
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      fpl_teams: nextProps.fpl_teams,
      current_user: nextProps.current_user,
      unpicked_players: nextProps.unpicked_players,
      picked_players: nextProps.picked_players,
      fpl_team_list: nextProps.fpl_team_list,
      fpl_team_lists: nextProps.fpl_team_lists,
      status: nextProps.status,
      waiver_picks: nextProps.waiver_picks,
      line_up: nextProps.line_up,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams,
      score: nextProps.score,
      current_round: nextProps.current_round,
      current_round_deadline: nextProps.current_round_deadline,
      current_round_status: nextProps.current_round_status,
      submitted_in_trade_group_count: nextProps.submitted_in_trade_group_count,
      approved_out_trade_group_count: nextProps.approved_out_trade_group_count,
      declined_out_trade_group_count: nextProps.declined_out_trade_group_count
    });

    if (nextProps.round != null && new Date(nextProps.round.deadline_time) < new Date()) {
      this.setState({
        action: 'pastRound'
      });
    } else if (this.state.action == 'pastRound' && nextProps.status != null) {
      this.setState({
        action: 'selectLineUp'
      });
    }

    if (this.props.success != nextProps.success) {
      this.successMesssage(nextProps.success);
    }
    if (this.props.errors != nextProps.errors) {
      this.errorMessages(nextProps.errors);
    }
  }

  successMesssage (success) {
    if (success == null) {
      return;
    }

    Alert.success(success, {
      position: 'top',
      effect: 'bouncyflip',
      timeout: 5000
    });
  }

  errorMessages (errors) {
    if (errors == null) {
      return;
    }

    errors.map((error) => {
      Alert.error(error, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });
    });
  }

  setAction (action) {
    this.setState({
      action: action
    });

    if (action == 'selectLineUp') {
      this.setState({
        clearSelection: false
      })
    }
  }

  tradePlayersTable () {
    if (this.state.fpl_team.active && (this.state.action == 'tradePlayers' || this.state.action == 'waiverPicks')) {
      return (
        <Col xs={12}>
          <TradePlayersTable
            unpicked_players={ this.state.unpicked_players }
            teams={ this.state.teams }
            positions={ this.state.positions }
            current_user={ this.state.current_user }
            fpl_team={ this.state.fpl_team }
            round={ this.state.round }
            status={ this.state.status }
            action={ this.state.action }
            listPosition={ this.state.listPosition }
            completeTradeAction={ this.completeTradeAction }
          />
        </Col>
      )
    }
  }

  tradeButtons () {
    switch (this.state.status) {
      case 'trade':
        return (<Button onClick={ () => this.setAction('tradePlayers') }>Trade Players</Button>);
      case 'waiver':
        return (<Button onClick={ () => this.setAction('waiverPicks') }>Trade Players (Waiver)</Button>);
      case 'mini_draft':
        return (<Button href={`/leagues/${this.state.league.id}/mini_draft_picks`}>Go to Mini Draft</Button>)
      default: null

    }
  }

  showButtons () {
    if (this.state.status == null) {
      return;
    }

    if (this.state.action == 'pastRound') {
      return;
    }

    if (this.state.fpl_team.user_id != this.state.current_user.id || this.state.line_up == '') {
      return;
    }

    return (
      <div>
        <Button onClick={ () => this.setAction('selectLineUp') }>Select starting line up</Button>
        { this.tradeButtons() }
        <Button href={ `/fpl_teams/${this.state.fplTeamId}/inter_team_trade_groups` }>
          Create/View Inter Team Trades
        </Button>
      </div>
    )
  }

  roundScore () {
    if (this.state.score == null) {
      return;
    }

    if (!this.state.round.data_checked && this.state.status == null) {
      return `Provisional round score: ${this.state.score}`
    } else if (!this.state.round.data_checked && this.state.status != null) {
      return `Last round: ${this.state.score}`
    } else {
      return `Round score: ${this.state.score}`
    }
  }

  tradeGroupNotifications () {
    if (this.state.fpl_team.user_id == this.state.current_user.id) {
      return (
        <TradeGroupNotifications
          fplTeamId={ this.state.fplTeamId }
          submitted_in_trade_group_count={ this.state.submitted_in_trade_group_count }
          approved_out_trade_group_count={ this.state.approved_out_trade_group_count }
          declined_out_trade_group_count={ this.state.declined_out_trade_group_count }
        />
      );
    }
  }

  roundCountdown () {
    if (this.state.current_round_deadline && this.state.fpl_team.active) {
      return (
        <RoundCountdown
          round={ this.state.current_round }
          current_round_deadline={ this.state.current_round_deadline }
          current_round_status={ this.state.current_round_status }
        />
      );
    }
  }

  roundsNav () {
    if (!this.state.fpl_team.active) {
      return;
    }

    return (
      <RoundsNav rounds={ this.state.rounds } round={ this.state.round } onChange={ this.roundDataSource } />
    );
  }

  teamListTable () {
    if (this.state.fpl_team.active) {
      return (
        <Row className='clearfix'>
          <Col xs={12}>
            <TeamListTable
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              line_up={ this.state.line_up }
              positions={ this.state.positions }
              teams={ this.state.teams }
              round={ this.state.round }
              status={ this.state.status }
              action={ this.state.action }
              clearSelection={ this.state.clearSelection }
              substitutePlayer={ this.substitutePlayer }
              setlistPosition={ this.setlistPosition }
            />
          </Col>
        </Row>
      );
    }
  }

  statusChart () {
    if (this.state.fpl_team.active) {
      return (
        <Row className='clearfix'>
          <Col sm={12}>
            <StatusChart
              fpl_team_lists={ this.state.fpl_team_lists }
              rounds={ this.state.rounds }
              fpl_teams={ this.state.fpl_teams }
            />
          </Col>
        </Row>
      );
    }
  }

  render () {
    if (
        this.state == null ||
        this.state.fpl_team == null ||
        this.state.fpl_team.active && this.state.fpl_team_list == null
      ) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          { this.roundCountdown() }
          <h2>{ this.state.fpl_team.name }</h2>
          { this.roundsNav() }
          { this.showButtons() }
          { this.tradeGroupNotifications() }
          <h4>{ this.roundScore() }</h4>
          { this.teamListTable() }
          <Row className='clearfix'>
            { this.tradePlayersTable() }
          </Row>
          <Row className='clearfix'>
            <Col sm={12}>
              { this.sortWaiverPicks() }
            </Col>
          </Row>
          { this.statusChart() }
        </div>
      )
    }
  }
}

function mapStateToProps (state) {
  return {
    league: state.FplTeamReducer.league,
    fpl_team: state.FplTeamReducer.fpl_team,
    fpl_teams: state.FplTeamReducer.fpl_teams,
    current_user: state.FplTeamReducer.current_user,
    picked_players: state.FplTeamReducer.picked_players,
    unpicked_players: state.FplTeamListsReducer.unpicked_players,
    fpl_team_list: state.FplTeamListsReducer.fpl_team_list,
    fpl_team_lists: state.FplTeamListsReducer.fpl_team_lists,
    line_up: state.FplTeamListsReducer.line_up,
    status: state.FplTeamListsReducer.status,
    waiver_picks: state.WaiverPicksReducer.waiver_picks || state.FplTeamReducer.waiver_picks,
    positions: state.FplTeamReducer.positions,
    current_round: state.CurrentRoundReducer.current_round,
    current_round_deadline: state.CurrentRoundReducer.current_round_deadline,
    current_round_status: state.CurrentRoundReducer.current_round_status,
    round: state.FplTeamListsReducer.round,
    rounds: state.FplTeamListsReducer.rounds,
    score: state.FplTeamListsReducer.score,
    deadline: state.FplTeamListsReducer.deadline,
    submitted_in_trade_group_count: state.FplTeamListsReducer.submitted_in_trade_group_count,
    approved_out_trade_group_count: state.FplTeamListsReducer.approved_out_trade_group_count,
    declined_out_trade_group_count: state.FplTeamListsReducer.declined_out_trade_group_count,
    teams: state.TeamsReducer,
    success: state.FplTeamListsReducer.success || state.TradePlayersReducer.success || state.WaiverPicksReducer.success,
    errors: state.FplTeamListsReducer.errors || state.TradePlayersReducer.errors || state.WaiverPicksReducer.errors
  }
}

function mapDispatchToProps (dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam,
    fetchTeams: fetchTeams,
    fetchFplTeamLists: fetchFplTeamLists,
    fetchFplTeamList: fetchFplTeamList,
    updateFplTeamList: updateFplTeamList,
    tradePlayers: tradePlayers,
    createWaiverPick: createWaiverPick,
    fetchWaiverPicks: fetchWaiverPicks,
    updateWaiverPickOrder: updateWaiverPickOrder,
    deleteWaiverPick: deleteWaiverPick,
    fetchCurrentRound: fetchCurrentRound
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(FplTeam);
