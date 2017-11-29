import { INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function fetchInterTeamTradeGroup (fplTeamId, fplTeamListId, tradeGroupId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups/${tradeGroupId}.json`)
      .then(res => {
        dispatch(fetchInterTeamTradeGroupAsync(res.data));
      });
  }
}

function fetchInterTeamTradeGroupAsync (data) {
  return {
    type: INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
