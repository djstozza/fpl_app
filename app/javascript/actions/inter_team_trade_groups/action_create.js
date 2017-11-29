import { CREATE_INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function createInterTeamTradeGroup (fplTeamId, fplTeamListId, inFplTeamListId, outPlayerId, inPlayerId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups.json`,
      method: 'post',
      data: {
        out_fpl_team_list_id: fplTeamListId,
        in_fpl_team_list_id: inFplTeamListId,
        out_player_id: outPlayerId,
        in_player_id: inPlayerId
      }
    }).then(res => {
        dispatch(createInterTeamTradeGroupAsync(res.data));
      });
  }
}

function createInterTeamTradeGroupAsync (data) {
  return {
    type: CREATE_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
