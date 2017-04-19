var Rounds = React.createClass({
  getInitialState: function () {
    return {
      rounds: this.props.rounds,
      round: this.props.round,
      fixtures: this.props.fixtures,
    }
  },

  dataSource: function (roundId) {
    var self = this;
    var roundId = roundId || this.state.round.id;
    $.getJSON(
      '/rounds/' + roundId,
      function (data) {
        self.setState({
          round: data.round,
          fixtures: data.fixtures
        })
    });
  },

  componentDidMount: function () {
    var self = this;
    setInterval(function () {
      if (self.state.round.is_current && !self.state.round.data_checked) {
        self.dataSource();
      }
    }, 60000);
  },

  shouldComponentUpdate: function (nextProps, nextState) {
    return nextState !== this.state;
  },

  render: function() {
    return (
      <div className='container'>
        < RoundsNav rounds={this.state.rounds} round={this.state.round} onChange={this.dataSource}/>
        < Round round={this.state.round} fixtures={this.state.fixtures} />
      </div>
    )
  }
});
