import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchPlayers from '../actions/action_fetch_players.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import fetchPositions from '../actions/action_fetch_positions.js';
import PlayersTable from '../components/players/players_table.js';

class Players extends Component {
  constructor(props) {
    super(props)
  }

  componentWillMount () {
    this.props.fetchPositions();
    this.props.fetchTeams();
    this.props.fetchPlayers();
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      players: nextProps.players,
      teams: nextProps.teams,
      positions: nextProps.positions
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
          <h2>Players</h2>
          <PlayersTable players={this.state.players} teams={this.state.teams} positions={ this.state.positions }/>
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    players: state.PlayersReducer,
    teams: state.TeamsReducer,
    positions: state.PositionsReducer
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchPlayers: fetchPlayers,
    fetchTeams: fetchTeams,
    fetchPositions: fetchPositions
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Players);
