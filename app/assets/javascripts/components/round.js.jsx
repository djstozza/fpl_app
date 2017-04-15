var Round = React.createClass({
  getInitialState: function() {
    return {
        roundId: this.props.data.round_id,
        isCurrent: this.props.data.is_current,
        dataChecked: this.props.data.data_checked,
        fixtureGroups: this.props.data.fixtures.fixture_groups
    }
  },

  componentDidMount: function () {
    var self = this;
    if (self.state.Iscurrent && !self.state.dataChecked) {
      setInterval(function () {
        self.fetchData()
      }, 60000);
    }
  },

  fetchData: function () {
    var self = this
    $.ajax({
      type: 'get',
      url: '/rounds/' + this.state.roundId,
      dataType: 'json',
      success: function (data) {
        self.setState({
          roundId: data.round.id,
          fixtureGroups: data.fixtures.fixture_groups
        })
      }
    })
  },

  fixtureGroups: function (fixtureGroups) {
    var self = this;
    return (
      fixtureGroups.map(function (fixtureGroup, key) {
        return(
          < FixtureGroup key={'game-day-' + key} gameDay={fixtureGroup.game_day} fixtures={fixtureGroup.fixtures} />
        )
      })
    );
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
