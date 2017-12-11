import React, { Component } from 'react';
import { ListGroupItem } from 'react-bootstrap';
import Countdown from 'react-countdown-now';

export default class RoundCountdown extends Component {
  constructor (props) {
    super(props);
  }

  days (days) {
    if (days == '0') {
      return;
    } else if (days == '1') {
      return `${days} day`;
    } else {
      return `${days} days`;
    }
  }

  hours (hours) {
    if (hours == '0') {
      return;
    } else if (hours == '1') {
      return `${hours} hour`;
    } else {
      return `${hours} hours`;
    }
  }

  minutes (minutes) {
    if (minutes == '0') {
      return;
    } else if (minutes == '1') {
      return `${minutes} minute`;
    } else {
      return `${minutes} minutes`;
    }
  }

  seconds (seconds) {
    if (seconds == '1') {
      return `${seconds} second`;
    } else {
      return `${seconds} seconds`;
    }
  }

  render () {
    const status = this.props.current_round_status.replace(/(_)/, ' ');
    const roundId = this.props.round.id;
    const renderer = ({ days, hours, minutes, seconds, completed }) => {
      if (completed) {
        location.reload();
        return <div/>;
      } else {
        return (
          <ListGroupItem bsStyle='info'>
            Round { roundId } { status } window closes
            in { this.days(days) } { this.hours(hours) } { this.minutes(minutes) } { this.seconds(seconds) }.
          </ListGroupItem>
        );
      }
    }

    return (
      <Countdown date={ new Date(this.props.current_round_deadline) } renderer={ renderer } />
    )
  }
}
