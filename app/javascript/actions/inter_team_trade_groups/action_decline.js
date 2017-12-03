import { DECLINE_INTER_TEAM_TRADE_GROUP, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function declineInterTeamTradeGroup (fplTeamId, tradeGroupId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        trade_action: 'Decline'
      }
    }).then(res => {
      dispatch(declineInterTeamTradeGroupAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function declineInterTeamTradeGroupAsync (data) {
  return {
    type: DECLINE_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
