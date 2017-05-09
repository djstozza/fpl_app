import React from 'react';
import ReactDOM from 'react-dom'
import axios from 'axios';
import RoundsNav from '../packs/rounds/roundsNav.js.jsx';
import Round from '../packs/rounds/round.js.jsx';

export default class Rounds extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rounds: props.rounds,
      fixtures: props.fixtures,
      round: props.round
    }

    this.dataSource = this.dataSource.bind(this);
  }

  dataSource (roundId) {
    var roundId = roundId || this.state.round.id;
    axios.get('/rounds/' + roundId + '.json').then(res => {
      this.setState({
        fixtures: res.data.fixtures,
        round: res.data.round
      });
    });
  }

  componentDidMount () {
    var self = this;
    setInterval(function () {
      if (self.state.round.is_current && !self.state.round.data_checked) {
        self.dataSource(this);
      }
    }.bind(this), 60000);
  }


  shouldComponentUpdate (nextProps, nextState) {
    return nextState !== this.state;
  }

  render () {
    return (
      <div className='container'>
        < RoundsNav rounds={this.state.rounds} round={this.state.round} onChange={this.dataSource}/>
        < Round round={this.state.round} fixtures={this.state.fixtures} />
      </div>
    );
  }
}

Rounds.propTypes = {
  rounds: React.PropTypes.array,
  round: React.PropTypes.object,
  fixtures: React.PropTypes.object
};
