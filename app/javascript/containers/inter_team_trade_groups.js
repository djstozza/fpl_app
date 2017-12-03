import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import Alert from 'react-s-alert';

import fetchFplTeam from '../actions/fpl_teams/action_fetch_fpl_team.js';
import fetchInterTeamTradeGroups from '../actions/inter_team_trade_groups/action_index.js';
import submitInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_submit.js';
import createInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_create.js';
import addToInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_add.js';
import deleteInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_delete.js';
import removeInterTeamTrade from '../actions/inter_team_trade_groups/action_remove.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import approveInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_approve.js';
import declineInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_decline.js';

import NewTradeGroup from '../components/inter_team_trades/new_trade_group.js';
import OutTradeGroups from '../components/inter_team_trades/out_trade_groups.js';
import InTradeGroups from '../components/inter_team_trades/in_trade_groups.js';


class InterTeamTradeGroups extends Component {
  constructor (props) {
    super(props);

    this.state = {
      fplTeamId: this.props.match.params.fpl_team_id
    }

    this.createTradeGroupAction = this.createTradeGroupAction.bind(this);
    this.addToTradeGroupAction = this.addToTradeGroupAction.bind(this);
    this.createTradeGroupAction = this.createTradeGroupAction.bind(this);
    this.submitTradeGroupAction = this.submitTradeGroupAction.bind(this);
    this.deleteTradeGroupAction = this.deleteTradeGroupAction.bind(this);
    this.approveTradeGroupAction = this.approveTradeGroupAction.bind(this);
    this.declineTradeGroupAction = this.declineTradeGroupAction.bind(this);
    this.removeTradeAction = this.removeTradeAction.bind(this);
    this.outTradeGroupSection = this.outTradeGroupSection.bind(this);
    this.inTradeGroupSection = this.inTradeGroupSection.bind(this);
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.state.fplTeamId);
    this.props.fetchInterTeamTradeGroups(this.state.fplTeamId);
    this.props.fetchTeams();
  }

  createTradeGroupAction (out_player, in_player) {
    this.props.createInterTeamTradeGroup(
      this.state.fplTeamId,
      out_player.out_player_id,
      in_player.in_fpl_team_list_id,
      in_player.in_player_id
    );
  }

  addToTradeGroupAction (tradeGroup, out_player, in_player) {
    this.props.addToInterTeamTradeGroup(
      this.state.fplTeamId,
      tradeGroup.id,
      out_player.out_player_id,
      in_player.in_player_id
    );
  }

  submitTradeGroupAction (tradeGroup) {
    this.props.submitInterTeamTradeGroup(this.state.fplTeamId, tradeGroup.id);
  }

  deleteTradeGroupAction (tradeGroup) {
    this.props.deleteInterTeamTradeGroup(this.state.fplTeamId, tradeGroup.id);
  }

  removeTradeAction (tradeGroup, tradeId) {
    this.props.removeInterTeamTrade(this.state.fplTeamId, tradeGroup.id, tradeId);
  }

  approveTradeGroupAction (tradeGroup) {
    this.props.approveInterTeamTradeGroup(this.state.fplTeamId, tradeGroup.id);
  }

  declineTradeGroupAction (tradeGroup) {
    this.props.declineInterTeamTradeGroup(this.state.fplTeamId, tradeGroup.id);
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

  outTradeGroupSection () {
    if (this.state.out_trade_groups.length > 0) {
      return [
        <OutTradeGroups
          key='out-trade-group'
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
        />,
        <hr key='out-trade-group-hr'/>
      ];
    }
  }

  inTradeGroupSection () {
    if (this.state.in_trade_groups.length > 0) {
      return (
        <InTradeGroups
          in_trade_groups={ this.state.in_trade_groups }
          fpl_team={ this.state.fpl_team }
          fpl_teams={ this.state.fpl_teams }
          current_user={ this.state.current_user }
          status={ this.state.status }
          teams={ this.state.teams }
          positions={ this.state.positions }
          approveTradeGroupAction={ this.approveTradeGroupAction }
          declineTradeGroupAction={ this.declineTradeGroupAction }
        />
      );
    }
  }

  render () {
    if (this.state == null || this.state.fpl_team == null || this.state.out_trade_groups == null) {
      return (<p>Loading...</p>);
    } else {
      return (
        <div>
          <NewTradeGroup
            out_players_tradeable={ this.state.out_players_tradeable }
            in_players_tradeable={ this.state.in_players_tradeable }
            fpl_team={ this.state.fpl_team }
            fpl_teams={ this.state.fpl_teams }
            current_user={ this.state.current_user }
            status={ this.state.status }
            createTradeGroupAction={ this.createTradeGroupAction }
          />
          <hr/>
          { this.outTradeGroupSection() }
          { this.inTradeGroupSection() }
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
    positions: state.FplTeamReducer.positions,
    teams: state.TeamsReducer,
    status: state.InterTeamTradeGroupsReducer.status,
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
    fetchTeams: fetchTeams,
    createInterTeamTradeGroup: createInterTeamTradeGroup,
    fetchInterTeamTradeGroups: fetchInterTeamTradeGroups,
    addToInterTeamTradeGroup: addToInterTeamTradeGroup,
    submitInterTeamTradeGroup: submitInterTeamTradeGroup,
    deleteInterTeamTradeGroup: deleteInterTeamTradeGroup,
    removeInterTeamTrade: removeInterTeamTrade,
    approveInterTeamTradeGroup: approveInterTeamTradeGroup,
    declineInterTeamTradeGroup: declineInterTeamTradeGroup
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(InterTeamTradeGroups);
