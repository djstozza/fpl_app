var FixtureGroup = React.createClass({
  getInitialState: function () {
    return {
      gameDay: this.props.gameDay,
      fixtures: this.props.fixtures
    }
  },

  matches: function () {
    var self = this;
    return (
      self.state.fixtures.map(function (match) {
        return (
          < Match key={'match-' + match.fixture.id} match={match} />
        )
      })
    );
  },

  render: function () {
    var self = this;
    return(
      <div>
        <b>{this.state.gameDay}</b>
        <div>{self.matches()}</div>
      </div>
    )
  }
});
