import { ADD_TO_INTER_TEAM_TRADE_GROUP, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function addToInterTeamTradeGroup (fplTeamId, tradeGroupId, outPlayerId, inPlayerId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        out_player_id: outPlayerId,
        in_player_id: inPlayerId,
        trade_action: 'AddToGroup'
      }
    }).then(res => {
      dispatch(addToInterTeamTradeGroupAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function addToInterTeamTradeGroupAsync (data) {
  return {
    type: ADD_TO_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
