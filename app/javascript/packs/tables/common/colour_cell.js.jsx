import React from 'react';
import {Table, Column, Cell} from 'fixed-data-table';

export default class ColourCell extends React.Component {
  render() {
    const {rowIndex, data, columnKey, selector} = this.props;
    console.log()
    return (
      <Cell className={data.getObjectAt(rowIndex)[selector]}>
        <div className={data.getObjectAt(rowIndex)[columnKey]}/>
      </Cell>
    );
  }
}
