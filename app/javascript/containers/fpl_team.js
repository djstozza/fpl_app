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
import WaiverPicksTable from '../components/fpl_teams/waiver_picks_table.js';
import Alert from 'react-s-alert';
import _ from 'underscore';


class FplTeam extends Component {
  constructor(props) {
    super(props)
    this.showButtons = this.showButtons.bind(this);
    this.substitutePlayer = this.substitutePlayer.bind(this);
    this.setlistPosition = this.setlistPosition.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
    this.dataSource = this.dataSource.bind(this);
    this.tradePlayers = this.tradePlayers.bind(this);
    this.sortWaiverPicks = this.sortWaiverPicks.bind(this);
    this.waiverPicks = this.waiverPicks.bind(this);
    this.updateWaiverPickOrder = this.updateWaiverPickOrder.bind(this);
    this.deleteWaiverPick = this.deleteWaiverPick.bind(this);
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
        line_up: res.data.line_up,
        editable: res.data.editable
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

      Alert.success(res.data.success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });

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

  tradePlayers (targetId) {
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

      Alert.success(res.data.success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });

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

  waiverPicks (targetId) {
    axios({
      method: 'post',
      url: `/fpl_teams/${this.props.match.params.id}/waiver_picks.json`,
      data: {
        list_position_id: this.state.listPosition.id,
        target_id: targetId
      }
    }).then(res => {
      this.setState({
        waiver_picks: res.data.waiver_picks
      });

      Alert.success(res.data.success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });

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

  completeTradeAction (targetId) {
    switch (this.state.action) {
      case 'tradePlayers':
        return this.tradePlayers(targetId);
      case 'waiverPicks':
        return this.waiverPicks(targetId);
    }
  }

  updateWaiverPickOrder (waiverPickId, newPickNumber) {
    axios({
      method: 'put',
      url: `/fpl_teams/${this.props.match.params.id}/waiver_picks/${waiverPickId}.json`,
      data: {
        new_pick_number: newPickNumber
      }
    }).then(res => {
      this.setState({
        waiver_picks: res.data.waiver_picks
      });

      Alert.success(res.data.success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });

    }).catch(error => {
      error.response.data.map((error) => {
        Alert.error(error, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        });
      })
    });
  }

  deleteWaiverPick (waiverPickId) {
    axios({
      method: 'delete',
      url: `/fpl_teams/${this.props.match.params.id}/waiver_picks/${waiverPickId}.json`
    }).then(res => {
      this.setState({
        waiver_picks: res.data.waiver_picks
      });

      Alert.success(res.data.success, {
        position: 'top',
        effect: 'bouncyflip',
        timeout: 5000
      });

    }).catch(error => {
      error.response.data.map((error) => {
        Alert.error(error, {
          position: 'top',
          effect: 'bouncyflip',
          timeout: 5000
        });
      })
    });
  }

  sortWaiverPicks () {
    if (this.state.waiver_picks.length == 0 || this.state.fpl_team.user_id != this.state.current_user.id) {
      return;
    }

    return (
      <WaiverPicksTable
        waiver_picks={ this.state.waiver_picks }
        editable={ this.state.editable }
        line_up={ this.state.line_up }
        positions={ this.state.positions }
        teams={ this.state.teams }
        fpl_team={ this.state.fpl_team }
        updateWaiverPickOrder={ this.updateWaiverPickOrder }
        deleteWaiverPick={ this.deleteWaiverPick }
      />
    )
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
      editable: nextProps.editable,
      waiver_picks: nextProps.waiver_picks,
      line_up: nextProps.line_up,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams
    });
  }

  setAction (action) {
    this.setState({
      action: action
    })
  }

  setTeamTableCol () {
    if (this.state.action == 'selectLineUp') {
      return 12;
    } else if (this.state.action == 'tradePlayers' || this.state.action == 'waiverPicks') {
      return 6;
    }
  }

  tradePlayers () {
    if (this.state.action == 'tradePlayers' || this.state.action == 'waiverPicks') {
      return (
        <Col sm={6}>
          <TradePlayersTable
            unpicked_players={ this.state.unpicked_players }
            teams={ this.state.teams }
            positions={ this.state.positions }
            current_user={ this.state.current_user }
            fpl_team={ this.state.fpl_team }
            round={ this.state.round }
            editable={ this.state.editable }
            action={ this.state.action }
            listPosition={ this.state.listPosition }
            completeTradeAction={ this.completeTradeAction }
          />
        </Col>
      )
    }
  }

  showButtons () {
    if (!this.state.editable) {
      return;
    }
    if (this.state.line_up == '') {
      return;
    }
    if (this.state.fpl_team.user_id != this.state.current_user.id) {
      return;
    }
    return (
      <div>
        <Button onClick={ () => this.setAction('selectLineUp') }>Select starting line up</Button>
        <Button onClick={ () => this.setAction('tradePlayers') }>Trade Players</Button>
        <Button onClick={ () => this.setAction('waiverPicks') }>Trade Players (Waiver)</Button>
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

          <RoundsNav rounds={ this.state.rounds } round={ this.state.round } onChange={ this.dataSource } />
          { this.showButtons() }
          <Row className='clearfix'>
            <Col sm={ this.setTeamTableCol() } >
              <TeamListTable
                fpl_team={ this.state.fpl_team }
                current_user={ this.state.current_user }
                line_up={ this.state.line_up }
                positions={ this.state.positions }
                teams={ this.state.teams }
                round={ this.state.round }
                editable={ this.state.editable }
                action={ this.state.action }
                substitutePlayer={ this.substitutePlayer }
                setlistPosition={ this.setlistPosition }
              />
            </Col>
            { this.tradePlayers() }
          </Row>
          <Row className='clearfix'>
            <Col sm={12}>
              { this.sortWaiverPicks() }
            </Col>
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
    editable: state.FplTeamReducer.editable,
    waiver_picks: state.FplTeamReducer.waiver_picks,
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
