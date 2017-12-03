import { APPROVE_INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function approveInterTeamTradeGroup (fplTeamId, tradeGroupId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}.json`,
      method: 'put',
      data: {
        trade_action: 'Approve'
      }
    }).then(res => {
      dispatch(approveInterTeamTradeGroupAsync(res.data));
    });
  }
}

function approveInterTeamTradeGroupAsync (data) {
  return {
    type: APPROVE_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
