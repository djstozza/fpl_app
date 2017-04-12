@Round = React.createClass({
  render: ->
    React.DOM.div
      className: 'container'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-md-offset-3 col-md-6',
          for fixtureGroup in this.props.data.round.fixture_groups
            React.DOM.div
              key: fixtureGroup.game_day
              React.DOM.b key: fixtureGroup.game_day, fixtureGroup.game_day
              for match in fixtureGroup.fixtures
                React.DOM.p null, 'hello'
                React.DOM.div
                  key: "match-#{match.fixture.id}"
                  className: 'panel-group fixture-group'
                  'aria-multiselectable': true
                  role: 'tablist'
                  id: "accordion-sharing-group-#{match.fixture.id}"
                  React.DOM.div
                    className: 'panel'
                    React.DOM.div
                      className: 'panel-heading'
                      role: 'tab'
                      id: "accordion-sharing-#{match.fixture.id}"
                      if match.fixture.started
                        React.DOM.a
                          'aria-controls': "sharing-tab-#{match.fixture.id}"
                          'aria-expanded': false
                          'data-parent': "#accordion-sharing-#{match.fixture.id}"
                          'data-toggle': 'collapse'
                          href: "#sharing-tab-#{match.fixture.id}"
                          role: 'button'
                          React.DOM.span null, "#{match.home_team.short_name} "
                          React.DOM.img
                            className: match.home_team.short_name.toLowerCase()
                            src: '/assets/badges-sprite.jpg'
                            alt: 'Badge sprite'
                          React.DOM.span null,  " #{match.fixture.team_h_score} - #{match.fixture.team_a_score} "
                          React.DOM.img
                            className: match.away_team.short_name.toLowerCase()
                            src: '/assets/badges-sprite.jpg'
                            alt: 'Badge sprite'
                          React.DOM.span, null, " #{match.away_team.short_name}"
                      else
                        React.DOM.div
                          className: "pending-fixture-#{match.fixture.id}"
                          React.DOM.span, null, "#{match.home_team.short_name} "
                          React.DOM.img
                            className: match.home_team.short_name.toLowerCase()
                            src: '/assets/badges-sprite.jpg'
                            alt: 'Badge sprite'
                          React.DOM.span, null, " #{match.kickoff_time} "
                          React.DOM.img
                            className: match.away_team.short_name.toLowerCase()
                            src: '/assets/badges-sprite.jpg'
                            alt: 'Badge sprite'
                          React.DOM.span, null, " #{match.away_team.short_name}"
                      React.DOM.div
                        className: 'panel-collapse collapse'
                        'aria-labelledby': "accordion-sharing-#{match.fixture.id}"
                        role: 'tabpanel'
                        id: "sharing-tab-#{match.fixture.id}"
                        React.DOM.div
                          className: 'panel-body'
                          React.DOM.table
                            className: 'table table-striped table-bordered'
                            React.DOM.thead null,
                              React.DOM.tr null,
                                React.DOM.td null
                                React.DOM.td null,
                                  React.DOM.a
                                    href: "/teams/#{match.home_team.id}"
                                    React.DOM.b null, match.home_team.name
                                React.DOM.td null,
                                  React.DOM.b null, match.fixture.team_h_score
                                React.DOM.td null,
                                  React.DOM.a
                                    href: "/teams/#{match.away_team.id}"
                                    React.DOM.b null, match.away_team.name
                                React.DOM.td null,
                                  React.DOM.b null, match.fixture.team_a_score
                            React.DOM.tbody null,
                              for key, value of match.stats
                                React.DOM.tr key: "match-#{match.id}-#{key}",
                                  React.DOM.td null,
                                    React.DOM.b
                                      className: "js-tooltip",
                                      title: value.name,
                                      value.initials
                                  React.DOM.td null,
                                    for stat in Object.values(value.home_team)
                                      React.DOM.p key: stat.player, stat.player
                                  React.DOM.td null,
                                    for stat in Object.values(value.home_team)
                                      React.DOM.p key: "#{stat.player}-#{stat.value}", stat.value
                                  React.DOM.td null,
                                    for stat in Object.values(value.away_team)
                                      React.DOM.p key: stat.player, stat.player
                                  React.DOM.td null,
                                    for stat in Object.values(value.away_team)
                                      React.DOM.p key: "#{stat.player}-#{stat.value}", stat.value
})
