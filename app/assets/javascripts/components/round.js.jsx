var Round = React.createClass({
  getInitialState: function() {
    return {
        roundId: this.props.data.round_id,
        fixtureGroups: this.props.data.fixtures.fixture_groups
    }
  },

  fixtureGroups: function (fixtureGroups) {
    var self = this;
    return (
      fixtureGroups.map(function (fixtureGroup, key) {
        var gameDay = fixtureGroup.game_day;
        return(
          <div>
            <b key={'game-day-group' + key}>{gameDay}</b>
            <div key={'matches-group' + key}>{self.matches(fixtureGroup.fixtures)}</div>
          </div>
        )
      })
    );
  },

  matches: function (fixtures) {
    var self = this;
    return (
      fixtures.map(function (match) {
        var fixture = match.fixture;
        var fixtureId = fixture.id;
        var homeTeam = match.home_team;
        var awayTeam = match.away_team;
        var homeTeamShortName = homeTeam.short_name;
        var awayTeamShortName = awayTeam.short_name;
        return (
          <div key={'match-fixture-' + fixtureId} className='panel-group fixture-group' aria-multiselectable='true'
            role='tablist' id={'accordion-sharing-group-' + fixtureId}>
            <div className='panel'>
              <div className='panel-heading' id={'accordion-sharing-' + fixtureId}>
                {self.matchPanelTitle(match)}
                <div className='panel-collapse collapse' aria-labelledby={'accordion-sharing-' + fixtureId}
                  role='tabpanel' id={'sharing-tab-' + fixtureId}>
                  <div className='panel-body'>
                    <table className='table table-striped table-bordered'>
                      <thead>
                        <tr>
                          <td/>
                          <td><a href={'/teams/' + homeTeam.id}><b>{homeTeam.name}</b></a></td>
                          <td><b>{fixture.team_h_score}</b></td>
                          <td><a href={'/teams/' + awayTeam.id}><b>{awayTeam.name}</b></a></td>
                          <td><b>{fixture.team_a_score}</b></td>
                        </tr>
                      </thead>
                      <tbody>
                        {self.matchStats(match)}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )
      })
    );
  },

  matchPanelTitle: function (match) {
    var self = this;
    var fixture = match.fixture;
    var fixtureId = fixture.id;
    if (fixture.started) {
      return (
        <a aria-controls={'sharing-tab-' + fixtureId} aria-expanded='false' data-toggle='collapse' role='button'
          data-parent={'#accordion-sharing-' + fixtureId} href={'#sharing-tab-' + fixtureId}>
          {self.matchPanelTitleText(match, fixture)}
        </a>
      );
    } else {
      return (
        <div className={'pending-fixture-' + fixtureId}>{self.matchPanelTitleText(match, fixture)}</div>
      );
    }
  },

  matchPanelTitleText: function (match, fixture) {
    var homeTeam = match.home_team.short_name;
    var awayTeam = match.away_team.short_name;
    var imgSrc = '/assets/badges-sprite.jpg';
    var matchScore = function () {
      if (fixture.started) {
        return (fixture.team_h_score + ' - ' + fixture.team_a_score);
      } else {
        return (match.kickoff_time);
      }
    }


    return (
      <div>
        <span>{homeTeam} </span>
        <img className={homeTeam.toLowerCase()} src={imgSrc}/>
        <span> {matchScore()} </span>
        <img className={awayTeam.toLowerCase()} src={imgSrc}/>
        <span> {awayTeam}</span>
      </div>
    );
  },

  matchStats: function (match) {
    var self = this;
    return (
      Object.values(match.stats).map(function (statValue) {
        return(
          <tr key={'match-' + match.id + '-' + statValue.initials}>
            <td><b className='js-tooltip' title={statValue.name}>{statValue.initials}</b></td>
            {self.statEntries(Object.values(statValue.home_team))}
            {self.statEntries(Object.values(statValue.away_team))}
          </tr>
        )
      })
    );
  },

  statEntries: function(statEntry) {
    return [
      <td>
        {
          statEntry.map(function(stat) {
              return (
                <p key={stat.player}>{stat.player}</p>
              )
            }
        )}
      </td>,
      <td>
        {
          statEntry.map(function(stat) {
              return (
                <p key={stat.player + '-' + stat.value}>{stat.value}</p>
              )
            }
        )}
      </td>
    ]
  },

  render: function () {
    return (
      <div className='container'>
        <div className='row'>
          <div className='col-md-offset-3 col-md-6'>
            <div>{this.fixtureGroups(this.state.fixtureGroups)}</div>
          </div>
        </div>
      </div>
    );
  }
});
