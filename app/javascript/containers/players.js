import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchPlayers from '../actions/action_fetch_players.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import PlayerTable from '../components/players/player_table.js';

class Players extends Component {
  constructor(props) {
    super(props)
  }

  componentWillMount () {
    this.props.fetchTeams();
    this.props.fetchPlayers();
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      players: nextProps.players,
      teams: nextProps.teams
    })
  }

  render () {
    if (this.state == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          <PlayerTable players={this.state.players} teams={this.state.teams} />
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    players: state.players,
    teams: state.teams
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchPlayers: fetchPlayers,
    fetchTeams: fetchTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Players);
