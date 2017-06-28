import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchLeague from '../actions/action_fetch_league.js';
import fetchDraftPicks from '../actions/action_fetch_draft_picks.js';
import updateDraftPick from '../actions/action_update_draft_pick.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import DraftPlayersTable from '../components/leagues/draft_players_table.js';
import DraftPicksTable from '../components/leagues/draft_picks_table.js';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import ActionCable from 'actioncable';
import Alert from 'react-s-alert';
var cable = ActionCable.createConsumer()

class DraftPicks extends Component {
  constructor(props) {
    super(props)
    this.draftPlayer = this.draftPlayer.bind(this);
  }

  draftPlayer (playerId) {
    this.props.updateDraftPick(this.props.match.params.id, this.state.current_draft_pick.id, playerId);
  }

  componentWillMount () {
    this.props.fetchDraftPicks(this.props.match.params.id);
    this.props.fetchLeague(this.props.match.params.id);
    this.props.fetchTeams();
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_teams: nextProps.fpl_teams,
      users: nextProps.users,
      commissioner: nextProps.commissioner,
      current_user: nextProps.current_user,
      draft_picks: nextProps.draft_picks,
      current_draft_pick: nextProps.current_draft_pick,
      picked_players: nextProps.picked_players,
      unpicked_players: nextProps.unpicked_players,
      teams: nextProps.teams,
      fpl_team: nextProps.fpl_team,
      positions: nextProps.positions
    })
    this.showAlerts(nextProps);
  }

  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state || nextProps !== this.props;
  }

  componentDidMount () {
    let self = this;
    cable.subscriptions.create({ channel: 'DraftPickChannel', room: `league ${this.props.match.params.id}` }, {
      received: function (data) {
        self.setState({
          draft_picks: data.draft_picks,
          unpicked_players: data.unpicked_players,
          current_draft_pick: data.current_draft_pick,
          picked_players: data.picked_players,
        })
        self.showDraftPickInfo(data.info);
      }
    })
  }

  showAlerts (nextProps) {
    if (nextProps.errors) {
      this.showErrors(nextProps.errors)
    } else if (nextProps.success) {
      this.successfulPick(nextProps.success);
    } else if (nextProps.current_draft_pick && nextProps.fpl_team) {
      this.yourTurn(nextProps.current_draft_pick.fpl_team_id, nextProps.fpl_team.id);
    }
  }

  showErrors (errors) {
    errors.map( (error) => {
      return (
        Alert.error(error, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        })
      )
    })
  }

  successfulPick (success) {
    Alert.success(success, {
      position: 'top',
      effect: 'bouncyflip',
      timeout: 5000
    })
  }

  yourTurn (curren_pick_fpl_team_id, fpl_team_id) {
    if (curren_pick_fpl_team_id == fpl_team_id) {
      return (
        Alert.info("It's your turn to pick a player", {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        })
      )
    }
  }

  showDraftPickInfo (info) {
    return (
      Alert.info(info, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      })
    )
  }

  render () {
    if (this.state == null || this.state.draft_picks == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          <DraftPlayersTable
            players={ this.state.unpicked_players }
            teams={ this.state.teams }
            onChange={ this.draftPlayer }
            fpl_teams={ this.state.fpl_teams }
            positions={ this.state.positions }
            current_draft_pick={ this.state.current_draft_pick }
            fpl_team={ this.state.fpl_team }/>
          <DraftPicksTable
            draft_picks={ this.state.draft_picks }
            players={ this.state.picked_players }
            fpl_teams={ this.state.fpl_teams }
            positions={ this.state.positions }
            teams={ this.state.teams }/>
        </div>
      )
    }
  }
}

function mapStateToProps(state) {
  return {
    league: state.LeagueReducer.league,
    fpl_teams: state.LeagueReducer.fpl_teams,
    users: state.LeagueReducer.users,
    commissioner: state.LeagueReducer.commissioner,
    current_user: state.LeagueReducer.current_user,
    draft_picks: state.DraftPicksReducer.draft_picks,
    fpl_team: state.DraftPicksReducer.fpl_team,
    picked_players: state.DraftPicksReducer.picked_players,
    current_draft_pick: state.DraftPicksReducer.current_draft_pick,
    unpicked_players: state.DraftPicksReducer.unpicked_players,
    teams: state.TeamsReducer,
    positions: state.DraftPicksReducer.positions,
    errors: state.DraftPicksReducer.errors,
    success: state.DraftPicksReducer.success
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchLeague: fetchLeague,
    fetchDraftPicks: fetchDraftPicks,
    fetchTeams: fetchTeams,
    updateDraftPick: updateDraftPick
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(DraftPicks);
