import { SUBMIT_INTER_TEAM_TRADE_GROUP, SHOW_ERRORS } from '../types';
import axios from 'axios';

export default function submitInterTeamTradeGroup (fplTeamId, tradeGroupId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        trade_action: 'Submit'
      }
    }).then(res => {
      dispatch(submitInterTeamTradeGroupAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });
  }
}

function submitInterTeamTradeGroupAsync (data) {
  return {
    type: SUBMIT_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
