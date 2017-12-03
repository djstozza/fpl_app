import { DELETE_INTER_TEAM_TRADE_GROUP, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function deleteInterTeamTradeGroup (fplTeamId, tradeGroupId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'delete'
    }).then(res => {
      dispatch(deleteInterTeamTradeGroupAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function deleteInterTeamTradeGroupAsync (data) {
  return {
    type: DELETE_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
