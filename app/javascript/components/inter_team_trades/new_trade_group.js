import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import { Row, Col, Button } from 'react-bootstrap';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import OutTradesTable from './out_trades_table.js';
import InTradesTable from './in_trades_table.js';

export default class NewTradeGroup extends Component {
  constructor(props) {
    super(props);
    this.setOutPlayer = this.setOutPlayer.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      activeTradeGroup: nextProps.activeTradeGroup,
      fpl_team: nextProps.fpl_team,
      fpl_teams: nextProps.fpl_teams,
      current_user: nextProps.current_user,
      out_players_tradeable: nextProps.out_players_tradeable,
      in_players_tradeable: nextProps.in_players_tradeable,
      status: nextProps.status,
      positions: nextProps.positions,
      teams: nextProps.teams,
      out_trade_groups: nextProps.out_trade_groups,
      in_trade_groups: nextProps.in_trade_groups
    });
  }

  setOutPlayer (outPlayer) {
    this.setState({ out_player: outPlayer });
  }

  completeTradeAction (inPlayer) {
    this.props.completeTradeAction(this.state.out_player, inPlayer);
  }

  tradeGroupPlayerList () {
    if (this.props.out_players_tradeable == null) {
      return;
    }

    if (this.state.activeTradeGroup != null) {
      return
    }

    return (
      <div>
        <Row className='clearfix'>
          <Col xs={5}>
            <OutTradesTable
              out_players_tradeable={ this.state.out_players_tradeable }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              status={ this.state.status }
              setOutPlayer={ this.setOutPlayer }
            />
          </Col>
          <Col xs={7}>
            <InTradesTable
              in_players_tradeable={ this.state.in_players_tradeable }
              teams={ this.state.teams }
              fpl_teams={ this.state.fpl_teams }
              positions={ this.state.positions }
              out_player={ this.state.out_player }
              status={ this.state.status }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              completeTradeAction={ this.completeTradeAction }
            />
          </Col>
        </Row>
      </div>
    );
  }

  render () {
    return (
      <div>
        { this.tradeGroupPlayerList() }
      </div>
    );
  }
}
