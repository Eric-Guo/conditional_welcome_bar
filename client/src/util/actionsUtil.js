const REQUEST = 'REQUEST';
const RECEIVE = 'RECEIVE';
const FAILURE = 'FAILURE';

export const actionTypes = base => (
  [REQUEST, RECEIVE, FAILURE].reduce((acc, type) => {
    acc[type] = `${base}_${type}`;
    return acc;
  }, {})
);

export const actionCreator = (type, payload = {}) => (
  { type, ...payload }
);
