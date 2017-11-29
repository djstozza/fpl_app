import { INTER_TEAM_TRADE_GROUPS } from '../types';
import axios from 'axios';

export default function fetchInterTeamTradeGroups (fplTeamId, fplTeamListId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups.json`)
      .then(res => {
        dispatch(fetchInterTeamTradeGroupsAsync(res.data));
      });
  }
}

function fetchInterTeamTradeGroupsAsync (data) {
  return {
    type: INTER_TEAM_TRADE_GROUPS,
    payload: data
  };
}
