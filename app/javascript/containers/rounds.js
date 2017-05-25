import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchRounds from '../actions/action_fetch_rounds.js';
import fetchTeams from '../actions/action_fetch_teams.js'
import axios from 'axios';
import RoundsNav from '../components/rounds/rounds_nav.js';
import Round from '../components/rounds/round.js';
import TeamLadder from '../components/teams/team_ladder.js';

class Rounds extends Component {
  constructor(props) {
    super(props)
    this.dataSource = this.dataSource.bind(this);
  }

  dataSource (roundId) {
    var roundId = roundId || this.state.round.id;
    axios.get(`/rounds/${roundId}.json`).then(res => {
      this.setState({
        fixtures: res.data.fixtures,
        round: res.data.round
      });
      window.history.pushState(null, '', `/rounds/${roundId}`)
    });
  }

  componentDidMount () {
    if (this.props.match.params.id) {
      this.dataSource(this.props.match.params.id);
    }
    this.props.fetchRounds();
    this.props.fetchTeams();

    setInterval(function () {
      if (this.state.round.is_current && !self.state.round.data_checked) {
        self.dataSource();
      }
    }.bind(this), 60000);
  }

  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state || nextProps !== this.props;
  }

  componentWillReceiveProps(nextProps, nextState) {
    if (this.state != null && this.state.round != null) {
      this.setState({
        rounds: nextProps.rounds,
        teams: nextProps.teams
      })
    } else {
      this.setState({
        rounds: nextProps.rounds,
        round: nextProps.round,
        fixtures: nextProps.fixtures,
        teams: nextProps.teams
      })
    }
  }



  render () {
    if (this.state == null || this.state.rounds == null || this.state.round == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div className='container'>
          <RoundsNav rounds={this.state.rounds} round={this.state.round} onChange={this.dataSource} />
          <Round round={this.state.round} fixtures={this.state.fixtures} />
          <TeamLadder teams={this.state.teams}/>
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    rounds: state.rounds_data.rounds,
    round: state.rounds_data.round,
    fixtures: state.rounds_data.fixtures,
    teams: state.teams
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchRounds: fetchRounds,
    fetchTeams: fetchTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Rounds);
