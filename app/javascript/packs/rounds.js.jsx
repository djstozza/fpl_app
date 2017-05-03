import React from 'react'
import ReactDOM from 'react-dom'
import axios from 'axios';

class Rounds extends  React.Component {
  constructor () {
    super()
    this.dataSource = this.dataSource.bind(this)
  }

  componentWillMount () {
    axios.get('/rounds.json').then(res => {
      this.setState({
        rounds: res.data.rounds,
        fixtures: res.data.fixtures,
        round: res.data.round
      });
    });
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
    if (this.state == null) {
      return (
        <div className='loader'/>
      )
    } else {
    return (
      <div className='container'>
        < RoundsNav rounds={this.state.rounds} round={this.state.round} onChange={this.dataSource}/>
        < Round round={this.state.round} fixtures={this.state.fixtures} />
      </div>
    )}
  }
}


ReactDOM.render(
  <Rounds />,
  document.body.appendChild(document.createElement('div')),
)
