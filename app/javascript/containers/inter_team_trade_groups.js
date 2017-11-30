import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import fetchFplTeam from '../actions/fpl_teams/action_fetch_fpl_team.js';
import fetchFplTeamLists from '../actions/fpl_team_lists/action_fetch_fpl_team_lists.js';
import fetchInterTeamTradeGroups from '../actions/inter_team_trade_groups/action_index.js';
import submitInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_submit.js';
import createInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_create.js';
import addToInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_add.js';
import deleteInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_delete.js';
import removeInterTeamTrade from '../actions/inter_team_trade_groups/action_remove.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import OutTradeGroups from '../components/inter_team_trades/out_trade_groups.js';
import OutTradesTable from '../components/inter_team_trades/out_trades_table.js';
import InTradesTable from '../components/inter_team_trades/in_trades_table.js';


class InterTeamTradeGroups extends Component {
  constructor (props) {
    super(props);

    this.state = {
      fplTeamId: this.props.match.params.fpl_team_id,
      fplTeamListId: this.props.match.params.fpl_team_list_id,
      clearSelection: false
    }

    this.toggleNewTradeGroup = this.toggleNewTradeGroup.bind(this);
    this.newTradeGroupPlayerList = this.newTradeGroupPlayerList.bind(this);
    this.setOutPlayer = this.setOutPlayer.bind(this);
    this.createTradeGroupAction = this.createTradeGroupAction.bind(this);
    this.addToTradeGroupAction = this.addToTradeGroupAction.bind(this);
    this.createTradeGroupAction = this.createTradeGroupAction.bind(this);
    this.submitTradeGroupAction = this.submitTradeGroupAction.bind(this);
    this.deleteTradeGroupAction = this.deleteTradeGroupAction.bind(this);
    this.removeTradeAction = this.removeTradeAction.bind(this);
  }

  toggleNewTradeGroup () {
    const element = document.getElementById('new-trade-group');
    if (element.classList.contains('hidden')) {
      element.classList.remove('hidden');
      this.setState({
        out_player: null,
        clearSelection: false
      });
    } else {
      element.classList.add('hidden');
      this.setState({
        out_player: null,
        clearSelection: true
      });
    }
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.state.fplTeamId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
    this.props.fetchInterTeamTradeGroups(this.state.fplTeamId, this.state.fplTeamListId);
    this.props.fetchTeams();
  }

  createTradeGroupAction (in_player) {
    this.props.createInterTeamTradeGroup(
      this.state.fplTeamId,
      this.state.fplTeamListId,
      in_player.in_fpl_team_list_id,
      this.state.out_player.out_player_id,
      in_player.in_player_id
    );
    this.setState({
      out_player: null,
      clearSelection: true
    });
    const element = document.getElementById('new-trade-group');
    element.classList.add('hidden');
  }

  addToTradeGroupAction (tradeGroup, out_player, in_player) {
    this.props.addToInterTeamTradeGroup(
      this.state.fplTeamId,
      this.state.fplTeamListId,
      tradeGroup.id,
      out_player.out_player_id,
      in_player.in_player_id
    );
  }

  submitTradeGroupAction (tradeGroup) {
    this.props.submitInterTeamTradeGroup(this.state.fplTeamId, this.state.fplTeamListId, tradeGroup.id);
  }

  deleteTradeGroupAction (tradeGroup) {
    this.props.deleteInterTeamTradeGroup(this.state.fplTeamId, this.state.fplTeamListId, tradeGroup.id);
  }

  removeTradeAction (tradeGroup, tradeId) {
    this.props.removeInterTeamTrade(this.state.fplTeamId, this.state.fplTeamListId, tradeGroup.id, tradeId);
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      fpl_teams: nextProps.fpl_teams,
      current_user: nextProps.current_user,
      picked_players: nextProps.picked_players,
      fpl_team_list: nextProps.fpl_team_list,
      fpl_team_lists: nextProps.fpl_team_lists,
      out_players_tradeable: nextProps.out_players_tradeable,
      in_players_tradeable: nextProps.in_players_tradeable,
      status: nextProps.status,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams,
      out_trade_groups: nextProps.out_trade_groups,
      in_trade_groups: nextProps.in_trade_groups
    });
  }

  newTradeGroupPlayerList (tradeGroup) {
    return (
      <div id='new-trade-group' className='hidden'>
        <Row className='clearfix'>
          <Col xs={5}>
            <OutTradesTable
              clearSelection={ this.state.clearSelection }
              out_players_tradeable={ this.state.out_players_tradeable }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              status={ this.state.status }
              setOutPlayer={ this.setOutPlayer }
            />
          </Col>
          <Col xs={7}>
            <InTradesTable
              in_players_tradeable={ this.state.in_players_tradeable }
              teams={ this.state.teams }
              fpl_teams={ this.state.fpl_teams }
              positions={ this.state.positions }
              out_player={ this.state.out_player }
              status={ this.state.status }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              completeTradeAction={ this.createTradeGroupAction }
            />
          </Col>
        </Row>
      </div>
    );
  }

  setOutPlayer (outPlayer) {
    this.setState({ out_player: outPlayer });
  }

  render () {
    if (
      this.state == null ||
      this.state.fpl_team == null ||
      this.state.fpl_team_list == null ||
      this.state.out_trade_groups == null
    ) {
      return (<p>Loading...</p>);
    } else {
      return (
        <div>
          { this.newTradeGroupPlayerList() }
          <Button bsStyle='primary' onClick={ () => this.toggleNewTradeGroup() }>Create A New Trade</Button>
          <hr/>
          <OutTradeGroups
            out_trade_groups={ this.state.out_trade_groups }
            fpl_team={ this.state.fpl_team }
            fpl_teams={ this.state.fpl_teams }
            current_user={ this.state.current_user }
            status={ this.state.status }
            teams={ this.state.teams }
            positions={ this.state.positions }
            completeTradeAction={ this.addToTradeGroupAction }
            submitTradeGroupAction={ this.submitTradeGroupAction }
            deleteTradeGroupAction={ this.deleteTradeGroupAction }
            removeTradeAction={ this.removeTradeAction }
          />
        </div>
      );
    }
  }
}

function mapStateToProps (state) {
  return {
    league: state.FplTeamReducer.league,
    fpl_team: state.FplTeamReducer.fpl_team,
    fpl_teams: state.FplTeamReducer.fpl_teams,
    current_user: state.FplTeamReducer.current_user,
    fpl_team_list: state.FplTeamListsReducer.fpl_team_list,
    fpl_team_lists: state.FplTeamListsReducer.fpl_team_lists,
    status: state.FplTeamListsReducer.status,
    positions: state.FplTeamReducer.positions,
    round: state.FplTeamListsReducer.round,
    rounds: state.FplTeamListsReducer.rounds,
    teams: state.TeamsReducer,
    out_trade_groups: state.InterTeamTradeGroupsReducer.out_trade_groups,
    in_trade_groups: state.InterTeamTradeGroupsReducer.in_trade_groups,
    out_players_tradeable: state.InterTeamTradeGroupsReducer.out_players_tradeable,
    in_players_tradeable: state.InterTeamTradeGroupsReducer.in_players_tradeable,
    success: state.InterTeamTradeGroupsReducer.success,
    errors: state.InterTeamTradeGroupsReducer.errors
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam,
    fetchFplTeamLists: fetchFplTeamLists,
    fetchTeams: fetchTeams,
    createInterTeamTradeGroup: createInterTeamTradeGroup,
    fetchInterTeamTradeGroups: fetchInterTeamTradeGroups,
    addToInterTeamTradeGroup: addToInterTeamTradeGroup,
    submitInterTeamTradeGroup: submitInterTeamTradeGroup,
    deleteInterTeamTradeGroup: deleteInterTeamTradeGroup,
    removeInterTeamTrade: removeInterTeamTrade
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(InterTeamTradeGroups);
