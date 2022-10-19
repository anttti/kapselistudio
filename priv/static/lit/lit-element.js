import { ReactiveElement as t } from "/lit/reactive-element.js";
export * from "/lit/reactive-element.js";
import { render as e, noChange as i } from "/lit/lit-html.js";
export * from "/lit/lit-html.js";

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
var l, o;
const r = t;
class s extends t {
  constructor() {
    super(...arguments),
      (this.renderOptions = {
        host: this,
      }),
      (this._$Dt = void 0);
  }
  createRenderRoot() {
    var t, e;
    const i = super.createRenderRoot();
    return (
      (null !== (t = (e = this.renderOptions).renderBefore) && void 0 !== t) ||
        (e.renderBefore = i.firstChild),
      i
    );
  }
  update(t) {
    const i = this.render();
    this.hasUpdated || (this.renderOptions.isConnected = this.isConnected),
      super.update(t),
      (this._$Dt = e(i, this.renderRoot, this.renderOptions));
  }
  connectedCallback() {
    var t;
    super.connectedCallback(),
      null === (t = this._$Dt) || void 0 === t || t.setConnected(!0);
  }
  disconnectedCallback() {
    var t;
    super.disconnectedCallback(),
      null === (t = this._$Dt) || void 0 === t || t.setConnected(!1);
  }
  render() {
    return i;
  }
}
(s.finalized = !0),
  (s._$litElement$ = !0),
  null === (l = globalThis.litElementHydrateSupport) ||
    void 0 === l ||
    l.call(globalThis, {
      LitElement: s,
    });
const n = globalThis.litElementPolyfillSupport;
null == n ||
  n({
    LitElement: s,
  });
const h = {
  _$AK: (t, e, i) => {
    t._$AK(e, i);
  },
  _$AL: (t) => t._$AL,
};
(null !== (o = globalThis.litElementVersions) && void 0 !== o
  ? o
  : (globalThis.litElementVersions = [])
).push("3.2.0");
export { s as LitElement, r as UpdatingElement, h as _$LE };
