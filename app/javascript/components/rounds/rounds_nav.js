import React from 'react';
import { centerItVariableWidth } from '../../utils/nav_tab.js';

export default class RoundsNav extends React.Component {
  selectRoundClick (roundTabClass, roundId) {
    document.querySelector('li.active').classList.remove('active');
    document.querySelector(`li.${roundTabClass}`).classList.add('active');
    this.centerItVariableWidth('li.active', '.js-scrollable-nav');
    this.dataSource(roundId);
  }

  // Adapted from https://gist.github.com/tim-reynolds/3019761
  centerItVariableWidth (target, outer) {
    var out = document.querySelector(outer);
    var tar = document.querySelector(target);
    var x = out.clientWidth;
    var y = this.outerWidth(tar);
    var z = this.indexInParent(tar);
    var q = 0;
    var m = out.querySelectorAll('li');

    for (var i = 0; i < z; i++) {
      q += this.outerWidth(m[i]);
    }
    out.scrollLeft = (Math.max(0, q - (x - y)/2));
  }

  outerWidth (el) {
    var width = el.offsetWidth;
    var style = getComputedStyle(el);

    width += parseInt(style.marginLeft) + parseInt(style.marginRight);
    return width;
  }

  indexInParent (node) {
    var children = node.parentNode.childNodes;
    var num = 0;
    for (var i=0; i < children.length; i++) {
      if (children[i] == node) return num;
      if (children[i].nodeType == 1) num++;
    }
    return -1;
  }

  dataSource (roundId) {
    this.props.onChange(roundId);
  }

  componentDidMount () {
    this.centerItVariableWidth('li.active', '.js-scrollable-nav');
  }

  render () {
    var self = this;
    var roundId = this.props.round.id;
    var roundList = this.props.rounds.map(function (round) {
      var roundTabClass = `round-tab-${round.id}`
      return (
        <li key={round.id} className={`${round.id == roundId ? 'active' : ''} presenter ${roundTabClass}`}>
          <a href="javascript:;" onClick={function () {self.selectRoundClick(roundTabClass, round.id)}}>
            {round.name}
          </a>
        </li>
      );
    });
    return (
      <div className='row'>
        <div className= 'col-sm-12'>
          <ul className='nav nav-tabs js-scrollable-nav' role='tablist'>
            { roundList }
          </ul>
        </div>
      </div>
    )
  }
}