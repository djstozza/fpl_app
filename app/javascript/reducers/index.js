import { combineReducers } from 'redux';
import PositionsReducer from './reducer_positions';
import TeamsReducer from './reducer_teams';
import RoundsReducer from './reducer_rounds';
import TeamReducer from './reducer_team';
import PlayersReducer from './reducer_players';
import PlayerReducer from './reducer_player';
import LeagueReducer from './reducer_league';
import DraftPicksReducer from './reducer_draft_picks';
import FplTeamReducer from './reducer_fpl_team';
import FplTeamListsReducer from './reducer_fpl_team_lists';
import TradePlayersReducer from './reducer_trade_players';
import WaiverPicksReducer from './reducer_waiver_picks';
import MiniDraftPicksReducer from './reducer_mini_draft_picks';
import InterTeamTradeGroupsReducer from './reducer_inter_team_trade_groups';

const rootReducer = combineReducers({
  PositionsReducer: PositionsReducer,
  TeamsReducer: TeamsReducer,
  RoundsReducer: RoundsReducer,
  TeamReducer: TeamReducer,
  PlayersReducer: PlayersReducer,
  PlayerReducer: PlayerReducer,
  LeagueReducer: LeagueReducer,
  DraftPicksReducer: DraftPicksReducer,
  FplTeamReducer: FplTeamReducer,
  FplTeamListsReducer: FplTeamListsReducer,
  TradePlayersReducer: TradePlayersReducer,
  WaiverPicksReducer: WaiverPicksReducer,
  MiniDraftPicksReducer: MiniDraftPicksReducer,
  InterTeamTradeGroupsReducer: InterTeamTradeGroupsReducer
});

export default rootReducer;
