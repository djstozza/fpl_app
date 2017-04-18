var FixtureGroup = React.createClass({
  matches: function () {
    var self = this;
    return (
      self.props.fixtures.map(function (match) {
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
        <b>{this.props.gameDay}</b>
        <div>{self.matches()}</div>
      </div>
    )
  }
});
