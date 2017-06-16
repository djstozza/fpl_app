import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Panel, Accordion, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import fetchLeague from '../actions/action_fetch_league.js';
import fetchDraftPicks from '../actions/action_fetch_draft_picks.js';
import FplTeamsTable from '../components/leagues/fpl_teams_table.js';
import axios from 'axios';

class League extends Component {
  constructor(props) {
    super(props)

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
      draft_picks: nextProps.draft_picks
    })
  }

  createDraftPicksButton () {
    console.log(this.state);
    if (this.state.draft_picks.length == 0) {
      return (
        <Button onClick={ () => this.createDraftPicks() }>Create draft</Button>
      )
    } else {
      return (
        <Button>Start the draft</Button>
      )
    }
  }

  createDraftPicks () {
    const leagueId = this.props.match.params.id
    axios.get(`/leagues/${leagueId}/draft_picks/new.json`).then(res => {
      this.setState({
        draft_picks: res.data
      });
    });
  }

  render () {
    if (this.state == null || this.state.league == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      console.log(this.state);
      return (
        <div>
          <h2>{ this.state.league.name }</h2>
          <p>Commissioner: { this.state.commissioner.username }</p>
          <FplTeamsTable
            fpl_teams={ this.state.fpl_teams }
            users={ this.state.users }
            draft_picks={ this.state.draft_picks }/>
          {this.createDraftPicksButton()}
        </div>
      )
    }
  }
}

function mapStateToProps(state) {
  return {
    league: state.league_data.league,
    fpl_teams: state.league_data.fpl_teams,
    users: state.league_data.users,
    commissioner: state.league_data.commissioner,
    current_user: state.league_data.current_user,
    draft_picks: state.draft_picks
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchLeague: fetchLeague,
    fetchDraftPicks: fetchDraftPicks
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(League);
