import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import { Row, Col, Button, Modal } from 'react-bootstrap';
import OutTradesTable from './out_trades_table.js';
import InTradesTable from './in_trades_table.js';

export default class OutTradeGroupTable extends Component {
  constructor(props) {
    super(props);

    this.state = {
      out_player: '',
      clearSelection: false,
      showModal: false
    }

    this.showTradeList = this.showTradeList.bind(this);
    this.setOutPlayer = this.setOutPlayer.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
    this.tradeGroupButtons = this.tradeGroupButtons.bind(this);
    this.removeTradeGroupCol = this.removeTradeGroupCol.bind(this);
    this.removeTradeButton = this.removeTradeButton.bind(this);
    this.removeTradeAction = this.removeTradeAction.bind(this);
    this.buttonCol = this.buttonCol.bind(this);
    this.buttonColWidth = this.buttonColWidth.bind(this);
    this.showModal = this.showModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.modalFunction = this.modalFunction.bind(this);
  }

  showTradeList (selector) {
    const element = document.getElementById(selector);
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

  completeTradeAction (in_player) {
    this.props.completeTradeAction(this.props.tradeGroup, this.state.out_player, in_player);
    this.setState({
      out_player: '',
      clearSelection: true
    });
    const element = document.getElementById(this.props.selector);
    element.classList.add('hidden');
  }

  tradeGroupButtons () {
    const tradeGroup = this.props.tradeGroup;
    if (tradeGroup.status == 'pending') {
      return [
        <Button
          key={ `trade-group-${tradeGroup.id}-add` }
          bsStyle='primary' onClick={ () => this.showTradeList(this.props.selector) }
        >
          Add to Trade Group
        </Button>,
        <Button
          key={`trade-group-${tradeGroup.id}-submit` }
          bsStyle='success' onClick={ () => this.showModal('submit') }
        >
          Submit
        </Button>,
        <Button
          bsStyle='danger'
          key={ `trade-group-${tradeGroup.id}-delete` }
          onClick={ () => this.showModal('delete') } >
          Delete
        </Button>
      ];
    } else if (tradeGroup.status == 'submitted') {
      return (
        <Button
          bsStyle='danger'
          key={ `trade-group-${tradeGroup.id}-delete` }
          onClick={ () => this.showModal('delete') } >
          Delete
        </Button>
      );
    }
  }

  removeTradeGroupCol () {
    if (this.props.status == null) {
      return;
    }

    if (this.props.tradeGroup.status != 'pending' || this.props.tradeGroup.trades.length == 1) {
      return;
    }

    return (
      <TableHeaderColumn
        row='1'
        rowSpan='2'
        dataField='id'
        dataAlign='center'
        dataFormat={ this.removeTradeButton }
      >
        <span data-tip='Action'>A</span>
      </TableHeaderColumn>
    );
  }

  removeTradeButton (cell, row) {
    if (this.props.tradeGroup.status == 'pending') {
      return <Button bsStyle='danger' onClick={ () => { this.removeTradeAction(row.id) } }>Remove</Button>
    }
  }

  removeTradeAction (tradeId) {
    this.props.removeTradeAction(this.props.tradeGroup, tradeId);
  }

  buttonCol () {
    if (this.props.status == null) {
      return;
    }

    if (this.props.tradeGroup.status == 'pending' || this.props.tradeGroup.status == 'submitted') {
      return (
        <TableHeaderColumn
          row='0'
          colSpan={ this.buttonColWidth() }
          dataAlign='center'
        >
          <div>
            { this.tradeGroupButtons() }
          </div>
        </TableHeaderColumn>
      );
    }
  }

  buttonColWidth () {
    if (this.props.tradeGroup.trades.length == 1 || this.props.tradeGroup.status != 'pending') {
      return '5'
    } else {
      return '6'
    }
  }

  showModal (action) {
    const capitalisedModalAction = action.charAt(0).toUpperCase() + action.slice(1);
    this.setState({
      showModal: true,
      modalAction: action,
      capitalisedModalAction: capitalisedModalAction,
    })
  };

  closeModal () {
    this.setState({
      showModal: false
    });
  }

  modalFunction () {
    this.setState({
      showModal: false
    });

    switch (this.state.modalAction) {
      case 'delete':
        return this.props.deleteTradeGroupAction(this.props.tradeGroup);
      case 'submit':
        return this.props.submitTradeGroupAction(this.props.tradeGroup);
    }
  }

  render () {
    return (
      <div>
        <Modal show={ this.state.showModal } onHide={ this.closeModal }>
            <Modal.Header closeButton><b>{ this.state.capitalisedModalAction } Trade</b></Modal.Header>
            <Modal.Body>
              <p>Are you sure you want to { this.state.modalAction } this trade?</p>
              <Row className='clearfix'>
                <Col sm={12}>
                  <Button
                    bsStyle='danger'
                    className='pull-left'
                    onClick={ () => this.closeModal() }
                  >
                    Cancel
                  </Button>
                  <Button
                    className='pull-right'
                    bsStyle='success'
                    onClick={ () => this.modalFunction() }
                  >
                    { this.state.capitalisedModalAction }
                  </Button>
                </Col>
              </Row>
            </Modal.Body>
        </Modal>
        <div id={ this.props.selector } className='hidden'>
          <Row>
            <Col xs={12} sm={12} md={5}>
              <h3>Out Players (You)</h3>
              <p>(1) Select the player you wish to trade out</p>
              <OutTradesTable
                out_players_tradeable={ this.props.tradeGroup.out_players_tradeable }
                clearSelection={ this.state.clearSelection }
                fpl_team={ this.props.fpl_team }
                current_user={ this.props.current_user }
                status={ this.props.status }
                setOutPlayer={ this.setOutPlayer }
              />
            </Col>
            <Col xs={12} sm={12} md={7}>
              <h3>In Players ({ this.props.tradeGroup.in_fpl_team.name })</h3>
              <p>(2) Select the player you wish to trade in</p>
              <InTradesTable
                in_players_tradeable={ this.props.tradeGroup.in_players_tradeable }
                teams={ this.props.teams }
                fpl_teams={ this.props.fpl_teams }
                positions={ this.props.positions }
                out_player={ this.state.out_player }
                status={ this.props.status }
                fpl_team={ this.props.fpl_team }
                current_user={ this.props.current_user }
                completeTradeAction={ this.completeTradeAction }
              />
            </Col>
          </Row>
        </div>

        <BootstrapTable
          data={ this.props.tradeGroup.trades }
          striped
          hover
        >
          { this.buttonCol() }
          <TableHeaderColumn dataField='out_player_id' dataAlign='center' isKey hidden/>
          <TableHeaderColumn row='1' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='Out'>{ this.props.fpl_team.name } (Me)</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            rowSpan='1'
            dataField='out_player_last_name'
            dataAlign='center'
          >
            <span data-tip='Name'>N</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            rowSpan='1'
            dataField='out_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='1' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='In'>{ this.props.tradeGroup.in_fpl_team.name }</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            dataField='in_player_last_name'
            dataAlign='center'
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='2'
            colSpan='1'
            dataField='in_team_short_name'
            dataAlign='center'
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            rowSpan='2'
            dataField='singular_name_short'
            dataAlign='center'
          >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          { this.removeTradeGroupCol() }
        </BootstrapTable>
        <ReactTooltip />
        <hr/>
      </div>
    );
  }
}
