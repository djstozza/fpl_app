$(document).ready ->
  return unless $('body').hasClass('controller-rounds')
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
      for match, i in data.fixtures
        if match.fixture.started
          homeTeamScore = match.fixture.team_h_score || 0
          awayTeamScore = match.fixture.team_a_score || 0
          $('.js-fixture-desc').eq(i).html(" #{homeTeamScore} - #{awayTeamScore} ")
          $('.js-away-team-score').eq(i).text(awayTeamScore)
          $('.js-home-team-score').eq(i).text(homeTeamScore)
          makeFixtureActive(match.fixture.id)
          for keyStat in Object.keys(match.stats)
            keyStatStr = keyStat.replace('_', '-')
            $(".js-#{keyStatStr}-tooltip").tooltip()
            for teamStat in Object.keys(match.stats[keyStat])
              teamStatStr = teamStat.replace('_', '-')
              stat_players_arr = []
              stat_values_arr = []
              for stat in match.stats[keyStat][teamStat]
                stat_players_arr.push("<p>#{stat.player}</p>")
                stat_values_arr.push("<p>#{stat.value}</p>")
                $(".js-#{keyStatStr}-#{teamStatStr}-players").eq(i).html(stat_players_arr)
                $(".js-#{keyStatStr}-#{teamStatStr}-values").eq(i).html(stat_values_arr)
        else
          $('.js-fixture-desc').eq(i).html(" #{match.kickoff_time} ")

  populateFixtureStats()
  setInterval((-> populateFixtureStats()), 180000)
