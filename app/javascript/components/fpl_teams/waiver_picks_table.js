import React, { Component } from 'react';
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
import { Button, Modal, Row, Col } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import _ from 'underscore';

export default class WaiverPicksTable extends Component {
  constructor (props) {
    super(props);
    this.deleteWaiverPickCol = this.deleteWaiverPickCol.bind(this);
    this.deletePickButton = this.deletePickButton.bind(this);
    this.beforeSaveCell = this.beforeSaveCell.bind(this);
    this.openDeleteWaiverDialog = this.openDeleteWaiverDialog.bind(this);
    this.closeDeleteWaiverDialog = this.closeDeleteWaiverDialog.bind(this);
    this.deleteWaiverPick = this.deleteWaiverPick.bind(this);
    this.state = {
      selected: '',
      showModal: false
    }
  }

  deleteWaiverPickCol () {
    if (!this.props.editable) {
      return;
    }

    return (
      <TableHeaderColumn
        row='0'
        rowSpan='2'
        dataField='id'
        dataAlign='center'
        dataFormat={ this.deletePickButton }
      >
        <span data-tip='Delete Pick'>D</span>
      </TableHeaderColumn>
    );
  }

  beforeSaveCell (row, cellName, cellValue) {
    if (!this.props.editable) {
      return false
    }
    return this.props.updateWaiverPickOrder(row.id, cellValue);
  }

  deletePickButton (cell, row) {
    return (
      <Button bsStyle='danger' onClick={ () => this.openDeleteWaiverDialog(row.id) }>Delete Pick</Button>
    )
  }

  closeDeleteWaiverDialog () {
    this.setState({
      showModal: false,
      selected: ''
    });
  }

  openDeleteWaiverDialog (rowId) {
    this.setState({
      showModal: true,
      selected: rowId
    });
  }

  deleteWaiverPick () {
    this.props.deleteWaiverPick(this.state.selected);
    this.closeDeleteWaiverDialog();
  }

  render () {
    const teamText = _.object(_.map(this.props.teams, (obj) => {
      return [obj.id, obj.short_name]
    }));

    const listPositionIdPlayerId = _.object(_.map(this.props.line_up, (obj) => {
      return [obj.id, obj.player_id]
    }));

    const playerLastNameText = _.object(_.map(this.props.line_up, (obj) => {
      return [obj.id, obj.last_name]
    }));

    const playerIdTeamId = _.object(_.map(this.props.line_up, (obj) => {
      return [obj.id, obj.team_id]
    }))

    const positionText = _.object(_.map(this.props.positions, (obj) => {
      return [obj.id, obj.singular_name_short]
    }))

    let positionTextCell = function (cell, row) {
      return positionText[cell]
    }

    let inPlayerLastNameCell = (cell, row) => {
      return playerLastNameText[cell];
    }

    let inTeamTextCell = (cell, row) => {
      return teamText[cell];
    }

    let outTeamTextCell = (cell, row) => {
      return teamText[playerIdTeamId[cell]]
    }

    let pickNumbers = _.map(this.props.waiver_picks, (obj) => {
      return obj.pick_number;
    });

    const cellEditProp = {
      mode: 'click',
      blurToSave: true,
      beforeSaveCell: this.beforeSaveCell
    };

    return (
      <div>
        <Modal show={ this.state.showModal } onHide={ this.closeDeleteWaiverDialog }>
            <Modal.Header closeButton><b>Delete waiver pick</b></Modal.Header>
            <Modal.Body>
              <p>Are you sure you want to delete this waiver pick?</p>
              <Row className='clearfix'>
                <Col sm={12}>
                  <Button
                    bsStyle='danger'
                    className='pull-left'
                    onClick={ () => this.closeDeleteWaiverDialog() }
                  >
                    Cancel
                  </Button>
                  <Button
                    className='pull-right'
                    bsStyle='success'
                    onClick={ () => this.deleteWaiverPick() }
                  >
                    Delete Draft Pick
                  </Button>
                </Col>
              </Row>
            </Modal.Body>
        </Modal>

        <h3>Waiver Picks</h3>
        <p>
          You can edit the order of your waiver picks by clicking on the pick number and changing it. Remember to
            click outside the cell for your change to be saved.
        </p>
        <p>
          You can delete an undesired waiver pick by clicking its 'Delete Pick' button.
        </p>

        <BootstrapTable
          data={ this.props.waiver_picks }
          cellEdit={ cellEditProp }
          striped
          hover
        >
          <TableHeaderColumn
            dataField='id'
            hidden={ true }
            isKey
          />
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='pick_number'
            dataAlign='center'
            editable={ { type: 'select', options: { values: pickNumbers } } }

          >
            <span data-tip='Pick Number'>PN</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='0' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='Out'>Out</span>
          </TableHeaderColumn>

          <TableHeaderColumn
            row='1'
            colSpan='1'
            rowSpan='1'
            dataField='list_position_id'
            dataAlign='center'
            dataFormat={ inPlayerLastNameCell }
            editable={ false }
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            colSpan='1'
            rowSpan='1'
            dataField='list_position_id'
            dataFormat={ outTeamTextCell }
            dataAlign='center'
            editable={ false }
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>

          <TableHeaderColumn row='0' colSpan='2' rowSpan='1' dataAlign='center'>
            <span data-tip='In'>In</span>
          </TableHeaderColumn>

          <TableHeaderColumn
            row='1'
            colSpan='1'
            dataField='last_name'
            dataAlign='center'
            editable={ false }
          >
            <span data-tip='Last Name'>LN</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='1'
            colSpan='1'
            dataField='team_id'
            dataAlign='center'
            dataFormat={ inTeamTextCell }
            editable={ false }
          >
            <span data-tip='Team'>T</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='position_id'
            dataAlign='center'
            dataFormat={ positionTextCell }
            editable={ false }
          >
            <span data-tip='Position'>Pos</span>
          </TableHeaderColumn>
          <TableHeaderColumn
            row='0'
            rowSpan='2'
            dataField='status'
            dataAlign='center'
            editable={ false }
          >
            <span data-tip='Status'>S</span>
          </TableHeaderColumn>
          { this.deleteWaiverPickCol() }
        </BootstrapTable>
      </div>
    )
  }
}
