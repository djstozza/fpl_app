"use strict";

import React from 'react';
import ReactDOM from 'react-dom';
import { Table, Column, Cell } from 'fixed-data-table-2';


import {DataCtxt, AddFilter} from '../../../../node_modules/fixed-data-table-2/examples/helpers/HOC'
import examplePropTypes from '../../../../node_modules/fixed-data-table-2/examples/helpers/examplePropTypes'
console.log( new FakeObjectDataListStore(100));

const FilterablePagingTable = AddFilter(DataCtxt(Table));

class PagedData {
  constructor(size = 2000) {
    this._dataList = new FakeObjectDataListStore(size);
    this._fetchSize = Math.ceil(size / 10);
    this._end = 50;
    this._pending = false;
    this._callbacks = [];
    this.runCallbacks = this.runCallbacks.bind(this);
  }

  setCallback(callback, id = 'base') {
    const newCallback = { id, fun: callback };

    let found = false;
    const newCallbacks = [];
    for (const cb of this._callbacks) {
      if (cb.id === id) {
        found = true;
        newCallbacks.push(newCallback);
      } else {
        newCallbacks.push(cb);
      }
    }

    if (!found) {
      newCallbacks.push(newCallback);
    }

    this._callbacks = newCallbacks;
  }

  runCallbacks() {
    for (const cb of this._callbacks) {
      cb.fun();
    }
  }

  getSize() {
    return this._dataList.getSize();
  }

  fetchRange(end) {
    if (this._pending) {
      return;
    }

    this._pending = true;
    new Promise(resolve => setTimeout(resolve, 1000))
    .then(() => {
      this._pending = false;
      this._end = end;
      this.runCallbacks();
    });
  }

  getObjectAt(index) {
    if (index >= this._end) {
      this.fetchRange(Math.min(this._dataList.getSize(),
                               index + this._fetchSize));
      return null;
    }

    return this._dataList.getObjectAt(index);
  }
}

class PendingCell extends React.PureComponent {
  render() {
    const { data, rowIndex, columnKey, dataVersion } = this.props;
    const rowObject = data.getObjectAt(rowIndex);
    return (
      <Cell>
        {rowObject ? rowObject[columnKey] : 'pending'}
      </Cell>
    );
  }
}

const PagedCell = (props, { data, version }) => (
  <PendingCell
    data={data}
    dataVersion={version}
  />);

PagedCell.contextTypes = {
  data: examplePropTypes.CtxtDataListStore,
  version: React.PropTypes.number,
};

export default class ContextExample extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      data: new PagedData(2000),
      filters: {
        firstName: '',
        lastName: '',
      },
    };

    this._onFilterChange = this._onFilterChange.bind(this);
  }

  _onFilterChange(name, value) {
    const filters = this.state.filters;
    filters[name] = value;
    this.setState({
      filters,
    });
  }

  render() {
    const { data, filters } = this.state;

    return (
      <div>
        <strong>Filter by:</strong>&nbsp;
        <input
          onChange={e => this._onFilterChange('firstName', e.target.value)}
          placeholder="First Name"
        />&nbsp;
        <input
          onChange={e => this._onFilterChange('lastName', e.target.value)}
          placeholder="Last Name"
        />
        <br />
        <FilterablePagingTable
          rowHeight={50}
          data={data}
          filters={filters}
          headerHeight={50}
          width={1000}
          height={500}
          {...this.props}
        >
          <Column
            columnKey="firstName"
            header={<Cell>First</Cell>}
            cell={<PagedCell />}
            fixed={true}
            width={100}
          />
          <Column
            columnKey="lastName"
            header={<Cell>Last Name</Cell>}
            cell={<PagedCell />}
            fixed={true}
            width={100}
          />
          <Column
            columnKey="city"
            header={<Cell>City</Cell>}
            cell={<PagedCell />}
            width={100}
          />
          <Column
            columnKey="street"
            header={<Cell>Street</Cell>}
            cell={<PagedCell />}
            width={200}
          />
          <Column
            columnKey="zipCode"
            header={<Cell>Zip Code</Cell>}
            cell={<PagedCell />}
            width={200}
          />
        </FilterablePagingTable>
      </div>
    );
  }
}

ReactDOM.render(
  <ContextExample />,
  document.getElementById('team-ladder')
)
