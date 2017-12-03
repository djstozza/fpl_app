import { REMOVE_INTER_TEAM_TRADE } from '../types';
import axios from 'axios';

export default function removeInterTeamTrade (fplTeamId, tradeGroupId, interTeamTradeId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/inter_team_trade_groups/${tradeGroupId}`,
      method: 'put',
      data: {
        inter_team_trade_id: interTeamTradeId,
        trade_action: 'RemoveFromTradeGroup'
      }
    }).then(res => {
      dispatch(removeInterTeamTradeAsync(res.data));
    });
  }
}

function removeInterTeamTradeAsync (data) {
  return {
    type: REMOVE_INTER_TEAM_TRADE,
    payload: data
  };
}
