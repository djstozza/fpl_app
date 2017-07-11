import { FETCH_ROUNDS } from './types';
import axios from 'axios';

export default function fetchRounds () {
  return dispatch => {
    axios.get('/rounds.json')
      .then(res => {
        dispatch(fetchRoundsAsync(res.data));
      });
  }
}

function fetchRoundsAsync (data) {
  return {
    type: FETCH_ROUNDS,
    payload: data
  };
}
