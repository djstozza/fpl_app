import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchPlayer from '../actions/action_fetch_player.js';
import fetchTeam from '../actions/action_fetch_team.js';
import PlayerFixtureHistoriesTable from '../components/players/player_fixture_histories_table.js';

class Player extends Component {
  constructor(props) {
    super(props)
  }

  componentWillMount () {
    this.props.fetchPlayer(this.props.match.params.id);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      player: nextProps.player,
      team: nextProps.team,
      team_fixtures: nextProps.team_fixtures
    })
  }

  render () {
    const playerImgSrc = 'https://platform-static-files.s3.amazonaws.com/premierleague/photos/players/110x140/p'

    if (this.state == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          <h2>{this.state.player.first_name} {this.state.player.last_name} - {this.state.team.name}</h2>
          <img src={`${playerImgSrc}${this.state.player.code}.png`}/>
          <PlayerFixtureHistoriesTable player_fixture_histories={ this.state.player.player_fixture_histories } />
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    player: state.player_data.player,
    team: state.player_data.team,
    team_fixtures: state.player_data.team_fixtures
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchPlayer: fetchPlayer
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Player);
