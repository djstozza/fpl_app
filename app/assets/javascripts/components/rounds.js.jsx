var Rounds = React.createClass({
  getInitialState: function () {
    return {
      round: this.props.round,
      fixtures: this.props.fixtures,
    }
  },

  selectRoundClick: function (roundTabClass, roundId) {
    document.querySelector('li.active').classList.remove('active');
    document.querySelector('li.' + roundTabClass).classList.add('active');
    this.centerItVariableWidth('li.active', '.js-scrollable-nav');
    this.dataSource(roundId);
  },

  // Adapted from https://gist.github.com/tim-reynolds/3019761
  centerItVariableWidth: function (target, outer){
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
   },

   outerWidth: function (el) {
     var width = el.offsetWidth;
     var style = getComputedStyle(el);

     width += parseInt(style.marginLeft) + parseInt(style.marginRight);
     return width;
   },

  indexInParent: function (node) {
    var children = node.parentNode.childNodes;
    var num = 0;
    for (var i=0; i < children.length; i++) {
      if (children[i] == node) return num;
      if (children[i].nodeType == 1) num++;
    }
    return -1;
  },

  dataSource: function (roundId) {
    var self = this;
    var roundId = roundId || this.state.round.id;
    $.getJSON(
      '/rounds/' + roundId,
      function (data) {
        self.setState({
          round: data.round,
          fixtures: data.fixtures
        })
    });
  },

  componentDidMount: function () {
    var self = this;
    this.centerItVariableWidth('li.active', '.js-scrollable-nav')
    setInterval(function () {
      if (self.state.round.is_current && !self.state.round.data_checked) {
        self.dataSource();
      }
    }, 60000);
  },

  shouldComponentUpdate: function (nextProps, nextState) {
    return nextState !== this.state;
  },

  render: function() {
    var self = this;
    var roundId = this.props.round.id;
    var roundList = this.props.rounds.map(function (round) {
      var roundTabClass = 'round-tab-' + round.id
      if (round.id == roundId) {
        return (
          <li key={round.id} className={'active presenter ' + roundTabClass}>
            <a href="javascript:;" onClick={function () {self.selectRoundClick(roundTabClass, round.id)}}>
              {round.name}
            </a>
          </li>
        );
      } else {
        return (
        <li key={round.id} className={'presenter ' + roundTabClass}>
          <a href="javascript:;" onClick={ function () { self.selectRoundClick(roundTabClass, round.id) } } >
            {round.name}
          </a>
        </li>
        );
      }
    });

    return (
      <div>
        <div className='container'>
          <div className='row'>
            <div className= 'col-sm-12'>
              <ul className='nav nav-tabs js-scrollable-nav' role='tablist'>
                { roundList }
              </ul>
            </div>
          </div>
        </div>
        < Round round={this.state.round} fixtures={this.state.fixtures} />
      </div>
    )
  }
});
