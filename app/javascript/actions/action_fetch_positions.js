import { FETCH_POSITIONS } from './types';
import axios from 'axios';

export default function fetchPositions () {
  return dispatch => {
    axios.get('/positions.json')
      .then(res => {
        dispatch(fetchPositionsAsync(res.data));
      });
  }
}

function fetchPositionsAsync (data) {
  return {
    type: FETCH_POSITIONS,
    payload: data
  };
}
