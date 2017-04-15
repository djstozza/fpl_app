var Match = React.createClass({
  getInitialState: function () {
    return {
      fixture: this.props.match.fixture,
      homeTeam: this.props.match.home_team,
      awayTeam: this.props.match.away_team,
      kickoffTime: this.props.match.kickoff_time,
      stats: this.props.match.stats
    }
  },

  matchTable: function () {
    var self = this;
    if (this.state.fixture.started) {
      var fixture = this.state.fixture;
      var fixtureId = fixture.id;
      var homeTeam = this.state.homeTeam;
      var awayTeam = this.state.awayTeam;
      return (
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
                {self.matchStats()}
              </tbody>
            </table>
          </div>
        </div>
      )
    }
  },


  matchStats: function () {
    var self = this;
    return (
      Object.values(this.state.stats).map(function (statValue) {
        return(
          <tr key={'match-' + self.state.fixture.id + statValue.initials}>
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
    var self = this;
    var fixtureId = this.state.fixture.id;
    return (
      <div className='panel-group fixture-group' aria-multiselectable='true'
        role='tablist' id={'accordion-sharing-group-' + fixtureId}>
        <div className='panel'>
          <div className='panel-heading' id={'accordion-sharing-' + fixtureId}>
            < MatchPanelTitle match={this.state} />
            {self.matchTable()}
          </div>
        </div>
      </div>
    )
  }
});
