import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import axios from 'axios';
import fetchFplTeam from '../actions/action_fetch_fpl_team.js';
import TeamListTable from '../components/fpl_teams/team_list_table.js';
import Alert from 'react-s-alert';


class FplTeam extends Component {
  constructor(props) {
    super(props)
    this.updateLineUp = this.updateLineUp.bind(this);
  }

  updateLineUp (playerId, targetId) {
    axios({
      method: 'put',
      url: `/fpl_team_lists/${this.state.team_list.id}.json`,
      data: {
        player_id: playerId,
        target_id: targetId
      }
    }).then(res => {
      this.setState({
        line_up: res.data.line_up
      })
      if (res.data.success) {
        Alert.success(res.data.success, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        });
      }
    }).catch(error => {
      error.response.data.map((error) => {
        Alert.error(error, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        });
      })

    })
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.props.match.params.id);
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      current_user: nextProps.current_user,
      players: nextProps.players,
      team_list: nextProps.team_list,
      line_up: nextProps.line_up,
      positions: nextProps.positions,
      round: nextProps.round
    })
  }

  render () {
    if (this.state == null || this.state.fpl_team == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          <h2>{ this.state.fpl_team.name }</h2>
          <TeamListTable
            fpl_team={ this.state.fpl_team }
            current_user={ this.state.current_user }
            line_up={ this.state.line_up }
            positions={ this.state.positions }
            players={ this.state.players }
            round={ this.state.round }
            onChange={ this.updateLineUp } />
        </div>
      )
    }
  }
}

function mapStateToProps(state) {
  return {
    league: state.FplTeamReducer.league,
    fpl_team: state.FplTeamReducer.fpl_team,
    current_user: state.FplTeamReducer.current_user,
    players: state.FplTeamReducer.players,
    team_list: state.FplTeamReducer.fpl_team_list,
    line_up: state.FplTeamReducer.line_up,
    positions: state.FplTeamReducer.positions,
    round: state.FplTeamReducer.round
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(FplTeam);
