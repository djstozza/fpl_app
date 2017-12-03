import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';

import OutTradesTable from './out_trades_table.js';
import InTradesTable from './in_trades_table.js';

export default class NewTradeGroup extends Component {
  constructor(props) {
    super(props);

    this.state = {
      out_player: '',
      clearSelection: false
    }

    this.toggleNewTradeGroup = this.toggleNewTradeGroup.bind(this);
    this.newTradeGroupPlayerList = this.newTradeGroupPlayerList.bind(this);
    this.setOutPlayer = this.setOutPlayer.bind(this);
    this.createTradeGroupAction = this.createTradeGroupAction.bind(this);
  }

  toggleNewTradeGroup () {
    const element = document.getElementById('new-trade-group');
    if (element.classList.contains('hidden')) {
      element.classList.remove('hidden');
      this.setState({
        out_player: null,
        clearSelection: false
      });
    } else {
      element.classList.add('hidden');
      this.setState({
        out_player: null,
        clearSelection: true
      });
    }
  }

  setOutPlayer (outPlayer) {
    this.setState({ out_player: outPlayer });
  }

  createTradeGroupAction (in_player) {
    this.props.createTradeGroupAction(
      this.state.out_player,
      in_player
    );

    this.setState({
      out_player: null,
      clearSelection: true
    });
    const element = document.getElementById('new-trade-group');
    element.classList.add('hidden');
  }

  newTradeGroupPlayerList (tradeGroup) {
    return (
      <div id='new-trade-group' className='hidden'>
        <Row className='clearfix'>
          <Col xs={5}>
            <OutTradesTable
              clearSelection={ this.state.clearSelection }
              out_players_tradeable={ this.props.out_players_tradeable }
              fpl_team={ this.props.fpl_team }
              current_user={ this.props.current_user }
              status={ this.props.status }
              setOutPlayer={ this.setOutPlayer }
            />
          </Col>
          <Col xs={7}>
            <InTradesTable
              in_players_tradeable={ this.props.in_players_tradeable }
              teams={ this.props.teams }
              fpl_teams={ this.props.fpl_teams }
              positions={ this.props.positions }
              out_player={ this.state.out_player }
              status={ this.props.status }
              fpl_team={ this.props.fpl_team }
              current_user={ this.props.current_user }
              completeTradeAction={ this.createTradeGroupAction }
            />
          </Col>
        </Row>
      </div>
    );
  }

  render () {
    return (
      <div>
        { this.newTradeGroupPlayerList() }
        <Button bsStyle='primary' onClick={ () => this.toggleNewTradeGroup() }>Create A New Trade</Button>
      </div>
    )
  }
}
