import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import fetchFplTeam from '../actions/action_fetch_fpl_team.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import RoundsNav from '../components/rounds/rounds_nav.js';
import TeamListTable from '../components/fpl_teams/team_list_table.js';
import TradePlayersTable from '../components/fpl_teams/trade_players_table.js';
import Alert from 'react-s-alert';
import _ from 'underscore';


class FplTeam extends Component {
  constructor(props) {
    super(props)
    this.showButtons = this.showButtons.bind(this);
    this.substitutePlayer = this.substitutePlayer.bind(this);
    this.setlistPosition = this.setlistPosition.bind(this);
    this.completeTrade = this.completeTrade.bind(this);
    this.dataSource = this.dataSource.bind(this);
    this.state = {
      action: 'selectLineUp'
    }
  }

  dataSource (roundId) {
    let fplTeamList = _.find(this.state.fpl_team_lists, (obj) => {
      return obj.round_id == roundId
    })

    axios.get(`/fpl_team_lists/${fplTeamList.id}.json`).then((res) => {
      this.setState({
        line_up: res.data.line_up
      })
    })
  }

  substitutePlayer (playerId, targetId) {
    axios({
      method: 'put',
      url: `/fpl_team_lists/${this.state.fpl_team_list.id}.json`,
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

  completeTrade (targetId) {
    axios({
      method: 'post',
      url: `/fpl_teams/${this.props.match.params.id}/trades.json`,
      data: {
        list_position_id: this.state.listPosition.id,
        target_id: targetId
      }
    }).then(res => {
      this.setState({
        line_up: res.data.line_up,
        unpicked_players: res.data.unpicked_players,
        picked_players: res.data.picked_players,
        players: res.data.players
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

  setlistPosition (listPosition) {
    this.setState({
      listPosition: listPosition
    });
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.props.match.params.id);
    this.props.fetchTeams();
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      current_user: nextProps.current_user,
      unpicked_players: nextProps.unpicked_players,
      picked_players: nextProps.picked_players,
      fpl_team_list: nextProps.fpl_team_list,
      fpl_team_lists: nextProps.fpl_team_lists,
      line_up: nextProps.line_up,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams
    })
  }

  setAction (action) {
    this.setState({
      action: action
    })
  }

  setTeamTableCol () {
    switch (this.state.action) {
      case 'selectLineUp':
        return 12;
      case 'tradePlayers':
        return 6;
      default: 12
    }
  }

  tradePlayers () {
    switch (this.state.action) {
      case 'tradePlayers':
        return (
          <Col sm={6}>
            <TradePlayersTable
              unpicked_players={ this.state.unpicked_players }
              teams={ this.state.teams }
              positions={ this.state.positions }
              current_user={ this.state.current_user }
              fpl_team={ this.state.fpl_team }
              round={ this.state.round }
              action={ this.state.action }
              listPosition={ this.state.listPosition }
              completeTrade={ this.completeTrade }
            />
          </Col>
        )
    }
  }

  showButtons () {
    if (this.state.fpl_team.user_id != this.state.current_user.id) {
      return;
    }
    return (
      <div>
      <Button onClick={ () => this.setAction('selectLineUp') }>Select starting line up</Button>
      <Button onClick={ () => this.setAction('tradePlayers') }>Trade Players</Button>
      </div>
    )
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

          <RoundsNav rounds={ this.state.rounds } round={ this.state.round }  onChange={ this.dataSource } />
          { this.showButtons() }
          <Row clasName='clearfix'>
            <Col sm={ this.setTeamTableCol() } >
              <TeamListTable
                fpl_team={ this.state.fpl_team }
                current_user={ this.state.current_user }
                line_up={ this.state.line_up }
                positions={ this.state.positions }
                teams={ this.state.teams }
                round={ this.state.round }
                action={ this.state.action }
                substitutePlayer={ this.substitutePlayer }
                setlistPosition={ this.setlistPosition }
              />
            </Col>
            { this.tradePlayers() }
          </Row>
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
    picked_players: state.FplTeamReducer.picked_players,
    unpicked_players: state.FplTeamReducer.unpicked_players,
    fpl_team_list: state.FplTeamReducer.fpl_team_list,
    fpl_team_lists: state.FplTeamReducer.fpl_team_lists,
    line_up: state.FplTeamReducer.line_up,
    positions: state.FplTeamReducer.positions,
    round: state.FplTeamReducer.round,
    rounds: state.FplTeamReducer.rounds,
    teams: state.TeamsReducer
  }
}
function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam,
    fetchTeams: fetchTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(FplTeam);
