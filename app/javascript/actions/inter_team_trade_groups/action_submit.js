import { SUBMIT_INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function submitInterTeamTradeGroup (fplTeamId, fplTeamListId, tradeGroupId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        trade_action: 'Submit'
      }
    }).then(res => {
      dispatch(submitInterTeamTradeGroupAsync(res.data));
    });
  }
}

function submitInterTeamTradeGroupAsync (data) {
  return {
    type: SUBMIT_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
