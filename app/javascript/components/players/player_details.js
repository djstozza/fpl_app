import React, { Component } from 'react';
import { Table } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { Icon } from 'react-fa';
import _ from 'underscore';


export default class PlayerDetails extends Component {
  render () {
    const playerImgSrc = 'https://platform-static-files.s3.amazonaws.com/premierleague/photos/players/110x140/p'
    let player = this.props.player
    let previousRound = _.find(this.props.rounds, function(obj) {
      return obj.is_previous == true
    })
    let currentRound = _.find(this.props.rounds, function (obj) {
      return obj.is_current == true
    })
    let previousFixtureHistory = _.find(player.player_fixture_histories, function (obj) {
      return obj.round == previousRound.id
    })
    let currentFixtureHistory = _.find(player.player_fixture_histories, function (obj) {
      return obj.round == currentRound.id
    })

    let previousRoundLink = () => {
      if (previousFixtureHistory != null) {
        return (
          `${<Link to={ `/rounds/${previousFixtureHistory.round}` }>{ previousFixtureHistory.round }</Link>}: ` +
          `${ previousFixtureHistory.total_points }`
        )
      }
    }

    const statuses = {
      a: { name: 'check', title: 'Available' },
      n: { name: 'warning', title: 'Unavailable' },
      u: { name: 'plane', title: 'On Loan' },
      d: { name: 'question', title: 'In Doubt' },
      s: { name: 'gavel', title: 'Suspended' },
      i: { name: 'ambulance', title: 'Injured' }
    }
    return (
      <div className='row'>
        <div className='col-sm-6 col-xs-12'>
          <Table bordered hover>
            <tbody>
              <tr>
                <td colSpan='2' rowSpan='6'><img src={ `${playerImgSrc}${player.code}.png` }/></td>
                <th colSpan='3'>Player Details</th>
              </tr>
              <tr>
                <th>Name</th>
                <td colSpan='2'>{ player.first_name } { player.last_name }</td>
              </tr>
              <tr>
                <th>Team</th>
                <td colSpan='2'><Link to={ `/teams/${this.props.team.id}` }>{ this.props.team.name }</Link></td>
              </tr>
              <tr>
                <th>Position</th>
                <td colSpan='2'>{ this.props.position.singular_name }</td>
              </tr>
              <tr>
                <th>Points</th>
                <th>Last Round</th>
                <th>This Round</th>
              </tr>
              <tr>
                <td>{ player.total_points }</td>
                <td>
                  { previousRoundLink }
                </td>
                <td>
                  <Link to={ `/rounds/${currentFixtureHistory.round}` }>{ currentFixtureHistory.round }</Link>
                  : { currentFixtureHistory.total_points }
                </td>
              </tr>
              <tr>
                <th>Status</th>
                <td colSpan='5'>
                  <Icon size='lg' name={ statuses[player.status].name } /> { statuses[player.status].title }
                  { player.news ? `: ${player.news}` : '' }
                </td>
              </tr>
              <tr>
                <th>Availability</th>
              <th>This Round</th>
                <td>{ player.chance_of_playing_this_round }%</td>
                <th>Next Round</th>
                <td>{ player.chance_of_playing_next_round }%</td>
              </tr>
              <tr>
                <th>Influence</th>
                <th>Threat</th>
                <th>Creativity</th>
                <th>ICT Index</th>
                <th>Dream Team</th>
              </tr>
              <tr>
                <td>{ player.influence }</td>
                <td>{ player.threat }</td>
                <td>{ player.creativity }</td>
                <td>{ player.ict_index }</td>
                <td>{ player.in_dreamteam ? 'Yes' : 'No' }</td>
              </tr>
            </tbody>
          </Table>
        </div>
      </div>
    )
  }
}
