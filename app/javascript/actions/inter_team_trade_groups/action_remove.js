import { REMOVE_INTER_TEAM_TRADE } from '../types';
import axios from 'axios';

export default function removeInterTeamTrade (fplTeamId, fplTeamListId, tradeGroupId, interTeamTradeId) {
  return dispatch => {
    axios({
      url: `/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups/${tradeGroupId}.json`,
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
