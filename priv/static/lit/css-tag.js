/**
 * @license
 * Copyright 2019 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const t = window,
  e =
    t.ShadowRoot &&
    (void 0 === t.ShadyCSS || t.ShadyCSS.nativeShadow) &&
    "adoptedStyleSheets" in Document.prototype &&
    "replace" in CSSStyleSheet.prototype,
  s = Symbol(),
  n = new WeakMap();
class o {
  constructor(t, e, n) {
    if (((this._$cssResult$ = !0), n !== s))
      throw Error(
        "CSSResult is not constructable. Use `unsafeCSS` or `css` instead."
      );
    (this.cssText = t), (this.t = e);
  }
  get styleSheet() {
    let t = this.o;
    const s = this.t;
    if (e && void 0 === t) {
      const e = void 0 !== s && 1 === s.length;
      e && (t = n.get(s)),
        void 0 === t &&
          ((this.o = t = new CSSStyleSheet()).replaceSync(this.cssText),
          e && n.set(s, t));
    }
    return t;
  }
  toString() {
    return this.cssText;
  }
}
const r = (t) => new o("string" == typeof t ? t : t + "", void 0, s),
  i = (t, ...e) => {
    const n =
      1 === t.length
        ? t[0]
        : e.reduce(
            (e, s, n) =>
              e +
              ((t) => {
                if (!0 === t._$cssResult$) return t.cssText;
                if ("number" == typeof t) return t;
                throw Error(
                  "Value passed to 'css' function must be a 'css' function result: " +
                    t +
                    ". Use 'unsafeCSS' to pass non-literal values, but take care to ensure page security."
                );
              })(s) +
              t[n + 1],
            t[0]
          );
    return new o(n, t, s);
  },
  S = (s, n) => {
    e
      ? (s.adoptedStyleSheets = n.map((t) =>
          t instanceof CSSStyleSheet ? t : t.styleSheet
        ))
      : n.forEach((e) => {
          const n = document.createElement("style"),
            o = t.litNonce;
          void 0 !== o && n.setAttribute("nonce", o),
            (n.textContent = e.cssText),
            s.appendChild(n);
        });
  },
  c = e
    ? (t) => t
    : (t) =>
        t instanceof CSSStyleSheet
          ? ((t) => {
              let e = "";
              for (const s of t.cssRules) e += s.cssText;
              return r(e);
            })(t)
          : t;
export {
  o as CSSResult,
  S as adoptStyles,
  i as css,
  c as getCompatibleStyle,
  e as supportsAdoptingStyleSheets,
  r as unsafeCSS,
};
