class CompleteMiniDraftPickForm < ApplicationInteraction
  object :league, class: League
  object :league_decorator,
         class: LeagueMiniDraftPicksDecorator,
         default: -> { LeagueMiniDraftPicksDecorator.new(league) }

  string :season, default: -> { league_decorator.season }

end
