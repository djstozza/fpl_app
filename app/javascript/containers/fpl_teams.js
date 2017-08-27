import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import UserFplTeamsTable from '../components/fpl_teams/user_fpl_teams_table.js';
import fetchFplTeams from '../actions/fpl_teams/action_fetch_fpl_teams.js';

class FplTeams extends Component {
  constructor (props) {
    super(props);
  }

  componentWillMount () {
    this.props.fetchFplTeams()
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      fpl_teams: nextProps.fpl_teams_data
    });
  }

  render () {
    if (this.state == null || this.state.fpl_teams == null) {
      return (
        <p>Loading...</p>
      );
    } else {
      return (
        <div>
          <h2>My Teams</h2>
          <UserFplTeamsTable fpl_teams={ this.state.fpl_teams }/>
        </div>
      );
    }
  }
}

function mapStateToProps (state) {
  return {
    fpl_teams_data: state.FplTeamReducer
  }
}

function mapDispatchToProps (dispatch) {
  return bindActionCreators({
    fetchFplTeams: fetchFplTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(FplTeams);
