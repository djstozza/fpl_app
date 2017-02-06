$(document).ready ->
  # Adapted from https://gist.github.com/tim-reynolds/3019761
  centerItVariableWidth = (target, outer) ->
    out = $(outer)
    tar = $(target)
    x = out.width()
    y = tar.outerWidth(true)
    z = tar.index()
    q = 0
    m = out.find('li')
    i = 0
    while i < z
      q += $(m[i]).outerWidth(true)
      i++
    out.scrollLeft Math.max(0, q - ((x - y) / 2))

  # Sets the active tab as the centre of the horizontal scroll nav bar
  centerItVariableWidth('li.active', '.js-scrollable-nav')

  makeFixtureActive = (id) ->
    if $(".js-pending-fixture-#{id}").length
      $(".js-pending-fixture-#{id}").wrap("<a aria-controls='sharing-tab-#{id}' aria-expanded='false' " +
                                          "data-parent='#accordion-sharing-#{id}' data-toggle='collapse' " +
                                          "href='#sharing-tab-#{id}' role='button'></a>")


  populateFixtureStats = ->
    $.getJSON "/rounds/#{window.fplVars.round_id}", (data) ->
      for fixture, i in data.fixtures
        if fixture.fixture.started
          $('.js-fixture-desc').eq(i).html(" #{fixture.fixture.team_h_score} - #{fixture.fixture.team_a_score} ")
          $('.js-away-team-score').eq(i).text(fixture.fixture.team_a_score)
          $('.js-home-team-score').eq(i).text(fixture.fixture.team_h_score)
          makeFixtureActive(fixture.fixture.id)
          for keyStat in Object.keys(fixture.stats)
            keyStatStr = keyStat.replace('_', '-')
            for teamStat in Object.keys(fixture.stats[keyStat])
              teamStatStr = teamStat.replace('_', '-')
              stat_players_arr = []
              stat_values_arr = []
              for stat in fixture.stats[keyStat][teamStat]
                stat_players_arr.push("<p>#{stat.player}</p>")
                stat_values_arr.push("<p>#{stat.value}</p>")
                $(".js-#{keyStatStr}-#{teamStatStr}-players").eq(i).html(stat_players_arr)
                $(".js-#{keyStatStr}-#{teamStatStr}-values").eq(i).html(stat_values_arr)
        else
          $('.js-fixture-desc').eq(i).html(" #{fixture.kickoff_time} ")

  populateFixtureStats()
  setInterval((-> populateFixtureStats()), 180000)
