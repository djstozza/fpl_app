import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Link } from 'react-router-dom';
import axios from 'axios';
import _ from 'underscore';
import { Icon } from 'react-fa';
import { Row, Col, Button, Modal } from 'react-bootstrap';

export default class InTradeGroupTable extends Component {
  constructor(props) {
    super(props);

    this.state = {
      showModal: false
    }

    this.buttonCol = this.buttonCol.bind(this);
    this.tradeGroupButtons = this.tradeGroupButtons.bind(this);
    this.showModal = this.showModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.modalFunction = this.modalFunction.bind(this);
  }

  buttonCol () {
    if (this.props.status == null) {
      return;
    }

    if (this.props.tradeGroup.status == 'submitted') {
      return (
        <TableHeaderColumn
          row='0'
          colSpan='5'
          dataAlign='center'
        >
          <div>
            { this.tradeGroupButtons() }
          </div>
        </TableHeaderColumn>
      );
    }
  }

  tradeGroupButtons () {
    const tradeGroup = this.props.tradeGroup;
    if (tradeGroup.status == 'submitted') {
      return [
        <Button
          key={ `trade-group-${tradeGroup.id}-approve` }
          bsStyle='success' onClick={ () => this.showModal('approve') }
        >
          Approve
        </Button>,
        <Button
          key={`trade-group-${tradeGroup.id}-decline` }
          bsStyle='danger' onClick={ () => this.showModal('decline') }
        >
          Deciline
        </Button>
      ]
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
      case 'approve':
        return this.props.approveTradeGroupAction(this.props.tradeGroup);
      case 'decline':
        return this.props.declineTradeGroupAction(this.props.tradeGroup);
    }
  }

  render () {
    let tradeGroupStatus = this.props.tradeGroup.status;
    let capitalisedTradeGroupStatus = tradeGroupStatus.charAt(0).toUpperCase() + tradeGroupStatus.slice(1);

    return (
      <div>
        <Modal show={ this.state.showModal } onHide={ this.closeModal }>
            <Modal.Header closeButton><b>{ this.state.capitalisedModalAction } Trade</b></Modal.Header>
            <Modal.Body>
              <p>Are you sure you want to { this.state.modalAction } this trade? It cannot be undone.</p>
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

        <BootstrapTable
          data={ this.props.tradeGroup.trades }
          striped
          hover
        >
          { this.buttonCol() }
          <TableHeaderColumn dataField='out_player_id' dataAlign='center' isKey hidden/>
          <TableHeaderColumn row='1' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='Out'>{ this.props.tradeGroup.out_fpl_team.name }</span>
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
            <span data-tip='In'>{ this.props.fpl_team.name } (Me)</span>
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
        </BootstrapTable>
        <ReactTooltip />
        <hr/>
      </div>
    );
  }
}
