import { CREATE_INTER_TEAM_TRADE_GROUP, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function createInterTeamTradeGroup (fplTeamId, outPlayerId, inFplTeamListId, inPlayerId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups.json`,
      method: 'post',
      data: {
        in_fpl_team_list_id: inFplTeamListId,
        out_player_id: outPlayerId,
        in_player_id: inPlayerId
      }
    }).then(res => {
      dispatch(createInterTeamTradeGroupAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function createInterTeamTradeGroupAsync (data) {
  return {
    type: CREATE_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
