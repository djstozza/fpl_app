import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Panel, Accordion } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import fetchRounds from '../actions/action_fetch_rounds.js';
import fetchPlayer from '../actions/action_fetch_player.js';
import fetchTeam from '../actions/action_fetch_team.js';
import PlayerDetails from '../components/players/player_details.js';
import FixtureHistoriesTable from '../components/players/fixture_histories_table.js';
import PastHistoriesTable from '../components/players/past_histories_table.js';

class Player extends Component {
  constructor(props) {
    super(props)
    this.playerPastHistories = this.playerPastHistories.bind(this);
  }

  componentWillMount () {
    this.props.fetchRounds();
    this.props.fetchPlayer(this.props.match.params.id);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      player: nextProps.player,
      team: nextProps.team,
      team_fixtures: nextProps.team_fixtures,
      position: nextProps.position,
      rounds: nextProps.rounds
    })
  }

  playerPastHistories () {
    if (this.state.player.player_past_histories.length > 0) {
      return (
        <Panel header='Past Seasons' bsStyle='primary' panelRole='tab' eventKey='2'>
          <PastHistoriesTable player_past_histories={ this.state.player.player_past_histories } />
        </Panel>
      )
    }
  }

  render () {
    if (this.state == null || this.state.player == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          <PlayerDetails
            player={ this.state.player }
            rounds={ this.state.rounds }
            team={ this.state.team }
            player_fixture_histories={ this.state.player_fixture_histories }
            position={ this.state.position } />
          <Accordion>
            <Panel header='Season' bsStyle='primary' panelRole='tab' eventKey='1'>
              <FixtureHistoriesTable player_fixture_histories={ this.state.player.player_fixture_histories } />
            </Panel>
            { this.playerPastHistories() }
          </Accordion>
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    player: state.player_data.player,
    team: state.player_data.team,
    team_fixtures: state.player_data.team_fixtures,
    position: state.player_data.position,
    rounds: state.rounds_data.rounds
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchPlayer: fetchPlayer,
    fetchRounds: fetchRounds
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Player);
