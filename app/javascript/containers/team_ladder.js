import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux'
import fetchTeams from '../actions/action_fetch_teams.js'
import { BootstrapTable, TableHeaderColumn } from 'react-bootstrap-table';
import ReactTooltip from 'react-tooltip';
require('../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css');

class TeamLadder extends Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    this.props.fetchTeams();
  }

  render () {
    return (
      <div>
        <BootstrapTable data={this.props.teams} striped hover>
          <TableHeaderColumn
            dataField="position"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }
            isKey>
            Pos
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="short_name"
            dataAlign="center"
            filter={ { type: 'TextFilter' } }
            dataSort>
            N
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="played"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            M
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="wins"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            W
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="losses"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            L
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="draws"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            D
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="form"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            F
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="goals_for"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            GF
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="goals_against"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            GA
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="goal_difference"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            GD
          </TableHeaderColumn>
          <TableHeaderColumn
            dataField="points"
            dataAlign="center"
            dataSort
            filter={ { type: 'TextFilter' } }>
            Pts
          </TableHeaderColumn>
        </BootstrapTable>
        <ReactTooltip />
      </div>
    )
  }
}

function mapStateToProps(state) {
  return {
    teams: state.teams
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchTeams: fetchTeams
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(TeamLadder);
