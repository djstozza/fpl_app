import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import fetchRounds from '../actions/action_fetch_rounds.js';
import axios from 'axios';
import RoundsNav from '../components/rounds/rounds_nav.js';
import Round from '../components/rounds/round.js';

class Rounds extends Component {
  constructor(props) {
    super(props)
    this.state = {
      rounds: [],
      round: '',
      fixtures: []
    }

    this.dataSource = this.dataSource.bind(this);
  }

  dataSource (roundId) {
    var roundId = roundId || this.state.round.id;
    axios.get(`/rounds/${roundId}.json`).then(res => {
      this.setState({
        fixtures: res.data.fixtures,
        round: res.data.round
      });
    });
  }

  componentDidMount () {
    this.props.fetchRounds();
    setInterval(function () {
      if (self.state.round.is_current && !self.state.round.data_checked) {
        self.dataSource(this);
      }
    }.bind(this), 60000);
  }

  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state || nextProps !== this.props;
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      rounds: nextProps.rounds,
      round: nextProps.round,
      fixtures: nextProps.fixtures
    })
  }



  render () {
    if (this.state.rounds.length == 0) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          <RoundsNav rounds={this.state.rounds} round={this.state.round} onChange={this.dataSource} />
          <Round round={this.state.round} fixtures={this.state.fixtures} />
        </div>
      );
    }
  }
}

function mapStateToProps(state) {
  return {
    rounds: state.rounds_data.rounds,
    round: state.rounds_data.round,
    fixtures: state.rounds_data.fixtures
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchRounds: fetchRounds,
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(Rounds);
