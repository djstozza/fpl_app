import React from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import {Table, Column, Cell} from 'fixed-data-table-2';
import DataListWrapper from '../packs/tables/common/data_list_wrapper.js.jsx';
import MyTextCell from '../packs/tables/common/text_cell.js.jsx';
import MyLinkCell from '../packs/tables/common/link_cell.js.jsx';
import SortHeaderCell from '../packs/tables/common/sort_header_cell.js.jsx';
import ColourCell from '../packs/tables/common/colour_cell.js.jsx';
const Dimensions = require('react-dimensions');
import ReactTooltip from 'react-tooltip';

var SortTypes = {
  ASC: 'ASC',
  DESC: 'DESC',
};

function reverseSortDirection(sortDir) {
  return sortDir === SortTypes.DESC ? SortTypes.ASC : SortTypes.DESC;
}

export default class TeamFixture extends React.Component {
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
      <div>
        <Table
          rowsCount={this.state.filteredDataList.getSize()}
          rowHeight={30}
          headerHeight={60}
          width={this.props.containerWidth}
          height={32 + ((this.state.filteredDataList.getSize() + 1) * 30)}>
          <Column
            columnKey='round_id'
            header={
              <SortHeaderCell
                onSortChange={this._onSortChange}
                onFilterChange={this._onFilterChange}
                sortDir={this.state.colSortDirs.round_id}
                tooltip='Round'>
                R
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
                sortDir={this.state.colSortDirs.kickoff_time}
                tooltip='Kickoff Time'>
                KT
              </SortHeaderCell>
            }
            cell={<MyTextCell data={this.state.filteredDataList} />}
            width={100}
            flexGrow={1}
          />
          <Column
            columnKey='opponent'
            header={
              <SortHeaderCell
                onSortChange={this._onSortChange}
                onFilterChange={this._onFilterChange}
                sortDir={this.state.colSortDirs.opponent}
                tooltip='Opponent'>
                O
              </SortHeaderCell>
            }
            cell={
              <MyLinkCell
                data={this.state.filteredDataList}
                url='/teams/'
                id='opponent_id'
              />
            }
            width={100}
            flexGrow={1}
          />
          <Column
            columnKey='result'
            header={
              <SortHeaderCell
                onSortChange={this._onSortChange}
                onFilterChange={this._onFilterChange}
                sortDir={this.state.colSortDirs.result}
                tooltip='Result'>
                R
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
                sortDir={this.state.colSortDirs.leg}
                tooltip='Home/Away'>
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
                sortDir={this.state.colSortDirs.score}
                tooltip='Score'>
                S
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
                sortDir={this.state.colSortDirs.advantage}
                tooltip='Advantage'>
                A
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
      <ReactTooltip />
      </div>
    );
  }
}

TeamFixture.propTypes = {
  rows: React.PropTypes.array,
  team: React.PropTypes.object
};

module.exports = Dimensions({
  getHeight: function(element) {
    return window.innerHeight - 200;
  },
  getWidth: function(element) {
    var widthOffset = window.innerWidth < 680 ? 0 : 240;
    return window.innerWidth - widthOffset;
  }
})(TeamFixture);
