import React from 'react';
import {Table, Column, Cell} from 'fixed-data-table';

export default class MyLinkCell extends React.Component {
  render() {
    const {rowIndex, columnKey, url, id, data} = this.props;
    const link = url + data.getObjectAt(rowIndex)[id];
    const name = data.getObjectAt(rowIndex)[columnKey];
    return (
      <Cell>
        <a href={link}>{name}</a>
      </Cell>
    );
  }
}
