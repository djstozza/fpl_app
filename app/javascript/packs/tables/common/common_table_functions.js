export const SortTypes =  { ASC: 'ASC', DESC: 'DESC' };

export function reverseSortDirection (sortDir) {
  return sortDir === SortTypes.DESC ? SortTypes.ASC : SortTypes.DESC;
}
