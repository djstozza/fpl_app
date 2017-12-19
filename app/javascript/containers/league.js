import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Panel, Accordion, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import axios from 'axios';

import fetchLeague from '../actions/action_fetch_league.js';
import fetchDraftPicks from '../actions/action_fetch_draft_picks.js';
import createDraftPicks from '../actions/action_create_draft_picks.js';
import fetchCurrentRound from '../actions/action_fetch_current_round.js';

import FplTeamsTable from '../components/leagues/fpl_teams_table.js';
import TeamListsTable from '../components/leagues/team_lists_table.js';
import RoundCountdown from '../components/rounds/round_countdown.js';

class League extends Component {
  constructor(props) {
    super(props)
    this.state = {
      disabled: false
    }

    this.props.fetchCurrentRound();
    this.createDraftPicksButton = this.createDraftPicksButton.bind(this);
    this.createDraftPicks = this.createDraftPicks.bind(this);
    this.roundCountdown = this.roundCountdown.bind(this);
  }

  componentWillMount () {
    const leagueId = this.props.match.params.id
    this.props.fetchLeague(leagueId);
    this.props.fetchDraftPicks(leagueId);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_teams: nextProps.fpl_teams,
      users: nextProps.users,
      commissioner: nextProps.commissioner,
      current_user: nextProps.current_user,
      draft_picks: nextProps.draft_picks,
      fpl_team_list_arr: nextProps.fpl_team_list_arr,
      fpl_team: nextProps.fpl_team,
      current_round: nextProps.current_round,
      current_round_deadline: nextProps.current_round_deadline,
      current_round_status: nextProps.current_round_status
    })
  }

  createDraftPicksButton () {
    if (this.state.draft_picks.length == 0)  {
      if (this.state.current_user.id == this.state.commissioner.id) {
        return (
          <Button disabled={ this.state.disabled } onClick={ () => this.createDraftPicks() }>Create draft</Button>
        )
      }
    } else {
      return (
        <Button href={ `/leagues/${this.props.match.params.id}/draft_picks` }>Go to draft</Button>
      )
    }
  }

  createDraftPicks () {
    const leagueId = this.props.match.params.id
    this.setState({
      disabled: true
    })
    this.props.createDraftPicks(leagueId)
  }

  roundCountdown () {
    if (this.state.current_round_deadline) {
      return (
        <RoundCountdown
          round={ this.state.current_round }
          current_round_deadline={ this.state.current_round_deadline }
          current_round_status={ this.state.current_round_status }
        />
      );
    }
  }

  render () {
    if (this.state == null || this.state.league == null || this.state.draft_picks == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          { this.roundCountdown() }
          <h2>{ this.state.league.name }</h2>
          <p>Commissioner: { this.state.commissioner.username }</p>
          <FplTeamsTable
            fpl_teams={ this.state.fpl_teams }
            users={ this.state.users }
            draft_picks={ this.state.draft_picks }/>
          { this.createDraftPicksButton() }
          <TeamListsTable fpl_team_list_arr={ this.state.fpl_team_list_arr } />
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
    fpl_team_list_arr: state.LeagueReducer.fpl_team_list_arr,
    commissioner: state.LeagueReducer.commissioner,
    current_user: state.LeagueReducer.current_user,
    draft_picks: state.DraftPicksReducer.draft_picks,
    current_round: state.CurrentRoundReducer.current_round,
    current_round_deadline: state.CurrentRoundReducer.current_round_deadline,
    current_round_status: state.CurrentRoundReducer.current_round_status,
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchLeague: fetchLeague,
    fetchDraftPicks: fetchDraftPicks,
    createDraftPicks: createDraftPicks,
    fetchCurrentRound: fetchCurrentRound
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(League);
