export function centerItVariableWidth (target, outer) {
  var out = document.querySelector(outer);
  var tar = document.querySelector(target);
  if (out == null || tar == null) {
    return;
  }
  var x = out.clientWidth;
  var y = this.outerWidth(tar);
  var z = this.indexInParent(tar);
  var q = 0;
  var m = out.querySelectorAll('li');

  for (var i = 0; i < z; i++) {
    q += this.outerWidth(m[i]);
  }
  out.scrollLeft = (Math.max(0, q - (x - y)/2));
}

export function outerWidth (el) {
  var width = el.offsetWidth;
  var style = getComputedStyle(el);

  width += parseInt(style.marginLeft) + parseInt(style.marginRight);
  return width;
}

export function indexInParent (node) {
  var children = node.parentNode.childNodes;
  var num = 0;
  for (var i=0; i < children.length; i++) {
    if (children[i] == node) return num;
    if (children[i].nodeType == 1) num++;
  }
  return -1;
}
