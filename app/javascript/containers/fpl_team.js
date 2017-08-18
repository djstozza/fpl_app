import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import fetchFplTeam from '../actions/fpl_teams/action_fetch_fpl_team.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import fetchFplTeamLists from '../actions/fpl_team_lists/action_fetch_fpl_team_lists.js';
import updateFplTeamList from '../actions/fpl_team_lists/action_update_fpl_team_list.js';
import createWaiverPick from '../actions/waiver_picks/action_create_waiver_pick.js';
import fetchWaiverPicks from '../actions/waiver_picks/action_fetch_waiver_picks.js';
import deleteWaiverPick from '../actions/waiver_picks/action_delete_waiver_pick.js';
import updateWaiverPickOrder from '../actions/waiver_picks/action_update_waiver_pick_order.js';
import tradePlayers from '../actions/action_trade_players.js';
import RoundsNav from '../components/rounds/rounds_nav.js';
import TeamListTable from '../components/fpl_teams/team_list_table.js';
import TradePlayersTable from '../components/fpl_teams/trade_players_table.js';
import WaiverPicksTable from '../components/fpl_teams/waiver_picks_table.js';
import Alert from 'react-s-alert';
import _ from 'underscore';

class FplTeam extends Component {
  constructor(props) {
    super(props)
    this.showButtons = this.showButtons.bind(this);
    this.substitutePlayer = this.substitutePlayer.bind(this);
    this.setlistPosition = this.setlistPosition.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
    this.dataSource = this.dataSource.bind(this);
    this.tradePlayers = this.tradePlayers.bind(this);
    this.sortWaiverPicks = this.sortWaiverPicks.bind(this);
    this.waiverPicks = this.waiverPicks.bind(this);
    this.updateWaiverPickOrder = this.updateWaiverPickOrder.bind(this);
    this.deleteWaiverPick = this.deleteWaiverPick.bind(this);
    this.state = {
      action: 'selectLineUp',
      fplTeamId: this.props.match.params.id
    }
  }

  dataSource (roundId) {
    let fplTeamList = _.find(this.state.fpl_team_lists, (obj) => {
      return obj.round_id == roundId
    })

    axios.get(`/fpl_team_lists/${fplTeamList.id}.json`).then((res) => {
      this.setState({
        line_up: res.data.line_up,
        editable: res.data.editable,
        round: res.data.round
      })
    })
  }

  substitutePlayer (playerId, targetId) {
    this.props.updateFplTeamList(this.state.fplTeamId, this.state.fpl_team_list.id, playerId, targetId);
  }

  tradePlayers (targetId) {
    this.props.tradePlayers(this.state.fplTeamId, this.state.listPosition.id, targetId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
  }

  waiverPicks (targetId) {
    this.props.createWaiverPick(this.state.fpl_team_list.id, this.state.listPosition.id, targetId);
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
    this.props.updateWaiverPickOrder(this.state.fpl_team_list.id, waiverPickId, newPickNumber);
  }

  deleteWaiverPick (waiverPickId) {
    this.props.deleteWaiverPick(this.state.fpl_team_list.id, waiverPickId);
  }

  sortWaiverPicks () {
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
    this.setState({ listPosition: listPosition });
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.state.fplTeamId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
    this.props.fetchWaiverPicks(this.state.fplTeamId, null);
    this.props.fetchTeams();
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
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
      teams: nextProps.teams
    });
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
    })
  }

  setTeamTableCol () {
    if (this.state.action == 'selectLineUp') {
      return 12;
    } else if (this.state.action == 'tradePlayers' || this.state.action == 'waiverPicks') {
      return 6;
    }
  }

  tradePlayersTable () {
    if (this.state.action == 'tradePlayers' || this.state.action == 'waiverPicks') {
      return (
        <Col sm={6}>
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
      default: null

    }
  }

  showButtons () {
    if (this.state.status == null) {
      return;
    }
    if (this.state.fpl_team.user_id != this.state.current_user.id || this.state.line_up == '') {
      return;
    }
    return (
      <div>
        <Button onClick={ () => this.setAction('selectLineUp') }>Select starting line up</Button>
        { this.tradeButtons() }
      </div>
    )
  }

  render () {
    if (this.state == null || this.state.fpl_team == null || this.state.fpl_team_list == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          <h2>{ this.state.fpl_team.name }</h2>

          <RoundsNav rounds={ this.state.rounds } round={ this.state.round } onChange={ this.dataSource } />
          { this.showButtons() }
          <Row className='clearfix'>
            <Col sm={ this.setTeamTableCol() } >
              <TeamListTable
                fpl_team={ this.state.fpl_team }
                current_user={ this.state.current_user }
                line_up={ this.state.line_up }
                positions={ this.state.positions }
                teams={ this.state.teams }
                round={ this.state.round }
                status={ this.state.status }
                action={ this.state.action }
                substitutePlayer={ this.substitutePlayer }
                setlistPosition={ this.setlistPosition }
              />
            </Col>
            { this.tradePlayersTable() }
          </Row>
          <Row className='clearfix'>
            <Col sm={12}>
              { this.sortWaiverPicks() }
            </Col>
          </Row>
        </div>
      )
    }
  }
}

function mapStateToProps (state) {
  return {
    league: state.FplTeamReducer.league,
    fpl_team: state.FplTeamReducer.fpl_team,
    current_user: state.FplTeamReducer.current_user,
    picked_players: state.FplTeamReducer.picked_players,
    unpicked_players: state.FplTeamListsReducer.unpicked_players,
    fpl_team_list: state.FplTeamListsReducer.fpl_team_list,
    fpl_team_lists: state.FplTeamListsReducer.fpl_team_lists,
    line_up: state.FplTeamListsReducer.line_up,
    status: state.FplTeamListsReducer.status,
    waiver_picks: state.WaiverPicksReducer.waiver_picks || state.FplTeamReducer.waiver_picks,
    positions: state.FplTeamReducer.positions,
    round: state.FplTeamListsReducer.round,
    rounds: state.FplTeamListsReducer.rounds,
    teams: state.TeamsReducer,
    success: state.FplTeamListsReducer.success || state.TradePlayersReducer.success || state.WaiverPicksReducer.success,
    errors: state.FplTeamListsReducer.errors || state.TradePlayersReducer.errors || state.WaiverPicksReducer.errors
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam,
    fetchTeams: fetchTeams,
    fetchFplTeamLists: fetchFplTeamLists,
    updateFplTeamList: updateFplTeamList,
    tradePlayers: tradePlayers,
    createWaiverPick: createWaiverPick,
    fetchWaiverPicks: fetchWaiverPicks,
    updateWaiverPickOrder: updateWaiverPickOrder,
    deleteWaiverPick: deleteWaiverPick
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(FplTeam);