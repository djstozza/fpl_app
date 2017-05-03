class Round extends React.Component {
  render () {
    return (
      <div className='container'>
        <div className='row'>
          <div className='col-md-offset-3 col-md-6'>
            < FixtureGroups fixtureGroups={this.props.fixtures.fixture_groups} />
          </div>
        </div>
      </div>
    );
  }
}
