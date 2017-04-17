var Round = React.createClass({
  getInitialState: function() {
    return {
        roundId: this.props.round.id,
        isCurrent: this.props.round.is_current,
        dataChecked: this.props.round.data_checked,
        fixtureGroups: this.props.fixtures.fixture_groups
    }
  },

  componentDidMount: function(){
    var self = this;
    if (self.state.isCurrent && !self.state.dataChecked) {
      setInterval(function () {
        self.dataSource();
      }, 10000);
    }
  },

  dataSource: function(props) {
    var self = this;
    $.getJSON(
      '/rounds/' + this.state.roundId,
      function (data) {
        self.setState({
          roundId: data.round.id,
          isCurrent: data.round.is_current,
          dataChecked: data.round.data_checked,
          fixtureGroups: data.fixtures.fixture_groups
        })
    });
  },

  shouldComponentUpdate: function (nextProps, nextState) {
    return nextState !== this.state
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
