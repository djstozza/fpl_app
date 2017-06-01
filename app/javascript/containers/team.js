import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchTeams from '../actions/action_fetch_teams.js'
import fetchTeam from '../actions/action_fetch_team.js'
import axios from 'axios';
import TeamsNav from '../components/teams/teams_nav.js';
import PlayersTable from '../components/players/players_table.js';
import TeamLadder from '../components/teams/team_ladder.js';
import TeamFixtures from '../components/teams/team_fixtures.js';
import imgSrc from '../../assets/images/badges-sprite.jpeg';
import { Panel, Accordion } from 'react-bootstrap';
import _ from 'underscore';

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
      players: nextProps.players
    })
  }

  render () {
    if (this.state == null || this.state.team == null || this.state.teams == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      var team = this.state.team
      var teams = _.sortBy(this.state.teams, function (obj) { return obj.position })

      return (
        <div>
          <TeamsNav teams={teams} team={team} onChange={this.dataSource} />
          <h2><img src={imgSrc} className={`crest ${team.short_name.toLowerCase()}`}/> {team.name} </h2>
          <Accordion>
            <Panel header='Players' bsStyle='primary' panelRole='tab' eventKey='1'>
                <PlayersTable players={this.state.players} />
            </Panel>
            <Panel header='Fixtures' bsStyle='primary' panelRole='tab' eventKey='2'>
                <TeamFixtures team_fixtures={this.state.team_fixtures} onChange={this.dataSource}/>
            </Panel>
            <Panel header='Ladder' bsStyle='primary' panelRole='tab' eventKey='3'>
              <TeamLadder teams={teams} team={team} onChange={this.dataSource} />
            </Panel>
          </Accordion>
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
    players: state.team_data.players
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchTeams: fetchTeams,
    fetchTeam: fetchTeam
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Team);
