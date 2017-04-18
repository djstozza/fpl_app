var FixtureGroups = React.createClass({
  render: function () {
    var self = this;
    return (
      <div>
      {
        self.props.fixtureGroups.map(function (fixtureGroup, key) {
          return(
            < FixtureGroup key={'game-day-' + key} gameDay={fixtureGroup.game_day} fixtures={fixtureGroup.fixtures} />
          )
        })
      }
      </div>
    );
  }
});
