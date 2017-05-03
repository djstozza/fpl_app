class  MatchPanelTitle extends React.Component {
  matchPanelTitleText () {
    var self = this;
    var fixture = this.props.match.fixture;
    var homeTeamShortName = this.props.match.home_team.short_name;
    var awayTeamShortName = this.props.match.away_team.short_name;
    var imgSrc = '/assets/badges-sprite.jpeg';
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
        <img className={homeTeamShortName.toLowerCase()} src={imgSrc}/>
        <span> {matchScore()} </span>
        <img className={awayTeamShortName.toLowerCase()} src={imgSrc}/>
        <span> {awayTeamShortName}</span>
      </div>
    );
  }

  render () {
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
}
