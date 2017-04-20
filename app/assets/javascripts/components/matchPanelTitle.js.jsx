var MatchPanelTitle = React.createClass({
  matchPanelTitleText: function () {
    var self = this;
    var fixture = this.props.match.fixture;
    var homeTeamShortName = this.props.match.home_team.short_name;
    var awayTeamShortName = this.props.match.away_team.short_name;
    var matchScore = function () {
      if (fixture.started) {
        return (fixture.team_h_score + ' - ' + fixture.team_a_score);
      } else {
        return (self.props.match.kickoff_time);
      }
    }

    return (
      <div>
        <span>{homeTeamShortName} </span>
        { imageTag('badges-sprite', { className: homeTeamShortName.toLowerCase() }) }
        <span> {matchScore()} </span>
        { imageTag('badges-sprite', { className: awayTeamShortName.toLowerCase() }) }
        <span> {awayTeamShortName}</span>
      </div>
    );
  },

  render: function () {
    var fixtureId = this.props.match.fixture.id;
    if (this.props.match.fixture.started) {
      return (
        <a aria-controls={'sharing-tab-' + fixtureId} aria-expanded='false' data-toggle='collapse' role='button'
          data-parent={'#accordion-sharing-' + fixtureId} href={'#sharing-tab-' + fixtureId}>
          {this.matchPanelTitleText()}
        </a>
      );
    } else {
      return (
        <div className={'pending-fixture-' + fixtureId}>{this.matchPanelTitleText()}</div>
      );
    }
  }
});
