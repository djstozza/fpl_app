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
      return (
        < MatchStatTable key={'match-stat-table-' + this.state.fixture.id} match={this.state} />
      )
    }
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
