import React from 'react';
import { Link } from 'react-router-dom';

export default class MatchStatTable extends React.Component {
  matchStats () {
    var self = this;
    var matchStats = this.props.match.stats;
    return (
      Object.keys(matchStats).map(function (key) {
        return(
          <tr key={`match-${self.props.match.fixture.id}-${matchStats[key].initials}`}>
            <td><b className='js-tooltip' title={matchStats[key].name}>{matchStats[key].initials}</b></td>
            {self.statEntries(matchStats[key].home_team)}
            {self.statEntries(matchStats[key].away_team)}
          </tr>
        )
      })
    );
  }

  statEntries (statEntry) {
    return [
      <td>
        {
          statEntry.map(function(stat) {
              return (
                <p key={stat.player.id}><Link to={ `/players/${stat.player.id}` }>{ stat.player.last_name }</Link></p>
              )
            }
        )}
      </td>,
      <td>
        {
          statEntry.map(function(stat) {
              return (
                <p key={ `${stat.player.last_name}-${stat.value}` }>{ stat.value }</p>
              )
            }
        )}
      </td>
    ]
  }

  render () {
    var self = this;
    var fixture = this.props.match.fixture;
    var fixtureId = fixture.id;
    var homeTeam = this.props.match.home_team;
    var awayTeam = this.props.match.away_team;
    return (
      <div className='panel-collapse collapse' aria-labelledby={`accordion-sharing-${fixtureId}`}
        role='tabpanel' id={`sharing-tab-${fixtureId}`}>
        <div className='panel-body'>
          <table className='table table-striped table-bordered'>
            <thead>
              <tr>
                <td/>
                <td><Link to={ `/teams/${homeTeam.id}` }><b>{ homeTeam.name }</b></Link></td>
                <td><b>{ fixture.team_h_score }</b></td>
                <td><Link to={ `/teams/${awayTeam.id}` }><b>{ awayTeam.name }</b></Link></td>
                <td><b>{ fixture.team_a_score }</b></td>
              </tr>
            </thead>
            <tbody>
              { this.matchStats() }
            </tbody>
          </table>
        </div>
      </div>
    )
  }
}
