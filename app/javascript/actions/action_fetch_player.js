import { FETCH_PLAYER } from './types';
import axios from 'axios';

export default function fetchPlayers (playerId) {
  return dispatch => {
    axios.get(`/players/${playerId}.json`)
      .then(res => {
        dispatch(fetchPlayerAsync(res.data));
      });
  }
}

function fetchPlayerAsync (data) {
  return {
    type: FETCH_PLAYER,
    payload: data
  };
}
