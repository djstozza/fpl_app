import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchTeams from '../actions/action_fetch_teams.js'
import fetchTeam from '../actions/action_fetch_team.js'
import axios from 'axios';
import TeamsNav from '../components/teams/teams_nav.js';
import TeamLadder from '../components/teams/team_ladder.js';
import TeamFixtures from '../components/teams/team_fixtures.js';
import imgSrc from '../../assets/images/badges-sprite.jpeg';

class Team extends Component {
  constructor(props) {
    super(props)
    this.dataSource = this.dataSource.bind(this);
  }

  dataSource (teamId) {
    this.props.fetchTeam(teamId);
    window.history.pushState(null, '', `/teams/${teamId}`)
  }

  componentDidMount () {
    this.props.fetchTeams();
    this.props.fetchTeam(this.props.match.params.id);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      teams: nextProps.teams,
      team: nextProps.team,
      team_fixtures: nextProps.team_fixtures,
      team_players: nextProps.team_players
    })
  }

  render () {
    if (this.state == null || this.state.team == null || this.state.teams == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      console.log(this.state.team_players);
      var team = this.state.team
      var teams = this.state.teams
      return (
        <div>
          <TeamsNav teams={teams} team={team} onChange={this.dataSource} />
          <h2><img src={imgSrc} className={`crest ${team.short_name.toLowerCase()}`}/> {team.name} </h2>
          <div
            id='team-fixture-accordion'
            className='panel-group data-group'
            aria-multiselectable='true'
            role='tablist'>
            <div className='panel'>
              <div id='team-fixture-heading' className='panel-heading' role='tab'>
                <a
                  aria-controls='team-fixture-collapse'
                  aria-expanded='false'
                  data-parent='#team-fixture-heading'
                  data-toggle='collapse'
                  href="#team-fixture-collapse"
                  role='button'>
                  <h4>Fixtures</h4>
                </a>
              </div>
              <div
                id='team-fixture-collapse'
                className='panel-collapse collapse'
                aria-labelledby="team-fixture-heading"
                role='tabpanel'>
                <TeamFixtures team_fixtures={this.state.team_fixtures} onChange={this.dataSource}/>
              </div>
            </div>
          </div>
          <div id='team-ladder-accordion' className='panel-group data-group' aria-multiselectable='true' role='tablist'>
            <div className='panel'>
              <div id='team-ladder-heading' className='panel-heading' role='tab'>
                <a
                  aria-controls='team-ladder-collapse'
                  aria-expanded='false'
                  data-parent='#team-ladder-heading'
                  data-toggle='collapse'
                  href='#team-ladder-collapse'
                  role='button'>
                  <h4>Ladder</h4>
                </a>
              </div>
              <div
                id='team-ladder-collapse'
                className='panel-collapse collapse'
                aria-labelledby='team-ladder-heading'
                role='tabpanel'>
                <TeamLadder teams={teams} team={team} onChange={this.dataSource} />
              </div>
            </div>
          </div>
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    teams: state.teams,
    team: state.team_data.team,
    team_fixtures: state.team_data.fixtures,
    team_players: state.team_data.players
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchTeams: fetchTeams,
    fetchTeam: fetchTeam
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Team);
