import { FETCH_PLAYERS } from './types';
import axios from 'axios';

export default function fetchPlayers() {
  return dispatch => {
    axios.get('/players.json')
      .then(res => {
        dispatch(fetchPlayersAsync(res.data));
      });
  }
}

function fetchPlayersAsync(data){
  return {
    type: FETCH_PLAYERS,
    payload: data
  };
}
