import React from 'react';
import {Table, Column, Cell} from 'fixed-data-table-2';
import ReactTooltip from 'react-tooltip';

var SortTypes = {
  ASC: 'ASC',
  DESC: 'DESC',
};

function reverseSortDirection(sortDir) {
  return sortDir === SortTypes.DESC ? SortTypes.ASC : SortTypes.DESC;
}

export default class SortHeaderCell extends React.Component {
  constructor(props) {
    super(props);
    this._onSortChange = this._onSortChange.bind(this);
    this._onFilterChange = this._onFilterChange.bind(this);
  }

  render() {
    var {sortDir, children, tooltip} = this.props;
    console.log(this.props);
    return (
      <Cell>
        <div>
        <a
          onClick={this._onSortChange}
          data-tip={tooltip}
          onMouseEnter={() => { ReactTooltip.show(); }}
          onMouseLeave={() => { ReactTooltip.hide(); }}>
          {children} {sortDir ? (sortDir === SortTypes.DESC ? '↓' : '↑') : ''}
        </a>
        <br/>
        <input className={this.props.columnKey + ' filter'} style={{width:90+'%'}} onChange={this._onFilterChange}/>
        </div>
      </Cell>

    );
  }

  _onSortChange(e) {
    e.preventDefault();

    if (this.props.onSortChange) {
      this.props.onSortChange(
        this.props.columnKey,
        this.props.sortDir ?
          reverseSortDirection(this.props.sortDir) :
          SortTypes.DESC
      );
    }
  }

  _onFilterChange(e) {
    this.props.onFilterChange(e, this.props.columnKey);
  }
}
