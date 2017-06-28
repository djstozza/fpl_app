import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Panel, Accordion, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import fetchLeague from '../actions/action_fetch_league.js';
import fetchDraftPicks from '../actions/action_fetch_draft_picks.js';
import createDraftPicks from '../actions/action_create_draft_picks.js';
import FplTeamsTable from '../components/leagues/fpl_teams_table.js';
import axios from 'axios';

class League extends Component {
  constructor(props) {
    super(props)
    this.state = {
      disabled: false
    }

    this.createDraftPicksButton = this.createDraftPicksButton.bind(this);
    this.createDraftPicks = this.createDraftPicks.bind(this);
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
      fpl_team: nextProps.fpl_team
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

  render () {
    if (this.state == null || this.state.league == null || this.state.draft_picks == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          <h2>{ this.state.league.name }</h2>
          <p>Commissioner: { this.state.commissioner.username }</p>
          <FplTeamsTable
            fpl_teams={ this.state.fpl_teams }
            users={ this.state.users }
            draft_picks={ this.state.draft_picks }/>
          { this.createDraftPicksButton() }
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
    draft_picks: state.DraftPicksReducer.draft_picks
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchLeague: fetchLeague,
    fetchDraftPicks: fetchDraftPicks,
    createDraftPicks: createDraftPicks
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(League);
