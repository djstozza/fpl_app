class Match extends React.Component {
  matchTable () {
    var fixture = this.props.match.fixture;
    if (fixture.started) {
      return (
        < MatchStatTable key={'match-stat-table-' + fixture.id} match={this.props.match} />
      )
    }
  }

  render () {
    var self = this;
    var fixtureId = this.props.match.fixture.id;
    return (
      <div className='panel-group fixture-group' aria-multiselectable='true'
        role='tablist' id={'accordion-sharing-group-' + fixtureId}>
        <div className='panel'>
          <div className='panel-heading' id={'accordion-sharing-' + fixtureId}>
            < MatchPanelTitle match={this.props.match} />
            {self.matchTable()}
          </div>
        </div>
      </div>
    )
  }
}
