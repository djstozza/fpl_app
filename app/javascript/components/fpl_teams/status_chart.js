import React, { Component } from 'react';
import { Bar } from 'react-chartjs-2';
import _ from 'underscore';

export default class StatusChart extends Component {
  constructor (props) {
    super(props);
  }

  data () {
    return {
      labels: _.map(this.props.rounds, (obj) => { return obj.id }),
      datasets: [{
        label: 'Rank',
        type:'line',
        data: _.map(this.props.fpl_team_lists, (obj) => { return obj.rank }),
        fill: false,
        borderColor: '#ff4d4d',
        backgroundColor: '#ff4d4d',
        pointBorderColor: '#ff4d4d',
        pointBackgroundColor: '#ff4d4d',
        pointHoverBackgroundColor: '#ff4d4d',
        pointHoverBorderColor: '#ff4d4d',
        yAxisID: 'y-axis-2'
      },{
        type: 'bar',
        label: 'Score',
        data: _.map(this.props.fpl_team_lists, (obj) => { return obj.total_score} ),
        fill: false,
        backgroundColor: '#4dff4d',
        borderColor: '#4dff4d',
        hoverBackgroundColor: '#4dff4d',
        hoverBorderColor: '#4dff4d',
        yAxisID: 'y-axis-1'
      }]
    }
  }

  options () {
    return {
      responsive: true,
      tooltips: {
        mode: 'label'
      },
      elements: {
        line: {
          fill: false
        }
      },
      scales: {
        xAxes: [
          {
            display: true,
            gridLines: {
              display: false
            },
            labels: {
              show: true
            },
            scaleLabel: {
              display: true,
              labelString: 'Rounds',
            },
          }
        ],
        yAxes: [
          {
            type: 'linear',
            display: true,
            position: 'left',
            id: 'y-axis-1',
            gridLines: {
              display: false
            },
            labels: {
              show: true
            },
            scaleLabel: {
              display: true,
              labelString: 'Score',
            },
          },
          {
            type: 'linear',
            display: true,
            position: 'right',
            id: 'y-axis-2',
            gridLines: {
              display: false
            },
            labels: {
              show: true
            },
            scaleLabel: {
              display: true,
              labelString: 'Rank',
            },
            ticks: {
              reverse: true,
              suggestedMin: 1,
              suggestedMax: this.props.fpl_teams.length
            },
          }
        ]
      }
    }
  }

  render () {
    return (
      <div>
        <h2>Team Status</h2>
        <Bar
          data={ this.data() }
          options={ this.options() }
        />
      </div>
    );
  }
}
