import React from 'react';
import {Table, Column, Cell} from 'fixed-data-table';

export default class MyTextCell extends React.Component {
  render() {
    const {rowIndex, data, columnKey} = this.props;
    return (
      <Cell>
        {data.getObjectAt(rowIndex)[columnKey]}
      </Cell>
    );
  }
}
