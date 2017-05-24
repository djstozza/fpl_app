import React from 'react';

export default class DataListWrapper {
  constructor(indexMap, data) {
    this._indexMap = indexMap;
    this._data = data;
  }

  getSize() {
    if (this._indexMap == null) {
      return 0
    } else {
      return this._indexMap.length;
    }
  }

  getObjectAt(index) {
    return this._data[this._indexMap[index]]
  }
}
