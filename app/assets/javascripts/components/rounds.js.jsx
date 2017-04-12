var Rounds = React.createClass({
    render: function() {
      roundId = this.props.data.round.id;
      console.log(this.props.data.rounds);
      console.log(this.props.data.round);
      var roundList = this.props.data.rounds.map( function (round) {
        roundLink = '/rounds/' + round.id
        if (round.id == roundId) {
          return <li key={round.id} className='active presenter'><a href={roundLink}>{round.name}</a></li>;
        } else {
          return <li key={round.id} className='presenter'><a href={roundLink}>{round.name}</a></li>;
        }


      });

      return (
        <div className='row'>
          <div className= 'col-sm-12'>
            <ul className='nav nav-tabs js-scrollable-nav' role='tablist'>
              { roundList }
            </ul>
          </div>
        </div>
      )
  }
});
