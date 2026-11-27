var bc=Object.defineProperty;var yc=(t,n)=>()=>(t&&(n=t(t=0)),n);var xc=(t,n)=>{for(var e in n)bc(t,e,{get:n[e],enumerable:!0})};var gc={};xc(gc,{default:()=>g2});function g2(t){let n;try{if(n=dc&&(self.URL||self.webkitURL).createObjectURL(dc),!n)throw"";let e=new Worker(n,{name:t?.name});return e.addEventListener("error",()=>{(self.URL||self.webkitURL).revokeObjectURL(n)}),e}catch{return new Worker("data:text/javascript;charset=utf-8,"+encodeURIComponent(fc),{name:t?.name})}}var fc,dc,mc=yc(()=>{fc=`(function() {
	//#region src/types.ts
	/**
	* Maps blur level to blur strength values.
	*/
	const BACKGROUND_BLUR_MAP = {
		low: 3,
		medium: 5,
		high: 7
	};
	//#endregion
	//#region ../../node_modules/@mediapipe/tasks-vision/vision_bundle.mjs
	var t = "undefined" != typeof self ? self : {};
	function e(e, n) {
		t: {
			for (var r = ["CLOSURE_FLAGS"], i = t, s = 0; s < r.length; s++) if (null == (i = i[r[s]])) {
				r = null;
				break t;
			}
			r = i;
		}
		return null != (e = r && r[e]) ? e : n;
	}
	function n() {
		throw Error("Invalid UTF8");
	}
	function r(t, e) {
		return e = String.fromCharCode.apply(null, e), null == t ? e : t + e;
	}
	let i;
	let s;
	const o = "undefined" != typeof TextDecoder;
	let a;
	const c = "undefined" != typeof TextEncoder;
	function h(t) {
		if (c) t = (a ||= new TextEncoder()).encode(t);
		else {
			let n = 0;
			const r = new Uint8Array(3 * t.length);
			for (let i = 0; i < t.length; i++) {
				var e = t.charCodeAt(i);
				if (e < 128) r[n++] = e;
				else {
					if (e < 2048) r[n++] = e >> 6 | 192;
					else {
						if (e >= 55296 && e <= 57343) {
							if (e <= 56319 && i < t.length) {
								const s = t.charCodeAt(++i);
								if (s >= 56320 && s <= 57343) {
									e = 1024 * (e - 55296) + s - 56320 + 65536, r[n++] = e >> 18 | 240, r[n++] = e >> 12 & 63 | 128, r[n++] = e >> 6 & 63 | 128, r[n++] = 63 & e | 128;
									continue;
								}
								i--;
							}
							e = 65533;
						}
						r[n++] = e >> 12 | 224, r[n++] = e >> 6 & 63 | 128;
					}
					r[n++] = 63 & e | 128;
				}
			}
			t = n === r.length ? r : r.subarray(0, n);
		}
		return t;
	}
	function u(e) {
		t.setTimeout((() => {
			throw e;
		}), 0);
	}
	var l;
	var f = e(610401301, !1);
	var d = e(748402147, !0);
	function p() {
		var e = t.navigator;
		return e && (e = e.userAgent) ? e : "";
	}
	const g = t.navigator;
	function m(t) {
		return m[" "](t), t;
	}
	l = g && g.userAgentData || null, m[" "] = function() {};
	const y = {};
	let _ = null;
	function v(t) {
		const e = t.length;
		let n = 3 * e / 4;
		n % 3 ? n = Math.floor(n) : -1 != "=.".indexOf(t[e - 1]) && (n = -1 != "=.".indexOf(t[e - 2]) ? n - 2 : n - 1);
		const r = new Uint8Array(n);
		let i = 0;
		return function(t, e) {
			function n(e) {
				for (; r < t.length;) {
					const e = t.charAt(r++), n = _[e];
					if (null != n) return n;
					if (!/^[\\s\\xa0]*$/.test(e)) throw Error("Unknown base64 encoding at char: " + e);
				}
				return e;
			}
			E();
			let r = 0;
			for (;;) {
				const t = n(-1), r = n(0), i = n(64), s = n(64);
				if (64 === s && -1 === t) break;
				e(t << 2 | r >> 4), 64 != i && (e(r << 4 & 240 | i >> 2), 64 != s && e(i << 6 & 192 | s));
			}
		}(t, (function(t) {
			r[i++] = t;
		})), i !== n ? r.subarray(0, i) : r;
	}
	function E() {
		if (!_) {
			_ = {};
			var t = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".split(""), e = [
				"+/=",
				"+/",
				"-_=",
				"-_.",
				"-_"
			];
			for (let n = 0; n < 5; n++) {
				const r = t.concat(e[n].split(""));
				y[n] = r;
				for (let t = 0; t < r.length; t++) {
					const e = r[t];
					void 0 === _[e] && (_[e] = t);
				}
			}
		}
	}
	var w = "undefined" != typeof Uint8Array;
	var T = !(!(f && l && l.brands.length > 0) && (-1 != p().indexOf("Trident") || -1 != p().indexOf("MSIE"))) && "function" == typeof btoa;
	const A = /[-_.]/g;
	const b = {
		"-": "+",
		_: "/",
		".": "="
	};
	function k(t) {
		return b[t] || "";
	}
	function S(t) {
		if (!T) return v(t);
		t = A.test(t) ? t.replace(A, k) : t, t = atob(t);
		const e = new Uint8Array(t.length);
		for (let n = 0; n < t.length; n++) e[n] = t.charCodeAt(n);
		return e;
	}
	function x(t) {
		return w && null != t && t instanceof Uint8Array;
	}
	var L = {};
	function R() {
		return M ||= new F(null, L);
	}
	function I(t) {
		C(L);
		var e = t.g;
		return null == (e = null == e || x(e) ? e : "string" == typeof e ? S(e) : null) ? e : t.g = e;
	}
	var F = class {
		h() {
			return new Uint8Array(I(this) || 0);
		}
		constructor(t, e) {
			if (C(e), this.g = t, null != t && 0 === t.length) throw Error("ByteString should be constructed with non-empty values");
		}
	};
	let M;
	let P;
	function C(t) {
		if (t !== L) throw Error("illegal external caller");
	}
	function O(t, e) {
		t.__closure__error__context__984382 || (t.__closure__error__context__984382 = {}), t.__closure__error__context__984382.severity = e;
	}
	function N(t) {
		return O(t = Error(t), "warning"), t;
	}
	function U(t, e) {
		if (null != t) {
			var n = P ??= {}, r = n[t] || 0;
			r >= e || (n[t] = r + 1, O(t = Error(), "incident"), u(t));
		}
	}
	function D() {
		return "function" == typeof BigInt;
	}
	var B = "function" == typeof Symbol && "symbol" == typeof Symbol();
	function G(t, e, n = !1) {
		return "function" == typeof Symbol && "symbol" == typeof Symbol() ? n && Symbol.for && t ? Symbol.for(t) : null != t ? Symbol(t) : Symbol() : e;
	}
	var j = G("jas", void 0, !0);
	var V = G(void 0, "0di");
	var X = G(void 0, "1oa");
	var H = G(void 0, Symbol());
	var W = G(void 0, "0ub");
	var z = G(void 0, "0ubs");
	var K = G(void 0, "0ubsb");
	var Y = G(void 0, "0actk");
	var q = G("m_m", "Pa", !0);
	var $ = G();
	const J = { Ga: {
		value: 0,
		configurable: !0,
		writable: !0,
		enumerable: !1
	} };
	const Z = Object.defineProperties;
	const Q = B ? j : "Ga";
	var tt;
	const et = [];
	function nt(t, e) {
		B || Q in t || Z(t, J), t[Q] |= e;
	}
	function rt(t, e) {
		B || Q in t || Z(t, J), t[Q] = e;
	}
	function it(t) {
		return nt(t, 34), t;
	}
	function st(t) {
		return nt(t, 8192), t;
	}
	rt(et, 7), tt = Object.freeze(et);
	var ot = {};
	function at(t, e) {
		return void 0 === e ? t.h !== ct && !!(2 & (0 | t.v[Q])) : !!(2 & e) && t.h !== ct;
	}
	const ct = {};
	function ht(t, e) {
		if (null != t) {
			if ("string" == typeof t) t = t ? new F(t, L) : R();
			else if (t.constructor !== F) if (x(t)) t = t.length ? new F(new Uint8Array(t), L) : R();
			else {
				if (!e) throw Error();
				t = void 0;
			}
		}
		return t;
	}
	var ut = class {
		constructor(t, e, n) {
			this.g = t, this.h = e, this.l = n;
		}
		next() {
			const t = this.g.next();
			return t.done || (t.value = this.h.call(this.l, t.value)), t;
		}
		[Symbol.iterator]() {
			return this;
		}
	};
	var lt = Object.freeze({});
	function ft(t, e, n) {
		const r = 128 & e ? 0 : -1, i = t.length;
		var s;
		(s = !!i) && (s = null != (s = t[i - 1]) && "object" == typeof s && s.constructor === Object);
		const o = i + (s ? -1 : 0);
		for (e = 128 & e ? 1 : 0; e < o; e++) n(e - r, t[e]);
		if (s) {
			t = t[i - 1];
			for (const e in t) !isNaN(e) && n(+e, t[e]);
		}
	}
	var dt = {};
	function pt(t) {
		return 128 & t ? dt : void 0;
	}
	function gt(t) {
		return t.Na = !0, t;
	}
	var mt = gt(((t) => "number" == typeof t));
	var yt = gt(((t) => "string" == typeof t));
	var _t = gt(((t) => "boolean" == typeof t));
	var vt = "function" == typeof t.BigInt && "bigint" == typeof t.BigInt(0);
	function Et(t) {
		var e = t;
		if (yt(e)) {
			if (!/^\\s*(?:-?[1-9]\\d*|0)?\\s*$/.test(e)) throw Error(String(e));
		} else if (mt(e) && !Number.isSafeInteger(e)) throw Error(String(e));
		return vt ? BigInt(t) : t = _t(t) ? t ? "1" : "0" : yt(t) ? t.trim() || "0" : String(t);
	}
	var wt = gt(((t) => vt ? t >= At && t <= kt : "-" === t[0] ? St(t, Tt) : St(t, bt)));
	const Tt = Number.MIN_SAFE_INTEGER.toString();
	const At = vt ? BigInt(Number.MIN_SAFE_INTEGER) : void 0;
	const bt = Number.MAX_SAFE_INTEGER.toString();
	const kt = vt ? BigInt(Number.MAX_SAFE_INTEGER) : void 0;
	function St(t, e) {
		if (t.length > e.length) return !1;
		if (t.length < e.length || t === e) return !0;
		for (let n = 0; n < t.length; n++) {
			const r = t[n], i = e[n];
			if (r > i) return !1;
			if (r < i) return !0;
		}
	}
	const xt = "function" == typeof Uint8Array.prototype.slice;
	let Lt;
	let Rt = 0;
	let It = 0;
	function Ft(t) {
		const e = t >>> 0;
		Rt = e, It = (t - e) / 4294967296 >>> 0;
	}
	function Mt(t) {
		if (t < 0) {
			Ft(-t);
			const [e, n] = jt(Rt, It);
			Rt = e >>> 0, It = n >>> 0;
		} else Ft(t);
	}
	function Pt(t) {
		const e = Lt ||= /* @__PURE__ */ new DataView(/* @__PURE__ */ new ArrayBuffer(8));
		e.setFloat32(0, +t, !0), It = 0, Rt = e.getUint32(0, !0);
	}
	function Ct(t, e) {
		const n = 4294967296 * e + (t >>> 0);
		return Number.isSafeInteger(n) ? n : Ut(t, e);
	}
	function Ot(t, e) {
		return Et(D() ? BigInt.asUintN(64, (BigInt(e >>> 0) << BigInt(32)) + BigInt(t >>> 0)) : Ut(t, e));
	}
	function Nt(t, e) {
		return D() ? Et(BigInt.asIntN(64, (BigInt.asUintN(32, BigInt(e)) << BigInt(32)) + BigInt.asUintN(32, BigInt(t)))) : Et(Bt(t, e));
	}
	function Ut(t, e) {
		if (t >>>= 0, (e >>>= 0) <= 2097151) var n = "" + (4294967296 * e + t);
		else D() ? n = "" + (BigInt(e) << BigInt(32) | BigInt(t)) : (t = (16777215 & t) + 6777216 * (n = 16777215 & (t >>> 24 | e << 8)) + 6710656 * (e = e >> 16 & 65535), n += 8147497 * e, e *= 2, t >= 1e7 && (n += t / 1e7 >>> 0, t %= 1e7), n >= 1e7 && (e += n / 1e7 >>> 0, n %= 1e7), n = e + Dt(n) + Dt(t));
		return n;
	}
	function Dt(t) {
		return t = String(t), "0000000".slice(t.length) + t;
	}
	function Bt(t, e) {
		if (2147483648 & e) if (D()) t = "" + (BigInt(0 | e) << BigInt(32) | BigInt(t >>> 0));
		else {
			const [n, r] = jt(t, e);
			t = "-" + Ut(n, r);
		}
		else t = Ut(t, e);
		return t;
	}
	function Gt(t) {
		if (t.length < 16) Mt(Number(t));
		else if (D()) t = BigInt(t), Rt = Number(t & BigInt(4294967295)) >>> 0, It = Number(t >> BigInt(32) & BigInt(4294967295));
		else {
			const e = +("-" === t[0]);
			It = Rt = 0;
			const n = t.length;
			for (let r = e, i = (n - e) % 6 + e; i <= n; r = i, i += 6) {
				const e = Number(t.slice(r, i));
				It *= 1e6, Rt = 1e6 * Rt + e, Rt >= 4294967296 && (It += Math.trunc(Rt / 4294967296), It >>>= 0, Rt >>>= 0);
			}
			if (e) {
				const [t, e] = jt(Rt, It);
				Rt = t, It = e;
			}
		}
	}
	function jt(t, e) {
		return e = ~e, t ? t = 1 + ~t : e += 1, [t, e];
	}
	function Vt(t) {
		return Array.prototype.slice.call(t);
	}
	const Xt = "function" == typeof BigInt ? BigInt.asIntN : void 0;
	const Ht = "function" == typeof BigInt ? BigInt.asUintN : void 0;
	const Wt = Number.isSafeInteger;
	const zt = Number.isFinite;
	const Kt = Math.trunc;
	const Yt = Et(0);
	function qt(t) {
		if (null != t && "number" != typeof t) throw Error(\`Value of float/double field must be a number, found \${typeof t}: \${t}\`);
		return t;
	}
	function $t(t) {
		return null == t || "number" == typeof t ? t : "NaN" === t || "Infinity" === t || "-Infinity" === t ? Number(t) : void 0;
	}
	function Jt(t) {
		if (null != t && "boolean" != typeof t) {
			var e = typeof t;
			throw Error(\`Expected boolean but got \${"object" != e ? e : t ? Array.isArray(t) ? "array" : e : "null"}: \${t}\`);
		}
		return t;
	}
	function Zt(t) {
		return null == t || "boolean" == typeof t ? t : "number" == typeof t ? !!t : void 0;
	}
	const Qt = /^-?([1-9][0-9]*|0)(\\.[0-9]+)?$/;
	function te(t) {
		switch (typeof t) {
			case "bigint": return !0;
			case "number": return zt(t);
			case "string": return Qt.test(t);
			default: return !1;
		}
	}
	function ee(t) {
		if (null == t) return t;
		if ("string" == typeof t && t) t = +t;
		else if ("number" != typeof t) return;
		return zt(t) ? 0 | t : void 0;
	}
	function ne(t) {
		if (null == t) return t;
		if ("string" == typeof t && t) t = +t;
		else if ("number" != typeof t) return;
		return zt(t) ? t >>> 0 : void 0;
	}
	function re(t) {
		const e = t.length;
		return ("-" === t[0] ? e < 20 || 20 === e && t <= "-9223372036854775808" : e < 19 || 19 === e && t <= "9223372036854775807") ? t : (Gt(t), Bt(Rt, It));
	}
	function ie(t) {
		if (t = Kt(t), !Wt(t)) {
			Mt(t);
			var e = Rt, n = It;
			(t = 2147483648 & n) && (n = ~n >>> 0, 0 == (e = 1 + ~e >>> 0) && (n = n + 1 >>> 0)), t = "number" == typeof (e = Ct(e, n)) ? t ? -e : e : t ? "-" + e : e;
		}
		return t;
	}
	function se(t) {
		var e = Kt(Number(t));
		return Wt(e) ? String(e) : (-1 !== (e = t.indexOf(".")) && (t = t.substring(0, e)), re(t));
	}
	function oe(t) {
		var e = Kt(Number(t));
		return Wt(e) ? Et(e) : (-1 !== (e = t.indexOf(".")) && (t = t.substring(0, e)), D() ? Et(Xt(64, BigInt(t))) : Et(re(t)));
	}
	function ae(t) {
		return Wt(t) ? t = Et(ie(t)) : (t = Kt(t), Wt(t) ? t = String(t) : (Mt(t), t = Bt(Rt, It)), t = Et(t)), t;
	}
	function ce(t) {
		const e = typeof t;
		return null == t ? t : "bigint" === e ? Et(Xt(64, t)) : te(t) ? "string" === e ? oe(t) : ae(t) : void 0;
	}
	function he(t) {
		if ("string" != typeof t) throw Error();
		return t;
	}
	function ue(t) {
		if (null != t && "string" != typeof t) throw Error();
		return t;
	}
	function le(t) {
		return null == t || "string" == typeof t ? t : void 0;
	}
	function fe(t, e, n, r) {
		return null != t && t[q] === ot ? t : Array.isArray(t) ? ((r = (n = 0 | t[Q]) | 32 & r | 2 & r) !== n && rt(t, r), new e(t)) : (n ? 2 & r ? ((t = e[V]) || (it((t = new e()).v), t = e[V] = t), e = t) : e = new e() : e = void 0, e);
	}
	function de(t, e, n) {
		if (e) t: {
			if (!te(e = t)) throw N("int64");
			switch (typeof e) {
				case "string":
					e = oe(e);
					break t;
				case "bigint":
					e = Et(Xt(64, e));
					break t;
				default: e = ae(e);
			}
		}
		else e = ce(t);
		return null == (t = e) ? n ? Yt : void 0 : t;
	}
	const pe = {};
	let ge = function() {
		try {
			return m(new class extends Map {
				constructor() {
					super();
				}
			}()), !1;
		} catch {
			return !0;
		}
	}();
	var me = class {
		constructor() {
			this.g = /* @__PURE__ */ new Map();
		}
		get(t) {
			return this.g.get(t);
		}
		set(t, e) {
			return this.g.set(t, e), this.size = this.g.size, this;
		}
		delete(t) {
			return t = this.g.delete(t), this.size = this.g.size, t;
		}
		clear() {
			this.g.clear(), this.size = this.g.size;
		}
		has(t) {
			return this.g.has(t);
		}
		entries() {
			return this.g.entries();
		}
		keys() {
			return this.g.keys();
		}
		values() {
			return this.g.values();
		}
		forEach(t, e) {
			return this.g.forEach(t, e);
		}
		[Symbol.iterator]() {
			return this.entries();
		}
	};
	const ye = ge ? (Object.setPrototypeOf(me.prototype, Map.prototype), Object.defineProperties(me.prototype, { size: {
		value: 0,
		configurable: !0,
		enumerable: !0,
		writable: !0
	} }), me) : class extends Map {
		constructor() {
			super();
		}
	};
	function _e(t) {
		return t;
	}
	function ve(t) {
		if (2 & t.J) throw Error("Cannot mutate an immutable Map");
	}
	var Ee = class extends ye {
		constructor(t, e, n = _e, r = _e) {
			super(), this.J = 0 | t[Q], this.K = e, this.S = n, this.fa = this.K ? we : r;
			for (let i = 0; i < t.length; i++) {
				const s = t[i], o = n(s[0], !1, !0);
				let a = s[1];
				e ? void 0 === a && (a = null) : a = r(s[1], !1, !0, void 0, void 0, this.J), super.set(o, a);
			}
		}
		V(t) {
			return st(Array.from(super.entries(), t));
		}
		clear() {
			ve(this), super.clear();
		}
		delete(t) {
			return ve(this), super.delete(this.S(t, !0, !1));
		}
		entries() {
			if (this.K) {
				var t = super.keys();
				t = new ut(t, Te, this);
			} else t = super.entries();
			return t;
		}
		values() {
			if (this.K) {
				var t = super.keys();
				t = new ut(t, Ee.prototype.get, this);
			} else t = super.values();
			return t;
		}
		forEach(t, e) {
			this.K ? super.forEach(((n, r, i) => {
				t.call(e, i.get(r), r, i);
			})) : super.forEach(t, e);
		}
		set(t, e) {
			return ve(this), null == (t = this.S(t, !0, !1)) ? this : null == e ? (super.delete(t), this) : super.set(t, this.fa(e, !0, !0, this.K, !1, this.J));
		}
		Ma(t) {
			const e = this.S(t[0], !1, !0);
			t = t[1], t = this.K ? void 0 === t ? null : t : this.fa(t, !1, !0, void 0, !1, this.J), super.set(e, t);
		}
		has(t) {
			return super.has(this.S(t, !1, !1));
		}
		get(t) {
			t = this.S(t, !1, !1);
			const e = super.get(t);
			if (void 0 !== e) {
				var n = this.K;
				return n ? ((n = this.fa(e, !1, !0, n, this.ra, this.J)) !== e && super.set(t, n), n) : e;
			}
		}
		[Symbol.iterator]() {
			return this.entries();
		}
	};
	function we(t, e, n, r, i, s) {
		return t = fe(t, r, n, s), i && (t = Xe(t)), t;
	}
	function Te(t) {
		return [t, this.get(t)];
	}
	let Ae;
	function be() {
		return Ae ||= new Ee(it([]), void 0, void 0, void 0, pe);
	}
	function ke(t) {
		return H ? t[H] : void 0;
	}
	function Se(t, e) {
		for (const n in t) !isNaN(n) && e(t, +n, t[n]);
	}
	Ee.prototype.toJSON = void 0;
	var xe = class {};
	const Le = { Ka: !0 };
	function Re(t, e) {
		e < 100 || U(z, 1);
	}
	function Ie(t, e, n, r) {
		const i = void 0 !== r;
		r = !!r;
		var s, o = H;
		!i && B && o && (s = t[o]) && Se(s, Re), o = [];
		var a = t.length;
		let c;
		s = 4294967295;
		let h = !1;
		const u = !!(64 & e), l = u ? 128 & e ? 0 : -1 : void 0;
		1 & e || (c = a && t[a - 1], null != c && "object" == typeof c && c.constructor === Object ? s = --a : c = void 0, !u || 128 & e || i || (h = !0, s = s - l + l)), e = void 0;
		for (var f = 0; f < a; f++) {
			let i = t[f];
			if (null != i && null != (i = n(i, r))) if (u && f >= s) {
				const t = f - l;
				(e ??= {})[t] = i;
			} else o[f] = i;
		}
		if (c) for (let t in c) {
			if (null == (a = c[t]) || null == (a = n(a, r))) continue;
			let i;
			f = +t, u && !Number.isNaN(f) && (i = f + l) < s ? o[i] = a : (e ??= {})[t] = a;
		}
		return e && (h ? o.push(e) : o[s] = e), i && H && (t = ke(t)) && t instanceof xe && (o[H] = function(t) {
			const e = new xe();
			return Se(t, ((t, n, r) => {
				e[n] = Vt(r);
			})), e.da = t.da, e;
		}(t)), o;
	}
	function Fe(t) {
		return t[0] = Me(t[0]), t[1] = Me(t[1]), t;
	}
	function Me(t) {
		switch (typeof t) {
			case "number": return Number.isFinite(t) ? t : "" + t;
			case "bigint": return wt(t) ? Number(t) : "" + t;
			case "boolean": return t ? 1 : 0;
			case "object":
				if (Array.isArray(t)) {
					var e = 0 | t[Q];
					return 0 === t.length && 1 & e ? void 0 : Ie(t, e, Me);
				}
				if (null != t && t[q] === ot) return Oe(t);
				if (t instanceof F) {
					if (null == (e = t.g)) t = "";
					else if ("string" == typeof e) t = e;
					else {
						if (T) {
							for (var n = "", r = 0, i = e.length - 10240; r < i;) n += String.fromCharCode.apply(null, e.subarray(r, r += 10240));
							n += String.fromCharCode.apply(null, r ? e.subarray(r) : e), e = btoa(n);
						} else {
							void 0 === n && (n = 0), E(), n = y[n], r = Array(Math.floor(e.length / 3)), i = n[64] || "";
							let t = 0, h = 0;
							for (; t < e.length - 2; t += 3) {
								var s = e[t], o = e[t + 1], a = e[t + 2], c = n[s >> 2];
								s = n[(3 & s) << 4 | o >> 4], o = n[(15 & o) << 2 | a >> 6], a = n[63 & a], r[h++] = c + s + o + a;
							}
							switch (c = 0, a = i, e.length - t) {
								case 2: a = n[(15 & (c = e[t + 1])) << 2] || i;
								case 1: e = e[t], r[h] = n[e >> 2] + n[(3 & e) << 4 | c >> 4] + a + i;
							}
							e = r.join("");
						}
						t = t.g = e;
					}
					return t;
				}
				return t instanceof Ee ? t = 0 !== t.size ? t.V(Fe) : void 0 : void 0;
		}
		return t;
	}
	let Pe;
	let Ce;
	function Oe(t) {
		return Ie(t = t.v, 0 | t[Q], Me);
	}
	function Ne(t, e) {
		return Ue(t, e[0], e[1]);
	}
	function Ue(t, e, n, r = 0) {
		if (null == t) {
			var i = 32;
			n ? (t = [n], i |= 128) : t = [], e && (i = -16760833 & i | (1023 & e) << 14);
		} else {
			if (!Array.isArray(t)) throw Error("narr");
			if (i = 0 | t[Q], d && 1 & i) throw Error("rfarr");
			if (2048 & i && !(2 & i) && function() {
				if (d) throw Error("carr");
				U(Y, 5);
			}(), 256 & i) throw Error("farr");
			if (64 & i) return (i | r) !== i && rt(t, i | r), t;
			if (n && (i |= 128, n !== t[0])) throw Error("mid");
			t: {
				i |= 64;
				var s = (n = t).length;
				if (s) {
					var o = s - 1;
					const t = n[o];
					if (null != t && "object" == typeof t && t.constructor === Object) {
						if ((o -= e = 128 & i ? 0 : -1) >= 1024) throw Error("pvtlmt");
						for (var a in t) (s = +a) < o && (n[s + e] = t[a], delete t[a]);
						i = -16760833 & i | (1023 & o) << 14;
						break t;
					}
				}
				if (e) {
					if ((a = Math.max(e, s - (128 & i ? 0 : -1))) > 1024) throw Error("spvt");
					i = -16760833 & i | (1023 & a) << 14;
				}
			}
		}
		return rt(t, 64 | i | r), t;
	}
	function De(t, e) {
		if ("object" != typeof t) return t;
		if (Array.isArray(t)) {
			var n = 0 | t[Q];
			return 0 === t.length && 1 & n ? void 0 : Be(t, n, e);
		}
		if (null != t && t[q] === ot) return je(t);
		if (t instanceof Ee) {
			if (2 & (e = t.J)) return t;
			if (!t.size) return;
			if (n = it(t.V()), t.K) for (t = 0; t < n.length; t++) {
				const r = n[t];
				let i = r[1];
				i = null == i || "object" != typeof i ? void 0 : null != i && i[q] === ot ? je(i) : Array.isArray(i) ? Be(i, 0 | i[Q], !!(32 & e)) : void 0, r[1] = i;
			}
			return n;
		}
		return t instanceof F ? t : void 0;
	}
	function Be(t, e, n) {
		return 2 & e || (!n || 4096 & e || 16 & e ? t = Ve(t, e, !1, n && !(16 & e)) : (nt(t, 34), 4 & e && Object.freeze(t))), t;
	}
	function Ge(t, e, n) {
		return t = new t.constructor(e), n && (t.h = ct), t.m = ct, t;
	}
	function je(t) {
		const e = t.v, n = 0 | e[Q];
		return at(t, n) ? t : Ke(t, e, n) ? Ge(t, e) : Ve(e, n);
	}
	function Ve(t, e, n, r) {
		return r ??= !!(34 & e), t = Ie(t, e, De, r), r = 32, n && (r |= 2), rt(t, e = 16769217 & e | r), t;
	}
	function Xe(t) {
		const e = t.v, n = 0 | e[Q];
		return at(t, n) ? Ke(t, e, n) ? Ge(t, e, !0) : new t.constructor(Ve(e, n, !1)) : t;
	}
	function He(t) {
		if (t.h !== ct) return !1;
		var e = t.v;
		return nt(e = Ve(e, 0 | e[Q]), 2048), t.v = e, t.h = void 0, t.m = void 0, !0;
	}
	function We(t) {
		if (!He(t) && at(t, 0 | t.v[Q])) throw Error();
	}
	function ze(t, e) {
		void 0 === e && (e = 0 | t[Q]), 32 & e && !(4096 & e) && rt(t, 4096 | e);
	}
	function Ke(t, e, n) {
		return !!(2 & n) || !(!(32 & n) || 4096 & n) && (rt(e, 2 | n), t.h = ct, !0);
	}
	const Ye = Et(0);
	const qe = {};
	function $e(t, e, n, r, i) {
		if (null !== (e = Je(t.v, e, n, i)) || r && t.m !== ct) return e;
	}
	function Je(t, e, n, r) {
		if (-1 === e) return null;
		const i = e + (n ? 0 : -1), s = t.length - 1;
		let o, a;
		if (!(s < 1 + (n ? 0 : -1))) {
			if (i >= s) if (o = t[s], null != o && "object" == typeof o && o.constructor === Object) n = o[e], a = !0;
			else {
				if (i !== s) return;
				n = o;
			}
			else n = t[i];
			if (r && null != n) {
				if (null == (r = r(n))) return r;
				if (!Object.is(r, n)) return a ? o[e] = r : t[i] = r, r;
			}
			return n;
		}
	}
	function Ze(t, e, n, r) {
		We(t), Qe(t = t.v, 0 | t[Q], e, n, r);
	}
	function Qe(t, e, n, r, i) {
		const s = n + (i ? 0 : -1);
		var o = t.length - 1;
		if (o >= 1 + (i ? 0 : -1) && s >= o) {
			const i = t[o];
			if (null != i && "object" == typeof i && i.constructor === Object) return i[n] = r, e;
		}
		return s <= o ? (t[s] = r, e) : (void 0 !== r && (n >= (o = (e ??= 0 | t[Q]) >> 14 & 1023 || 536870912) ? null != r && (t[o + (i ? 0 : -1)] = { [n]: r }) : t[s] = r), e);
	}
	function tn() {
		return void 0 === lt ? 2 : 4;
	}
	function en(t, e, n, r, i) {
		let s = t.v, o = 0 | s[Q];
		r = at(t, o) ? 1 : r, i = !!i || 3 === r, 2 === r && He(t) && (s = t.v, o = 0 | s[Q]);
		let a = (t = rn(s, e)) === tt ? 7 : 0 | t[Q], c = sn(a, o);
		var h = !(4 & c);
		if (h) {
			4 & c && (t = Vt(t), a = 0, c = An(c, o), o = Qe(s, o, e, t));
			let r = 0, i = 0;
			for (; r < t.length; r++) {
				const e = n(t[r]);
				null != e && (t[i++] = e);
			}
			i < r && (t.length = i), n = -513 & (4 | c), c = n &= -1025, c &= -4097;
		}
		return c !== a && (rt(t, c), 2 & c && Object.freeze(t)), nn(t, c, s, o, e, r, h, i);
	}
	function nn(t, e, n, r, i, s, o, a) {
		let c = e;
		return 1 === s || 4 === s && (2 & e || !(16 & e) && 32 & r) ? on(e) || ((e |= !t.length || o && !(4096 & e) || 32 & r && !(4096 & e || 16 & e) ? 2 : 256) !== c && rt(t, e), Object.freeze(t)) : (2 === s && on(e) && (t = Vt(t), c = 0, e = An(e, r), r = Qe(n, r, i, t)), on(e) || (a || (e |= 16), e !== c && rt(t, e))), 2 & e || !(4096 & e || 16 & e) || ze(n, r), t;
	}
	function rn(t, e, n) {
		return t = Je(t, e, n), Array.isArray(t) ? t : tt;
	}
	function sn(t, e) {
		return 2 & e && (t |= 2), 1 | t;
	}
	function on(t) {
		return !!(2 & t) && !!(4 & t) || !!(256 & t);
	}
	function an(t) {
		return ht(t, !0);
	}
	function cn(t) {
		t = Vt(t);
		for (let e = 0; e < t.length; e++) {
			const n = t[e] = Vt(t[e]);
			Array.isArray(n[1]) && (n[1] = it(n[1]));
		}
		return st(t);
	}
	function hn(t, e, n, r) {
		We(t), Qe(t = t.v, 0 | t[Q], e, ("0" === r ? 0 === Number(n) : n === r) ? void 0 : n);
	}
	function un(t, e, n) {
		if (2 & e) throw Error();
		const r = pt(e);
		let i = rn(t, n, r), s = i === tt ? 7 : 0 | i[Q], o = sn(s, e);
		return (2 & o || on(o) || 16 & o) && (o === s || on(o) || rt(i, o), i = Vt(i), s = 0, o = An(o, e), Qe(t, e, n, i, r)), o &= -13, o !== s && rt(i, o), i;
	}
	function ln(t, e) {
		var n = Cs;
		return pn(fn(t = t.v), t, void 0, n) === e ? e : -1;
	}
	function fn(t) {
		if (B) return t[X] ?? (t[X] = /* @__PURE__ */ new Map());
		if (X in t) return t[X];
		const e = /* @__PURE__ */ new Map();
		return Object.defineProperty(t, X, { value: e }), e;
	}
	function dn(t, e, n, r, i) {
		const s = fn(t), o = pn(s, t, e, n, i);
		return o !== r && (o && (e = Qe(t, e, o, void 0, i)), s.set(n, r)), e;
	}
	function pn(t, e, n, r, i) {
		let s = t.get(r);
		if (null != s) return s;
		s = 0;
		for (let t = 0; t < r.length; t++) {
			const o = r[t];
			null != Je(e, o, i) && (0 !== s && (n = Qe(e, n, s, void 0, i)), s = o);
		}
		return t.set(r, s), s;
	}
	function gn(t, e, n) {
		let r = 0 | t[Q];
		const i = pt(r), s = Je(t, n, i);
		let o;
		if (null != s && s[q] === ot) {
			if (!at(s)) return He(s), s.v;
			o = s.v;
		} else Array.isArray(s) && (o = s);
		if (o) {
			const t = 0 | o[Q];
			2 & t && (o = Ve(o, t));
		}
		return o = Ne(o, e), o !== s && Qe(t, r, n, o, i), o;
	}
	function mn(t, e, n, r, i) {
		let s = !1;
		if (null != (r = Je(t, r, i, ((t) => {
			const r = fe(t, n, !1, e);
			return s = r !== t && null != r, r;
		})))) return s && !at(r) && ze(t, e), r;
	}
	function yn(t, e, n, r) {
		let i = t.v, s = 0 | i[Q];
		if (null == (e = mn(i, s, e, n, r))) return e;
		if (s = 0 | i[Q], !at(t, s)) {
			const o = Xe(e);
			o !== e && (He(t) && (i = t.v, s = 0 | i[Q]), s = Qe(i, s, n, e = o, r), ze(i, s));
		}
		return e;
	}
	function _n(t, e, n, r, i, s, o, a) {
		var c = at(t, n);
		s = c ? 1 : s, o = !!o || 3 === s, c = a && !c, (2 === s || c) && He(t) && (n = 0 | (e = t.v)[Q]);
		var h = (t = rn(e, i)) === tt ? 7 : 0 | t[Q], u = sn(h, n);
		if (a = !(4 & u)) {
			var l = t, f = n;
			const e = !!(2 & u);
			e && (f |= 2);
			let i = !e, s = !0, o = 0, a = 0;
			for (; o < l.length; o++) {
				const t = fe(l[o], r, !1, f);
				if (t instanceof r) {
					if (!e) {
						const e = at(t);
						i &&= !e, s &&= e;
					}
					l[a++] = t;
				}
			}
			a < o && (l.length = a), u |= 4, u = s ? -4097 & u : 4096 | u, u = i ? 8 | u : -9 & u;
		}
		if (u !== h && (rt(t, u), 2 & u && Object.freeze(t)), c && !(8 & u || !t.length && (1 === s || 4 === s && (2 & u || !(16 & u) && 32 & n)))) {
			for (on(u) && (t = Vt(t), u = An(u, n), n = Qe(e, n, i, t)), r = t, c = u, h = 0; h < r.length; h++) (l = r[h]) !== (u = Xe(l)) && (r[h] = u);
			c |= 8, rt(t, u = c = r.length ? 4096 | c : -4097 & c);
		}
		return nn(t, u, e, n, i, s, a, o);
	}
	function vn(t, e, n) {
		const r = t.v;
		return _n(t, r, 0 | r[Q], e, n, tn(), !1, !0);
	}
	function En(t) {
		return t ??= void 0, t;
	}
	function wn(t, e, n, r, i) {
		return Ze(t, n, r = En(r), i), r && !at(r) && ze(t.v), t;
	}
	function Tn(t, e, n, r) {
		t: {
			var i = r = En(r);
			We(t);
			const s = t.v;
			let o = 0 | s[Q];
			if (null == i) {
				const t = fn(s);
				if (pn(t, s, o, n) !== e) break t;
				t.set(n, 0);
			} else o = dn(s, o, n, e);
			Qe(s, o, e, i);
		}
		r && !at(r) && ze(t.v);
	}
	function An(t, e) {
		return -273 & (2 & e ? 2 | t : -3 & t);
	}
	function bn(t, e, n, r) {
		var i = r;
		We(t), t = _n(t, r = t.v, 0 | r[Q], n, e, 2, !0), i = null != i ? i : new n(), t.push(i), e = n = t === tt ? 7 : 0 | t[Q], (i = at(i)) ? (n &= -9, 1 === t.length && (n &= -4097)) : n |= 4096, n !== e && rt(t, n), i || ze(r);
	}
	function kn(t, e, n) {
		return ee($e(t, e, void 0, n));
	}
	function Sn(t, e) {
		return $e(t, e, void 0, void 0, $t) ?? 0;
	}
	function xn(t, e, n) {
		if (null != n) {
			if ("number" != typeof n) throw N("int32");
			if (!zt(n)) throw N("int32");
			n |= 0;
		}
		Ze(t, e, n);
	}
	function Ln(t, e, n) {
		Ze(t, e, qt(n));
	}
	function Rn(t, e, n) {
		hn(t, e, ue(n), "");
	}
	function In(t, e, n) {
		{
			We(t);
			const o = t.v;
			let a = 0 | o[Q];
			if (null == n) Qe(o, a, e);
			else {
				var r = t = n === tt ? 7 : 0 | n[Q], i = on(t), s = i || Object.isFrozen(n);
				for (i || (t = 0), s || (n = Vt(n), r = 0, t = An(t, a), s = !1), t |= 5, t |= (4 & t ? 512 & t ? 512 : 1024 & t ? 1024 : 0 : void 0) ?? 1024, i = 0; i < n.length; i++) {
					const e = n[i], o = he(e);
					Object.is(e, o) || (s && (n = Vt(n), r = 0, t = An(t, a), s = !1), n[i] = o);
				}
				t !== r && (s && (n = Vt(n), t = An(t, a)), rt(n, t)), Qe(o, a, e, n);
			}
		}
	}
	function Fn(t, e, n) {
		We(t), en(t, e, le, 2, !0).push(he(n));
	}
	var Mn = class {
		constructor(t, e, n) {
			if (this.buffer = t, n && !e) throw Error();
			this.g = e;
		}
	};
	function Pn(t, e) {
		if ("string" == typeof t) return new Mn(S(t), e);
		if (Array.isArray(t)) return new Mn(new Uint8Array(t), e);
		if (t.constructor === Uint8Array) return new Mn(t, !1);
		if (t.constructor === ArrayBuffer) return t = new Uint8Array(t), new Mn(t, !1);
		if (t.constructor === F) return e = I(t) || /* @__PURE__ */ new Uint8Array(0), new Mn(e, !0, t);
		if (t instanceof Uint8Array) return t = t.constructor === Uint8Array ? t : new Uint8Array(t.buffer, t.byteOffset, t.byteLength), new Mn(t, !1);
		throw Error();
	}
	function Cn(t, e) {
		let n, r = 0, i = 0, s = 0;
		const o = t.h;
		let a = t.g;
		do
			n = o[a++], r |= (127 & n) << s, s += 7;
		while (s < 32 && 128 & n);
		if (s > 32) for (i |= (127 & n) >> 4, s = 3; s < 32 && 128 & n; s += 7) n = o[a++], i |= (127 & n) << s;
		if (Gn(t, a), !(128 & n)) return e(r >>> 0, i >>> 0);
		throw Error();
	}
	function On(t) {
		let e = 0, n = t.g;
		const r = n + 10, i = t.h;
		for (; n < r;) {
			const r = i[n++];
			if (e |= r, 0 == (128 & r)) return Gn(t, n), !!(127 & e);
		}
		throw Error();
	}
	function Nn(t) {
		const e = t.h;
		let n = t.g, r = e[n++], i = 127 & r;
		if (128 & r && (r = e[n++], i |= (127 & r) << 7, 128 & r && (r = e[n++], i |= (127 & r) << 14, 128 & r && (r = e[n++], i |= (127 & r) << 21, 128 & r && (r = e[n++], i |= r << 28, 128 & r && 128 & e[n++] && 128 & e[n++] && 128 & e[n++] && 128 & e[n++] && 128 & e[n++]))))) throw Error();
		return Gn(t, n), i;
	}
	function Un(t) {
		return Nn(t) >>> 0;
	}
	function Dn(t) {
		var e = t.h;
		const n = t.g;
		var r = e[n], i = e[n + 1];
		const s = e[n + 2];
		return e = e[n + 3], Gn(t, t.g + 4), t = 2 * ((i = (r << 0 | i << 8 | s << 16 | e << 24) >>> 0) >> 31) + 1, r = i >>> 23 & 255, i &= 8388607, 255 == r ? i ? NaN : t * (1 / 0) : 0 == r ? 1401298464324817e-60 * t * i : t * Math.pow(2, r - 150) * (i + 8388608);
	}
	function Bn(t) {
		return Nn(t);
	}
	function Gn(t, e) {
		if (t.g = e, e > t.l) throw Error();
	}
	function jn(t, e) {
		if (e < 0) throw Error();
		const n = t.g;
		if ((e = n + e) > t.l) throw Error();
		return t.g = e, n;
	}
	function Vn(t, e) {
		if (0 == e) return R();
		var n = jn(t, e);
		return t.Y && t.j ? n = t.h.subarray(n, n + e) : (t = t.h, n = n === (e = n + e) ? /* @__PURE__ */ new Uint8Array(0) : xt ? t.slice(n, e) : new Uint8Array(t.subarray(n, e))), 0 == n.length ? R() : new F(n, L);
	}
	var Xn = [];
	function Hn(t, e, n, r) {
		if (Qn.length) {
			const i = Qn.pop();
			return i.o(r), i.g.init(t, e, n, r), i;
		}
		return new Zn(t, e, n, r);
	}
	function Wn(t) {
		t.g.clear(), t.l = -1, t.h = -1, Qn.length < 100 && Qn.push(t);
	}
	function zn(t) {
		var e = t.g;
		if (e.g == e.l) return !1;
		t.m = t.g.g;
		var n = Un(t.g);
		if (e = n >>> 3, !((n &= 7) >= 0 && n <= 5)) throw Error();
		if (e < 1) throw Error();
		return t.l = e, t.h = n, !0;
	}
	function Kn(t) {
		switch (t.h) {
			case 0:
				0 != t.h ? Kn(t) : On(t.g);
				break;
			case 1:
				Gn(t = t.g, t.g + 8);
				break;
			case 2:
				if (2 != t.h) Kn(t);
				else {
					var e = Un(t.g);
					Gn(t = t.g, t.g + e);
				}
				break;
			case 5:
				Gn(t = t.g, t.g + 4);
				break;
			case 3:
				for (e = t.l;;) {
					if (!zn(t)) throw Error();
					if (4 == t.h) {
						if (t.l != e) throw Error();
						break;
					}
					Kn(t);
				}
				break;
			default: throw Error();
		}
	}
	function Yn(t, e, n) {
		const r = t.g.l;
		var i = Un(t.g);
		let s = (i = t.g.g + i) - r;
		if (s <= 0 && (t.g.l = i, n(e, t, void 0, void 0, void 0), s = i - t.g.g), s) throw Error();
		return t.g.g = i, t.g.l = r, e;
	}
	function qn(t) {
		var e = Un(t.g), a = jn(t = t.g, e);
		if (t = t.h, o) {
			var c, h = t;
			(c = s) || (c = s = new TextDecoder("utf-8", { fatal: !0 })), e = a + e, h = 0 === a && e === h.length ? h : h.subarray(a, e);
			try {
				var u = c.decode(h);
			} catch (t) {
				if (void 0 === i) {
					try {
						c.decode(new Uint8Array([128]));
					} catch (t) {}
					try {
						c.decode(new Uint8Array([97])), i = !0;
					} catch (t) {
						i = !1;
					}
				}
				throw !i && (s = void 0), t;
			}
		} else {
			e = (u = a) + e, a = [];
			let i, s = null;
			for (; u < e;) {
				var l = t[u++];
				l < 128 ? a.push(l) : l < 224 ? u >= e ? n() : (i = t[u++], l < 194 || 128 != (192 & i) ? (u--, n()) : a.push((31 & l) << 6 | 63 & i)) : l < 240 ? u >= e - 1 ? n() : (i = t[u++], 128 != (192 & i) || 224 === l && i < 160 || 237 === l && i >= 160 || 128 != (192 & (c = t[u++])) ? (u--, n()) : a.push((15 & l) << 12 | (63 & i) << 6 | 63 & c)) : l <= 244 ? u >= e - 2 ? n() : (i = t[u++], 128 != (192 & i) || i - 144 + (l << 28) >> 30 != 0 || 128 != (192 & (c = t[u++])) || 128 != (192 & (h = t[u++])) ? (u--, n()) : (l = (7 & l) << 18 | (63 & i) << 12 | (63 & c) << 6 | 63 & h, l -= 65536, a.push(55296 + (l >> 10 & 1023), 56320 + (1023 & l)))) : n(), a.length >= 8192 && (s = r(s, a), a.length = 0);
			}
			u = r(s, a);
		}
		return u;
	}
	function $n(t) {
		const e = Un(t.g);
		return Vn(t.g, e);
	}
	function Jn(t, e, n) {
		var r = Un(t.g);
		for (r = t.g.g + r; t.g.g < r;) n.push(e(t.g));
	}
	var Zn = class {
		constructor(t, e, n, r) {
			if (Xn.length) {
				const i = Xn.pop();
				i.init(t, e, n, r), t = i;
			} else t = new class {
				constructor(t, e, n, r) {
					this.h = null, this.j = !1, this.g = this.l = this.m = 0, this.init(t, e, n, r);
				}
				init(t, e, n, { Y: r = !1, ea: i = !1 } = {}) {
					this.Y = r, this.ea = i, t && (t = Pn(t, this.ea), this.h = t.buffer, this.j = t.g, this.m = e || 0, this.l = void 0 !== n ? this.m + n : this.h.length, this.g = this.m);
				}
				clear() {
					this.h = null, this.j = !1, this.g = this.l = this.m = 0, this.Y = !1;
				}
			}(t, e, n, r);
			this.g = t, this.m = this.g.g, this.h = this.l = -1, this.o(r);
		}
		o({ ha: t = !1 } = {}) {
			this.ha = t;
		}
	};
	var Qn = [];
	function tr(t) {
		return t ? /^\\d+$/.test(t) ? (Gt(t), new er(Rt, It)) : null : nr ||= new er(0, 0);
	}
	var er = class {
		constructor(t, e) {
			this.h = t >>> 0, this.g = e >>> 0;
		}
	};
	let nr;
	function rr(t) {
		return t ? /^-?\\d+$/.test(t) ? (Gt(t), new ir(Rt, It)) : null : sr ||= new ir(0, 0);
	}
	var ir = class {
		constructor(t, e) {
			this.h = t >>> 0, this.g = e >>> 0;
		}
	};
	let sr;
	function or(t, e, n) {
		for (; n > 0 || e > 127;) t.g.push(127 & e | 128), e = (e >>> 7 | n << 25) >>> 0, n >>>= 7;
		t.g.push(e);
	}
	function ar(t, e) {
		for (; e > 127;) t.g.push(127 & e | 128), e >>>= 7;
		t.g.push(e);
	}
	function cr(t, e) {
		if (e >= 0) ar(t, e);
		else {
			for (let n = 0; n < 9; n++) t.g.push(127 & e | 128), e >>= 7;
			t.g.push(1);
		}
	}
	function hr(t) {
		var e = Rt;
		t.g.push(e >>> 0 & 255), t.g.push(e >>> 8 & 255), t.g.push(e >>> 16 & 255), t.g.push(e >>> 24 & 255);
	}
	function ur(t, e) {
		0 !== e.length && (t.l.push(e), t.h += e.length);
	}
	function lr(t, e, n) {
		ar(t.g, 8 * e + n);
	}
	function fr(t, e) {
		return lr(t, e, 2), e = t.g.end(), ur(t, e), e.push(t.h), e;
	}
	function dr(t, e) {
		var n = e.pop();
		for (n = t.h + t.g.length() - n; n > 127;) e.push(127 & n | 128), n >>>= 7, t.h++;
		e.push(n), t.h++;
	}
	function pr(t, e, n) {
		lr(t, e, 2), ar(t.g, n.length), ur(t, t.g.end()), ur(t, n);
	}
	function gr(t, e, n, r) {
		null != n && (e = fr(t, e), r(n, t), dr(t, e));
	}
	function mr() {
		const t = class {
			constructor() {
				throw Error();
			}
		};
		return Object.setPrototypeOf(t, t.prototype), t;
	}
	var yr = mr();
	var _r = mr();
	var vr = mr();
	var Er = mr();
	var wr = mr();
	var Tr = mr();
	var Ar = mr();
	var br = mr();
	var kr = mr();
	var Sr = mr();
	function xr(t, e, n) {
		var r = t.v;
		H && H in r && (r = r[H]) && delete r[e.g], e.h ? e.j(t, e.h, e.g, n, e.l) : e.j(t, e.g, n, e.l);
	}
	var Lr = class {
		constructor(t, e) {
			this.v = Ue(t, e, void 0, 2048);
		}
		toJSON() {
			return Oe(this);
		}
		j() {
			var t = xo, e = this.v, n = t.g, r = H;
			if (B && r && null != e[r]?.[n] && U(W, 3), e = t.g, $ && H && void 0 === $ && (r = (n = this.v)[H]) && (r = r.da)) try {
				r(n, e, Le);
			} catch (t) {
				u(t);
			}
			return t.h ? t.m(this, t.h, t.g, t.l) : t.m(this, t.g, t.defaultValue, t.l);
		}
		clone() {
			const t = this.v, e = 0 | t[Q];
			return Ke(this, t, e) ? Ge(this, t, !0) : new this.constructor(Ve(t, e, !1));
		}
	};
	Lr.prototype[q] = ot, Lr.prototype.toString = function() {
		return this.v.toString();
	};
	var Rr = class {
		constructor(t, e, n) {
			this.g = t, this.h = e, t = yr, this.l = !!t && n === t || !1;
		}
	};
	function Ir(t, e) {
		return new Rr(t, e, yr);
	}
	function Fr(t, e, n, r, i) {
		gr(t, n, Xr(e, r), i);
	}
	const Mr = Ir((function(t, e, n, r, i) {
		return 2 === t.h && (Yn(t, gn(e, r, n), i), !0);
	}), Fr);
	const Pr = Ir((function(t, e, n, r, i) {
		return 2 === t.h && (Yn(t, gn(e, r, n), i), !0);
	}), Fr);
	var Cr = Symbol();
	var Or = Symbol();
	var Nr = Symbol();
	var Ur = Symbol();
	var Dr = Symbol();
	let Br;
	let Gr;
	function jr(t, e, n, r) {
		var i = r[t];
		if (i) return i;
		(i = {}).qa = r, i.T = function(t) {
			switch (typeof t) {
				case "boolean": return Pe ||= [
					0,
					void 0,
					!0
				];
				case "number": return t > 0 ? void 0 : 0 === t ? Ce ||= [0, void 0] : [-t, void 0];
				case "string": return [0, t];
				case "object": return t;
			}
		}(r[0]);
		var s = r[1];
		let o = 1;
		s && s.constructor === Object && (i.ba = s, "function" == typeof (s = r[++o]) && (i.ma = !0, Br ??= s, Gr ??= r[o + 1], s = r[o += 2]));
		const a = {};
		for (; s && Array.isArray(s) && s.length && "number" == typeof s[0] && s[0] > 0;) {
			for (var c = 0; c < s.length; c++) a[s[c]] = s;
			s = r[++o];
		}
		for (c = 1; void 0 !== s;) {
			let t;
			"number" == typeof s && (c += s, s = r[++o]);
			var h = void 0;
			if (s instanceof Rr ? t = s : (t = Mr, o--), t?.l) {
				s = r[++o], h = r;
				var u = o;
				"function" == typeof s && (s = s(), h[u] = s), h = s;
			}
			for (u = c + 1, "number" == typeof (s = r[++o]) && s < 0 && (u -= s, s = r[++o]); c < u; c++) {
				const r = a[c];
				h ? n(i, c, t, h, r) : e(i, c, t, r);
			}
		}
		return r[t] = i;
	}
	function Vr(t) {
		return Array.isArray(t) ? t[0] instanceof Rr ? t : [Pr, t] : [t, void 0];
	}
	function Xr(t, e) {
		return t instanceof Lr ? t.v : Array.isArray(t) ? Ne(t, e) : void 0;
	}
	function Hr(t, e, n, r) {
		const i = n.g;
		t[e] = r ? (t, e, n) => i(t, e, n, r) : i;
	}
	function Wr(t, e, n, r, i) {
		const s = n.g;
		let o, a;
		t[e] = (t, e, n) => s(t, e, n, a ||= jr(Or, Hr, Wr, r).T, o ||= zr(r), i);
	}
	function zr(t) {
		let e = t[Nr];
		if (null != e) return e;
		const n = jr(Or, Hr, Wr, t);
		return e = n.ma ? (t, e) => Br(t, e, n) : (t, e) => {
			for (; zn(e) && 4 != e.h;) {
				var r = e.l, i = n[r];
				if (null == i) {
					var s = n.ba;
					s && (s = s[r]) && null != (s = Yr(s)) && (i = n[r] = s);
				}
				if (null == i || !i(e, t, r)) {
					if (i = (s = e).m, Kn(s), s.ha) var o = void 0;
					else o = s.g.g - i, s.g.g = i, o = Vn(s.g, o);
					i = void 0, s = t, o && ((i = s[H] ?? (s[H] = new xe()))[r] ?? (i[r] = [])).push(o);
				}
			}
			return (t = ke(t)) && (t.da = n.qa[Dr]), !0;
		}, t[Nr] = e, t[Dr] = Kr.bind(t), e;
	}
	function Kr(t, e, n, r) {
		var i = this[Or];
		const s = this[Nr], o = Ne(void 0, i.T), a = ke(t);
		if (a) {
			var c = !1, h = i.ba;
			if (h) {
				if (i = (e, n, i) => {
					if (0 !== i.length) if (h[n]) for (const t of i) {
						e = Hn(t);
						try {
							c = !0, s(o, e);
						} finally {
							Wn(e);
						}
					}
					else r?.(t, n, i);
				}, null == e) Se(a, i);
				else if (null != a) {
					const t = a[e];
					t && i(a, e, t);
				}
				if (c) {
					let r = 0 | t[Q];
					if (2 & r && 2048 & r && !n?.Ka) throw Error();
					const i = pt(r), s = (e, s) => {
						if (null != Je(t, e, i)) {
							if (1 === n?.Qa) return;
							throw Error();
						}
						null != s && (r = Qe(t, r, e, s, i)), delete a[e];
					};
					null == e ? ft(o, 0 | o[Q], ((t, e) => {
						s(t, e);
					})) : s(e, Je(o, e, i));
				}
			}
		}
	}
	function Yr(t) {
		const e = (t = Vr(t))[0].g;
		if (t = t[1]) {
			const n = zr(t), r = jr(Or, Hr, Wr, t).T;
			return (t, i, s) => e(t, i, s, r, n);
		}
		return e;
	}
	function qr(t, e, n) {
		t[e] = n.h;
	}
	function $r(t, e, n, r) {
		let i, s;
		const o = n.h;
		t[e] = (t, e, n) => o(t, e, n, s ||= jr(Cr, qr, $r, r).T, i ||= Jr(r));
	}
	function Jr(t) {
		let e = t[Ur];
		if (!e) {
			const n = jr(Cr, qr, $r, t);
			e = (t, e) => Zr(t, e, n), t[Ur] = e;
		}
		return e;
	}
	function Zr(t, e, n) {
		ft(t, 0 | t[Q], ((t, r) => {
			if (null != r) {
				var i = function(t, e) {
					var n = t[e];
					if (n) return n;
					if ((n = t.ba) && (n = n[e])) {
						var r = (n = Vr(n))[0].h;
						if (n = n[1]) {
							const e = Jr(n), i = jr(Cr, qr, $r, n).T;
							n = t.ma ? Gr(i, e) : (t, n, s) => r(t, n, s, i, e);
						} else n = r;
						return t[e] = n;
					}
				}(n, t);
				i ? i(e, r, t) : t < 500 || U(K, 3);
			}
		})), (t = ke(t)) && Se(t, ((t, n, r) => {
			for (ur(e, e.g.end()), t = 0; t < r.length; t++) ur(e, I(r[t]) || /* @__PURE__ */ new Uint8Array(0));
		}));
	}
	const Qr = Et(0);
	function ti(t, e) {
		if (Array.isArray(e)) {
			var n = 0 | e[Q];
			if (4 & n) return e;
			for (var r = 0, i = 0; r < e.length; r++) {
				const n = t(e[r]);
				null != n && (e[i++] = n);
			}
			return i < r && (e.length = i), (t = -1537 & (5 | n)) !== n && rt(e, t), 2 & t && Object.freeze(e), e;
		}
	}
	function ei(t, e, n) {
		return new Rr(t, e, n);
	}
	function ni(t, e, n) {
		return new Rr(t, e, n);
	}
	function ri(t, e, n) {
		Qe(t, 0 | t[Q], e, n, pt(0 | t[Q]));
	}
	var ii = Ir((function(t, e, n, r, i) {
		if (2 !== t.h) return !1;
		if (t = Vt(t = Yn(t, Ne([void 0, void 0], r), i)), i = pt(r = 0 | e[Q]), 2 & r) throw Error();
		let s = Je(e, n, i);
		if (s instanceof Ee) 0 != (2 & s.J) ? (s = s.V(), s.push(t), Qe(e, r, n, s, i)) : s.Ma(t);
		else if (Array.isArray(s)) {
			var o = 0 | s[Q];
			8192 & o || rt(s, o |= 8192), 2 & o && (s = cn(s), Qe(e, r, n, s, i)), s.push(t);
		} else Qe(e, r, n, st([t]), i);
		return !0;
	}), (function(t, e, n, r, i) {
		if (e instanceof Ee) e.forEach(((e, s) => {
			gr(t, n, Ne([s, e], r), i);
		}));
		else if (Array.isArray(e)) {
			for (let s = 0; s < e.length; s++) {
				const o = e[s];
				Array.isArray(o) && gr(t, n, Ne(o, r), i);
			}
			st(e);
		}
	}));
	function si(t, e, n) {
		null != (e = $t(e)) && (lr(t, n, 5), t = t.g, Pt(e), hr(t));
	}
	function oi(t, e, n) {
		if (e = function(t) {
			if (null == t) return t;
			const e = typeof t;
			if ("bigint" === e) return String(Xt(64, t));
			if (te(t)) {
				if ("string" === e) return se(t);
				if ("number" === e) return ie(t);
			}
		}(e), null != e) {
			if ("string" == typeof e) rr(e);
			if (null != e) switch (lr(t, n, 0), typeof e) {
				case "number":
					t = t.g, Mt(e), or(t, Rt, It);
					break;
				case "bigint":
					n = BigInt.asUintN(64, e), n = new ir(Number(n & BigInt(4294967295)), Number(n >> BigInt(32))), or(t.g, n.h, n.g);
					break;
				default: n = rr(e), or(t.g, n.h, n.g);
			}
		}
	}
	function ai(t, e, n) {
		null != (e = ee(e)) && null != e && (lr(t, n, 0), cr(t.g, e));
	}
	function ci(t, e, n) {
		null != (e = Zt(e)) && (lr(t, n, 0), t.g.g.push(e ? 1 : 0));
	}
	function hi(t, e, n) {
		null != (e = le(e)) && pr(t, n, h(e));
	}
	function ui(t, e, n, r, i) {
		gr(t, n, Xr(e, r), i);
	}
	function li(t, e, n) {
		null != (e = null == e || "string" == typeof e || e instanceof F ? e : void 0) && pr(t, n, Pn(e, !0).buffer);
	}
	function fi(t, e, n) {
		null != (e = ne(e)) && null != e && (lr(t, n, 0), ar(t.g, e));
	}
	function di(t, e, n) {
		return (5 === t.h || 2 === t.h) && (e = un(e, 0 | e[Q], n), 2 == t.h ? Jn(t, Dn, e) : e.push(Dn(t.g)), !0);
	}
	var pi = ei((function(t, e, n) {
		return 5 === t.h && (ri(e, n, Dn(t.g)), !0);
	}), si, br);
	var gi = ni(di, (function(t, e, n) {
		if (null != (e = ti($t, e))) for (let o = 0; o < e.length; o++) {
			var r = t, i = n, s = e[o];
			null != s && (lr(r, i, 5), r = r.g, Pt(s), hr(r));
		}
	}), br);
	var mi = ni(di, (function(t, e, n) {
		if (null != (e = ti($t, e)) && e.length) {
			lr(t, n, 2), ar(t.g, 4 * e.length);
			for (let r = 0; r < e.length; r++) n = t.g, Pt(e[r]), hr(n);
		}
	}), br);
	var yi = ei((function(t, e, n) {
		return 5 === t.h && (ri(e, n, 0 === (t = Dn(t.g)) ? void 0 : t), !0);
	}), si, br);
	var _i = ei((function(t, e, n) {
		return 0 !== t.h ? t = !1 : (ri(e, n, Cn(t.g, Nt)), t = !0), t;
	}), oi, Tr);
	var vi = ei((function(t, e, n) {
		return 0 !== t.h ? e = !1 : (ri(e, n, (t = Cn(t.g, Nt)) === Qr ? void 0 : t), e = !0), e;
	}), oi, Tr);
	var Ei = ei((function(t, e, n) {
		return 0 !== t.h ? t = !1 : (ri(e, n, Cn(t.g, Ot)), t = !0), t;
	}), (function(t, e, n) {
		if (e = function(t) {
			if (null == t) return t;
			var e = typeof t;
			if ("bigint" === e) return String(Ht(64, t));
			if (te(t)) {
				if ("string" === e) return e = Kt(Number(t)), Wt(e) && e >= 0 ? t = String(e) : (-1 !== (e = t.indexOf(".")) && (t = t.substring(0, e)), (e = "-" !== t[0] && ((e = t.length) < 20 || 20 === e && t <= "18446744073709551615")) || (Gt(t), t = Ut(Rt, It))), t;
				if ("number" === e) return (t = Kt(t)) >= 0 && Wt(t) || (Mt(t), t = Ct(Rt, It)), t;
			}
		}(e), null != e) {
			if ("string" == typeof e) tr(e);
			if (null != e) switch (lr(t, n, 0), typeof e) {
				case "number":
					t = t.g, Mt(e), or(t, Rt, It);
					break;
				case "bigint":
					n = BigInt.asUintN(64, e), n = new er(Number(n & BigInt(4294967295)), Number(n >> BigInt(32))), or(t.g, n.h, n.g);
					break;
				default: n = tr(e), or(t.g, n.h, n.g);
			}
		}
	}), Ar);
	var wi = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, Nn(t.g)), !0);
	}), ai, Er);
	var Ti = ni((function(t, e, n) {
		return (0 === t.h || 2 === t.h) && (e = un(e, 0 | e[Q], n), 2 == t.h ? Jn(t, Nn, e) : e.push(Nn(t.g)), !0);
	}), (function(t, e, n) {
		if (null != (e = ti(ee, e)) && e.length) {
			n = fr(t, n);
			for (let n = 0; n < e.length; n++) cr(t.g, e[n]);
			dr(t, n);
		}
	}), Er);
	var Ai = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, 0 === (t = Nn(t.g)) ? void 0 : t), !0);
	}), ai, Er);
	var bi = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, On(t.g)), !0);
	}), ci, _r);
	var ki = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, !1 === (t = On(t.g)) ? void 0 : t), !0);
	}), ci, _r);
	var Si = ni((function(t, e, n) {
		return 2 === t.h && (t = qn(t), un(e, 0 | e[Q], n).push(t), !0);
	}), (function(t, e, n) {
		if (null != (e = ti(le, e))) for (let o = 0; o < e.length; o++) {
			var r = t, i = n, s = e[o];
			null != s && pr(r, i, h(s));
		}
	}), vr);
	var xi = ei((function(t, e, n) {
		return 2 === t.h && (ri(e, n, "" === (t = qn(t)) ? void 0 : t), !0);
	}), hi, vr);
	var Li = ei((function(t, e, n) {
		return 2 === t.h && (ri(e, n, qn(t)), !0);
	}), hi, vr);
	var Ri = function(t, e, n = yr) {
		return new Rr(t, e, n);
	}((function(t, e, n, r, i) {
		return 2 === t.h && (r = Ne(void 0, r), un(e, 0 | e[Q], n).push(r), Yn(t, r, i), !0);
	}), (function(t, e, n, r, i) {
		if (Array.isArray(e)) {
			for (let s = 0; s < e.length; s++) ui(t, e[s], n, r, i);
			1 & (t = 0 | e[Q]) || rt(e, 1 | t);
		}
	}));
	var Ii = Ir((function(t, e, n, r, i, s) {
		if (2 !== t.h) return !1;
		let o = 0 | e[Q];
		return dn(e, o, s, n, pt(o)), Yn(t, e = gn(e, r, n), i), !0;
	}), ui);
	var Fi = ei((function(t, e, n) {
		return 2 === t.h && (ri(e, n, $n(t)), !0);
	}), li, kr);
	var Mi = ni((function(t, e, n) {
		return (0 === t.h || 2 === t.h) && (e = un(e, 0 | e[Q], n), 2 == t.h ? Jn(t, Un, e) : e.push(Un(t.g)), !0);
	}), (function(t, e, n) {
		if (null != (e = ti(ne, e))) for (let o = 0; o < e.length; o++) {
			var r = t, i = n, s = e[o];
			null != s && (lr(r, i, 0), ar(r.g, s));
		}
	}), wr);
	var Pi = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, 0 === (t = Un(t.g)) ? void 0 : t), !0);
	}), fi, wr);
	var Ci = ei((function(t, e, n) {
		return 0 === t.h && (ri(e, n, Nn(t.g)), !0);
	}), (function(t, e, n) {
		null != (e = ee(e)) && (e = parseInt(e, 10), lr(t, n, 0), cr(t.g, e));
	}), Sr);
	var Oi = class {
		constructor(t, e) {
			var n = Qi;
			this.g = t, this.h = e, this.m = yn, this.j = wn, this.defaultValue = void 0, this.l = null != n.Oa ? dt : void 0;
		}
		register() {
			m(this);
		}
	};
	function Ni(t, e) {
		return new Oi(t, e);
	}
	function Ui(t, e) {
		return (n, r) => {
			{
				const s = { ea: !0 };
				r && Object.assign(s, r), n = Hn(n, void 0, void 0, s);
				try {
					const r = new t(), s = r.v;
					zr(e)(s, n);
					var i = r;
				} finally {
					Wn(n);
				}
			}
			return i;
		};
	}
	function Di(t) {
		return function() {
			const e = new class {
				constructor() {
					this.l = [], this.h = 0, this.g = new class {
						constructor() {
							this.g = [];
						}
						length() {
							return this.g.length;
						}
						end() {
							const t = this.g;
							return this.g = [], t;
						}
					}();
				}
			}();
			Zr(this.v, e, jr(Cr, qr, $r, t)), ur(e, e.g.end());
			const n = new Uint8Array(e.h), r = e.l, i = r.length;
			let s = 0;
			for (let t = 0; t < i; t++) {
				const e = r[t];
				n.set(e, s), s += e.length;
			}
			return e.l = [n], n;
		};
	}
	var Bi = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Gi = [
		0,
		xi,
		ei((function(t, e, n) {
			return 2 === t.h && (ri(e, n, (t = $n(t)) === R() ? void 0 : t), !0);
		}), (function(t, e, n) {
			if (null != e) {
				if (e instanceof Lr) {
					const r = e.Ra;
					r ? (e = r(e), null != e && pr(t, n, Pn(e, !0).buffer)) : U(K, 3);
					return;
				}
				if (Array.isArray(e)) return void U(K, 3);
			}
			li(t, e, n);
		}), kr)
	];
	let ji;
	let Vi = globalThis.trustedTypes;
	function Xi(t) {
		var e;
		return void 0 === ji && (ji = function() {
			let t = null;
			if (!Vi) return t;
			try {
				const e = (t) => t;
				t = Vi.createPolicy("goog#html", {
					createHTML: e,
					createScript: e,
					createScriptURL: e
				});
			} catch (t) {}
			return t;
		}()), t = (e = ji) ? e.createScriptURL(t) : t, new class {
			constructor(t) {
				this.g = t;
			}
			toString() {
				return this.g + "";
			}
		}(t);
	}
	function Hi(t, ...e) {
		if (0 === e.length) return Xi(t[0]);
		let n = t[0];
		for (let r = 0; r < e.length; r++) n += encodeURIComponent(e[r]) + t[r + 1];
		return Xi(n);
	}
	var Wi = [
		0,
		wi,
		Ci,
		bi,
		-1,
		Ti,
		Ci,
		-1,
		bi
	];
	var zi = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ki = [
		0,
		bi,
		Li,
		bi,
		Ci,
		-1,
		ni((function(t, e, n) {
			return (0 === t.h || 2 === t.h) && (e = un(e, 0 | e[Q], n), 2 == t.h ? Jn(t, Bn, e) : e.push(Nn(t.g)), !0);
		}), (function(t, e, n) {
			if (null != (e = ti(ee, e)) && e.length) {
				n = fr(t, n);
				for (let n = 0; n < e.length; n++) cr(t.g, e[n]);
				dr(t, n);
			}
		}), Sr),
		Li,
		-1,
		[
			0,
			bi,
			-1
		],
		Ci,
		bi,
		-1
	];
	var Yi = [
		0,
		3,
		bi,
		-1,
		2,
		[
			0,
			[2],
			wi,
			Ii,
			[0, ei((function(t, e, n) {
				return 0 === t.h && (ri(e, n, Un(t.g)), !0);
			}), fi, wr)]
		],
		[
			0,
			Ci,
			bi,
			Ci,
			bi,
			Ci,
			bi,
			Li,
			-1
		],
		[
			0,
			[3, 4],
			Li,
			-1,
			Ii,
			[0, wi],
			Ii,
			[0, Ci]
		],
		[0]
	];
	var qi = [
		0,
		Li,
		-2
	];
	var $i = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ji = [0];
	var Zi = [
		0,
		wi,
		bi,
		1,
		bi,
		-4
	];
	var Qi = class extends Lr {
		constructor(t) {
			super(t, 2);
		}
	};
	var ts = {};
	ts[336783863] = [
		0,
		Li,
		bi,
		-1,
		wi,
		[
			0,
			[
				1,
				2,
				3,
				4,
				5,
				6,
				7,
				8,
				9
			],
			Ii,
			Ji,
			Ii,
			Ki,
			Ii,
			qi,
			Ii,
			Zi,
			Ii,
			Wi,
			Ii,
			[
				0,
				Li,
				-2
			],
			Ii,
			[
				0,
				Li,
				Ci
			],
			Ii,
			Yi,
			Ii,
			[
				0,
				Ci,
				-1,
				bi
			]
		],
		[0, Li],
		bi,
		[
			0,
			[1, 3],
			[2, 4],
			Ii,
			[0, Ti],
			-1,
			Ii,
			[0, Si],
			-1,
			Ri,
			[
				0,
				Li,
				-1
			]
		],
		Li
	];
	var es = [
		0,
		vi,
		-1,
		ki,
		-3,
		vi,
		Ti,
		xi,
		Ai,
		vi,
		-1,
		ki,
		Ai,
		ki,
		-2,
		xi
	];
	function ns(t, e) {
		Fn(t, 3, e);
	}
	function rs(t, e) {
		Fn(t, 4, e);
	}
	var is = class extends Lr {
		constructor(t) {
			super(t, 500);
		}
		o(t) {
			return wn(this, 0, 7, t);
		}
	};
	var ss = [-1, {}];
	var os = [
		0,
		Li,
		1,
		ss
	];
	var as = [
		0,
		Li,
		Si,
		ss
	];
	function cs(t, e) {
		bn(t, 1, is, e);
	}
	function hs(t, e) {
		Fn(t, 10, e);
	}
	function us(t, e) {
		Fn(t, 15, e);
	}
	var ls = class extends Lr {
		constructor(t) {
			super(t, 500);
		}
		o(t) {
			return wn(this, 0, 1001, t);
		}
	};
	var fs = [
		-500,
		Ri,
		[
			-500,
			xi,
			-1,
			Si,
			-3,
			[
				-2,
				ts,
				bi
			],
			Ri,
			Gi,
			Ai,
			-1,
			os,
			as,
			Ri,
			[
				0,
				xi,
				ki
			],
			xi,
			es,
			Ai,
			Si,
			987,
			Si
		],
		4,
		Ri,
		[
			-500,
			Li,
			-1,
			[-1, {}],
			998,
			Li
		],
		Ri,
		[
			-500,
			Li,
			Si,
			-1,
			[
				-2,
				{},
				bi
			],
			997,
			Si,
			-1
		],
		Ai,
		Ri,
		[
			-500,
			Li,
			Si,
			ss,
			998,
			Si
		],
		Si,
		Ai,
		os,
		as,
		Ri,
		[
			0,
			xi,
			-1,
			ss
		],
		Si,
		-2,
		es,
		xi,
		-1,
		ki,
		[
			0,
			ki,
			Pi
		],
		978,
		ss,
		Ri,
		Gi
	];
	ls.prototype.g = Di(fs);
	var ds = Ui(ls, fs);
	var ps = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var gs = class extends Lr {
		constructor(t) {
			super(t);
		}
		g() {
			return vn(this, ps, 1);
		}
	};
	var ms = [
		0,
		Ri,
		[
			0,
			wi,
			pi,
			Li,
			-1
		]
	];
	var ys = Ui(gs, ms);
	var _s = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var vs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Es = class extends Lr {
		constructor(t) {
			super(t);
		}
		l() {
			return yn(this, _s, 2);
		}
		g() {
			return vn(this, vs, 5);
		}
	};
	var ws = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		Si,
		Ti,
		mi,
		[
			0,
			Ci,
			[
				0,
				wi,
				-3
			],
			[
				0,
				pi,
				-3
			],
			[
				0,
				wi,
				-1,
				[
					0,
					Ri,
					[
						0,
						wi,
						-2
					]
				]
			],
			Ri,
			[
				0,
				pi,
				-1,
				Li,
				pi
			]
		],
		Li,
		-1,
		_i,
		Ri,
		[
			0,
			wi,
			pi
		],
		Si,
		_i
	]);
	var Ts = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var As = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		Ri,
		[
			0,
			pi,
			-4
		]
	]);
	var bs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var ks = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		Ri,
		[
			0,
			pi,
			-4
		]
	]);
	var Ss = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var xs = [
		0,
		wi,
		-1,
		mi,
		Ci
	];
	var Ls = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	Ls.prototype.g = Di([
		0,
		pi,
		-4,
		_i
	]);
	var Rs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Is = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		Ri,
		[
			0,
			1,
			wi,
			Li,
			ms
		],
		_i
	]);
	var Fs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ms = class extends Lr {
		constructor(t) {
			super(t);
		}
		na() {
			const t = $e(this, 1, void 0, void 0, an);
			return null == t ? R() : t;
		}
	};
	var Ps = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Cs = [1, 2];
	var Os = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		Ri,
		[
			0,
			Cs,
			Ii,
			[0, mi],
			Ii,
			[0, Fi],
			wi,
			Li
		],
		_i
	]);
	var Ns = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Us = [
		0,
		Li,
		wi,
		pi,
		Si,
		-1
	];
	var Ds = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Bs = [
		0,
		bi,
		-1
	];
	var Gs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var js = [
		1,
		2,
		3,
		4,
		5,
		6
	];
	var Vs = class extends Lr {
		constructor(t) {
			super(t);
		}
		g() {
			return null != $e(this, 1, void 0, void 0, an);
		}
		l() {
			return null != le($e(this, 2));
		}
	};
	var Xs = class extends Lr {
		constructor(t) {
			super(t);
		}
		g() {
			return Zt($e(this, 2)) ?? !1;
		}
	};
	var Hs = [
		0,
		Fi,
		Li,
		[
			0,
			wi,
			_i,
			-1
		],
		[
			0,
			Ei,
			_i
		]
	];
	var Ws = [
		0,
		Hs,
		bi,
		[
			0,
			js,
			Ii,
			Zi,
			Ii,
			Ki,
			Ii,
			Wi,
			Ii,
			Ji,
			Ii,
			qi,
			Ii,
			Yi
		],
		Ci
	];
	var zs = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ks = [
		0,
		Ws,
		pi,
		-1,
		wi
	];
	var Ys = Ni(502141897, zs);
	ts[502141897] = Ks;
	var qs = Ui(class extends Lr {
		constructor(t) {
			super(t);
		}
	}, [
		0,
		[
			0,
			Ci,
			-1,
			gi,
			Mi
		],
		xs
	]);
	var $s = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Js = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Zs = [
		0,
		Ws,
		pi,
		[0, Ws],
		bi
	];
	var Qs = Ni(508968150, Js);
	ts[508968150] = [
		0,
		Ws,
		Ks,
		Zs,
		pi,
		[0, [0, Hs]]
	], ts[508968149] = Zs;
	var to = class extends Lr {
		constructor(t) {
			super(t);
		}
		l() {
			return yn(this, Ns, 2);
		}
		g() {
			Ze(this, 2);
		}
	};
	var eo = [
		0,
		Ws,
		Us
	];
	ts[478825465] = eo;
	var no = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var ro = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var io = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var so = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var oo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var ao = [
		0,
		Ws,
		[0, Ws],
		eo,
		-1
	];
	var co = [
		0,
		Ws,
		pi,
		wi
	];
	var ho = [
		0,
		Ws,
		pi
	];
	var uo = [
		0,
		Ws,
		co,
		ho,
		pi
	];
	var lo = Ni(479097054, oo);
	ts[479097054] = [
		0,
		Ws,
		uo,
		ao
	], ts[463370452] = ao, ts[464864288] = co;
	var fo = Ni(462713202, so);
	ts[462713202] = uo, ts[474472470] = ho;
	var po = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var go = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var mo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var yo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var _o = [
		0,
		Ws,
		pi,
		-1,
		wi
	];
	var vo = [
		0,
		Ws,
		pi,
		bi
	];
	yo.prototype.g = Di([
		0,
		Ws,
		ho,
		[0, Ws],
		Ks,
		Zs,
		_o,
		vo
	]);
	var Eo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var wo = Ni(456383383, Eo);
	ts[456383383] = [
		0,
		Ws,
		Us
	];
	var To = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ao = Ni(476348187, To);
	ts[476348187] = [
		0,
		Ws,
		Bs
	];
	var bo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var ko = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var So = [
		0,
		Ci,
		-1
	];
	var xo = Ni(458105876, class extends Lr {
		constructor(t) {
			super(t);
		}
		g() {
			let t;
			var e = this.v;
			const n = 0 | e[Q];
			return t = at(this, n), e = function(t, e, n, r) {
				var i = ko;
				!r && He(t) && (n = 0 | (e = t.v)[Q]);
				var s = Je(e, 2);
				if (t = !1, null == s) {
					if (r) return be();
					s = [];
				} else if (s.constructor === Ee) {
					if (!(2 & s.J) || r) return s;
					s = s.V();
				} else Array.isArray(s) ? t = !!(2 & (0 | s[Q])) : s = [];
				if (r) {
					if (!s.length) return be();
					t || (t = !0, it(s));
				} else t && (t = !1, st(s), s = cn(s));
				return !t && 32 & n && nt(s, 32), n = Qe(e, n, 2, r = new Ee(s, i, de, void 0)), t || ze(e, n), r;
			}(this, e, n, t), !t && ko && (e.ra = !0), e;
		}
	});
	ts[458105876] = [
		0,
		So,
		ii,
		[
			!0,
			_i,
			[
				0,
				Li,
				-1,
				Si
			]
		],
		[
			0,
			Ti,
			bi,
			Ci
		]
	];
	var Lo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Ro = Ni(458105758, Lo);
	ts[458105758] = [
		0,
		Ws,
		Li,
		So
	];
	var Io = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Fo = [
		0,
		yi,
		-1,
		ki
	];
	var Mo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Po = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Co = [1, 2];
	Po.prototype.g = Di([
		0,
		Co,
		Ii,
		Fo,
		Ii,
		[
			0,
			Ri,
			Fo
		]
	]);
	var Oo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var No = Ni(443442058, Oo);
	ts[443442058] = [
		0,
		Ws,
		Li,
		wi,
		pi,
		Si,
		-1,
		bi,
		pi
	], ts[514774813] = _o;
	var Uo = class extends Lr {
		constructor(t) {
			super(t);
		}
	};
	var Do = Ni(516587230, Uo);
	function Bo(t, e) {
		return e = e ? e.clone() : new Ns(), void 0 !== t.displayNamesLocale ? Ze(e, 1, ue(t.displayNamesLocale)) : void 0 === t.displayNamesLocale && Ze(e, 1), void 0 !== t.maxResults ? xn(e, 2, t.maxResults) : "maxResults" in t && Ze(e, 2), void 0 !== t.scoreThreshold ? Ln(e, 3, t.scoreThreshold) : "scoreThreshold" in t && Ze(e, 3), void 0 !== t.categoryAllowlist ? In(e, 4, t.categoryAllowlist) : "categoryAllowlist" in t && Ze(e, 4), void 0 !== t.categoryDenylist ? In(e, 5, t.categoryDenylist) : "categoryDenylist" in t && Ze(e, 5), e;
	}
	function Go(t) {
		const e = Number(t);
		return Number.isSafeInteger(e) ? e : String(t);
	}
	function jo(t, e = -1, n = "") {
		return {
			categories: t.map(((t) => ({
				index: kn(t, 1) ?? 0 ?? -1,
				score: Sn(t, 2) ?? 0,
				categoryName: le($e(t, 3)) ?? "" ?? "",
				displayName: le($e(t, 4)) ?? "" ?? ""
			}))),
			headIndex: e,
			headName: n
		};
	}
	function Vo(t) {
		const e = { classifications: vn(t, Rs, 1).map(((t) => jo(yn(t, gs, 4)?.g() ?? [], kn(t, 2) ?? 0, le($e(t, 3)) ?? ""))) };
		return null != function(t) {
			return null == t ? t : "bigint" == typeof t ? (wt(t) ? t = Number(t) : (t = Xt(64, t), t = wt(t) ? Number(t) : String(t)), t) : te(t) ? "number" == typeof t ? ie(t) : se(t) : void 0;
		}($e(t, 2, void 0, void 0, ce)) && (e.timestampMs = Go($e(t, 2, void 0, void 0, ce) ?? Ye)), e;
	}
	function Xo(t) {
		var e = en(t, 3, $t, tn()), n = en(t, 2, ee, tn()), r = en(t, 1, le, tn()), i = en(t, 9, le, tn());
		const s = {
			categories: [],
			keypoints: []
		};
		for (let t = 0; t < e.length; t++) s.categories.push({
			score: e[t],
			index: n[t] ?? -1,
			categoryName: r[t] ?? "",
			displayName: i[t] ?? ""
		});
		if ((e = yn(t, Es, 4)?.l()) && (s.boundingBox = {
			originX: kn(e, 1, qe) ?? 0,
			originY: kn(e, 2, qe) ?? 0,
			width: kn(e, 3, qe) ?? 0,
			height: kn(e, 4, qe) ?? 0,
			angle: 0
		}), yn(t, Es, 4)?.g().length) for (const e of yn(t, Es, 4).g()) s.keypoints.push({
			x: $e(e, 1, void 0, qe, $t) ?? 0,
			y: $e(e, 2, void 0, qe, $t) ?? 0,
			score: $e(e, 4, void 0, qe, $t) ?? 0,
			label: le($e(e, 3, void 0, qe)) ?? ""
		});
		return s;
	}
	function Ho(t) {
		const e = [];
		for (const n of vn(t, bs, 1)) e.push({
			x: Sn(n, 1) ?? 0,
			y: Sn(n, 2) ?? 0,
			z: Sn(n, 3) ?? 0,
			visibility: Sn(n, 4) ?? 0
		});
		return e;
	}
	function Wo(t) {
		const e = [];
		for (const n of vn(t, Ts, 1)) e.push({
			x: Sn(n, 1) ?? 0,
			y: Sn(n, 2) ?? 0,
			z: Sn(n, 3) ?? 0,
			visibility: Sn(n, 4) ?? 0
		});
		return e;
	}
	function zo(t) {
		return Array.from(t, ((t) => t > 127 ? t - 256 : t));
	}
	function Ko(t, e) {
		if (t.length !== e.length) throw Error(\`Cannot compute cosine similarity between embeddings of different sizes (\${t.length} vs. \${e.length}).\`);
		let n = 0, r = 0, i = 0;
		for (let s = 0; s < t.length; s++) n += t[s] * e[s], r += t[s] * t[s], i += e[s] * e[s];
		if (r <= 0 || i <= 0) throw Error("Cannot compute cosine similarity on embedding with 0 norm.");
		return n / Math.sqrt(r * i);
	}
	let Yo;
	ts[516587230] = [
		0,
		Ws,
		_o,
		vo,
		pi
	], ts[518928384] = vo;
	const qo = new Uint8Array([
		0,
		97,
		115,
		109,
		1,
		0,
		0,
		0,
		1,
		5,
		1,
		96,
		0,
		1,
		123,
		3,
		2,
		1,
		0,
		10,
		10,
		1,
		8,
		0,
		65,
		0,
		253,
		15,
		253,
		98,
		11
	]);
	async function $o(t) {
		if (t) return !0;
		if (void 0 === Yo) try {
			await WebAssembly.instantiate(qo), Yo = !0;
		} catch {
			Yo = !1;
		}
		return Yo;
	}
	async function Jo(t, e, n) {
		return {
			wasmLoaderPath: \`\${e}/\${t}_\${n = \`wasm\${n ? "_module" : ""}\${await $o(n) ? "" : "_nosimd"}_internal\`}.js\`,
			wasmBinaryPath: \`\${e}/\${t}_\${n}.wasm\`
		};
	}
	var Zo = class {};
	function Qo() {
		var t = navigator;
		return "undefined" != typeof OffscreenCanvas && (!function(t = navigator) {
			return (t = t.userAgent).includes("Safari") && !t.includes("Chrome");
		}(t) || !!((t = t.userAgent.match(/Version\\/([\\d]+).*Safari/)) && t.length >= 1 && Number(t[1]) >= 17));
	}
	async function ta(t) {
		if ("function" != typeof importScripts) {
			const e = document.createElement("script");
			return e.src = t.toString(), e.crossOrigin = "anonymous", new Promise(((t, n) => {
				e.addEventListener("load", (() => {
					t();
				}), !1), e.addEventListener("error", ((t) => {
					n(t);
				}), !1), document.body.appendChild(e);
			}));
		}
		try {
			importScripts(t.toString());
		} catch (e) {
			if (!(e instanceof TypeError)) throw e;
			{
				const e = self.import;
				e ? await e(t.toString()) : await import(t.toString());
			}
		}
	}
	function ea(t) {
		return void 0 !== t.videoWidth ? [t.videoWidth, t.videoHeight] : void 0 !== t.naturalWidth ? [t.naturalWidth, t.naturalHeight] : void 0 !== t.displayWidth ? [t.displayWidth, t.displayHeight] : [t.width, t.height];
	}
	function na(t, e, n) {
		t.m || console.error("No wasm multistream support detected: ensure dependency inclusion of :gl_graph_runner_internal_multi_input target"), n(e = t.i.stringToNewUTF8(e)), t.i._free(e);
	}
	function ra(t, e, n) {
		if (!t.i.canvas) throw Error("No OpenGL canvas configured.");
		if (n ? t.i._bindTextureToStream(n) : t.i._bindTextureToCanvas(), !(n = t.i.canvas.getContext("webgl2") || t.i.canvas.getContext("webgl"))) throw Error("Failed to obtain WebGL context from the provided canvas. \`getContext()\` should only be invoked with \`webgl\` or \`webgl2\`.");
		t.i.gpuOriginForWebTexturesIsBottomLeft && n.pixelStorei(n.UNPACK_FLIP_Y_WEBGL, !0), n.texImage2D(n.TEXTURE_2D, 0, n.RGBA, n.RGBA, n.UNSIGNED_BYTE, e), t.i.gpuOriginForWebTexturesIsBottomLeft && n.pixelStorei(n.UNPACK_FLIP_Y_WEBGL, !1);
		const [r, i] = ea(e);
		return !t.l || r === t.i.canvas.width && i === t.i.canvas.height || (t.i.canvas.width = r, t.i.canvas.height = i), [r, i];
	}
	function ia(t, e, n) {
		t.m || console.error("No wasm multistream support detected: ensure dependency inclusion of :gl_graph_runner_internal_multi_input target");
		const r = new Uint32Array(e.length);
		for (let n = 0; n < e.length; n++) r[n] = t.i.stringToNewUTF8(e[n]);
		e = t.i._malloc(4 * r.length), t.i.HEAPU32.set(r, e >> 2), n(e);
		for (const e of r) t.i._free(e);
		t.i._free(e);
	}
	function sa(t, e, n) {
		t.i.simpleListeners = t.i.simpleListeners || {}, t.i.simpleListeners[e] = n;
	}
	function oa(t, e, n) {
		let r = [];
		t.i.simpleListeners = t.i.simpleListeners || {}, t.i.simpleListeners[e] = (t, e, i) => {
			e ? (n(r, i), r = []) : r.push(t);
		};
	}
	Zo.forVisionTasks = function(t, e = !1) {
		return Jo("vision", t ?? Hi\`\`, e);
	}, Zo.forTextTasks = function(t, e = !1) {
		return Jo("text", t ?? Hi\`\`, e);
	}, Zo.forGenAiTasks = function(t, e = !1) {
		return Jo("genai", t ?? Hi\`\`, e);
	}, Zo.forAudioTasks = function(t, e = !1) {
		return Jo("audio", t ?? Hi\`\`, e);
	}, Zo.isSimdSupported = function(t = !1) {
		return $o(t);
	};
	async function aa(t, e, n, r) {
		return t = await (async (t, e, n, r, i) => {
			if (e && await ta(e), !self.ModuleFactory) throw Error("ModuleFactory not set.");
			if (n && (await ta(n), !self.ModuleFactory)) throw Error("ModuleFactory not set.");
			return self.Module && i && ((e = self.Module).locateFile = i.locateFile, i.mainScriptUrlOrBlob && (e.mainScriptUrlOrBlob = i.mainScriptUrlOrBlob)), i = await self.ModuleFactory(self.Module || i), self.ModuleFactory = self.Module = void 0, new t(i, r);
		})(t, n.wasmLoaderPath, n.assetLoaderPath, e, { locateFile: (t) => t.endsWith(".wasm") ? n.wasmBinaryPath.toString() : n.assetBinaryPath && t.endsWith(".data") ? n.assetBinaryPath.toString() : t }), await t.o(r), t;
	}
	function ca(t, e) {
		const n = yn(t.baseOptions, Vs, 1) || new Vs();
		"string" == typeof e ? (Ze(n, 2, ue(e)), Ze(n, 1)) : e instanceof Uint8Array && (Ze(n, 1, ht(e, !1)), Ze(n, 2)), wn(t.baseOptions, 0, 1, n);
	}
	function ha(t) {
		try {
			const e = t.H.length;
			if (1 === e) throw Error(t.H[0].message);
			if (e > 1) throw Error("Encountered multiple errors: " + t.H.map(((t) => t.message)).join(", "));
		} finally {
			t.H = [];
		}
	}
	function ua(t, e) {
		t.C = Math.max(t.C, e);
	}
	function la(t, e) {
		t.B = new is(), Rn(t.B, 2, "PassThroughCalculator"), ns(t.B, "free_memory"), rs(t.B, "free_memory_unused_out"), hs(e, "free_memory"), cs(e, t.B);
	}
	function fa(t, e) {
		ns(t.B, e), rs(t.B, e + "_unused_out");
	}
	function da(t) {
		t.g.addBoolToStream(!0, "free_memory", t.C);
	}
	var pa = class {
		constructor(t) {
			this.g = t, this.H = [], this.C = 0, this.g.setAutoRenderToScreen(!1);
		}
		l(t, e = !0) {
			if (e) {
				const e = t.baseOptions || {};
				if (t.baseOptions?.modelAssetBuffer && t.baseOptions?.modelAssetPath) throw Error("Cannot set both baseOptions.modelAssetPath and baseOptions.modelAssetBuffer");
				if (!(yn(this.baseOptions, Vs, 1)?.g() || yn(this.baseOptions, Vs, 1)?.l() || t.baseOptions?.modelAssetBuffer || t.baseOptions?.modelAssetPath)) throw Error("Either baseOptions.modelAssetPath or baseOptions.modelAssetBuffer must be set");
				if (function(t, e) {
					let n = yn(t.baseOptions, Gs, 3);
					if (!n) {
						var r = n = new Gs(), i = new $i();
						Tn(r, 4, js, i);
					}
					"delegate" in e && ("GPU" === e.delegate ? (e = n, r = new zi(), Tn(e, 2, js, r)) : (e = n, r = new $i(), Tn(e, 4, js, r))), wn(t.baseOptions, 0, 3, n);
				}(this, e), e.modelAssetPath) return fetch(e.modelAssetPath.toString()).then(((t) => {
					if (t.ok) return t.arrayBuffer();
					throw Error(\`Failed to fetch model: \${e.modelAssetPath} (\${t.status})\`);
				})).then(((t) => {
					try {
						this.g.i.FS_unlink("/model.dat");
					} catch {}
					this.g.i.FS_createDataFile("/", "model.dat", new Uint8Array(t), !0, !1, !1), ca(this, "/model.dat"), this.m(), this.L();
				}));
				if (e.modelAssetBuffer instanceof Uint8Array) ca(this, e.modelAssetBuffer);
				else if (e.modelAssetBuffer) return async function(t) {
					const e = [];
					for (var n = 0;;) {
						const { done: r, value: i } = await t.read();
						if (r) break;
						e.push(i), n += i.length;
					}
					if (0 === e.length) return /* @__PURE__ */ new Uint8Array(0);
					if (1 === e.length) return e[0];
					t = new Uint8Array(n), n = 0;
					for (const r of e) t.set(r, n), n += r.length;
					return t;
				}(e.modelAssetBuffer).then(((t) => {
					ca(this, t), this.m(), this.L();
				}));
			}
			return this.m(), this.L(), Promise.resolve();
		}
		L() {}
		ca() {
			let t;
			if (this.g.ca(((e) => {
				t = ds(e);
			})), !t) throw Error("Failed to retrieve CalculatorGraphConfig");
			return t;
		}
		setGraph(t, e) {
			this.g.attachErrorListener(((t, e) => {
				this.H.push(Error(e));
			})), this.g.Ja(), this.g.setGraph(t, e), this.B = void 0, ha(this);
		}
		finishProcessing() {
			this.g.finishProcessing(), ha(this);
		}
		close() {
			this.B = void 0, this.g.closeGraph();
		}
	};
	function ga(t, e) {
		if (!t) throw Error(\`Unable to obtain required WebGL resource: \${e}\`);
		return t;
	}
	pa.prototype.close = pa.prototype.close;
	var ma = class {
		constructor(t, e, n, r) {
			this.g = t, this.h = e, this.m = n, this.l = r;
		}
		bind() {
			this.g.bindVertexArray(this.h);
		}
		close() {
			this.g.deleteVertexArray(this.h), this.g.deleteBuffer(this.m), this.g.deleteBuffer(this.l);
		}
	};
	function ya(t, e, n) {
		const r = t.g;
		if (n = ga(r.createShader(n), "Failed to create WebGL shader"), r.shaderSource(n, e), r.compileShader(n), !r.getShaderParameter(n, r.COMPILE_STATUS)) throw Error(\`Could not compile WebGL shader: \${r.getShaderInfoLog(n)}\`);
		return r.attachShader(t.h, n), n;
	}
	function _a(t, e) {
		const n = t.g, r = ga(n.createVertexArray(), "Failed to create vertex array");
		n.bindVertexArray(r);
		const i = ga(n.createBuffer(), "Failed to create buffer");
		n.bindBuffer(n.ARRAY_BUFFER, i), n.enableVertexAttribArray(t.O), n.vertexAttribPointer(t.O, 2, n.FLOAT, !1, 0, 0), n.bufferData(n.ARRAY_BUFFER, new Float32Array([
			-1,
			-1,
			-1,
			1,
			1,
			1,
			1,
			-1
		]), n.STATIC_DRAW);
		const s = ga(n.createBuffer(), "Failed to create buffer");
		return n.bindBuffer(n.ARRAY_BUFFER, s), n.enableVertexAttribArray(t.L), n.vertexAttribPointer(t.L, 2, n.FLOAT, !1, 0, 0), n.bufferData(n.ARRAY_BUFFER, new Float32Array(e ? [
			0,
			1,
			0,
			0,
			1,
			0,
			1,
			1
		] : [
			0,
			0,
			0,
			1,
			1,
			1,
			1,
			0
		]), n.STATIC_DRAW), n.bindBuffer(n.ARRAY_BUFFER, null), n.bindVertexArray(null), new ma(n, r, i, s);
	}
	function va(t, e) {
		if (t.g) {
			if (e !== t.g) throw Error("Cannot change GL context once initialized");
		} else t.g = e;
	}
	function Ea(t, e, n, r) {
		return va(t, e), t.h || (t.m(), t.D()), n ? (t.u || (t.u = _a(t, !0)), n = t.u) : (t.A || (t.A = _a(t, !1)), n = t.A), e.useProgram(t.h), n.bind(), t.l(), t = r(), n.g.bindVertexArray(null), t;
	}
	function wa(t, e, n) {
		return va(t, e), t = ga(e.createTexture(), "Failed to create texture"), e.bindTexture(e.TEXTURE_2D, t), e.texParameteri(e.TEXTURE_2D, e.TEXTURE_WRAP_S, e.CLAMP_TO_EDGE), e.texParameteri(e.TEXTURE_2D, e.TEXTURE_WRAP_T, e.CLAMP_TO_EDGE), e.texParameteri(e.TEXTURE_2D, e.TEXTURE_MIN_FILTER, n ?? e.LINEAR), e.texParameteri(e.TEXTURE_2D, e.TEXTURE_MAG_FILTER, n ?? e.LINEAR), e.bindTexture(e.TEXTURE_2D, null), t;
	}
	function Ta(t, e, n) {
		va(t, e), t.B || (t.B = ga(e.createFramebuffer(), "Failed to create framebuffe.")), e.bindFramebuffer(e.FRAMEBUFFER, t.B), e.framebufferTexture2D(e.FRAMEBUFFER, e.COLOR_ATTACHMENT0, e.TEXTURE_2D, n, 0);
	}
	function Aa(t) {
		t.g?.bindFramebuffer(t.g.FRAMEBUFFER, null);
	}
	var ba = class {
		H() {
			return "\\n  precision mediump float;\\n  varying vec2 vTex;\\n  uniform sampler2D inputTexture;\\n  void main() {\\n    gl_FragColor = texture2D(inputTexture, vTex);\\n  }\\n ";
		}
		m() {
			const t = this.g;
			if (this.h = ga(t.createProgram(), "Failed to create WebGL program"), this.X = ya(this, "\\n  attribute vec2 aVertex;\\n  attribute vec2 aTex;\\n  varying vec2 vTex;\\n  void main(void) {\\n    gl_Position = vec4(aVertex, 0.0, 1.0);\\n    vTex = aTex;\\n  }", t.VERTEX_SHADER), this.W = ya(this, this.H(), t.FRAGMENT_SHADER), t.linkProgram(this.h), !t.getProgramParameter(this.h, t.LINK_STATUS)) throw Error(\`Error during program linking: \${t.getProgramInfoLog(this.h)}\`);
			this.O = t.getAttribLocation(this.h, "aVertex"), this.L = t.getAttribLocation(this.h, "aTex");
		}
		D() {}
		l() {}
		close() {
			if (this.h) {
				const t = this.g;
				t.deleteProgram(this.h), t.deleteShader(this.X), t.deleteShader(this.W);
			}
			this.B && this.g.deleteFramebuffer(this.B), this.A && this.A.close(), this.u && this.u.close();
		}
	};
	var ka = class extends ba {
		H() {
			return "\\n  precision mediump float;\\n  uniform sampler2D backgroundTexture;\\n  uniform sampler2D maskTexture;\\n  uniform sampler2D colorMappingTexture;\\n  varying vec2 vTex;\\n  void main() {\\n    vec4 backgroundColor = texture2D(backgroundTexture, vTex);\\n    float category = texture2D(maskTexture, vTex).r;\\n    vec4 categoryColor = texture2D(colorMappingTexture, vec2(category, 0.0));\\n    gl_FragColor = mix(backgroundColor, categoryColor, categoryColor.a);\\n  }\\n ";
		}
		D() {
			const t = this.g;
			t.activeTexture(t.TEXTURE1), this.C = wa(this, t, t.LINEAR), t.activeTexture(t.TEXTURE2), this.j = wa(this, t, t.NEAREST);
		}
		m() {
			super.m();
			const t = this.g;
			this.P = ga(t.getUniformLocation(this.h, "backgroundTexture"), "Uniform location"), this.U = ga(t.getUniformLocation(this.h, "colorMappingTexture"), "Uniform location"), this.M = ga(t.getUniformLocation(this.h, "maskTexture"), "Uniform location");
		}
		l() {
			super.l();
			const t = this.g;
			t.uniform1i(this.M, 0), t.uniform1i(this.P, 1), t.uniform1i(this.U, 2);
		}
		close() {
			this.C && this.g.deleteTexture(this.C), this.j && this.g.deleteTexture(this.j), super.close();
		}
	};
	var Sa = class extends ba {
		H() {
			return "\\n  precision mediump float;\\n  uniform sampler2D maskTexture;\\n  uniform sampler2D defaultTexture;\\n  uniform sampler2D overlayTexture;\\n  varying vec2 vTex;\\n  void main() {\\n    float confidence = texture2D(maskTexture, vTex).r;\\n    vec4 defaultColor = texture2D(defaultTexture, vTex);\\n    vec4 overlayColor = texture2D(overlayTexture, vTex);\\n    // Apply the alpha from the overlay and merge in the default color\\n    overlayColor = mix(defaultColor, overlayColor, overlayColor.a);\\n    gl_FragColor = mix(defaultColor, overlayColor, confidence);\\n  }\\n ";
		}
		D() {
			const t = this.g;
			t.activeTexture(t.TEXTURE1), this.j = wa(this, t), t.activeTexture(t.TEXTURE2), this.C = wa(this, t);
		}
		m() {
			super.m();
			const t = this.g;
			this.M = ga(t.getUniformLocation(this.h, "defaultTexture"), "Uniform location"), this.P = ga(t.getUniformLocation(this.h, "overlayTexture"), "Uniform location"), this.I = ga(t.getUniformLocation(this.h, "maskTexture"), "Uniform location");
		}
		l() {
			super.l();
			const t = this.g;
			t.uniform1i(this.I, 0), t.uniform1i(this.M, 1), t.uniform1i(this.P, 2);
		}
		close() {
			this.j && this.g.deleteTexture(this.j), this.C && this.g.deleteTexture(this.C), super.close();
		}
	};
	function xa(t, e) {
		switch (e) {
			case 0: return t.g.find(((t) => t instanceof Uint8Array));
			case 1: return t.g.find(((t) => t instanceof Float32Array));
			case 2: return t.g.find(((t) => "undefined" != typeof WebGLTexture && t instanceof WebGLTexture));
			default: throw Error(\`Type is not supported: \${e}\`);
		}
	}
	function La(t) {
		var e = xa(t, 1);
		if (!e) {
			if (e = xa(t, 0)) e = new Float32Array(e).map(((t) => t / 255));
			else {
				e = new Float32Array(t.width * t.height);
				const r = Ia(t);
				var n = Ma(t);
				if (Ta(n, r, Ra(t)), "iPad Simulator;iPhone Simulator;iPod Simulator;iPad;iPhone;iPod".split(";").includes(navigator.platform) || navigator.userAgent.includes("Mac") && "document" in self && "ontouchend" in self.document) {
					n = new Float32Array(t.width * t.height * 4), r.readPixels(0, 0, t.width, t.height, r.RGBA, r.FLOAT, n);
					for (let t = 0, r = 0; t < e.length; ++t, r += 4) e[t] = n[r];
				} else r.readPixels(0, 0, t.width, t.height, r.RED, r.FLOAT, e);
			}
			t.g.push(e);
		}
		return e;
	}
	function Ra(t) {
		let e = xa(t, 2);
		if (!e) {
			const n = Ia(t);
			e = Pa(t);
			const r = La(t), i = Fa(t);
			n.texImage2D(n.TEXTURE_2D, 0, i, t.width, t.height, 0, n.RED, n.FLOAT, r), Ca(t);
		}
		return e;
	}
	function Ia(t) {
		if (!t.canvas) throw Error("Conversion to different image formats require that a canvas is passed when initializing the image.");
		return t.h || (t.h = ga(t.canvas.getContext("webgl2"), "You cannot use a canvas that is already bound to a different type of rendering context.")), t.h;
	}
	function Fa(t) {
		if (t = Ia(t), !Oa) if (t.getExtension("EXT_color_buffer_float") && t.getExtension("OES_texture_float_linear") && t.getExtension("EXT_float_blend")) Oa = t.R32F;
		else {
			if (!t.getExtension("EXT_color_buffer_half_float")) throw Error("GPU does not fully support 4-channel float32 or float16 formats");
			Oa = t.R16F;
		}
		return Oa;
	}
	function Ma(t) {
		return t.l || (t.l = new ba()), t.l;
	}
	function Pa(t) {
		const e = Ia(t);
		e.viewport(0, 0, t.width, t.height), e.activeTexture(e.TEXTURE0);
		let n = xa(t, 2);
		return n || (n = wa(Ma(t), e, t.m ? e.LINEAR : e.NEAREST), t.g.push(n), t.j = !0), e.bindTexture(e.TEXTURE_2D, n), n;
	}
	function Ca(t) {
		t.h.bindTexture(t.h.TEXTURE_2D, null);
	}
	var Oa;
	var Na = class {
		constructor(t, e, n, r, i, s, o) {
			this.g = t, this.m = e, this.j = n, this.canvas = r, this.l = i, this.width = s, this.height = o, this.j && 0 === --Ua && console.error("You seem to be creating MPMask instances without invoking .close(). This leaks resources.");
		}
		Fa() {
			return !!xa(this, 0);
		}
		ka() {
			return !!xa(this, 1);
		}
		R() {
			return !!xa(this, 2);
		}
		ja() {
			return (e = xa(t = this, 0)) || (e = La(t), e = new Uint8Array(e.map(((t) => Math.round(255 * t)))), t.g.push(e)), e;
			var t, e;
		}
		ia() {
			return La(this);
		}
		N() {
			return Ra(this);
		}
		clone() {
			const t = [];
			for (const e of this.g) {
				let n;
				if (e instanceof Uint8Array) n = new Uint8Array(e);
				else if (e instanceof Float32Array) n = new Float32Array(e);
				else {
					if (!(e instanceof WebGLTexture)) throw Error(\`Type is not supported: \${e}\`);
					{
						const t = Ia(this), e = Ma(this);
						t.activeTexture(t.TEXTURE1), n = wa(e, t, this.m ? t.LINEAR : t.NEAREST), t.bindTexture(t.TEXTURE_2D, n);
						const r = Fa(this);
						t.texImage2D(t.TEXTURE_2D, 0, r, this.width, this.height, 0, t.RED, t.FLOAT, null), t.bindTexture(t.TEXTURE_2D, null), Ta(e, t, n), Ea(e, t, !1, (() => {
							Pa(this), t.clearColor(0, 0, 0, 0), t.clear(t.COLOR_BUFFER_BIT), t.drawArrays(t.TRIANGLE_FAN, 0, 4), Ca(this);
						})), Aa(e), Ca(this);
					}
				}
				t.push(n);
			}
			return new Na(t, this.m, this.R(), this.canvas, this.l, this.width, this.height);
		}
		close() {
			this.j && Ia(this).deleteTexture(xa(this, 2)), Ua = -1;
		}
	};
	Na.prototype.close = Na.prototype.close, Na.prototype.clone = Na.prototype.clone, Na.prototype.getAsWebGLTexture = Na.prototype.N, Na.prototype.getAsFloat32Array = Na.prototype.ia, Na.prototype.getAsUint8Array = Na.prototype.ja, Na.prototype.hasWebGLTexture = Na.prototype.R, Na.prototype.hasFloat32Array = Na.prototype.ka, Na.prototype.hasUint8Array = Na.prototype.Fa;
	var Ua = 250;
	const Da = {
		color: "white",
		lineWidth: 4,
		radius: 6
	};
	function Ba(t) {
		return {
			...Da,
			fillColor: (t = t || {}).color,
			...t
		};
	}
	function Ga(t, e) {
		return t instanceof Function ? t(e) : t;
	}
	function ja(t, e, n) {
		return Math.max(Math.min(e, n), Math.min(Math.max(e, n), t));
	}
	function Va(t) {
		if (!t.l) throw Error("CPU rendering requested but CanvasRenderingContext2D not provided.");
		return t.l;
	}
	function Xa(t) {
		if (!t.j) throw Error("GPU rendering requested but WebGL2RenderingContext not provided.");
		return t.j;
	}
	function Ha(t, e, n) {
		if (e.R()) n(e.N());
		else {
			const r = e.ka() ? e.ia() : e.ja();
			t.m = t.m ?? new ba();
			const i = Xa(t);
			n((t = new Na([r], e.m, !1, i.canvas, t.m, e.width, e.height)).N()), t.close();
		}
	}
	function Wa(t, e, n, r) {
		const i = function(t) {
			return t.g || (t.g = new ka()), t.g;
		}(t), s = Xa(t), o = Array.isArray(n) ? new ImageData(new Uint8ClampedArray(n), 1, 1) : n;
		Ea(i, s, !0, (() => {
			(function(t, e, n, r) {
				const i = t.g;
				if (i.activeTexture(i.TEXTURE0), i.bindTexture(i.TEXTURE_2D, e), i.activeTexture(i.TEXTURE1), i.bindTexture(i.TEXTURE_2D, t.C), i.texImage2D(i.TEXTURE_2D, 0, i.RGBA, i.RGBA, i.UNSIGNED_BYTE, n), t.I && function(t, e) {
					if (t !== e) return !1;
					t = t.entries(), e = e.entries();
					for (const [n, r] of t) {
						t = n;
						const i = r, s = e.next();
						if (s.done) return !1;
						const [o, a] = s.value;
						if (t !== o || i[0] !== a[0] || i[1] !== a[1] || i[2] !== a[2] || i[3] !== a[3]) return !1;
					}
					return !!e.next().done;
				}(t.I, r)) i.activeTexture(i.TEXTURE2), i.bindTexture(i.TEXTURE_2D, t.j);
				else {
					t.I = r;
					const e = Array(1024).fill(0);
					r.forEach(((t, n) => {
						if (4 !== t.length) throw Error(\`Color at index \${n} is not a four-channel value.\`);
						e[4 * n] = t[0], e[4 * n + 1] = t[1], e[4 * n + 2] = t[2], e[4 * n + 3] = t[3];
					})), i.activeTexture(i.TEXTURE2), i.bindTexture(i.TEXTURE_2D, t.j), i.texImage2D(i.TEXTURE_2D, 0, i.RGBA, 256, 1, 0, i.RGBA, i.UNSIGNED_BYTE, new Uint8Array(e));
				}
			})(i, e, o, r), s.clearColor(0, 0, 0, 0), s.clear(s.COLOR_BUFFER_BIT), s.drawArrays(s.TRIANGLE_FAN, 0, 4);
			const t = i.g;
			t.activeTexture(t.TEXTURE0), t.bindTexture(t.TEXTURE_2D, null), t.activeTexture(t.TEXTURE1), t.bindTexture(t.TEXTURE_2D, null), t.activeTexture(t.TEXTURE2), t.bindTexture(t.TEXTURE_2D, null);
		}));
	}
	function za(t, e, n, r) {
		const i = Xa(t), s = function(t) {
			return t.h || (t.h = new Sa()), t.h;
		}(t), o = Array.isArray(n) ? new ImageData(new Uint8ClampedArray(n), 1, 1) : n, a = Array.isArray(r) ? new ImageData(new Uint8ClampedArray(r), 1, 1) : r;
		Ea(s, i, !0, (() => {
			var t = s.g;
			t.activeTexture(t.TEXTURE0), t.bindTexture(t.TEXTURE_2D, e), t.activeTexture(t.TEXTURE1), t.bindTexture(t.TEXTURE_2D, s.j), t.texImage2D(t.TEXTURE_2D, 0, t.RGBA, t.RGBA, t.UNSIGNED_BYTE, o), t.activeTexture(t.TEXTURE2), t.bindTexture(t.TEXTURE_2D, s.C), t.texImage2D(t.TEXTURE_2D, 0, t.RGBA, t.RGBA, t.UNSIGNED_BYTE, a), i.clearColor(0, 0, 0, 0), i.clear(i.COLOR_BUFFER_BIT), i.drawArrays(i.TRIANGLE_FAN, 0, 4), i.bindTexture(i.TEXTURE_2D, null), (t = s.g).activeTexture(t.TEXTURE0), t.bindTexture(t.TEXTURE_2D, null), t.activeTexture(t.TEXTURE1), t.bindTexture(t.TEXTURE_2D, null), t.activeTexture(t.TEXTURE2), t.bindTexture(t.TEXTURE_2D, null);
		}));
	}
	var Ka = class {
		constructor(t, e) {
			"undefined" != typeof CanvasRenderingContext2D && t instanceof CanvasRenderingContext2D || t instanceof OffscreenCanvasRenderingContext2D ? (this.l = t, this.j = e) : this.j = t;
		}
		ya(t, e) {
			if (t) {
				var n = Va(this);
				e = Ba(e), n.save();
				var r = n.canvas, i = 0;
				for (const s of t) n.fillStyle = Ga(e.fillColor, {
					index: i,
					from: s
				}), n.strokeStyle = Ga(e.color, {
					index: i,
					from: s
				}), n.lineWidth = Ga(e.lineWidth, {
					index: i,
					from: s
				}), (t = new Path2D()).arc(s.x * r.width, s.y * r.height, Ga(e.radius, {
					index: i,
					from: s
				}), 0, 2 * Math.PI), n.fill(t), n.stroke(t), ++i;
				n.restore();
			}
		}
		xa(t, e, n) {
			if (t && e) {
				var r = Va(this);
				n = Ba(n), r.save();
				var i = r.canvas, s = 0;
				for (const o of e) {
					r.beginPath(), e = t[o.start];
					const a = t[o.end];
					e && a && (r.strokeStyle = Ga(n.color, {
						index: s,
						from: e,
						to: a
					}), r.lineWidth = Ga(n.lineWidth, {
						index: s,
						from: e,
						to: a
					}), r.moveTo(e.x * i.width, e.y * i.height), r.lineTo(a.x * i.width, a.y * i.height)), ++s, r.stroke();
				}
				r.restore();
			}
		}
		ua(t, e) {
			const n = Va(this);
			e = Ba(e), n.save(), n.beginPath(), n.lineWidth = Ga(e.lineWidth, {}), n.strokeStyle = Ga(e.color, {}), n.fillStyle = Ga(e.fillColor, {}), n.moveTo(t.originX, t.originY), n.lineTo(t.originX + t.width, t.originY), n.lineTo(t.originX + t.width, t.originY + t.height), n.lineTo(t.originX, t.originY + t.height), n.lineTo(t.originX, t.originY), n.stroke(), n.fill(), n.restore();
		}
		va(t, e, n = [
			0,
			0,
			0,
			255
		]) {
			this.l ? function(t, e, n, r) {
				const i = Xa(t);
				Ha(t, e, ((e) => {
					Wa(t, e, n, r), (e = Va(t)).drawImage(i.canvas, 0, 0, e.canvas.width, e.canvas.height);
				}));
			}(this, t, n, e) : Wa(this, t.N(), n, e);
		}
		wa(t, e, n) {
			this.l ? function(t, e, n, r) {
				const i = Xa(t);
				Ha(t, e, ((e) => {
					za(t, e, n, r), (e = Va(t)).drawImage(i.canvas, 0, 0, e.canvas.width, e.canvas.height);
				}));
			}(this, t, e, n) : za(this, t.N(), e, n);
		}
		close() {
			this.g?.close(), this.g = void 0, this.h?.close(), this.h = void 0, this.m?.close(), this.m = void 0;
		}
	};
	function Ya(t, e) {
		switch (e) {
			case 0: return t.g.find(((t) => t instanceof ImageData));
			case 1: return t.g.find(((t) => "undefined" != typeof ImageBitmap && t instanceof ImageBitmap));
			case 2: return t.g.find(((t) => "undefined" != typeof WebGLTexture && t instanceof WebGLTexture));
			default: throw Error(\`Type is not supported: \${e}\`);
		}
	}
	function qa(t) {
		var e = Ya(t, 0);
		if (!e) {
			e = Ja(t);
			const n = Za(t), r = new Uint8Array(t.width * t.height * 4);
			Ta(n, e, $a(t)), e.readPixels(0, 0, t.width, t.height, e.RGBA, e.UNSIGNED_BYTE, r), Aa(n), e = new ImageData(new Uint8ClampedArray(r.buffer), t.width, t.height), t.g.push(e);
		}
		return e;
	}
	function $a(t) {
		let e = Ya(t, 2);
		if (!e) {
			const n = Ja(t);
			e = Qa(t);
			const r = Ya(t, 1) || qa(t);
			n.texImage2D(n.TEXTURE_2D, 0, n.RGBA, n.RGBA, n.UNSIGNED_BYTE, r), tc(t);
		}
		return e;
	}
	function Ja(t) {
		if (!t.canvas) throw Error("Conversion to different image formats require that a canvas is passed when initializing the image.");
		return t.h || (t.h = ga(t.canvas.getContext("webgl2"), "You cannot use a canvas that is already bound to a different type of rendering context.")), t.h;
	}
	function Za(t) {
		return t.l || (t.l = new ba()), t.l;
	}
	function Qa(t) {
		const e = Ja(t);
		e.viewport(0, 0, t.width, t.height), e.activeTexture(e.TEXTURE0);
		let n = Ya(t, 2);
		return n || (n = wa(Za(t), e), t.g.push(n), t.m = !0), e.bindTexture(e.TEXTURE_2D, n), n;
	}
	function tc(t) {
		t.h.bindTexture(t.h.TEXTURE_2D, null);
	}
	function ec(t) {
		const e = Ja(t);
		return Ea(Za(t), e, !0, (() => function(t, e) {
			const n = t.canvas;
			if (n.width === t.width && n.height === t.height) return e();
			const r = n.width, i = n.height;
			return n.width = t.width, n.height = t.height, t = e(), n.width = r, n.height = i, t;
		}(t, (() => {
			if (e.bindFramebuffer(e.FRAMEBUFFER, null), e.clearColor(0, 0, 0, 0), e.clear(e.COLOR_BUFFER_BIT), e.drawArrays(e.TRIANGLE_FAN, 0, 4), !(t.canvas instanceof OffscreenCanvas)) throw Error("Conversion to ImageBitmap requires that the MediaPipe Tasks is initialized with an OffscreenCanvas");
			return t.canvas.transferToImageBitmap();
		}))));
	}
	Ka.prototype.close = Ka.prototype.close, Ka.prototype.drawConfidenceMask = Ka.prototype.wa, Ka.prototype.drawCategoryMask = Ka.prototype.va, Ka.prototype.drawBoundingBox = Ka.prototype.ua, Ka.prototype.drawConnectors = Ka.prototype.xa, Ka.prototype.drawLandmarks = Ka.prototype.ya, Ka.lerp = function(t, e, n, r, i) {
		return ja(r * (1 - (t - e) / (n - e)) + i * (1 - (n - t) / (n - e)), r, i);
	}, Ka.clamp = ja;
	var nc = class {
		constructor(t, e, n, r, i, s, o) {
			this.g = t, this.j = e, this.m = n, this.canvas = r, this.l = i, this.width = s, this.height = o, (this.j || this.m) && 0 === --rc && console.error("You seem to be creating MPImage instances without invoking .close(). This leaks resources.");
		}
		Ea() {
			return !!Ya(this, 0);
		}
		la() {
			return !!Ya(this, 1);
		}
		R() {
			return !!Ya(this, 2);
		}
		Ca() {
			return qa(this);
		}
		Ba() {
			var t = Ya(this, 1);
			return t || ($a(this), Qa(this), t = ec(this), tc(this), this.g.push(t), this.j = !0), t;
		}
		N() {
			return $a(this);
		}
		clone() {
			const t = [];
			for (const e of this.g) {
				let n;
				if (e instanceof ImageData) n = new ImageData(e.data, this.width, this.height);
				else if (e instanceof WebGLTexture) {
					const t = Ja(this), e = Za(this);
					t.activeTexture(t.TEXTURE1), n = wa(e, t), t.bindTexture(t.TEXTURE_2D, n), t.texImage2D(t.TEXTURE_2D, 0, t.RGBA, this.width, this.height, 0, t.RGBA, t.UNSIGNED_BYTE, null), t.bindTexture(t.TEXTURE_2D, null), Ta(e, t, n), Ea(e, t, !1, (() => {
						Qa(this), t.clearColor(0, 0, 0, 0), t.clear(t.COLOR_BUFFER_BIT), t.drawArrays(t.TRIANGLE_FAN, 0, 4), tc(this);
					})), Aa(e), tc(this);
				} else {
					if (!(e instanceof ImageBitmap)) throw Error(\`Type is not supported: \${e}\`);
					$a(this), Qa(this), n = ec(this), tc(this);
				}
				t.push(n);
			}
			return new nc(t, this.la(), this.R(), this.canvas, this.l, this.width, this.height);
		}
		close() {
			this.j && Ya(this, 1).close(), this.m && Ja(this).deleteTexture(Ya(this, 2)), rc = -1;
		}
	};
	nc.prototype.close = nc.prototype.close, nc.prototype.clone = nc.prototype.clone, nc.prototype.getAsWebGLTexture = nc.prototype.N, nc.prototype.getAsImageBitmap = nc.prototype.Ba, nc.prototype.getAsImageData = nc.prototype.Ca, nc.prototype.hasWebGLTexture = nc.prototype.R, nc.prototype.hasImageBitmap = nc.prototype.la, nc.prototype.hasImageData = nc.prototype.Ea;
	var rc = 250;
	function ic(...t) {
		return t.map((([t, e]) => ({
			start: t,
			end: e
		})));
	}
	const sc = function(t) {
		return class extends t {
			Ja() {
				this.i._registerModelResourcesGraphService();
			}
		};
	}((oc = class {
		constructor(t, e) {
			this.l = !0, this.i = t, this.g = null, this.h = 0, this.m = "function" == typeof this.i._addIntToInputStream, void 0 !== e ? this.i.canvas = e : Qo() ? this.i.canvas = new OffscreenCanvas(1, 1) : (console.warn("OffscreenCanvas not supported and GraphRunner constructor glCanvas parameter is undefined. Creating backup canvas."), this.i.canvas = document.createElement("canvas"));
		}
		async initializeGraph(t) {
			const e = await (await fetch(t)).arrayBuffer();
			t = !(t.endsWith(".pbtxt") || t.endsWith(".textproto")), this.setGraph(new Uint8Array(e), t);
		}
		setGraphFromString(t) {
			this.setGraph(new TextEncoder().encode(t), !1);
		}
		setGraph(t, e) {
			const n = t.length, r = this.i._malloc(n);
			this.i.HEAPU8.set(t, r), e ? this.i._changeBinaryGraph(n, r) : this.i._changeTextGraph(n, r), this.i._free(r);
		}
		configureAudio(t, e, n, r, i) {
			this.i._configureAudio || console.warn("Attempting to use configureAudio without support for input audio. Is build dep \\":gl_graph_runner_audio\\" missing?"), na(this, r || "input_audio", ((r) => {
				na(this, i = i || "audio_header", ((i) => {
					this.i._configureAudio(r, i, t, e ?? 0, n);
				}));
			}));
		}
		setAutoResizeCanvas(t) {
			this.l = t;
		}
		setAutoRenderToScreen(t) {
			this.i._setAutoRenderToScreen(t);
		}
		setGpuBufferVerticalFlip(t) {
			this.i.gpuOriginForWebTexturesIsBottomLeft = t;
		}
		ca(t) {
			sa(this, "__graph_config__", ((e) => {
				t(e);
			})), na(this, "__graph_config__", ((t) => {
				this.i._getGraphConfig(t, void 0);
			})), delete this.i.simpleListeners.__graph_config__;
		}
		attachErrorListener(t) {
			this.i.errorListener = t;
		}
		attachEmptyPacketListener(t, e) {
			this.i.emptyPacketListeners = this.i.emptyPacketListeners || {}, this.i.emptyPacketListeners[t] = e;
		}
		addAudioToStream(t, e, n) {
			this.addAudioToStreamWithShape(t, 0, 0, e, n);
		}
		addAudioToStreamWithShape(t, e, n, r, i) {
			const s = 4 * t.length;
			this.h !== s && (this.g && this.i._free(this.g), this.g = this.i._malloc(s), this.h = s), this.i.HEAPF32.set(t, this.g / 4), na(this, r, ((t) => {
				this.i._addAudioToInputStream(this.g, e, n, t, i);
			}));
		}
		addGpuBufferToStream(t, e, n) {
			na(this, e, ((e) => {
				const [r, i] = ra(this, t, e);
				this.i._addBoundTextureToStream(e, r, i, n);
			}));
		}
		addBoolToStream(t, e, n) {
			na(this, e, ((e) => {
				this.i._addBoolToInputStream(t, e, n);
			}));
		}
		addDoubleToStream(t, e, n) {
			na(this, e, ((e) => {
				this.i._addDoubleToInputStream(t, e, n);
			}));
		}
		addFloatToStream(t, e, n) {
			na(this, e, ((e) => {
				this.i._addFloatToInputStream(t, e, n);
			}));
		}
		addIntToStream(t, e, n) {
			na(this, e, ((e) => {
				this.i._addIntToInputStream(t, e, n);
			}));
		}
		addUintToStream(t, e, n) {
			na(this, e, ((e) => {
				this.i._addUintToInputStream(t, e, n);
			}));
		}
		addStringToStream(t, e, n) {
			na(this, e, ((e) => {
				na(this, t, ((t) => {
					this.i._addStringToInputStream(t, e, n);
				}));
			}));
		}
		addStringRecordToStream(t, e, n) {
			na(this, e, ((e) => {
				ia(this, Object.keys(t), ((r) => {
					ia(this, Object.values(t), ((i) => {
						this.i._addFlatHashMapToInputStream(r, i, Object.keys(t).length, e, n);
					}));
				}));
			}));
		}
		addProtoToStream(t, e, n, r) {
			na(this, n, ((n) => {
				na(this, e, ((e) => {
					const i = this.i._malloc(t.length);
					this.i.HEAPU8.set(t, i), this.i._addProtoToInputStream(i, t.length, e, n, r), this.i._free(i);
				}));
			}));
		}
		addEmptyPacketToStream(t, e) {
			na(this, t, ((t) => {
				this.i._addEmptyPacketToInputStream(t, e);
			}));
		}
		addBoolVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateBoolVector(t.length);
				if (!r) throw Error("Unable to allocate new bool vector on heap.");
				for (const e of t) this.i._addBoolVectorEntry(r, e);
				this.i._addBoolVectorToInputStream(r, e, n);
			}));
		}
		addDoubleVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateDoubleVector(t.length);
				if (!r) throw Error("Unable to allocate new double vector on heap.");
				for (const e of t) this.i._addDoubleVectorEntry(r, e);
				this.i._addDoubleVectorToInputStream(r, e, n);
			}));
		}
		addFloatVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateFloatVector(t.length);
				if (!r) throw Error("Unable to allocate new float vector on heap.");
				for (const e of t) this.i._addFloatVectorEntry(r, e);
				this.i._addFloatVectorToInputStream(r, e, n);
			}));
		}
		addIntVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateIntVector(t.length);
				if (!r) throw Error("Unable to allocate new int vector on heap.");
				for (const e of t) this.i._addIntVectorEntry(r, e);
				this.i._addIntVectorToInputStream(r, e, n);
			}));
		}
		addUintVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateUintVector(t.length);
				if (!r) throw Error("Unable to allocate new unsigned int vector on heap.");
				for (const e of t) this.i._addUintVectorEntry(r, e);
				this.i._addUintVectorToInputStream(r, e, n);
			}));
		}
		addStringVectorToStream(t, e, n) {
			na(this, e, ((e) => {
				const r = this.i._allocateStringVector(t.length);
				if (!r) throw Error("Unable to allocate new string vector on heap.");
				for (const e of t) na(this, e, ((t) => {
					this.i._addStringVectorEntry(r, t);
				}));
				this.i._addStringVectorToInputStream(r, e, n);
			}));
		}
		addBoolToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				this.i._addBoolToInputSidePacket(t, e);
			}));
		}
		addDoubleToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				this.i._addDoubleToInputSidePacket(t, e);
			}));
		}
		addFloatToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				this.i._addFloatToInputSidePacket(t, e);
			}));
		}
		addIntToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				this.i._addIntToInputSidePacket(t, e);
			}));
		}
		addUintToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				this.i._addUintToInputSidePacket(t, e);
			}));
		}
		addStringToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				na(this, t, ((t) => {
					this.i._addStringToInputSidePacket(t, e);
				}));
			}));
		}
		addProtoToInputSidePacket(t, e, n) {
			na(this, n, ((n) => {
				na(this, e, ((e) => {
					const r = this.i._malloc(t.length);
					this.i.HEAPU8.set(t, r), this.i._addProtoToInputSidePacket(r, t.length, e, n), this.i._free(r);
				}));
			}));
		}
		addBoolVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateBoolVector(t.length);
				if (!n) throw Error("Unable to allocate new bool vector on heap.");
				for (const e of t) this.i._addBoolVectorEntry(n, e);
				this.i._addBoolVectorToInputSidePacket(n, e);
			}));
		}
		addDoubleVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateDoubleVector(t.length);
				if (!n) throw Error("Unable to allocate new double vector on heap.");
				for (const e of t) this.i._addDoubleVectorEntry(n, e);
				this.i._addDoubleVectorToInputSidePacket(n, e);
			}));
		}
		addFloatVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateFloatVector(t.length);
				if (!n) throw Error("Unable to allocate new float vector on heap.");
				for (const e of t) this.i._addFloatVectorEntry(n, e);
				this.i._addFloatVectorToInputSidePacket(n, e);
			}));
		}
		addIntVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateIntVector(t.length);
				if (!n) throw Error("Unable to allocate new int vector on heap.");
				for (const e of t) this.i._addIntVectorEntry(n, e);
				this.i._addIntVectorToInputSidePacket(n, e);
			}));
		}
		addUintVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateUintVector(t.length);
				if (!n) throw Error("Unable to allocate new unsigned int vector on heap.");
				for (const e of t) this.i._addUintVectorEntry(n, e);
				this.i._addUintVectorToInputSidePacket(n, e);
			}));
		}
		addStringVectorToInputSidePacket(t, e) {
			na(this, e, ((e) => {
				const n = this.i._allocateStringVector(t.length);
				if (!n) throw Error("Unable to allocate new string vector on heap.");
				for (const e of t) na(this, e, ((t) => {
					this.i._addStringVectorEntry(n, t);
				}));
				this.i._addStringVectorToInputSidePacket(n, e);
			}));
		}
		attachBoolListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachBoolListener(t);
			}));
		}
		attachBoolVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachBoolVectorListener(t);
			}));
		}
		attachIntListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachIntListener(t);
			}));
		}
		attachIntVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachIntVectorListener(t);
			}));
		}
		attachUintListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachUintListener(t);
			}));
		}
		attachUintVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachUintVectorListener(t);
			}));
		}
		attachDoubleListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachDoubleListener(t);
			}));
		}
		attachDoubleVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachDoubleVectorListener(t);
			}));
		}
		attachFloatListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachFloatListener(t);
			}));
		}
		attachFloatVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachFloatVectorListener(t);
			}));
		}
		attachStringListener(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachStringListener(t);
			}));
		}
		attachStringVectorListener(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachStringVectorListener(t);
			}));
		}
		attachProtoListener(t, e, n) {
			sa(this, t, e), na(this, t, ((t) => {
				this.i._attachProtoListener(t, n || !1);
			}));
		}
		attachProtoVectorListener(t, e, n) {
			oa(this, t, e), na(this, t, ((t) => {
				this.i._attachProtoVectorListener(t, n || !1);
			}));
		}
		attachAudioListener(t, e, n) {
			this.i._attachAudioListener || console.warn("Attempting to use attachAudioListener without support for output audio. Is build dep \\":gl_graph_runner_audio_out\\" missing?"), sa(this, t, ((t, n) => {
				t = new Float32Array(t.buffer, t.byteOffset, t.length / 4), e(t, n);
			})), na(this, t, ((t) => {
				this.i._attachAudioListener(t, n || !1);
			}));
		}
		finishProcessing() {
			this.i._waitUntilIdle();
		}
		closeGraph() {
			this.i._closeGraph(), this.i.simpleListeners = void 0, this.i.emptyPacketListeners = void 0;
		}
	}, class extends oc {
		get ga() {
			return this.i;
		}
		pa(t, e, n) {
			na(this, e, ((e) => {
				const [r, i] = ra(this, t, e);
				this.ga._addBoundTextureAsImageToStream(e, r, i, n);
			}));
		}
		Z(t, e) {
			sa(this, t, e), na(this, t, ((t) => {
				this.ga._attachImageListener(t);
			}));
		}
		aa(t, e) {
			oa(this, t, e), na(this, t, ((t) => {
				this.ga._attachImageVectorListener(t);
			}));
		}
	}));
	var oc;
	var ac = class extends sc {};
	async function cc(t, e, n) {
		return async function(t, e, n, r) {
			return aa(t, e, n, r);
		}(t, n.canvas ?? (Qo() ? void 0 : document.createElement("canvas")), e, n);
	}
	function hc(t, e, n, r) {
		if (t.U) {
			const s = new Ls();
			if (n?.regionOfInterest) {
				if (!t.oa) throw Error("This task doesn't support region-of-interest.");
				var i = n.regionOfInterest;
				if (i.left >= i.right || i.top >= i.bottom) throw Error("Expected RectF with left < right and top < bottom.");
				if (i.left < 0 || i.top < 0 || i.right > 1 || i.bottom > 1) throw Error("Expected RectF values to be in [0,1].");
				Ln(s, 1, (i.left + i.right) / 2), Ln(s, 2, (i.top + i.bottom) / 2), Ln(s, 4, i.right - i.left), Ln(s, 3, i.bottom - i.top);
			} else Ln(s, 1, .5), Ln(s, 2, .5), Ln(s, 4, 1), Ln(s, 3, 1);
			if (n?.rotationDegrees) {
				if (n?.rotationDegrees % 90 != 0) throw Error("Expected rotation to be a multiple of 90\xB0.");
				if (Ln(s, 5, -Math.PI * n.rotationDegrees / 180), n?.rotationDegrees % 180 != 0) {
					const [t, r] = ea(e);
					n = Sn(s, 3) * r / t, i = Sn(s, 4) * t / r, Ln(s, 4, n), Ln(s, 3, i);
				}
			}
			t.g.addProtoToStream(s.g(), "mediapipe.NormalizedRect", t.U, r);
		}
		t.g.pa(e, t.X, r ?? performance.now()), t.finishProcessing();
	}
	function uc(t, e, n) {
		if (t.baseOptions?.g()) throw Error("Task is not initialized with image mode. 'runningMode' must be set to 'IMAGE'.");
		hc(t, e, n, t.C + 1);
	}
	function lc(t, e, n, r) {
		if (!t.baseOptions?.g()) throw Error("Task is not initialized with video mode. 'runningMode' must be set to 'VIDEO'.");
		hc(t, e, n, r);
	}
	function fc(t, e, n, r) {
		var i = e.data;
		const s = e.width, o = s * (e = e.height);
		if ((i instanceof Uint8Array || i instanceof Float32Array) && i.length !== o) throw Error("Unsupported channel count: " + i.length / o);
		return t = new Na([i], n, !1, t.g.i.canvas, t.P, s, e), r ? t.clone() : t;
	}
	var dc = class extends pa {
		constructor(t, e, n, r) {
			super(t), this.g = t, this.X = e, this.U = n, this.oa = r, this.P = new ba();
		}
		l(t, e = !0) {
			if ("runningMode" in t && Ze(this.baseOptions, 2, Jt(!!t.runningMode && "IMAGE" !== t.runningMode)), void 0 !== t.canvas && this.g.i.canvas !== t.canvas) throw Error("You must create a new task to reset the canvas.");
			return super.l(t, e);
		}
		close() {
			this.P.close(), super.close();
		}
	};
	dc.prototype.close = dc.prototype.close;
	var pc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect_in", !1), this.j = { detections: [] }, wn(t = this.h = new zs(), 0, 1, e = new Xs()), Ln(this.h, 2, .5), Ln(this.h, 3, .3);
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return "minDetectionConfidence" in t && Ln(this.h, 2, t.minDetectionConfidence ?? .5), "minSuppressionThreshold" in t && Ln(this.h, 3, t.minSuppressionThreshold ?? .3), this.l(t);
		}
		F(t, e) {
			return this.j = { detections: [] }, uc(this, t, e), this.j;
		}
		G(t, e, n) {
			return this.j = { detections: [] }, lc(this, t, n, e), this.j;
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect_in"), us(t, "detections");
			const e = new Qi();
			xr(e, Ys, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.face_detector.FaceDetectorGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect_in"), rs(n, "DETECTIONS:detections"), n.o(e), cs(t, n), this.g.attachProtoVectorListener("detections", ((t, e) => {
				for (const e of t) t = ws(e), this.j.detections.push(Xo(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("detections", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	pc.prototype.detectForVideo = pc.prototype.G, pc.prototype.detect = pc.prototype.F, pc.prototype.setOptions = pc.prototype.o, pc.createFromModelPath = async function(t, e) {
		return cc(pc, t, { baseOptions: { modelAssetPath: e } });
	}, pc.createFromModelBuffer = function(t, e) {
		return cc(pc, t, { baseOptions: { modelAssetBuffer: e } });
	}, pc.createFromOptions = function(t, e) {
		return cc(pc, t, e);
	};
	var gc = ic([61, 146], [146, 91], [91, 181], [181, 84], [84, 17], [17, 314], [314, 405], [405, 321], [321, 375], [375, 291], [61, 185], [185, 40], [40, 39], [39, 37], [37, 0], [0, 267], [267, 269], [269, 270], [270, 409], [409, 291], [78, 95], [95, 88], [88, 178], [178, 87], [87, 14], [14, 317], [317, 402], [402, 318], [318, 324], [324, 308], [78, 191], [191, 80], [80, 81], [81, 82], [82, 13], [13, 312], [312, 311], [311, 310], [310, 415], [415, 308]);
	var mc = ic([263, 249], [249, 390], [390, 373], [373, 374], [374, 380], [380, 381], [381, 382], [382, 362], [263, 466], [466, 388], [388, 387], [387, 386], [386, 385], [385, 384], [384, 398], [398, 362]);
	var yc = ic([276, 283], [283, 282], [282, 295], [295, 285], [300, 293], [293, 334], [334, 296], [296, 336]);
	var _c = ic([474, 475], [475, 476], [476, 477], [477, 474]);
	var vc = ic([33, 7], [7, 163], [163, 144], [144, 145], [145, 153], [153, 154], [154, 155], [155, 133], [33, 246], [246, 161], [161, 160], [160, 159], [159, 158], [158, 157], [157, 173], [173, 133]);
	var Ec = ic([46, 53], [53, 52], [52, 65], [65, 55], [70, 63], [63, 105], [105, 66], [66, 107]);
	var wc = ic([469, 470], [470, 471], [471, 472], [472, 469]);
	var Tc = ic([10, 338], [338, 297], [297, 332], [332, 284], [284, 251], [251, 389], [389, 356], [356, 454], [454, 323], [323, 361], [361, 288], [288, 397], [397, 365], [365, 379], [379, 378], [378, 400], [400, 377], [377, 152], [152, 148], [148, 176], [176, 149], [149, 150], [150, 136], [136, 172], [172, 58], [58, 132], [132, 93], [93, 234], [234, 127], [127, 162], [162, 21], [21, 54], [54, 103], [103, 67], [67, 109], [109, 10]);
	var Ac = [
		...gc,
		...mc,
		...yc,
		...vc,
		...Ec,
		...Tc
	];
	var bc = ic([127, 34], [34, 139], [139, 127], [11, 0], [0, 37], [37, 11], [232, 231], [231, 120], [120, 232], [72, 37], [37, 39], [39, 72], [128, 121], [121, 47], [47, 128], [232, 121], [121, 128], [128, 232], [104, 69], [69, 67], [67, 104], [175, 171], [171, 148], [148, 175], [118, 50], [50, 101], [101, 118], [73, 39], [39, 40], [40, 73], [9, 151], [151, 108], [108, 9], [48, 115], [115, 131], [131, 48], [194, 204], [204, 211], [211, 194], [74, 40], [40, 185], [185, 74], [80, 42], [42, 183], [183, 80], [40, 92], [92, 186], [186, 40], [230, 229], [229, 118], [118, 230], [202, 212], [212, 214], [214, 202], [83, 18], [18, 17], [17, 83], [76, 61], [61, 146], [146, 76], [160, 29], [29, 30], [30, 160], [56, 157], [157, 173], [173, 56], [106, 204], [204, 194], [194, 106], [135, 214], [214, 192], [192, 135], [203, 165], [165, 98], [98, 203], [21, 71], [71, 68], [68, 21], [51, 45], [45, 4], [4, 51], [144, 24], [24, 23], [23, 144], [77, 146], [146, 91], [91, 77], [205, 50], [50, 187], [187, 205], [201, 200], [200, 18], [18, 201], [91, 106], [106, 182], [182, 91], [90, 91], [91, 181], [181, 90], [85, 84], [84, 17], [17, 85], [206, 203], [203, 36], [36, 206], [148, 171], [171, 140], [140, 148], [92, 40], [40, 39], [39, 92], [193, 189], [189, 244], [244, 193], [159, 158], [158, 28], [28, 159], [247, 246], [246, 161], [161, 247], [236, 3], [3, 196], [196, 236], [54, 68], [68, 104], [104, 54], [193, 168], [168, 8], [8, 193], [117, 228], [228, 31], [31, 117], [189, 193], [193, 55], [55, 189], [98, 97], [97, 99], [99, 98], [126, 47], [47, 100], [100, 126], [166, 79], [79, 218], [218, 166], [155, 154], [154, 26], [26, 155], [209, 49], [49, 131], [131, 209], [135, 136], [136, 150], [150, 135], [47, 126], [126, 217], [217, 47], [223, 52], [52, 53], [53, 223], [45, 51], [51, 134], [134, 45], [211, 170], [170, 140], [140, 211], [67, 69], [69, 108], [108, 67], [43, 106], [106, 91], [91, 43], [230, 119], [119, 120], [120, 230], [226, 130], [130, 247], [247, 226], [63, 53], [53, 52], [52, 63], [238, 20], [20, 242], [242, 238], [46, 70], [70, 156], [156, 46], [78, 62], [62, 96], [96, 78], [46, 53], [53, 63], [63, 46], [143, 34], [34, 227], [227, 143], [123, 117], [117, 111], [111, 123], [44, 125], [125, 19], [19, 44], [236, 134], [134, 51], [51, 236], [216, 206], [206, 205], [205, 216], [154, 153], [153, 22], [22, 154], [39, 37], [37, 167], [167, 39], [200, 201], [201, 208], [208, 200], [36, 142], [142, 100], [100, 36], [57, 212], [212, 202], [202, 57], [20, 60], [60, 99], [99, 20], [28, 158], [158, 157], [157, 28], [35, 226], [226, 113], [113, 35], [160, 159], [159, 27], [27, 160], [204, 202], [202, 210], [210, 204], [113, 225], [225, 46], [46, 113], [43, 202], [202, 204], [204, 43], [62, 76], [76, 77], [77, 62], [137, 123], [123, 116], [116, 137], [41, 38], [38, 72], [72, 41], [203, 129], [129, 142], [142, 203], [64, 98], [98, 240], [240, 64], [49, 102], [102, 64], [64, 49], [41, 73], [73, 74], [74, 41], [212, 216], [216, 207], [207, 212], [42, 74], [74, 184], [184, 42], [169, 170], [170, 211], [211, 169], [170, 149], [149, 176], [176, 170], [105, 66], [66, 69], [69, 105], [122, 6], [6, 168], [168, 122], [123, 147], [147, 187], [187, 123], [96, 77], [77, 90], [90, 96], [65, 55], [55, 107], [107, 65], [89, 90], [90, 180], [180, 89], [101, 100], [100, 120], [120, 101], [63, 105], [105, 104], [104, 63], [93, 137], [137, 227], [227, 93], [15, 86], [86, 85], [85, 15], [129, 102], [102, 49], [49, 129], [14, 87], [87, 86], [86, 14], [55, 8], [8, 9], [9, 55], [100, 47], [47, 121], [121, 100], [145, 23], [23, 22], [22, 145], [88, 89], [89, 179], [179, 88], [6, 122], [122, 196], [196, 6], [88, 95], [95, 96], [96, 88], [138, 172], [172, 136], [136, 138], [215, 58], [58, 172], [172, 215], [115, 48], [48, 219], [219, 115], [42, 80], [80, 81], [81, 42], [195, 3], [3, 51], [51, 195], [43, 146], [146, 61], [61, 43], [171, 175], [175, 199], [199, 171], [81, 82], [82, 38], [38, 81], [53, 46], [46, 225], [225, 53], [144, 163], [163, 110], [110, 144], [52, 65], [65, 66], [66, 52], [229, 228], [228, 117], [117, 229], [34, 127], [127, 234], [234, 34], [107, 108], [108, 69], [69, 107], [109, 108], [108, 151], [151, 109], [48, 64], [64, 235], [235, 48], [62, 78], [78, 191], [191, 62], [129, 209], [209, 126], [126, 129], [111, 35], [35, 143], [143, 111], [117, 123], [123, 50], [50, 117], [222, 65], [65, 52], [52, 222], [19, 125], [125, 141], [141, 19], [221, 55], [55, 65], [65, 221], [3, 195], [195, 197], [197, 3], [25, 7], [7, 33], [33, 25], [220, 237], [237, 44], [44, 220], [70, 71], [71, 139], [139, 70], [122, 193], [193, 245], [245, 122], [247, 130], [130, 33], [33, 247], [71, 21], [21, 162], [162, 71], [170, 169], [169, 150], [150, 170], [188, 174], [174, 196], [196, 188], [216, 186], [186, 92], [92, 216], [2, 97], [97, 167], [167, 2], [141, 125], [125, 241], [241, 141], [164, 167], [167, 37], [37, 164], [72, 38], [38, 12], [12, 72], [38, 82], [82, 13], [13, 38], [63, 68], [68, 71], [71, 63], [226, 35], [35, 111], [111, 226], [101, 50], [50, 205], [205, 101], [206, 92], [92, 165], [165, 206], [209, 198], [198, 217], [217, 209], [165, 167], [167, 97], [97, 165], [220, 115], [115, 218], [218, 220], [133, 112], [112, 243], [243, 133], [239, 238], [238, 241], [241, 239], [214, 135], [135, 169], [169, 214], [190, 173], [173, 133], [133, 190], [171, 208], [208, 32], [32, 171], [125, 44], [44, 237], [237, 125], [86, 87], [87, 178], [178, 86], [85, 86], [86, 179], [179, 85], [84, 85], [85, 180], [180, 84], [83, 84], [84, 181], [181, 83], [201, 83], [83, 182], [182, 201], [137, 93], [93, 132], [132, 137], [76, 62], [62, 183], [183, 76], [61, 76], [76, 184], [184, 61], [57, 61], [61, 185], [185, 57], [212, 57], [57, 186], [186, 212], [214, 207], [207, 187], [187, 214], [34, 143], [143, 156], [156, 34], [79, 239], [239, 237], [237, 79], [123, 137], [137, 177], [177, 123], [44, 1], [1, 4], [4, 44], [201, 194], [194, 32], [32, 201], [64, 102], [102, 129], [129, 64], [213, 215], [215, 138], [138, 213], [59, 166], [166, 219], [219, 59], [242, 99], [99, 97], [97, 242], [2, 94], [94, 141], [141, 2], [75, 59], [59, 235], [235, 75], [24, 110], [110, 228], [228, 24], [25, 130], [130, 226], [226, 25], [23, 24], [24, 229], [229, 23], [22, 23], [23, 230], [230, 22], [26, 22], [22, 231], [231, 26], [112, 26], [26, 232], [232, 112], [189, 190], [190, 243], [243, 189], [221, 56], [56, 190], [190, 221], [28, 56], [56, 221], [221, 28], [27, 28], [28, 222], [222, 27], [29, 27], [27, 223], [223, 29], [30, 29], [29, 224], [224, 30], [247, 30], [30, 225], [225, 247], [238, 79], [79, 20], [20, 238], [166, 59], [59, 75], [75, 166], [60, 75], [75, 240], [240, 60], [147, 177], [177, 215], [215, 147], [20, 79], [79, 166], [166, 20], [187, 147], [147, 213], [213, 187], [112, 233], [233, 244], [244, 112], [233, 128], [128, 245], [245, 233], [128, 114], [114, 188], [188, 128], [114, 217], [217, 174], [174, 114], [131, 115], [115, 220], [220, 131], [217, 198], [198, 236], [236, 217], [198, 131], [131, 134], [134, 198], [177, 132], [132, 58], [58, 177], [143, 35], [35, 124], [124, 143], [110, 163], [163, 7], [7, 110], [228, 110], [110, 25], [25, 228], [356, 389], [389, 368], [368, 356], [11, 302], [302, 267], [267, 11], [452, 350], [350, 349], [349, 452], [302, 303], [303, 269], [269, 302], [357, 343], [343, 277], [277, 357], [452, 453], [453, 357], [357, 452], [333, 332], [332, 297], [297, 333], [175, 152], [152, 377], [377, 175], [347, 348], [348, 330], [330, 347], [303, 304], [304, 270], [270, 303], [9, 336], [336, 337], [337, 9], [278, 279], [279, 360], [360, 278], [418, 262], [262, 431], [431, 418], [304, 408], [408, 409], [409, 304], [310, 415], [415, 407], [407, 310], [270, 409], [409, 410], [410, 270], [450, 348], [348, 347], [347, 450], [422, 430], [430, 434], [434, 422], [313, 314], [314, 17], [17, 313], [306, 307], [307, 375], [375, 306], [387, 388], [388, 260], [260, 387], [286, 414], [414, 398], [398, 286], [335, 406], [406, 418], [418, 335], [364, 367], [367, 416], [416, 364], [423, 358], [358, 327], [327, 423], [251, 284], [284, 298], [298, 251], [281, 5], [5, 4], [4, 281], [373, 374], [374, 253], [253, 373], [307, 320], [320, 321], [321, 307], [425, 427], [427, 411], [411, 425], [421, 313], [313, 18], [18, 421], [321, 405], [405, 406], [406, 321], [320, 404], [404, 405], [405, 320], [315, 16], [16, 17], [17, 315], [426, 425], [425, 266], [266, 426], [377, 400], [400, 369], [369, 377], [322, 391], [391, 269], [269, 322], [417, 465], [465, 464], [464, 417], [386, 257], [257, 258], [258, 386], [466, 260], [260, 388], [388, 466], [456, 399], [399, 419], [419, 456], [284, 332], [332, 333], [333, 284], [417, 285], [285, 8], [8, 417], [346, 340], [340, 261], [261, 346], [413, 441], [441, 285], [285, 413], [327, 460], [460, 328], [328, 327], [355, 371], [371, 329], [329, 355], [392, 439], [439, 438], [438, 392], [382, 341], [341, 256], [256, 382], [429, 420], [420, 360], [360, 429], [364, 394], [394, 379], [379, 364], [277, 343], [343, 437], [437, 277], [443, 444], [444, 283], [283, 443], [275, 440], [440, 363], [363, 275], [431, 262], [262, 369], [369, 431], [297, 338], [338, 337], [337, 297], [273, 375], [375, 321], [321, 273], [450, 451], [451, 349], [349, 450], [446, 342], [342, 467], [467, 446], [293, 334], [334, 282], [282, 293], [458, 461], [461, 462], [462, 458], [276, 353], [353, 383], [383, 276], [308, 324], [324, 325], [325, 308], [276, 300], [300, 293], [293, 276], [372, 345], [345, 447], [447, 372], [352, 345], [345, 340], [340, 352], [274, 1], [1, 19], [19, 274], [456, 248], [248, 281], [281, 456], [436, 427], [427, 425], [425, 436], [381, 256], [256, 252], [252, 381], [269, 391], [391, 393], [393, 269], [200, 199], [199, 428], [428, 200], [266, 330], [330, 329], [329, 266], [287, 273], [273, 422], [422, 287], [250, 462], [462, 328], [328, 250], [258, 286], [286, 384], [384, 258], [265, 353], [353, 342], [342, 265], [387, 259], [259, 257], [257, 387], [424, 431], [431, 430], [430, 424], [342, 353], [353, 276], [276, 342], [273, 335], [335, 424], [424, 273], [292, 325], [325, 307], [307, 292], [366, 447], [447, 345], [345, 366], [271, 303], [303, 302], [302, 271], [423, 266], [266, 371], [371, 423], [294, 455], [455, 460], [460, 294], [279, 278], [278, 294], [294, 279], [271, 272], [272, 304], [304, 271], [432, 434], [434, 427], [427, 432], [272, 407], [407, 408], [408, 272], [394, 430], [430, 431], [431, 394], [395, 369], [369, 400], [400, 395], [334, 333], [333, 299], [299, 334], [351, 417], [417, 168], [168, 351], [352, 280], [280, 411], [411, 352], [325, 319], [319, 320], [320, 325], [295, 296], [296, 336], [336, 295], [319, 403], [403, 404], [404, 319], [330, 348], [348, 349], [349, 330], [293, 298], [298, 333], [333, 293], [323, 454], [454, 447], [447, 323], [15, 16], [16, 315], [315, 15], [358, 429], [429, 279], [279, 358], [14, 15], [15, 316], [316, 14], [285, 336], [336, 9], [9, 285], [329, 349], [349, 350], [350, 329], [374, 380], [380, 252], [252, 374], [318, 402], [402, 403], [403, 318], [6, 197], [197, 419], [419, 6], [318, 319], [319, 325], [325, 318], [367, 364], [364, 365], [365, 367], [435, 367], [367, 397], [397, 435], [344, 438], [438, 439], [439, 344], [272, 271], [271, 311], [311, 272], [195, 5], [5, 281], [281, 195], [273, 287], [287, 291], [291, 273], [396, 428], [428, 199], [199, 396], [311, 271], [271, 268], [268, 311], [283, 444], [444, 445], [445, 283], [373, 254], [254, 339], [339, 373], [282, 334], [334, 296], [296, 282], [449, 347], [347, 346], [346, 449], [264, 447], [447, 454], [454, 264], [336, 296], [296, 299], [299, 336], [338, 10], [10, 151], [151, 338], [278, 439], [439, 455], [455, 278], [292, 407], [407, 415], [415, 292], [358, 371], [371, 355], [355, 358], [340, 345], [345, 372], [372, 340], [346, 347], [347, 280], [280, 346], [442, 443], [443, 282], [282, 442], [19, 94], [94, 370], [370, 19], [441, 442], [442, 295], [295, 441], [248, 419], [419, 197], [197, 248], [263, 255], [255, 359], [359, 263], [440, 275], [275, 274], [274, 440], [300, 383], [383, 368], [368, 300], [351, 412], [412, 465], [465, 351], [263, 467], [467, 466], [466, 263], [301, 368], [368, 389], [389, 301], [395, 378], [378, 379], [379, 395], [412, 351], [351, 419], [419, 412], [436, 426], [426, 322], [322, 436], [2, 164], [164, 393], [393, 2], [370, 462], [462, 461], [461, 370], [164, 0], [0, 267], [267, 164], [302, 11], [11, 12], [12, 302], [268, 12], [12, 13], [13, 268], [293, 300], [300, 301], [301, 293], [446, 261], [261, 340], [340, 446], [330, 266], [266, 425], [425, 330], [426, 423], [423, 391], [391, 426], [429, 355], [355, 437], [437, 429], [391, 327], [327, 326], [326, 391], [440, 457], [457, 438], [438, 440], [341, 382], [382, 362], [362, 341], [459, 457], [457, 461], [461, 459], [434, 430], [430, 394], [394, 434], [414, 463], [463, 362], [362, 414], [396, 369], [369, 262], [262, 396], [354, 461], [461, 457], [457, 354], [316, 403], [403, 402], [402, 316], [315, 404], [404, 403], [403, 315], [314, 405], [405, 404], [404, 314], [313, 406], [406, 405], [405, 313], [421, 418], [418, 406], [406, 421], [366, 401], [401, 361], [361, 366], [306, 408], [408, 407], [407, 306], [291, 409], [409, 408], [408, 291], [287, 410], [410, 409], [409, 287], [432, 436], [436, 410], [410, 432], [434, 416], [416, 411], [411, 434], [264, 368], [368, 383], [383, 264], [309, 438], [438, 457], [457, 309], [352, 376], [376, 401], [401, 352], [274, 275], [275, 4], [4, 274], [421, 428], [428, 262], [262, 421], [294, 327], [327, 358], [358, 294], [433, 416], [416, 367], [367, 433], [289, 455], [455, 439], [439, 289], [462, 370], [370, 326], [326, 462], [2, 326], [326, 370], [370, 2], [305, 460], [460, 455], [455, 305], [254, 449], [449, 448], [448, 254], [255, 261], [261, 446], [446, 255], [253, 450], [450, 449], [449, 253], [252, 451], [451, 450], [450, 252], [256, 452], [452, 451], [451, 256], [341, 453], [453, 452], [452, 341], [413, 464], [464, 463], [463, 413], [441, 413], [413, 414], [414, 441], [258, 442], [442, 441], [441, 258], [257, 443], [443, 442], [442, 257], [259, 444], [444, 443], [443, 259], [260, 445], [445, 444], [444, 260], [467, 342], [342, 445], [445, 467], [459, 458], [458, 250], [250, 459], [289, 392], [392, 290], [290, 289], [290, 328], [328, 460], [460, 290], [376, 433], [433, 435], [435, 376], [250, 290], [290, 392], [392, 250], [411, 416], [416, 433], [433, 411], [341, 463], [463, 464], [464, 341], [453, 464], [464, 465], [465, 453], [357, 465], [465, 412], [412, 357], [343, 412], [412, 399], [399, 343], [360, 363], [363, 440], [440, 360], [437, 399], [399, 456], [456, 437], [420, 456], [456, 363], [363, 420], [401, 435], [435, 288], [288, 401], [372, 383], [383, 353], [353, 372], [339, 255], [255, 249], [249, 339], [448, 261], [261, 255], [255, 448], [133, 243], [243, 190], [190, 133], [133, 155], [155, 112], [112, 133], [33, 246], [246, 247], [247, 33], [33, 130], [130, 25], [25, 33], [398, 384], [384, 286], [286, 398], [362, 398], [398, 414], [414, 362], [362, 463], [463, 341], [341, 362], [263, 359], [359, 467], [467, 263], [263, 249], [249, 255], [255, 263], [466, 467], [467, 260], [260, 466], [75, 60], [60, 166], [166, 75], [238, 239], [239, 79], [79, 238], [162, 127], [127, 139], [139, 162], [72, 11], [11, 37], [37, 72], [121, 232], [232, 120], [120, 121], [73, 72], [72, 39], [39, 73], [114, 128], [128, 47], [47, 114], [233, 232], [232, 128], [128, 233], [103, 104], [104, 67], [67, 103], [152, 175], [175, 148], [148, 152], [119, 118], [118, 101], [101, 119], [74, 73], [73, 40], [40, 74], [107, 9], [9, 108], [108, 107], [49, 48], [48, 131], [131, 49], [32, 194], [194, 211], [211, 32], [184, 74], [74, 185], [185, 184], [191, 80], [80, 183], [183, 191], [185, 40], [40, 186], [186, 185], [119, 230], [230, 118], [118, 119], [210, 202], [202, 214], [214, 210], [84, 83], [83, 17], [17, 84], [77, 76], [76, 146], [146, 77], [161, 160], [160, 30], [30, 161], [190, 56], [56, 173], [173, 190], [182, 106], [106, 194], [194, 182], [138, 135], [135, 192], [192, 138], [129, 203], [203, 98], [98, 129], [54, 21], [21, 68], [68, 54], [5, 51], [51, 4], [4, 5], [145, 144], [144, 23], [23, 145], [90, 77], [77, 91], [91, 90], [207, 205], [205, 187], [187, 207], [83, 201], [201, 18], [18, 83], [181, 91], [91, 182], [182, 181], [180, 90], [90, 181], [181, 180], [16, 85], [85, 17], [17, 16], [205, 206], [206, 36], [36, 205], [176, 148], [148, 140], [140, 176], [165, 92], [92, 39], [39, 165], [245, 193], [193, 244], [244, 245], [27, 159], [159, 28], [28, 27], [30, 247], [247, 161], [161, 30], [174, 236], [236, 196], [196, 174], [103, 54], [54, 104], [104, 103], [55, 193], [193, 8], [8, 55], [111, 117], [117, 31], [31, 111], [221, 189], [189, 55], [55, 221], [240, 98], [98, 99], [99, 240], [142, 126], [126, 100], [100, 142], [219, 166], [166, 218], [218, 219], [112, 155], [155, 26], [26, 112], [198, 209], [209, 131], [131, 198], [169, 135], [135, 150], [150, 169], [114, 47], [47, 217], [217, 114], [224, 223], [223, 53], [53, 224], [220, 45], [45, 134], [134, 220], [32, 211], [211, 140], [140, 32], [109, 67], [67, 108], [108, 109], [146, 43], [43, 91], [91, 146], [231, 230], [230, 120], [120, 231], [113, 226], [226, 247], [247, 113], [105, 63], [63, 52], [52, 105], [241, 238], [238, 242], [242, 241], [124, 46], [46, 156], [156, 124], [95, 78], [78, 96], [96, 95], [70, 46], [46, 63], [63, 70], [116, 143], [143, 227], [227, 116], [116, 123], [123, 111], [111, 116], [1, 44], [44, 19], [19, 1], [3, 236], [236, 51], [51, 3], [207, 216], [216, 205], [205, 207], [26, 154], [154, 22], [22, 26], [165, 39], [39, 167], [167, 165], [199, 200], [200, 208], [208, 199], [101, 36], [36, 100], [100, 101], [43, 57], [57, 202], [202, 43], [242, 20], [20, 99], [99, 242], [56, 28], [28, 157], [157, 56], [124, 35], [35, 113], [113, 124], [29, 160], [160, 27], [27, 29], [211, 204], [204, 210], [210, 211], [124, 113], [113, 46], [46, 124], [106, 43], [43, 204], [204, 106], [96, 62], [62, 77], [77, 96], [227, 137], [137, 116], [116, 227], [73, 41], [41, 72], [72, 73], [36, 203], [203, 142], [142, 36], [235, 64], [64, 240], [240, 235], [48, 49], [49, 64], [64, 48], [42, 41], [41, 74], [74, 42], [214, 212], [212, 207], [207, 214], [183, 42], [42, 184], [184, 183], [210, 169], [169, 211], [211, 210], [140, 170], [170, 176], [176, 140], [104, 105], [105, 69], [69, 104], [193, 122], [122, 168], [168, 193], [50, 123], [123, 187], [187, 50], [89, 96], [96, 90], [90, 89], [66, 65], [65, 107], [107, 66], [179, 89], [89, 180], [180, 179], [119, 101], [101, 120], [120, 119], [68, 63], [63, 104], [104, 68], [234, 93], [93, 227], [227, 234], [16, 15], [15, 85], [85, 16], [209, 129], [129, 49], [49, 209], [15, 14], [14, 86], [86, 15], [107, 55], [55, 9], [9, 107], [120, 100], [100, 121], [121, 120], [153, 145], [145, 22], [22, 153], [178, 88], [88, 179], [179, 178], [197, 6], [6, 196], [196, 197], [89, 88], [88, 96], [96, 89], [135, 138], [138, 136], [136, 135], [138, 215], [215, 172], [172, 138], [218, 115], [115, 219], [219, 218], [41, 42], [42, 81], [81, 41], [5, 195], [195, 51], [51, 5], [57, 43], [43, 61], [61, 57], [208, 171], [171, 199], [199, 208], [41, 81], [81, 38], [38, 41], [224, 53], [53, 225], [225, 224], [24, 144], [144, 110], [110, 24], [105, 52], [52, 66], [66, 105], [118, 229], [229, 117], [117, 118], [227, 34], [34, 234], [234, 227], [66, 107], [107, 69], [69, 66], [10, 109], [109, 151], [151, 10], [219, 48], [48, 235], [235, 219], [183, 62], [62, 191], [191, 183], [142, 129], [129, 126], [126, 142], [116, 111], [111, 143], [143, 116], [118, 117], [117, 50], [50, 118], [223, 222], [222, 52], [52, 223], [94, 19], [19, 141], [141, 94], [222, 221], [221, 65], [65, 222], [196, 3], [3, 197], [197, 196], [45, 220], [220, 44], [44, 45], [156, 70], [70, 139], [139, 156], [188, 122], [122, 245], [245, 188], [139, 71], [71, 162], [162, 139], [149, 170], [170, 150], [150, 149], [122, 188], [188, 196], [196, 122], [206, 216], [216, 92], [92, 206], [164, 2], [2, 167], [167, 164], [242, 141], [141, 241], [241, 242], [0, 164], [164, 37], [37, 0], [11, 72], [72, 12], [12, 11], [12, 38], [38, 13], [13, 12], [70, 63], [63, 71], [71, 70], [31, 226], [226, 111], [111, 31], [36, 101], [101, 205], [205, 36], [203, 206], [206, 165], [165, 203], [126, 209], [209, 217], [217, 126], [98, 165], [165, 97], [97, 98], [237, 220], [220, 218], [218, 237], [237, 239], [239, 241], [241, 237], [210, 214], [214, 169], [169, 210], [140, 171], [171, 32], [32, 140], [241, 125], [125, 237], [237, 241], [179, 86], [86, 178], [178, 179], [180, 85], [85, 179], [179, 180], [181, 84], [84, 180], [180, 181], [182, 83], [83, 181], [181, 182], [194, 201], [201, 182], [182, 194], [177, 137], [137, 132], [132, 177], [184, 76], [76, 183], [183, 184], [185, 61], [61, 184], [184, 185], [186, 57], [57, 185], [185, 186], [216, 212], [212, 186], [186, 216], [192, 214], [214, 187], [187, 192], [139, 34], [34, 156], [156, 139], [218, 79], [79, 237], [237, 218], [147, 123], [123, 177], [177, 147], [45, 44], [44, 4], [4, 45], [208, 201], [201, 32], [32, 208], [98, 64], [64, 129], [129, 98], [192, 213], [213, 138], [138, 192], [235, 59], [59, 219], [219, 235], [141, 242], [242, 97], [97, 141], [97, 2], [2, 141], [141, 97], [240, 75], [75, 235], [235, 240], [229, 24], [24, 228], [228, 229], [31, 25], [25, 226], [226, 31], [230, 23], [23, 229], [229, 230], [231, 22], [22, 230], [230, 231], [232, 26], [26, 231], [231, 232], [233, 112], [112, 232], [232, 233], [244, 189], [189, 243], [243, 244], [189, 221], [221, 190], [190, 189], [222, 28], [28, 221], [221, 222], [223, 27], [27, 222], [222, 223], [224, 29], [29, 223], [223, 224], [225, 30], [30, 224], [224, 225], [113, 247], [247, 225], [225, 113], [99, 60], [60, 240], [240, 99], [213, 147], [147, 215], [215, 213], [60, 20], [20, 166], [166, 60], [192, 187], [187, 213], [213, 192], [243, 112], [112, 244], [244, 243], [244, 233], [233, 245], [245, 244], [245, 128], [128, 188], [188, 245], [188, 114], [114, 174], [174, 188], [134, 131], [131, 220], [220, 134], [174, 217], [217, 236], [236, 174], [236, 198], [198, 134], [134, 236], [215, 177], [177, 58], [58, 215], [156, 143], [143, 124], [124, 156], [25, 110], [110, 7], [7, 25], [31, 228], [228, 25], [25, 31], [264, 356], [356, 368], [368, 264], [0, 11], [11, 267], [267, 0], [451, 452], [452, 349], [349, 451], [267, 302], [302, 269], [269, 267], [350, 357], [357, 277], [277, 350], [350, 452], [452, 357], [357, 350], [299, 333], [333, 297], [297, 299], [396, 175], [175, 377], [377, 396], [280, 347], [347, 330], [330, 280], [269, 303], [303, 270], [270, 269], [151, 9], [9, 337], [337, 151], [344, 278], [278, 360], [360, 344], [424, 418], [418, 431], [431, 424], [270, 304], [304, 409], [409, 270], [272, 310], [310, 407], [407, 272], [322, 270], [270, 410], [410, 322], [449, 450], [450, 347], [347, 449], [432, 422], [422, 434], [434, 432], [18, 313], [313, 17], [17, 18], [291, 306], [306, 375], [375, 291], [259, 387], [387, 260], [260, 259], [424, 335], [335, 418], [418, 424], [434, 364], [364, 416], [416, 434], [391, 423], [423, 327], [327, 391], [301, 251], [251, 298], [298, 301], [275, 281], [281, 4], [4, 275], [254, 373], [373, 253], [253, 254], [375, 307], [307, 321], [321, 375], [280, 425], [425, 411], [411, 280], [200, 421], [421, 18], [18, 200], [335, 321], [321, 406], [406, 335], [321, 320], [320, 405], [405, 321], [314, 315], [315, 17], [17, 314], [423, 426], [426, 266], [266, 423], [396, 377], [377, 369], [369, 396], [270, 322], [322, 269], [269, 270], [413, 417], [417, 464], [464, 413], [385, 386], [386, 258], [258, 385], [248, 456], [456, 419], [419, 248], [298, 284], [284, 333], [333, 298], [168, 417], [417, 8], [8, 168], [448, 346], [346, 261], [261, 448], [417, 413], [413, 285], [285, 417], [326, 327], [327, 328], [328, 326], [277, 355], [355, 329], [329, 277], [309, 392], [392, 438], [438, 309], [381, 382], [382, 256], [256, 381], [279, 429], [429, 360], [360, 279], [365, 364], [364, 379], [379, 365], [355, 277], [277, 437], [437, 355], [282, 443], [443, 283], [283, 282], [281, 275], [275, 363], [363, 281], [395, 431], [431, 369], [369, 395], [299, 297], [297, 337], [337, 299], [335, 273], [273, 321], [321, 335], [348, 450], [450, 349], [349, 348], [359, 446], [446, 467], [467, 359], [283, 293], [293, 282], [282, 283], [250, 458], [458, 462], [462, 250], [300, 276], [276, 383], [383, 300], [292, 308], [308, 325], [325, 292], [283, 276], [276, 293], [293, 283], [264, 372], [372, 447], [447, 264], [346, 352], [352, 340], [340, 346], [354, 274], [274, 19], [19, 354], [363, 456], [456, 281], [281, 363], [426, 436], [436, 425], [425, 426], [380, 381], [381, 252], [252, 380], [267, 269], [269, 393], [393, 267], [421, 200], [200, 428], [428, 421], [371, 266], [266, 329], [329, 371], [432, 287], [287, 422], [422, 432], [290, 250], [250, 328], [328, 290], [385, 258], [258, 384], [384, 385], [446, 265], [265, 342], [342, 446], [386, 387], [387, 257], [257, 386], [422, 424], [424, 430], [430, 422], [445, 342], [342, 276], [276, 445], [422, 273], [273, 424], [424, 422], [306, 292], [292, 307], [307, 306], [352, 366], [366, 345], [345, 352], [268, 271], [271, 302], [302, 268], [358, 423], [423, 371], [371, 358], [327, 294], [294, 460], [460, 327], [331, 279], [279, 294], [294, 331], [303, 271], [271, 304], [304, 303], [436, 432], [432, 427], [427, 436], [304, 272], [272, 408], [408, 304], [395, 394], [394, 431], [431, 395], [378, 395], [395, 400], [400, 378], [296, 334], [334, 299], [299, 296], [6, 351], [351, 168], [168, 6], [376, 352], [352, 411], [411, 376], [307, 325], [325, 320], [320, 307], [285, 295], [295, 336], [336, 285], [320, 319], [319, 404], [404, 320], [329, 330], [330, 349], [349, 329], [334, 293], [293, 333], [333, 334], [366, 323], [323, 447], [447, 366], [316, 15], [15, 315], [315, 316], [331, 358], [358, 279], [279, 331], [317, 14], [14, 316], [316, 317], [8, 285], [285, 9], [9, 8], [277, 329], [329, 350], [350, 277], [253, 374], [374, 252], [252, 253], [319, 318], [318, 403], [403, 319], [351, 6], [6, 419], [419, 351], [324, 318], [318, 325], [325, 324], [397, 367], [367, 365], [365, 397], [288, 435], [435, 397], [397, 288], [278, 344], [344, 439], [439, 278], [310, 272], [272, 311], [311, 310], [248, 195], [195, 281], [281, 248], [375, 273], [273, 291], [291, 375], [175, 396], [396, 199], [199, 175], [312, 311], [311, 268], [268, 312], [276, 283], [283, 445], [445, 276], [390, 373], [373, 339], [339, 390], [295, 282], [282, 296], [296, 295], [448, 449], [449, 346], [346, 448], [356, 264], [264, 454], [454, 356], [337, 336], [336, 299], [299, 337], [337, 338], [338, 151], [151, 337], [294, 278], [278, 455], [455, 294], [308, 292], [292, 415], [415, 308], [429, 358], [358, 355], [355, 429], [265, 340], [340, 372], [372, 265], [352, 346], [346, 280], [280, 352], [295, 442], [442, 282], [282, 295], [354, 19], [19, 370], [370, 354], [285, 441], [441, 295], [295, 285], [195, 248], [248, 197], [197, 195], [457, 440], [440, 274], [274, 457], [301, 300], [300, 368], [368, 301], [417, 351], [351, 465], [465, 417], [251, 301], [301, 389], [389, 251], [394, 395], [395, 379], [379, 394], [399, 412], [412, 419], [419, 399], [410, 436], [436, 322], [322, 410], [326, 2], [2, 393], [393, 326], [354, 370], [370, 461], [461, 354], [393, 164], [164, 267], [267, 393], [268, 302], [302, 12], [12, 268], [312, 268], [268, 13], [13, 312], [298, 293], [293, 301], [301, 298], [265, 446], [446, 340], [340, 265], [280, 330], [330, 425], [425, 280], [322, 426], [426, 391], [391, 322], [420, 429], [429, 437], [437, 420], [393, 391], [391, 326], [326, 393], [344, 440], [440, 438], [438, 344], [458, 459], [459, 461], [461, 458], [364, 434], [434, 394], [394, 364], [428, 396], [396, 262], [262, 428], [274, 354], [354, 457], [457, 274], [317, 316], [316, 402], [402, 317], [316, 315], [315, 403], [403, 316], [315, 314], [314, 404], [404, 315], [314, 313], [313, 405], [405, 314], [313, 421], [421, 406], [406, 313], [323, 366], [366, 361], [361, 323], [292, 306], [306, 407], [407, 292], [306, 291], [291, 408], [408, 306], [291, 287], [287, 409], [409, 291], [287, 432], [432, 410], [410, 287], [427, 434], [434, 411], [411, 427], [372, 264], [264, 383], [383, 372], [459, 309], [309, 457], [457, 459], [366, 352], [352, 401], [401, 366], [1, 274], [274, 4], [4, 1], [418, 421], [421, 262], [262, 418], [331, 294], [294, 358], [358, 331], [435, 433], [433, 367], [367, 435], [392, 289], [289, 439], [439, 392], [328, 462], [462, 326], [326, 328], [94, 2], [2, 370], [370, 94], [289, 305], [305, 455], [455, 289], [339, 254], [254, 448], [448, 339], [359, 255], [255, 446], [446, 359], [254, 253], [253, 449], [449, 254], [253, 252], [252, 450], [450, 253], [252, 256], [256, 451], [451, 252], [256, 341], [341, 452], [452, 256], [414, 413], [413, 463], [463, 414], [286, 441], [441, 414], [414, 286], [286, 258], [258, 441], [441, 286], [258, 257], [257, 442], [442, 258], [257, 259], [259, 443], [443, 257], [259, 260], [260, 444], [444, 259], [260, 467], [467, 445], [445, 260], [309, 459], [459, 250], [250, 309], [305, 289], [289, 290], [290, 305], [305, 290], [290, 460], [460, 305], [401, 376], [376, 435], [435, 401], [309, 250], [250, 392], [392, 309], [376, 411], [411, 433], [433, 376], [453, 341], [341, 464], [464, 453], [357, 453], [453, 465], [465, 357], [343, 357], [357, 412], [412, 343], [437, 343], [343, 399], [399, 437], [344, 360], [360, 440], [440, 344], [420, 437], [437, 456], [456, 420], [360, 420], [420, 363], [363, 360], [361, 401], [401, 288], [288, 361], [265, 372], [372, 353], [353, 265], [390, 339], [339, 249], [249, 390], [339, 448], [448, 255], [255, 339]);
	function kc(t) {
		t.j = {
			faceLandmarks: [],
			faceBlendshapes: [],
			facialTransformationMatrixes: []
		};
	}
	var Sc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !1), this.j = {
				faceLandmarks: [],
				faceBlendshapes: [],
				facialTransformationMatrixes: []
			}, this.outputFacialTransformationMatrixes = this.outputFaceBlendshapes = !1, wn(t = this.h = new Js(), 0, 1, e = new Xs()), this.A = new $s(), wn(this.h, 0, 3, this.A), this.u = new zs(), wn(this.h, 0, 2, this.u), xn(this.u, 4, 1), Ln(this.u, 2, .5), Ln(this.A, 2, .5), Ln(this.h, 4, .5);
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return "numFaces" in t && xn(this.u, 4, t.numFaces ?? 1), "minFaceDetectionConfidence" in t && Ln(this.u, 2, t.minFaceDetectionConfidence ?? .5), "minTrackingConfidence" in t && Ln(this.h, 4, t.minTrackingConfidence ?? .5), "minFacePresenceConfidence" in t && Ln(this.A, 2, t.minFacePresenceConfidence ?? .5), "outputFaceBlendshapes" in t && (this.outputFaceBlendshapes = !!t.outputFaceBlendshapes), "outputFacialTransformationMatrixes" in t && (this.outputFacialTransformationMatrixes = !!t.outputFacialTransformationMatrixes), this.l(t);
		}
		F(t, e) {
			return kc(this), uc(this, t, e), this.j;
		}
		G(t, e, n) {
			return kc(this), lc(this, t, n, e), this.j;
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect"), us(t, "face_landmarks");
			const e = new Qi();
			xr(e, Qs, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.face_landmarker.FaceLandmarkerGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), rs(n, "NORM_LANDMARKS:face_landmarks"), n.o(e), cs(t, n), this.g.attachProtoVectorListener("face_landmarks", ((t, e) => {
				for (const e of t) t = ks(e), this.j.faceLandmarks.push(Ho(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("face_landmarks", ((t) => {
				ua(this, t);
			})), this.outputFaceBlendshapes && (us(t, "blendshapes"), rs(n, "BLENDSHAPES:blendshapes"), this.g.attachProtoVectorListener("blendshapes", ((t, e) => {
				if (this.outputFaceBlendshapes) for (const e of t) t = ys(e), this.j.faceBlendshapes.push(jo(t.g() ?? []));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("blendshapes", ((t) => {
				ua(this, t);
			}))), this.outputFacialTransformationMatrixes && (us(t, "face_geometry"), rs(n, "FACE_GEOMETRY:face_geometry"), this.g.attachProtoVectorListener("face_geometry", ((t, e) => {
				if (this.outputFacialTransformationMatrixes) for (const e of t) (t = yn(t = qs(e), Ss, 2)) && this.j.facialTransformationMatrixes.push({
					rows: kn(t, 1) ?? 0 ?? 0,
					columns: kn(t, 2) ?? 0 ?? 0,
					data: en(t, 3, $t, tn()).slice() ?? []
				});
				ua(this, e);
			})), this.g.attachEmptyPacketListener("face_geometry", ((t) => {
				ua(this, t);
			}))), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Sc.prototype.detectForVideo = Sc.prototype.G, Sc.prototype.detect = Sc.prototype.F, Sc.prototype.setOptions = Sc.prototype.o, Sc.createFromModelPath = function(t, e) {
		return cc(Sc, t, { baseOptions: { modelAssetPath: e } });
	}, Sc.createFromModelBuffer = function(t, e) {
		return cc(Sc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Sc.createFromOptions = function(t, e) {
		return cc(Sc, t, e);
	}, Sc.FACE_LANDMARKS_LIPS = gc, Sc.FACE_LANDMARKS_LEFT_EYE = mc, Sc.FACE_LANDMARKS_LEFT_EYEBROW = yc, Sc.FACE_LANDMARKS_LEFT_IRIS = _c, Sc.FACE_LANDMARKS_RIGHT_EYE = vc, Sc.FACE_LANDMARKS_RIGHT_EYEBROW = Ec, Sc.FACE_LANDMARKS_RIGHT_IRIS = wc, Sc.FACE_LANDMARKS_FACE_OVAL = Tc, Sc.FACE_LANDMARKS_CONTOURS = Ac, Sc.FACE_LANDMARKS_TESSELATION = bc;
	var xc = ic([0, 1], [1, 2], [2, 3], [3, 4], [0, 5], [5, 6], [6, 7], [7, 8], [5, 9], [9, 10], [10, 11], [11, 12], [9, 13], [13, 14], [14, 15], [15, 16], [13, 17], [0, 17], [17, 18], [18, 19], [19, 20]);
	function Lc(t) {
		t.gestures = [], t.landmarks = [], t.worldLandmarks = [], t.handedness = [];
	}
	function Rc(t) {
		return 0 === t.gestures.length ? {
			gestures: [],
			landmarks: [],
			worldLandmarks: [],
			handedness: [],
			handednesses: []
		} : {
			gestures: t.gestures,
			landmarks: t.landmarks,
			worldLandmarks: t.worldLandmarks,
			handedness: t.handedness,
			handednesses: t.handedness
		};
	}
	function Ic(t, e = !0) {
		const n = [];
		for (const i of t) {
			var r = ys(i);
			t = [];
			for (const n of r.g()) r = e && null != kn(n, 1) ? kn(n, 1) ?? 0 : -1, t.push({
				score: Sn(n, 2) ?? 0,
				index: r,
				categoryName: le($e(n, 3)) ?? "" ?? "",
				displayName: le($e(n, 4)) ?? "" ?? ""
			});
			n.push(t);
		}
		return n;
	}
	var Fc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !1), this.gestures = [], this.landmarks = [], this.worldLandmarks = [], this.handedness = [], wn(t = this.j = new oo(), 0, 1, e = new Xs()), this.u = new so(), wn(this.j, 0, 2, this.u), this.D = new io(), wn(this.u, 0, 3, this.D), this.A = new ro(), wn(this.u, 0, 2, this.A), this.h = new no(), wn(this.j, 0, 3, this.h), Ln(this.A, 2, .5), Ln(this.u, 4, .5), Ln(this.D, 2, .5);
		}
		get baseOptions() {
			return yn(this.j, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.j, 0, 1, t);
		}
		o(t) {
			if (xn(this.A, 3, t.numHands ?? 1), "minHandDetectionConfidence" in t && Ln(this.A, 2, t.minHandDetectionConfidence ?? .5), "minTrackingConfidence" in t && Ln(this.u, 4, t.minTrackingConfidence ?? .5), "minHandPresenceConfidence" in t && Ln(this.D, 2, t.minHandPresenceConfidence ?? .5), t.cannedGesturesClassifierOptions) {
				var e = new to(), n = e, r = Bo(t.cannedGesturesClassifierOptions, yn(this.h, to, 3)?.l());
				wn(n, 0, 2, r), wn(this.h, 0, 3, e);
			} else void 0 === t.cannedGesturesClassifierOptions && yn(this.h, to, 3)?.g();
			return t.customGesturesClassifierOptions ? (wn(n = e = new to(), 0, 2, r = Bo(t.customGesturesClassifierOptions, yn(this.h, to, 4)?.l())), wn(this.h, 0, 4, e)) : void 0 === t.customGesturesClassifierOptions && yn(this.h, to, 4)?.g(), this.l(t);
		}
		Ha(t, e) {
			return Lc(this), uc(this, t, e), Rc(this);
		}
		Ia(t, e, n) {
			return Lc(this), lc(this, t, n, e), Rc(this);
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect"), us(t, "hand_gestures"), us(t, "hand_landmarks"), us(t, "world_hand_landmarks"), us(t, "handedness");
			const e = new Qi();
			xr(e, lo, this.j);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.gesture_recognizer.GestureRecognizerGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), rs(n, "HAND_GESTURES:hand_gestures"), rs(n, "LANDMARKS:hand_landmarks"), rs(n, "WORLD_LANDMARKS:world_hand_landmarks"), rs(n, "HANDEDNESS:handedness"), n.o(e), cs(t, n), this.g.attachProtoVectorListener("hand_landmarks", ((t, e) => {
				for (const e of t) {
					t = ks(e);
					const n = [];
					for (const e of vn(t, bs, 1)) n.push({
						x: Sn(e, 1) ?? 0,
						y: Sn(e, 2) ?? 0,
						z: Sn(e, 3) ?? 0,
						visibility: Sn(e, 4) ?? 0
					});
					this.landmarks.push(n);
				}
				ua(this, e);
			})), this.g.attachEmptyPacketListener("hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoVectorListener("world_hand_landmarks", ((t, e) => {
				for (const e of t) {
					t = As(e);
					const n = [];
					for (const e of vn(t, Ts, 1)) n.push({
						x: Sn(e, 1) ?? 0,
						y: Sn(e, 2) ?? 0,
						z: Sn(e, 3) ?? 0,
						visibility: Sn(e, 4) ?? 0
					});
					this.worldLandmarks.push(n);
				}
				ua(this, e);
			})), this.g.attachEmptyPacketListener("world_hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoVectorListener("hand_gestures", ((t, e) => {
				this.gestures.push(...Ic(t, !1)), ua(this, e);
			})), this.g.attachEmptyPacketListener("hand_gestures", ((t) => {
				ua(this, t);
			})), this.g.attachProtoVectorListener("handedness", ((t, e) => {
				this.handedness.push(...Ic(t)), ua(this, e);
			})), this.g.attachEmptyPacketListener("handedness", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	function Mc(t) {
		return {
			landmarks: t.landmarks,
			worldLandmarks: t.worldLandmarks,
			handednesses: t.handedness,
			handedness: t.handedness
		};
	}
	Fc.prototype.recognizeForVideo = Fc.prototype.Ia, Fc.prototype.recognize = Fc.prototype.Ha, Fc.prototype.setOptions = Fc.prototype.o, Fc.createFromModelPath = function(t, e) {
		return cc(Fc, t, { baseOptions: { modelAssetPath: e } });
	}, Fc.createFromModelBuffer = function(t, e) {
		return cc(Fc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Fc.createFromOptions = function(t, e) {
		return cc(Fc, t, e);
	}, Fc.HAND_CONNECTIONS = xc;
	var Pc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !1), this.landmarks = [], this.worldLandmarks = [], this.handedness = [], wn(t = this.h = new so(), 0, 1, e = new Xs()), this.u = new io(), wn(this.h, 0, 3, this.u), this.j = new ro(), wn(this.h, 0, 2, this.j), xn(this.j, 3, 1), Ln(this.j, 2, .5), Ln(this.u, 2, .5), Ln(this.h, 4, .5);
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return "numHands" in t && xn(this.j, 3, t.numHands ?? 1), "minHandDetectionConfidence" in t && Ln(this.j, 2, t.minHandDetectionConfidence ?? .5), "minTrackingConfidence" in t && Ln(this.h, 4, t.minTrackingConfidence ?? .5), "minHandPresenceConfidence" in t && Ln(this.u, 2, t.minHandPresenceConfidence ?? .5), this.l(t);
		}
		F(t, e) {
			return this.landmarks = [], this.worldLandmarks = [], this.handedness = [], uc(this, t, e), Mc(this);
		}
		G(t, e, n) {
			return this.landmarks = [], this.worldLandmarks = [], this.handedness = [], lc(this, t, n, e), Mc(this);
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect"), us(t, "hand_landmarks"), us(t, "world_hand_landmarks"), us(t, "handedness");
			const e = new Qi();
			xr(e, fo, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.hand_landmarker.HandLandmarkerGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), rs(n, "LANDMARKS:hand_landmarks"), rs(n, "WORLD_LANDMARKS:world_hand_landmarks"), rs(n, "HANDEDNESS:handedness"), n.o(e), cs(t, n), this.g.attachProtoVectorListener("hand_landmarks", ((t, e) => {
				for (const e of t) t = ks(e), this.landmarks.push(Ho(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoVectorListener("world_hand_landmarks", ((t, e) => {
				for (const e of t) t = As(e), this.worldLandmarks.push(Wo(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("world_hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoVectorListener("handedness", ((t, e) => {
				var n = this.handedness, r = n.push;
				const i = [];
				for (const e of t) {
					t = ys(e);
					const n = [];
					for (const e of t.g()) n.push({
						score: Sn(e, 2) ?? 0,
						index: kn(e, 1) ?? 0 ?? -1,
						categoryName: le($e(e, 3)) ?? "" ?? "",
						displayName: le($e(e, 4)) ?? "" ?? ""
					});
					i.push(n);
				}
				r.call(n, ...i), ua(this, e);
			})), this.g.attachEmptyPacketListener("handedness", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Pc.prototype.detectForVideo = Pc.prototype.G, Pc.prototype.detect = Pc.prototype.F, Pc.prototype.setOptions = Pc.prototype.o, Pc.createFromModelPath = function(t, e) {
		return cc(Pc, t, { baseOptions: { modelAssetPath: e } });
	}, Pc.createFromModelBuffer = function(t, e) {
		return cc(Pc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Pc.createFromOptions = function(t, e) {
		return cc(Pc, t, e);
	}, Pc.HAND_CONNECTIONS = xc;
	var Cc = ic([0, 1], [1, 2], [2, 3], [3, 7], [0, 4], [4, 5], [5, 6], [6, 8], [9, 10], [11, 12], [11, 13], [13, 15], [15, 17], [15, 19], [15, 21], [17, 19], [12, 14], [14, 16], [16, 18], [16, 20], [16, 22], [18, 20], [11, 23], [12, 24], [23, 24], [23, 25], [24, 26], [25, 27], [26, 28], [27, 29], [28, 30], [29, 31], [30, 32], [27, 31], [28, 32]);
	function Oc(t) {
		t.h = {
			faceLandmarks: [],
			faceBlendshapes: [],
			poseLandmarks: [],
			poseWorldLandmarks: [],
			poseSegmentationMasks: [],
			leftHandLandmarks: [],
			leftHandWorldLandmarks: [],
			rightHandLandmarks: [],
			rightHandWorldLandmarks: []
		};
	}
	function Nc(t) {
		try {
			if (!t.D) return t.h;
			t.D(t.h);
		} finally {
			da(t);
		}
	}
	function Uc(t, e) {
		t = ks(t), e.push(Ho(t));
	}
	var Dc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "input_frames_image", null, !1), this.h = {
				faceLandmarks: [],
				faceBlendshapes: [],
				poseLandmarks: [],
				poseWorldLandmarks: [],
				poseSegmentationMasks: [],
				leftHandLandmarks: [],
				leftHandWorldLandmarks: [],
				rightHandLandmarks: [],
				rightHandWorldLandmarks: []
			}, this.outputPoseSegmentationMasks = this.outputFaceBlendshapes = !1, wn(t = this.j = new yo(), 0, 1, e = new Xs()), this.I = new io(), wn(this.j, 0, 2, this.I), this.W = new po(), wn(this.j, 0, 3, this.W), this.u = new zs(), wn(this.j, 0, 4, this.u), this.O = new $s(), wn(this.j, 0, 5, this.O), this.A = new go(), wn(this.j, 0, 6, this.A), this.M = new mo(), wn(this.j, 0, 7, this.M), Ln(this.u, 2, .5), Ln(this.u, 3, .3), Ln(this.O, 2, .5), Ln(this.A, 2, .5), Ln(this.A, 3, .3), Ln(this.M, 2, .5), Ln(this.I, 2, .5);
		}
		get baseOptions() {
			return yn(this.j, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.j, 0, 1, t);
		}
		o(t) {
			return "minFaceDetectionConfidence" in t && Ln(this.u, 2, t.minFaceDetectionConfidence ?? .5), "minFaceSuppressionThreshold" in t && Ln(this.u, 3, t.minFaceSuppressionThreshold ?? .3), "minFacePresenceConfidence" in t && Ln(this.O, 2, t.minFacePresenceConfidence ?? .5), "outputFaceBlendshapes" in t && (this.outputFaceBlendshapes = !!t.outputFaceBlendshapes), "minPoseDetectionConfidence" in t && Ln(this.A, 2, t.minPoseDetectionConfidence ?? .5), "minPoseSuppressionThreshold" in t && Ln(this.A, 3, t.minPoseSuppressionThreshold ?? .3), "minPosePresenceConfidence" in t && Ln(this.M, 2, t.minPosePresenceConfidence ?? .5), "outputPoseSegmentationMasks" in t && (this.outputPoseSegmentationMasks = !!t.outputPoseSegmentationMasks), "minHandLandmarksConfidence" in t && Ln(this.I, 2, t.minHandLandmarksConfidence ?? .5), this.l(t);
		}
		F(t, e, n) {
			const r = "function" != typeof e ? e : {};
			return this.D = "function" == typeof e ? e : n, Oc(this), uc(this, t, r), Nc(this);
		}
		G(t, e, n, r) {
			const i = "function" != typeof n ? n : {};
			return this.D = "function" == typeof n ? n : r, Oc(this), lc(this, t, i, e), Nc(this);
		}
		m() {
			var t = new ls();
			hs(t, "input_frames_image"), us(t, "pose_landmarks"), us(t, "pose_world_landmarks"), us(t, "face_landmarks"), us(t, "left_hand_landmarks"), us(t, "left_hand_world_landmarks"), us(t, "right_hand_landmarks"), us(t, "right_hand_world_landmarks");
			const e = new Qi(), n = new Bi();
			Rn(n, 1, "type.googleapis.com/mediapipe.tasks.vision.holistic_landmarker.proto.HolisticLandmarkerGraphOptions"), function(t, e) {
				if (null != e) if (Array.isArray(e)) Ze(t, 2, Ie(e, 0, Me));
				else {
					if (!("string" == typeof e || e instanceof F || x(e))) throw Error("invalid value in Any.value field: " + e + " expected a ByteString, a base64 encoded string, a Uint8Array or a jspb array");
					hn(t, 2, ht(e, !1), R());
				}
			}(n, this.j.g());
			const r = new is();
			Rn(r, 2, "mediapipe.tasks.vision.holistic_landmarker.HolisticLandmarkerGraph"), bn(r, 8, Bi, n), ns(r, "IMAGE:input_frames_image"), rs(r, "POSE_LANDMARKS:pose_landmarks"), rs(r, "POSE_WORLD_LANDMARKS:pose_world_landmarks"), rs(r, "FACE_LANDMARKS:face_landmarks"), rs(r, "LEFT_HAND_LANDMARKS:left_hand_landmarks"), rs(r, "LEFT_HAND_WORLD_LANDMARKS:left_hand_world_landmarks"), rs(r, "RIGHT_HAND_LANDMARKS:right_hand_landmarks"), rs(r, "RIGHT_HAND_WORLD_LANDMARKS:right_hand_world_landmarks"), r.o(e), cs(t, r), la(this, t), this.g.attachProtoListener("pose_landmarks", ((t, e) => {
				Uc(t, this.h.poseLandmarks), ua(this, e);
			})), this.g.attachEmptyPacketListener("pose_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoListener("pose_world_landmarks", ((t, e) => {
				var n = this.h.poseWorldLandmarks;
				t = As(t), n.push(Wo(t)), ua(this, e);
			})), this.g.attachEmptyPacketListener("pose_world_landmarks", ((t) => {
				ua(this, t);
			})), this.outputPoseSegmentationMasks && (rs(r, "POSE_SEGMENTATION_MASK:pose_segmentation_mask"), fa(this, "pose_segmentation_mask"), this.g.Z("pose_segmentation_mask", ((t, e) => {
				this.h.poseSegmentationMasks = [fc(this, t, !0, !this.D)], ua(this, e);
			})), this.g.attachEmptyPacketListener("pose_segmentation_mask", ((t) => {
				this.h.poseSegmentationMasks = [], ua(this, t);
			}))), this.g.attachProtoListener("face_landmarks", ((t, e) => {
				Uc(t, this.h.faceLandmarks), ua(this, e);
			})), this.g.attachEmptyPacketListener("face_landmarks", ((t) => {
				ua(this, t);
			})), this.outputFaceBlendshapes && (us(t, "extra_blendshapes"), rs(r, "FACE_BLENDSHAPES:extra_blendshapes"), this.g.attachProtoListener("extra_blendshapes", ((t, e) => {
				var n = this.h.faceBlendshapes;
				this.outputFaceBlendshapes && (t = ys(t), n.push(jo(t.g() ?? []))), ua(this, e);
			})), this.g.attachEmptyPacketListener("extra_blendshapes", ((t) => {
				ua(this, t);
			}))), this.g.attachProtoListener("left_hand_landmarks", ((t, e) => {
				Uc(t, this.h.leftHandLandmarks), ua(this, e);
			})), this.g.attachEmptyPacketListener("left_hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoListener("left_hand_world_landmarks", ((t, e) => {
				var n = this.h.leftHandWorldLandmarks;
				t = As(t), n.push(Wo(t)), ua(this, e);
			})), this.g.attachEmptyPacketListener("left_hand_world_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoListener("right_hand_landmarks", ((t, e) => {
				Uc(t, this.h.rightHandLandmarks), ua(this, e);
			})), this.g.attachEmptyPacketListener("right_hand_landmarks", ((t) => {
				ua(this, t);
			})), this.g.attachProtoListener("right_hand_world_landmarks", ((t, e) => {
				var n = this.h.rightHandWorldLandmarks;
				t = As(t), n.push(Wo(t)), ua(this, e);
			})), this.g.attachEmptyPacketListener("right_hand_world_landmarks", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Dc.prototype.detectForVideo = Dc.prototype.G, Dc.prototype.detect = Dc.prototype.F, Dc.prototype.setOptions = Dc.prototype.o, Dc.createFromModelPath = function(t, e) {
		return cc(Dc, t, { baseOptions: { modelAssetPath: e } });
	}, Dc.createFromModelBuffer = function(t, e) {
		return cc(Dc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Dc.createFromOptions = function(t, e) {
		return cc(Dc, t, e);
	}, Dc.HAND_CONNECTIONS = xc, Dc.POSE_CONNECTIONS = Cc, Dc.FACE_LANDMARKS_LIPS = gc, Dc.FACE_LANDMARKS_LEFT_EYE = mc, Dc.FACE_LANDMARKS_LEFT_EYEBROW = yc, Dc.FACE_LANDMARKS_LEFT_IRIS = _c, Dc.FACE_LANDMARKS_RIGHT_EYE = vc, Dc.FACE_LANDMARKS_RIGHT_EYEBROW = Ec, Dc.FACE_LANDMARKS_RIGHT_IRIS = wc, Dc.FACE_LANDMARKS_FACE_OVAL = Tc, Dc.FACE_LANDMARKS_CONTOURS = Ac, Dc.FACE_LANDMARKS_TESSELATION = bc;
	var Bc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "input_image", "norm_rect", !0), this.j = { classifications: [] }, wn(t = this.h = new Eo(), 0, 1, e = new Xs());
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return wn(this.h, 0, 2, Bo(t, yn(this.h, Ns, 2))), this.l(t);
		}
		sa(t, e) {
			return this.j = { classifications: [] }, uc(this, t, e), this.j;
		}
		ta(t, e, n) {
			return this.j = { classifications: [] }, lc(this, t, n, e), this.j;
		}
		m() {
			var t = new ls();
			hs(t, "input_image"), hs(t, "norm_rect"), us(t, "classifications");
			const e = new Qi();
			xr(e, wo, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.image_classifier.ImageClassifierGraph"), ns(n, "IMAGE:input_image"), ns(n, "NORM_RECT:norm_rect"), rs(n, "CLASSIFICATIONS:classifications"), n.o(e), cs(t, n), this.g.attachProtoListener("classifications", ((t, e) => {
				this.j = Vo(Is(t)), ua(this, e);
			})), this.g.attachEmptyPacketListener("classifications", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Bc.prototype.classifyForVideo = Bc.prototype.ta, Bc.prototype.classify = Bc.prototype.sa, Bc.prototype.setOptions = Bc.prototype.o, Bc.createFromModelPath = function(t, e) {
		return cc(Bc, t, { baseOptions: { modelAssetPath: e } });
	}, Bc.createFromModelBuffer = function(t, e) {
		return cc(Bc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Bc.createFromOptions = function(t, e) {
		return cc(Bc, t, e);
	};
	var Gc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !0), this.h = new To(), this.embeddings = { embeddings: [] }, wn(t = this.h, 0, 1, e = new Xs());
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			var e = this.h, n = yn(this.h, Ds, 2);
			return n = n ? n.clone() : new Ds(), void 0 !== t.l2Normalize ? Ze(n, 1, Jt(t.l2Normalize)) : "l2Normalize" in t && Ze(n, 1), void 0 !== t.quantize ? Ze(n, 2, Jt(t.quantize)) : "quantize" in t && Ze(n, 2), wn(e, 0, 2, n), this.l(t);
		}
		za(t, e) {
			return uc(this, t, e), this.embeddings;
		}
		Aa(t, e, n) {
			return lc(this, t, n, e), this.embeddings;
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect"), us(t, "embeddings_out");
			const e = new Qi();
			xr(e, Ao, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.image_embedder.ImageEmbedderGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), rs(n, "EMBEDDINGS:embeddings_out"), n.o(e), cs(t, n), this.g.attachProtoListener("embeddings_out", ((t, e) => {
				t = Os(t), this.embeddings = function(t) {
					return {
						embeddings: vn(t, Ps, 1).map(((t) => {
							const e = {
								headIndex: kn(t, 3) ?? 0 ?? -1,
								headName: le($e(t, 4)) ?? "" ?? ""
							};
							var n = t.v;
							return void 0 !== mn(n, 0 | n[Q], Fs, ln(t, 1)) ? (t = en(t = yn(t, Fs, ln(t, 1), void 0), 1, $t, tn()), e.floatEmbedding = t.slice()) : (n = /* @__PURE__ */ new Uint8Array(0), e.quantizedEmbedding = yn(t, Ms, ln(t, 2), void 0)?.na()?.h() ?? n), e;
						})),
						timestampMs: Go($e(t, 2, void 0, void 0, ce) ?? Ye)
					};
				}(t), ua(this, e);
			})), this.g.attachEmptyPacketListener("embeddings_out", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Gc.cosineSimilarity = function(t, e) {
		if (t.floatEmbedding && e.floatEmbedding) t = Ko(t.floatEmbedding, e.floatEmbedding);
		else {
			if (!t.quantizedEmbedding || !e.quantizedEmbedding) throw Error("Cannot compute cosine similarity between quantized and float embeddings.");
			t = Ko(zo(t.quantizedEmbedding), zo(e.quantizedEmbedding));
		}
		return t;
	}, Gc.prototype.embedForVideo = Gc.prototype.Aa, Gc.prototype.embed = Gc.prototype.za, Gc.prototype.setOptions = Gc.prototype.o, Gc.createFromModelPath = function(t, e) {
		return cc(Gc, t, { baseOptions: { modelAssetPath: e } });
	}, Gc.createFromModelBuffer = function(t, e) {
		return cc(Gc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Gc.createFromOptions = function(t, e) {
		return cc(Gc, t, e);
	};
	var jc = class {
		constructor(t, e, n) {
			this.confidenceMasks = t, this.categoryMask = e, this.qualityScores = n;
		}
		close() {
			this.confidenceMasks?.forEach(((t) => {
				t.close();
			})), this.categoryMask?.close();
		}
	};
	function Vc(t) {
		const e = function(t) {
			return vn(t, is, 1);
		}(t.ca()).filter(((t) => (le($e(t, 1)) ?? "").includes("mediapipe.tasks.TensorsToSegmentationCalculator")));
		if (t.u = [], e.length > 1) throw Error("The graph has more than one mediapipe.tasks.TensorsToSegmentationCalculator.");
		1 === e.length && (yn(e[0], Qi, 7)?.j()?.g() ?? /* @__PURE__ */ new Map()).forEach(((e, n) => {
			t.u[Number(n)] = le($e(e, 1)) ?? "";
		}));
	}
	function Xc(t) {
		t.categoryMask = void 0, t.confidenceMasks = void 0, t.qualityScores = void 0;
	}
	function Hc(t) {
		try {
			const e = new jc(t.confidenceMasks, t.categoryMask, t.qualityScores);
			if (!t.j) return e;
			t.j(e);
		} finally {
			da(t);
		}
	}
	jc.prototype.close = jc.prototype.close;
	var Wc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !1), this.u = [], this.outputCategoryMask = !1, this.outputConfidenceMasks = !0, this.h = new Lo(), this.A = new bo(), wn(this.h, 0, 3, this.A), wn(t = this.h, 0, 1, e = new Xs());
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return void 0 !== t.displayNamesLocale ? Ze(this.h, 2, ue(t.displayNamesLocale)) : "displayNamesLocale" in t && Ze(this.h, 2), "outputCategoryMask" in t && (this.outputCategoryMask = t.outputCategoryMask ?? !1), "outputConfidenceMasks" in t && (this.outputConfidenceMasks = t.outputConfidenceMasks ?? !0), super.l(t);
		}
		L() {
			Vc(this);
		}
		segment(t, e, n) {
			const r = "function" != typeof e ? e : {};
			return this.j = "function" == typeof e ? e : n, Xc(this), uc(this, t, r), Hc(this);
		}
		La(t, e, n, r) {
			const i = "function" != typeof n ? n : {};
			return this.j = "function" == typeof n ? n : r, Xc(this), lc(this, t, i, e), Hc(this);
		}
		Da() {
			return this.u;
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect");
			const e = new Qi();
			xr(e, Ro, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.image_segmenter.ImageSegmenterGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), n.o(e), cs(t, n), la(this, t), this.outputConfidenceMasks && (us(t, "confidence_masks"), rs(n, "CONFIDENCE_MASKS:confidence_masks"), fa(this, "confidence_masks"), this.g.aa("confidence_masks", ((t, e) => {
				this.confidenceMasks = t.map(((t) => fc(this, t, !0, !this.j))), ua(this, e);
			})), this.g.attachEmptyPacketListener("confidence_masks", ((t) => {
				this.confidenceMasks = [], ua(this, t);
			}))), this.outputCategoryMask && (us(t, "category_mask"), rs(n, "CATEGORY_MASK:category_mask"), fa(this, "category_mask"), this.g.Z("category_mask", ((t, e) => {
				this.categoryMask = fc(this, t, !1, !this.j), ua(this, e);
			})), this.g.attachEmptyPacketListener("category_mask", ((t) => {
				this.categoryMask = void 0, ua(this, t);
			}))), us(t, "quality_scores"), rs(n, "QUALITY_SCORES:quality_scores"), this.g.attachFloatVectorListener("quality_scores", ((t, e) => {
				this.qualityScores = t, ua(this, e);
			})), this.g.attachEmptyPacketListener("quality_scores", ((t) => {
				this.categoryMask = void 0, ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Wc.prototype.getLabels = Wc.prototype.Da, Wc.prototype.segmentForVideo = Wc.prototype.La, Wc.prototype.segment = Wc.prototype.segment, Wc.prototype.setOptions = Wc.prototype.o, Wc.createFromModelPath = function(t, e) {
		return cc(Wc, t, { baseOptions: { modelAssetPath: e } });
	}, Wc.createFromModelBuffer = function(t, e) {
		return cc(Wc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Wc.createFromOptions = function(t, e) {
		return cc(Wc, t, e);
	};
	var zc = class {
		constructor(t, e, n) {
			this.confidenceMasks = t, this.categoryMask = e, this.qualityScores = n;
		}
		close() {
			this.confidenceMasks?.forEach(((t) => {
				t.close();
			})), this.categoryMask?.close();
		}
	};
	zc.prototype.close = zc.prototype.close;
	var Kc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect_in", !1), this.outputCategoryMask = !1, this.outputConfidenceMasks = !0, this.h = new Lo(), this.u = new bo(), wn(this.h, 0, 3, this.u), wn(t = this.h, 0, 1, e = new Xs());
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return "outputCategoryMask" in t && (this.outputCategoryMask = t.outputCategoryMask ?? !1), "outputConfidenceMasks" in t && (this.outputConfidenceMasks = t.outputConfidenceMasks ?? !0), super.l(t);
		}
		segment(t, e, n, r) {
			const i = "function" != typeof n ? n : {};
			if (this.j = "function" == typeof n ? n : r, this.qualityScores = this.categoryMask = this.confidenceMasks = void 0, n = this.C + 1, r = new Po(), e.keypoint && e.scribble) throw Error("Cannot provide both keypoint and scribble.");
			if (e.keypoint) {
				var s = new Io();
				hn(s, 3, Jt(!0), !1), hn(s, 1, qt(e.keypoint.x), 0), hn(s, 2, qt(e.keypoint.y), 0), Tn(r, 1, Co, s);
			} else {
				if (!e.scribble) throw Error("Must provide either a keypoint or a scribble.");
				{
					const t = new Mo();
					for (s of e.scribble) hn(e = new Io(), 3, Jt(!0), !1), hn(e, 1, qt(s.x), 0), hn(e, 2, qt(s.y), 0), bn(t, 1, Io, e);
					Tn(r, 2, Co, t);
				}
			}
			this.g.addProtoToStream(r.g(), "mediapipe.tasks.vision.interactive_segmenter.proto.RegionOfInterest", "roi_in", n), uc(this, t, i);
			t: {
				try {
					const t = new zc(this.confidenceMasks, this.categoryMask, this.qualityScores);
					if (!this.j) {
						var o = t;
						break t;
					}
					this.j(t);
				} finally {
					da(this);
				}
				o = void 0;
			}
			return o;
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "roi_in"), hs(t, "norm_rect_in");
			const e = new Qi();
			xr(e, Ro, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.interactive_segmenter.InteractiveSegmenterGraphV2"), ns(n, "IMAGE:image_in"), ns(n, "ROI:roi_in"), ns(n, "NORM_RECT:norm_rect_in"), n.o(e), cs(t, n), la(this, t), this.outputConfidenceMasks && (us(t, "confidence_masks"), rs(n, "CONFIDENCE_MASKS:confidence_masks"), fa(this, "confidence_masks"), this.g.aa("confidence_masks", ((t, e) => {
				this.confidenceMasks = t.map(((t) => fc(this, t, !0, !this.j))), ua(this, e);
			})), this.g.attachEmptyPacketListener("confidence_masks", ((t) => {
				this.confidenceMasks = [], ua(this, t);
			}))), this.outputCategoryMask && (us(t, "category_mask"), rs(n, "CATEGORY_MASK:category_mask"), fa(this, "category_mask"), this.g.Z("category_mask", ((t, e) => {
				this.categoryMask = fc(this, t, !1, !this.j), ua(this, e);
			})), this.g.attachEmptyPacketListener("category_mask", ((t) => {
				this.categoryMask = void 0, ua(this, t);
			}))), us(t, "quality_scores"), rs(n, "QUALITY_SCORES:quality_scores"), this.g.attachFloatVectorListener("quality_scores", ((t, e) => {
				this.qualityScores = t, ua(this, e);
			})), this.g.attachEmptyPacketListener("quality_scores", ((t) => {
				this.categoryMask = void 0, ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Kc.prototype.segment = Kc.prototype.segment, Kc.prototype.setOptions = Kc.prototype.o, Kc.createFromModelPath = function(t, e) {
		return cc(Kc, t, { baseOptions: { modelAssetPath: e } });
	}, Kc.createFromModelBuffer = function(t, e) {
		return cc(Kc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Kc.createFromOptions = function(t, e) {
		return cc(Kc, t, e);
	};
	var Yc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "input_frame_gpu", "norm_rect", !1), this.j = { detections: [] }, wn(t = this.h = new Oo(), 0, 1, e = new Xs());
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return void 0 !== t.displayNamesLocale ? Ze(this.h, 2, ue(t.displayNamesLocale)) : "displayNamesLocale" in t && Ze(this.h, 2), void 0 !== t.maxResults ? xn(this.h, 3, t.maxResults) : "maxResults" in t && Ze(this.h, 3), void 0 !== t.scoreThreshold ? Ln(this.h, 4, t.scoreThreshold) : "scoreThreshold" in t && Ze(this.h, 4), void 0 !== t.categoryAllowlist ? In(this.h, 5, t.categoryAllowlist) : "categoryAllowlist" in t && Ze(this.h, 5), void 0 !== t.categoryDenylist ? In(this.h, 6, t.categoryDenylist) : "categoryDenylist" in t && Ze(this.h, 6), this.l(t);
		}
		F(t, e) {
			return this.j = { detections: [] }, uc(this, t, e), this.j;
		}
		G(t, e, n) {
			return this.j = { detections: [] }, lc(this, t, n, e), this.j;
		}
		m() {
			var t = new ls();
			hs(t, "input_frame_gpu"), hs(t, "norm_rect"), us(t, "detections");
			const e = new Qi();
			xr(e, No, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.ObjectDetectorGraph"), ns(n, "IMAGE:input_frame_gpu"), ns(n, "NORM_RECT:norm_rect"), rs(n, "DETECTIONS:detections"), n.o(e), cs(t, n), this.g.attachProtoVectorListener("detections", ((t, e) => {
				for (const e of t) t = ws(e), this.j.detections.push(Xo(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("detections", ((t) => {
				ua(this, t);
			})), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Yc.prototype.detectForVideo = Yc.prototype.G, Yc.prototype.detect = Yc.prototype.F, Yc.prototype.setOptions = Yc.prototype.o, Yc.createFromModelPath = async function(t, e) {
		return cc(Yc, t, { baseOptions: { modelAssetPath: e } });
	}, Yc.createFromModelBuffer = function(t, e) {
		return cc(Yc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Yc.createFromOptions = function(t, e) {
		return cc(Yc, t, e);
	};
	var qc = class {
		constructor(t, e, n) {
			this.landmarks = t, this.worldLandmarks = e, this.segmentationMasks = n;
		}
		close() {
			this.segmentationMasks?.forEach(((t) => {
				t.close();
			}));
		}
	};
	function $c(t) {
		t.landmarks = [], t.worldLandmarks = [], t.segmentationMasks = void 0;
	}
	function Jc(t) {
		try {
			const e = new qc(t.landmarks, t.worldLandmarks, t.segmentationMasks);
			if (!t.u) return e;
			t.u(e);
		} finally {
			da(t);
		}
	}
	qc.prototype.close = qc.prototype.close;
	var Zc = class extends dc {
		constructor(t, e) {
			super(new ac(t, e), "image_in", "norm_rect", !1), this.landmarks = [], this.worldLandmarks = [], this.outputSegmentationMasks = !1, wn(t = this.h = new Uo(), 0, 1, e = new Xs()), this.A = new mo(), wn(this.h, 0, 3, this.A), this.j = new go(), wn(this.h, 0, 2, this.j), xn(this.j, 4, 1), Ln(this.j, 2, .5), Ln(this.A, 2, .5), Ln(this.h, 4, .5);
		}
		get baseOptions() {
			return yn(this.h, Xs, 1);
		}
		set baseOptions(t) {
			wn(this.h, 0, 1, t);
		}
		o(t) {
			return "numPoses" in t && xn(this.j, 4, t.numPoses ?? 1), "minPoseDetectionConfidence" in t && Ln(this.j, 2, t.minPoseDetectionConfidence ?? .5), "minTrackingConfidence" in t && Ln(this.h, 4, t.minTrackingConfidence ?? .5), "minPosePresenceConfidence" in t && Ln(this.A, 2, t.minPosePresenceConfidence ?? .5), "outputSegmentationMasks" in t && (this.outputSegmentationMasks = t.outputSegmentationMasks ?? !1), this.l(t);
		}
		F(t, e, n) {
			const r = "function" != typeof e ? e : {};
			return this.u = "function" == typeof e ? e : n, $c(this), uc(this, t, r), Jc(this);
		}
		G(t, e, n, r) {
			const i = "function" != typeof n ? n : {};
			return this.u = "function" == typeof n ? n : r, $c(this), lc(this, t, i, e), Jc(this);
		}
		m() {
			var t = new ls();
			hs(t, "image_in"), hs(t, "norm_rect"), us(t, "normalized_landmarks"), us(t, "world_landmarks"), us(t, "segmentation_masks");
			const e = new Qi();
			xr(e, Do, this.h);
			const n = new is();
			Rn(n, 2, "mediapipe.tasks.vision.pose_landmarker.PoseLandmarkerGraph"), ns(n, "IMAGE:image_in"), ns(n, "NORM_RECT:norm_rect"), rs(n, "NORM_LANDMARKS:normalized_landmarks"), rs(n, "WORLD_LANDMARKS:world_landmarks"), n.o(e), cs(t, n), la(this, t), this.g.attachProtoVectorListener("normalized_landmarks", ((t, e) => {
				this.landmarks = [];
				for (const e of t) t = ks(e), this.landmarks.push(Ho(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("normalized_landmarks", ((t) => {
				this.landmarks = [], ua(this, t);
			})), this.g.attachProtoVectorListener("world_landmarks", ((t, e) => {
				this.worldLandmarks = [];
				for (const e of t) t = As(e), this.worldLandmarks.push(Wo(t));
				ua(this, e);
			})), this.g.attachEmptyPacketListener("world_landmarks", ((t) => {
				this.worldLandmarks = [], ua(this, t);
			})), this.outputSegmentationMasks && (rs(n, "SEGMENTATION_MASK:segmentation_masks"), fa(this, "segmentation_masks"), this.g.aa("segmentation_masks", ((t, e) => {
				this.segmentationMasks = t.map(((t) => fc(this, t, !0, !this.u))), ua(this, e);
			})), this.g.attachEmptyPacketListener("segmentation_masks", ((t) => {
				this.segmentationMasks = [], ua(this, t);
			}))), t = t.g(), this.setGraph(new Uint8Array(t), !0);
		}
	};
	Zc.prototype.detectForVideo = Zc.prototype.G, Zc.prototype.detect = Zc.prototype.F, Zc.prototype.setOptions = Zc.prototype.o, Zc.createFromModelPath = function(t, e) {
		return cc(Zc, t, { baseOptions: { modelAssetPath: e } });
	}, Zc.createFromModelBuffer = function(t, e) {
		return cc(Zc, t, { baseOptions: { modelAssetBuffer: e } });
	}, Zc.createFromOptions = function(t, e) {
		return cc(Zc, t, e);
	}, Zc.POSE_CONNECTIONS = Cc;
	//#endregion
	//#region src/WebGLRenderer.ts
	var WebGLRenderer = class WebGLRenderer {
		canvas;
		gl;
		stateUpdateProgram;
		maskRefineProgram;
		blurProgram;
		blendProgram;
		stateUpdateLocations;
		maskRefineLocations;
		blurLocations;
		blendLocations;
		positionBuffer;
		texCoordBuffer;
		storedStateTextures;
		fbo;
		refineFbo;
		refinedMaskTexture;
		frameTexture;
		blurTexture1;
		blurTexture2;
		blurFbo1;
		blurFbo2;
		running = false;
		static DEFAULT_BG_COLOR = [
			33,
			150,
			243,
			255
		];
		currentStateIndex = 0;
		backgroundRenderInfo = null;
		activeBackgroundSourceIdentifier = null;
		constructor(canvas) {
			this.canvas = canvas;
			const gl = this.canvas.getContext("webgl2", {
				alpha: false,
				antialias: false,
				desynchronized: true
			});
			if (!gl) throw new Error("WebGL2 not supported");
			this.gl = gl;
			const stateUpdateVertexShaderSource = \`attribute vec2 a_position; attribute vec2 a_texCoord; varying vec2 v_texCoord; void main() { gl_Position = vec4(a_position, 0.0, 1.0); v_texCoord = a_texCoord; }\`;
			const stateUpdateFragmentShaderSource = \`
      precision mediump float;
      varying vec2 v_texCoord;
      uniform sampler2D u_categoryTexture;
      uniform sampler2D u_confidenceTexture;
      uniform sampler2D u_prevStateTexture;
      uniform float u_smoothingFactor;
      uniform float u_smoothstepMin;
      uniform float u_smoothstepMax;
      uniform int u_selfieModel;

      void main() {
        vec2 prevCoord = vec2(v_texCoord.x, 1.0 - v_texCoord.y);
        float categoryValue = texture2D(u_categoryTexture, v_texCoord).r;
        float confidenceValue = texture2D(u_confidenceTexture, v_texCoord).r;

        if (u_selfieModel == 1) {
            categoryValue = 1.0 - categoryValue;
            confidenceValue = 1.0 - confidenceValue;
        }

        if (categoryValue > 0.0) {
            categoryValue = 1.0;
            confidenceValue = 1.0 - confidenceValue;
        }

        float nonLinearConfidence = smoothstep(u_smoothstepMin, u_smoothstepMax, confidenceValue);
        float prevCategoryValue = texture2D(u_prevStateTexture, prevCoord).r;
        float alpha = u_smoothingFactor * nonLinearConfidence;
        float newCategoryValue = alpha * categoryValue + (1.0 - alpha) * prevCategoryValue;

        gl_FragColor = vec4(newCategoryValue, 0.0, 0.0, 0.0);
      }
    \`;
			this.stateUpdateProgram = this.createAndLinkProgram(stateUpdateVertexShaderSource, stateUpdateFragmentShaderSource);
			this.stateUpdateLocations = {
				position: gl.getAttribLocation(this.stateUpdateProgram, "a_position"),
				texCoord: gl.getAttribLocation(this.stateUpdateProgram, "a_texCoord"),
				categoryTexture: gl.getUniformLocation(this.stateUpdateProgram, "u_categoryTexture"),
				confidenceTexture: gl.getUniformLocation(this.stateUpdateProgram, "u_confidenceTexture"),
				prevStateTexture: gl.getUniformLocation(this.stateUpdateProgram, "u_prevStateTexture"),
				smoothingFactor: gl.getUniformLocation(this.stateUpdateProgram, "u_smoothingFactor"),
				smoothstepMin: gl.getUniformLocation(this.stateUpdateProgram, "u_smoothstepMin"),
				smoothstepMax: gl.getUniformLocation(this.stateUpdateProgram, "u_smoothstepMax"),
				selfieModel: gl.getUniformLocation(this.stateUpdateProgram, "u_selfieModel")
			};
			const maskRefineVertexShaderSource = stateUpdateVertexShaderSource;
			const maskRefineFragmentShaderSource = \`
      precision mediump float;
      varying vec2 v_texCoord;

      uniform sampler2D u_maskTexture;
      uniform sampler2D u_frameTexture;
      uniform vec2 u_texelSize;
      uniform float u_sigmaSpatial;
      uniform float u_sigmaRange;

      void main() {
        vec2 flippedCoord = v_texCoord;
        vec3 centerPixelColor = texture2D(u_frameTexture, v_texCoord).rgb;
        float totalWeight = 0.0;
        float weightedMaskSum = 0.0;

        for (int offsetX = -2; offsetX <= 2; offsetX++) {
          for (int offsetY = -2; offsetY <= 2; offsetY++) {
            vec2 shift = vec2(float(offsetX), float(offsetY)) * u_texelSize;
            vec2 frameCoord = v_texCoord + shift;
            vec2 maskCoord = flippedCoord + shift;

            vec3 neighborPixelColor = texture2D(u_frameTexture, frameCoord).rgb;
            float neighborMaskValue = texture2D(u_maskTexture, maskCoord).r;

            float spatialWeight = exp(-dot(shift, shift) / (2.0 * u_sigmaSpatial * u_sigmaSpatial));
            vec3 colorDifference = neighborPixelColor - centerPixelColor;
            float rangeWeight = exp(-(dot(colorDifference, colorDifference)) / (2.0 * u_sigmaRange * u_sigmaRange));

            float combinedWeight = spatialWeight * rangeWeight;
            weightedMaskSum += neighborMaskValue * combinedWeight;
            totalWeight += combinedWeight;
          }
        }

        float refinedMaskValue = weightedMaskSum / max(totalWeight, 1e-6);
        gl_FragColor = vec4(refinedMaskValue, refinedMaskValue, refinedMaskValue, 1.0);
      }
    \`;
			this.maskRefineProgram = this.createAndLinkProgram(maskRefineVertexShaderSource, maskRefineFragmentShaderSource);
			this.maskRefineLocations = {
				position: gl.getAttribLocation(this.maskRefineProgram, "a_position"),
				texCoord: gl.getAttribLocation(this.maskRefineProgram, "a_texCoord"),
				maskTexture: gl.getUniformLocation(this.maskRefineProgram, "u_maskTexture"),
				frameTexture: gl.getUniformLocation(this.maskRefineProgram, "u_frameTexture"),
				texelSize: gl.getUniformLocation(this.maskRefineProgram, "u_texelSize"),
				sigmaSpatial: gl.getUniformLocation(this.maskRefineProgram, "u_sigmaSpatial"),
				sigmaRange: gl.getUniformLocation(this.maskRefineProgram, "u_sigmaRange")
			};
			const blurVertexShaderSource = stateUpdateVertexShaderSource;
			const blurFragmentShaderSource = \`
      precision highp float;
      varying vec2 v_texCoord;

      uniform sampler2D u_image;
      uniform sampler2D u_personMask;
      uniform vec2 u_texelSize;
      uniform float u_sigma;
      uniform float u_radiusScale;
      uniform vec2 u_direction;

      const int KERNEL_RADIUS = 10;

      float gauss(float x, float s) {
        return exp(-(x * x) / (2.0 * s * s));
      }

      void main() {
        vec2 maskCoord = u_direction.y > 0.5 ? vec2(v_texCoord.x, 1.0 - v_texCoord.y) : v_texCoord;
        float mCenter = texture2D(u_personMask, maskCoord).r;
        float wCenter = gauss(0.0, u_sigma);
        vec4 accum = texture2D(u_image, v_texCoord) * wCenter * (1.0 - mCenter);
        float weightSum = wCenter * (1.0 - mCenter);

        for (int i = 1; i <= KERNEL_RADIUS; i++) {
          float f = float(i);
          float offset = f * u_radiusScale;
          float w = gauss(offset, u_sigma);
          vec2 texOffset = u_direction * offset * u_texelSize;

          vec2 uvPlus = v_texCoord + texOffset;
          vec2 maskCoordPlus = u_direction.y > 0.5 ? vec2(uvPlus.x, 1.0 - uvPlus.y) : uvPlus;
          float mPlus = texture2D(u_personMask, maskCoordPlus).r;
          accum += texture2D(u_image, uvPlus) * w * (1.0 - mPlus);
          weightSum += w * (1.0 - mPlus);

          vec2 uvMinus = v_texCoord - texOffset;
          vec2 maskCoordMinus = u_direction.y > 0.5 ? vec2(uvMinus.x, 1.0 - uvMinus.y) : uvMinus;
          float mMinus = texture2D(u_personMask, maskCoordMinus).r;
          accum += texture2D(u_image, uvMinus) * w * (1.0 - mMinus);
          weightSum += w * (1.0 - mMinus);
        }

        vec4 blurred = accum / max(weightSum, 1e-6);
        gl_FragColor = blurred;
      }
    \`;
			this.blurProgram = this.createAndLinkProgram(blurVertexShaderSource, blurFragmentShaderSource);
			this.blurLocations = {
				position: gl.getAttribLocation(this.blurProgram, "a_position"),
				texCoord: gl.getAttribLocation(this.blurProgram, "a_texCoord"),
				image: gl.getUniformLocation(this.blurProgram, "u_image"),
				personMask: gl.getUniformLocation(this.blurProgram, "u_personMask"),
				texelSize: gl.getUniformLocation(this.blurProgram, "u_texelSize"),
				sigma: gl.getUniformLocation(this.blurProgram, "u_sigma"),
				radiusScale: gl.getUniformLocation(this.blurProgram, "u_radiusScale"),
				direction: gl.getUniformLocation(this.blurProgram, "u_direction")
			};
			const blendVertexShaderSource = stateUpdateVertexShaderSource;
			const blendFragmentShaderSource = \`
      precision mediump float;
      varying vec2 v_texCoord;

      uniform sampler2D u_frameTexture;
      uniform sampler2D u_currentStateTexture;
      uniform sampler2D u_backgroundTexture;
      uniform vec2 u_bgImageDimensions;
      uniform vec2 u_canvasDimensions;
      uniform float u_borderSmooth;
      uniform float u_bgBlur;
      uniform float u_bgBlurRadius;
      uniform int u_enabled;

      vec4 getMixedFragColor(vec2 bgTexCoord, vec2 categoryCoord, vec2 offset) {
          vec4 backgroundColor = texture2D(u_backgroundTexture, bgTexCoord + offset);
          vec4 frameColor = texture2D(u_frameTexture, v_texCoord + offset);
          float categoryValue = texture2D(u_currentStateTexture, categoryCoord + offset).r;
          return mix(backgroundColor, frameColor, categoryValue);
      }

      void main() {
        if (u_enabled == 0) {
          gl_FragColor = texture2D(u_frameTexture, v_texCoord);
          return;
        }

        vec2 categoryCoord = v_texCoord;
        float categoryValue = texture2D(u_currentStateTexture, categoryCoord).r;

        float canvasAspect = u_canvasDimensions.x / u_canvasDimensions.y;
          float bgAspect = u_bgImageDimensions.x / u_bgImageDimensions.y;

          vec2 bgTexCoord = v_texCoord;
          float scaleX = 1.0;
          float scaleY = 1.0;
          float offsetX = 0.0;
          float offsetY = 0.0;

          if (canvasAspect < bgAspect) {
              scaleY = 1.0;
              scaleX = bgAspect / canvasAspect;
              offsetX = (1.0 - scaleX) / 2.0;
          } else {
              scaleX = 1.0;
              scaleY = canvasAspect / bgAspect;
              offsetY = (1.0 - scaleY) / 2.0;
          }

          bgTexCoord = vec2((v_texCoord.x - offsetX) / scaleX, (v_texCoord.y - offsetY) / scaleY);
          gl_FragColor = getMixedFragColor(bgTexCoord, categoryCoord, vec2(0.0, 0.0));
    }\`;
			this.blendProgram = this.createAndLinkProgram(blendVertexShaderSource, blendFragmentShaderSource);
			this.blendLocations = {
				position: gl.getAttribLocation(this.blendProgram, "a_position"),
				texCoord: gl.getAttribLocation(this.blendProgram, "a_texCoord"),
				frameTexture: gl.getUniformLocation(this.blendProgram, "u_frameTexture"),
				currentStateTexture: gl.getUniformLocation(this.blendProgram, "u_currentStateTexture"),
				backgroundTexture: gl.getUniformLocation(this.blendProgram, "u_backgroundTexture"),
				bgImageDimensions: gl.getUniformLocation(this.blendProgram, "u_bgImageDimensions"),
				canvasDimensions: gl.getUniformLocation(this.blendProgram, "u_canvasDimensions"),
				borderSmooth: gl.getUniformLocation(this.blendProgram, "u_borderSmooth"),
				bgBlur: gl.getUniformLocation(this.blendProgram, "u_bgBlur"),
				bgBlurRadius: gl.getUniformLocation(this.blendProgram, "u_bgBlurRadius"),
				enabled: gl.getUniformLocation(this.blendProgram, "u_enabled")
			};
			this.positionBuffer = gl.createBuffer();
			gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
				-1,
				-1,
				1,
				-1,
				-1,
				1,
				-1,
				1,
				1,
				-1,
				1,
				1
			]), gl.STATIC_DRAW);
			this.texCoordBuffer = gl.createBuffer();
			gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
				0,
				1,
				1,
				1,
				0,
				0,
				0,
				0,
				1,
				1,
				1,
				0
			]), gl.STATIC_DRAW);
			this.storedStateTextures = Array.from({ length: 2 }, () => {
				const tex = gl.createTexture();
				gl.bindTexture(gl.TEXTURE_2D, tex);
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, new Uint8Array([
					0,
					0,
					0,
					255
				]));
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				return tex;
			});
			gl.bindTexture(gl.TEXTURE_2D, null);
			this.fbo = gl.createFramebuffer();
			this.refineFbo = gl.createFramebuffer();
			const refinedTex = gl.createTexture();
			this.frameTexture = gl.createTexture();
			if (!refinedTex) throw new Error("Failed to create refined mask texture");
			gl.bindTexture(gl.TEXTURE_2D, refinedTex);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.bindTexture(gl.TEXTURE_2D, null);
			this.refinedMaskTexture = refinedTex;
			const mkColorTex = () => {
				const t = gl.createTexture();
				if (!t) throw new Error("Failed to create blur texture");
				gl.bindTexture(gl.TEXTURE_2D, t);
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.bindTexture(gl.TEXTURE_2D, null);
				return t;
			};
			this.blurTexture1 = mkColorTex();
			this.blurTexture2 = mkColorTex();
			const mkFbo = (tex) => {
				const fb = gl.createFramebuffer();
				if (!fb || !tex) throw new Error("Failed to create blur FBO");
				gl.bindFramebuffer(gl.FRAMEBUFFER, fb);
				gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, tex, 0);
				gl.bindFramebuffer(gl.FRAMEBUFFER, null);
				return fb;
			};
			this.blurFbo1 = mkFbo(this.blurTexture1);
			this.blurFbo2 = mkFbo(this.blurTexture2);
			this.running = true;
		}
		createAndLinkProgram(vsSource, fsSource) {
			const vs = this.createShader(this.gl.VERTEX_SHADER, vsSource);
			const fs = this.createShader(this.gl.FRAGMENT_SHADER, fsSource);
			const prog = this.gl.createProgram();
			if (!prog) throw new Error("Failed to create program");
			this.gl.attachShader(prog, vs);
			this.gl.attachShader(prog, fs);
			this.gl.linkProgram(prog);
			if (!this.gl.getProgramParameter(prog, this.gl.LINK_STATUS)) {
				console.error("Program link error:", this.gl.getProgramInfoLog(prog));
				this.gl.deleteProgram(prog);
				throw new Error("Link fail");
			}
			this.gl.detachShader(prog, vs);
			this.gl.detachShader(prog, fs);
			this.gl.deleteShader(vs);
			this.gl.deleteShader(fs);
			return prog;
		}
		createShader(type, source) {
			const shader = this.gl.createShader(type);
			if (!shader) throw new Error(\`Failed to create shader type: \${type}\`);
			this.gl.shaderSource(shader, source);
			this.gl.compileShader(shader);
			if (!this.gl.getShaderParameter(shader, this.gl.COMPILE_STATUS)) {
				console.error("Shader compile error:", this.gl.getShaderInfoLog(shader));
				this.gl.deleteShader(shader);
				throw new Error("Failed to compile shader");
			}
			return shader;
		}
		createColorTexture(r, g, b, a) {
			const texture = this.gl.createTexture();
			if (!texture) throw new Error("Failed to create texture for color");
			this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
			const pixel = new Uint8Array([
				r,
				g,
				b,
				a
			]);
			this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, 1, 1, 0, this.gl.RGBA, this.gl.UNSIGNED_BYTE, pixel);
			this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.CLAMP_TO_EDGE);
			this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.CLAMP_TO_EDGE);
			this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.NEAREST);
			this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.NEAREST);
			this.gl.bindTexture(this.gl.TEXTURE_2D, null);
			return {
				texture,
				color: [
					r,
					g,
					b,
					a
				]
			};
		}
		updateBackgroundIfNeeded(newSource) {
			const gl = this.gl;
			let newIdentifier;
			if (!newSource) {
				const [r, g, b, a] = WebGLRenderer.DEFAULT_BG_COLOR;
				newIdentifier = \`color(\${r},\${g},\${b},\${a})\`;
			} else newIdentifier = newSource.url;
			if (newIdentifier === this.activeBackgroundSourceIdentifier && this.backgroundRenderInfo) return;
			if (this.backgroundRenderInfo) {
				gl.deleteTexture(this.backgroundRenderInfo.texture);
				this.backgroundRenderInfo = null;
			}
			this.activeBackgroundSourceIdentifier = newIdentifier;
			if (!newSource) {
				const [r, g, b, a] = WebGLRenderer.DEFAULT_BG_COLOR;
				const colorTexData = this.createColorTexture(r, g, b, a);
				this.backgroundRenderInfo = {
					type: "color",
					texture: colorTexData.texture,
					color: colorTexData.color
				};
				this.activeBackgroundSourceIdentifier = \`color(\${r},\${g},\${b},\${a})\`;
			} else if (newSource.type === "image") {
				const { media, url } = newSource;
				const texture = this.gl.createTexture();
				if (!texture) throw new Error("Failed to create texture object for image.");
				this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
				this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, this.gl.RGBA, this.gl.UNSIGNED_BYTE, media);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.CLAMP_TO_EDGE);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.CLAMP_TO_EDGE);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
				this.gl.bindTexture(this.gl.TEXTURE_2D, null);
				this.backgroundRenderInfo = {
					type: "image",
					texture,
					width: media.width,
					height: media.height,
					url
				};
			} else if (newSource.type === "video") {
				const { media, url } = newSource;
				const canvas = new OffscreenCanvas(1, 1);
				const ctx = canvas.getContext("2d");
				const writer = new WritableStream({
					write(videoFrame) {
						canvas.width = videoFrame.codedWidth;
						canvas.height = videoFrame.codedHeight;
						ctx?.drawImage(videoFrame, 0, 0);
						videoFrame.close();
					},
					close() {
						console.log("[virtual-background] video background close");
					}
				});
				media.pipeTo(writer).catch((err) => {
					console.error("media.pipeTo(writer) error", err);
				});
				const texture = this.gl.createTexture();
				if (!texture) throw new Error("Failed to create texture for video");
				this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
				this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, 1, 1, 0, this.gl.RGBA, this.gl.UNSIGNED_BYTE, null);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.CLAMP_TO_EDGE);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.CLAMP_TO_EDGE);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
				this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
				this.gl.bindTexture(this.gl.TEXTURE_2D, null);
				this.backgroundRenderInfo = {
					type: "video",
					texture,
					url,
					media,
					canvas
				};
			}
			if (!this.backgroundRenderInfo) {
				console.error("Critical: backgroundRenderInfo is null after processing new source. Setting default color.");
				const [r, g, b, a] = WebGLRenderer.DEFAULT_BG_COLOR;
				const colorTexData = this.createColorTexture(r, g, b, a);
				this.backgroundRenderInfo = {
					type: "color",
					texture: colorTexData.texture,
					color: colorTexData.color
				};
				this.activeBackgroundSourceIdentifier = \`color(\${r},\${g},\${b},\${a})\`;
			}
		}
		render(videoFrame, options, categoryTexture, confidenceTexture) {
			if (!this.running) return;
			const { gl, fbo, frameTexture, storedStateTextures, stateUpdateProgram, stateUpdateLocations, refineFbo, refinedMaskTexture, maskRefineProgram, maskRefineLocations, blendProgram, blendLocations, blurFbo1, blurFbo2, blurTexture1, blurTexture2 } = this;
			const { displayWidth: width, displayHeight: height } = videoFrame;
			if (this.canvas.width !== width || this.canvas.height !== height) {
				this.canvas.width = width;
				this.canvas.height = height;
			}
			if (!categoryTexture || !confidenceTexture) {
				gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
				gl.useProgram(blendProgram);
				const frame = gl.createTexture();
				gl.activeTexture(gl.TEXTURE0);
				gl.bindTexture(gl.TEXTURE_2D, frame);
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, videoFrame);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.uniform1i(blendLocations.frameTexture, 0);
				gl.uniform1i(blendLocations.enabled, 0);
				gl.enableVertexAttribArray(blendLocations.position);
				gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
				gl.vertexAttribPointer(blendLocations.position, 2, gl.FLOAT, false, 0, 0);
				gl.enableVertexAttribArray(blendLocations.texCoord);
				gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
				gl.vertexAttribPointer(blendLocations.texCoord, 2, gl.FLOAT, false, 0, 0);
				gl.drawArrays(gl.TRIANGLES, 0, 6);
				gl.deleteTexture(frame);
				gl.activeTexture(gl.TEXTURE0);
				gl.bindTexture(gl.TEXTURE_2D, null);
				return;
			}
			const readStateIndex = this.currentStateIndex;
			const writeStateIndex = (this.currentStateIndex + 1) % 2;
			const prevStateTexture = storedStateTextures[readStateIndex];
			const newStateTexture = storedStateTextures[writeStateIndex];
			this.updateBackgroundIfNeeded(options.backgroundSource);
			gl.bindFramebuffer(gl.FRAMEBUFFER, fbo);
			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, newStateTexture, 0);
			gl.bindTexture(gl.TEXTURE_2D, newStateTexture);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
			gl.viewport(0, 0, width, height);
			gl.useProgram(stateUpdateProgram);
			gl.activeTexture(gl.TEXTURE0);
			gl.bindTexture(gl.TEXTURE_2D, categoryTexture);
			gl.uniform1i(stateUpdateLocations.categoryTexture, 0);
			gl.activeTexture(gl.TEXTURE1);
			gl.bindTexture(gl.TEXTURE_2D, confidenceTexture);
			gl.uniform1i(stateUpdateLocations.confidenceTexture, 1);
			gl.activeTexture(gl.TEXTURE2);
			gl.bindTexture(gl.TEXTURE_2D, prevStateTexture);
			gl.uniform1i(stateUpdateLocations.prevStateTexture, 2);
			gl.uniform1f(stateUpdateLocations.smoothingFactor, options.segmentationOptions?.smoothingFactor ?? .8);
			gl.uniform1f(stateUpdateLocations.smoothstepMin, options.segmentationOptions?.smoothstepMin ?? .6);
			gl.uniform1f(stateUpdateLocations.smoothstepMax, options.segmentationOptions?.smoothstepMax ?? .9);
			gl.uniform1i(stateUpdateLocations.selfieModel, options.isSelfieMode ? 1 : 0);
			gl.enableVertexAttribArray(stateUpdateLocations.position);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
			gl.vertexAttribPointer(stateUpdateLocations.position, 2, gl.FLOAT, false, 0, 0);
			gl.enableVertexAttribArray(stateUpdateLocations.texCoord);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
			gl.vertexAttribPointer(stateUpdateLocations.texCoord, 2, gl.FLOAT, false, 0, 0);
			gl.drawArrays(gl.TRIANGLES, 0, 6);
			gl.bindFramebuffer(gl.FRAMEBUFFER, refineFbo);
			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, refinedMaskTexture, 0);
			gl.bindTexture(gl.TEXTURE_2D, refinedMaskTexture);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
			gl.viewport(0, 0, width, height);
			gl.useProgram(maskRefineProgram);
			gl.enableVertexAttribArray(maskRefineLocations.position);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
			gl.vertexAttribPointer(maskRefineLocations.position, 2, gl.FLOAT, false, 0, 0);
			gl.enableVertexAttribArray(maskRefineLocations.texCoord);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
			gl.vertexAttribPointer(maskRefineLocations.texCoord, 2, gl.FLOAT, false, 0, 0);
			gl.activeTexture(gl.TEXTURE0);
			gl.bindTexture(gl.TEXTURE_2D, newStateTexture);
			gl.uniform1i(maskRefineLocations.maskTexture, 0);
			gl.activeTexture(gl.TEXTURE1);
			gl.bindTexture(gl.TEXTURE_2D, frameTexture);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, videoFrame);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.uniform1i(maskRefineLocations.frameTexture, 1);
			gl.uniform2f(maskRefineLocations.texelSize, 1 / width, 1 / height);
			gl.uniform1f(maskRefineLocations.sigmaSpatial, 2);
			gl.uniform1f(maskRefineLocations.sigmaRange, .1);
			gl.drawArrays(gl.TRIANGLES, 0, 6);
			gl.disableVertexAttribArray(maskRefineLocations.position);
			gl.disableVertexAttribArray(maskRefineLocations.texCoord);
			let backgroundTexToUse;
			let bgWToSend = width;
			let bgHToSend = height;
			if (options.bgBlur > 0 && options.bgBlurRadius > 0) {
				const downscale = .5;
				const blurW = Math.floor(width * downscale);
				const blurH = Math.floor(height * downscale);
				gl.bindTexture(gl.TEXTURE_2D, blurTexture1);
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, blurW, blurH, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
				gl.bindTexture(gl.TEXTURE_2D, blurTexture2);
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, blurW, blurH, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
				const radiusScale = Math.max(0, options.bgBlurRadius) / 10;
				gl.useProgram(this.blurProgram);
				gl.enableVertexAttribArray(this.blurLocations.position);
				gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
				gl.vertexAttribPointer(this.blurLocations.position, 2, gl.FLOAT, false, 0, 0);
				gl.enableVertexAttribArray(this.blurLocations.texCoord);
				gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
				gl.vertexAttribPointer(this.blurLocations.texCoord, 2, gl.FLOAT, false, 0, 0);
				gl.activeTexture(gl.TEXTURE1);
				gl.bindTexture(gl.TEXTURE_2D, refinedMaskTexture);
				gl.uniform1i(this.blurLocations.personMask, 1);
				gl.uniform1f(this.blurLocations.sigma, options.bgBlur * .7);
				gl.uniform1f(this.blurLocations.radiusScale, radiusScale);
				const blurPasses = [
					{
						direction: [1, 0],
						input: frameTexture,
						output: blurFbo1,
						texelSize: [1 / width, 1 / height]
					},
					{
						direction: [0, 1],
						input: blurTexture1,
						output: blurFbo2,
						texelSize: [1 / blurW, 1 / blurH]
					},
					{
						direction: [1, 0],
						input: blurTexture2,
						output: blurFbo1,
						texelSize: [1 / blurW, 1 / blurH]
					},
					{
						direction: [0, 1],
						input: blurTexture1,
						output: blurFbo2,
						texelSize: [1 / blurW, 1 / blurH]
					}
				];
				for (const pass of blurPasses) {
					gl.bindFramebuffer(gl.FRAMEBUFFER, pass.output);
					gl.viewport(0, 0, blurW, blurH);
					gl.activeTexture(gl.TEXTURE0);
					gl.bindTexture(gl.TEXTURE_2D, pass.input);
					gl.uniform1i(this.blurLocations.image, 0);
					gl.uniform2f(this.blurLocations.texelSize, pass.texelSize[0], pass.texelSize[1]);
					gl.uniform2f(this.blurLocations.direction, pass.direction[0], pass.direction[1]);
					gl.drawArrays(gl.TRIANGLES, 0, 6);
				}
				backgroundTexToUse = blurTexture2;
				bgWToSend = blurW;
				bgHToSend = blurH;
			} else if (options.backgroundSource && this.backgroundRenderInfo) {
				backgroundTexToUse = this.backgroundRenderInfo.texture;
				if (this.backgroundRenderInfo.type === "video") {
					const { canvas } = this.backgroundRenderInfo;
					bgWToSend = canvas.width || width;
					bgHToSend = canvas.height || height;
				} else if (this.backgroundRenderInfo.type === "image") {
					bgWToSend = this.backgroundRenderInfo.width;
					bgHToSend = this.backgroundRenderInfo.height;
				} else {
					bgWToSend = width;
					bgHToSend = height;
				}
			} else backgroundTexToUse = this.backgroundRenderInfo?.texture ?? null;
			gl.bindFramebuffer(gl.FRAMEBUFFER, null);
			gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
			gl.useProgram(blendProgram);
			gl.activeTexture(gl.TEXTURE0);
			gl.bindTexture(gl.TEXTURE_2D, frameTexture);
			gl.uniform1i(blendLocations.frameTexture, 0);
			gl.uniform1f(blendLocations.borderSmooth, 0);
			gl.uniform1f(blendLocations.bgBlur, options.bgBlur);
			gl.uniform1f(blendLocations.bgBlurRadius, options.bgBlurRadius);
			gl.uniform1i(blendLocations.enabled, 1);
			gl.activeTexture(gl.TEXTURE1);
			gl.bindTexture(gl.TEXTURE_2D, refinedMaskTexture);
			gl.uniform1i(blendLocations.currentStateTexture, 1);
			if (backgroundTexToUse) {
				gl.activeTexture(gl.TEXTURE2);
				gl.bindTexture(gl.TEXTURE_2D, backgroundTexToUse);
				gl.uniform1i(blendLocations.backgroundTexture, 2);
				gl.uniform2f(blendLocations.bgImageDimensions, bgWToSend, bgHToSend);
				gl.uniform2f(blendLocations.canvasDimensions, width, height);
			} else {
				gl.uniform2f(blendLocations.bgImageDimensions, width, height);
				gl.uniform2f(blendLocations.canvasDimensions, width, height);
			}
			gl.enableVertexAttribArray(blendLocations.position);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
			gl.vertexAttribPointer(blendLocations.position, 2, gl.FLOAT, false, 0, 0);
			gl.enableVertexAttribArray(blendLocations.texCoord);
			gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
			gl.vertexAttribPointer(blendLocations.texCoord, 2, gl.FLOAT, false, 0, 0);
			gl.drawArrays(gl.TRIANGLES, 0, 6);
			for (let i = 0; i < 3; ++i) {
				gl.activeTexture(gl.TEXTURE0 + i);
				gl.bindTexture(gl.TEXTURE_2D, null);
			}
			this.currentStateIndex = writeStateIndex;
		}
		close() {
			if (!this.running) return;
			this.running = false;
			const { gl, fbo, refineFbo, refinedMaskTexture, blurFbo1, blurFbo2 } = this;
			gl.clearColor(0, 0, 0, 0);
			gl.clear(gl.COLOR_BUFFER_BIT);
			gl.bindFramebuffer(gl.FRAMEBUFFER, null);
			if (fbo) gl.deleteFramebuffer(fbo);
			if (refineFbo) gl.deleteFramebuffer(refineFbo);
			if (blurFbo1) gl.deleteFramebuffer(blurFbo1);
			if (blurFbo2) gl.deleteFramebuffer(blurFbo2);
			gl.deleteProgram(this.stateUpdateProgram);
			gl.deleteProgram(this.maskRefineProgram);
			gl.deleteProgram(this.blurProgram);
			gl.deleteProgram(this.blendProgram);
			if (this.positionBuffer) gl.deleteBuffer(this.positionBuffer);
			if (this.texCoordBuffer) gl.deleteBuffer(this.texCoordBuffer);
			if (refinedMaskTexture) gl.deleteTexture(refinedMaskTexture);
			if (this.blurTexture1) gl.deleteTexture(this.blurTexture1);
			if (this.blurTexture2) gl.deleteTexture(this.blurTexture2);
			this.storedStateTextures.forEach((t) => t && gl.deleteTexture(t));
			this.storedStateTextures.splice(0, this.storedStateTextures.length);
			if (this.backgroundRenderInfo?.texture) {
				gl.deleteTexture(this.backgroundRenderInfo.texture);
				this.backgroundRenderInfo = null;
			}
			this.activeBackgroundSourceIdentifier = null;
		}
	};
	//#endregion
	//#region src/FallbackGenerator.ts
	/**
	* Fallback video processor for browsers that do not support MediaStreamTrackGenerator.
	*
	* Produces a video MediaStreamTrack sourced from a canvas and exposes
	* a WritableStream<VideoFrame> on track.writable for writing frames.
	*/
	var FallbackGenerator = class {
		constructor({ kind, signalTarget }) {
			if (kind !== "video") throw new Error("Only video tracks are supported");
			const canvas = document.createElement("canvas");
			const ctx = canvas.getContext("2d", { desynchronized: true });
			if (!ctx) throw new Error("Failed to get 2D context from canvas");
			const track = canvas.captureStream().getVideoTracks()[0];
			const height = signalTarget?.getSettings().height;
			const width = signalTarget?.getSettings().width;
			if (height && width) {
				canvas.height = height;
				canvas.width = width;
			}
			if (!track) throw new Error("Failed to create canvas track");
			if (signalTarget) signalTarget.addEventListener("ended", () => {
				track.stop();
			});
			track.writable = new WritableStream({
				write: (frame) => {
					if (canvas.width !== frame.displayWidth || canvas.height !== frame.displayHeight) {
						canvas.width = frame.displayWidth;
						canvas.height = frame.displayHeight;
					}
					ctx.drawImage(frame, 0, 0, canvas.width, canvas.height);
					frame.close();
				},
				abort: () => {
					track.stop();
				},
				close: () => {
					track.stop();
				}
			});
			return track;
		}
	};
	/**
	* Adapts VideoTrackGenerator to the MediaStreamTrackGenerator shape.
	*/
	var SpecTrackGenerator = class {
		constructor({ signalTarget }) {
			const generator = new VideoTrackGenerator();
			const track = generator.track;
			track.writable = generator.writable;
			signalTarget?.addEventListener("ended", () => track.stop());
			return track;
		}
	};
	const TrackGenerator = typeof MediaStreamTrackGenerator !== "undefined" ? MediaStreamTrackGenerator : typeof VideoTrackGenerator !== "undefined" ? SpecTrackGenerator : FallbackGenerator;
	//#endregion
	//#region ../../node_modules/@stream-io/worker-timer/dist/worker.build.mjs
	var timerWorker = { src: \`const e=new Map;self.addEventListener("message",t=>{const s=t.data;switch(s.type){case"setTimeout":case"setInterval":e.set(s.id,("setTimeout"===s.type?setTimeout:setInterval)(()=>{!function(e){const t={type:"tick",id:e};self.postMessage(t)}(s.id),"setTimeout"===s.type&&e.delete(s.id)},s.timeout));break;case"clearTimeout":case"clearInterval":("clearTimeout"===s.type?clearTimeout:clearInterval)(e.get(s.id)),e.delete(s.id)}});\` };
	//#endregion
	//#region ../../node_modules/@stream-io/worker-timer/dist/index.mjs
	var WorkerTimer = class {
		currentTimerId = 1;
		callbacks = /* @__PURE__ */ new Map();
		worker;
		fallback = false;
		/**
		* Constructs a new instance of WorkerTimer.
		*
		* @param init the init parameters.
		*/
		constructor(init = {}) {
			this.setup(init);
		}
		setup = ({ useWorker = true, name = "@stream-io/worker-timer" } = {}) => {
			if (!useWorker) {
				this.fallback = true;
				return;
			}
			try {
				const source = timerWorker.src;
				const blob = new Blob([source], { type: "application/javascript; charset=utf-8" });
				const script = URL.createObjectURL(blob);
				this.worker = new Worker(script, { name });
				this.worker.addEventListener("message", (e) => {
					const { type, id } = e.data;
					if (type === "tick") this.callbacks.get(id)?.();
				});
			} catch (err) {
				console.error("Failed to create timer worker: ", err);
				this.fallback = true;
			}
		};
		destroy = () => {
			this.callbacks.clear();
			this.worker?.terminate();
			this.worker = void 0;
			this.fallback = false;
		};
		get ready() {
			return this.fallback || Boolean(this.worker);
		}
		setInterval = (callback, timeout) => this.setTimer("setInterval", callback, timeout);
		clearInterval = (id) => {
			this.clearTimer("clearInterval", id);
		};
		setTimeout = (callback, timeout) => this.setTimer("setTimeout", callback, timeout);
		clearTimeout = (id) => {
			this.clearTimer("clearTimeout", id);
		};
		setTimer = (type, callback, timeout) => {
			if (!this.ready) this.setup();
			if (this.fallback) return (type === "setTimeout" ? setTimeout : setInterval)(callback, timeout);
			const id = this.getTimerId();
			this.callbacks.set(id, () => {
				callback();
				if (type === "setTimeout") this.callbacks.delete(id);
			});
			this.sendMessage({
				type,
				id,
				timeout
			});
			return id;
		};
		clearTimer = (type, id) => {
			if (!id) return;
			if (!this.ready) this.setup();
			if (this.fallback) {
				(type === "clearTimeout" ? clearTimeout : clearInterval)(id);
				return;
			}
			this.callbacks.delete(id);
			this.sendMessage({
				type,
				id
			});
		};
		getTimerId = () => this.currentTimerId++;
		sendMessage = (message) => {
			if (!this.worker) throw new Error("Cannot use timer worker before it's set up");
			this.worker.postMessage(message);
		};
	};
	//#endregion
	//#region src/FallbackProcessor.ts
	/**
	* Fallback implementation for browsers without MediaStreamTrackGenerator.
	*
	* Produces a video MediaStreamTrack sourced from a canvas and exposes a
	* WritableStream<VideoFrame> on track.writable. Written frames are drawn
	* into the canvas and update the underlying track automatically.
	*/
	var FallbackProcessor = class {
		readable;
		workerTimer;
		video;
		constructor({ track }) {
			if (!track) throw new Error("MediaStreamTrack is required");
			if (track.kind !== "video") throw new Error("MediaStreamTrack must be video");
			let running = true;
			this.video = document.createElement("video");
			this.video.muted = true;
			this.video.playsInline = true;
			this.video.srcObject = new MediaStream([track]);
			const canvas = new OffscreenCanvas(1, 1);
			const ctx = canvas.getContext("2d");
			if (!ctx) throw new Error("Failed to get 2D context from OffscreenCanvas");
			let timestamp = 0;
			let frameDuration = 1e3 / (track.getSettings().frameRate || 30);
			this.workerTimer = new WorkerTimer({ useWorker: true });
			this.readable = new ReadableStream({
				start: async () => {
					await Promise.all([this.video.play(), new Promise((r) => this.video.addEventListener("loadeddata", r, { once: true }))]);
					frameDuration = 1e3 / (track.getSettings().frameRate || 30);
					timestamp = performance.now();
				},
				pull: async (controller) => {
					if (!running) {
						controller.close();
						this.close();
						return;
					}
					const delta = performance.now() - timestamp;
					if (delta <= frameDuration) await new Promise((r) => this.workerTimer.setTimeout(r, frameDuration - delta));
					timestamp = performance.now();
					if (canvas.width !== this.video.videoWidth || canvas.height !== this.video.videoHeight) {
						canvas.width = this.video.videoWidth;
						canvas.height = this.video.videoHeight;
					}
					ctx.drawImage(this.video, 0, 0);
					try {
						const frame = new VideoFrame(canvas, { timestamp: Math.round(this.video.currentTime * 1e6) });
						controller.enqueue(frame);
					} catch (err) {
						running = false;
						controller.error(err);
						this.close();
					}
				},
				cancel: () => {
					running = false;
					this.close();
				}
			});
		}
		close = () => {
			this.video.pause();
			this.video.srcObject = null;
			this.video.src = "";
			this.workerTimer.destroy();
		};
	};
	const TrackProcessor = typeof MediaStreamTrackProcessor !== "undefined" ? MediaStreamTrackProcessor : FallbackProcessor;
	//#endregion
	//#region src/BaseVideoProcessor.ts
	/**
	* Base class for real-time video filters.
	*
	* It sets up the full pipeline that reads frames from the input track,
	* processes them, and outputs a new track with your effect applied. Subclasses
	* only need to implement \`initialize\` (run once before processing starts) and
	* \`transform\` (called for every frame).
	*
	* Everything else\u2014canvas setup, performance tracking, error handling, and
	* clean shutdown is handled for you. Calling \`start()\` returns a processed
	* \`MediaStreamTrack\` ready to use.
	*/
	var BaseVideoProcessor = class {
		track;
		processor;
		generator;
		hooks;
		abortController = new AbortController();
		canvas;
		frames = 0;
		delayTotal = 0;
		lastStatsTime = 0;
		/**
		* Constructs a new instance.
		*/
		constructor(track, hooks = {}) {
			this.track = track;
			this.processor = new TrackProcessor({ track });
			this.generator = new TrackGenerator({
				kind: "video",
				signalTarget: track
			});
			this.hooks = hooks;
		}
		async start() {
			const { readable } = this.processor;
			const { writable } = this.generator;
			const { width = 1280, height = 720 } = this.track.getSettings();
			this.canvas = new OffscreenCanvas(width, height);
			await this.initialize();
			const transformStream = new TransformStream({
				transform: async (frame, controller) => {
					try {
						if (this.abortController.signal.aborted) return frame.close();
						if (this.canvas.width !== frame.displayWidth || this.canvas.height !== frame.displayHeight) {
							this.canvas.width = frame.displayWidth;
							this.canvas.height = frame.displayHeight;
						}
						const processed = await this.transform(frame);
						controller.enqueue(processed);
					} catch (e) {
						this.hooks.onError?.(e);
					} finally {
						frame.close();
					}
				},
				flush: () => this.onFlush()
			});
			readable.pipeThrough(transformStream, { signal: this.abortController.signal }).pipeTo(writable, { signal: this.abortController.signal }).catch((e) => {
				if (e.name !== "AbortError" && e.name !== "InvalidStateError") {
					console.error(\`[\${this.processorName}] Error processing track:\`, e);
					this.hooks.onError?.(e);
				}
			});
			return this.generator;
		}
		stop() {
			this.abortController.abort();
			this.generator.stop();
			this.onStop();
		}
		updateStats(delay) {
			this.frames++;
			this.delayTotal += delay;
			const now = performance.now();
			if (this.lastStatsTime === 0) {
				this.lastStatsTime = now;
				return;
			}
			if (now - this.lastStatsTime >= 1e3) {
				const avgDelay = Math.round(this.delayTotal / this.frames * 100) / 100;
				const fps = Math.round(1e3 * this.frames / (now - this.lastStatsTime));
				this.hooks.onStats?.({
					delay: avgDelay,
					fps,
					timestamp: now
				});
				this.frames = 0;
				this.delayTotal = 0;
				this.lastStatsTime = now;
			}
		}
		onFlush() {}
		onStop() {}
		get processorName() {
			return "base-processor";
		}
	};
	//#endregion
	//#region src/VirtualBackground.ts
	/**
	* Wraps a video MediaStreamTrack in a real-time processing pipeline.
	* Incoming frames are processed through a transformer and re-emitted
	* on a new MediaStreamVideoTrack for downstream consumption.
	*/
	var VirtualBackground = class extends BaseVideoProcessor {
		options;
		segmenter = null;
		isSegmenterReady = false;
		webGlRenderer;
		opts;
		latestCategoryMask = void 0;
		latestConfidenceMask = void 0;
		lastFrameTime = -1;
		constructor(track, options = {}, hooks = {}) {
			super(track, hooks);
			this.options = options;
		}
		async updateOptions(options) {
			const { basePath, modelPath } = this.options;
			const previous = this.options;
			const next = {
				basePath,
				modelPath,
				...options
			};
			this.options = next;
			try {
				const opts = await this.initializeSegmenterOptions();
				if (this.options === next) {
					const previousMedia = this.opts?.backgroundSource?.media;
					this.opts = opts;
					if (previousMedia instanceof ImageBitmap && previousMedia !== opts.backgroundSource?.media) previousMedia.close();
				}
			} catch (error) {
				if (this.options === next) this.options = previous;
				throw error;
			}
		}
		async initialize() {
			this.webGlRenderer = new WebGLRenderer(this.canvas);
			await this.initializeSegmenter();
		}
		async initializeSegmenter() {
			try {
				this.opts = await this.initializeSegmenterOptions();
				const basePath = this.options.basePath || \`https://unpkg.com/@stream-io/video-filters-web@1.0.0-beta.3/mediapipe\`;
				const model = this.options.modelPath || \`\${basePath}/models/selfie_segmenter_landscape.tflite\`;
				const fileset = await Zo.forVisionTasks(\`\${basePath}/wasm\`);
				this.segmenter = await Wc.createFromOptions(fileset, {
					baseOptions: {
						modelAssetPath: model,
						delegate: "GPU"
					},
					runningMode: "VIDEO",
					outputCategoryMask: true,
					outputConfidenceMasks: true,
					canvas: this.canvas
				});
				this.isSegmenterReady = true;
			} catch (error) {
				this.isSegmenterReady = false;
				this.hooks.onError?.(error);
				throw error;
			}
		}
		async transform(frame) {
			const currentTime = frame.timestamp;
			const hasNewFrame = currentTime - this.lastFrameTime > 1e3;
			this.lastFrameTime = currentTime;
			if (hasNewFrame && this.isSegmenterReady && this.segmenter) {
				const start = performance.now();
				await this.runSegmentation(frame);
				this.webGlRenderer.render(frame, this.opts, this.latestCategoryMask, this.latestConfidenceMask);
				this.updateStats(performance.now() - start);
			}
			return new VideoFrame(this.canvas, { timestamp: frame.timestamp });
		}
		async runSegmentation(frame) {
			if (!this.segmenter) return;
			return new Promise((resolve) => {
				const timestamp = Math.floor(performance.now());
				this.segmenter.segmentForVideo(frame, timestamp, (result) => {
					try {
						this.latestCategoryMask = result.categoryMask?.getAsWebGLTexture();
						this.latestConfidenceMask = result.confidenceMasks?.[0]?.getAsWebGLTexture();
					} catch (err) {
						console.error("[virtual-background] segmentation error:", err);
						this.hooks.onError?.(err);
					} finally {
						result.close();
						resolve();
					}
				});
			});
		}
		async initializeSegmenterOptions() {
			const isSelfieMode = this.options.modelPath ? this.options.modelPath.includes("selfie_segmenter") : true;
			if (this.options.backgroundFilter === "image") return {
				backgroundSource: await this.loadBackground(this.options.backgroundImage),
				bgBlur: 0,
				bgBlurRadius: 0,
				isSelfieMode,
				segmentationOptions: this.options.segmentationOptions
			};
			const blurLevel = this.options.backgroundBlurLevel;
			const strength = typeof blurLevel === "string" ? BACKGROUND_BLUR_MAP[blurLevel] : Math.round(blurLevel ?? 5);
			return {
				backgroundSource: void 0,
				bgBlur: Math.min(strength * 1.5, 20),
				bgBlurRadius: Math.min(strength, 10),
				isSelfieMode,
				segmentationOptions: this.options.segmentationOptions
			};
		}
		async loadBackground(url) {
			if (!url) return null;
			const current = this.opts?.backgroundSource;
			if (current?.url === url) return current;
			const result = await fetch(url, { signal: this.abortController.signal });
			if (!result.ok) throw new Error(\`[virtual-background] Failed to load background image: \${result.status} \${result.statusText}\`);
			return {
				type: "image",
				media: await createImageBitmap(await result.blob()),
				url
			};
		}
		onFlush() {
			this.destroySegmenter();
		}
		onStop() {
			this.webGlRenderer?.close();
			this.destroySegmenter();
		}
		destroySegmenter() {
			this.segmenter?.close();
			this.segmenter = null;
			this.isSegmenterReady = false;
		}
		get processorName() {
			return "background-processor";
		}
	};
	//#endregion
	//#region src/worker/worker.ts
	/**
	* Worker entry for the background effect. It runs as a classic worker
	* because tasks-vision loads its WASM with importScripts(). Safari exposes
	* MediaStreamTrackProcessor and VideoTrackGenerator inside workers,
	* so the regular VirtualBackground pipeline runs here unchanged.
	*/
	const messageOf = (error) => error instanceof Error ? error.message : String(error);
	const scope = self;
	const post = (message, transfer = []) => scope.postMessage(message, transfer);
	const hasTrackApis = () => typeof MediaStreamTrackProcessor !== "undefined" && typeof self.VideoTrackGenerator !== "undefined";
	let processor;
	let input;
	scope.onmessage = async (e) => {
		const message = e.data;
		switch (message.type) {
			case "start":
				input = message.track;
				if (!hasTrackApis()) {
					input.stop();
					post({
						type: "error",
						message: "MediaStreamTrackProcessor/VideoTrackGenerator unavailable in workers"
					});
					break;
				}
				try {
					processor = new VirtualBackground(input, message.options, {
						onStats: (stats) => post({
							type: "stats",
							stats
						}),
						onError: (error) => post({
							type: "error",
							message: messageOf(error)
						})
					});
					const output = await processor.start();
					post({
						type: "started",
						track: output
					}, [output]);
				} catch (error) {
					post({
						type: "error",
						message: messageOf(error)
					});
				}
				break;
			case "update": {
				const { id } = message;
				(processor?.updateOptions(message.options) ?? Promise.resolve()).then(() => post({
					type: "updated",
					id
				}), (error) => post({
					type: "updateError",
					id,
					message: messageOf(error)
				}));
				break;
			}
			case "stop":
				processor?.stop();
				input?.stop();
				processor = void 0;
				input = void 0;
				post({ type: "stopped" });
		}
	};
	//#endregion
})();

//# sourceMappingURL=worker-CTRz85NB.js.map`,dc=typeof self<"u"&&self.Blob&&new Blob(["(self.URL || self.webkitURL).revokeObjectURL(self.location.href);",fc],{type:"text/javascript;charset=utf-8"})});var wc=()=>/Mobi/i.test(navigator.userAgent),Ac=()=>/^((?!chrome|android).)*safari/i.test(navigator.userAgent),Rc=async({forceMobileSupport:t=!1,forceSafariSupport:n=!1}={})=>typeof document<"u"&&typeof window<"u"&&typeof navigator<"u"&&(t||!wc())&&(n||!Ac())&&typeof WebAssembly<"u"&&typeof OffscreenCanvas<"u"&&!!window.WebGL2RenderingContext&&!!new OffscreenCanvas(1,1).getContext("webgl2")&&typeof VideoFrame<"u"&&typeof createImageBitmap<"u";var zi="1.0.0-beta.3",Ki="@stream-io/video-filters-web";var $i="",Tr,kc=async(t={})=>{let{basePath:n=`https://unpkg.com/${Ki}@${zi}/mediapipe`,modelPath:e=`${n}/models/selfie_segmenter_landscape.tflite`}=t,r=e===$i&&Tr?Tr:await fetch(e).then(o=>o.arrayBuffer());return Tr=r,$i=e,r};var _r={low:3,medium:5,high:7};var Sc=class{constructor({kind:t,signalTarget:n}){if(t!=="video")throw new Error("Only video tracks are supported");let e=document.createElement("canvas"),r=e.getContext("2d",{desynchronized:!0});if(!r)throw new Error("Failed to get 2D context from canvas");let o=e.captureStream().getVideoTracks()[0],i=n?.getSettings().height,s=n?.getSettings().width;if(i&&s&&(e.height=i,e.width=s),!o)throw new Error("Failed to create canvas track");return n&&n.addEventListener("ended",()=>{o.stop()}),o.writable=new WritableStream({write:a=>{(e.width!==a.displayWidth||e.height!==a.displayHeight)&&(e.width=a.displayWidth,e.height=a.displayHeight),r.drawImage(a,0,0,e.width,e.height),a.close()},abort:()=>{o.stop()},close:()=>{o.stop()}}),o}},Lc=class{constructor({signalTarget:t}){let n=new VideoTrackGenerator,e=n.track;return e.writable=n.writable,t?.addEventListener("ended",()=>e.stop()),e}},qi=typeof MediaStreamTrackGenerator<"u"?MediaStreamTrackGenerator:typeof VideoTrackGenerator<"u"?Lc:Sc;var Qi={src:'const e=new Map;self.addEventListener("message",t=>{const s=t.data;switch(s.type){case"setTimeout":case"setInterval":e.set(s.id,("setTimeout"===s.type?setTimeout:setInterval)(()=>{!function(e){const t={type:"tick",id:e};self.postMessage(t)}(s.id),"setTimeout"===s.type&&e.delete(s.id)},s.timeout));break;case"clearTimeout":case"clearInterval":("clearTimeout"===s.type?clearTimeout:clearInterval)(e.get(s.id)),e.delete(s.id)}});'};var Zi=class{currentTimerId=1;callbacks=new Map;worker;fallback=!1;constructor(t={}){this.setup(t)}setup=({useWorker:t=!0,name:n="@stream-io/worker-timer"}={})=>{if(!t){this.fallback=!0;return}try{let e=Qi.src,r=new Blob([e],{type:"application/javascript; charset=utf-8"}),o=URL.createObjectURL(r);this.worker=new Worker(o,{name:n}),this.worker.addEventListener("message",i=>{let{type:s,id:a}=i.data;s==="tick"&&this.callbacks.get(a)?.()})}catch(e){console.error("Failed to create timer worker: ",e),this.fallback=!0}};destroy=()=>{this.callbacks.clear(),this.worker?.terminate(),this.worker=void 0,this.fallback=!1};get ready(){return this.fallback||!!this.worker}setInterval=(t,n)=>this.setTimer("setInterval",t,n);clearInterval=t=>{this.clearTimer("clearInterval",t)};setTimeout=(t,n)=>this.setTimer("setTimeout",t,n);clearTimeout=t=>{this.clearTimer("clearTimeout",t)};setTimer=(t,n,e)=>{if(this.ready||this.setup(),this.fallback)return(t==="setTimeout"?setTimeout:setInterval)(n,e);let r=this.getTimerId();return this.callbacks.set(r,()=>{n(),t==="setTimeout"&&this.callbacks.delete(r)}),this.sendMessage({type:t,id:r,timeout:e}),r};clearTimer=(t,n)=>{if(n){if(this.ready||this.setup(),this.fallback){(t==="clearTimeout"?clearTimeout:clearInterval)(n);return}this.callbacks.delete(n),this.sendMessage({type:t,id:n})}};getTimerId=()=>this.currentTimerId++;sendMessage=t=>{if(!this.worker)throw new Error("Cannot use timer worker before it's set up");this.worker.postMessage(t)}};var Uc=class{readable;workerTimer;video;constructor({track:t}){if(!t)throw new Error("MediaStreamTrack is required");if(t.kind!=="video")throw new Error("MediaStreamTrack must be video");let n=!0;this.video=document.createElement("video"),this.video.muted=!0,this.video.playsInline=!0,this.video.srcObject=new MediaStream([t]);let e=new OffscreenCanvas(1,1),r=e.getContext("2d");if(!r)throw new Error("Failed to get 2D context from OffscreenCanvas");let o=0,i=1e3/(t.getSettings().frameRate||30);this.workerTimer=new Zi({useWorker:!0}),this.readable=new ReadableStream({start:async()=>{await Promise.all([this.video.play(),new Promise(s=>this.video.addEventListener("loadeddata",s,{once:!0}))]),i=1e3/(t.getSettings().frameRate||30),o=performance.now()},pull:async s=>{if(!n){s.close(),this.close();return}let a=performance.now()-o;a<=i&&await new Promise(c=>this.workerTimer.setTimeout(c,i-a)),o=performance.now(),(e.width!==this.video.videoWidth||e.height!==this.video.videoHeight)&&(e.width=this.video.videoWidth,e.height=this.video.videoHeight),r.drawImage(this.video,0,0);try{let c=new VideoFrame(e,{timestamp:Math.round(this.video.currentTime*1e6)});s.enqueue(c)}catch(c){n=!1,s.error(c),this.close()}},cancel:()=>{n=!1,this.close()}})}close=()=>{this.video.pause(),this.video.srcObject=null,this.video.src="",this.workerTimer.destroy()}},Ji=typeof MediaStreamTrackProcessor<"u"?MediaStreamTrackProcessor:Uc;var ee=class{track;processor;generator;hooks;abortController=new AbortController;canvas;frames=0;delayTotal=0;lastStatsTime=0;constructor(t,n={}){this.track=t,this.processor=new Ji({track:t}),this.generator=new qi({kind:"video",signalTarget:t}),this.hooks=n}async start(){let{readable:t}=this.processor,{writable:n}=this.generator,{width:e=1280,height:r=720}=this.track.getSettings();this.canvas=new OffscreenCanvas(e,r),await this.initialize();let o=new TransformStream({transform:async(i,s)=>{try{if(this.abortController.signal.aborted)return i.close();(this.canvas.width!==i.displayWidth||this.canvas.height!==i.displayHeight)&&(this.canvas.width=i.displayWidth,this.canvas.height=i.displayHeight);let a=await this.transform(i);s.enqueue(a)}catch(a){this.hooks.onError?.(a)}finally{i.close()}},flush:()=>this.onFlush()});return t.pipeThrough(o,{signal:this.abortController.signal}).pipeTo(n,{signal:this.abortController.signal}).catch(i=>{i.name!=="AbortError"&&i.name!=="InvalidStateError"&&(console.error(`[${this.processorName}] Error processing track:`,i),this.hooks.onError?.(i))}),this.generator}stop(){this.abortController.abort(),this.generator.stop(),this.onStop()}updateStats(t){this.frames++,this.delayTotal+=t;let n=performance.now();if(this.lastStatsTime===0){this.lastStatsTime=n;return}if(n-this.lastStatsTime>=1e3){let e=Math.round(this.delayTotal/this.frames*100)/100,r=Math.round(1e3*this.frames/(n-this.lastStatsTime));this.hooks.onStats?.({delay:e,fps:r,timestamp:n}),this.frames=0,this.delayTotal=0,this.lastStatsTime=n}}onFlush(){}onStop(){}get processorName(){return"base-processor"}};var to=class Re{canvas;gl;stateUpdateProgram;maskRefineProgram;blurProgram;blendProgram;stateUpdateLocations;maskRefineLocations;blurLocations;blendLocations;positionBuffer;texCoordBuffer;storedStateTextures;fbo;refineFbo;refinedMaskTexture;frameTexture;blurTexture1;blurTexture2;blurFbo1;blurFbo2;running=!1;static DEFAULT_BG_COLOR=[33,150,243,255];currentStateIndex=0;backgroundRenderInfo=null;activeBackgroundSourceIdentifier=null;constructor(n){this.canvas=n;let e=this.canvas.getContext("webgl2",{alpha:!1,antialias:!1,desynchronized:!0});if(!e)throw new Error("WebGL2 not supported");this.gl=e;let r="attribute vec2 a_position; attribute vec2 a_texCoord; varying vec2 v_texCoord; void main() { gl_Position = vec4(a_position, 0.0, 1.0); v_texCoord = a_texCoord; }",o=`
      precision mediump float;
      varying vec2 v_texCoord;
      uniform sampler2D u_categoryTexture;
      uniform sampler2D u_confidenceTexture;
      uniform sampler2D u_prevStateTexture;
      uniform float u_smoothingFactor;
      uniform float u_smoothstepMin;
      uniform float u_smoothstepMax;
      uniform int u_selfieModel;

      void main() {
        vec2 prevCoord = vec2(v_texCoord.x, 1.0 - v_texCoord.y);
        float categoryValue = texture2D(u_categoryTexture, v_texCoord).r;
        float confidenceValue = texture2D(u_confidenceTexture, v_texCoord).r;

        if (u_selfieModel == 1) {
            categoryValue = 1.0 - categoryValue;
            confidenceValue = 1.0 - confidenceValue;
        }

        if (categoryValue > 0.0) {
            categoryValue = 1.0;
            confidenceValue = 1.0 - confidenceValue;
        }

        float nonLinearConfidence = smoothstep(u_smoothstepMin, u_smoothstepMax, confidenceValue);
        float prevCategoryValue = texture2D(u_prevStateTexture, prevCoord).r;
        float alpha = u_smoothingFactor * nonLinearConfidence;
        float newCategoryValue = alpha * categoryValue + (1.0 - alpha) * prevCategoryValue;

        gl_FragColor = vec4(newCategoryValue, 0.0, 0.0, 0.0);
      }
    `;this.stateUpdateProgram=this.createAndLinkProgram(r,o),this.stateUpdateLocations={position:e.getAttribLocation(this.stateUpdateProgram,"a_position"),texCoord:e.getAttribLocation(this.stateUpdateProgram,"a_texCoord"),categoryTexture:e.getUniformLocation(this.stateUpdateProgram,"u_categoryTexture"),confidenceTexture:e.getUniformLocation(this.stateUpdateProgram,"u_confidenceTexture"),prevStateTexture:e.getUniformLocation(this.stateUpdateProgram,"u_prevStateTexture"),smoothingFactor:e.getUniformLocation(this.stateUpdateProgram,"u_smoothingFactor"),smoothstepMin:e.getUniformLocation(this.stateUpdateProgram,"u_smoothstepMin"),smoothstepMax:e.getUniformLocation(this.stateUpdateProgram,"u_smoothstepMax"),selfieModel:e.getUniformLocation(this.stateUpdateProgram,"u_selfieModel")};let i=r,s=`
      precision mediump float;
      varying vec2 v_texCoord;

      uniform sampler2D u_maskTexture;
      uniform sampler2D u_frameTexture;
      uniform vec2 u_texelSize;
      uniform float u_sigmaSpatial;
      uniform float u_sigmaRange;

      void main() {
        vec2 flippedCoord = v_texCoord;
        vec3 centerPixelColor = texture2D(u_frameTexture, v_texCoord).rgb;
        float totalWeight = 0.0;
        float weightedMaskSum = 0.0;

        for (int offsetX = -2; offsetX <= 2; offsetX++) {
          for (int offsetY = -2; offsetY <= 2; offsetY++) {
            vec2 shift = vec2(float(offsetX), float(offsetY)) * u_texelSize;
            vec2 frameCoord = v_texCoord + shift;
            vec2 maskCoord = flippedCoord + shift;

            vec3 neighborPixelColor = texture2D(u_frameTexture, frameCoord).rgb;
            float neighborMaskValue = texture2D(u_maskTexture, maskCoord).r;

            float spatialWeight = exp(-dot(shift, shift) / (2.0 * u_sigmaSpatial * u_sigmaSpatial));
            vec3 colorDifference = neighborPixelColor - centerPixelColor;
            float rangeWeight = exp(-(dot(colorDifference, colorDifference)) / (2.0 * u_sigmaRange * u_sigmaRange));

            float combinedWeight = spatialWeight * rangeWeight;
            weightedMaskSum += neighborMaskValue * combinedWeight;
            totalWeight += combinedWeight;
          }
        }

        float refinedMaskValue = weightedMaskSum / max(totalWeight, 1e-6);
        gl_FragColor = vec4(refinedMaskValue, refinedMaskValue, refinedMaskValue, 1.0);
      }
    `;this.maskRefineProgram=this.createAndLinkProgram(i,s),this.maskRefineLocations={position:e.getAttribLocation(this.maskRefineProgram,"a_position"),texCoord:e.getAttribLocation(this.maskRefineProgram,"a_texCoord"),maskTexture:e.getUniformLocation(this.maskRefineProgram,"u_maskTexture"),frameTexture:e.getUniformLocation(this.maskRefineProgram,"u_frameTexture"),texelSize:e.getUniformLocation(this.maskRefineProgram,"u_texelSize"),sigmaSpatial:e.getUniformLocation(this.maskRefineProgram,"u_sigmaSpatial"),sigmaRange:e.getUniformLocation(this.maskRefineProgram,"u_sigmaRange")};let a=r,c=`
      precision highp float;
      varying vec2 v_texCoord;

      uniform sampler2D u_image;
      uniform sampler2D u_personMask;
      uniform vec2 u_texelSize;
      uniform float u_sigma;
      uniform float u_radiusScale;
      uniform vec2 u_direction;

      const int KERNEL_RADIUS = 10;

      float gauss(float x, float s) {
        return exp(-(x * x) / (2.0 * s * s));
      }

      void main() {
        vec2 maskCoord = u_direction.y > 0.5 ? vec2(v_texCoord.x, 1.0 - v_texCoord.y) : v_texCoord;
        float mCenter = texture2D(u_personMask, maskCoord).r;
        float wCenter = gauss(0.0, u_sigma);
        vec4 accum = texture2D(u_image, v_texCoord) * wCenter * (1.0 - mCenter);
        float weightSum = wCenter * (1.0 - mCenter);

        for (int i = 1; i <= KERNEL_RADIUS; i++) {
          float f = float(i);
          float offset = f * u_radiusScale;
          float w = gauss(offset, u_sigma);
          vec2 texOffset = u_direction * offset * u_texelSize;

          vec2 uvPlus = v_texCoord + texOffset;
          vec2 maskCoordPlus = u_direction.y > 0.5 ? vec2(uvPlus.x, 1.0 - uvPlus.y) : uvPlus;
          float mPlus = texture2D(u_personMask, maskCoordPlus).r;
          accum += texture2D(u_image, uvPlus) * w * (1.0 - mPlus);
          weightSum += w * (1.0 - mPlus);

          vec2 uvMinus = v_texCoord - texOffset;
          vec2 maskCoordMinus = u_direction.y > 0.5 ? vec2(uvMinus.x, 1.0 - uvMinus.y) : uvMinus;
          float mMinus = texture2D(u_personMask, maskCoordMinus).r;
          accum += texture2D(u_image, uvMinus) * w * (1.0 - mMinus);
          weightSum += w * (1.0 - mMinus);
        }

        vec4 blurred = accum / max(weightSum, 1e-6);
        gl_FragColor = blurred;
      }
    `;this.blurProgram=this.createAndLinkProgram(a,c),this.blurLocations={position:e.getAttribLocation(this.blurProgram,"a_position"),texCoord:e.getAttribLocation(this.blurProgram,"a_texCoord"),image:e.getUniformLocation(this.blurProgram,"u_image"),personMask:e.getUniformLocation(this.blurProgram,"u_personMask"),texelSize:e.getUniformLocation(this.blurProgram,"u_texelSize"),sigma:e.getUniformLocation(this.blurProgram,"u_sigma"),radiusScale:e.getUniformLocation(this.blurProgram,"u_radiusScale"),direction:e.getUniformLocation(this.blurProgram,"u_direction")};let l=r,u=`
      precision mediump float;
      varying vec2 v_texCoord;

      uniform sampler2D u_frameTexture;
      uniform sampler2D u_currentStateTexture;
      uniform sampler2D u_backgroundTexture;
      uniform vec2 u_bgImageDimensions;
      uniform vec2 u_canvasDimensions;
      uniform float u_borderSmooth;
      uniform float u_bgBlur;
      uniform float u_bgBlurRadius;
      uniform int u_enabled;

      vec4 getMixedFragColor(vec2 bgTexCoord, vec2 categoryCoord, vec2 offset) {
          vec4 backgroundColor = texture2D(u_backgroundTexture, bgTexCoord + offset);
          vec4 frameColor = texture2D(u_frameTexture, v_texCoord + offset);
          float categoryValue = texture2D(u_currentStateTexture, categoryCoord + offset).r;
          return mix(backgroundColor, frameColor, categoryValue);
      }

      void main() {
        if (u_enabled == 0) {
          gl_FragColor = texture2D(u_frameTexture, v_texCoord);
          return;
        }

        vec2 categoryCoord = v_texCoord;
        float categoryValue = texture2D(u_currentStateTexture, categoryCoord).r;

        float canvasAspect = u_canvasDimensions.x / u_canvasDimensions.y;
          float bgAspect = u_bgImageDimensions.x / u_bgImageDimensions.y;

          vec2 bgTexCoord = v_texCoord;
          float scaleX = 1.0;
          float scaleY = 1.0;
          float offsetX = 0.0;
          float offsetY = 0.0;

          if (canvasAspect < bgAspect) {
              scaleY = 1.0;
              scaleX = bgAspect / canvasAspect;
              offsetX = (1.0 - scaleX) / 2.0;
          } else {
              scaleX = 1.0;
              scaleY = canvasAspect / bgAspect;
              offsetY = (1.0 - scaleY) / 2.0;
          }

          bgTexCoord = vec2((v_texCoord.x - offsetX) / scaleX, (v_texCoord.y - offsetY) / scaleY);
          gl_FragColor = getMixedFragColor(bgTexCoord, categoryCoord, vec2(0.0, 0.0));
    }`;this.blendProgram=this.createAndLinkProgram(l,u),this.blendLocations={position:e.getAttribLocation(this.blendProgram,"a_position"),texCoord:e.getAttribLocation(this.blendProgram,"a_texCoord"),frameTexture:e.getUniformLocation(this.blendProgram,"u_frameTexture"),currentStateTexture:e.getUniformLocation(this.blendProgram,"u_currentStateTexture"),backgroundTexture:e.getUniformLocation(this.blendProgram,"u_backgroundTexture"),bgImageDimensions:e.getUniformLocation(this.blendProgram,"u_bgImageDimensions"),canvasDimensions:e.getUniformLocation(this.blendProgram,"u_canvasDimensions"),borderSmooth:e.getUniformLocation(this.blendProgram,"u_borderSmooth"),bgBlur:e.getUniformLocation(this.blendProgram,"u_bgBlur"),bgBlurRadius:e.getUniformLocation(this.blendProgram,"u_bgBlurRadius"),enabled:e.getUniformLocation(this.blendProgram,"u_enabled")},this.positionBuffer=e.createBuffer(),e.bindBuffer(e.ARRAY_BUFFER,this.positionBuffer),e.bufferData(e.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1]),e.STATIC_DRAW),this.texCoordBuffer=e.createBuffer(),e.bindBuffer(e.ARRAY_BUFFER,this.texCoordBuffer),e.bufferData(e.ARRAY_BUFFER,new Float32Array([0,1,1,1,0,0,0,0,1,1,1,0]),e.STATIC_DRAW),this.storedStateTextures=Array.from({length:2},()=>{let _=e.createTexture();return e.bindTexture(e.TEXTURE_2D,_),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,1,1,0,e.RGBA,e.UNSIGNED_BYTE,new Uint8Array([0,0,0,255])),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MIN_FILTER,e.LINEAR),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MAG_FILTER,e.LINEAR),_}),e.bindTexture(e.TEXTURE_2D,null),this.fbo=e.createFramebuffer(),this.refineFbo=e.createFramebuffer();let p=e.createTexture();if(this.frameTexture=e.createTexture(),!p)throw new Error("Failed to create refined mask texture");e.bindTexture(e.TEXTURE_2D,p),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,1,1,0,e.RGBA,e.UNSIGNED_BYTE,null),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MIN_FILTER,e.LINEAR),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MAG_FILTER,e.LINEAR),e.bindTexture(e.TEXTURE_2D,null),this.refinedMaskTexture=p;let h=()=>{let _=e.createTexture();if(!_)throw new Error("Failed to create blur texture");return e.bindTexture(e.TEXTURE_2D,_),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,1,1,0,e.RGBA,e.UNSIGNED_BYTE,null),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MIN_FILTER,e.LINEAR),e.texParameteri(e.TEXTURE_2D,e.TEXTURE_MAG_FILTER,e.LINEAR),e.bindTexture(e.TEXTURE_2D,null),_};this.blurTexture1=h(),this.blurTexture2=h();let v=_=>{let Y=e.createFramebuffer();if(!Y||!_)throw new Error("Failed to create blur FBO");return e.bindFramebuffer(e.FRAMEBUFFER,Y),e.framebufferTexture2D(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.TEXTURE_2D,_,0),e.bindFramebuffer(e.FRAMEBUFFER,null),Y};this.blurFbo1=v(this.blurTexture1),this.blurFbo2=v(this.blurTexture2),this.running=!0}createAndLinkProgram(n,e){let r=this.createShader(this.gl.VERTEX_SHADER,n),o=this.createShader(this.gl.FRAGMENT_SHADER,e),i=this.gl.createProgram();if(!i)throw new Error("Failed to create program");if(this.gl.attachShader(i,r),this.gl.attachShader(i,o),this.gl.linkProgram(i),!this.gl.getProgramParameter(i,this.gl.LINK_STATUS))throw console.error("Program link error:",this.gl.getProgramInfoLog(i)),this.gl.deleteProgram(i),new Error("Link fail");return this.gl.detachShader(i,r),this.gl.detachShader(i,o),this.gl.deleteShader(r),this.gl.deleteShader(o),i}createShader(n,e){let r=this.gl.createShader(n);if(!r)throw new Error(`Failed to create shader type: ${n}`);if(this.gl.shaderSource(r,e),this.gl.compileShader(r),!this.gl.getShaderParameter(r,this.gl.COMPILE_STATUS))throw console.error("Shader compile error:",this.gl.getShaderInfoLog(r)),this.gl.deleteShader(r),new Error("Failed to compile shader");return r}createColorTexture(n,e,r,o){let i=this.gl.createTexture();if(!i)throw new Error("Failed to create texture for color");this.gl.bindTexture(this.gl.TEXTURE_2D,i);let s=new Uint8Array([n,e,r,o]);return this.gl.texImage2D(this.gl.TEXTURE_2D,0,this.gl.RGBA,1,1,0,this.gl.RGBA,this.gl.UNSIGNED_BYTE,s),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_S,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_T,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MIN_FILTER,this.gl.NEAREST),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MAG_FILTER,this.gl.NEAREST),this.gl.bindTexture(this.gl.TEXTURE_2D,null),{texture:i,color:[n,e,r,o]}}updateBackgroundIfNeeded(n){let e=this.gl,r;if(n)r=n.url;else{let[o,i,s,a]=Re.DEFAULT_BG_COLOR;r=`color(${o},${i},${s},${a})`}if(!(r===this.activeBackgroundSourceIdentifier&&this.backgroundRenderInfo)){if(this.backgroundRenderInfo&&(e.deleteTexture(this.backgroundRenderInfo.texture),this.backgroundRenderInfo=null),this.activeBackgroundSourceIdentifier=r,n){if(n.type==="image"){let{media:o,url:i}=n,s=this.gl.createTexture();if(!s)throw new Error("Failed to create texture object for image.");this.gl.bindTexture(this.gl.TEXTURE_2D,s),this.gl.texImage2D(this.gl.TEXTURE_2D,0,this.gl.RGBA,this.gl.RGBA,this.gl.UNSIGNED_BYTE,o),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_S,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_T,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MIN_FILTER,this.gl.LINEAR),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MAG_FILTER,this.gl.LINEAR),this.gl.bindTexture(this.gl.TEXTURE_2D,null),this.backgroundRenderInfo={type:"image",texture:s,width:o.width,height:o.height,url:i}}else if(n.type==="video"){let{media:o,url:i}=n,s=new OffscreenCanvas(1,1),a=s.getContext("2d"),c=new WritableStream({write(u){s.width=u.codedWidth,s.height=u.codedHeight,a?.drawImage(u,0,0),u.close()},close(){console.log("[virtual-background] video background close")}});o.pipeTo(c).catch(u=>{console.error("media.pipeTo(writer) error",u)});let l=this.gl.createTexture();if(!l)throw new Error("Failed to create texture for video");this.gl.bindTexture(this.gl.TEXTURE_2D,l),this.gl.texImage2D(this.gl.TEXTURE_2D,0,this.gl.RGBA,1,1,0,this.gl.RGBA,this.gl.UNSIGNED_BYTE,null),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_S,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_WRAP_T,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MIN_FILTER,this.gl.LINEAR),this.gl.texParameteri(this.gl.TEXTURE_2D,this.gl.TEXTURE_MAG_FILTER,this.gl.LINEAR),this.gl.bindTexture(this.gl.TEXTURE_2D,null),this.backgroundRenderInfo={type:"video",texture:l,url:i,media:o,canvas:s}}}else{let[o,i,s,a]=Re.DEFAULT_BG_COLOR,c=this.createColorTexture(o,i,s,a);this.backgroundRenderInfo={type:"color",texture:c.texture,color:c.color},this.activeBackgroundSourceIdentifier=`color(${o},${i},${s},${a})`}if(!this.backgroundRenderInfo){console.error("Critical: backgroundRenderInfo is null after processing new source. Setting default color.");let[o,i,s,a]=Re.DEFAULT_BG_COLOR,c=this.createColorTexture(o,i,s,a);this.backgroundRenderInfo={type:"color",texture:c.texture,color:c.color},this.activeBackgroundSourceIdentifier=`color(${o},${i},${s},${a})`}}}render(n,e,r,o){if(!this.running)return;let{gl:i,fbo:s,frameTexture:a,storedStateTextures:c,stateUpdateProgram:l,stateUpdateLocations:u,refineFbo:p,refinedMaskTexture:h,maskRefineProgram:v,maskRefineLocations:_,blendProgram:Y,blendLocations:A,blurFbo1:st,blurFbo2:Gt,blurTexture1:zt,blurTexture2:Kt}=this,{displayWidth:nt,displayHeight:et}=n;if((this.canvas.width!==nt||this.canvas.height!==et)&&(this.canvas.width=nt,this.canvas.height=et),!r||!o){i.viewport(0,0,i.drawingBufferWidth,i.drawingBufferHeight),i.useProgram(Y);let St=i.createTexture();i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,St),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,i.RGBA,i.UNSIGNED_BYTE,n),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_S,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_T,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MIN_FILTER,i.NEAREST),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MAG_FILTER,i.NEAREST),i.uniform1i(A.frameTexture,0),i.uniform1i(A.enabled,0),i.enableVertexAttribArray(A.position),i.bindBuffer(i.ARRAY_BUFFER,this.positionBuffer),i.vertexAttribPointer(A.position,2,i.FLOAT,!1,0,0),i.enableVertexAttribArray(A.texCoord),i.bindBuffer(i.ARRAY_BUFFER,this.texCoordBuffer),i.vertexAttribPointer(A.texCoord,2,i.FLOAT,!1,0,0),i.drawArrays(i.TRIANGLES,0,6),i.deleteTexture(St),i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,null);return}let Tc=this.currentStateIndex,Yi=(this.currentStateIndex+1)%2,_c=c[Tc],pr=c[Yi];this.updateBackgroundIfNeeded(e.backgroundSource),i.bindFramebuffer(i.FRAMEBUFFER,s),i.framebufferTexture2D(i.FRAMEBUFFER,i.COLOR_ATTACHMENT0,i.TEXTURE_2D,pr,0),i.bindTexture(i.TEXTURE_2D,pr),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,nt,et,0,i.RGBA,i.UNSIGNED_BYTE,null),i.viewport(0,0,nt,et),i.useProgram(l),i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,r),i.uniform1i(u.categoryTexture,0),i.activeTexture(i.TEXTURE1),i.bindTexture(i.TEXTURE_2D,o),i.uniform1i(u.confidenceTexture,1),i.activeTexture(i.TEXTURE2),i.bindTexture(i.TEXTURE_2D,_c),i.uniform1i(u.prevStateTexture,2),i.uniform1f(u.smoothingFactor,e.segmentationOptions?.smoothingFactor??.8),i.uniform1f(u.smoothstepMin,e.segmentationOptions?.smoothstepMin??.6),i.uniform1f(u.smoothstepMax,e.segmentationOptions?.smoothstepMax??.9),i.uniform1i(u.selfieModel,e.isSelfieMode?1:0),i.enableVertexAttribArray(u.position),i.bindBuffer(i.ARRAY_BUFFER,this.positionBuffer),i.vertexAttribPointer(u.position,2,i.FLOAT,!1,0,0),i.enableVertexAttribArray(u.texCoord),i.bindBuffer(i.ARRAY_BUFFER,this.texCoordBuffer),i.vertexAttribPointer(u.texCoord,2,i.FLOAT,!1,0,0),i.drawArrays(i.TRIANGLES,0,6),i.bindFramebuffer(i.FRAMEBUFFER,p),i.framebufferTexture2D(i.FRAMEBUFFER,i.COLOR_ATTACHMENT0,i.TEXTURE_2D,h,0),i.bindTexture(i.TEXTURE_2D,h),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,nt,et,0,i.RGBA,i.UNSIGNED_BYTE,null),i.viewport(0,0,nt,et),i.useProgram(v),i.enableVertexAttribArray(_.position),i.bindBuffer(i.ARRAY_BUFFER,this.positionBuffer),i.vertexAttribPointer(_.position,2,i.FLOAT,!1,0,0),i.enableVertexAttribArray(_.texCoord),i.bindBuffer(i.ARRAY_BUFFER,this.texCoordBuffer),i.vertexAttribPointer(_.texCoord,2,i.FLOAT,!1,0,0),i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,pr),i.uniform1i(_.maskTexture,0),i.activeTexture(i.TEXTURE1),i.bindTexture(i.TEXTURE_2D,a),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,i.RGBA,i.UNSIGNED_BYTE,n),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_S,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_WRAP_T,i.CLAMP_TO_EDGE),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MIN_FILTER,i.NEAREST),i.texParameteri(i.TEXTURE_2D,i.TEXTURE_MAG_FILTER,i.NEAREST),i.uniform1i(_.frameTexture,1),i.uniform2f(_.texelSize,1/nt,1/et),i.uniform1f(_.sigmaSpatial,2),i.uniform1f(_.sigmaRange,.1),i.drawArrays(i.TRIANGLES,0,6),i.disableVertexAttribArray(_.position),i.disableVertexAttribArray(_.texCoord);let Jn,te=nt,ne=et;if(e.bgBlur>0&&e.bgBlurRadius>0){let rn=Math.floor(nt*.5),on=Math.floor(et*.5);i.bindTexture(i.TEXTURE_2D,zt),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,rn,on,0,i.RGBA,i.UNSIGNED_BYTE,null),i.bindTexture(i.TEXTURE_2D,Kt),i.texImage2D(i.TEXTURE_2D,0,i.RGBA,rn,on,0,i.RGBA,i.UNSIGNED_BYTE,null);let Ec=Math.max(0,e.bgBlurRadius)/10;i.useProgram(this.blurProgram),i.enableVertexAttribArray(this.blurLocations.position),i.bindBuffer(i.ARRAY_BUFFER,this.positionBuffer),i.vertexAttribPointer(this.blurLocations.position,2,i.FLOAT,!1,0,0),i.enableVertexAttribArray(this.blurLocations.texCoord),i.bindBuffer(i.ARRAY_BUFFER,this.texCoordBuffer),i.vertexAttribPointer(this.blurLocations.texCoord,2,i.FLOAT,!1,0,0),i.activeTexture(i.TEXTURE1),i.bindTexture(i.TEXTURE_2D,h),i.uniform1i(this.blurLocations.personMask,1),i.uniform1f(this.blurLocations.sigma,e.bgBlur*.7),i.uniform1f(this.blurLocations.radiusScale,Ec);let vc=[{direction:[1,0],input:a,output:st,texelSize:[1/nt,1/et]},{direction:[0,1],input:zt,output:Gt,texelSize:[1/rn,1/on]},{direction:[1,0],input:Kt,output:st,texelSize:[1/rn,1/on]},{direction:[0,1],input:zt,output:Gt,texelSize:[1/rn,1/on]}];for(let bn of vc)i.bindFramebuffer(i.FRAMEBUFFER,bn.output),i.viewport(0,0,rn,on),i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,bn.input),i.uniform1i(this.blurLocations.image,0),i.uniform2f(this.blurLocations.texelSize,bn.texelSize[0],bn.texelSize[1]),i.uniform2f(this.blurLocations.direction,bn.direction[0],bn.direction[1]),i.drawArrays(i.TRIANGLES,0,6);Jn=Kt,te=rn,ne=on}else if(e.backgroundSource&&this.backgroundRenderInfo)if(Jn=this.backgroundRenderInfo.texture,this.backgroundRenderInfo.type==="video"){let{canvas:St}=this.backgroundRenderInfo;te=St.width||nt,ne=St.height||et}else this.backgroundRenderInfo.type==="image"?(te=this.backgroundRenderInfo.width,ne=this.backgroundRenderInfo.height):(te=nt,ne=et);else Jn=this.backgroundRenderInfo?.texture??null;i.bindFramebuffer(i.FRAMEBUFFER,null),i.viewport(0,0,i.drawingBufferWidth,i.drawingBufferHeight),i.useProgram(Y),i.activeTexture(i.TEXTURE0),i.bindTexture(i.TEXTURE_2D,a),i.uniform1i(A.frameTexture,0),i.uniform1f(A.borderSmooth,0),i.uniform1f(A.bgBlur,e.bgBlur),i.uniform1f(A.bgBlurRadius,e.bgBlurRadius),i.uniform1i(A.enabled,1),i.activeTexture(i.TEXTURE1),i.bindTexture(i.TEXTURE_2D,h),i.uniform1i(A.currentStateTexture,1),Jn?(i.activeTexture(i.TEXTURE2),i.bindTexture(i.TEXTURE_2D,Jn),i.uniform1i(A.backgroundTexture,2),i.uniform2f(A.bgImageDimensions,te,ne),i.uniform2f(A.canvasDimensions,nt,et)):(i.uniform2f(A.bgImageDimensions,nt,et),i.uniform2f(A.canvasDimensions,nt,et)),i.enableVertexAttribArray(A.position),i.bindBuffer(i.ARRAY_BUFFER,this.positionBuffer),i.vertexAttribPointer(A.position,2,i.FLOAT,!1,0,0),i.enableVertexAttribArray(A.texCoord),i.bindBuffer(i.ARRAY_BUFFER,this.texCoordBuffer),i.vertexAttribPointer(A.texCoord,2,i.FLOAT,!1,0,0),i.drawArrays(i.TRIANGLES,0,6);for(let St=0;St<3;++St)i.activeTexture(i.TEXTURE0+St),i.bindTexture(i.TEXTURE_2D,null);this.currentStateIndex=Yi}close(){if(!this.running)return;this.running=!1;let{gl:n,fbo:e,refineFbo:r,refinedMaskTexture:o,blurFbo1:i,blurFbo2:s}=this;n.clearColor(0,0,0,0),n.clear(n.COLOR_BUFFER_BIT),n.bindFramebuffer(n.FRAMEBUFFER,null),e&&n.deleteFramebuffer(e),r&&n.deleteFramebuffer(r),i&&n.deleteFramebuffer(i),s&&n.deleteFramebuffer(s),n.deleteProgram(this.stateUpdateProgram),n.deleteProgram(this.maskRefineProgram),n.deleteProgram(this.blurProgram),n.deleteProgram(this.blendProgram),this.positionBuffer&&n.deleteBuffer(this.positionBuffer),this.texCoordBuffer&&n.deleteBuffer(this.texCoordBuffer),o&&n.deleteTexture(o),this.blurTexture1&&n.deleteTexture(this.blurTexture1),this.blurTexture2&&n.deleteTexture(this.blurTexture2),this.storedStateTextures.forEach(a=>a&&n.deleteTexture(a)),this.storedStateTextures.splice(0,this.storedStateTextures.length),this.backgroundRenderInfo?.texture&&(n.deleteTexture(this.backgroundRenderInfo.texture),this.backgroundRenderInfo=null),this.activeBackgroundSourceIdentifier=null}};var kn=typeof self<"u"?self:{};function hs(t,n){t:{for(var e=["CLOSURE_FLAGS"],r=kn,o=0;o<e.length;o++)if((r=r[e[o]])==null){e=null;break t}e=r}return(t=e&&e[t])!=null?t:n}function sn(){throw Error("Invalid UTF8")}function no(t,n){return n=String.fromCharCode.apply(null,n),t==null?n:t+n}var ke,Er,Fc=typeof TextDecoder<"u",Pc,Ic=typeof TextEncoder<"u";function ls(t){if(Ic)t=(Pc||=new TextEncoder).encode(t);else{let e=0,r=new Uint8Array(3*t.length);for(let o=0;o<t.length;o++){var n=t.charCodeAt(o);if(n<128)r[e++]=n;else{if(n<2048)r[e++]=n>>6|192;else{if(n>=55296&&n<=57343){if(n<=56319&&o<t.length){let i=t.charCodeAt(++o);if(i>=56320&&i<=57343){n=1024*(n-55296)+i-56320+65536,r[e++]=n>>18|240,r[e++]=n>>12&63|128,r[e++]=n>>6&63|128,r[e++]=63&n|128;continue}o--}n=65533}r[e++]=n>>12|224,r[e++]=n>>6&63|128}r[e++]=63&n|128}}t=e===r.length?r:r.subarray(0,e)}return t}function ds(t){kn.setTimeout((()=>{throw t}),0)}var Sr,Cc=hs(610401301,!1),eo=hs(748402147,!0);function ro(){var t=kn.navigator;return t&&(t=t.userAgent)?t:""}var io=kn.navigator;function He(t){return He[" "](t),t}Sr=io&&io.userAgentData||null,He[" "]=function(){};var fs={},oe=null;function Dc(t){let n=t.length,e=3*n/4;e%3?e=Math.floor(e):"=.".indexOf(t[n-1])!=-1&&(e="=.".indexOf(t[n-2])!=-1?e-2:e-1);let r=new Uint8Array(e),o=0;return(function(i,s){function a(l){for(;c<i.length;){let u=i.charAt(c++),p=oe[u];if(p!=null)return p;if(!/^[\s\xa0]*$/.test(u))throw Error("Unknown base64 encoding at char: "+u)}return l}gs();let c=0;for(;;){let l=a(-1),u=a(0),p=a(64),h=a(64);if(h===64&&l===-1)break;s(l<<2|u>>4),p!=64&&(s(u<<4&240|p>>2),h!=64&&s(p<<6&192|h))}})(t,(function(i){r[o++]=i})),o!==e?r.subarray(0,o):r}function gs(){if(!oe){oe={};var t="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".split(""),n=["+/=","+/","-_=","-_.","-_"];for(let e=0;e<5;e++){let r=t.concat(n[e].split(""));fs[e]=r;for(let o=0;o<r.length;o++){let i=r[o];oe[i]===void 0&&(oe[i]=o)}}}}var Mc=typeof Uint8Array<"u",ms=!(!(Cc&&Sr&&Sr.brands.length>0)&&(ro().indexOf("Trident")!=-1||ro().indexOf("MSIE")!=-1))&&typeof btoa=="function",oo=/[-_.]/g,Bc={"-":"+",_:"/",".":"="};function Nc(t){return Bc[t]||""}function ps(t){if(!ms)return Dc(t);t=oo.test(t)?t.replace(oo,Nc):t,t=atob(t);let n=new Uint8Array(t.length);for(let e=0;e<t.length;e++)n[e]=t.charCodeAt(e);return n}function Kr(t){return Mc&&t!=null&&t instanceof Uint8Array}var Sn={};function mn(){return Oc||=new It(null,Sn)}function $r(t){Ts(Sn);var n=t.g;return(n=n==null||Kr(n)?n:typeof n=="string"?ps(n):null)==null?n:t.g=n}var It=class{h(){return new Uint8Array($r(this)||0)}constructor(t,n){if(Ts(n),this.g=t,t!=null&&t.length===0)throw Error("ByteString should be constructed with non-empty values")}},Oc,Gc;function Ts(t){if(t!==Sn)throw Error("illegal external caller")}function _s(t,n){t.__closure__error__context__984382||(t.__closure__error__context__984382={}),t.__closure__error__context__984382.severity=n}function Lr(t){return _s(t=Error(t),"warning"),t}function Ln(t,n){if(t!=null){var e=Gc??={},r=e[t]||0;r>=n||(e[t]=r+1,_s(t=Error(),"incident"),ds(t))}}function On(){return typeof BigInt=="function"}var Gn=typeof Symbol=="function"&&typeof Symbol()=="symbol";function Dt(t,n,e=!1){return typeof Symbol=="function"&&typeof Symbol()=="symbol"?e&&Symbol.for&&t?Symbol.for(t):t!=null?Symbol(t):Symbol():n}var Xc=Dt("jas",void 0,!0),so=Dt(void 0,"0di"),re=Dt(void 0,"1oa"),lt=Dt(void 0,Symbol()),Vc=Dt(void 0,"0ub"),Wc=Dt(void 0,"0ubs"),Ur=Dt(void 0,"0ubsb"),jc=Dt(void 0,"0actk"),Un=Dt("m_m","Pa",!0),ao=Dt(),Es={Ga:{value:0,configurable:!0,writable:!0,enumerable:!1}},vs=Object.defineProperties,f=Gn?Xc:"Ga",_n,co=[];function Te(t,n){Gn||f in t||vs(t,Es),t[f]|=n}function H(t,n){Gn||f in t||vs(t,Es),t[f]=n}function _e(t){return Te(t,34),t}function de(t){return Te(t,8192),t}H(co,7),_n=Object.freeze(co);var Fn={};function ft(t,n){return n===void 0?t.h!==pn&&!!(2&(0|t.v[f])):!!(2&n)&&t.h!==pn}var pn={};function qr(t,n){if(t!=null){if(typeof t=="string")t=t?new It(t,Sn):mn();else if(t.constructor!==It)if(Kr(t))t=t.length?new It(new Uint8Array(t),Sn):mn();else{if(!n)throw Error();t=void 0}}return t}var Be=class{constructor(n,e,r){this.g=n,this.h=e,this.l=r}next(){let n=this.g.next();return n.done||(n.value=this.h.call(this.l,n.value)),n}[Symbol.iterator](){return this}},Hc=Object.freeze({});function bs(t,n,e){let r=128&n?0:-1,o=t.length;var i;(i=!!o)&&(i=(i=t[o-1])!=null&&typeof i=="object"&&i.constructor===Object);let s=o+(i?-1:0);for(n=128&n?1:0;n<s;n++)e(n-r,t[n]);if(i){t=t[o-1];for(let a in t)!isNaN(a)&&e(+a,t[a])}}var ys={};function Xn(t){return 128&t?ys:void 0}function Ye(t){return t.Na=!0,t}var Yc=Ye((t=>typeof t=="number")),uo=Ye((t=>typeof t=="string")),zc=Ye((t=>typeof t=="boolean")),ze=typeof kn.BigInt=="function"&&typeof kn.BigInt(0)=="bigint";function dt(t){var n=t;if(uo(n)){if(!/^\s*(?:-?[1-9]\d*|0)?\s*$/.test(n))throw Error(String(n))}else if(Yc(n)&&!Number.isSafeInteger(n))throw Error(String(n));return ze?BigInt(t):t=zc(t)?t?"1":"0":uo(t)?t.trim()||"0":String(t)}var Fr=Ye((t=>ze?t>=$c&&t<=Qc:t[0]==="-"?ho(t,Kc):ho(t,qc))),Kc=Number.MIN_SAFE_INTEGER.toString(),$c=ze?BigInt(Number.MIN_SAFE_INTEGER):void 0,qc=Number.MAX_SAFE_INTEGER.toString(),Qc=ze?BigInt(Number.MAX_SAFE_INTEGER):void 0;function ho(t,n){if(t.length>n.length)return!1;if(t.length<n.length||t===n)return!0;for(let e=0;e<t.length;e++){let r=t[e],o=n[e];if(r>o)return!1;if(r<o)return!0}}var Zc=typeof Uint8Array.prototype.slice=="function",Jc,F=0,N=0;function lo(t){let n=t>>>0;F=n,N=(t-n)/4294967296>>>0}function Pn(t){if(t<0){lo(-t);let[n,e]=Jr(F,N);F=n>>>0,N=e>>>0}else lo(t)}function Qr(t){let n=Jc||=new DataView(new ArrayBuffer(8));n.setFloat32(0,+t,!0),N=0,F=n.getUint32(0,!0)}function xs(t,n){let e=4294967296*n+(t>>>0);return Number.isSafeInteger(e)?e:fe(t,n)}function tu(t,n){return dt(On()?BigInt.asUintN(64,(BigInt(n>>>0)<<BigInt(32))+BigInt(t>>>0)):fe(t,n))}function ws(t,n){return On()?dt(BigInt.asIntN(64,(BigInt.asUintN(32,BigInt(n))<<BigInt(32))+BigInt.asUintN(32,BigInt(t)))):dt(Zr(t,n))}function fe(t,n){if(t>>>=0,(n>>>=0)<=2097151)var e=""+(4294967296*n+t);else On()?e=""+(BigInt(n)<<BigInt(32)|BigInt(t)):(t=(16777215&t)+6777216*(e=16777215&(t>>>24|n<<8))+6710656*(n=n>>16&65535),e+=8147497*n,n*=2,t>=1e7&&(e+=t/1e7>>>0,t%=1e7),e>=1e7&&(n+=e/1e7>>>0,e%=1e7),e=n+fo(e)+fo(t));return e}function fo(t){return t=String(t),"0000000".slice(t.length)+t}function Zr(t,n){if(2147483648&n)if(On())t=""+(BigInt(0|n)<<BigInt(32)|BigInt(t>>>0));else{let[e,r]=Jr(t,n);t="-"+fe(e,r)}else t=fe(t,n);return t}function Ke(t){if(t.length<16)Pn(Number(t));else if(On())t=BigInt(t),F=Number(t&BigInt(4294967295))>>>0,N=Number(t>>BigInt(32)&BigInt(4294967295));else{let n=+(t[0]==="-");N=F=0;let e=t.length;for(let r=n,o=(e-n)%6+n;o<=e;r=o,o+=6){let i=Number(t.slice(r,o));N*=1e6,F=1e6*F+i,F>=4294967296&&(N+=Math.trunc(F/4294967296),N>>>=0,F>>>=0)}if(n){let[r,o]=Jr(F,N);F=r,N=o}}}function Jr(t,n){return n=~n,t?t=1+~t:n+=1,[t,n]}function wt(t){return Array.prototype.slice.call(t)}var Ee=typeof BigInt=="function"?BigInt.asIntN:void 0,nu=typeof BigInt=="function"?BigInt.asUintN:void 0,Tn=Number.isSafeInteger,$e=Number.isFinite,In=Math.trunc,eu=dt(0);function se(t){if(t!=null&&typeof t!="number")throw Error(`Value of float/double field must be a number, found ${typeof t}: ${t}`);return t}function Pt(t){return t==null||typeof t=="number"?t:t==="NaN"||t==="Infinity"||t==="-Infinity"?Number(t):void 0}function ge(t){if(t!=null&&typeof t!="boolean"){var n=typeof t;throw Error(`Expected boolean but got ${n!="object"?n:t?Array.isArray(t)?"array":n:"null"}: ${t}`)}return t}function As(t){return t==null||typeof t=="boolean"?t:typeof t=="number"?!!t:void 0}var ru=/^-?([1-9][0-9]*|0)(\.[0-9]+)?$/;function ve(t){switch(typeof t){case"bigint":return!0;case"number":return $e(t);case"string":return ru.test(t);default:return!1}}function Vn(t){if(t==null)return t;if(typeof t=="string"&&t)t=+t;else if(typeof t!="number")return;return $e(t)?0|t:void 0}function Rs(t){if(t==null)return t;if(typeof t=="string"&&t)t=+t;else if(typeof t!="number")return;return $e(t)?t>>>0:void 0}function ks(t){let n=t.length;return(t[0]==="-"?n<20||n===20&&t<="-9223372036854775808":n<19||n===19&&t<="9223372036854775807")?t:(Ke(t),Zr(F,N))}function ti(t){if(t=In(t),!Tn(t)){Pn(t);var n=F,e=N;(t=2147483648&e)&&(e=~e>>>0,(n=1+~n>>>0)==0&&(e=e+1>>>0)),t=typeof(n=xs(n,e))=="number"?t?-n:n:t?"-"+n:n}return t}function Ss(t){var n=In(Number(t));return Tn(n)?String(n):((n=t.indexOf("."))!==-1&&(t=t.substring(0,n)),ks(t))}function Ls(t){var n=In(Number(t));return Tn(n)?dt(n):((n=t.indexOf("."))!==-1&&(t=t.substring(0,n)),On()?dt(Ee(64,BigInt(t))):dt(ks(t)))}function Us(t){return Tn(t)?t=dt(ti(t)):(t=In(t),Tn(t)?t=String(t):(Pn(t),t=Zr(F,N)),t=dt(t)),t}function Ne(t){let n=typeof t;return t==null?t:n==="bigint"?dt(Ee(64,t)):ve(t)?n==="string"?Ls(t):Us(t):void 0}function Fs(t){if(typeof t!="string")throw Error();return t}function be(t){if(t!=null&&typeof t!="string")throw Error();return t}function $(t){return t==null||typeof t=="string"?t:void 0}function ni(t,n,e,r){return t!=null&&t[Un]===Fn?t:Array.isArray(t)?((r=(e=0|t[f])|32&r|2&r)!==e&&H(t,r),new n(t)):(e?2&r?((t=n[so])||(_e((t=new n).v),t=n[so]=t),n=t):n=new n:n=void 0,n)}function iu(t,n,e){if(n)t:{if(!ve(n=t))throw Lr("int64");switch(typeof n){case"string":n=Ls(n);break t;case"bigint":n=dt(Ee(64,n));break t;default:n=Us(n)}}else n=Ne(t);return(t=n)==null?e?eu:void 0:t}var ou={},su=(function(){try{return He(new class extends Map{constructor(){super()}}),!1}catch{return!0}})(),ce=class{constructor(){this.g=new Map}get(n){return this.g.get(n)}set(n,e){return this.g.set(n,e),this.size=this.g.size,this}delete(n){return n=this.g.delete(n),this.size=this.g.size,n}clear(){this.g.clear(),this.size=this.g.size}has(n){return this.g.has(n)}entries(){return this.g.entries()}keys(){return this.g.keys()}values(){return this.g.values()}forEach(n,e){return this.g.forEach(n,e)}[Symbol.iterator](){return this.entries()}},au=su?(Object.setPrototypeOf(ce.prototype,Map.prototype),Object.defineProperties(ce.prototype,{size:{value:0,configurable:!0,enumerable:!0,writable:!0}}),ce):class extends Map{constructor(){super()}};function go(t){return t}function vr(t){if(2&t.J)throw Error("Cannot mutate an immutable Map")}var Wt=class extends au{constructor(t,n,e=go,r=go){super(),this.J=0|t[f],this.K=n,this.S=e,this.fa=this.K?cu:r;for(let o=0;o<t.length;o++){let i=t[o],s=e(i[0],!1,!0),a=i[1];n?a===void 0&&(a=null):a=r(i[1],!1,!0,void 0,void 0,this.J),super.set(s,a)}}V(t){return de(Array.from(super.entries(),t))}clear(){vr(this),super.clear()}delete(t){return vr(this),super.delete(this.S(t,!0,!1))}entries(){if(this.K){var t=super.keys();t=new Be(t,uu,this)}else t=super.entries();return t}values(){if(this.K){var t=super.keys();t=new Be(t,Wt.prototype.get,this)}else t=super.values();return t}forEach(t,n){this.K?super.forEach(((e,r,o)=>{t.call(n,o.get(r),r,o)})):super.forEach(t,n)}set(t,n){return vr(this),(t=this.S(t,!0,!1))==null?this:n==null?(super.delete(t),this):super.set(t,this.fa(n,!0,!0,this.K,!1,this.J))}Ma(t){let n=this.S(t[0],!1,!0);t=t[1],t=this.K?t===void 0?null:t:this.fa(t,!1,!0,void 0,!1,this.J),super.set(n,t)}has(t){return super.has(this.S(t,!1,!1))}get(t){t=this.S(t,!1,!1);let n=super.get(t);if(n!==void 0){var e=this.K;return e?((e=this.fa(n,!1,!0,e,this.ra,this.J))!==n&&super.set(t,e),e):n}}[Symbol.iterator](){return this.entries()}};function cu(t,n,e,r,o,i){return t=ni(t,r,e,i),o&&(t=ri(t)),t}function uu(t){return[t,this.get(t)]}var hu;function mo(){return hu||=new Wt(_e([]),void 0,void 0,void 0,ou)}function qe(t){return lt?t[lt]:void 0}function Oe(t,n){for(let e in t)!isNaN(e)&&n(t,+e,t[e])}Wt.prototype.toJSON=void 0;var Pr=class{},lu={Ka:!0};function du(t,n){n<100||Ln(Wc,1)}function Qe(t,n,e,r){let o=r!==void 0;r=!!r;var i,s=lt;!o&&Gn&&s&&(i=t[s])&&Oe(i,du),s=[];var a=t.length;let c;i=4294967295;let l=!1,u=!!(64&n),p=u?128&n?0:-1:void 0;1&n||(c=a&&t[a-1],c!=null&&typeof c=="object"&&c.constructor===Object?i=--a:c=void 0,!u||128&n||o||(l=!0,i=i-p+p)),n=void 0;for(var h=0;h<a;h++){let v=t[h];if(v!=null&&(v=e(v,r))!=null)if(u&&h>=i){let _=h-p;(n??={})[_]=v}else s[h]=v}if(c)for(let v in c){if((a=c[v])==null||(a=e(a,r))==null)continue;let _;h=+v,u&&!Number.isNaN(h)&&(_=h+p)<i?s[_]=a:(n??={})[v]=a}return n&&(l?s.push(n):s[i]=n),o&&lt&&(t=qe(t))&&t instanceof Pr&&(s[lt]=(function(v){let _=new Pr;return Oe(v,((Y,A,st)=>{_[A]=wt(st)})),_.da=v.da,_})(t)),s}function fu(t){return t[0]=me(t[0]),t[1]=me(t[1]),t}function me(t){switch(typeof t){case"number":return Number.isFinite(t)?t:""+t;case"bigint":return Fr(t)?Number(t):""+t;case"boolean":return t?1:0;case"object":if(Array.isArray(t)){var n=0|t[f];return t.length===0&&1&n?void 0:Qe(t,n,me)}if(t!=null&&t[Un]===Fn)return Ps(t);if(t instanceof It){if((n=t.g)==null)t="";else if(typeof n=="string")t=n;else{if(ms){for(var e="",r=0,o=n.length-10240;r<o;)e+=String.fromCharCode.apply(null,n.subarray(r,r+=10240));e+=String.fromCharCode.apply(null,r?n.subarray(r):n),n=btoa(e)}else{e===void 0&&(e=0),gs(),e=fs[e],r=Array(Math.floor(n.length/3)),o=e[64]||"";let l=0,u=0;for(;l<n.length-2;l+=3){var i=n[l],s=n[l+1],a=n[l+2],c=e[i>>2];i=e[(3&i)<<4|s>>4],s=e[(15&s)<<2|a>>6],a=e[63&a],r[u++]=c+i+s+a}switch(c=0,a=o,n.length-l){case 2:a=e[(15&(c=n[l+1]))<<2]||o;case 1:n=n[l],r[u]=e[n>>2]+e[(3&n)<<4|c>>4]+a+o}n=r.join("")}t=t.g=n}return t}return t instanceof Wt?t=t.size!==0?t.V(fu):void 0:void 0}return t}var gu,mu;function Ps(t){return Qe(t=t.v,0|t[f],me)}function hn(t,n){return Is(t,n[0],n[1])}function Is(t,n,e,r=0){if(t==null){var o=32;e?(t=[e],o|=128):t=[],n&&(o=-16760833&o|(1023&n)<<14)}else{if(!Array.isArray(t))throw Error("narr");if(o=0|t[f],eo&&1&o)throw Error("rfarr");if(2048&o&&!(2&o)&&(function(){if(eo)throw Error("carr");Ln(jc,5)})(),256&o)throw Error("farr");if(64&o)return(o|r)!==o&&H(t,o|r),t;if(e&&(o|=128,e!==t[0]))throw Error("mid");t:{o|=64;var i=(e=t).length;if(i){var s=i-1;let c=e[s];if(c!=null&&typeof c=="object"&&c.constructor===Object){if((s-=n=128&o?0:-1)>=1024)throw Error("pvtlmt");for(var a in c)(i=+a)<s&&(e[i+n]=c[a],delete c[a]);o=-16760833&o|(1023&s)<<14;break t}}if(n){if((a=Math.max(n,i-(128&o?0:-1)))>1024)throw Error("spvt");o=-16760833&o|(1023&a)<<14}}}return H(t,64|o|r),t}function pu(t,n){if(typeof t!="object")return t;if(Array.isArray(t)){var e=0|t[f];return t.length===0&&1&e?void 0:po(t,e,n)}if(t!=null&&t[Un]===Fn)return To(t);if(t instanceof Wt){if(2&(n=t.J))return t;if(!t.size)return;if(e=_e(t.V()),t.K)for(t=0;t<e.length;t++){let r=e[t],o=r[1];o=o==null||typeof o!="object"?void 0:o!=null&&o[Un]===Fn?To(o):Array.isArray(o)?po(o,0|o[f],!!(32&n)):void 0,r[1]=o}return e}return t instanceof It?t:void 0}function po(t,n,e){return 2&n||(!e||4096&n||16&n?t=Wn(t,n,!1,e&&!(16&n)):(Te(t,34),4&n&&Object.freeze(t))),t}function ei(t,n,e){return t=new t.constructor(n),e&&(t.h=pn),t.m=pn,t}function To(t){let n=t.v,e=0|n[f];return ft(t,e)?t:ii(t,n,e)?ei(t,n):Wn(n,e)}function Wn(t,n,e,r){return r??=!!(34&n),t=Qe(t,n,pu,r),r=32,e&&(r|=2),H(t,n=16769217&n|r),t}function ri(t){let n=t.v,e=0|n[f];return ft(t,e)?ii(t,n,e)?ei(t,n,!0):new t.constructor(Wn(n,e,!1)):t}function jn(t){if(t.h!==pn)return!1;var n=t.v;return Te(n=Wn(n,0|n[f]),2048),t.v=n,t.h=void 0,t.m=void 0,!0}function Hn(t){if(!jn(t)&&ft(t,0|t.v[f]))throw Error()}function En(t,n){n===void 0&&(n=0|t[f]),32&n&&!(4096&n)&&H(t,4096|n)}function ii(t,n,e){return!!(2&e)||!(!(32&e)||4096&e)&&(H(n,2|e),t.h=pn,!0)}var Cs=dt(0),$t={};function P(t,n,e,r,o){if((n=jt(t.v,n,e,o))!==null||r&&t.m!==pn)return n}function jt(t,n,e,r){if(n===-1)return null;let o=n+(e?0:-1),i=t.length-1,s,a;if(!(i<1+(e?0:-1))){if(o>=i)if(s=t[i],s!=null&&typeof s=="object"&&s.constructor===Object)e=s[n],a=!0;else{if(o!==i)return;e=s}else e=t[o];if(r&&e!=null){if((r=r(e))==null)return r;if(!Object.is(r,e))return a?s[n]=r:t[o]=r,r}return e}}function R(t,n,e,r){Hn(t),W(t=t.v,0|t[f],n,e,r)}function W(t,n,e,r,o){let i=e+(o?0:-1);var s=t.length-1;if(s>=1+(o?0:-1)&&i>=s){let a=t[s];if(a!=null&&typeof a=="object"&&a.constructor===Object)return a[e]=r,n}return i<=s?(t[i]=r,n):(r!==void 0&&(e>=(s=(n??=0|t[f])>>14&1023||536870912)?r!=null&&(t[s+(o?0:-1)]={[e]:r}):t[i]=r),n)}function cn(){return Hc===void 0?2:4}function un(t,n,e,r,o){let i=t.v,s=0|i[f];r=ft(t,s)?1:r,o=!!o||r===3,r===2&&jn(t)&&(i=t.v,s=0|i[f]);let a=(t=oi(i,n))===_n?7:0|t[f],c=si(a,s);var l=!(4&c);if(l){4&c&&(t=wt(t),a=0,c=dn(c,s),s=W(i,s,n,t));let u=0,p=0;for(;u<t.length;u++){let h=e(t[u]);h!=null&&(t[p++]=h)}p<u&&(t.length=p),e=-513&(4|c),c=e&=-1025,c&=-4097}return c!==a&&(H(t,c),2&c&&Object.freeze(t)),Ds(t,c,i,s,n,r,l,o)}function Ds(t,n,e,r,o,i,s,a){let c=n;return i===1||i===4&&(2&n||!(16&n)&&32&r)?ln(n)||((n|=!t.length||s&&!(4096&n)||32&r&&!(4096&n||16&n)?2:256)!==c&&H(t,n),Object.freeze(t)):(i===2&&ln(n)&&(t=wt(t),c=0,n=dn(n,r),r=W(e,r,o,t)),ln(n)||(a||(n|=16),n!==c&&H(t,n))),2&n||!(4096&n||16&n)||En(e,r),t}function oi(t,n,e){return t=jt(t,n,e),Array.isArray(t)?t:_n}function si(t,n){return 2&n&&(t|=2),1|t}function ln(t){return!!(2&t)&&!!(4&t)||!!(256&t)}function Ms(t){return qr(t,!0)}function Bs(t){t=wt(t);for(let n=0;n<t.length;n++){let e=t[n]=wt(t[n]);Array.isArray(e[1])&&(e[1]=_e(e[1]))}return de(t)}function Qt(t,n,e,r){Hn(t),W(t=t.v,0|t[f],n,(r==="0"?Number(e)===0:e===r)?void 0:e)}function Yn(t,n,e){if(2&n)throw Error();let r=Xn(n),o=oi(t,e,r),i=o===_n?7:0|o[f],s=si(i,n);return(2&s||ln(s)||16&s)&&(s===i||ln(s)||H(o,s),o=wt(o),i=0,s=dn(s,n),W(t,n,e,o,r)),s&=-13,s!==i&&H(o,s),o}function br(t,n){var e=Sa;return ci(ai(t=t.v),t,void 0,e)===n?n:-1}function ai(t){if(Gn)return t[re]??(t[re]=new Map);if(re in t)return t[re];let n=new Map;return Object.defineProperty(t,re,{value:n}),n}function Ns(t,n,e,r,o){let i=ai(t),s=ci(i,t,n,e,o);return s!==r&&(s&&(n=W(t,n,s,void 0,o)),i.set(e,r)),n}function ci(t,n,e,r,o){let i=t.get(r);if(i!=null)return i;i=0;for(let s=0;s<r.length;s++){let a=r[s];jt(n,a,o)!=null&&(i!==0&&(e=W(n,e,i,void 0,o)),i=a)}return t.set(r,i),i}function ui(t,n,e){let r=0|t[f],o=Xn(r),i=jt(t,e,o),s;if(i!=null&&i[Un]===Fn){if(!ft(i))return jn(i),i.v;s=i.v}else Array.isArray(i)&&(s=i);if(s){let a=0|s[f];2&a&&(s=Wn(s,a))}return s=hn(s,n),s!==i&&W(t,r,e,s,o),s}function Os(t,n,e,r,o){let i=!1;if((r=jt(t,r,o,(s=>{let a=ni(s,e,!1,n);return i=a!==s&&a!=null,a})))!=null)return i&&!ft(r)&&En(t,n),r}function x(t,n,e,r){let o=t.v,i=0|o[f];if((n=Os(o,i,n,e,r))==null)return n;if(i=0|o[f],!ft(t,i)){let s=ri(n);s!==n&&(jn(t)&&(o=t.v,i=0|o[f]),i=W(o,i,e,n=s,r),En(o,i))}return n}function Gs(t,n,e,r,o,i,s,a){var c=ft(t,e);i=c?1:i,s=!!s||i===3,c=a&&!c,(i===2||c)&&jn(t)&&(e=0|(n=t.v)[f]);var l=(t=oi(n,o))===_n?7:0|t[f],u=si(l,e);if(a=!(4&u)){var p=t,h=e;let v=!!(2&u);v&&(h|=2);let _=!v,Y=!0,A=0,st=0;for(;A<p.length;A++){let Gt=ni(p[A],r,!1,h);if(Gt instanceof r){if(!v){let zt=ft(Gt);_&&=!zt,Y&&=zt}p[st++]=Gt}}st<A&&(p.length=st),u|=4,u=Y?-4097&u:4096|u,u=_?8|u:-9&u}if(u!==l&&(H(t,u),2&u&&Object.freeze(t)),c&&!(8&u||!t.length&&(i===1||i===4&&(2&u||!(16&u)&&32&e)))){for(ln(u)&&(t=wt(t),u=dn(u,e),e=W(n,e,o,t)),r=t,c=u,l=0;l<r.length;l++)(p=r[l])!==(u=ri(p))&&(r[l]=u);c|=8,H(t,u=c=r.length?4096|c:-4097&c)}return Ds(t,u,n,e,o,i,a,s)}function Ht(t,n,e){let r=t.v;return Gs(t,r,0|r[f],n,e,cn(),!1,!0)}function Xs(t){return t==null&&(t=void 0),t}function E(t,n,e,r,o){return R(t,e,r=Xs(r),o),r&&!ft(r)&&En(t.v),t}function ue(t,n,e,r){t:{var o=r=Xs(r);Hn(t);let i=t.v,s=0|i[f];if(o==null){let a=ai(i);if(ci(a,i,s,e)!==n)break t;a.set(e,0)}else s=Ns(i,s,e,n);W(i,s,n,o)}r&&!ft(r)&&En(t.v)}function dn(t,n){return-273&(2&n?2|t:-3&t)}function hi(t,n,e,r){var o=r;Hn(t),t=Gs(t,r=t.v,0|r[f],e,n,2,!0),o=o??new e,t.push(o),n=e=t===_n?7:0|t[f],(o=ft(o))?(e&=-9,t.length===1&&(e&=-4097)):e|=4096,e!==n&&H(t,e),o||En(r)}function bt(t,n,e){return Vn(P(t,n,void 0,e))}function B(t,n){return P(t,n,void 0,void 0,Pt)??0}function Yt(t,n,e){if(e!=null){if(typeof e!="number"||!$e(e))throw Lr("int32");e|=0}R(t,n,e)}function T(t,n,e){R(t,n,se(e))}function gt(t,n,e){Qt(t,n,be(e),"")}function Ge(t,n,e){{Hn(t);let s=t.v,a=0|s[f];if(e==null)W(s,a,n);else{var r=t=e===_n?7:0|e[f],o=ln(t),i=o||Object.isFrozen(e);for(o||(t=0),i||(e=wt(e),r=0,t=dn(t,a),i=!1),t|=5,t|=(4&t?512&t?512:1024&t?1024:0:void 0)??1024,o=0;o<e.length;o++){let c=e[o],l=Fs(c);Object.is(c,l)||(i&&(e=wt(e),r=0,t=dn(t,a),i=!1),e[o]=l)}t!==r&&(i&&(e=wt(e),t=dn(t,a)),H(e,t)),W(s,a,n,e)}}}function Ze(t,n,e){Hn(t),un(t,n,$,2,!0).push(Fs(e))}var yn=class{constructor(t,n,e){if(this.buffer=t,e&&!n)throw Error();this.g=n}};function li(t,n){if(typeof t=="string")return new yn(ps(t),n);if(Array.isArray(t))return new yn(new Uint8Array(t),n);if(t.constructor===Uint8Array)return new yn(t,!1);if(t.constructor===ArrayBuffer)return t=new Uint8Array(t),new yn(t,!1);if(t.constructor===It)return n=$r(t)||new Uint8Array(0),new yn(n,!0,t);if(t instanceof Uint8Array)return t=t.constructor===Uint8Array?t:new Uint8Array(t.buffer,t.byteOffset,t.byteLength),new yn(t,!1);throw Error()}function di(t,n){let e,r=0,o=0,i=0,s=t.h,a=t.g;do e=s[a++],r|=(127&e)<<i,i+=7;while(i<32&&128&e);if(i>32)for(o|=(127&e)>>4,i=3;i<32&&128&e;i+=7)e=s[a++],o|=(127&e)<<i;if(fn(t,a),!(128&e))return n(r>>>0,o>>>0);throw Error()}function fi(t){let n=0,e=t.g,r=e+10,o=t.h;for(;e<r;){let i=o[e++];if(n|=i,(128&i)==0)return fn(t,e),!!(127&n)}throw Error()}function Jt(t){let n=t.h,e=t.g,r=n[e++],o=127&r;if(128&r&&(r=n[e++],o|=(127&r)<<7,128&r&&(r=n[e++],o|=(127&r)<<14,128&r&&(r=n[e++],o|=(127&r)<<21,128&r&&(r=n[e++],o|=r<<28,128&r&&128&n[e++]&&128&n[e++]&&128&n[e++]&&128&n[e++]&&128&n[e++])))))throw Error();return fn(t,e),o}function Ct(t){return Jt(t)>>>0}function Xe(t){var n=t.h;let e=t.g;var r=n[e],o=n[e+1];let i=n[e+2];return n=n[e+3],fn(t,t.g+4),t=2*((o=(r<<0|o<<8|i<<16|n<<24)>>>0)>>31)+1,r=o>>>23&255,o&=8388607,r==255?o?NaN:t*(1/0):r==0?1401298464324817e-60*t*o:t*Math.pow(2,r-150)*(o+8388608)}function Tu(t){return Jt(t)}function fn(t,n){if(t.g=n,n>t.l)throw Error()}function Vs(t,n){if(n<0)throw Error();let e=t.g;if((n=e+n)>t.l)throw Error();return t.g=n,e}function Ws(t,n){if(n==0)return mn();var e=Vs(t,n);return t.Y&&t.j?e=t.h.subarray(e,e+n):(t=t.h,e=e===(n=e+n)?new Uint8Array(0):Zc?t.slice(e,n):new Uint8Array(t.subarray(e,n))),e.length==0?mn():new It(e,Sn)}var _o=[];function js(t,n,e,r){if(Ve.length){let o=Ve.pop();return o.o(r),o.g.init(t,n,e,r),o}return new _u(t,n,e,r)}function Hs(t){t.g.clear(),t.l=-1,t.h=-1,Ve.length<100&&Ve.push(t)}function Ys(t){var n=t.g;if(n.g==n.l)return!1;t.m=t.g.g;var e=Ct(t.g);if(n=e>>>3,!((e&=7)>=0&&e<=5)||n<1)throw Error();return t.l=n,t.h=e,!0}function Ie(t){switch(t.h){case 0:t.h!=0?Ie(t):fi(t.g);break;case 1:fn(t=t.g,t.g+8);break;case 2:if(t.h!=2)Ie(t);else{var n=Ct(t.g);fn(t=t.g,t.g+n)}break;case 5:fn(t=t.g,t.g+4);break;case 3:for(n=t.l;;){if(!Ys(t))throw Error();if(t.h==4){if(t.l!=n)throw Error();break}Ie(t)}break;default:throw Error()}}function ye(t,n,e){let r=t.g.l;var o=Ct(t.g);let i=(o=t.g.g+o)-r;if(i<=0&&(t.g.l=o,e(n,t,void 0,void 0,void 0),i=o-t.g.g),i)throw Error();return t.g.g=o,t.g.l=r,n}function gi(t){var n=Ct(t.g),e=Vs(t=t.g,n);if(t=t.h,Fc){var r,o=t;(r=Er)||(r=Er=new TextDecoder("utf-8",{fatal:!0})),n=e+n,o=e===0&&n===o.length?o:o.subarray(e,n);try{var i=r.decode(o)}catch(a){if(ke===void 0){try{r.decode(new Uint8Array([128]))}catch{}try{r.decode(new Uint8Array([97])),ke=!0}catch{ke=!1}}throw!ke&&(Er=void 0),a}}else{n=(i=e)+n,e=[];let a,c=null;for(;i<n;){var s=t[i++];s<128?e.push(s):s<224?i>=n?sn():(a=t[i++],s<194||(192&a)!=128?(i--,sn()):e.push((31&s)<<6|63&a)):s<240?i>=n-1?sn():(a=t[i++],(192&a)!=128||s===224&&a<160||s===237&&a>=160||(192&(r=t[i++]))!=128?(i--,sn()):e.push((15&s)<<12|(63&a)<<6|63&r)):s<=244?i>=n-2?sn():(a=t[i++],(192&a)!=128||a-144+(s<<28)>>30!=0||(192&(r=t[i++]))!=128||(192&(o=t[i++]))!=128?(i--,sn()):(s=(7&s)<<18|(63&a)<<12|(63&r)<<6|63&o,s-=65536,e.push(55296+(s>>10&1023),56320+(1023&s)))):sn(),e.length>=8192&&(c=no(c,e),e.length=0)}i=no(c,e)}return i}function zs(t){let n=Ct(t.g);return Ws(t.g,n)}function Je(t,n,e){var r=Ct(t.g);for(r=t.g.g+r;t.g.g<r;)e.push(n(t.g))}var _u=class{constructor(t,n,e,r){if(_o.length){let o=_o.pop();o.init(t,n,e,r),t=o}else t=new class{constructor(o,i,s,a){this.h=null,this.j=!1,this.g=this.l=this.m=0,this.init(o,i,s,a)}init(o,i,s,{Y:a=!1,ea:c=!1}={}){this.Y=a,this.ea=c,o&&(o=li(o,this.ea),this.h=o.buffer,this.j=o.g,this.m=i||0,this.l=s!==void 0?this.m+s:this.h.length,this.g=this.m)}clear(){this.h=null,this.j=!1,this.g=this.l=this.m=0,this.Y=!1}}(t,n,e,r);this.g=t,this.m=this.g.g,this.h=this.l=-1,this.o(r)}o({ha:t=!1}={}){this.ha=t}},Ve=[];function Eo(t){return t?/^\d+$/.test(t)?(Ke(t),new Ir(F,N)):null:Eu||=new Ir(0,0)}var Ir=class{constructor(t,n){this.h=t>>>0,this.g=n>>>0}},Eu;function vo(t){return t?/^-?\d+$/.test(t)?(Ke(t),new Cr(F,N)):null:vu||=new Cr(0,0)}var Cr=class{constructor(t,n){this.h=t>>>0,this.g=n>>>0}},vu;function An(t,n,e){for(;e>0||n>127;)t.g.push(127&n|128),n=(n>>>7|e<<25)>>>0,e>>>=7;t.g.push(n)}function zn(t,n){for(;n>127;)t.g.push(127&n|128),n>>>=7;t.g.push(n)}function tr(t,n){if(n>=0)zn(t,n);else{for(let e=0;e<9;e++)t.g.push(127&n|128),n>>=7;t.g.push(1)}}function mi(t){var n=F;t.g.push(n>>>0&255),t.g.push(n>>>8&255),t.g.push(n>>>16&255),t.g.push(n>>>24&255)}function Cn(t,n){n.length!==0&&(t.l.push(n),t.h+=n.length)}function yt(t,n,e){zn(t.g,8*n+e)}function pi(t,n){return yt(t,n,2),n=t.g.end(),Cn(t,n),n.push(t.h),n}function Ti(t,n){var e=n.pop();for(e=t.h+t.g.length()-e;e>127;)n.push(127&e|128),e>>>=7,t.h++;n.push(e),t.h++}function nr(t,n,e){yt(t,n,2),zn(t.g,e.length),Cn(t,t.g.end()),Cn(t,e)}function We(t,n,e,r){e!=null&&(n=pi(t,n),r(e,t),Ti(t,n))}function Mt(){let t=class{constructor(){throw Error()}};return Object.setPrototypeOf(t,t.prototype),t}var _i=Mt(),Ks=Mt(),Ei=Mt(),vi=Mt(),bi=Mt(),$s=Mt(),bu=Mt(),er=Mt(),qs=Mt(),Qs=Mt();function Bt(t,n,e){var r=t.v;lt&&lt in r&&(r=r[lt])&&delete r[n.g],n.h?n.j(t,n.h,n.g,e,n.l):n.j(t,n.g,e,n.l)}var g=class{constructor(t,n){this.v=Is(t,n,void 0,2048)}toJSON(){return Ps(this)}j(){var t=n2,n=this.v,e=t.g,r=lt;if(Gn&&r&&n[r]?.[e]!=null&&Ln(Vc,3),n=t.g,ao&&lt&&ao===void 0&&(r=(e=this.v)[lt])&&(r=r.da))try{r(e,n,lu)}catch(o){ds(o)}return t.h?t.m(this,t.h,t.g,t.l):t.m(this,t.g,t.defaultValue,t.l)}clone(){let t=this.v,n=0|t[f];return ii(this,t,n)?ei(this,t,!0):new this.constructor(Wn(t,n,!1))}};g.prototype[Un]=Fn,g.prototype.toString=function(){return this.v.toString()};var Kn=class{constructor(t,n,e){this.g=t,this.h=n,t=_i,this.l=!!t&&e===t||!1}};function rr(t,n){return new Kn(t,n,_i)}function Zs(t,n,e,r,o){We(t,e,ea(n,r),o)}var yu=rr((function(t,n,e,r,o){return t.h===2&&(ye(t,ui(n,r,e),o),!0)}),Zs),xu=rr((function(t,n,e,r,o){return t.h===2&&(ye(t,ui(n,r,e),o),!0)}),Zs),ir=Symbol(),or=Symbol(),Dr=Symbol(),bo=Symbol(),yo=Symbol(),Js,ta;function vn(t,n,e,r){var o=r[t];if(o)return o;(o={}).qa=r,o.T=(function(p){switch(typeof p){case"boolean":return gu||=[0,void 0,!0];case"number":return p>0?void 0:p===0?mu||=[0,void 0]:[-p,void 0];case"string":return[0,p];case"object":return p}})(r[0]);var i=r[1];let s=1;i&&i.constructor===Object&&(o.ba=i,typeof(i=r[++s])=="function"&&(o.ma=!0,Js??=i,ta??=r[s+1],i=r[s+=2]));let a={};for(;i&&Array.isArray(i)&&i.length&&typeof i[0]=="number"&&i[0]>0;){for(var c=0;c<i.length;c++)a[i[c]]=i;i=r[++s]}for(c=1;i!==void 0;){let p;typeof i=="number"&&(c+=i,i=r[++s]);var l=void 0;if(i instanceof Kn?p=i:(p=yu,s--),p?.l){i=r[++s],l=r;var u=s;typeof i=="function"&&(i=i(),l[u]=i),l=i}for(u=c+1,typeof(i=r[++s])=="number"&&i<0&&(u-=i,i=r[++s]);c<u;c++){let h=a[c];l?e(o,c,p,l,h):n(o,c,p,h)}}return r[t]=o}function na(t){return Array.isArray(t)?t[0]instanceof Kn?t:[xu,t]:[t,void 0]}function ea(t,n){return t instanceof g?t.v:Array.isArray(t)?hn(t,n):void 0}function yi(t,n,e,r){let o=e.g;t[n]=r?(i,s,a)=>o(i,s,a,r):o}function xi(t,n,e,r,o){let i=e.g,s,a;t[n]=(c,l,u)=>i(c,l,u,a||=vn(or,yi,xi,r).T,s||=wi(r),o)}function wi(t){let n=t[Dr];if(n!=null)return n;let e=vn(or,yi,xi,t);return n=e.ma?(r,o)=>Js(r,o,e):(r,o)=>{for(;Ys(o)&&o.h!=4;){var i=o.l,s=e[i];if(s==null){var a=e.ba;a&&(a=a[i])&&(a=Au(a))!=null&&(s=e[i]=a)}if(s==null||!s(o,r,i)){if(s=(a=o).m,Ie(a),a.ha)var c=void 0;else c=a.g.g-s,a.g.g=s,c=Ws(a.g,c);s=void 0,a=r,c&&((s=a[lt]??(a[lt]=new Pr))[i]??(s[i]=[])).push(c)}}return(r=qe(r))&&(r.da=e.qa[yo]),!0},t[Dr]=n,t[yo]=wu.bind(t),n}function wu(t,n,e,r){var o=this[or];let i=this[Dr],s=hn(void 0,o.T),a=qe(t);if(a){var c=!1,l=o.ba;if(l){if(o=(u,p,h)=>{if(h.length!==0)if(l[p])for(let v of h){u=js(v);try{c=!0,i(s,u)}finally{Hs(u)}}else r?.(t,p,h)},n==null)Oe(a,o);else if(a!=null){let u=a[n];u&&o(a,n,u)}if(c){let u=0|t[f];if(2&u&&2048&u&&!e?.Ka)throw Error();let p=Xn(u),h=(v,_)=>{if(jt(t,v,p)!=null){if(e?.Qa===1)return;throw Error()}_!=null&&(u=W(t,u,v,_,p)),delete a[v]};n==null?bs(s,0|s[f],((v,_)=>{h(v,_)})):h(n,jt(s,n,p))}}}}function Au(t){let n=(t=na(t))[0].g;if(t=t[1]){let e=wi(t),r=vn(or,yi,xi,t).T;return(o,i,s)=>n(o,i,s,r,e)}return n}function sr(t,n,e){t[n]=e.h}function ar(t,n,e,r){let o,i,s=e.h;t[n]=(a,c,l)=>s(a,c,l,i||=vn(ir,sr,ar,r).T,o||=ra(r))}function ra(t){let n=t[bo];if(!n){let e=vn(ir,sr,ar,t);n=(r,o)=>ia(r,o,e),t[bo]=n}return n}function ia(t,n,e){bs(t,0|t[f],((r,o)=>{if(o!=null){var i=(function(s,a){var c=s[a];if(c)return c;if((c=s.ba)&&(c=c[a])){var l=(c=na(c))[0].h;if(c=c[1]){let u=ra(c),p=vn(ir,sr,ar,c).T;c=s.ma?ta(p,u):(h,v,_)=>l(h,v,_,p,u)}else c=l;return s[a]=c}})(e,r);i?i(n,o,r):r<500||Ln(Ur,3)}})),(t=qe(t))&&Oe(t,((r,o,i)=>{for(Cn(n,n.g.end()),r=0;r<i.length;r++)Cn(n,$r(i[r])||new Uint8Array(0))}))}var Ru=dt(0);function $n(t,n){if(Array.isArray(n)){var e=0|n[f];if(4&e)return n;for(var r=0,o=0;r<n.length;r++){let i=t(n[r]);i!=null&&(n[o++]=i)}return o<r&&(n.length=o),(t=-1537&(5|e))!==e&&H(n,t),2&t&&Object.freeze(n),n}}function J(t,n,e){return new Kn(t,n,e)}function qn(t,n,e){return new Kn(t,n,e)}function tt(t,n,e){W(t,0|t[f],n,e,Xn(0|t[f]))}var ku=rr((function(t,n,e,r,o){if(t.h!==2)return!1;if(t=wt(t=ye(t,hn([void 0,void 0],r),o)),o=Xn(r=0|n[f]),2&r)throw Error();let i=jt(n,e,o);if(i instanceof Wt)(2&i.J)!=0?(i=i.V(),i.push(t),W(n,r,e,i,o)):i.Ma(t);else if(Array.isArray(i)){var s=0|i[f];8192&s||H(i,s|=8192),2&s&&(i=Bs(i),W(n,r,e,i,o)),i.push(t)}else W(n,r,e,de([t]),o);return!0}),(function(t,n,e,r,o){if(n instanceof Wt)n.forEach(((i,s)=>{We(t,e,hn([s,i],r),o)}));else if(Array.isArray(n)){for(let i=0;i<n.length;i++){let s=n[i];Array.isArray(s)&&We(t,e,hn(s,r),o)}de(n)}}));function oa(t,n,e){(n=Pt(n))!=null&&(yt(t,e,5),t=t.g,Qr(n),mi(t))}function sa(t,n,e){if(n=(function(r){if(r==null)return r;let o=typeof r;if(o==="bigint")return String(Ee(64,r));if(ve(r)){if(o==="string")return Ss(r);if(o==="number")return ti(r)}})(n),n!=null&&(typeof n=="string"&&vo(n),n!=null))switch(yt(t,e,0),typeof n){case"number":t=t.g,Pn(n),An(t,F,N);break;case"bigint":e=BigInt.asUintN(64,n),e=new Cr(Number(e&BigInt(4294967295)),Number(e>>BigInt(32))),An(t.g,e.h,e.g);break;default:e=vo(n),An(t.g,e.h,e.g)}}function aa(t,n,e){(n=Vn(n))!=null&&n!=null&&(yt(t,e,0),tr(t.g,n))}function ca(t,n,e){(n=As(n))!=null&&(yt(t,e,0),t.g.g.push(n?1:0))}function ua(t,n,e){(n=$(n))!=null&&nr(t,e,ls(n))}function ha(t,n,e,r,o){We(t,e,ea(n,r),o)}function la(t,n,e){(n=n==null||typeof n=="string"||n instanceof It?n:void 0)!=null&&nr(t,e,li(n,!0).buffer)}function da(t,n,e){(n=Rs(n))!=null&&n!=null&&(yt(t,e,0),zn(t.g,n))}function fa(t,n,e){return(t.h===5||t.h===2)&&(n=Yn(n,0|n[f],e),t.h==2?Je(t,Xe,n):n.push(Xe(t.g)),!0)}var O=J((function(t,n,e){return t.h===5&&(tt(n,e,Xe(t.g)),!0)}),oa,er),Su=qn(fa,(function(t,n,e){if((n=$n(Pt,n))!=null)for(let s=0;s<n.length;s++){var r=t,o=e,i=n[s];i!=null&&(yt(r,o,5),r=r.g,Qr(i),mi(r))}}),er),Ai=qn(fa,(function(t,n,e){if((n=$n(Pt,n))!=null&&n.length){yt(t,e,2),zn(t.g,4*n.length);for(let r=0;r<n.length;r++)e=t.g,Qr(n[r]),mi(e)}}),er),Lu=J((function(t,n,e){return t.h===5&&(tt(n,e,(t=Xe(t.g))===0?void 0:t),!0)}),oa,er),tn=J((function(t,n,e){return t.h!==0?t=!1:(tt(n,e,di(t.g,ws)),t=!0),t}),sa,$s),yr=J((function(t,n,e){return t.h!==0?n=!1:(tt(n,e,(t=di(t.g,ws))===Ru?void 0:t),n=!0),n}),sa,$s),Uu=J((function(t,n,e){return t.h!==0?t=!1:(tt(n,e,di(t.g,tu)),t=!0),t}),(function(t,n,e){if(n=(function(r){if(r==null)return r;var o=typeof r;if(o==="bigint")return String(nu(64,r));if(ve(r)){if(o==="string")return o=In(Number(r)),Tn(o)&&o>=0?r=String(o):((o=r.indexOf("."))!==-1&&(r=r.substring(0,o)),(o=r[0]!=="-"&&((o=r.length)<20||o===20&&r<="18446744073709551615"))||(Ke(r),r=fe(F,N))),r;if(o==="number")return(r=In(r))>=0&&Tn(r)||(Pn(r),r=xs(F,N)),r}})(n),n!=null&&(typeof n=="string"&&Eo(n),n!=null))switch(yt(t,e,0),typeof n){case"number":t=t.g,Pn(n),An(t,F,N);break;case"bigint":e=BigInt.asUintN(64,n),e=new Ir(Number(e&BigInt(4294967295)),Number(e>>BigInt(32))),An(t.g,e.h,e.g);break;default:e=Eo(n),An(t.g,e.h,e.g)}}),bu),V=J((function(t,n,e){return t.h===0&&(tt(n,e,Jt(t.g)),!0)}),aa,vi),xe=qn((function(t,n,e){return(t.h===0||t.h===2)&&(n=Yn(n,0|n[f],e),t.h==2?Je(t,Jt,n):n.push(Jt(t.g)),!0)}),(function(t,n,e){if((n=$n(Vn,n))!=null&&n.length){e=pi(t,e);for(let r=0;r<n.length;r++)tr(t.g,n[r]);Ti(t,e)}}),vi),wn=J((function(t,n,e){return t.h===0&&(tt(n,e,(t=Jt(t.g))===0?void 0:t),!0)}),aa,vi),I=J((function(t,n,e){return t.h===0&&(tt(n,e,fi(t.g)),!0)}),ca,Ks),gn=J((function(t,n,e){return t.h===0&&(tt(n,e,(t=fi(t.g))===!1?void 0:t),!0)}),ca,Ks),Q=qn((function(t,n,e){return t.h===2&&(t=gi(t),Yn(n,0|n[f],e).push(t),!0)}),(function(t,n,e){if((n=$n($,n))!=null)for(let s=0;s<n.length;s++){var r=t,o=e,i=n[s];i!=null&&nr(r,o,ls(i))}}),Ei),Zt=J((function(t,n,e){return t.h===2&&(tt(n,e,(t=gi(t))===""?void 0:t),!0)}),ua,Ei),k=J((function(t,n,e){return t.h===2&&(tt(n,e,gi(t)),!0)}),ua,Ei),z=(function(t,n,e=_i){return new Kn(t,n,e)})((function(t,n,e,r,o){return t.h===2&&(r=hn(void 0,r),Yn(n,0|n[f],e).push(r),ye(t,r,o),!0)}),(function(t,n,e,r,o){if(Array.isArray(n)){for(let i=0;i<n.length;i++)ha(t,n[i],e,r,o);1&(t=0|n[f])||H(n,1|t)}})),L=rr((function(t,n,e,r,o,i){if(t.h!==2)return!1;let s=0|n[f];return Ns(n,s,i,e,Xn(s)),ye(t,n=ui(n,r,e),o),!0}),ha),ga=J((function(t,n,e){return t.h===2&&(tt(n,e,zs(t)),!0)}),la,qs),Fu=qn((function(t,n,e){return(t.h===0||t.h===2)&&(n=Yn(n,0|n[f],e),t.h==2?Je(t,Ct,n):n.push(Ct(t.g)),!0)}),(function(t,n,e){if((n=$n(Rs,n))!=null)for(let s=0;s<n.length;s++){var r=t,o=e,i=n[s];i!=null&&(yt(r,o,0),zn(r.g,i))}}),bi),Pu=J((function(t,n,e){return t.h===0&&(tt(n,e,(t=Ct(t.g))===0?void 0:t),!0)}),da,bi),Z=J((function(t,n,e){return t.h===0&&(tt(n,e,Jt(t.g)),!0)}),(function(t,n,e){(n=Vn(n))!=null&&(n=parseInt(n,10),yt(t,e,0),tr(t.g,n))}),Qs),Mr=class{constructor(n,e){var r=pt;this.g=n,this.h=e,this.m=x,this.j=E,this.defaultValue=void 0,this.l=r.Oa!=null?ys:void 0}register(){He(this)}};function Nt(t,n){return new Mr(t,n)}function en(t,n){return(e,r)=>{{let i={ea:!0};r&&Object.assign(i,r),e=js(e,void 0,void 0,i);try{let s=new t,a=s.v;wi(n)(a,e);var o=s}finally{Hs(e)}}return o}}function cr(t){return function(){let n=new class{constructor(){this.l=[],this.h=0,this.g=new class{constructor(){this.g=[]}length(){return this.g.length}end(){let s=this.g;return this.g=[],s}}}};ia(this.v,n,vn(ir,sr,ar,t)),Cn(n,n.g.end());let e=new Uint8Array(n.h),r=n.l,o=r.length,i=0;for(let s=0;s<o;s++){let a=r[s];e.set(a,i),i+=a.length}return n.l=[e],e}}var xo=class extends g{constructor(t){super(t)}},wo=[0,Zt,J((function(t,n,e){return t.h===2&&(tt(n,e,(t=zs(t))===mn()?void 0:t),!0)}),(function(t,n,e){if(n!=null){if(n instanceof g){let r=n.Ra;return void(r?(n=r(n),n!=null&&nr(t,e,li(n,!0).buffer)):Ln(Ur,3))}if(Array.isArray(n))return void Ln(Ur,3)}la(t,n,e)}),qs)],xr,Ao=globalThis.trustedTypes;function Ro(t){var n;return xr===void 0&&(xr=(function(){let e=null;if(!Ao)return e;try{let r=o=>o;e=Ao.createPolicy("goog#html",{createHTML:r,createScript:r,createScriptURL:r})}catch{}return e})()),t=(n=xr)?n.createScriptURL(t):t,new class{constructor(e){this.g=e}toString(){return this.g+""}}(t)}function Se(t,...n){if(n.length===0)return Ro(t[0]);let e=t[0];for(let r=0;r<n.length;r++)e+=encodeURIComponent(n[r])+t[r+1];return Ro(e)}var ma=[0,V,Z,I,-1,xe,Z,-1,I],Iu=class extends g{constructor(t){super(t)}},pa=[0,I,k,I,Z,-1,qn((function(t,n,e){return(t.h===0||t.h===2)&&(n=Yn(n,0|n[f],e),t.h==2?Je(t,Tu,n):n.push(Jt(t.g)),!0)}),(function(t,n,e){if((n=$n(Vn,n))!=null&&n.length){e=pi(t,e);for(let r=0;r<n.length;r++)tr(t.g,n[r]);Ti(t,e)}}),Qs),k,-1,[0,I,-1],Z,I,-1],Ta=[0,3,I,-1,2,[0,[2],V,L,[0,J((function(t,n,e){return t.h===0&&(tt(n,e,Ct(t.g)),!0)}),da,bi)]],[0,Z,I,Z,I,Z,I,k,-1],[0,[3,4],k,-1,L,[0,V],L,[0,Z]],[0]],_a=[0,k,-2],ko=class extends g{constructor(t){super(t)}},Ea=[0],va=[0,V,I,1,I,-4],pt=class extends g{constructor(t){super(t,2)}},j={};j[336783863]=[0,k,I,-1,V,[0,[1,2,3,4,5,6,7,8,9],L,Ea,L,pa,L,_a,L,va,L,ma,L,[0,k,-2],L,[0,k,Z],L,Ta,L,[0,Z,-1,I]],[0,k],I,[0,[1,3],[2,4],L,[0,xe],-1,L,[0,Q],-1,z,[0,k,-1]],k];var So=[0,yr,-1,gn,-3,yr,xe,Zt,wn,yr,-1,gn,wn,gn,-2,Zt];function U(t,n){Ze(t,3,n)}function b(t,n){Ze(t,4,n)}var ot=class extends g{constructor(t){super(t,500)}o(t){return E(this,0,7,t)}},he=[-1,{}],Lo=[0,k,1,he],Uo=[0,k,Q,he];function xt(t,n){hi(t,1,ot,n)}function C(t,n){Ze(t,10,n)}function w(t,n){Ze(t,15,n)}var Tt=class extends g{constructor(t){super(t,500)}o(t){return E(this,0,1001,t)}},ba=[-500,z,[-500,Zt,-1,Q,-3,[-2,j,I],z,wo,wn,-1,Lo,Uo,z,[0,Zt,gn],Zt,So,wn,Q,987,Q],4,z,[-500,k,-1,[-1,{}],998,k],z,[-500,k,Q,-1,[-2,{},I],997,Q,-1],wn,z,[-500,k,Q,he,998,Q],Q,wn,Lo,Uo,z,[0,Zt,-1,he],Q,-2,So,Zt,-1,gn,[0,gn,Pu],978,he,z,wo];Tt.prototype.g=cr(ba);var Cu=en(Tt,ba),Du=class extends g{constructor(t){super(t)}},ya=class extends g{constructor(t){super(t)}g(){return Ht(this,Du,1)}},xa=[0,z,[0,V,O,k,-1]],ur=en(ya,xa),Mu=class extends g{constructor(t){super(t)}},Bu=class extends g{constructor(t){super(t)}},wr=class extends g{constructor(t){super(t)}l(){return x(this,Mu,2)}g(){return Ht(this,Bu,5)}},wa=en(class extends g{constructor(t){super(t)}},[0,Q,xe,Ai,[0,Z,[0,V,-3],[0,O,-3],[0,V,-1,[0,z,[0,V,-2]]],z,[0,O,-1,k,O]],k,-1,tn,z,[0,V,O],Q,tn]),Aa=class extends g{constructor(t){super(t)}},Rn=en(class extends g{constructor(t){super(t)}},[0,z,[0,O,-4]]),Ra=class extends g{constructor(t){super(t)}},we=en(class extends g{constructor(t){super(t)}},[0,z,[0,O,-4]]),Nu=class extends g{constructor(t){super(t)}},Ou=[0,V,-1,Ai,Z],ka=class extends g{constructor(t){super(t)}};ka.prototype.g=cr([0,O,-4,tn]);var Gu=class extends g{constructor(t){super(t)}},Xu=en(class extends g{constructor(t){super(t)}},[0,z,[0,1,V,k,xa],tn]),Fo=class extends g{constructor(t){super(t)}},Vu=class extends g{constructor(t){super(t)}na(){let t=P(this,1,void 0,void 0,Ms);return t??mn()}},Wu=class extends g{constructor(t){super(t)}},Sa=[1,2],ju=en(class extends g{constructor(t){super(t)}},[0,z,[0,Sa,L,[0,Ai],L,[0,ga],V,k],tn]),Ri=class extends g{constructor(t){super(t)}},La=[0,k,V,O,Q,-1],Po=class extends g{constructor(t){super(t)}},Hu=[0,I,-1],Io=class extends g{constructor(t){super(t)}},Ce=[1,2,3,4,5,6],je=class extends g{constructor(t){super(t)}g(){return P(this,1,void 0,void 0,Ms)!=null}l(){return $(P(this,2))!=null}},M=class extends g{constructor(t){super(t)}g(){return As(P(this,2))??!1}},Ua=[0,ga,k,[0,V,tn,-1],[0,Uu,tn]],G=[0,Ua,I,[0,Ce,L,va,L,pa,L,ma,L,Ea,L,_a,L,Ta],Z],hr=class extends g{constructor(t){super(t)}},ki=[0,G,O,-1,V],Yu=Nt(502141897,hr);j[502141897]=ki;var zu=en(class extends g{constructor(t){super(t)}},[0,[0,Z,-1,Su,Fu],Ou]),Fa=class extends g{constructor(t){super(t)}},Pa=class extends g{constructor(t){super(t)}},Br=[0,G,O,[0,G],I],Ku=Nt(508968150,Pa);j[508968150]=[0,G,ki,Br,O,[0,[0,Ua]]],j[508968149]=Br;var xn=class extends g{constructor(t){super(t)}l(){return x(this,Ri,2)}g(){R(this,2)}},Ia=[0,G,La];j[478825465]=Ia;var $u=class extends g{constructor(t){super(t)}},Ca=class extends g{constructor(t){super(t)}},Si=class extends g{constructor(t){super(t)}},Li=class extends g{constructor(t){super(t)}},Da=class extends g{constructor(t){super(t)}},Co=[0,G,[0,G],Ia,-1],Ma=[0,G,O,V],Ui=[0,G,O],Ba=[0,G,Ma,Ui,O],qu=Nt(479097054,Da);j[479097054]=[0,G,Ba,Co],j[463370452]=Co,j[464864288]=Ma;var Qu=Nt(462713202,Li);j[462713202]=Ba,j[474472470]=Ui;var Zu=class extends g{constructor(t){super(t)}},Na=class extends g{constructor(t){super(t)}},Oa=class extends g{constructor(t){super(t)}},Ga=class extends g{constructor(t){super(t)}},Fi=[0,G,O,-1,V],Nr=[0,G,O,I];Ga.prototype.g=cr([0,G,Ui,[0,G],ki,Br,Fi,Nr]);var Xa=class extends g{constructor(t){super(t)}},Ju=Nt(456383383,Xa);j[456383383]=[0,G,La];var Va=class extends g{constructor(t){super(t)}},t2=Nt(476348187,Va);j[476348187]=[0,G,Hu];var Wa=class extends g{constructor(t){super(t)}},Do=class extends g{constructor(t){super(t)}},ja=[0,Z,-1],n2=Nt(458105876,class extends g{constructor(t){super(t)}g(){let t;var n=this.v;let e=0|n[f];return t=ft(this,e),n=(function(r,o,i,s){var a=Do;!s&&jn(r)&&(i=0|(o=r.v)[f]);var c=jt(o,2);if(r=!1,c==null){if(s)return mo();c=[]}else if(c.constructor===Wt){if(!(2&c.J)||s)return c;c=c.V()}else Array.isArray(c)?r=!!(2&(0|c[f])):c=[];if(s){if(!c.length)return mo();r||(r=!0,_e(c))}else r&&(r=!1,de(c),c=Bs(c));return!r&&32&i&&Te(c,32),i=W(o,i,2,s=new Wt(c,a,iu,void 0)),r||En(o,i),s})(this,n,e,t),!t&&Do&&(n.ra=!0),n}});j[458105876]=[0,ja,ku,[!0,tn,[0,k,-1,Q]],[0,xe,I,Z]];var Pi=class extends g{constructor(t){super(t)}},Ha=Nt(458105758,Pi);j[458105758]=[0,G,k,ja];var Ar=class extends g{constructor(t){super(t)}},Mo=[0,Lu,-1,gn],e2=class extends g{constructor(t){super(t)}},Ya=class extends g{constructor(t){super(t)}},Or=[1,2];Ya.prototype.g=cr([0,Or,L,Mo,L,[0,z,Mo]]);var za=class extends g{constructor(t){super(t)}},r2=Nt(443442058,za);j[443442058]=[0,G,k,V,O,Q,-1,I,O],j[514774813]=Fi;var Ka=class extends g{constructor(t){super(t)}},i2=Nt(516587230,Ka);function Gr(t,n){return n=n?n.clone():new Ri,t.displayNamesLocale!==void 0?R(n,1,be(t.displayNamesLocale)):t.displayNamesLocale===void 0&&R(n,1),t.maxResults!==void 0?Yt(n,2,t.maxResults):"maxResults"in t&&R(n,2),t.scoreThreshold!==void 0?T(n,3,t.scoreThreshold):"scoreThreshold"in t&&R(n,3),t.categoryAllowlist!==void 0?Ge(n,4,t.categoryAllowlist):"categoryAllowlist"in t&&R(n,4),t.categoryDenylist!==void 0?Ge(n,5,t.categoryDenylist):"categoryDenylist"in t&&R(n,5),n}function $a(t){let n=Number(t);return Number.isSafeInteger(n)?n:String(t)}function Ii(t,n=-1,e=""){return{categories:t.map((r=>({index:bt(r,1)??0??-1,score:B(r,2)??0,categoryName:$(P(r,3))??""??"",displayName:$(P(r,4))??""??""}))),headIndex:n,headName:e}}function o2(t){let n={classifications:Ht(t,Gu,1).map((e=>Ii(x(e,ya,4)?.g()??[],bt(e,2)??0,$(P(e,3))??"")))};return(function(e){return e==null?e:typeof e=="bigint"?(Fr(e)?e=Number(e):(e=Ee(64,e),e=Fr(e)?Number(e):String(e)),e):ve(e)?typeof e=="number"?ti(e):Ss(e):void 0})(P(t,2,void 0,void 0,Ne))!=null&&(n.timestampMs=$a(P(t,2,void 0,void 0,Ne)??Cs)),n}function qa(t){var n=un(t,3,Pt,cn()),e=un(t,2,Vn,cn()),r=un(t,1,$,cn()),o=un(t,9,$,cn());let i={categories:[],keypoints:[]};for(let s=0;s<n.length;s++)i.categories.push({score:n[s],index:e[s]??-1,categoryName:r[s]??"",displayName:o[s]??""});if((n=x(t,wr,4)?.l())&&(i.boundingBox={originX:bt(n,1,$t)??0,originY:bt(n,2,$t)??0,width:bt(n,3,$t)??0,height:bt(n,4,$t)??0,angle:0}),x(t,wr,4)?.g().length)for(let s of x(t,wr,4).g())i.keypoints.push({x:P(s,1,void 0,$t,Pt)??0,y:P(s,2,void 0,$t,Pt)??0,score:P(s,4,void 0,$t,Pt)??0,label:$(P(s,3,void 0,$t))??""});return i}function lr(t){let n=[];for(let e of Ht(t,Ra,1))n.push({x:B(e,1)??0,y:B(e,2)??0,z:B(e,3)??0,visibility:B(e,4)??0});return n}function le(t){let n=[];for(let e of Ht(t,Aa,1))n.push({x:B(e,1)??0,y:B(e,2)??0,z:B(e,3)??0,visibility:B(e,4)??0});return n}function Bo(t){return Array.from(t,(n=>n>127?n-256:n))}function No(t,n){if(t.length!==n.length)throw Error(`Cannot compute cosine similarity between embeddings of different sizes (${t.length} vs. ${n.length}).`);let e=0,r=0,o=0;for(let i=0;i<t.length;i++)e+=t[i]*n[i],r+=t[i]*t[i],o+=n[i]*n[i];if(r<=0||o<=0)throw Error("Cannot compute cosine similarity on embedding with 0 norm.");return e/Math.sqrt(r*o)}var Le;j[516587230]=[0,G,Fi,Nr,O],j[518928384]=Nr;var s2=new Uint8Array([0,97,115,109,1,0,0,0,1,5,1,96,0,1,123,3,2,1,0,10,10,1,8,0,65,0,253,15,253,98,11]);async function Qa(t){if(t)return!0;if(Le===void 0)try{await WebAssembly.instantiate(s2),Le=!0}catch{Le=!1}return Le}async function Ue(t,n,e){return{wasmLoaderPath:`${n}/${t}_${e=`wasm${e?"_module":""}${await Qa(e)?"":"_nosimd"}_internal`}.js`,wasmBinaryPath:`${n}/${t}_${e}.wasm`}}var an=class{};function Za(){var t=navigator;return typeof OffscreenCanvas<"u"&&(!(function(n=navigator){return(n=n.userAgent).includes("Safari")&&!n.includes("Chrome")})(t)||!!((t=t.userAgent.match(/Version\/([\d]+).*Safari/))&&t.length>=1&&Number(t[1])>=17))}async function Oo(t){if(typeof importScripts!="function"){let n=document.createElement("script");return n.src=t.toString(),n.crossOrigin="anonymous",new Promise(((e,r)=>{n.addEventListener("load",(()=>{e()}),!1),n.addEventListener("error",(o=>{r(o)}),!1),document.body.appendChild(n)}))}try{importScripts(t.toString())}catch(n){if(!(n instanceof TypeError))throw n;{let e=self.import;e?await e(t.toString()):await import(t.toString())}}}function Ja(t){return t.videoWidth!==void 0?[t.videoWidth,t.videoHeight]:t.naturalWidth!==void 0?[t.naturalWidth,t.naturalHeight]:t.displayWidth!==void 0?[t.displayWidth,t.displayHeight]:[t.width,t.height]}function m(t,n,e){t.m||console.error("No wasm multistream support detected: ensure dependency inclusion of :gl_graph_runner_internal_multi_input target"),e(n=t.i.stringToNewUTF8(n)),t.i._free(n)}function Go(t,n,e){if(!t.i.canvas)throw Error("No OpenGL canvas configured.");if(e?t.i._bindTextureToStream(e):t.i._bindTextureToCanvas(),!(e=t.i.canvas.getContext("webgl2")||t.i.canvas.getContext("webgl")))throw Error("Failed to obtain WebGL context from the provided canvas. `getContext()` should only be invoked with `webgl` or `webgl2`.");t.i.gpuOriginForWebTexturesIsBottomLeft&&e.pixelStorei(e.UNPACK_FLIP_Y_WEBGL,!0),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,e.RGBA,e.UNSIGNED_BYTE,n),t.i.gpuOriginForWebTexturesIsBottomLeft&&e.pixelStorei(e.UNPACK_FLIP_Y_WEBGL,!1);let[r,o]=Ja(n);return!t.l||r===t.i.canvas.width&&o===t.i.canvas.height||(t.i.canvas.width=r,t.i.canvas.height=o),[r,o]}function Xo(t,n,e){t.m||console.error("No wasm multistream support detected: ensure dependency inclusion of :gl_graph_runner_internal_multi_input target");let r=new Uint32Array(n.length);for(let o=0;o<n.length;o++)r[o]=t.i.stringToNewUTF8(n[o]);n=t.i._malloc(4*r.length),t.i.HEAPU32.set(r,n>>2),e(n);for(let o of r)t.i._free(o);t.i._free(n)}function Lt(t,n,e){t.i.simpleListeners=t.i.simpleListeners||{},t.i.simpleListeners[n]=e}function qt(t,n,e){let r=[];t.i.simpleListeners=t.i.simpleListeners||{},t.i.simpleListeners[n]=(o,i,s)=>{i?(e(r,s),r=[]):r.push(o)}}an.forVisionTasks=function(t,n=!1){return Ue("vision",t??Se``,n)},an.forTextTasks=function(t,n=!1){return Ue("text",t??Se``,n)},an.forGenAiTasks=function(t,n=!1){return Ue("genai",t??Se``,n)},an.forAudioTasks=function(t,n=!1){return Ue("audio",t??Se``,n)},an.isSimdSupported=function(t=!1){return Qa(t)};async function a2(t,n,e,r){return t=await(async(o,i,s,a,c)=>{if(i&&await Oo(i),!self.ModuleFactory||s&&(await Oo(s),!self.ModuleFactory))throw Error("ModuleFactory not set.");return self.Module&&c&&((i=self.Module).locateFile=c.locateFile,c.mainScriptUrlOrBlob&&(i.mainScriptUrlOrBlob=c.mainScriptUrlOrBlob)),c=await self.ModuleFactory(self.Module||c),self.ModuleFactory=self.Module=void 0,new o(c,a)})(t,e.wasmLoaderPath,e.assetLoaderPath,n,{locateFile:o=>o.endsWith(".wasm")?e.wasmBinaryPath.toString():e.assetBinaryPath&&o.endsWith(".data")?e.assetBinaryPath.toString():o}),await t.o(r),t}function Rr(t,n){let e=x(t.baseOptions,je,1)||new je;typeof n=="string"?(R(e,2,be(n)),R(e,1)):n instanceof Uint8Array&&(R(e,1,qr(n,!1)),R(e,2)),E(t.baseOptions,0,1,e)}function Vo(t){try{let n=t.H.length;if(n===1)throw Error(t.H[0].message);if(n>1)throw Error("Encountered multiple errors: "+t.H.map((e=>e.message)).join(", "))}finally{t.H=[]}}function d(t,n){t.C=Math.max(t.C,n)}function dr(t,n){t.B=new ot,gt(t.B,2,"PassThroughCalculator"),U(t.B,"free_memory"),b(t.B,"free_memory_unused_out"),C(n,"free_memory"),xt(n,t.B)}function Dn(t,n){U(t.B,n),b(t.B,n+"_unused_out")}function fr(t){t.g.addBoolToStream(!0,"free_memory",t.C)}var Xr=class{constructor(t){this.g=t,this.H=[],this.C=0,this.g.setAutoRenderToScreen(!1)}l(t,n=!0){if(n){let e=t.baseOptions||{};if(t.baseOptions?.modelAssetBuffer&&t.baseOptions?.modelAssetPath)throw Error("Cannot set both baseOptions.modelAssetPath and baseOptions.modelAssetBuffer");if(!(x(this.baseOptions,je,1)?.g()||x(this.baseOptions,je,1)?.l()||t.baseOptions?.modelAssetBuffer||t.baseOptions?.modelAssetPath))throw Error("Either baseOptions.modelAssetPath or baseOptions.modelAssetBuffer must be set");if((function(r,o){let i=x(r.baseOptions,Io,3);if(!i){var s=i=new Io,a=new ko;ue(s,4,Ce,a)}"delegate"in o&&(o.delegate==="GPU"?(o=i,s=new Iu,ue(o,2,Ce,s)):(o=i,s=new ko,ue(o,4,Ce,s))),E(r.baseOptions,0,3,i)})(this,e),e.modelAssetPath)return fetch(e.modelAssetPath.toString()).then((r=>{if(r.ok)return r.arrayBuffer();throw Error(`Failed to fetch model: ${e.modelAssetPath} (${r.status})`)})).then((r=>{try{this.g.i.FS_unlink("/model.dat")}catch{}this.g.i.FS_createDataFile("/","model.dat",new Uint8Array(r),!0,!1,!1),Rr(this,"/model.dat"),this.m(),this.L()}));if(e.modelAssetBuffer instanceof Uint8Array)Rr(this,e.modelAssetBuffer);else if(e.modelAssetBuffer)return(async function(r){let o=[];for(var i=0;;){let{done:s,value:a}=await r.read();if(s)break;o.push(a),i+=a.length}if(o.length===0)return new Uint8Array(0);if(o.length===1)return o[0];r=new Uint8Array(i),i=0;for(let s of o)r.set(s,i),i+=s.length;return r})(e.modelAssetBuffer).then((r=>{Rr(this,r),this.m(),this.L()}))}return this.m(),this.L(),Promise.resolve()}L(){}ca(){let t;if(this.g.ca((n=>{t=Cu(n)})),!t)throw Error("Failed to retrieve CalculatorGraphConfig");return t}setGraph(t,n){this.g.attachErrorListener(((e,r)=>{this.H.push(Error(r))})),this.g.Ja(),this.g.setGraph(t,n),this.B=void 0,Vo(this)}finishProcessing(){this.g.finishProcessing(),Vo(this)}close(){this.B=void 0,this.g.closeGraph()}};function rt(t,n){if(!t)throw Error(`Unable to obtain required WebGL resource: ${n}`);return t}Xr.prototype.close=Xr.prototype.close;var Vr=class{constructor(n,e,r,o){this.g=n,this.h=e,this.m=r,this.l=o}bind(){this.g.bindVertexArray(this.h)}close(){this.g.deleteVertexArray(this.h),this.g.deleteBuffer(this.m),this.g.deleteBuffer(this.l)}};function Wo(t,n,e){let r=t.g;if(e=rt(r.createShader(e),"Failed to create WebGL shader"),r.shaderSource(e,n),r.compileShader(e),!r.getShaderParameter(e,r.COMPILE_STATUS))throw Error(`Could not compile WebGL shader: ${r.getShaderInfoLog(e)}`);return r.attachShader(t.h,e),e}function jo(t,n){let e=t.g,r=rt(e.createVertexArray(),"Failed to create vertex array");e.bindVertexArray(r);let o=rt(e.createBuffer(),"Failed to create buffer");e.bindBuffer(e.ARRAY_BUFFER,o),e.enableVertexAttribArray(t.O),e.vertexAttribPointer(t.O,2,e.FLOAT,!1,0,0),e.bufferData(e.ARRAY_BUFFER,new Float32Array([-1,-1,-1,1,1,1,1,-1]),e.STATIC_DRAW);let i=rt(e.createBuffer(),"Failed to create buffer");return e.bindBuffer(e.ARRAY_BUFFER,i),e.enableVertexAttribArray(t.L),e.vertexAttribPointer(t.L,2,e.FLOAT,!1,0,0),e.bufferData(e.ARRAY_BUFFER,new Float32Array(n?[0,1,0,0,1,0,1,1]:[0,0,0,1,1,1,1,0]),e.STATIC_DRAW),e.bindBuffer(e.ARRAY_BUFFER,null),e.bindVertexArray(null),new Vr(e,r,o,i)}function Ci(t,n){if(t.g){if(n!==t.g)throw Error("Cannot change GL context once initialized")}else t.g=n}function Ae(t,n,e,r){return Ci(t,n),t.h||(t.m(),t.D()),e?(t.u||(t.u=jo(t,!0)),e=t.u):(t.A||(t.A=jo(t,!1)),e=t.A),n.useProgram(t.h),e.bind(),t.l(),t=r(),e.g.bindVertexArray(null),t}function nn(t,n,e){return Ci(t,n),t=rt(n.createTexture(),"Failed to create texture"),n.bindTexture(n.TEXTURE_2D,t),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_S,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_T,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MIN_FILTER,e??n.LINEAR),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MAG_FILTER,e??n.LINEAR),n.bindTexture(n.TEXTURE_2D,null),t}function gr(t,n,e){Ci(t,n),t.B||(t.B=rt(n.createFramebuffer(),"Failed to create framebuffe.")),n.bindFramebuffer(n.FRAMEBUFFER,t.B),n.framebufferTexture2D(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,e,0)}function Di(t){t.g?.bindFramebuffer(t.g.FRAMEBUFFER,null)}var Qn=class{H(){return`
  precision mediump float;
  varying vec2 vTex;
  uniform sampler2D inputTexture;
  void main() {
    gl_FragColor = texture2D(inputTexture, vTex);
  }
 `}m(){let t=this.g;if(this.h=rt(t.createProgram(),"Failed to create WebGL program"),this.X=Wo(this,`
  attribute vec2 aVertex;
  attribute vec2 aTex;
  varying vec2 vTex;
  void main(void) {
    gl_Position = vec4(aVertex, 0.0, 1.0);
    vTex = aTex;
  }`,t.VERTEX_SHADER),this.W=Wo(this,this.H(),t.FRAGMENT_SHADER),t.linkProgram(this.h),!t.getProgramParameter(this.h,t.LINK_STATUS))throw Error(`Error during program linking: ${t.getProgramInfoLog(this.h)}`);this.O=t.getAttribLocation(this.h,"aVertex"),this.L=t.getAttribLocation(this.h,"aTex")}D(){}l(){}close(){if(this.h){let t=this.g;t.deleteProgram(this.h),t.deleteShader(this.X),t.deleteShader(this.W)}this.B&&this.g.deleteFramebuffer(this.B),this.A&&this.A.close(),this.u&&this.u.close()}},c2=class extends Qn{H(){return`
  precision mediump float;
  uniform sampler2D backgroundTexture;
  uniform sampler2D maskTexture;
  uniform sampler2D colorMappingTexture;
  varying vec2 vTex;
  void main() {
    vec4 backgroundColor = texture2D(backgroundTexture, vTex);
    float category = texture2D(maskTexture, vTex).r;
    vec4 categoryColor = texture2D(colorMappingTexture, vec2(category, 0.0));
    gl_FragColor = mix(backgroundColor, categoryColor, categoryColor.a);
  }
 `}D(){let t=this.g;t.activeTexture(t.TEXTURE1),this.C=nn(this,t,t.LINEAR),t.activeTexture(t.TEXTURE2),this.j=nn(this,t,t.NEAREST)}m(){super.m();let t=this.g;this.P=rt(t.getUniformLocation(this.h,"backgroundTexture"),"Uniform location"),this.U=rt(t.getUniformLocation(this.h,"colorMappingTexture"),"Uniform location"),this.M=rt(t.getUniformLocation(this.h,"maskTexture"),"Uniform location")}l(){super.l();let t=this.g;t.uniform1i(this.M,0),t.uniform1i(this.P,1),t.uniform1i(this.U,2)}close(){this.C&&this.g.deleteTexture(this.C),this.j&&this.g.deleteTexture(this.j),super.close()}},u2=class extends Qn{H(){return`
  precision mediump float;
  uniform sampler2D maskTexture;
  uniform sampler2D defaultTexture;
  uniform sampler2D overlayTexture;
  varying vec2 vTex;
  void main() {
    float confidence = texture2D(maskTexture, vTex).r;
    vec4 defaultColor = texture2D(defaultTexture, vTex);
    vec4 overlayColor = texture2D(overlayTexture, vTex);
    // Apply the alpha from the overlay and merge in the default color
    overlayColor = mix(defaultColor, overlayColor, overlayColor.a);
    gl_FragColor = mix(defaultColor, overlayColor, confidence);
  }
 `}D(){let t=this.g;t.activeTexture(t.TEXTURE1),this.j=nn(this,t),t.activeTexture(t.TEXTURE2),this.C=nn(this,t)}m(){super.m();let t=this.g;this.M=rt(t.getUniformLocation(this.h,"defaultTexture"),"Uniform location"),this.P=rt(t.getUniformLocation(this.h,"overlayTexture"),"Uniform location"),this.I=rt(t.getUniformLocation(this.h,"maskTexture"),"Uniform location")}l(){super.l();let t=this.g;t.uniform1i(this.I,0),t.uniform1i(this.M,1),t.uniform1i(this.P,2)}close(){this.j&&this.g.deleteTexture(this.j),this.C&&this.g.deleteTexture(this.C),super.close()}};function Vt(t,n){switch(n){case 0:return t.g.find((e=>e instanceof Uint8Array));case 1:return t.g.find((e=>e instanceof Float32Array));case 2:return t.g.find((e=>typeof WebGLTexture<"u"&&e instanceof WebGLTexture));default:throw Error(`Type is not supported: ${n}`)}}function Wr(t){var n=Vt(t,1);if(!n){if(n=Vt(t,0))n=new Float32Array(n).map((r=>r/255));else{n=new Float32Array(t.width*t.height);let r=Mn(t);var e=Mi(t);if(gr(e,r,tc(t)),"iPad Simulator;iPhone Simulator;iPod Simulator;iPad;iPhone;iPod".split(";").includes(navigator.platform)||navigator.userAgent.includes("Mac")&&"document"in self&&"ontouchend"in self.document){e=new Float32Array(t.width*t.height*4),r.readPixels(0,0,t.width,t.height,r.RGBA,r.FLOAT,e);for(let o=0,i=0;o<n.length;++o,i+=4)n[o]=e[i]}else r.readPixels(0,0,t.width,t.height,r.RED,r.FLOAT,n)}t.g.push(n)}return n}function tc(t){let n=Vt(t,2);if(!n){let e=Mn(t);n=ec(t);let r=Wr(t),o=nc(t);e.texImage2D(e.TEXTURE_2D,0,o,t.width,t.height,0,e.RED,e.FLOAT,r),jr(t)}return n}function Mn(t){if(!t.canvas)throw Error("Conversion to different image formats require that a canvas is passed when initializing the image.");return t.h||(t.h=rt(t.canvas.getContext("webgl2"),"You cannot use a canvas that is already bound to a different type of rendering context.")),t.h}function nc(t){if(t=Mn(t),!Fe)if(t.getExtension("EXT_color_buffer_float")&&t.getExtension("OES_texture_float_linear")&&t.getExtension("EXT_float_blend"))Fe=t.R32F;else{if(!t.getExtension("EXT_color_buffer_half_float"))throw Error("GPU does not fully support 4-channel float32 or float16 formats");Fe=t.R16F}return Fe}function Mi(t){return t.l||(t.l=new Qn),t.l}function ec(t){let n=Mn(t);n.viewport(0,0,t.width,t.height),n.activeTexture(n.TEXTURE0);let e=Vt(t,2);return e||(e=nn(Mi(t),n,t.m?n.LINEAR:n.NEAREST),t.g.push(e),t.j=!0),n.bindTexture(n.TEXTURE_2D,e),e}function jr(t){t.h.bindTexture(t.h.TEXTURE_2D,null)}var Fe,X=class{constructor(t,n,e,r,o,i,s){this.g=t,this.m=n,this.j=e,this.canvas=r,this.l=o,this.width=i,this.height=s,this.j&&--Ho===0&&console.error("You seem to be creating MPMask instances without invoking .close(). This leaks resources.")}Fa(){return!!Vt(this,0)}ka(){return!!Vt(this,1)}R(){return!!Vt(this,2)}ja(){return(n=Vt(t=this,0))||(n=Wr(t),n=new Uint8Array(n.map((e=>Math.round(255*e)))),t.g.push(n)),n;var t,n}ia(){return Wr(this)}N(){return tc(this)}clone(){let t=[];for(let n of this.g){let e;if(n instanceof Uint8Array)e=new Uint8Array(n);else if(n instanceof Float32Array)e=new Float32Array(n);else{if(!(n instanceof WebGLTexture))throw Error(`Type is not supported: ${n}`);{let r=Mn(this),o=Mi(this);r.activeTexture(r.TEXTURE1),e=nn(o,r,this.m?r.LINEAR:r.NEAREST),r.bindTexture(r.TEXTURE_2D,e);let i=nc(this);r.texImage2D(r.TEXTURE_2D,0,i,this.width,this.height,0,r.RED,r.FLOAT,null),r.bindTexture(r.TEXTURE_2D,null),gr(o,r,e),Ae(o,r,!1,(()=>{ec(this),r.clearColor(0,0,0,0),r.clear(r.COLOR_BUFFER_BIT),r.drawArrays(r.TRIANGLE_FAN,0,4),jr(this)})),Di(o),jr(this)}}t.push(e)}return new X(t,this.m,this.R(),this.canvas,this.l,this.width,this.height)}close(){this.j&&Mn(this).deleteTexture(Vt(this,2)),Ho=-1}};X.prototype.close=X.prototype.close,X.prototype.clone=X.prototype.clone,X.prototype.getAsWebGLTexture=X.prototype.N,X.prototype.getAsFloat32Array=X.prototype.ia,X.prototype.getAsUint8Array=X.prototype.ja,X.prototype.hasWebGLTexture=X.prototype.R,X.prototype.hasFloat32Array=X.prototype.ka,X.prototype.hasUint8Array=X.prototype.Fa;var Ho=250,h2={color:"white",lineWidth:4,radius:6};function kr(t){return{...h2,fillColor:(t=t||{}).color,...t}}function Xt(t,n){return t instanceof Function?t(n):t}function Yo(t,n,e){return Math.max(Math.min(n,e),Math.min(Math.max(n,e),t))}function ie(t){if(!t.l)throw Error("CPU rendering requested but CanvasRenderingContext2D not provided.");return t.l}function pe(t){if(!t.j)throw Error("GPU rendering requested but WebGL2RenderingContext not provided.");return t.j}function zo(t,n,e){if(n.R())e(n.N());else{let r=n.ka()?n.ia():n.ja();t.m=t.m??new Qn;let o=pe(t);e((t=new X([r],n.m,!1,o.canvas,t.m,n.width,n.height)).N()),t.close()}}function Ko(t,n,e,r){let o=(function(a){return a.g||(a.g=new c2),a.g})(t),i=pe(t),s=Array.isArray(e)?new ImageData(new Uint8ClampedArray(e),1,1):e;Ae(o,i,!0,(()=>{(function(c,l,u,p){let h=c.g;if(h.activeTexture(h.TEXTURE0),h.bindTexture(h.TEXTURE_2D,l),h.activeTexture(h.TEXTURE1),h.bindTexture(h.TEXTURE_2D,c.C),h.texImage2D(h.TEXTURE_2D,0,h.RGBA,h.RGBA,h.UNSIGNED_BYTE,u),c.I&&(function(v,_){if(v!==_)return!1;v=v.entries(),_=_.entries();for(let[Y,A]of v){v=Y;let st=A,Gt=_.next();if(Gt.done)return!1;let[zt,Kt]=Gt.value;if(v!==zt||st[0]!==Kt[0]||st[1]!==Kt[1]||st[2]!==Kt[2]||st[3]!==Kt[3])return!1}return!!_.next().done})(c.I,p))h.activeTexture(h.TEXTURE2),h.bindTexture(h.TEXTURE_2D,c.j);else{c.I=p;let v=Array(1024).fill(0);p.forEach(((_,Y)=>{if(_.length!==4)throw Error(`Color at index ${Y} is not a four-channel value.`);v[4*Y]=_[0],v[4*Y+1]=_[1],v[4*Y+2]=_[2],v[4*Y+3]=_[3]})),h.activeTexture(h.TEXTURE2),h.bindTexture(h.TEXTURE_2D,c.j),h.texImage2D(h.TEXTURE_2D,0,h.RGBA,256,1,0,h.RGBA,h.UNSIGNED_BYTE,new Uint8Array(v))}})(o,n,s,r),i.clearColor(0,0,0,0),i.clear(i.COLOR_BUFFER_BIT),i.drawArrays(i.TRIANGLE_FAN,0,4);let a=o.g;a.activeTexture(a.TEXTURE0),a.bindTexture(a.TEXTURE_2D,null),a.activeTexture(a.TEXTURE1),a.bindTexture(a.TEXTURE_2D,null),a.activeTexture(a.TEXTURE2),a.bindTexture(a.TEXTURE_2D,null)}))}function $o(t,n,e,r){let o=pe(t),i=(function(c){return c.h||(c.h=new u2),c.h})(t),s=Array.isArray(e)?new ImageData(new Uint8ClampedArray(e),1,1):e,a=Array.isArray(r)?new ImageData(new Uint8ClampedArray(r),1,1):r;Ae(i,o,!0,(()=>{var c=i.g;c.activeTexture(c.TEXTURE0),c.bindTexture(c.TEXTURE_2D,n),c.activeTexture(c.TEXTURE1),c.bindTexture(c.TEXTURE_2D,i.j),c.texImage2D(c.TEXTURE_2D,0,c.RGBA,c.RGBA,c.UNSIGNED_BYTE,s),c.activeTexture(c.TEXTURE2),c.bindTexture(c.TEXTURE_2D,i.C),c.texImage2D(c.TEXTURE_2D,0,c.RGBA,c.RGBA,c.UNSIGNED_BYTE,a),o.clearColor(0,0,0,0),o.clear(o.COLOR_BUFFER_BIT),o.drawArrays(o.TRIANGLE_FAN,0,4),o.bindTexture(o.TEXTURE_2D,null),(c=i.g).activeTexture(c.TEXTURE0),c.bindTexture(c.TEXTURE_2D,null),c.activeTexture(c.TEXTURE1),c.bindTexture(c.TEXTURE_2D,null),c.activeTexture(c.TEXTURE2),c.bindTexture(c.TEXTURE_2D,null)}))}var it=class{constructor(t,n){typeof CanvasRenderingContext2D<"u"&&t instanceof CanvasRenderingContext2D||t instanceof OffscreenCanvasRenderingContext2D?(this.l=t,this.j=n):this.j=t}ya(t,n){if(t){var e=ie(this);n=kr(n),e.save();var r=e.canvas,o=0;for(let i of t)e.fillStyle=Xt(n.fillColor,{index:o,from:i}),e.strokeStyle=Xt(n.color,{index:o,from:i}),e.lineWidth=Xt(n.lineWidth,{index:o,from:i}),(t=new Path2D).arc(i.x*r.width,i.y*r.height,Xt(n.radius,{index:o,from:i}),0,2*Math.PI),e.fill(t),e.stroke(t),++o;e.restore()}}xa(t,n,e){if(t&&n){var r=ie(this);e=kr(e),r.save();var o=r.canvas,i=0;for(let s of n){r.beginPath(),n=t[s.start];let a=t[s.end];n&&a&&(r.strokeStyle=Xt(e.color,{index:i,from:n,to:a}),r.lineWidth=Xt(e.lineWidth,{index:i,from:n,to:a}),r.moveTo(n.x*o.width,n.y*o.height),r.lineTo(a.x*o.width,a.y*o.height)),++i,r.stroke()}r.restore()}}ua(t,n){let e=ie(this);n=kr(n),e.save(),e.beginPath(),e.lineWidth=Xt(n.lineWidth,{}),e.strokeStyle=Xt(n.color,{}),e.fillStyle=Xt(n.fillColor,{}),e.moveTo(t.originX,t.originY),e.lineTo(t.originX+t.width,t.originY),e.lineTo(t.originX+t.width,t.originY+t.height),e.lineTo(t.originX,t.originY+t.height),e.lineTo(t.originX,t.originY),e.stroke(),e.fill(),e.restore()}va(t,n,e=[0,0,0,255]){this.l?(function(r,o,i,s){let a=pe(r);zo(r,o,(c=>{Ko(r,c,i,s),(c=ie(r)).drawImage(a.canvas,0,0,c.canvas.width,c.canvas.height)}))})(this,t,e,n):Ko(this,t.N(),e,n)}wa(t,n,e){this.l?(function(r,o,i,s){let a=pe(r);zo(r,o,(c=>{$o(r,c,i,s),(c=ie(r)).drawImage(a.canvas,0,0,c.canvas.width,c.canvas.height)}))})(this,t,n,e):$o(this,t.N(),n,e)}close(){this.g?.close(),this.g=void 0,this.h?.close(),this.h=void 0,this.m?.close(),this.m=void 0}};function Ft(t,n){switch(n){case 0:return t.g.find((e=>e instanceof ImageData));case 1:return t.g.find((e=>typeof ImageBitmap<"u"&&e instanceof ImageBitmap));case 2:return t.g.find((e=>typeof WebGLTexture<"u"&&e instanceof WebGLTexture));default:throw Error(`Type is not supported: ${n}`)}}function rc(t){var n=Ft(t,0);if(!n){n=Bn(t);let e=mr(t),r=new Uint8Array(t.width*t.height*4);gr(e,n,De(t)),n.readPixels(0,0,t.width,t.height,n.RGBA,n.UNSIGNED_BYTE,r),Di(e),n=new ImageData(new Uint8ClampedArray(r.buffer),t.width,t.height),t.g.push(n)}return n}function De(t){let n=Ft(t,2);if(!n){let e=Bn(t);n=Me(t);let r=Ft(t,1)||rc(t);e.texImage2D(e.TEXTURE_2D,0,e.RGBA,e.RGBA,e.UNSIGNED_BYTE,r),ae(t)}return n}function Bn(t){if(!t.canvas)throw Error("Conversion to different image formats require that a canvas is passed when initializing the image.");return t.h||(t.h=rt(t.canvas.getContext("webgl2"),"You cannot use a canvas that is already bound to a different type of rendering context.")),t.h}function mr(t){return t.l||(t.l=new Qn),t.l}function Me(t){let n=Bn(t);n.viewport(0,0,t.width,t.height),n.activeTexture(n.TEXTURE0);let e=Ft(t,2);return e||(e=nn(mr(t),n),t.g.push(e),t.m=!0),n.bindTexture(n.TEXTURE_2D,e),e}function ae(t){t.h.bindTexture(t.h.TEXTURE_2D,null)}function qo(t){let n=Bn(t);return Ae(mr(t),n,!0,(()=>(function(e,r){let o=e.canvas;if(o.width===e.width&&o.height===e.height)return r();let i=o.width,s=o.height;return o.width=e.width,o.height=e.height,e=r(),o.width=i,o.height=s,e})(t,(()=>{if(n.bindFramebuffer(n.FRAMEBUFFER,null),n.clearColor(0,0,0,0),n.clear(n.COLOR_BUFFER_BIT),n.drawArrays(n.TRIANGLE_FAN,0,4),!(t.canvas instanceof OffscreenCanvas))throw Error("Conversion to ImageBitmap requires that the MediaPipe Tasks is initialized with an OffscreenCanvas");return t.canvas.transferToImageBitmap()}))))}it.prototype.close=it.prototype.close,it.prototype.drawConfidenceMask=it.prototype.wa,it.prototype.drawCategoryMask=it.prototype.va,it.prototype.drawBoundingBox=it.prototype.ua,it.prototype.drawConnectors=it.prototype.xa,it.prototype.drawLandmarks=it.prototype.ya,it.lerp=function(t,n,e,r,o){return Yo(r*(1-(t-n)/(e-n))+o*(1-(e-t)/(e-n)),r,o)},it.clamp=Yo;var K=class{constructor(t,n,e,r,o,i,s){this.g=t,this.j=n,this.m=e,this.canvas=r,this.l=o,this.width=i,this.height=s,(this.j||this.m)&&--Qo===0&&console.error("You seem to be creating MPImage instances without invoking .close(). This leaks resources.")}Ea(){return!!Ft(this,0)}la(){return!!Ft(this,1)}R(){return!!Ft(this,2)}Ca(){return rc(this)}Ba(){var t=Ft(this,1);return t||(De(this),Me(this),t=qo(this),ae(this),this.g.push(t),this.j=!0),t}N(){return De(this)}clone(){let t=[];for(let n of this.g){let e;if(n instanceof ImageData)e=new ImageData(n.data,this.width,this.height);else if(n instanceof WebGLTexture){let r=Bn(this),o=mr(this);r.activeTexture(r.TEXTURE1),e=nn(o,r),r.bindTexture(r.TEXTURE_2D,e),r.texImage2D(r.TEXTURE_2D,0,r.RGBA,this.width,this.height,0,r.RGBA,r.UNSIGNED_BYTE,null),r.bindTexture(r.TEXTURE_2D,null),gr(o,r,e),Ae(o,r,!1,(()=>{Me(this),r.clearColor(0,0,0,0),r.clear(r.COLOR_BUFFER_BIT),r.drawArrays(r.TRIANGLE_FAN,0,4),ae(this)})),Di(o),ae(this)}else{if(!(n instanceof ImageBitmap))throw Error(`Type is not supported: ${n}`);De(this),Me(this),e=qo(this),ae(this)}t.push(e)}return new K(t,this.la(),this.R(),this.canvas,this.l,this.width,this.height)}close(){this.j&&Ft(this,1).close(),this.m&&Bn(this).deleteTexture(Ft(this,2)),Qo=-1}};K.prototype.close=K.prototype.close,K.prototype.clone=K.prototype.clone,K.prototype.getAsWebGLTexture=K.prototype.N,K.prototype.getAsImageBitmap=K.prototype.Ba,K.prototype.getAsImageData=K.prototype.Ca,K.prototype.hasWebGLTexture=K.prototype.R,K.prototype.hasImageBitmap=K.prototype.la,K.prototype.hasImageData=K.prototype.Ea;var Qo=250;function At(...t){return t.map((([n,e])=>({start:n,end:e})))}var l2=(function(t){return class extends t{Ja(){this.i._registerModelResourcesGraphService()}}})((Zo=class{constructor(t,n){this.l=!0,this.i=t,this.g=null,this.h=0,this.m=typeof this.i._addIntToInputStream=="function",n!==void 0?this.i.canvas=n:Za()?this.i.canvas=new OffscreenCanvas(1,1):(console.warn("OffscreenCanvas not supported and GraphRunner constructor glCanvas parameter is undefined. Creating backup canvas."),this.i.canvas=document.createElement("canvas"))}async initializeGraph(t){let n=await(await fetch(t)).arrayBuffer();t=!(t.endsWith(".pbtxt")||t.endsWith(".textproto")),this.setGraph(new Uint8Array(n),t)}setGraphFromString(t){this.setGraph(new TextEncoder().encode(t),!1)}setGraph(t,n){let e=t.length,r=this.i._malloc(e);this.i.HEAPU8.set(t,r),n?this.i._changeBinaryGraph(e,r):this.i._changeTextGraph(e,r),this.i._free(r)}configureAudio(t,n,e,r,o){this.i._configureAudio||console.warn('Attempting to use configureAudio without support for input audio. Is build dep ":gl_graph_runner_audio" missing?'),m(this,r||"input_audio",(i=>{m(this,o=o||"audio_header",(s=>{this.i._configureAudio(i,s,t,n??0,e)}))}))}setAutoResizeCanvas(t){this.l=t}setAutoRenderToScreen(t){this.i._setAutoRenderToScreen(t)}setGpuBufferVerticalFlip(t){this.i.gpuOriginForWebTexturesIsBottomLeft=t}ca(t){Lt(this,"__graph_config__",(n=>{t(n)})),m(this,"__graph_config__",(n=>{this.i._getGraphConfig(n,void 0)})),delete this.i.simpleListeners.__graph_config__}attachErrorListener(t){this.i.errorListener=t}attachEmptyPacketListener(t,n){this.i.emptyPacketListeners=this.i.emptyPacketListeners||{},this.i.emptyPacketListeners[t]=n}addAudioToStream(t,n,e){this.addAudioToStreamWithShape(t,0,0,n,e)}addAudioToStreamWithShape(t,n,e,r,o){let i=4*t.length;this.h!==i&&(this.g&&this.i._free(this.g),this.g=this.i._malloc(i),this.h=i),this.i.HEAPF32.set(t,this.g/4),m(this,r,(s=>{this.i._addAudioToInputStream(this.g,n,e,s,o)}))}addGpuBufferToStream(t,n,e){m(this,n,(r=>{let[o,i]=Go(this,t,r);this.i._addBoundTextureToStream(r,o,i,e)}))}addBoolToStream(t,n,e){m(this,n,(r=>{this.i._addBoolToInputStream(t,r,e)}))}addDoubleToStream(t,n,e){m(this,n,(r=>{this.i._addDoubleToInputStream(t,r,e)}))}addFloatToStream(t,n,e){m(this,n,(r=>{this.i._addFloatToInputStream(t,r,e)}))}addIntToStream(t,n,e){m(this,n,(r=>{this.i._addIntToInputStream(t,r,e)}))}addUintToStream(t,n,e){m(this,n,(r=>{this.i._addUintToInputStream(t,r,e)}))}addStringToStream(t,n,e){m(this,n,(r=>{m(this,t,(o=>{this.i._addStringToInputStream(o,r,e)}))}))}addStringRecordToStream(t,n,e){m(this,n,(r=>{Xo(this,Object.keys(t),(o=>{Xo(this,Object.values(t),(i=>{this.i._addFlatHashMapToInputStream(o,i,Object.keys(t).length,r,e)}))}))}))}addProtoToStream(t,n,e,r){m(this,e,(o=>{m(this,n,(i=>{let s=this.i._malloc(t.length);this.i.HEAPU8.set(t,s),this.i._addProtoToInputStream(s,t.length,i,o,r),this.i._free(s)}))}))}addEmptyPacketToStream(t,n){m(this,t,(e=>{this.i._addEmptyPacketToInputStream(e,n)}))}addBoolVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateBoolVector(t.length);if(!o)throw Error("Unable to allocate new bool vector on heap.");for(let i of t)this.i._addBoolVectorEntry(o,i);this.i._addBoolVectorToInputStream(o,r,e)}))}addDoubleVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateDoubleVector(t.length);if(!o)throw Error("Unable to allocate new double vector on heap.");for(let i of t)this.i._addDoubleVectorEntry(o,i);this.i._addDoubleVectorToInputStream(o,r,e)}))}addFloatVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateFloatVector(t.length);if(!o)throw Error("Unable to allocate new float vector on heap.");for(let i of t)this.i._addFloatVectorEntry(o,i);this.i._addFloatVectorToInputStream(o,r,e)}))}addIntVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateIntVector(t.length);if(!o)throw Error("Unable to allocate new int vector on heap.");for(let i of t)this.i._addIntVectorEntry(o,i);this.i._addIntVectorToInputStream(o,r,e)}))}addUintVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateUintVector(t.length);if(!o)throw Error("Unable to allocate new unsigned int vector on heap.");for(let i of t)this.i._addUintVectorEntry(o,i);this.i._addUintVectorToInputStream(o,r,e)}))}addStringVectorToStream(t,n,e){m(this,n,(r=>{let o=this.i._allocateStringVector(t.length);if(!o)throw Error("Unable to allocate new string vector on heap.");for(let i of t)m(this,i,(s=>{this.i._addStringVectorEntry(o,s)}));this.i._addStringVectorToInputStream(o,r,e)}))}addBoolToInputSidePacket(t,n){m(this,n,(e=>{this.i._addBoolToInputSidePacket(t,e)}))}addDoubleToInputSidePacket(t,n){m(this,n,(e=>{this.i._addDoubleToInputSidePacket(t,e)}))}addFloatToInputSidePacket(t,n){m(this,n,(e=>{this.i._addFloatToInputSidePacket(t,e)}))}addIntToInputSidePacket(t,n){m(this,n,(e=>{this.i._addIntToInputSidePacket(t,e)}))}addUintToInputSidePacket(t,n){m(this,n,(e=>{this.i._addUintToInputSidePacket(t,e)}))}addStringToInputSidePacket(t,n){m(this,n,(e=>{m(this,t,(r=>{this.i._addStringToInputSidePacket(r,e)}))}))}addProtoToInputSidePacket(t,n,e){m(this,e,(r=>{m(this,n,(o=>{let i=this.i._malloc(t.length);this.i.HEAPU8.set(t,i),this.i._addProtoToInputSidePacket(i,t.length,o,r),this.i._free(i)}))}))}addBoolVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateBoolVector(t.length);if(!r)throw Error("Unable to allocate new bool vector on heap.");for(let o of t)this.i._addBoolVectorEntry(r,o);this.i._addBoolVectorToInputSidePacket(r,e)}))}addDoubleVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateDoubleVector(t.length);if(!r)throw Error("Unable to allocate new double vector on heap.");for(let o of t)this.i._addDoubleVectorEntry(r,o);this.i._addDoubleVectorToInputSidePacket(r,e)}))}addFloatVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateFloatVector(t.length);if(!r)throw Error("Unable to allocate new float vector on heap.");for(let o of t)this.i._addFloatVectorEntry(r,o);this.i._addFloatVectorToInputSidePacket(r,e)}))}addIntVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateIntVector(t.length);if(!r)throw Error("Unable to allocate new int vector on heap.");for(let o of t)this.i._addIntVectorEntry(r,o);this.i._addIntVectorToInputSidePacket(r,e)}))}addUintVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateUintVector(t.length);if(!r)throw Error("Unable to allocate new unsigned int vector on heap.");for(let o of t)this.i._addUintVectorEntry(r,o);this.i._addUintVectorToInputSidePacket(r,e)}))}addStringVectorToInputSidePacket(t,n){m(this,n,(e=>{let r=this.i._allocateStringVector(t.length);if(!r)throw Error("Unable to allocate new string vector on heap.");for(let o of t)m(this,o,(i=>{this.i._addStringVectorEntry(r,i)}));this.i._addStringVectorToInputSidePacket(r,e)}))}attachBoolListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachBoolListener(e)}))}attachBoolVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachBoolVectorListener(e)}))}attachIntListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachIntListener(e)}))}attachIntVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachIntVectorListener(e)}))}attachUintListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachUintListener(e)}))}attachUintVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachUintVectorListener(e)}))}attachDoubleListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachDoubleListener(e)}))}attachDoubleVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachDoubleVectorListener(e)}))}attachFloatListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachFloatListener(e)}))}attachFloatVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachFloatVectorListener(e)}))}attachStringListener(t,n){Lt(this,t,n),m(this,t,(e=>{this.i._attachStringListener(e)}))}attachStringVectorListener(t,n){qt(this,t,n),m(this,t,(e=>{this.i._attachStringVectorListener(e)}))}attachProtoListener(t,n,e){Lt(this,t,n),m(this,t,(r=>{this.i._attachProtoListener(r,e||!1)}))}attachProtoVectorListener(t,n,e){qt(this,t,n),m(this,t,(r=>{this.i._attachProtoVectorListener(r,e||!1)}))}attachAudioListener(t,n,e){this.i._attachAudioListener||console.warn('Attempting to use attachAudioListener without support for output audio. Is build dep ":gl_graph_runner_audio_out" missing?'),Lt(this,t,((r,o)=>{r=new Float32Array(r.buffer,r.byteOffset,r.length/4),n(r,o)})),m(this,t,(r=>{this.i._attachAudioListener(r,e||!1)}))}finishProcessing(){this.i._waitUntilIdle()}closeGraph(){this.i._closeGraph(),this.i.simpleListeners=void 0,this.i.emptyPacketListeners=void 0}},class extends Zo{get ga(){return this.i}pa(t,n,e){m(this,n,(r=>{let[o,i]=Go(this,t,r);this.ga._addBoundTextureAsImageToStream(r,o,i,e)}))}Z(t,n){Lt(this,t,n),m(this,t,(e=>{this.ga._attachImageListener(e)}))}aa(t,n){qt(this,t,n),m(this,t,(e=>{this.ga._attachImageVectorListener(e)}))}})),Zo,Rt=class extends l2{};async function y(t,n,e){return(async function(r,o,i,s){return a2(r,o,i,s)})(t,e.canvas??(Za()?void 0:document.createElement("canvas")),n,e)}function ic(t,n,e,r){if(t.U){let i=new ka;if(e?.regionOfInterest){if(!t.oa)throw Error("This task doesn't support region-of-interest.");var o=e.regionOfInterest;if(o.left>=o.right||o.top>=o.bottom)throw Error("Expected RectF with left < right and top < bottom.");if(o.left<0||o.top<0||o.right>1||o.bottom>1)throw Error("Expected RectF values to be in [0,1].");T(i,1,(o.left+o.right)/2),T(i,2,(o.top+o.bottom)/2),T(i,4,o.right-o.left),T(i,3,o.bottom-o.top)}else T(i,1,.5),T(i,2,.5),T(i,4,1),T(i,3,1);if(e?.rotationDegrees){if(e?.rotationDegrees%90!=0)throw Error("Expected rotation to be a multiple of 90\xB0.");if(T(i,5,-Math.PI*e.rotationDegrees/180),e?.rotationDegrees%180!=0){let[s,a]=Ja(n);e=B(i,3)*a/s,o=B(i,4)*s/a,T(i,4,e),T(i,3,o)}}t.g.addProtoToStream(i.g(),"mediapipe.NormalizedRect",t.U,r)}t.g.pa(n,t.X,r??performance.now()),t.finishProcessing()}function kt(t,n,e){if(t.baseOptions?.g())throw Error("Task is not initialized with image mode. 'runningMode' must be set to 'IMAGE'.");ic(t,n,e,t.C+1)}function Ot(t,n,e,r){if(!t.baseOptions?.g())throw Error("Task is not initialized with video mode. 'runningMode' must be set to 'VIDEO'.");ic(t,n,e,r)}function Nn(t,n,e,r){var o=n.data;let i=n.width,s=i*(n=n.height);if((o instanceof Uint8Array||o instanceof Float32Array)&&o.length!==s)throw Error("Unsupported channel count: "+o.length/s);return t=new X([o],e,!1,t.g.i.canvas,t.P,i,n),r?t.clone():t}var mt=class extends Xr{constructor(t,n,e,r){super(t),this.g=t,this.X=n,this.U=e,this.oa=r,this.P=new Qn}l(t,n=!0){if("runningMode"in t&&R(this.baseOptions,2,ge(!!t.runningMode&&t.runningMode!=="IMAGE")),t.canvas!==void 0&&this.g.i.canvas!==t.canvas)throw Error("You must create a new task to reset the canvas.");return super.l(t,n)}close(){this.P.close(),super.close()}};mt.prototype.close=mt.prototype.close;var _t=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect_in",!1),this.j={detections:[]},E(t=this.h=new hr,0,1,n=new M),T(this.h,2,.5),T(this.h,3,.3)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return"minDetectionConfidence"in t&&T(this.h,2,t.minDetectionConfidence??.5),"minSuppressionThreshold"in t&&T(this.h,3,t.minSuppressionThreshold??.3),this.l(t)}F(t,n){return this.j={detections:[]},kt(this,t,n),this.j}G(t,n,e){return this.j={detections:[]},Ot(this,t,e,n),this.j}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect_in"),w(t,"detections");let n=new pt;Bt(n,Yu,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.face_detector.FaceDetectorGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect_in"),b(e,"DETECTIONS:detections"),e.o(n),xt(t,e),this.g.attachProtoVectorListener("detections",((r,o)=>{for(let i of r)r=wa(i),this.j.detections.push(qa(r));d(this,o)})),this.g.attachEmptyPacketListener("detections",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};_t.prototype.detectForVideo=_t.prototype.G,_t.prototype.detect=_t.prototype.F,_t.prototype.setOptions=_t.prototype.o,_t.createFromModelPath=async function(t,n){return y(_t,t,{baseOptions:{modelAssetPath:n}})},_t.createFromModelBuffer=function(t,n){return y(_t,t,{baseOptions:{modelAssetBuffer:n}})},_t.createFromOptions=function(t,n){return y(_t,t,n)};var Bi=At([61,146],[146,91],[91,181],[181,84],[84,17],[17,314],[314,405],[405,321],[321,375],[375,291],[61,185],[185,40],[40,39],[39,37],[37,0],[0,267],[267,269],[269,270],[270,409],[409,291],[78,95],[95,88],[88,178],[178,87],[87,14],[14,317],[317,402],[402,318],[318,324],[324,308],[78,191],[191,80],[80,81],[81,82],[82,13],[13,312],[312,311],[311,310],[310,415],[415,308]),Ni=At([263,249],[249,390],[390,373],[373,374],[374,380],[380,381],[381,382],[382,362],[263,466],[466,388],[388,387],[387,386],[386,385],[385,384],[384,398],[398,362]),Oi=At([276,283],[283,282],[282,295],[295,285],[300,293],[293,334],[334,296],[296,336]),oc=At([474,475],[475,476],[476,477],[477,474]),Gi=At([33,7],[7,163],[163,144],[144,145],[145,153],[153,154],[154,155],[155,133],[33,246],[246,161],[161,160],[160,159],[159,158],[158,157],[157,173],[173,133]),Xi=At([46,53],[53,52],[52,65],[65,55],[70,63],[63,105],[105,66],[66,107]),sc=At([469,470],[470,471],[471,472],[472,469]),Vi=At([10,338],[338,297],[297,332],[332,284],[284,251],[251,389],[389,356],[356,454],[454,323],[323,361],[361,288],[288,397],[397,365],[365,379],[379,378],[378,400],[400,377],[377,152],[152,148],[148,176],[176,149],[149,150],[150,136],[136,172],[172,58],[58,132],[132,93],[93,234],[234,127],[127,162],[162,21],[21,54],[54,103],[103,67],[67,109],[109,10]),ac=[...Bi,...Ni,...Oi,...Gi,...Xi,...Vi],cc=At([127,34],[34,139],[139,127],[11,0],[0,37],[37,11],[232,231],[231,120],[120,232],[72,37],[37,39],[39,72],[128,121],[121,47],[47,128],[232,121],[121,128],[128,232],[104,69],[69,67],[67,104],[175,171],[171,148],[148,175],[118,50],[50,101],[101,118],[73,39],[39,40],[40,73],[9,151],[151,108],[108,9],[48,115],[115,131],[131,48],[194,204],[204,211],[211,194],[74,40],[40,185],[185,74],[80,42],[42,183],[183,80],[40,92],[92,186],[186,40],[230,229],[229,118],[118,230],[202,212],[212,214],[214,202],[83,18],[18,17],[17,83],[76,61],[61,146],[146,76],[160,29],[29,30],[30,160],[56,157],[157,173],[173,56],[106,204],[204,194],[194,106],[135,214],[214,192],[192,135],[203,165],[165,98],[98,203],[21,71],[71,68],[68,21],[51,45],[45,4],[4,51],[144,24],[24,23],[23,144],[77,146],[146,91],[91,77],[205,50],[50,187],[187,205],[201,200],[200,18],[18,201],[91,106],[106,182],[182,91],[90,91],[91,181],[181,90],[85,84],[84,17],[17,85],[206,203],[203,36],[36,206],[148,171],[171,140],[140,148],[92,40],[40,39],[39,92],[193,189],[189,244],[244,193],[159,158],[158,28],[28,159],[247,246],[246,161],[161,247],[236,3],[3,196],[196,236],[54,68],[68,104],[104,54],[193,168],[168,8],[8,193],[117,228],[228,31],[31,117],[189,193],[193,55],[55,189],[98,97],[97,99],[99,98],[126,47],[47,100],[100,126],[166,79],[79,218],[218,166],[155,154],[154,26],[26,155],[209,49],[49,131],[131,209],[135,136],[136,150],[150,135],[47,126],[126,217],[217,47],[223,52],[52,53],[53,223],[45,51],[51,134],[134,45],[211,170],[170,140],[140,211],[67,69],[69,108],[108,67],[43,106],[106,91],[91,43],[230,119],[119,120],[120,230],[226,130],[130,247],[247,226],[63,53],[53,52],[52,63],[238,20],[20,242],[242,238],[46,70],[70,156],[156,46],[78,62],[62,96],[96,78],[46,53],[53,63],[63,46],[143,34],[34,227],[227,143],[123,117],[117,111],[111,123],[44,125],[125,19],[19,44],[236,134],[134,51],[51,236],[216,206],[206,205],[205,216],[154,153],[153,22],[22,154],[39,37],[37,167],[167,39],[200,201],[201,208],[208,200],[36,142],[142,100],[100,36],[57,212],[212,202],[202,57],[20,60],[60,99],[99,20],[28,158],[158,157],[157,28],[35,226],[226,113],[113,35],[160,159],[159,27],[27,160],[204,202],[202,210],[210,204],[113,225],[225,46],[46,113],[43,202],[202,204],[204,43],[62,76],[76,77],[77,62],[137,123],[123,116],[116,137],[41,38],[38,72],[72,41],[203,129],[129,142],[142,203],[64,98],[98,240],[240,64],[49,102],[102,64],[64,49],[41,73],[73,74],[74,41],[212,216],[216,207],[207,212],[42,74],[74,184],[184,42],[169,170],[170,211],[211,169],[170,149],[149,176],[176,170],[105,66],[66,69],[69,105],[122,6],[6,168],[168,122],[123,147],[147,187],[187,123],[96,77],[77,90],[90,96],[65,55],[55,107],[107,65],[89,90],[90,180],[180,89],[101,100],[100,120],[120,101],[63,105],[105,104],[104,63],[93,137],[137,227],[227,93],[15,86],[86,85],[85,15],[129,102],[102,49],[49,129],[14,87],[87,86],[86,14],[55,8],[8,9],[9,55],[100,47],[47,121],[121,100],[145,23],[23,22],[22,145],[88,89],[89,179],[179,88],[6,122],[122,196],[196,6],[88,95],[95,96],[96,88],[138,172],[172,136],[136,138],[215,58],[58,172],[172,215],[115,48],[48,219],[219,115],[42,80],[80,81],[81,42],[195,3],[3,51],[51,195],[43,146],[146,61],[61,43],[171,175],[175,199],[199,171],[81,82],[82,38],[38,81],[53,46],[46,225],[225,53],[144,163],[163,110],[110,144],[52,65],[65,66],[66,52],[229,228],[228,117],[117,229],[34,127],[127,234],[234,34],[107,108],[108,69],[69,107],[109,108],[108,151],[151,109],[48,64],[64,235],[235,48],[62,78],[78,191],[191,62],[129,209],[209,126],[126,129],[111,35],[35,143],[143,111],[117,123],[123,50],[50,117],[222,65],[65,52],[52,222],[19,125],[125,141],[141,19],[221,55],[55,65],[65,221],[3,195],[195,197],[197,3],[25,7],[7,33],[33,25],[220,237],[237,44],[44,220],[70,71],[71,139],[139,70],[122,193],[193,245],[245,122],[247,130],[130,33],[33,247],[71,21],[21,162],[162,71],[170,169],[169,150],[150,170],[188,174],[174,196],[196,188],[216,186],[186,92],[92,216],[2,97],[97,167],[167,2],[141,125],[125,241],[241,141],[164,167],[167,37],[37,164],[72,38],[38,12],[12,72],[38,82],[82,13],[13,38],[63,68],[68,71],[71,63],[226,35],[35,111],[111,226],[101,50],[50,205],[205,101],[206,92],[92,165],[165,206],[209,198],[198,217],[217,209],[165,167],[167,97],[97,165],[220,115],[115,218],[218,220],[133,112],[112,243],[243,133],[239,238],[238,241],[241,239],[214,135],[135,169],[169,214],[190,173],[173,133],[133,190],[171,208],[208,32],[32,171],[125,44],[44,237],[237,125],[86,87],[87,178],[178,86],[85,86],[86,179],[179,85],[84,85],[85,180],[180,84],[83,84],[84,181],[181,83],[201,83],[83,182],[182,201],[137,93],[93,132],[132,137],[76,62],[62,183],[183,76],[61,76],[76,184],[184,61],[57,61],[61,185],[185,57],[212,57],[57,186],[186,212],[214,207],[207,187],[187,214],[34,143],[143,156],[156,34],[79,239],[239,237],[237,79],[123,137],[137,177],[177,123],[44,1],[1,4],[4,44],[201,194],[194,32],[32,201],[64,102],[102,129],[129,64],[213,215],[215,138],[138,213],[59,166],[166,219],[219,59],[242,99],[99,97],[97,242],[2,94],[94,141],[141,2],[75,59],[59,235],[235,75],[24,110],[110,228],[228,24],[25,130],[130,226],[226,25],[23,24],[24,229],[229,23],[22,23],[23,230],[230,22],[26,22],[22,231],[231,26],[112,26],[26,232],[232,112],[189,190],[190,243],[243,189],[221,56],[56,190],[190,221],[28,56],[56,221],[221,28],[27,28],[28,222],[222,27],[29,27],[27,223],[223,29],[30,29],[29,224],[224,30],[247,30],[30,225],[225,247],[238,79],[79,20],[20,238],[166,59],[59,75],[75,166],[60,75],[75,240],[240,60],[147,177],[177,215],[215,147],[20,79],[79,166],[166,20],[187,147],[147,213],[213,187],[112,233],[233,244],[244,112],[233,128],[128,245],[245,233],[128,114],[114,188],[188,128],[114,217],[217,174],[174,114],[131,115],[115,220],[220,131],[217,198],[198,236],[236,217],[198,131],[131,134],[134,198],[177,132],[132,58],[58,177],[143,35],[35,124],[124,143],[110,163],[163,7],[7,110],[228,110],[110,25],[25,228],[356,389],[389,368],[368,356],[11,302],[302,267],[267,11],[452,350],[350,349],[349,452],[302,303],[303,269],[269,302],[357,343],[343,277],[277,357],[452,453],[453,357],[357,452],[333,332],[332,297],[297,333],[175,152],[152,377],[377,175],[347,348],[348,330],[330,347],[303,304],[304,270],[270,303],[9,336],[336,337],[337,9],[278,279],[279,360],[360,278],[418,262],[262,431],[431,418],[304,408],[408,409],[409,304],[310,415],[415,407],[407,310],[270,409],[409,410],[410,270],[450,348],[348,347],[347,450],[422,430],[430,434],[434,422],[313,314],[314,17],[17,313],[306,307],[307,375],[375,306],[387,388],[388,260],[260,387],[286,414],[414,398],[398,286],[335,406],[406,418],[418,335],[364,367],[367,416],[416,364],[423,358],[358,327],[327,423],[251,284],[284,298],[298,251],[281,5],[5,4],[4,281],[373,374],[374,253],[253,373],[307,320],[320,321],[321,307],[425,427],[427,411],[411,425],[421,313],[313,18],[18,421],[321,405],[405,406],[406,321],[320,404],[404,405],[405,320],[315,16],[16,17],[17,315],[426,425],[425,266],[266,426],[377,400],[400,369],[369,377],[322,391],[391,269],[269,322],[417,465],[465,464],[464,417],[386,257],[257,258],[258,386],[466,260],[260,388],[388,466],[456,399],[399,419],[419,456],[284,332],[332,333],[333,284],[417,285],[285,8],[8,417],[346,340],[340,261],[261,346],[413,441],[441,285],[285,413],[327,460],[460,328],[328,327],[355,371],[371,329],[329,355],[392,439],[439,438],[438,392],[382,341],[341,256],[256,382],[429,420],[420,360],[360,429],[364,394],[394,379],[379,364],[277,343],[343,437],[437,277],[443,444],[444,283],[283,443],[275,440],[440,363],[363,275],[431,262],[262,369],[369,431],[297,338],[338,337],[337,297],[273,375],[375,321],[321,273],[450,451],[451,349],[349,450],[446,342],[342,467],[467,446],[293,334],[334,282],[282,293],[458,461],[461,462],[462,458],[276,353],[353,383],[383,276],[308,324],[324,325],[325,308],[276,300],[300,293],[293,276],[372,345],[345,447],[447,372],[352,345],[345,340],[340,352],[274,1],[1,19],[19,274],[456,248],[248,281],[281,456],[436,427],[427,425],[425,436],[381,256],[256,252],[252,381],[269,391],[391,393],[393,269],[200,199],[199,428],[428,200],[266,330],[330,329],[329,266],[287,273],[273,422],[422,287],[250,462],[462,328],[328,250],[258,286],[286,384],[384,258],[265,353],[353,342],[342,265],[387,259],[259,257],[257,387],[424,431],[431,430],[430,424],[342,353],[353,276],[276,342],[273,335],[335,424],[424,273],[292,325],[325,307],[307,292],[366,447],[447,345],[345,366],[271,303],[303,302],[302,271],[423,266],[266,371],[371,423],[294,455],[455,460],[460,294],[279,278],[278,294],[294,279],[271,272],[272,304],[304,271],[432,434],[434,427],[427,432],[272,407],[407,408],[408,272],[394,430],[430,431],[431,394],[395,369],[369,400],[400,395],[334,333],[333,299],[299,334],[351,417],[417,168],[168,351],[352,280],[280,411],[411,352],[325,319],[319,320],[320,325],[295,296],[296,336],[336,295],[319,403],[403,404],[404,319],[330,348],[348,349],[349,330],[293,298],[298,333],[333,293],[323,454],[454,447],[447,323],[15,16],[16,315],[315,15],[358,429],[429,279],[279,358],[14,15],[15,316],[316,14],[285,336],[336,9],[9,285],[329,349],[349,350],[350,329],[374,380],[380,252],[252,374],[318,402],[402,403],[403,318],[6,197],[197,419],[419,6],[318,319],[319,325],[325,318],[367,364],[364,365],[365,367],[435,367],[367,397],[397,435],[344,438],[438,439],[439,344],[272,271],[271,311],[311,272],[195,5],[5,281],[281,195],[273,287],[287,291],[291,273],[396,428],[428,199],[199,396],[311,271],[271,268],[268,311],[283,444],[444,445],[445,283],[373,254],[254,339],[339,373],[282,334],[334,296],[296,282],[449,347],[347,346],[346,449],[264,447],[447,454],[454,264],[336,296],[296,299],[299,336],[338,10],[10,151],[151,338],[278,439],[439,455],[455,278],[292,407],[407,415],[415,292],[358,371],[371,355],[355,358],[340,345],[345,372],[372,340],[346,347],[347,280],[280,346],[442,443],[443,282],[282,442],[19,94],[94,370],[370,19],[441,442],[442,295],[295,441],[248,419],[419,197],[197,248],[263,255],[255,359],[359,263],[440,275],[275,274],[274,440],[300,383],[383,368],[368,300],[351,412],[412,465],[465,351],[263,467],[467,466],[466,263],[301,368],[368,389],[389,301],[395,378],[378,379],[379,395],[412,351],[351,419],[419,412],[436,426],[426,322],[322,436],[2,164],[164,393],[393,2],[370,462],[462,461],[461,370],[164,0],[0,267],[267,164],[302,11],[11,12],[12,302],[268,12],[12,13],[13,268],[293,300],[300,301],[301,293],[446,261],[261,340],[340,446],[330,266],[266,425],[425,330],[426,423],[423,391],[391,426],[429,355],[355,437],[437,429],[391,327],[327,326],[326,391],[440,457],[457,438],[438,440],[341,382],[382,362],[362,341],[459,457],[457,461],[461,459],[434,430],[430,394],[394,434],[414,463],[463,362],[362,414],[396,369],[369,262],[262,396],[354,461],[461,457],[457,354],[316,403],[403,402],[402,316],[315,404],[404,403],[403,315],[314,405],[405,404],[404,314],[313,406],[406,405],[405,313],[421,418],[418,406],[406,421],[366,401],[401,361],[361,366],[306,408],[408,407],[407,306],[291,409],[409,408],[408,291],[287,410],[410,409],[409,287],[432,436],[436,410],[410,432],[434,416],[416,411],[411,434],[264,368],[368,383],[383,264],[309,438],[438,457],[457,309],[352,376],[376,401],[401,352],[274,275],[275,4],[4,274],[421,428],[428,262],[262,421],[294,327],[327,358],[358,294],[433,416],[416,367],[367,433],[289,455],[455,439],[439,289],[462,370],[370,326],[326,462],[2,326],[326,370],[370,2],[305,460],[460,455],[455,305],[254,449],[449,448],[448,254],[255,261],[261,446],[446,255],[253,450],[450,449],[449,253],[252,451],[451,450],[450,252],[256,452],[452,451],[451,256],[341,453],[453,452],[452,341],[413,464],[464,463],[463,413],[441,413],[413,414],[414,441],[258,442],[442,441],[441,258],[257,443],[443,442],[442,257],[259,444],[444,443],[443,259],[260,445],[445,444],[444,260],[467,342],[342,445],[445,467],[459,458],[458,250],[250,459],[289,392],[392,290],[290,289],[290,328],[328,460],[460,290],[376,433],[433,435],[435,376],[250,290],[290,392],[392,250],[411,416],[416,433],[433,411],[341,463],[463,464],[464,341],[453,464],[464,465],[465,453],[357,465],[465,412],[412,357],[343,412],[412,399],[399,343],[360,363],[363,440],[440,360],[437,399],[399,456],[456,437],[420,456],[456,363],[363,420],[401,435],[435,288],[288,401],[372,383],[383,353],[353,372],[339,255],[255,249],[249,339],[448,261],[261,255],[255,448],[133,243],[243,190],[190,133],[133,155],[155,112],[112,133],[33,246],[246,247],[247,33],[33,130],[130,25],[25,33],[398,384],[384,286],[286,398],[362,398],[398,414],[414,362],[362,463],[463,341],[341,362],[263,359],[359,467],[467,263],[263,249],[249,255],[255,263],[466,467],[467,260],[260,466],[75,60],[60,166],[166,75],[238,239],[239,79],[79,238],[162,127],[127,139],[139,162],[72,11],[11,37],[37,72],[121,232],[232,120],[120,121],[73,72],[72,39],[39,73],[114,128],[128,47],[47,114],[233,232],[232,128],[128,233],[103,104],[104,67],[67,103],[152,175],[175,148],[148,152],[119,118],[118,101],[101,119],[74,73],[73,40],[40,74],[107,9],[9,108],[108,107],[49,48],[48,131],[131,49],[32,194],[194,211],[211,32],[184,74],[74,185],[185,184],[191,80],[80,183],[183,191],[185,40],[40,186],[186,185],[119,230],[230,118],[118,119],[210,202],[202,214],[214,210],[84,83],[83,17],[17,84],[77,76],[76,146],[146,77],[161,160],[160,30],[30,161],[190,56],[56,173],[173,190],[182,106],[106,194],[194,182],[138,135],[135,192],[192,138],[129,203],[203,98],[98,129],[54,21],[21,68],[68,54],[5,51],[51,4],[4,5],[145,144],[144,23],[23,145],[90,77],[77,91],[91,90],[207,205],[205,187],[187,207],[83,201],[201,18],[18,83],[181,91],[91,182],[182,181],[180,90],[90,181],[181,180],[16,85],[85,17],[17,16],[205,206],[206,36],[36,205],[176,148],[148,140],[140,176],[165,92],[92,39],[39,165],[245,193],[193,244],[244,245],[27,159],[159,28],[28,27],[30,247],[247,161],[161,30],[174,236],[236,196],[196,174],[103,54],[54,104],[104,103],[55,193],[193,8],[8,55],[111,117],[117,31],[31,111],[221,189],[189,55],[55,221],[240,98],[98,99],[99,240],[142,126],[126,100],[100,142],[219,166],[166,218],[218,219],[112,155],[155,26],[26,112],[198,209],[209,131],[131,198],[169,135],[135,150],[150,169],[114,47],[47,217],[217,114],[224,223],[223,53],[53,224],[220,45],[45,134],[134,220],[32,211],[211,140],[140,32],[109,67],[67,108],[108,109],[146,43],[43,91],[91,146],[231,230],[230,120],[120,231],[113,226],[226,247],[247,113],[105,63],[63,52],[52,105],[241,238],[238,242],[242,241],[124,46],[46,156],[156,124],[95,78],[78,96],[96,95],[70,46],[46,63],[63,70],[116,143],[143,227],[227,116],[116,123],[123,111],[111,116],[1,44],[44,19],[19,1],[3,236],[236,51],[51,3],[207,216],[216,205],[205,207],[26,154],[154,22],[22,26],[165,39],[39,167],[167,165],[199,200],[200,208],[208,199],[101,36],[36,100],[100,101],[43,57],[57,202],[202,43],[242,20],[20,99],[99,242],[56,28],[28,157],[157,56],[124,35],[35,113],[113,124],[29,160],[160,27],[27,29],[211,204],[204,210],[210,211],[124,113],[113,46],[46,124],[106,43],[43,204],[204,106],[96,62],[62,77],[77,96],[227,137],[137,116],[116,227],[73,41],[41,72],[72,73],[36,203],[203,142],[142,36],[235,64],[64,240],[240,235],[48,49],[49,64],[64,48],[42,41],[41,74],[74,42],[214,212],[212,207],[207,214],[183,42],[42,184],[184,183],[210,169],[169,211],[211,210],[140,170],[170,176],[176,140],[104,105],[105,69],[69,104],[193,122],[122,168],[168,193],[50,123],[123,187],[187,50],[89,96],[96,90],[90,89],[66,65],[65,107],[107,66],[179,89],[89,180],[180,179],[119,101],[101,120],[120,119],[68,63],[63,104],[104,68],[234,93],[93,227],[227,234],[16,15],[15,85],[85,16],[209,129],[129,49],[49,209],[15,14],[14,86],[86,15],[107,55],[55,9],[9,107],[120,100],[100,121],[121,120],[153,145],[145,22],[22,153],[178,88],[88,179],[179,178],[197,6],[6,196],[196,197],[89,88],[88,96],[96,89],[135,138],[138,136],[136,135],[138,215],[215,172],[172,138],[218,115],[115,219],[219,218],[41,42],[42,81],[81,41],[5,195],[195,51],[51,5],[57,43],[43,61],[61,57],[208,171],[171,199],[199,208],[41,81],[81,38],[38,41],[224,53],[53,225],[225,224],[24,144],[144,110],[110,24],[105,52],[52,66],[66,105],[118,229],[229,117],[117,118],[227,34],[34,234],[234,227],[66,107],[107,69],[69,66],[10,109],[109,151],[151,10],[219,48],[48,235],[235,219],[183,62],[62,191],[191,183],[142,129],[129,126],[126,142],[116,111],[111,143],[143,116],[118,117],[117,50],[50,118],[223,222],[222,52],[52,223],[94,19],[19,141],[141,94],[222,221],[221,65],[65,222],[196,3],[3,197],[197,196],[45,220],[220,44],[44,45],[156,70],[70,139],[139,156],[188,122],[122,245],[245,188],[139,71],[71,162],[162,139],[149,170],[170,150],[150,149],[122,188],[188,196],[196,122],[206,216],[216,92],[92,206],[164,2],[2,167],[167,164],[242,141],[141,241],[241,242],[0,164],[164,37],[37,0],[11,72],[72,12],[12,11],[12,38],[38,13],[13,12],[70,63],[63,71],[71,70],[31,226],[226,111],[111,31],[36,101],[101,205],[205,36],[203,206],[206,165],[165,203],[126,209],[209,217],[217,126],[98,165],[165,97],[97,98],[237,220],[220,218],[218,237],[237,239],[239,241],[241,237],[210,214],[214,169],[169,210],[140,171],[171,32],[32,140],[241,125],[125,237],[237,241],[179,86],[86,178],[178,179],[180,85],[85,179],[179,180],[181,84],[84,180],[180,181],[182,83],[83,181],[181,182],[194,201],[201,182],[182,194],[177,137],[137,132],[132,177],[184,76],[76,183],[183,184],[185,61],[61,184],[184,185],[186,57],[57,185],[185,186],[216,212],[212,186],[186,216],[192,214],[214,187],[187,192],[139,34],[34,156],[156,139],[218,79],[79,237],[237,218],[147,123],[123,177],[177,147],[45,44],[44,4],[4,45],[208,201],[201,32],[32,208],[98,64],[64,129],[129,98],[192,213],[213,138],[138,192],[235,59],[59,219],[219,235],[141,242],[242,97],[97,141],[97,2],[2,141],[141,97],[240,75],[75,235],[235,240],[229,24],[24,228],[228,229],[31,25],[25,226],[226,31],[230,23],[23,229],[229,230],[231,22],[22,230],[230,231],[232,26],[26,231],[231,232],[233,112],[112,232],[232,233],[244,189],[189,243],[243,244],[189,221],[221,190],[190,189],[222,28],[28,221],[221,222],[223,27],[27,222],[222,223],[224,29],[29,223],[223,224],[225,30],[30,224],[224,225],[113,247],[247,225],[225,113],[99,60],[60,240],[240,99],[213,147],[147,215],[215,213],[60,20],[20,166],[166,60],[192,187],[187,213],[213,192],[243,112],[112,244],[244,243],[244,233],[233,245],[245,244],[245,128],[128,188],[188,245],[188,114],[114,174],[174,188],[134,131],[131,220],[220,134],[174,217],[217,236],[236,174],[236,198],[198,134],[134,236],[215,177],[177,58],[58,215],[156,143],[143,124],[124,156],[25,110],[110,7],[7,25],[31,228],[228,25],[25,31],[264,356],[356,368],[368,264],[0,11],[11,267],[267,0],[451,452],[452,349],[349,451],[267,302],[302,269],[269,267],[350,357],[357,277],[277,350],[350,452],[452,357],[357,350],[299,333],[333,297],[297,299],[396,175],[175,377],[377,396],[280,347],[347,330],[330,280],[269,303],[303,270],[270,269],[151,9],[9,337],[337,151],[344,278],[278,360],[360,344],[424,418],[418,431],[431,424],[270,304],[304,409],[409,270],[272,310],[310,407],[407,272],[322,270],[270,410],[410,322],[449,450],[450,347],[347,449],[432,422],[422,434],[434,432],[18,313],[313,17],[17,18],[291,306],[306,375],[375,291],[259,387],[387,260],[260,259],[424,335],[335,418],[418,424],[434,364],[364,416],[416,434],[391,423],[423,327],[327,391],[301,251],[251,298],[298,301],[275,281],[281,4],[4,275],[254,373],[373,253],[253,254],[375,307],[307,321],[321,375],[280,425],[425,411],[411,280],[200,421],[421,18],[18,200],[335,321],[321,406],[406,335],[321,320],[320,405],[405,321],[314,315],[315,17],[17,314],[423,426],[426,266],[266,423],[396,377],[377,369],[369,396],[270,322],[322,269],[269,270],[413,417],[417,464],[464,413],[385,386],[386,258],[258,385],[248,456],[456,419],[419,248],[298,284],[284,333],[333,298],[168,417],[417,8],[8,168],[448,346],[346,261],[261,448],[417,413],[413,285],[285,417],[326,327],[327,328],[328,326],[277,355],[355,329],[329,277],[309,392],[392,438],[438,309],[381,382],[382,256],[256,381],[279,429],[429,360],[360,279],[365,364],[364,379],[379,365],[355,277],[277,437],[437,355],[282,443],[443,283],[283,282],[281,275],[275,363],[363,281],[395,431],[431,369],[369,395],[299,297],[297,337],[337,299],[335,273],[273,321],[321,335],[348,450],[450,349],[349,348],[359,446],[446,467],[467,359],[283,293],[293,282],[282,283],[250,458],[458,462],[462,250],[300,276],[276,383],[383,300],[292,308],[308,325],[325,292],[283,276],[276,293],[293,283],[264,372],[372,447],[447,264],[346,352],[352,340],[340,346],[354,274],[274,19],[19,354],[363,456],[456,281],[281,363],[426,436],[436,425],[425,426],[380,381],[381,252],[252,380],[267,269],[269,393],[393,267],[421,200],[200,428],[428,421],[371,266],[266,329],[329,371],[432,287],[287,422],[422,432],[290,250],[250,328],[328,290],[385,258],[258,384],[384,385],[446,265],[265,342],[342,446],[386,387],[387,257],[257,386],[422,424],[424,430],[430,422],[445,342],[342,276],[276,445],[422,273],[273,424],[424,422],[306,292],[292,307],[307,306],[352,366],[366,345],[345,352],[268,271],[271,302],[302,268],[358,423],[423,371],[371,358],[327,294],[294,460],[460,327],[331,279],[279,294],[294,331],[303,271],[271,304],[304,303],[436,432],[432,427],[427,436],[304,272],[272,408],[408,304],[395,394],[394,431],[431,395],[378,395],[395,400],[400,378],[296,334],[334,299],[299,296],[6,351],[351,168],[168,6],[376,352],[352,411],[411,376],[307,325],[325,320],[320,307],[285,295],[295,336],[336,285],[320,319],[319,404],[404,320],[329,330],[330,349],[349,329],[334,293],[293,333],[333,334],[366,323],[323,447],[447,366],[316,15],[15,315],[315,316],[331,358],[358,279],[279,331],[317,14],[14,316],[316,317],[8,285],[285,9],[9,8],[277,329],[329,350],[350,277],[253,374],[374,252],[252,253],[319,318],[318,403],[403,319],[351,6],[6,419],[419,351],[324,318],[318,325],[325,324],[397,367],[367,365],[365,397],[288,435],[435,397],[397,288],[278,344],[344,439],[439,278],[310,272],[272,311],[311,310],[248,195],[195,281],[281,248],[375,273],[273,291],[291,375],[175,396],[396,199],[199,175],[312,311],[311,268],[268,312],[276,283],[283,445],[445,276],[390,373],[373,339],[339,390],[295,282],[282,296],[296,295],[448,449],[449,346],[346,448],[356,264],[264,454],[454,356],[337,336],[336,299],[299,337],[337,338],[338,151],[151,337],[294,278],[278,455],[455,294],[308,292],[292,415],[415,308],[429,358],[358,355],[355,429],[265,340],[340,372],[372,265],[352,346],[346,280],[280,352],[295,442],[442,282],[282,295],[354,19],[19,370],[370,354],[285,441],[441,295],[295,285],[195,248],[248,197],[197,195],[457,440],[440,274],[274,457],[301,300],[300,368],[368,301],[417,351],[351,465],[465,417],[251,301],[301,389],[389,251],[394,395],[395,379],[379,394],[399,412],[412,419],[419,399],[410,436],[436,322],[322,410],[326,2],[2,393],[393,326],[354,370],[370,461],[461,354],[393,164],[164,267],[267,393],[268,302],[302,12],[12,268],[312,268],[268,13],[13,312],[298,293],[293,301],[301,298],[265,446],[446,340],[340,265],[280,330],[330,425],[425,280],[322,426],[426,391],[391,322],[420,429],[429,437],[437,420],[393,391],[391,326],[326,393],[344,440],[440,438],[438,344],[458,459],[459,461],[461,458],[364,434],[434,394],[394,364],[428,396],[396,262],[262,428],[274,354],[354,457],[457,274],[317,316],[316,402],[402,317],[316,315],[315,403],[403,316],[315,314],[314,404],[404,315],[314,313],[313,405],[405,314],[313,421],[421,406],[406,313],[323,366],[366,361],[361,323],[292,306],[306,407],[407,292],[306,291],[291,408],[408,306],[291,287],[287,409],[409,291],[287,432],[432,410],[410,287],[427,434],[434,411],[411,427],[372,264],[264,383],[383,372],[459,309],[309,457],[457,459],[366,352],[352,401],[401,366],[1,274],[274,4],[4,1],[418,421],[421,262],[262,418],[331,294],[294,358],[358,331],[435,433],[433,367],[367,435],[392,289],[289,439],[439,392],[328,462],[462,326],[326,328],[94,2],[2,370],[370,94],[289,305],[305,455],[455,289],[339,254],[254,448],[448,339],[359,255],[255,446],[446,359],[254,253],[253,449],[449,254],[253,252],[252,450],[450,253],[252,256],[256,451],[451,252],[256,341],[341,452],[452,256],[414,413],[413,463],[463,414],[286,441],[441,414],[414,286],[286,258],[258,441],[441,286],[258,257],[257,442],[442,258],[257,259],[259,443],[443,257],[259,260],[260,444],[444,259],[260,467],[467,445],[445,260],[309,459],[459,250],[250,309],[305,289],[289,290],[290,305],[305,290],[290,460],[460,305],[401,376],[376,435],[435,401],[309,250],[250,392],[392,309],[376,411],[411,433],[433,376],[453,341],[341,464],[464,453],[357,453],[453,465],[465,357],[343,357],[357,412],[412,343],[437,343],[343,399],[399,437],[344,360],[360,440],[440,344],[420,437],[437,456],[456,420],[360,420],[420,363],[363,360],[361,401],[401,288],[288,361],[265,372],[372,353],[353,265],[390,339],[339,249],[249,390],[339,448],[448,255],[255,339]);function Jo(t){t.j={faceLandmarks:[],faceBlendshapes:[],facialTransformationMatrixes:[]}}var D=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!1),this.j={faceLandmarks:[],faceBlendshapes:[],facialTransformationMatrixes:[]},this.outputFacialTransformationMatrixes=this.outputFaceBlendshapes=!1,E(t=this.h=new Pa,0,1,n=new M),this.A=new Fa,E(this.h,0,3,this.A),this.u=new hr,E(this.h,0,2,this.u),Yt(this.u,4,1),T(this.u,2,.5),T(this.A,2,.5),T(this.h,4,.5)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return"numFaces"in t&&Yt(this.u,4,t.numFaces??1),"minFaceDetectionConfidence"in t&&T(this.u,2,t.minFaceDetectionConfidence??.5),"minTrackingConfidence"in t&&T(this.h,4,t.minTrackingConfidence??.5),"minFacePresenceConfidence"in t&&T(this.A,2,t.minFacePresenceConfidence??.5),"outputFaceBlendshapes"in t&&(this.outputFaceBlendshapes=!!t.outputFaceBlendshapes),"outputFacialTransformationMatrixes"in t&&(this.outputFacialTransformationMatrixes=!!t.outputFacialTransformationMatrixes),this.l(t)}F(t,n){return Jo(this),kt(this,t,n),this.j}G(t,n,e){return Jo(this),Ot(this,t,e,n),this.j}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect"),w(t,"face_landmarks");let n=new pt;Bt(n,Ku,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.face_landmarker.FaceLandmarkerGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),b(e,"NORM_LANDMARKS:face_landmarks"),e.o(n),xt(t,e),this.g.attachProtoVectorListener("face_landmarks",((r,o)=>{for(let i of r)r=we(i),this.j.faceLandmarks.push(lr(r));d(this,o)})),this.g.attachEmptyPacketListener("face_landmarks",(r=>{d(this,r)})),this.outputFaceBlendshapes&&(w(t,"blendshapes"),b(e,"BLENDSHAPES:blendshapes"),this.g.attachProtoVectorListener("blendshapes",((r,o)=>{if(this.outputFaceBlendshapes)for(let i of r)r=ur(i),this.j.faceBlendshapes.push(Ii(r.g()??[]));d(this,o)})),this.g.attachEmptyPacketListener("blendshapes",(r=>{d(this,r)}))),this.outputFacialTransformationMatrixes&&(w(t,"face_geometry"),b(e,"FACE_GEOMETRY:face_geometry"),this.g.attachProtoVectorListener("face_geometry",((r,o)=>{if(this.outputFacialTransformationMatrixes)for(let i of r)(r=x(r=zu(i),Nu,2))&&this.j.facialTransformationMatrixes.push({rows:bt(r,1)??0??0,columns:bt(r,2)??0??0,data:un(r,3,Pt,cn()).slice()??[]});d(this,o)})),this.g.attachEmptyPacketListener("face_geometry",(r=>{d(this,r)}))),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};D.prototype.detectForVideo=D.prototype.G,D.prototype.detect=D.prototype.F,D.prototype.setOptions=D.prototype.o,D.createFromModelPath=function(t,n){return y(D,t,{baseOptions:{modelAssetPath:n}})},D.createFromModelBuffer=function(t,n){return y(D,t,{baseOptions:{modelAssetBuffer:n}})},D.createFromOptions=function(t,n){return y(D,t,n)},D.FACE_LANDMARKS_LIPS=Bi,D.FACE_LANDMARKS_LEFT_EYE=Ni,D.FACE_LANDMARKS_LEFT_EYEBROW=Oi,D.FACE_LANDMARKS_LEFT_IRIS=oc,D.FACE_LANDMARKS_RIGHT_EYE=Gi,D.FACE_LANDMARKS_RIGHT_EYEBROW=Xi,D.FACE_LANDMARKS_RIGHT_IRIS=sc,D.FACE_LANDMARKS_FACE_OVAL=Vi,D.FACE_LANDMARKS_CONTOURS=ac,D.FACE_LANDMARKS_TESSELATION=cc;var Wi=At([0,1],[1,2],[2,3],[3,4],[0,5],[5,6],[6,7],[7,8],[5,9],[9,10],[10,11],[11,12],[9,13],[13,14],[14,15],[15,16],[13,17],[0,17],[17,18],[18,19],[19,20]);function ts(t){t.gestures=[],t.landmarks=[],t.worldLandmarks=[],t.handedness=[]}function ns(t){return t.gestures.length===0?{gestures:[],landmarks:[],worldLandmarks:[],handedness:[],handednesses:[]}:{gestures:t.gestures,landmarks:t.landmarks,worldLandmarks:t.worldLandmarks,handedness:t.handedness,handednesses:t.handedness}}function es(t,n=!0){let e=[];for(let o of t){var r=ur(o);t=[];for(let i of r.g())r=n&&bt(i,1)!=null?bt(i,1)??0:-1,t.push({score:B(i,2)??0,index:r,categoryName:$(P(i,3))??""??"",displayName:$(P(i,4))??""??""});e.push(t)}return e}var at=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!1),this.gestures=[],this.landmarks=[],this.worldLandmarks=[],this.handedness=[],E(t=this.j=new Da,0,1,n=new M),this.u=new Li,E(this.j,0,2,this.u),this.D=new Si,E(this.u,0,3,this.D),this.A=new Ca,E(this.u,0,2,this.A),this.h=new $u,E(this.j,0,3,this.h),T(this.A,2,.5),T(this.u,4,.5),T(this.D,2,.5)}get baseOptions(){return x(this.j,M,1)}set baseOptions(t){E(this.j,0,1,t)}o(t){if(Yt(this.A,3,t.numHands??1),"minHandDetectionConfidence"in t&&T(this.A,2,t.minHandDetectionConfidence??.5),"minTrackingConfidence"in t&&T(this.u,4,t.minTrackingConfidence??.5),"minHandPresenceConfidence"in t&&T(this.D,2,t.minHandPresenceConfidence??.5),t.cannedGesturesClassifierOptions){var n=new xn,e=n,r=Gr(t.cannedGesturesClassifierOptions,x(this.h,xn,3)?.l());E(e,0,2,r),E(this.h,0,3,n)}else t.cannedGesturesClassifierOptions===void 0&&x(this.h,xn,3)?.g();return t.customGesturesClassifierOptions?(E(e=n=new xn,0,2,r=Gr(t.customGesturesClassifierOptions,x(this.h,xn,4)?.l())),E(this.h,0,4,n)):t.customGesturesClassifierOptions===void 0&&x(this.h,xn,4)?.g(),this.l(t)}Ha(t,n){return ts(this),kt(this,t,n),ns(this)}Ia(t,n,e){return ts(this),Ot(this,t,e,n),ns(this)}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect"),w(t,"hand_gestures"),w(t,"hand_landmarks"),w(t,"world_hand_landmarks"),w(t,"handedness");let n=new pt;Bt(n,qu,this.j);let e=new ot;gt(e,2,"mediapipe.tasks.vision.gesture_recognizer.GestureRecognizerGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),b(e,"HAND_GESTURES:hand_gestures"),b(e,"LANDMARKS:hand_landmarks"),b(e,"WORLD_LANDMARKS:world_hand_landmarks"),b(e,"HANDEDNESS:handedness"),e.o(n),xt(t,e),this.g.attachProtoVectorListener("hand_landmarks",((r,o)=>{for(let i of r){r=we(i);let s=[];for(let a of Ht(r,Ra,1))s.push({x:B(a,1)??0,y:B(a,2)??0,z:B(a,3)??0,visibility:B(a,4)??0});this.landmarks.push(s)}d(this,o)})),this.g.attachEmptyPacketListener("hand_landmarks",(r=>{d(this,r)})),this.g.attachProtoVectorListener("world_hand_landmarks",((r,o)=>{for(let i of r){r=Rn(i);let s=[];for(let a of Ht(r,Aa,1))s.push({x:B(a,1)??0,y:B(a,2)??0,z:B(a,3)??0,visibility:B(a,4)??0});this.worldLandmarks.push(s)}d(this,o)})),this.g.attachEmptyPacketListener("world_hand_landmarks",(r=>{d(this,r)})),this.g.attachProtoVectorListener("hand_gestures",((r,o)=>{this.gestures.push(...es(r,!1)),d(this,o)})),this.g.attachEmptyPacketListener("hand_gestures",(r=>{d(this,r)})),this.g.attachProtoVectorListener("handedness",((r,o)=>{this.handedness.push(...es(r)),d(this,o)})),this.g.attachEmptyPacketListener("handedness",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};function rs(t){return{landmarks:t.landmarks,worldLandmarks:t.worldLandmarks,handednesses:t.handedness,handedness:t.handedness}}at.prototype.recognizeForVideo=at.prototype.Ia,at.prototype.recognize=at.prototype.Ha,at.prototype.setOptions=at.prototype.o,at.createFromModelPath=function(t,n){return y(at,t,{baseOptions:{modelAssetPath:n}})},at.createFromModelBuffer=function(t,n){return y(at,t,{baseOptions:{modelAssetBuffer:n}})},at.createFromOptions=function(t,n){return y(at,t,n)},at.HAND_CONNECTIONS=Wi;var ct=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!1),this.landmarks=[],this.worldLandmarks=[],this.handedness=[],E(t=this.h=new Li,0,1,n=new M),this.u=new Si,E(this.h,0,3,this.u),this.j=new Ca,E(this.h,0,2,this.j),Yt(this.j,3,1),T(this.j,2,.5),T(this.u,2,.5),T(this.h,4,.5)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return"numHands"in t&&Yt(this.j,3,t.numHands??1),"minHandDetectionConfidence"in t&&T(this.j,2,t.minHandDetectionConfidence??.5),"minTrackingConfidence"in t&&T(this.h,4,t.minTrackingConfidence??.5),"minHandPresenceConfidence"in t&&T(this.u,2,t.minHandPresenceConfidence??.5),this.l(t)}F(t,n){return this.landmarks=[],this.worldLandmarks=[],this.handedness=[],kt(this,t,n),rs(this)}G(t,n,e){return this.landmarks=[],this.worldLandmarks=[],this.handedness=[],Ot(this,t,e,n),rs(this)}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect"),w(t,"hand_landmarks"),w(t,"world_hand_landmarks"),w(t,"handedness");let n=new pt;Bt(n,Qu,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.hand_landmarker.HandLandmarkerGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),b(e,"LANDMARKS:hand_landmarks"),b(e,"WORLD_LANDMARKS:world_hand_landmarks"),b(e,"HANDEDNESS:handedness"),e.o(n),xt(t,e),this.g.attachProtoVectorListener("hand_landmarks",((r,o)=>{for(let i of r)r=we(i),this.landmarks.push(lr(r));d(this,o)})),this.g.attachEmptyPacketListener("hand_landmarks",(r=>{d(this,r)})),this.g.attachProtoVectorListener("world_hand_landmarks",((r,o)=>{for(let i of r)r=Rn(i),this.worldLandmarks.push(le(r));d(this,o)})),this.g.attachEmptyPacketListener("world_hand_landmarks",(r=>{d(this,r)})),this.g.attachProtoVectorListener("handedness",((r,o)=>{var i=this.handedness,s=i.push;let a=[];for(let c of r){r=ur(c);let l=[];for(let u of r.g())l.push({score:B(u,2)??0,index:bt(u,1)??0??-1,categoryName:$(P(u,3))??""??"",displayName:$(P(u,4))??""??""});a.push(l)}s.call(i,...a),d(this,o)})),this.g.attachEmptyPacketListener("handedness",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};ct.prototype.detectForVideo=ct.prototype.G,ct.prototype.detect=ct.prototype.F,ct.prototype.setOptions=ct.prototype.o,ct.createFromModelPath=function(t,n){return y(ct,t,{baseOptions:{modelAssetPath:n}})},ct.createFromModelBuffer=function(t,n){return y(ct,t,{baseOptions:{modelAssetBuffer:n}})},ct.createFromOptions=function(t,n){return y(ct,t,n)},ct.HAND_CONNECTIONS=Wi;var uc=At([0,1],[1,2],[2,3],[3,7],[0,4],[4,5],[5,6],[6,8],[9,10],[11,12],[11,13],[13,15],[15,17],[15,19],[15,21],[17,19],[12,14],[14,16],[16,18],[16,20],[16,22],[18,20],[11,23],[12,24],[23,24],[23,25],[24,26],[25,27],[26,28],[27,29],[28,30],[29,31],[30,32],[27,31],[28,32]);function is(t){t.h={faceLandmarks:[],faceBlendshapes:[],poseLandmarks:[],poseWorldLandmarks:[],poseSegmentationMasks:[],leftHandLandmarks:[],leftHandWorldLandmarks:[],rightHandLandmarks:[],rightHandWorldLandmarks:[]}}function os(t){try{if(!t.D)return t.h;t.D(t.h)}finally{fr(t)}}function Pe(t,n){t=we(t),n.push(lr(t))}var S=class extends mt{constructor(t,n){super(new Rt(t,n),"input_frames_image",null,!1),this.h={faceLandmarks:[],faceBlendshapes:[],poseLandmarks:[],poseWorldLandmarks:[],poseSegmentationMasks:[],leftHandLandmarks:[],leftHandWorldLandmarks:[],rightHandLandmarks:[],rightHandWorldLandmarks:[]},this.outputPoseSegmentationMasks=this.outputFaceBlendshapes=!1,E(t=this.j=new Ga,0,1,n=new M),this.I=new Si,E(this.j,0,2,this.I),this.W=new Zu,E(this.j,0,3,this.W),this.u=new hr,E(this.j,0,4,this.u),this.O=new Fa,E(this.j,0,5,this.O),this.A=new Na,E(this.j,0,6,this.A),this.M=new Oa,E(this.j,0,7,this.M),T(this.u,2,.5),T(this.u,3,.3),T(this.O,2,.5),T(this.A,2,.5),T(this.A,3,.3),T(this.M,2,.5),T(this.I,2,.5)}get baseOptions(){return x(this.j,M,1)}set baseOptions(t){E(this.j,0,1,t)}o(t){return"minFaceDetectionConfidence"in t&&T(this.u,2,t.minFaceDetectionConfidence??.5),"minFaceSuppressionThreshold"in t&&T(this.u,3,t.minFaceSuppressionThreshold??.3),"minFacePresenceConfidence"in t&&T(this.O,2,t.minFacePresenceConfidence??.5),"outputFaceBlendshapes"in t&&(this.outputFaceBlendshapes=!!t.outputFaceBlendshapes),"minPoseDetectionConfidence"in t&&T(this.A,2,t.minPoseDetectionConfidence??.5),"minPoseSuppressionThreshold"in t&&T(this.A,3,t.minPoseSuppressionThreshold??.3),"minPosePresenceConfidence"in t&&T(this.M,2,t.minPosePresenceConfidence??.5),"outputPoseSegmentationMasks"in t&&(this.outputPoseSegmentationMasks=!!t.outputPoseSegmentationMasks),"minHandLandmarksConfidence"in t&&T(this.I,2,t.minHandLandmarksConfidence??.5),this.l(t)}F(t,n,e){let r=typeof n!="function"?n:{};return this.D=typeof n=="function"?n:e,is(this),kt(this,t,r),os(this)}G(t,n,e,r){let o=typeof e!="function"?e:{};return this.D=typeof e=="function"?e:r,is(this),Ot(this,t,o,n),os(this)}m(){var t=new Tt;C(t,"input_frames_image"),w(t,"pose_landmarks"),w(t,"pose_world_landmarks"),w(t,"face_landmarks"),w(t,"left_hand_landmarks"),w(t,"left_hand_world_landmarks"),w(t,"right_hand_landmarks"),w(t,"right_hand_world_landmarks");let n=new pt,e=new xo;gt(e,1,"type.googleapis.com/mediapipe.tasks.vision.holistic_landmarker.proto.HolisticLandmarkerGraphOptions"),(function(o,i){if(i!=null)if(Array.isArray(i))R(o,2,Qe(i,0,me));else{if(!(typeof i=="string"||i instanceof It||Kr(i)))throw Error("invalid value in Any.value field: "+i+" expected a ByteString, a base64 encoded string, a Uint8Array or a jspb array");Qt(o,2,qr(i,!1),mn())}})(e,this.j.g());let r=new ot;gt(r,2,"mediapipe.tasks.vision.holistic_landmarker.HolisticLandmarkerGraph"),hi(r,8,xo,e),U(r,"IMAGE:input_frames_image"),b(r,"POSE_LANDMARKS:pose_landmarks"),b(r,"POSE_WORLD_LANDMARKS:pose_world_landmarks"),b(r,"FACE_LANDMARKS:face_landmarks"),b(r,"LEFT_HAND_LANDMARKS:left_hand_landmarks"),b(r,"LEFT_HAND_WORLD_LANDMARKS:left_hand_world_landmarks"),b(r,"RIGHT_HAND_LANDMARKS:right_hand_landmarks"),b(r,"RIGHT_HAND_WORLD_LANDMARKS:right_hand_world_landmarks"),r.o(n),xt(t,r),dr(this,t),this.g.attachProtoListener("pose_landmarks",((o,i)=>{Pe(o,this.h.poseLandmarks),d(this,i)})),this.g.attachEmptyPacketListener("pose_landmarks",(o=>{d(this,o)})),this.g.attachProtoListener("pose_world_landmarks",((o,i)=>{var s=this.h.poseWorldLandmarks;o=Rn(o),s.push(le(o)),d(this,i)})),this.g.attachEmptyPacketListener("pose_world_landmarks",(o=>{d(this,o)})),this.outputPoseSegmentationMasks&&(b(r,"POSE_SEGMENTATION_MASK:pose_segmentation_mask"),Dn(this,"pose_segmentation_mask"),this.g.Z("pose_segmentation_mask",((o,i)=>{this.h.poseSegmentationMasks=[Nn(this,o,!0,!this.D)],d(this,i)})),this.g.attachEmptyPacketListener("pose_segmentation_mask",(o=>{this.h.poseSegmentationMasks=[],d(this,o)}))),this.g.attachProtoListener("face_landmarks",((o,i)=>{Pe(o,this.h.faceLandmarks),d(this,i)})),this.g.attachEmptyPacketListener("face_landmarks",(o=>{d(this,o)})),this.outputFaceBlendshapes&&(w(t,"extra_blendshapes"),b(r,"FACE_BLENDSHAPES:extra_blendshapes"),this.g.attachProtoListener("extra_blendshapes",((o,i)=>{var s=this.h.faceBlendshapes;this.outputFaceBlendshapes&&(o=ur(o),s.push(Ii(o.g()??[]))),d(this,i)})),this.g.attachEmptyPacketListener("extra_blendshapes",(o=>{d(this,o)}))),this.g.attachProtoListener("left_hand_landmarks",((o,i)=>{Pe(o,this.h.leftHandLandmarks),d(this,i)})),this.g.attachEmptyPacketListener("left_hand_landmarks",(o=>{d(this,o)})),this.g.attachProtoListener("left_hand_world_landmarks",((o,i)=>{var s=this.h.leftHandWorldLandmarks;o=Rn(o),s.push(le(o)),d(this,i)})),this.g.attachEmptyPacketListener("left_hand_world_landmarks",(o=>{d(this,o)})),this.g.attachProtoListener("right_hand_landmarks",((o,i)=>{Pe(o,this.h.rightHandLandmarks),d(this,i)})),this.g.attachEmptyPacketListener("right_hand_landmarks",(o=>{d(this,o)})),this.g.attachProtoListener("right_hand_world_landmarks",((o,i)=>{var s=this.h.rightHandWorldLandmarks;o=Rn(o),s.push(le(o)),d(this,i)})),this.g.attachEmptyPacketListener("right_hand_world_landmarks",(o=>{d(this,o)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};S.prototype.detectForVideo=S.prototype.G,S.prototype.detect=S.prototype.F,S.prototype.setOptions=S.prototype.o,S.createFromModelPath=function(t,n){return y(S,t,{baseOptions:{modelAssetPath:n}})},S.createFromModelBuffer=function(t,n){return y(S,t,{baseOptions:{modelAssetBuffer:n}})},S.createFromOptions=function(t,n){return y(S,t,n)},S.HAND_CONNECTIONS=Wi,S.POSE_CONNECTIONS=uc,S.FACE_LANDMARKS_LIPS=Bi,S.FACE_LANDMARKS_LEFT_EYE=Ni,S.FACE_LANDMARKS_LEFT_EYEBROW=Oi,S.FACE_LANDMARKS_LEFT_IRIS=oc,S.FACE_LANDMARKS_RIGHT_EYE=Gi,S.FACE_LANDMARKS_RIGHT_EYEBROW=Xi,S.FACE_LANDMARKS_RIGHT_IRIS=sc,S.FACE_LANDMARKS_FACE_OVAL=Vi,S.FACE_LANDMARKS_CONTOURS=ac,S.FACE_LANDMARKS_TESSELATION=cc;var Et=class extends mt{constructor(t,n){super(new Rt(t,n),"input_image","norm_rect",!0),this.j={classifications:[]},E(t=this.h=new Xa,0,1,n=new M)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return E(this.h,0,2,Gr(t,x(this.h,Ri,2))),this.l(t)}sa(t,n){return this.j={classifications:[]},kt(this,t,n),this.j}ta(t,n,e){return this.j={classifications:[]},Ot(this,t,e,n),this.j}m(){var t=new Tt;C(t,"input_image"),C(t,"norm_rect"),w(t,"classifications");let n=new pt;Bt(n,Ju,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.image_classifier.ImageClassifierGraph"),U(e,"IMAGE:input_image"),U(e,"NORM_RECT:norm_rect"),b(e,"CLASSIFICATIONS:classifications"),e.o(n),xt(t,e),this.g.attachProtoListener("classifications",((r,o)=>{this.j=o2(Xu(r)),d(this,o)})),this.g.attachEmptyPacketListener("classifications",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};Et.prototype.classifyForVideo=Et.prototype.ta,Et.prototype.classify=Et.prototype.sa,Et.prototype.setOptions=Et.prototype.o,Et.createFromModelPath=function(t,n){return y(Et,t,{baseOptions:{modelAssetPath:n}})},Et.createFromModelBuffer=function(t,n){return y(Et,t,{baseOptions:{modelAssetBuffer:n}})},Et.createFromOptions=function(t,n){return y(Et,t,n)};var ut=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!0),this.h=new Va,this.embeddings={embeddings:[]},E(t=this.h,0,1,n=new M)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){var n=this.h,e=x(this.h,Po,2);return e=e?e.clone():new Po,t.l2Normalize!==void 0?R(e,1,ge(t.l2Normalize)):"l2Normalize"in t&&R(e,1),t.quantize!==void 0?R(e,2,ge(t.quantize)):"quantize"in t&&R(e,2),E(n,0,2,e),this.l(t)}za(t,n){return kt(this,t,n),this.embeddings}Aa(t,n,e){return Ot(this,t,e,n),this.embeddings}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect"),w(t,"embeddings_out");let n=new pt;Bt(n,t2,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.image_embedder.ImageEmbedderGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),b(e,"EMBEDDINGS:embeddings_out"),e.o(n),xt(t,e),this.g.attachProtoListener("embeddings_out",((r,o)=>{r=ju(r),this.embeddings=(function(i){return{embeddings:Ht(i,Wu,1).map((s=>{let a={headIndex:bt(s,3)??0??-1,headName:$(P(s,4))??""??""};var c=s.v;return Os(c,0|c[f],Fo,br(s,1))!==void 0?(s=un(s=x(s,Fo,br(s,1),void 0),1,Pt,cn()),a.floatEmbedding=s.slice()):(c=new Uint8Array(0),a.quantizedEmbedding=x(s,Vu,br(s,2),void 0)?.na()?.h()??c),a})),timestampMs:$a(P(i,2,void 0,void 0,Ne)??Cs)}})(r),d(this,o)})),this.g.attachEmptyPacketListener("embeddings_out",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};ut.cosineSimilarity=function(t,n){if(t.floatEmbedding&&n.floatEmbedding)t=No(t.floatEmbedding,n.floatEmbedding);else{if(!t.quantizedEmbedding||!n.quantizedEmbedding)throw Error("Cannot compute cosine similarity between quantized and float embeddings.");t=No(Bo(t.quantizedEmbedding),Bo(n.quantizedEmbedding))}return t},ut.prototype.embedForVideo=ut.prototype.Aa,ut.prototype.embed=ut.prototype.za,ut.prototype.setOptions=ut.prototype.o,ut.createFromModelPath=function(t,n){return y(ut,t,{baseOptions:{modelAssetPath:n}})},ut.createFromModelBuffer=function(t,n){return y(ut,t,{baseOptions:{modelAssetBuffer:n}})},ut.createFromOptions=function(t,n){return y(ut,t,n)};var Hr=class{constructor(t,n,e){this.confidenceMasks=t,this.categoryMask=n,this.qualityScores=e}close(){this.confidenceMasks?.forEach((t=>{t.close()})),this.categoryMask?.close()}};function d2(t){let n=(function(e){return Ht(e,ot,1)})(t.ca()).filter((e=>($(P(e,1))??"").includes("mediapipe.tasks.TensorsToSegmentationCalculator")));if(t.u=[],n.length>1)throw Error("The graph has more than one mediapipe.tasks.TensorsToSegmentationCalculator.");n.length===1&&(x(n[0],pt,7)?.j()?.g()??new Map).forEach(((e,r)=>{t.u[Number(r)]=$(P(e,1))??""}))}function ss(t){t.categoryMask=void 0,t.confidenceMasks=void 0,t.qualityScores=void 0}function as(t){try{let n=new Hr(t.confidenceMasks,t.categoryMask,t.qualityScores);if(!t.j)return n;t.j(n)}finally{fr(t)}}Hr.prototype.close=Hr.prototype.close;var q=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!1),this.u=[],this.outputCategoryMask=!1,this.outputConfidenceMasks=!0,this.h=new Pi,this.A=new Wa,E(this.h,0,3,this.A),E(t=this.h,0,1,n=new M)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return t.displayNamesLocale!==void 0?R(this.h,2,be(t.displayNamesLocale)):"displayNamesLocale"in t&&R(this.h,2),"outputCategoryMask"in t&&(this.outputCategoryMask=t.outputCategoryMask??!1),"outputConfidenceMasks"in t&&(this.outputConfidenceMasks=t.outputConfidenceMasks??!0),super.l(t)}L(){d2(this)}segment(t,n,e){let r=typeof n!="function"?n:{};return this.j=typeof n=="function"?n:e,ss(this),kt(this,t,r),as(this)}La(t,n,e,r){let o=typeof e!="function"?e:{};return this.j=typeof e=="function"?e:r,ss(this),Ot(this,t,o,n),as(this)}Da(){return this.u}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect");let n=new pt;Bt(n,Ha,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.image_segmenter.ImageSegmenterGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),e.o(n),xt(t,e),dr(this,t),this.outputConfidenceMasks&&(w(t,"confidence_masks"),b(e,"CONFIDENCE_MASKS:confidence_masks"),Dn(this,"confidence_masks"),this.g.aa("confidence_masks",((r,o)=>{this.confidenceMasks=r.map((i=>Nn(this,i,!0,!this.j))),d(this,o)})),this.g.attachEmptyPacketListener("confidence_masks",(r=>{this.confidenceMasks=[],d(this,r)}))),this.outputCategoryMask&&(w(t,"category_mask"),b(e,"CATEGORY_MASK:category_mask"),Dn(this,"category_mask"),this.g.Z("category_mask",((r,o)=>{this.categoryMask=Nn(this,r,!1,!this.j),d(this,o)})),this.g.attachEmptyPacketListener("category_mask",(r=>{this.categoryMask=void 0,d(this,r)}))),w(t,"quality_scores"),b(e,"QUALITY_SCORES:quality_scores"),this.g.attachFloatVectorListener("quality_scores",((r,o)=>{this.qualityScores=r,d(this,o)})),this.g.attachEmptyPacketListener("quality_scores",(r=>{this.categoryMask=void 0,d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};q.prototype.getLabels=q.prototype.Da,q.prototype.segmentForVideo=q.prototype.La,q.prototype.segment=q.prototype.segment,q.prototype.setOptions=q.prototype.o,q.createFromModelPath=function(t,n){return y(q,t,{baseOptions:{modelAssetPath:n}})},q.createFromModelBuffer=function(t,n){return y(q,t,{baseOptions:{modelAssetBuffer:n}})},q.createFromOptions=function(t,n){return y(q,t,n)};var Yr=class{constructor(t,n,e){this.confidenceMasks=t,this.categoryMask=n,this.qualityScores=e}close(){this.confidenceMasks?.forEach((t=>{t.close()})),this.categoryMask?.close()}};Yr.prototype.close=Yr.prototype.close;var Ut=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect_in",!1),this.outputCategoryMask=!1,this.outputConfidenceMasks=!0,this.h=new Pi,this.u=new Wa,E(this.h,0,3,this.u),E(t=this.h,0,1,n=new M)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return"outputCategoryMask"in t&&(this.outputCategoryMask=t.outputCategoryMask??!1),"outputConfidenceMasks"in t&&(this.outputConfidenceMasks=t.outputConfidenceMasks??!0),super.l(t)}segment(t,n,e,r){let o=typeof e!="function"?e:{};if(this.j=typeof e=="function"?e:r,this.qualityScores=this.categoryMask=this.confidenceMasks=void 0,e=this.C+1,r=new Ya,n.keypoint&&n.scribble)throw Error("Cannot provide both keypoint and scribble.");if(n.keypoint){var i=new Ar;Qt(i,3,ge(!0),!1),Qt(i,1,se(n.keypoint.x),0),Qt(i,2,se(n.keypoint.y),0),ue(r,1,Or,i)}else{if(!n.scribble)throw Error("Must provide either a keypoint or a scribble.");{let a=new e2;for(i of n.scribble)Qt(n=new Ar,3,ge(!0),!1),Qt(n,1,se(i.x),0),Qt(n,2,se(i.y),0),hi(a,1,Ar,n);ue(r,2,Or,a)}}this.g.addProtoToStream(r.g(),"mediapipe.tasks.vision.interactive_segmenter.proto.RegionOfInterest","roi_in",e),kt(this,t,o);t:{try{let a=new Yr(this.confidenceMasks,this.categoryMask,this.qualityScores);if(!this.j){var s=a;break t}this.j(a)}finally{fr(this)}s=void 0}return s}m(){var t=new Tt;C(t,"image_in"),C(t,"roi_in"),C(t,"norm_rect_in");let n=new pt;Bt(n,Ha,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.interactive_segmenter.InteractiveSegmenterGraphV2"),U(e,"IMAGE:image_in"),U(e,"ROI:roi_in"),U(e,"NORM_RECT:norm_rect_in"),e.o(n),xt(t,e),dr(this,t),this.outputConfidenceMasks&&(w(t,"confidence_masks"),b(e,"CONFIDENCE_MASKS:confidence_masks"),Dn(this,"confidence_masks"),this.g.aa("confidence_masks",((r,o)=>{this.confidenceMasks=r.map((i=>Nn(this,i,!0,!this.j))),d(this,o)})),this.g.attachEmptyPacketListener("confidence_masks",(r=>{this.confidenceMasks=[],d(this,r)}))),this.outputCategoryMask&&(w(t,"category_mask"),b(e,"CATEGORY_MASK:category_mask"),Dn(this,"category_mask"),this.g.Z("category_mask",((r,o)=>{this.categoryMask=Nn(this,r,!1,!this.j),d(this,o)})),this.g.attachEmptyPacketListener("category_mask",(r=>{this.categoryMask=void 0,d(this,r)}))),w(t,"quality_scores"),b(e,"QUALITY_SCORES:quality_scores"),this.g.attachFloatVectorListener("quality_scores",((r,o)=>{this.qualityScores=r,d(this,o)})),this.g.attachEmptyPacketListener("quality_scores",(r=>{this.categoryMask=void 0,d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};Ut.prototype.segment=Ut.prototype.segment,Ut.prototype.setOptions=Ut.prototype.o,Ut.createFromModelPath=function(t,n){return y(Ut,t,{baseOptions:{modelAssetPath:n}})},Ut.createFromModelBuffer=function(t,n){return y(Ut,t,{baseOptions:{modelAssetBuffer:n}})},Ut.createFromOptions=function(t,n){return y(Ut,t,n)};var vt=class extends mt{constructor(t,n){super(new Rt(t,n),"input_frame_gpu","norm_rect",!1),this.j={detections:[]},E(t=this.h=new za,0,1,n=new M)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return t.displayNamesLocale!==void 0?R(this.h,2,be(t.displayNamesLocale)):"displayNamesLocale"in t&&R(this.h,2),t.maxResults!==void 0?Yt(this.h,3,t.maxResults):"maxResults"in t&&R(this.h,3),t.scoreThreshold!==void 0?T(this.h,4,t.scoreThreshold):"scoreThreshold"in t&&R(this.h,4),t.categoryAllowlist!==void 0?Ge(this.h,5,t.categoryAllowlist):"categoryAllowlist"in t&&R(this.h,5),t.categoryDenylist!==void 0?Ge(this.h,6,t.categoryDenylist):"categoryDenylist"in t&&R(this.h,6),this.l(t)}F(t,n){return this.j={detections:[]},kt(this,t,n),this.j}G(t,n,e){return this.j={detections:[]},Ot(this,t,e,n),this.j}m(){var t=new Tt;C(t,"input_frame_gpu"),C(t,"norm_rect"),w(t,"detections");let n=new pt;Bt(n,r2,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.ObjectDetectorGraph"),U(e,"IMAGE:input_frame_gpu"),U(e,"NORM_RECT:norm_rect"),b(e,"DETECTIONS:detections"),e.o(n),xt(t,e),this.g.attachProtoVectorListener("detections",((r,o)=>{for(let i of r)r=wa(i),this.j.detections.push(qa(r));d(this,o)})),this.g.attachEmptyPacketListener("detections",(r=>{d(this,r)})),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};vt.prototype.detectForVideo=vt.prototype.G,vt.prototype.detect=vt.prototype.F,vt.prototype.setOptions=vt.prototype.o,vt.createFromModelPath=async function(t,n){return y(vt,t,{baseOptions:{modelAssetPath:n}})},vt.createFromModelBuffer=function(t,n){return y(vt,t,{baseOptions:{modelAssetBuffer:n}})},vt.createFromOptions=function(t,n){return y(vt,t,n)};var zr=class{constructor(t,n,e){this.landmarks=t,this.worldLandmarks=n,this.segmentationMasks=e}close(){this.segmentationMasks?.forEach((t=>{t.close()}))}};function cs(t){t.landmarks=[],t.worldLandmarks=[],t.segmentationMasks=void 0}function us(t){try{let n=new zr(t.landmarks,t.worldLandmarks,t.segmentationMasks);if(!t.u)return n;t.u(n)}finally{fr(t)}}zr.prototype.close=zr.prototype.close;var ht=class extends mt{constructor(t,n){super(new Rt(t,n),"image_in","norm_rect",!1),this.landmarks=[],this.worldLandmarks=[],this.outputSegmentationMasks=!1,E(t=this.h=new Ka,0,1,n=new M),this.A=new Oa,E(this.h,0,3,this.A),this.j=new Na,E(this.h,0,2,this.j),Yt(this.j,4,1),T(this.j,2,.5),T(this.A,2,.5),T(this.h,4,.5)}get baseOptions(){return x(this.h,M,1)}set baseOptions(t){E(this.h,0,1,t)}o(t){return"numPoses"in t&&Yt(this.j,4,t.numPoses??1),"minPoseDetectionConfidence"in t&&T(this.j,2,t.minPoseDetectionConfidence??.5),"minTrackingConfidence"in t&&T(this.h,4,t.minTrackingConfidence??.5),"minPosePresenceConfidence"in t&&T(this.A,2,t.minPosePresenceConfidence??.5),"outputSegmentationMasks"in t&&(this.outputSegmentationMasks=t.outputSegmentationMasks??!1),this.l(t)}F(t,n,e){let r=typeof n!="function"?n:{};return this.u=typeof n=="function"?n:e,cs(this),kt(this,t,r),us(this)}G(t,n,e,r){let o=typeof e!="function"?e:{};return this.u=typeof e=="function"?e:r,cs(this),Ot(this,t,o,n),us(this)}m(){var t=new Tt;C(t,"image_in"),C(t,"norm_rect"),w(t,"normalized_landmarks"),w(t,"world_landmarks"),w(t,"segmentation_masks");let n=new pt;Bt(n,i2,this.h);let e=new ot;gt(e,2,"mediapipe.tasks.vision.pose_landmarker.PoseLandmarkerGraph"),U(e,"IMAGE:image_in"),U(e,"NORM_RECT:norm_rect"),b(e,"NORM_LANDMARKS:normalized_landmarks"),b(e,"WORLD_LANDMARKS:world_landmarks"),e.o(n),xt(t,e),dr(this,t),this.g.attachProtoVectorListener("normalized_landmarks",((r,o)=>{this.landmarks=[];for(let i of r)r=we(i),this.landmarks.push(lr(r));d(this,o)})),this.g.attachEmptyPacketListener("normalized_landmarks",(r=>{this.landmarks=[],d(this,r)})),this.g.attachProtoVectorListener("world_landmarks",((r,o)=>{this.worldLandmarks=[];for(let i of r)r=Rn(i),this.worldLandmarks.push(le(r));d(this,o)})),this.g.attachEmptyPacketListener("world_landmarks",(r=>{this.worldLandmarks=[],d(this,r)})),this.outputSegmentationMasks&&(b(e,"SEGMENTATION_MASK:segmentation_masks"),Dn(this,"segmentation_masks"),this.g.aa("segmentation_masks",((r,o)=>{this.segmentationMasks=r.map((i=>Nn(this,i,!0,!this.u))),d(this,o)})),this.g.attachEmptyPacketListener("segmentation_masks",(r=>{this.segmentationMasks=[],d(this,r)}))),t=t.g(),this.setGraph(new Uint8Array(t),!0)}};ht.prototype.detectForVideo=ht.prototype.G,ht.prototype.detect=ht.prototype.F,ht.prototype.setOptions=ht.prototype.o,ht.createFromModelPath=function(t,n){return y(ht,t,{baseOptions:{modelAssetPath:n}})},ht.createFromModelBuffer=function(t,n){return y(ht,t,{baseOptions:{modelAssetBuffer:n}})},ht.createFromOptions=function(t,n){return y(ht,t,n)},ht.POSE_CONNECTIONS=uc;var ji=class extends ee{options;segmenter=null;isSegmenterReady=!1;webGlRenderer;opts;latestCategoryMask=void 0;latestConfidenceMask=void 0;lastFrameTime=-1;constructor(t,n={},e={}){super(t,e),this.options=n}async updateOptions(t){let{basePath:n,modelPath:e}=this.options,r=this.options,o={basePath:n,modelPath:e,...t};this.options=o;try{let i=await this.initializeSegmenterOptions();if(this.options===o){let s=this.opts?.backgroundSource?.media;this.opts=i,s instanceof ImageBitmap&&s!==i.backgroundSource?.media&&s.close()}}catch(i){throw this.options===o&&(this.options=r),i}}async initialize(){this.webGlRenderer=new to(this.canvas),await this.initializeSegmenter()}async initializeSegmenter(){try{this.opts=await this.initializeSegmenterOptions();let t=this.options.basePath||"https://unpkg.com/@stream-io/video-filters-web@1.0.0-beta.3/mediapipe",n=this.options.modelPath||`${t}/models/selfie_segmenter_landscape.tflite`,e=await an.forVisionTasks(`${t}/wasm`);this.segmenter=await q.createFromOptions(e,{baseOptions:{modelAssetPath:n,delegate:"GPU"},runningMode:"VIDEO",outputCategoryMask:!0,outputConfidenceMasks:!0,canvas:this.canvas}),this.isSegmenterReady=!0}catch(t){throw this.isSegmenterReady=!1,this.hooks.onError?.(t),t}}async transform(t){let n=t.timestamp,e=n-this.lastFrameTime>1e3;if(this.lastFrameTime=n,e&&this.isSegmenterReady&&this.segmenter){let r=performance.now();await this.runSegmentation(t),this.webGlRenderer.render(t,this.opts,this.latestCategoryMask,this.latestConfidenceMask),this.updateStats(performance.now()-r)}return new VideoFrame(this.canvas,{timestamp:t.timestamp})}async runSegmentation(t){if(this.segmenter)return new Promise(n=>{let e=Math.floor(performance.now());this.segmenter.segmentForVideo(t,e,r=>{try{this.latestCategoryMask=r.categoryMask?.getAsWebGLTexture(),this.latestConfidenceMask=r.confidenceMasks?.[0]?.getAsWebGLTexture()}catch(o){console.error("[virtual-background] segmentation error:",o),this.hooks.onError?.(o)}finally{r.close(),n()}})})}async initializeSegmenterOptions(){let t=this.options.modelPath?this.options.modelPath.includes("selfie_segmenter"):!0;if(this.options.backgroundFilter==="image")return{backgroundSource:await this.loadBackground(this.options.backgroundImage),bgBlur:0,bgBlurRadius:0,isSelfieMode:t,segmentationOptions:this.options.segmentationOptions};let n=this.options.backgroundBlurLevel,e=typeof n=="string"?_r[n]:Math.round(n??5);return{backgroundSource:void 0,bgBlur:Math.min(e*1.5,20),bgBlurRadius:Math.min(e,10),isSelfieMode:t,segmentationOptions:this.options.segmentationOptions}}async loadBackground(t){if(!t)return null;let n=this.opts?.backgroundSource;if(n?.url===t)return n;let e=await fetch(t,{signal:this.abortController.signal});if(!e.ok)throw new Error(`[virtual-background] Failed to load background image: ${e.status} ${e.statusText}`);return{type:"image",media:await createImageBitmap(await e.blob()),url:t}}onFlush(){this.destroySegmenter()}onStop(){this.webGlRenderer?.close(),this.destroySegmenter()}destroySegmenter(){this.segmenter?.close(),this.segmenter=null,this.isSegmenterReady=!1}get processorName(){return"background-processor"}};var hc=class{canvas;gl;blurProgramHandle;blurLocations;passthroughProgramHandle;passthroughLocations;positionBuffer;texCoordBuffer;pingTexture;pongTexture;pingFbo;pongFbo;inputTexture=null;isRunning=!1;targetWidth=0;targetHeight=0;weightCache=new Map;constructor(t){this.canvas=t;let n=t.getContext("webgl2",{alpha:!1,antialias:!1,desynchronized:!0});if(!n)throw new Error("WebGL2 not supported");this.gl=n;let e=`#version 300 es
      precision highp float;
      in vec2 a_position;
      in vec2 a_texCoord;
      out vec2 v_texCoord;
      void main() {
          v_texCoord = a_texCoord;
          gl_Position = vec4(a_position, 0.0, 1.0);
      }
    `,r=`#version 300 es
      precision highp float;
      in vec2 v_texCoord;
      out vec4 outColor;
      uniform sampler2D u_image;
      uniform vec2 u_texelSize;
      uniform vec2 u_direction;
      uniform float u_weights[25];
      void main() {
          vec4 color = vec4(0.0);
          for (int i = -12; i <= 12; i++) {
              float w = u_weights[i + 12];
              if (w == 0.0) continue;
              vec2 offset = float(i) * u_direction * u_texelSize;
              color += w * texture(u_image, v_texCoord + offset);
          }
          outColor = color;
      }
    `;this.blurProgramHandle=this.createAndLinkProgram(e,r);let o=`#version 300 es
      precision highp float;
      in vec2 v_texCoord;
      out vec4 outColor;
      uniform sampler2D u_image;
      void main() {
          outColor = texture(u_image, v_texCoord);
      }
    `;this.passthroughProgramHandle=this.createAndLinkProgram(e,o);let i=this.blurProgramHandle,s=this.passthroughProgramHandle;this.blurLocations={positionLocation:n.getAttribLocation(i,"a_position"),texCoordLocation:n.getAttribLocation(i,"a_texCoord"),imageLocation:n.getUniformLocation(i,"u_image"),texelSizeLocation:n.getUniformLocation(i,"u_texelSize"),directionLocation:n.getUniformLocation(i,"u_direction"),weightsLocation:n.getUniformLocation(i,"u_weights")},this.passthroughLocations={positionLocation:n.getAttribLocation(s,"a_position"),texCoordLocation:n.getAttribLocation(s,"a_texCoord"),imageLocation:n.getUniformLocation(s,"u_image")},this.positionBuffer=n.createBuffer(),n.bindBuffer(n.ARRAY_BUFFER,this.positionBuffer),n.bufferData(n.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1]),n.STATIC_DRAW),this.texCoordBuffer=n.createBuffer(),n.bindBuffer(n.ARRAY_BUFFER,this.texCoordBuffer),n.bufferData(n.ARRAY_BUFFER,new Float32Array([0,1,1,1,0,0,0,0,1,1,1,0]),n.STATIC_DRAW);let a=()=>{let l=n.createTexture();if(!l)throw new Error("Failed to create texture");return n.bindTexture(n.TEXTURE_2D,l),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_S,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_WRAP_T,n.CLAMP_TO_EDGE),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MIN_FILTER,n.LINEAR),n.texParameteri(n.TEXTURE_2D,n.TEXTURE_MAG_FILTER,n.LINEAR),n.bindTexture(n.TEXTURE_2D,null),l},c=l=>{let u=n.createFramebuffer();if(!u)throw new Error("Failed to create framebuffer");return n.bindFramebuffer(n.FRAMEBUFFER,u),n.framebufferTexture2D(n.FRAMEBUFFER,n.COLOR_ATTACHMENT0,n.TEXTURE_2D,l,0),n.bindFramebuffer(n.FRAMEBUFFER,null),u};this.pingTexture=a(),this.pongTexture=a(),this.pingFbo=c(this.pingTexture),this.pongFbo=c(this.pongTexture),this.inputTexture=a(),n.useProgram(i),n.bindBuffer(n.ARRAY_BUFFER,this.positionBuffer),n.enableVertexAttribArray(this.blurLocations.positionLocation),n.vertexAttribPointer(this.blurLocations.positionLocation,2,n.FLOAT,!1,0,0),n.bindBuffer(n.ARRAY_BUFFER,this.texCoordBuffer),n.enableVertexAttribArray(this.blurLocations.texCoordLocation),n.vertexAttribPointer(this.blurLocations.texCoordLocation,2,n.FLOAT,!1,0,0),this.blurLocations.imageLocation&&n.uniform1i(this.blurLocations.imageLocation,0),this.isRunning=!0}createAndLinkProgram(t,n){let e=this.gl,r=this.createShader(e.VERTEX_SHADER,t),o=this.createShader(e.FRAGMENT_SHADER,n),i=e.createProgram();if(!i)throw new Error("Failed to create program");if(e.attachShader(i,r),e.attachShader(i,o),e.linkProgram(i),!e.getProgramParameter(i,e.LINK_STATUS))throw new Error("Shader link failed: "+e.getProgramInfoLog(i));return e.deleteShader(r),e.deleteShader(o),i}createShader(t,n){let e=this.gl,r=e.createShader(t);if(!r)throw new Error("Failed to create shader");if(e.shaderSource(r,n),e.compileShader(r),!e.getShaderParameter(r,e.COMPILE_STATUS))throw new Error("Shader compile failed: "+e.getShaderInfoLog(r));return r}getGaussianWeights(t){let n=Math.max(0,Math.min(t|0,12)),e=this.weightCache.get(n);if(e)return e;let r=new Float32Array(25);if(n===0)return r[12]=1,this.weightCache.set(n,r),r;let o=n*.6,i=0;for(let s=-n;s<=n;s++){let a=Math.exp(-(s*s)/(2*o*o));r[s+12]=a,i+=a}for(let s=-n;s<=n;s++)r[s+12]/=i;return this.weightCache.set(n,r),r}render(t,n){if(!this.isRunning)return;let e=this.gl,r=t.displayWidth,o=t.displayHeight;if(!r||!o)return;(this.canvas.width!==r||this.canvas.height!==o)&&(this.canvas.width=r,this.canvas.height=o);let i=.15,s=Math.max(1,Math.floor(r*i)),a=Math.max(1,Math.floor(o*i));(s!==this.targetWidth||a!==this.targetHeight)&&(this.targetWidth=s,this.targetHeight=a,e.bindTexture(e.TEXTURE_2D,this.pingTexture),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,s,a,0,e.RGBA,e.UNSIGNED_BYTE,null),e.bindTexture(e.TEXTURE_2D,this.pongTexture),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,s,a,0,e.RGBA,e.UNSIGNED_BYTE,null),e.bindTexture(e.TEXTURE_2D,null)),e.activeTexture(e.TEXTURE0),e.bindTexture(e.TEXTURE_2D,this.inputTexture),e.texImage2D(e.TEXTURE_2D,0,e.RGBA,e.RGBA,e.UNSIGNED_BYTE,t),e.useProgram(this.blurProgramHandle),this.blurLocations.texelSizeLocation&&e.uniform2f(this.blurLocations.texelSizeLocation,1/s,1/a);let c=this.getGaussianWeights(n);this.blurLocations.weightsLocation&&e.uniform1fv(this.blurLocations.weightsLocation,c),e.viewport(0,0,s,a),e.bindFramebuffer(e.FRAMEBUFFER,this.pingFbo),e.bindTexture(e.TEXTURE_2D,this.inputTexture),this.blurLocations.directionLocation&&e.uniform2f(this.blurLocations.directionLocation,1,0),e.drawArrays(e.TRIANGLES,0,6),e.bindFramebuffer(e.FRAMEBUFFER,this.pongFbo),e.bindTexture(e.TEXTURE_2D,this.pingTexture),this.blurLocations.directionLocation&&e.uniform2f(this.blurLocations.directionLocation,0,1),e.drawArrays(e.TRIANGLES,0,6),e.bindFramebuffer(e.FRAMEBUFFER,null),e.viewport(0,0,r,o),e.useProgram(this.passthroughProgramHandle),e.bindBuffer(e.ARRAY_BUFFER,this.positionBuffer),e.enableVertexAttribArray(this.passthroughLocations.positionLocation),e.vertexAttribPointer(this.passthroughLocations.positionLocation,2,e.FLOAT,!1,0,0),e.bindBuffer(e.ARRAY_BUFFER,this.texCoordBuffer),e.enableVertexAttribArray(this.passthroughLocations.texCoordLocation),e.vertexAttribPointer(this.passthroughLocations.texCoordLocation,2,e.FLOAT,!1,0,0),e.bindTexture(e.TEXTURE_2D,this.pongTexture),this.passthroughLocations.imageLocation&&e.uniform1i(this.passthroughLocations.imageLocation,0),e.drawArrays(e.TRIANGLES,0,6)}close(){if(!this.isRunning)return;this.isRunning=!1;let t=this.gl;this.pingFbo&&t.deleteFramebuffer(this.pingFbo),this.pongFbo&&t.deleteFramebuffer(this.pongFbo),this.pingTexture&&t.deleteTexture(this.pingTexture),this.pongTexture&&t.deleteTexture(this.pongTexture),this.inputTexture&&t.deleteTexture(this.inputTexture),this.positionBuffer&&t.deleteBuffer(this.positionBuffer),this.texCoordBuffer&&t.deleteBuffer(this.texCoordBuffer),t.deleteProgram(this.blurProgramHandle),t.deleteProgram(this.passthroughProgramHandle)}};var f2=class extends ee{blurRenderer;blurRadius;constructor(t,n={},e={}){super(t,e),this.blurRadius=n.blurRadius??6}async initialize(){this.blurRenderer=new hc(this.canvas)}async transform(t){return this.blurRenderer.render(t,this.blurRadius),new VideoFrame(this.canvas,{timestamp:t.timestamp})}onStop(){this.blurRenderer?.close()}get processorName(){return"fullscreen-blur"}};var Zn,lc=()=>{if(Zn!==void 0)return Zn;if(Zn=!1,typeof document>"u"||typeof MessageChannel>"u")return!1;let t=document.createElement("canvas");if(typeof t.captureStream!="function")return!1;let[n]=t.captureStream().getVideoTracks();if(!n)return!1;let e=new MessageChannel;try{e.port1.postMessage(n,[n]),Zn=!0}catch{Zn=!1}finally{e.port1.close(),e.port2.close(),n.stop()}return Zn};var pc=t=>{let n={...t};for(let e of["basePath","modelPath","backgroundImage"]){let r=n[e];r&&(n[e]=new URL(r,location.href).href)}return n},Hi=class{track;hooks;options;worker;output;starting;stopped=!1;pendingStart;pendingUpdates=new Map;nextUpdateId=1;constructor(t,n={},e={}){this.track=t,this.options=n,this.hooks=e}static isSupported=()=>typeof Worker<"u"&&typeof VideoFrame<"u"&&typeof MediaStreamTrackProcessor>"u"&&lc();start=async()=>{this.starting=this.startWorker();try{this.output=await this.starting}catch(t){throw this.disposeWorker(),t}return this.track.addEventListener("ended",this.stop,{once:!0}),this.output};updateOptions=async t=>{let{basePath:n,modelPath:e}=this.options,r=this.options;if(this.options={basePath:n,modelPath:e,...t},!this.worker){this.starting&&!this.output&&await this.starting;return}let o=this.nextUpdateId++;return new Promise((i,s)=>{this.pendingUpdates.set(o,{resolve:i,reject:a=>{this.options!==r&&(this.options=r),s(a)}}),this.post({type:"update",id:o,options:pc(t)})})};stop=()=>{this.stopped||(this.stopped=!0,this.track.removeEventListener("ended",this.stop),this.output?.stop(),this.settleStart(new Error("Stopped")),this.worker&&(setTimeout(this.disposeWorker,1e3),this.post({type:"stop"})))};startWorker=async()=>{let{default:t}=await Promise.resolve().then(()=>(mc(),gc));if(this.stopped)throw new Error("Stopped");let n=new t({name:"stream-video-filters"});this.worker=n,n.onmessage=o=>this.dispatch(o.data),n.onerror=o=>this.fail(new Error(o.message||"Can't load the worker. Allow `worker-src blob:` in the Content-Security-Policy."));let e=new Promise((o,i)=>{this.pendingStart={resolve:o,reject:i}}),r=this.track.clone();return this.post({type:"start",track:r,options:pc(this.options)},[r]),e};dispatch=t=>{switch(t.type){case"started":this.pendingStart?.resolve(t.track),this.pendingStart=void 0;break;case"stats":this.hooks.onStats?.(t.stats);break;case"updated":case"updateError":{let n=this.pendingUpdates.get(t.id);this.pendingUpdates.delete(t.id),t.type==="updated"?n?.resolve():n?.reject(new Error(t.message));break}case"error":this.fail(new Error(t.message));break;case"stopped":this.disposeWorker()}};fail=t=>{this.pendingStart?this.settleStart(t):this.hooks.onError?.(t)};settleStart=t=>{this.pendingStart?.reject(t),this.pendingStart=void 0};disposeWorker=()=>{this.settleStart(new Error("Worker terminated"));for(let t of this.pendingUpdates.values())t.reject(new Error("Stopped"));this.pendingUpdates.clear(),this.worker?.terminate(),this.worker=void 0};post=(t,n=[])=>this.worker?.postMessage(t,n)};var m2=(t,n={},e={})=>Hi.isSupported()?new Hi(t,n,e):new ji(t,n,e);export{_r as BACKGROUND_BLUR_MAP,ee as BaseVideoProcessor,f2 as FullScreenBlur,ji as VirtualBackground,m2 as createVirtualBackground,Rc as isMediaPipePlatformSupported,kc as loadMediaPipe};
