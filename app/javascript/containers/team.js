import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchTeams from '../actions/action_fetch_teams.js'
import fetchTeam from '../actions/action_fetch_team.js'
import axios from 'axios';
import TeamLadder from '../components/teams/team_ladder.js';
import TeamFixtures from '../components/teams/team_fixtures.js';

class Team extends Component {
  constructor(props) {
    super(props)
  }

  dataSource (teamId) {
    this.props.fetchTeam(teamId);
  }

  componentDidMount () {
    this.props.fetchTeams();
    this.props.fetchTeam(this.props.match.params.id);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      teams: nextProps.teams,
      team: nextProps.team,
      team_fixtures: nextProps.team_fixtures
    })
  }

  render () {
    if (this.state == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div className='container'>
          <h2>{this.state.team.name}</h2>
          <TeamFixtures team_fixtures={this.state.team_fixtures} onChange={this.dataSource}/>
          <TeamLadder teams={this.state.teams} onChange={this.dataSource}/>
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    teams: state.teams,
    team: state.team_data.team,
    team_fixtures: state.team_data.fixtures
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchTeams: fetchTeams,
    fetchTeam: fetchTeam
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Team);
