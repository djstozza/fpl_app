import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Button } from 'react-bootstrap';
import fetchLeague from '../actions/action_fetch_league.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import createMiniDraftPick from '../actions/mini_draft_picks/action_create_mini_draft_pick.js';
import passMiniDraftPick from '../actions/mini_draft_picks/action_pass_mini_draft_pick.js';
import fetchMiniDraftPicks from '../actions/mini_draft_picks/action_fetch_mini_draft_picks.js';
import TradePlayersTable from '../components/fpl_teams/trade_players_table.js';
import TeamListTable from '../components/fpl_teams/team_list_table.js';
import MiniDraftPicksTable from '../components/leagues/mini_draft_picks_table.js';
import Alert from 'react-s-alert';
var cable = ActionCable.createConsumer()

class MiniDraftPicks extends Component {
  constructor(props) {
    super(props);

    this.setlistPosition = this.setlistPosition.bind(this);
    this.miniDraftOut = this.miniDraftOut.bind(this);
    this.passButton = this.passButton.bind(this);
    this.pass = this.pass.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);

    this.state = {
      action: 'miniDraft',
      leagueId: this.props.match.params.id
    }
  }

  componentWillMount () {
    this.props.fetchMiniDraftPicks(this.state.leagueId);
    this.props.fetchLeague(this.state.leagueId);
    this.props.fetchTeams();
  }

  componentDidMount () {
    let self = this;
    cable.subscriptions.create({ channel: 'MiniDraftPickChannel', room: `league ${this.props.match.params.id}` }, {
      received: function (data) {
        self.setState({
          draft_picks: data.draft_picks,
          unpicked_players: data.unpicked_players,
          current_draft_pick: data.current_draft_pick
        });

        self.showDraftPickInfo(data.info);
        self.yourTurn(data.current_draft_pick.fpl_team_id, self.state.fpl_team);
      }
    });
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      fpl_teams: nextProps.fpl_teams,
      fpl_team_list: nextProps.fpl_team_list,
      current_user: nextProps.current_user,
      draft_picks: nextProps.draft_picks,
      unpicked_players: nextProps.unpicked_players,
      picked_players: nextProps.picked_players,
      fpl_team_list: nextProps.fpl_team_list,
      fpl_team_lists: nextProps.fpl_team_lists,
      current_draft_pick: nextProps.current_draft_pick,
      status: nextProps.status,
      line_up: nextProps.line_up,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams,
      success: nextProps.success,
      errors: nextProps.errors
    });

    if (this.props.success != nextProps.success) {
      this.successMessage(nextProps.success);
    }
    if (this.props.errors != nextProps.errors) {
      this.errorMessages(nextProps.errors);
    }
  }

  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state || nextProps !== this.props;
  }

  yourTurn (curren_pick_fpl_team_id, fpl_team) {
    if (curren_pick_fpl_team_id == fpl_team.id) {
      return (
        Alert.info("It's your turn to pick a player", {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        })
      );
    }
  }

  successMessage (success) {
    return (
      Alert.success(success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      })
    );
  }

  errorMessages (errors) {
    errors.map( (error) => {
      return (
        Alert.error(error, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        })
      );
    });
  }

  showDraftPickInfo (info) {
    return (
      Alert.info(info, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      })
    );
  }

  setlistPosition (listPosition) {
    this.setState({ listPosition: listPosition });
  }

  completeTradeAction (playerId) {
    this.props.createMiniDraftPick(
      this.state.leagueId,
      this.state.fpl_team_list.id,
      this.state.listPosition.id,
      playerId
    );
  }

  pass () {
    this.props.passMiniDraftPick(this.state.leagueId, this.state.fpl_team_list.id);
  }

  passButton () {
    if (this.state.current_draft_pick.fpl_team_id == this.state.fpl_team.id) {
      return (
        <div>
          <h2>{ this.state.league.name } Mini Draft</h2>
          <Button bsSize='large' bsStyle='danger' onClick={ () => this.pass() }>Pass</Button>
          <h4> - or - </h4>
        </div>
      );
    }
  }

  miniDraftOut () {
    if (this.state.current_draft_pick.fpl_team_id == this.state.fpl_team.id) {
      return (
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
      );
    }
  }

  render () {
    if (this.state == null || this.state.league == null || this.state.draft_picks == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          { this.passButton() }
          { this.miniDraftOut() }
          <br/>
          <TradePlayersTable
            unpicked_players={ this.state.unpicked_players }
            teams={ this.state.teams }
            positions={ this.state.positions }
            current_user={ this.state.current_user }
            current_draft_pick={ this.state.current_draft_pick }
            fpl_team={ this.state.fpl_team }
            round={ this.state.round }
            status={ this.state.status }
            action={ this.state.action }
            listPosition={ this.state.listPosition }
            completeTradeAction={ this.completeTradeAction }
          />
          <h3>Completed Mini Draft Picks</h3>
          <MiniDraftPicksTable
            draft_picks={ this.state.draft_picks }
            fpl_teams={ this.state.fpl_teams }
            positions={ this.state.positions }
            teams={ this.state.teams }
          />
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
    current_user: state.MiniDraftPicksReducer.current_user,
    draft_picks: state.MiniDraftPicksReducer.draft_picks,
    fpl_team: state.MiniDraftPicksReducer.fpl_team,
    fpl_team_list: state.MiniDraftPicksReducer.fpl_team_list,
    line_up: state.MiniDraftPicksReducer.line_up,
    current_draft_pick: state.MiniDraftPicksReducer.current_draft_pick,
    round: state.MiniDraftPicksReducer.round,
    status: state.MiniDraftPicksReducer.status,
    unpicked_players: state.MiniDraftPicksReducer.unpicked_players,
    teams: state.TeamsReducer,
    positions: state.MiniDraftPicksReducer.positions,
    errors: state.MiniDraftPicksReducer.errors,
    success: state.MiniDraftPicksReducer.success
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchLeague: fetchLeague,
    fetchMiniDraftPicks: fetchMiniDraftPicks,
    createMiniDraftPick: createMiniDraftPick,
    passMiniDraftPick: passMiniDraftPick,
    fetchTeams: fetchTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(MiniDraftPicks);
