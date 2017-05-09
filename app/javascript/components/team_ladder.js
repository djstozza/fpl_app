import React from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import {Table, Column, Cell} from 'fixed-data-table-2';
import DataListWrapper from '../packs/tables/common/data_list_wrapper.js.jsx';
import MyTextCell from '../packs/tables/common/text_cell.js.jsx';
import MyLinkCell from '../packs/tables/common/link_cell.js.jsx';
import SortHeaderCell from '../packs/tables/common/sort_header_cell.js.jsx';
const Dimensions = require('react-dimensions');
import ReactTooltip from 'react-tooltip'

var SortTypes = {
  ASC: 'ASC',
  DESC: 'DESC',
};

function reverseSortDirection(sortDir) {
  return sortDir === SortTypes.DESC ? SortTypes.ASC : SortTypes.DESC;
}

export default class TeamLadder extends React.Component {
  constructor(props) {
    super(props);
    console.log(props);
    var size = props.rows.length;
    this._defaultSortIndexes = [];
    for (var index = 0; index < size; index++) {
      this._defaultSortIndexes.push(index);
    }

    this._dataList = new DataListWrapper(this._defaultSortIndexes, props.rows);
    this.state = {
      filteredDataList: this._dataList,
      colSortDirs: {},
    };

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
        width={this.props.containerWidth}
        height={32 + ((this.state.filteredDataList.getSize() + 1) * 30)}>
        <Column
          columnKey='position'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.position}>
              Pos
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='name'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.name}>
              Name
            </SortHeaderCell>
          }
          cell={<MyLinkCell data={this.state.filteredDataList} id='id' url='/teams/' />}
          width={130}
          flexGrow={1}
        />
        <Column
          columnKey='played'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.played}>
              M
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='wins'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.wins}>
              W
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='losses'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.losses}>
              L
            </SortHeaderCell>
          }
          cell={
            <MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='draws'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.draws}>
              D
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />
          }
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='form'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.form}>
              F
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={100}
          flexGrow={1}
        />
        <Column
          columnKey='clean_sheets'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.clean_sheets}>
              CS
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='goals_for'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.goals_for}>
              GF
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
        />
        <Column
          columnKey='goals_against'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.goals_against}>
              GA
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='goal_difference'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.goal_difference}>
              GD
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
        <Column
          columnKey='points'
          header={
            <SortHeaderCell
              onSortChange={this._onSortChange}
              onFilterChange={this._onFilterChange}
              sortDir={this.state.colSortDirs.points}>
              Pts
            </SortHeaderCell>
          }
          cell={<MyTextCell data={this.state.filteredDataList} />}
          width={55}
          flexGrow={1}
        />
      </Table>
    );
  }
}



TeamLadder.propTypes = {
  rows: React.PropTypes.array
};

module.exports = Dimensions({
  getHeight: function(element) {
    return window.innerHeight - 200;
  },
  getWidth: function(element) {
    var widthOffset = window.innerWidth < 680 ? 0 : 240;
    return window.innerWidth - widthOffset;
  }
})(TeamLadder);
