var MatchPanelTitle = React.createClass({
  getInitialState: function () {
    return {
      fixture: this.props.match.fixture,
      homeTeam: this.props.match.homeTeam,
      awayTeam: this.props.match.awayTeam,
      kickoffTime: this.props.match.kickoffTime,
      stats: this.props.match.stats
    }
  },

  matchPanelTitleText: function () {
    var self = this;
    var fixture = this.state.fixture;
    var homeTeamShortName = this.state.homeTeam.short_name;
    var awayTeamShortName = this.state.awayTeam.short_name;
    var imgSrc = '/assets/badges-sprite.jpg';
    var matchScore = function () {
      if (fixture.started) {
        return (fixture.team_h_score + ' - ' + fixture.team_a_score);
      } else {
        return (self.state.kickoffTime);
      }
    }

    return (
      <div>
        <span>{homeTeamShortName} </span>
        <img className={homeTeamShortName.toLowerCase()} src={imgSrc}/>
        <span> {matchScore()} </span>
        <img className={awayTeamShortName.toLowerCase()} src={imgSrc}/>
        <span> {awayTeamShortName}</span>
      </div>
    );
  },

  render: function () {
    var fixtureId = this.state.fixture.id;
    if (this.state.fixture.started) {
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
