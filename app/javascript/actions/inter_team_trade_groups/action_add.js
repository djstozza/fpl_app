import { ADD_TO_INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function addToInterTeamTradeGroup (fplTeamId, fplTeamListId, tradeGroupId, outPlayerId, inPlayerId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        out_player_id: outPlayerId,
        in_player_id: inPlayerId,
        trade_action: 'AddToGroup'
      }
    }).then(res => {
      dispatch(addToInterTeamTradeGroupAsync(res.data));
    });
  }
}

function addToInterTeamTradeGroupAsync (data) {
  return {
    type: ADD_TO_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
