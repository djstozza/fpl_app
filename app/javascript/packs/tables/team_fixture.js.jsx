"use strict";

import React from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import {Table, Column, Cell} from 'fixed-data-table';
import DataListWrapper from './common/data_list_wrapper.js.jsx';
import MyTextCell from './common/text_cell.js.jsx';
import MyLinkCell from './common/link_cell.js.jsx';
import SortHeaderCell from './common/sort_header_cell.js.jsx';
import ColourCell from './common/colour_cell.js.jsx';

var SortTypes = {
  ASC: 'ASC',
  DESC: 'DESC',
};

function reverseSortDirection(sortDir) {
  return sortDir === SortTypes.DESC ? SortTypes.ASC : SortTypes.DESC;
}

class TeamFixture extends React.Component {
  constructor(props) {
    super(props);
    console.log(props);
    var size = props.fixtures.length;
    this._defaultSortIndexes = [];
    for (var index = 0; index < size; index++) {
      this._defaultSortIndexes.push(index);
    }

    this._dataList = new DataListWrapper(this._defaultSortIndexes, props.fixtures);
    this.state = {
      team: props.team,
      filteredDataList: this._dataList,
      colSortDirs: {},
    };

    console.log(this.state);

    this._onFilterChange = this._onFilterChange.bind(this);
    this._onSortChange = this._onSortChange.bind(this);
  }

  _onFilterChange(e, columnKey) {
    if (!e.target.value) {
      this.setState({
        filteredDataList: this._dataList,
      });
    }

    var filterBy = e.target.value.toString().toLowerCase();
    var size = this._dataList.getSize();
    var filteredIndexes = [];
    for (var index = 0; index < size; index++) {
      var v = this._dataList.getObjectAt(index)[columnKey];
      if (v.toString().toLowerCase().indexOf(filterBy) !== -1) {
        filteredIndexes.push(index);
      }
    }

    this.setState({
      filteredDataList: new DataListWrapper(filteredIndexes, this._dataList._data),
    });
  }

  _onSortChange(columnKey, sortDir) {
    var sortIndexes = this._defaultSortIndexes.slice();
    sortIndexes.sort((indexA, indexB) => {
      var valueA = this._dataList.getObjectAt(indexA)[columnKey];
      var valueB = this._dataList.getObjectAt(indexB)[columnKey];
      var sortVal = 0;
      if (valueA > valueB) {
        sortVal = 1;
      }
      if (valueA < valueB) {
        sortVal = -1;
      }
      if (sortVal !== 0 && sortDir === SortTypes.ASC) {
        sortVal = sortVal * -1;
      }
      return sortVal;
    });

    this.setState({
      filteredDataList: new DataListWrapper(sortIndexes, this._dataList._data),
      colSortDirs: {
        [columnKey]: sortDir
      }
    });
  }


  render() {
    return (
      <Table
        rowsCount={this.state.filteredDataList.getSize()}
        rowHeight={30}
        headerHeight={60}
        width={780}
        height={32 + ((this.state.filteredDataList.getSize() + 1) * 30)}>
        <Column
          columnKey='round_id'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.round_id}>
              Round
            </SortHeaderCell>
          }
          cell={
            <MyTextCell
              data={this.state.filteredDataList}
            />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='kickoff_time'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.kickoff_time}>
              Kickoff Time
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={130}
          flexGrow={1}
        />
        <Column
          columnKey='opponent_short_name'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.opponent_short_name}>
              Opponent
            </SortHeaderCell>
          }
          cell={
            <MyLinkCell
              data={this.state.filteredDataList}
              url='/teams/'
              id='opponent_id'
            />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='result'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.result}>
              Result
            </SortHeaderCell>
          }
          cell={
            <MyTextCell
              data={this.state.filteredDataList}
            />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='leg'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.leg}>
              H/A
            </SortHeaderCell>
          }
          cell={
            <MyTextCell
              data={this.state.filteredDataList}
            />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='score'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.score}>
              Score
            </SortHeaderCell>
          }
          cell={
            <MyTextCell
              data={this.state.filteredDataList}
            />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='advantage'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.advantage}>
              Advantage
            </SortHeaderCell>
          }
          cell={
            <ColourCell
              data={this.state.filteredDataList}
              selector='fixture_advantage'
            />
          }
          width={55}
          flexGrow={1}
        />
      </Table>
    );
  }
}


axios.get('/teams/team_fixture_datatable.json?id=' + window.fplVars.team_id).then(res => {
  TeamFixture.defaultProps = {
    team: res.data.team,
    fixtures: res.data.fixtures
  }

  TeamFixture.propTypes = {
    team: React.PropTypes.object,
    fixtures: React.PropTypes.array
  }
  if (document.getElementById('team-fixture')) {
    ReactDOM.render(
      <TeamFixture />,
      document.getElementById('team-fixture')
    )
  }
});
