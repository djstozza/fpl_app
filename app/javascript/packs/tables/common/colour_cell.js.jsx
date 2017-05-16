import React from 'react';
import {Table, Column, Cell} from 'fixed-data-table-2';

export default class ColourCell extends React.Component {
  render() {
    const {rowIndex, data, columnKey, selector} = this.props;
    return (
      <Cell className={data.getObjectAt(rowIndex)[selector]}>
        <div className={data.getObjectAt(rowIndex)[columnKey]}/>
      </Cell>
    );
  }
}
