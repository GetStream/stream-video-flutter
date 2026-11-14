// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      AC: Function.prototype.call.bind(DataView.prototype.setInt16),
      AD: x0 => x0.height,
      AE: (x0,x1) => x0.observe(x1),
      AF: x0 => x0.wheelDeltaY,
      AG: x0 => x0.v8BreakIterator,
      AH: x0 => x0.hash,
      AI: x0 => x0.unlock(),
      AJ: () => new AbortController(),
      AK: x0 => x0.kind,
      AL: x0 => x0.stop(),
      AM: x0 => x0.document,
      AN: x0 => x0.image,
      AO: (x0,x1) => x0.objectStore(x1),
      AP: x0 => x0.send(),
      AQ: x0 => x0.metaKey,
      AR: (x0,x1,x2) => new File(x0,x1,x2),
      AS: x0 => ({video: x0}),
      AT: (x0,x1) => { x0.preload = x1 },
      AU: x0 => x0.hostname,
      AV: x0 => x0.signInMethod,
      AW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      B: s => printToConsole(s),
      BB: b => !!b,
      BC: Function.prototype.call.bind(DataView.prototype.setUint16),
      BD: x0 => x0.width,
      BE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      BF: x0 => x0.wheelDeltaX,
      BG: () => globalThis.Intl,
      BH: x0 => x0.location,
      BI: (x0,x1) => x0.lock(x1),
      BJ: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      BK: x0 => x0.mediaDevices,
      BL: (x0,x1) => x0.replaceTrack(x1),
      BM: (x0,x1,x2) => x0.setAttribute(x1,x2),
      BN: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      BO: (x0,x1) => x0.getAll(x1),
      BP: x0 => x0.status,
      BQ: x0 => x0.altKey,
      BR: (x0,x1) => { x0.type = x1 },
      BS: x0 => x0.active,
      BT: x0 => x0.src,
      BU: x0 => x0.location,
      BV: x0 => x0.providerId,
      BW: (x0,x1) => { x0.ondragleave = x1 },
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      CC: Function.prototype.call.bind(DataView.prototype.setUint8),
      CD: x0 => x0.screen,
      CE: x0 => new ResizeObserver(x0),
      CF: x0 => x0.key,
      CG: (x0,x1) => x0.segment(x1),
      CH: x0 => x0.search,
      CI: x0 => x0.orientation,
      CJ: (x0,x1) => globalThis.fetch(x0,x1),
      CK: x0 => x0.restartIce(),
      CL: x0 => x0.clone(),
      CM: x0 => x0.message,
      CN: x0 => new window.ImageDecoder(x0),
      CO: x0 => x0.value,
      CP: x0 => x0.response,
      CQ: x0 => x0.ctrlKey,
      CR: x0 => ({name: x0}),
      CS: x0 => x0.geolocation,
      CT: (x0,x1) => x0.getAttribute(x1),
      CU: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      CV: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      CW: x0 => x0.preventDefault(),
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (x0,x1) => x0.focus(x1),
      DC: Function.prototype.call.bind(DataView.prototype.setInt8),
      DD: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      DE: (x0,x1) => x0.getPropertyValue(x1),
      DF: x0 => x0.identifier,
      DG: x0 => x0.index,
      DH: x0 => x0.pathname,
      DI: (x0,x1) => x0.querySelector(x1),
      DJ: (x0,x1) => x0.get(x1),
      DK: x0 => x0.close(),
      DL: x0 => x0.track,
      DM: x0 => x0.code,
      DN: x0 => x0.name,
      DO: x0 => x0.openCursor(),
      DP: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      DQ: x0 => x0.isComposing,
      DR: (x0,x1) => x0.query(x1),
      DS: x0 => x0.baseURI,
      DT: (x0,x1) => x0.debug(x1),
      DU: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      DV: x0 => x0.username,
      DW: x0 => x0.clientY,
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: () => ({}),
      EC: Function.prototype.call.bind(DataView.prototype.getInt8),
      ED: x0 => x0.tabIndex,
      EE: x0 => globalThis.parseFloat(x0),
      EF: x0 => x0.touches,
      EG: x0 => x0.next(),
      EH: x0 => x0.parentElement,
      EI: (x0,x1) => { x0.title = x1 },
      EJ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      EK: (x0,x1) => x0.createOffer(x1),
      EL: x0 => x0.sender,
      EM: x0 => x0.error,
      EN: x0 => x0.repetitionCount,
      EO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      EP: (x0,x1) => { x0.responseType = x1 },
      EQ: x0 => x0.code,
      ER: (o,s,v) => o[s] = v,
      ES: (x0,x1) => x0.call(x1),
      ET: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      EU: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      EV: x0 => x0.providerId,
      EW: x0 => x0.clientX,
      F: () => new Error().stack,
      FB: (o, p, v) => o[p] = v,
      FC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      FD: (x0,x1) => x0.contains(x1),
      FE: (x0,x1) => x0.getComputedStyle(x1),
      FF: x0 => x0.pressure,
      FG: x0 => x0.value,
      FH: (x0,x1) => x0.querySelectorAll(x1),
      FI: (x0,x1) => x0.vibrate(x1),
      FJ: (x0,x1) => x0.forEach(x1),
      FK: x0 => x0.type,
      FL: x0 => x0.getVideoTracks(),
      FM: x0 => x0.videoHeight,
      FN: x0 => x0.frameCount,
      FO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FP: () => new XMLHttpRequest(),
      FQ: x0 => x0.repeat,
      FR: () => Symbol("jsBoxedDartObjectProperty"),
      FS: x0 => x0.reset,
      FT: x0 => ({createScriptURL: x0}),
      FU: () => globalThis.firebase_auth.debugErrorMap,
      FV: x0 => x0.profile,
      FW: (x0,x1) => { x0.ondragover = x1 },
      G: s => JSON.stringify(s),
      GB: () => [],
      GC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      GD: x0 => x0.activeElement,
      GE: x0 => x0.documentElement,
      GF: x0 => x0.tiltY,
      GG: x0 => x0.done,
      GH: (d, digits) => d.toFixed(digits),
      GI: x0 => x0.content,
      GJ: x0 => x0.name,
      GK: x0 => x0.sdp,
      GL: x0 => x0.getAudioTracks(),
      GM: x0 => x0.videoWidth,
      GN: x0 => x0.selectedTrack,
      GO: x0 => x0.continue(),
      GP: () => globalThis.window.navigator.userAgent,
      GQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GR: x0 => x0.state,
      GS: x0 => x0.stopContinuousDecode,
      GT: (x0,x1,x2) => x0.createPolicy(x1,x2),
      GU: () => globalThis.firebase_auth.browserSessionPersistence,
      GV: x0 => x0.isNewUser,
      GW: (x0,x1) => { x0.ondragenter = x1 },
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (a, i) => a.push(i),
      HC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      HD: x0 => x0.parentNode,
      HE: x0 => x0.computedStyleMap(),
      HF: x0 => x0.tiltX,
      HG: (o, m, a) => o[m].apply(o, a),
      HH: x0 => x0.maxHeight,
      HI: x0 => x0.document,
      HJ: x0 => x0.statusText,
      HK: (x0,x1,x2) => x0.addTransceiver(x1,x2),
      HL: (x0,x1) => x0.getUserMedia(x1),
      HM: (x0,x1) => { x0.controls = x1 },
      HN: x0 => x0.completed,
      HO: x0 => x0.target,
      HP: x0 => x0.close(),
      HQ: (x0,x1) => { x0.loop = x1 },
      HR: x0 => x0.permissions,
      HS: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      HT: (x0,x1) => x0.createScriptURL(x1),
      HU: () => globalThis.firebase_auth.browserLocalPersistence,
      HV: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      HW: (x0,x1) => { x0.ondrop = x1 },
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Int8Array(x0),
      IC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      ID: x0 => x0.tagName,
      IE: (x0,x1) => x0.get(x1),
      IF: x0 => x0.pointerType,
      IG: x0 => x0.iterator,
      IH: x0 => x0.maxWidth,
      II: x0 => new WeakRef(x0),
      IJ: x0 => x0.url,
      IK: x0 => new RTCPeerConnection(x0),
      IL: (x0,x1) => ({video: x0,audio: x1}),
      IM: (x0,x1) => x0.removeTrack(x1),
      IN: x0 => x0.ready,
      IO: (x0,x1) => x0.getAllKeys(x1),
      IP: x0 => x0.getTracks(),
      IQ: (x0,x1) => { x0.volume = x1 },
      IR: (x0,x1) => x0.append(x1),
      IS: x0 => x0.text,
      IT: (x0,x1) => { x0.nonce = x1 },
      IU: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      IV: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      IW: x0 => x0.webkitGetAsEntry(),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      JC: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      JD: x0 => x0.target,
      JE: (o, p) => p in o,
      JF: x0 => x0.pointerId,
      JG: () => globalThis.Symbol,
      JH: x0 => x0.minHeight,
      JI: x0 => x0.deref(),
      JJ: x0 => x0.status,
      JK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JL: (x0,x1) => x0.getDisplayMedia(x1),
      JM: (x0,x1,x2) => ({candidate: x0,sdpMid: x1,sdpMLineIndex: x2}),
      JN: x0 => x0.tracks,
      JO: x0 => x0.key,
      JP: x0 => ({audio: x0}),
      JQ: (x0,x1) => { x0.src = x1 },
      JR: x0 => x0.head,
      JS: x0 => x0.barcodeFormat,
      JT: (x0,x1) => x0.querySelectorAll(x1),
      JU: x0 => x0.name,
      JV: x0 => x0.session,
      JW: x0 => x0.createReader(),
      K: o => o,
      KB: x0 => new Uint8Array(x0),
      KC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      KD: x0 => x0.clientY,
      KE: (x0,x1) => { x0.textContent = x1 },
      KF: x0 => x0.getCoalescedEvents(),
      KG: (x0,x1) => new Intl.Segmenter(x0,x1),
      KH: x0 => x0.minWidth,
      KI: () => globalThis.WeakRef,
      KJ: x0 => x0.getReader(),
      KK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      KL: x0 => x0.getSettings(),
      KM: (x0,x1) => x0.addIceCandidate(x1),
      KN: () => globalThis.window.ImageDecoder,
      KO: x0 => x0.close(),
      KP: () => new AudioContext(),
      KQ: (x0,x1) => x0.start(x1),
      KR: (x0,x1) => { x0.src = x1 },
      KS: x0 => x0.rawBytes,
      KT: x0 => x0.nonce,
      KU: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7,recaptchaSiteKey: x8}),
      KV: x0 => x0.phoneNumber,
      KW: () => new Blob(),
      L: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      LB: x0 => new Uint8ClampedArray(x0),
      LC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      LD: x0 => x0.clientX,
      LE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      LF: (x0,x1) => x0.getModifierState(x1),
      LG: x0 => x0.Segmenter,
      LH: (x0,x1) => x0.removeProperty(x1),
      LI: (x0,x1,x2) => x0.supports(x1,x2),
      LJ: x0 => x0.read(),
      LK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      LL: x0 => x0.groupId,
      LM: x0 => x0.type,
      LN: (x0,x1,x2,x3) => ({name: x0,hash: x1,salt: x2,iterations: x3}),
      LO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      LP: (x0,x1) => x0.createMediaStreamSource(x1),
      LQ: (x0,x1) => x0.end(x1),
      LR: (x0,x1) => { x0.charset = x1 },
      LS: x0 => x0.y,
      LT: (x0,x1) => { x0.src = x1 },
      LU: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      LV: x0 => x0.uid,
      LW: (x0,x1,x2,x3) => x0.slice(x1,x2,x3),
      M: x0 => x0.index,
      MB: x0 => new Int16Array(x0),
      MC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      MD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      ME: x0 => x0.matches,
      MF: s => s.trimLeft(),
      MG: x0 => x0.buffer,
      MH: (x0,x1) => x0.add(x1),
      MI: () => globalThis.CSS,
      MJ: x0 => x0.value,
      MK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ML: x0 => x0.deviceId,
      MM: x0 => x0.sdp,
      MN: (x0,x1,x2) => globalThis.crypto.subtle.deriveBits(x0,x1,x2),
      MO: (x0,x1) => x0.deleteObjectStore(x1),
      MP: x0 => x0.createAnalyser(),
      MQ: x0 => x0.length,
      MR: (x0,x1) => { x0.type = x1 },
      MS: x0 => x0.x,
      MT: x0 => x0.trustedTypes,
      MU: x0 => x0.storageBucket,
      MV: x0 => x0.enrollmentTime,
      MW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      N: o => String(o),
      NB: x0 => new Uint16Array(x0),
      NC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      ND: x0 => x0.getBoundingClientRect(),
      NE: (x0,x1) => x0.matchMedia(x1),
      NF: s => s.toUpperCase(),
      NG: x0 => x0.wasmMemory,
      NH: x0 => x0.data,
      NI: (x0,x1) => { x0.innerText = x1 },
      NJ: x0 => x0.done,
      NK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      NL: x0 => x0.resizeMode,
      NM: x0 => x0.remoteDescription,
      NN: (x0,x1,x2,x3,x4) => globalThis.crypto.subtle.importKey(x0,x1,x2,x3,x4),
      NO: x0 => x0.length,
      NP: (x0,x1) => x0.connect(x1),
      NQ: x0 => x0.buffered,
      NR: (x0,x1) => x0.item(x1),
      NS: x0 => x0.resultPoints,
      NT: x0 => x0.trustedTypes,
      NU: x0 => x0.databaseURL,
      NV: x0 => x0.factorId,
      NW: (x0,x1) => x0.file(x1),
      O: o => o === undefined,
      OB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      OC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      OD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      OE: x0 => x0.matches,
      OF: x0 => x0.pop(),
      OG: () => globalThis.window._flutter_skwasmInstance,
      OH: (x0,x1) => { x0.scrollTop = x1 },
      OI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      OJ: x0 => x0.cancel(),
      OK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OL: x0 => x0.facingMode,
      OM: x0 => x0.input,
      ON: () => globalThis.window.isSecureContext,
      OO: x0 => x0.name,
      OP: (x0,x1) => x0.getByteFrequencyData(x1),
      OQ: x0 => x0.duration,
      OR: x0 => x0.id,
      OS: x0 => x0.message,
      OT: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      OU: x0 => x0.apiKey,
      OV: x0 => x0.displayName,
      OW: x0 => x0.lastModified,
      P: (x0,x1) => x0.exec(x1),
      PB: x0 => new Int32Array(x0),
      PC: (x0,x1) => x0.querySelector(x1),
      PD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      PE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      PF: x0 => x0.flags,
      PG: () => new TextDecoder(),
      PH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      PI: (a, s, e) => a.slice(s, e),
      PJ: x0 => x0.body,
      PK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PL: x0 => x0.frameRate,
      PM: (x0,x1) => ({type: x0,sdp: x1}),
      PN: () => globalThis.crypto.subtle,
      PO: (x0,x1) => x0.get(x1),
      PP: x0 => x0.frequencyBinCount,
      PQ: (x0,x1) => { x0.playsInline = x1 },
      PR: x0 => x0.length,
      PS: x0 => x0.videoElement,
      PT: x0 => { globalThis.onGoogleLibraryLoad = x0 },
      PU: x0 => x0.options,
      PV: x0 => x0.hints,
      PW: x0 => x0.fullPath,
      Q: (x0,x1) => { x0.lastIndex = x1 },
      QB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      QC: (x0,x1) => x0.item(x1),
      QD: Date.now,
      QE: f => f.dartFunction,
      QF: (a, s) => a.join(s),
      QG: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      QH: (x0,x1) => { x0.value = x1 },
      QI: () => new XMLHttpRequest(),
      QJ: x0 => x0.headers,
      QK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      QL: x0 => x0.aspectRatio,
      QM: (x0,x1) => x0.setLocalDescription(x1),
      QN: (x0,x1) => x0.item(x1),
      QO: (x0,x1) => x0.createObjectStore(x1),
      QP: x0 => x0.resume(),
      QQ: (x0,x1) => { x0.width = x1 },
      QR: x0 => x0.stop(),
      QS: x0 => x0.decodeContinuously,
      QT: x0 => x0.message,
      QU: () => globalThis.firebase_core.SDK_VERSION,
      QV: x0 => x0.tenantId,
      QW: x0 => x0.name,
      R: o => o,
      RB: x0 => new Uint32Array(x0),
      RC: x0 => x0.length,
      RD: (handle) => clearTimeout(handle),
      RE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RF: (x0,x1) => x0.error(x1),
      RG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      RH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      RI: (x0,x1,x2) => x0.open(x1,x2),
      RJ: x0 => x0.signal,
      RK: x0 => x0.id,
      RL: x0 => x0.height,
      RM: (x0,x1) => x0.createAnswer(x1),
      RN: x0 => x0.name,
      RO: x0 => x0.version,
      RP: x0 => x0.state,
      RQ: (x0,x1) => { x0.height = x1 },
      RR: (x0,x1,x2) => ({mimeType: x0,audioBitsPerSecond: x1,bitsPerSecond: x2}),
      RS: (x0,x1) => new ZXing.BrowserMultiFormatReader(x0,x1),
      RT: x0 => x0.code,
      RU: (x0,x1,x2) => globalThis.firebase_core.registerVersion(x0,x1,x2),
      RV: x0 => x0.phoneNumber,
      RW: (a, l) => a.length = l,
      S: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      SB: x0 => new Float32Array(x0),
      SC: (x0,x1) => x0.querySelectorAll(x1),
      SD: (x0,x1) => x0.closest(x1),
      SE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SF: () => globalThis.console,
      SG: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      SH: (x0,x1) => { x0.value = x1 },
      SI: (x0,x1) => x0.send(x1),
      SJ: (o, p) => p in o,
      SK: x0 => x0.streams,
      SL: x0 => x0.width,
      SM: (x0,x1) => ({type: x0,sdp: x1}),
      SN: x0 => x0.type,
      SO: x0 => x0.objectStoreNames,
      SP: (x0,x1) => { x0.fftSize = x1 },
      SQ: (x0,x1) => { x0.border = x1 },
      SR: (x0,x1) => new MediaRecorder(x0,x1),
      SS: (x0,x1) => ({width: x0,height: x1}),
      ST: (x0,x1) => globalThis.firebase_messaging.getToken(x0,x1),
      SU: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SV: x0 => x0.email,
      SW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      T: o => o instanceof RegExp,
      TB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      TC: (x0,x1) => x0.getAttribute(x1),
      TD: x0 => x0.bottom,
      TE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      TF: s => s.trimRight(),
      TG: (a, i) => a.splice(i, 1),
      TH: x0 => x0.value,
      TI: x0 => x0.send(),
      TJ: x0 => x0.groups,
      TK: x0 => x0.transceiver,
      TL: x0 => x0.channelCount,
      TM: (x0,x1) => x0.setRemoteDescription(x1),
      TN: x0 => x0.length,
      TO: (x0,x1) => { x0.onupgradeneeded = x1 },
      TP: (x0,x1) => x0.querySelectorAll(x1),
      TQ: x0 => x0.pause(),
      TR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      TS: (x0,x1,x2) => ({width: x0,height: x1,facingMode: x2}),
      TT: x0 => x0.link,
      TU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      TV: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      TW: (x0,x1) => x0.readEntries(x1),
      U: (string, times) => string.repeat(times),
      UB: x0 => new Float64Array(x0),
      UC: x0 => x0.remove(),
      UD: x0 => x0.top,
      UE: (o, i) => o[i],
      UF: x0 => x0.blur(),
      UG: a => a.pop(),
      UH: x0 => x0.selectionDirection,
      UI: x0 => x0.abort(),
      UJ: (x0,x1) => x0.getElementById(x1),
      UK: x0 => x0.receiver,
      UL: x0 => x0.latency,
      UM: x0 => x0.mid,
      UN: x0 => x0.files,
      UO: (x0,x1) => { x0.height = x1 },
      UP: (x0,x1) => x0.item(x1),
      UQ: x0 => x0.message,
      UR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      US: x0 => x0.facingMode,
      UT: x0 => x0.analyticsLabel,
      UU: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      UV: x0 => x0.customData,
      UW: x0 => x0.isDirectory,
      V: o => o,
      VB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      VC: (x0,x1) => x0.appendChild(x1),
      VD: x0 => x0.right,
      VE: o => o.length,
      VF: x0 => x0.button,
      VG: (map, o, v) => map.set(o, v),
      VH: x0 => x0.selectionStart,
      VI: x0 => x0.readyState,
      VJ: (x0,x1) => x0.setSinkId(x1),
      VK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      VL: x0 => x0.noiseSuppression,
      VM: x0 => x0.localDescription,
      VN: x0 => x0.clipboardData,
      VO: (x0,x1) => { x0.width = x1 },
      VP: x0 => x0.length,
      VQ: (x0,x1) => { x0.currentTime = x1 },
      VR: (x0,x1) => x0.start(x1),
      VS: x0 => x0.attachStreamToVideo,
      VT: x0 => x0.image,
      VU: (x0,x1) => x0.createScriptURL(x1),
      VV: x0 => x0.message,
      VW: (x0,x1) => x0[x1],
      W: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      WB: x0 => new ArrayBuffer(x0),
      WC: (x0,x1) => x0.append(x1),
      WD: x0 => x0.left,
      WE: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      WF: x0 => x0.innerHeight,
      WG: (map, o) => map.get(o),
      WH: x0 => x0.selectionEnd,
      WI: x0 => x0.total,
      WJ: () => globalThis.document,
      WK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WL: x0 => x0.autoGainControl,
      WM: x0 => x0.enumerateDevices(),
      WN: x0 => new Blob(x0),
      WO: (x0,x1) => { x0.objectFit = x1 },
      WP: (x0,x1,x2) => x0.insertBefore(x1,x2),
      WQ: (x0,x1) => { x0.playbackRate = x1 },
      WR: (x0,x1) => { x0.smoothingTimeConstant = x1 },
      WS: () => new Map(),
      WT: x0 => x0.body,
      WU: (x0,x1,x2) => x0.createScript(x1,x2),
      WV: x0 => x0.code,
      WW: x0 => x0.length,
      X: x0 => x0.dotAll,
      XB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      XC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      XD: x0 => x0.clientY,
      XE: x0 => x0.language,
      XF: x0 => x0.innerWidth,
      XG: () => new WeakMap(),
      XH: x0 => x0.value,
      XI: x0 => x0.loaded,
      XJ: (x0,x1) => x0.createElement(x1),
      XK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XL: x0 => x0.echoCancellation,
      XM: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XN: x0 => ({type: x0}),
      XO: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      XP: x0 => x0.id,
      XQ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      XR: (x0,x1) => { x0.maxDecibels = x1 },
      XS: (x0,x1,x2) => x0.set(x1,x2),
      XT: x0 => x0.title,
      XU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XV: (x0,x1) => globalThis.firebase_auth.signInWithPopup(x0,x1),
      XW: x0 => x0.items,
      Y: x0 => x0.unicode,
      YB: (x0,x1,x2) => new DataView(x0,x1,x2),
      YC: x0 => x0.style,
      YD: x0 => x0.clientX,
      YE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      YF: x0 => x0.height,
      YG: x0 => x0.debugSkipFontRetryDelay,
      YH: x0 => x0.selectionDirection,
      YI: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      YJ: x0 => x0.userAgent,
      YK: x0 => x0.id,
      YL: x0 => x0.sampleSize,
      YM: (x0,x1) => { x0.ondevicechange = x1 },
      YN: (x0,x1) => new Blob(x0,x1),
      YO: (x0,x1) => x0.requestVideoFrameCallback(x1),
      YP: x0 => x0.offsetHeight,
      YQ: x0 => globalThis.URL.revokeObjectURL(x0),
      YR: (x0,x1) => { x0.minDecibels = x1 },
      YS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      YT: x0 => x0.fcmOptions,
      YU: (o, p) => delete o[p],
      YV: (x0,x1) => x0.setCustomParameters(x1),
      YW: x0 => x0.dataTransfer,
      Z: x0 => x0.ignoreCase,
      ZB: (o, p) => o[p],
      ZC: x0 => x0.debugShowSemanticsNodes,
      ZD: x0 => x0.changedTouches,
      ZE: () => globalThis.window.FinalizationRegistry,
      ZF: x0 => x0.width,
      ZG: x0 => x0.status,
      ZH: x0 => x0.selectionStart,
      ZI: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      ZJ: x0 => x0.navigator,
      ZK: x0 => x0.muted,
      ZL: x0 => x0.sampleRate,
      ZM: x0 => x0.naturalHeight,
      ZN: x0 => x0.size,
      ZO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ZP: x0 => x0.offsetWidth,
      ZQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ZR: x0 => ({sampleRate: x0}),
      ZS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ZT: x0 => x0.notification,
      ZU: (o, p, v) => o[p] = v,
      ZV: (x0,x1) => x0.addScope(x1),
      ZW: x0 => x0.level,
      a: x0 => x0.multiline,
      aB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      aC: (x0,x1) => x0.warn(x1),
      aD: x0 => x0.offsetY,
      aE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aF: x0 => x0.clientHeight,
      aG: (x0,x1,x2) => x0.set(x1,x2),
      aH: x0 => x0.selectionEnd,
      aI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aJ: () => globalThis.window,
      aK: x0 => x0.label,
      aL: x0 => x0.stop(),
      aM: x0 => x0.naturalWidth,
      aN: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      aO: (x0,x1) => x0.requestAnimationFrame(x1),
      aP: x0 => x0.stopPropagation(),
      aQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aR: x0 => new AudioContext(x0),
      aS: (x0,x1) => { x0.onpause = x1 },
      aT: x0 => x0.messageId,
      aU: (x0,x1) => { x0.text = x1 },
      aV: () => new firebase_auth.GoogleAuthProvider(),
      aW: x0 => x0.getBattery(),
      b: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      bB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      bC: x0 => x0.console,
      bD: x0 => x0.offsetX,
      bE: x0 => new window.FinalizationRegistry(x0),
      bF: x0 => x0.clientWidth,
      bG: x0 => x0.arrayBuffer(),
      bH: x0 => x0.keyCode,
      bI: x0 => x0.upload,
      bJ: (x0,x1) => x0.append(x1),
      bK: x0 => x0.kind,
      bL: x0 => x0.getParameters(),
      bM: (x0,x1) => x0.createElement(x1),
      bN: x0 => x0.vendor,
      bO: (x0,x1,x2,x3) => x0.call(x1,x2,x3),
      bP: x0 => x0.disabled,
      bQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      bR: (x0,x1) => { x0.onstop = x1 },
      bS: (x0,x1) => { x0.onplay = x1 },
      bT: x0 => x0.from,
      bU: (x0,x1) => { x0.text = x1 },
      bV: x0 => x0.firstChild,
      bW: x0 => x0.length,
      c: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      cB: o => o.byteOffset,
      cC: () => globalThis.window,
      cD: x0 => x0.type,
      cE: (x0,x1) => x0.unregister(x1),
      cF: (x0,x1) => { x0.content = x1 },
      cG: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      cH: (x0,x1) => x0.scrollIntoView(x1),
      cI: x0 => x0.responseURL,
      cJ: () => new MediaStream(),
      cK: x0 => x0.track,
      cL: (x0,x1) => x0.setParameters(x1),
      cM: (x0,x1) => { x0.pointerEvents = x1 },
      cN: o => o.byteLength,
      cO: x0 => x0.currentTime,
      cP: (x0,x1) => { x0.min = x1 },
      cQ: (x0,x1) => { x0.crossOrigin = x1 },
      cR: (x0,x1) => globalThis.jsFixWebmDuration(x0,x1),
      cS: (x0,x1) => { x0.transformOrigin = x1 },
      cT: x0 => x0.collapseKey,
      cU: x0 => x0.trustedTypes,
      cV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      cW: x0 => x0.getReader(),
      d: (x0,x1) => x0.didCreateEngineInitializer(x1),
      dB: o => o.buffer,
      dC: (o, c) => o instanceof c,
      dD: x0 => x0.maxTouchPoints,
      dE: (x0,x1) => x0.contains(x1),
      dF: (x0,x1) => { x0.name = x1 },
      dG: (x0,x1) => x0.fetch(x1),
      dH: x0 => x0.multiViewEnabled,
      dI: x0 => x0.statusText,
      dJ: (x0,x1) => x0.addTrack(x1),
      dK: x0 => x0.connectionState,
      dL: (x0,x1) => { x0.encodings = x1 },
      dM: (x0,x1) => { x0.height = x1 },
      dN: () => new FileReader(),
      dO: (x0,x1) => x0.append(x1),
      dP: (x0,x1) => { x0.max = x1 },
      dQ: (x0,x1) => x0.getContext(x1),
      dR: x0 => x0.mimeType,
      dS: x0 => x0.getSupportedConstraints(),
      dT: x0 => x0.data,
      dU: x0 => x0.providerId,
      dV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      dW: x0 => x0.value,
      e: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eB: Function.prototype.call.bind(DataView.prototype.getUint8),
      eC: (x0,x1) => x0[x1],
      eD: x0 => x0.platform,
      eE: (s) => +s,
      eF: x0 => x0.head,
      eG: x0 => x0.fontFallbackBaseUrl,
      eH: (x0,x1) => x0.replaceWith(x1),
      eI: x0 => x0.getAllResponseHeaders(),
      eJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eK: x0 => x0.signalingState,
      eL: x0 => x0.clockRate,
      eM: (x0,x1) => { x0.width = x1 },
      eN: (x0,x1) => x0.readAsArrayBuffer(x1),
      eO: (x0,x1,x2) => x0.insertRule(x1,x2),
      eP: (x0,x1) => { x0.disabled = x1 },
      eQ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      eR: (x0,x1) => { x0.ondataavailable = x1 },
      eS: x0 => ({facingMode: x0}),
      eT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eU: x0 => x0.providerData,
      eV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eW: x0 => x0.done,
      f: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      fB: (b, o) => new DataView(b, o),
      fC: x0 => x0.length,
      fD: x0 => x0.body,
      fE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      fF: (x0,x1) => x0.removeChild(x1),
      fG: (handle) => clearInterval(handle),
      fH: (x0,x1) => { x0.type = x1 },
      fI: x0 => x0.status,
      fJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fK: (x0,x1) => { x0.onicegatheringstatechange = x1 },
      fL: x0 => x0.payloadType,
      fM: x0 => x0.style,
      fN: x0 => x0.result,
      fO: (x0,x1) => x0.add(x1),
      fP: (x0,x1) => { x0.scrollLeft = x1 },
      fQ: (x0,x1,x2,x3,x4,x5) => x0.drawImage(x1,x2,x3,x4,x5),
      fR: x0 => x0.data,
      fS: x0 => x0.facingMode,
      fT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fU: x0 => x0.tenantId,
      fV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fW: x0 => x0.read(),
      g: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      gB: (b, o, l) => new DataView(b, o, l),
      gC: (string, token) => string.split(token),
      gD: () => globalThis.document,
      gE: s => s.trim(),
      gF: x0 => x0.firstChild,
      gG: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      gH: (x0,x1) => { x0.className = x1 },
      gI: x0 => x0.response,
      gJ: (x0,x1,x2) => x0.addEventListener(x1,x2),
      gK: x0 => x0.iceGatheringState,
      gL: x0 => x0.active,
      gM: (x0,x1) => { x0.src = x1 },
      gN: x0 => globalThis.URL.createObjectURL(x0),
      gO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gP: (x0,x1) => { x0.spellcheck = x1 },
      gQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gR: x0 => globalThis.MediaRecorder.isTypeSupported(x0),
      gS: (x0,x1) => x0.querySelector(x1),
      gT: (x0,x1) => ({next: x0,error: x1}),
      gU: x0 => x0.refreshToken,
      gV: x0 => x0.files,
      gW: (x0,x1) => new OffscreenCanvas(x0,x1),
      h: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      hB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      hC: o => o instanceof Array,
      hD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      hE: x0 => x0.classList,
      hF: x0 => x0.viewConstraints,
      hG: () => Date.now(),
      hH: (x0,x1) => { x0.tabIndex = x1 },
      hI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hJ: x0 => x0.play(),
      hK: x0 => x0.iceConnectionState,
      hL: x0 => x0.headerExtensions,
      hM: () => globalThis.document,
      hN: (x0,x1) => x0.get(x1),
      hO: (x0,x1,x2) => x0.addEventListener(x1,x2),
      hP: (x0,x1) => { x0.disabled = x1 },
      hQ: (x0,x1,x2,x3) => x0.toBlob(x1,x2,x3),
      hR: x0 => x0.disconnect(),
      hS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hT: (x0,x1) => globalThis.firebase_messaging.onMessage(x0,x1),
      hU: x0 => x0.photoURL,
      hV: (x0,x1) => { x0.accept = x1 },
      hW: x0 => x0.assetBase,
      i: x0 => new Promise(x0),
      iB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      iC: (a, i) => a[i],
      iD: x0 => x0.hasFocus(),
      iE: x0 => x0.preventDefault(),
      iF: x0 => x0.hostElement,
      iG: (a, l) => a.length = l,
      iH: (x0,x1) => { x0.name = x1 },
      iI: (x0,x1) => { x0.timeout = x1 },
      iJ: x0 => x0.paused,
      iK: x0 => x0.sdpMLineIndex,
      iL: x0 => x0.reducedSize,
      iM: x0 => x0.src,
      iN: x0 => x0.body,
      iO: x0 => x0.preventDefault(),
      iP: x0 => x0.baseURI,
      iQ: (x0,x1) => { x0.height = x1 },
      iR: (x0,x1) => x0.removeTrack(x1),
      iS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iT: x0 => globalThis.firebase_messaging.getMessaging(x0),
      iU: x0 => x0.phoneNumber,
      iV: (x0,x1) => { x0.multiple = x1 },
      iW: x0 => x0.loader,
      j: (x0,x1,x2) => x0.call(x1,x2),
      jB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      jC: a => a.length,
      jD: x0 => x0.relatedTarget,
      jE: x0 => x0.parent,
      jF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      jH: (x0,x1) => { x0.placeholder = x1 },
      jI: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      jJ: x0 => x0.ended,
      jK: x0 => x0.sdpMid,
      jL: x0 => x0.cname,
      jM: (x0,x1) => x0.revokeObjectURL(x1),
      jN: x0 => x0.headers,
      jO: x0 => x0.createRange(),
      jP: (x0,x1) => x0.cancelVideoFrameCallback(x1),
      jQ: (x0,x1) => { x0.width = x1 },
      jR: (x0,x1) => x0.warn(x1),
      jS: (x0,x1) => { x0.onerror = x1 },
      jT: x0 => globalThis.firebase_core.getApp(x0),
      jU: x0 => x0.lastSignInTime,
      jV: (x0,x1) => { x0.draggable = x1 },
      jW: () => globalThis._flutter,
      k: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      kB: (t, s) => t.set(s),
      kC: (x0,x1) => x0.test(x1),
      kD: x0 => x0.shiftKey,
      kE: x0 => x0.timeStamp,
      kF: x0 => ({runApp: x0}),
      kG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      kH: (x0,x1) => { x0.autocomplete = x1 },
      kI: (x0,x1) => { x0.withCredentials = x1 },
      kJ: x0 => x0.srcObject,
      kK: x0 => x0.candidate,
      kL: x0 => x0.rtcp,
      kM: (x0,x1) => { x0.src = x1 },
      kN: (x0,x1) => x0.deleteDatabase(x1),
      kO: (x0,x1) => x0.selectNode(x1),
      kP: (x0,x1) => x0.cancelAnimationFrame(x1),
      kQ: (x0,x1) => x0.getItem(x1),
      kR: () => globalThis.console,
      kS: (x0,x1) => x0.removeChild(x1),
      kT: () => globalThis.firebase_core.getApp(),
      kU: x0 => x0.creationTime,
      kV: (x0,x1) => { x0.type = x1 },
      l: x0 => new Array(x0),
      lB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      lC: x0 => x0.userAgent,
      lD: (decoder, codeUnits) => decoder.decode(codeUnits),
      lE: (x0,x1) => x0.hasAttribute(x1),
      lF: () => typeof dartUseDateNowForTicks !== "undefined",
      lG: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      lH: (x0,x1) => { x0.name = x1 },
      lI: (x0,x1) => { x0.responseType = x1 },
      lJ: x0 => x0.readyState,
      lK: x0 => x0.candidate,
      lL: x0 => x0.receiver,
      lM: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      lN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lO: x0 => x0.getSelection(),
      lP: (x0,x1) => x0.transferFromImageBitmap(x1),
      lQ: x0 => x0.localStorage,
      lR: x0 => x0.state,
      lS: (x0,x1) => { x0.onload = x1 },
      lT: x0 => x0.recaptchaSiteKey,
      lU: x0 => x0.metadata,
      lV: x0 => x0.maxTouchPoints,
      m: o => [o],
      mB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      mC: x0 => x0.navigator,
      mD: () => new TextDecoder("utf-8", {fatal: true}),
      mE: x0 => x0.buttons,
      mF: () => Date.now(),
      mG: (a, t) => a.concat(t),
      mH: (x0,x1) => { x0.placeholder = x1 },
      mI: x0 => x0.protocol,
      mJ: x0 => x0.type,
      mK: x0 => x0.label,
      mL: x0 => x0.track,
      mM: x0 => x0.naturalHeight,
      mN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mO: x0 => x0.removeAllRanges(),
      mP: (x0,x1) => x0.getContext(x1),
      mQ: (x0,x1) => x0.key(x1),
      mR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mS: (x0,x1) => { x0.crossOrigin = x1 },
      mT: x0 => x0.measurementId,
      mU: x0 => x0.isAnonymous,
      mV: x0 => x0.hardwareConcurrency,
      n: (o0, o1) => [o0, o1],
      nB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      nC: Function.prototype.call.bind(String.prototype.toLowerCase),
      nD: () => new TextDecoder("utf-8", {fatal: false}),
      nE: x0 => x0.ctrlKey,
      nF: () => 1000 * performance.now(),
      nG: (x0,x1) => x0.getRandomValues(x1),
      nH: (x0,x1) => { x0.action = x1 },
      nI: (x0,x1,x2) => x0.close(x1,x2),
      nJ: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      nK: x0 => x0.id,
      nL: x0 => x0.getTransceivers(),
      nM: x0 => x0.naturalWidth,
      nN: (x0,x1) => { x0.onerror = x1 },
      nO: (x0,x1) => x0.addRange(x1),
      nP: (x0,x1) => { x0.height = x1 },
      nQ: x0 => x0.length,
      nR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nS: (x0,x1) => { x0.lang = x1 },
      nT: x0 => x0.appId,
      nU: x0 => x0.emailVerified,
      nV: x0 => x0.vendorSub,
      o: (o0, o1, o2) => [o0, o1, o2],
      oB: Function.prototype.call.bind(DataView.prototype.getUint32),
      oC: Object.is,
      oD: (a, i, v) => a[i] = v,
      oE: x0 => x0.y,
      oF: (x0,x1) => x0.requestAnimationFrame(x1),
      oG: () => globalThis.crypto,
      oH: (x0,x1) => { x0.method = x1 },
      oI: (x0,x1) => x0.close(x1),
      oJ: (x0,x1) => { x0.srcObject = x1 },
      oK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oL: x0 => x0.remove(),
      oM: x0 => x0.decode(),
      oN: x0 => x0.error,
      oO: () => globalThis.window,
      oP: (x0,x1) => { x0.width = x1 },
      oQ: (x0,x1) => x0.removeItem(x1),
      oR: (x0,x1) => { x0.onmessage = x1 },
      oS: (x0,x1) => { x0.defer = x1 },
      oT: x0 => x0.messagingSenderId,
      oU: x0 => x0.email,
      oV: x0 => x0.productSub,
      p: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      pB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      pC: x0 => x0.vendor,
      pD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      pE: x0 => x0.x,
      pF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pG: l => new DataView(new ArrayBuffer(l)),
      pH: (x0,x1) => { x0.noValidate = x1 },
      pI: x0 => x0.close(),
      pJ: (x0,x1) => { x0.muted = x1 },
      pK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pL: (o, a) => o === a,
      pM: (x0,x1) => { x0.decoding = x1 },
      pN: (x0,x1) => { x0.onsuccess = x1 },
      pO: (x0,x1) => { x0.innerText = x1 },
      pP: x0 => x0.height,
      pQ: (x0,x1,x2) => x0.setItem(x1,x2),
      pR: x0 => x0.port,
      pS: (x0,x1) => { x0.async = x1 },
      pT: x0 => x0.authDomain,
      pU: x0 => x0.displayName,
      pV: x0 => x0.product,
      q: (x0,x1,x2) => { x0[x1] = x2 },
      qB: Function.prototype.call.bind(DataView.prototype.getInt32),
      qC: (x0,x1) => x0.createTextNode(x1),
      qD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      qE: x0 => x0.scrollTop,
      qF: x0 => x0.now(),
      qG: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      qH: (x0,x1) => x0.removeAttribute(x1),
      qI: (x0,x1) => x0.send(x1),
      qJ: x0 => x0.body,
      qK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qL: (x0,x1) => x0.removeAttribute(x1),
      qM: (x0,x1) => { x0.crossOrigin = x1 },
      qN: x0 => x0.result,
      qO: x0 => x0.offsetY,
      qP: x0 => x0.width,
      qQ: (x0,x1) => x0.canShare(x1),
      qR: x0 => x0.destination,
      qS: x0 => x0.stream,
      qT: x0 => x0.projectId,
      qU: x0 => globalThis.firebase_auth.multiFactor(x0),
      qV: x0 => x0.platform,
      r: (o, p) => o[p],
      rB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      rC: (x0,x1) => { x0.id = x1 },
      rD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      rE: x0 => x0.offsetTop,
      rF: x0 => x0.performance,
      rG: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      rH: x0 => x0.isConnected,
      rI: () => new Array(),
      rJ: (x0,x1) => { x0.display = x1 },
      rK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rL: x0 => x0.load(),
      rM: (x0,x1) => x0.createObjectURL(x1),
      rN: x0 => x0.indexedDB,
      rO: x0 => x0.offsetX,
      rP: x0 => x0.rasterEndMilliseconds,
      rQ: (x0,x1) => x0.share(x1),
      rR: (x0,x1) => x0.addModule(x1),
      rS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rT: x0 => x0.name,
      rU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rV: x0 => x0.languages,
      s: () => globalThis,
      sB: o => o instanceof Uint16Array,
      sC: (x0,x1) => { x0.nonce = x1 },
      sD: x0 => x0.visibilityState,
      sE: x0 => x0.scrollLeft,
      sF: x0 => new Uint8Array(x0),
      sG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      sH: x0 => x0.click(),
      sI: (x0,x1) => new WebSocket(x0,x1),
      sJ: x0 => x0.style,
      sK: (x0,x1) => { x0.onbufferedamountlow = x1 },
      sL: x0 => x0.hasChildNodes(),
      sM: x0 => x0.URL,
      sN: x0 => x0.self,
      sO: x0 => x0.button,
      sP: x0 => x0.rasterStartMilliseconds,
      sQ: x0 => x0.click(),
      sR: x0 => ({parameterData: x0}),
      sS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sV: x0 => x0.language,
      t: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tB: Function.prototype.call.bind(DataView.prototype.getUint16),
      tC: x0 => x0.nonce,
      tD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      tE: x0 => x0.offsetLeft,
      tF: (x0,x1,x2) => x0.slice(x1,x2),
      tG: x0 => x0.history,
      tH: (x0,x1) => x0.getElementsByClassName(x1),
      tI: x0 => x0.reason,
      tJ: (x0,x1) => { x0.autoplay = x1 },
      tK: (x0,x1) => { x0.onmessage = x1 },
      tL: (x0,x1) => { x0.top = x1 },
      tM: x0 => new Blob(x0),
      tN: (x0,x1,x2) => x0.open(x1,x2),
      tO: x0 => x0.classList,
      tP: x0 => x0.imageBitmaps,
      tQ: (o, a) => o + a,
      tR: (x0,x1,x2) => new AudioWorkletNode(x0,x1,x2),
      tS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tU: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      tV: x0 => x0.deviceMemory,
      u: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uB: o => o instanceof Int16Array,
      uC: () => globalThis.window.flutterConfiguration,
      uD: x0 => x0.disconnect(),
      uE: x0 => x0.offsetParent,
      uF: (x0,x1) => x0.decode(x1),
      uG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      uH: (x0,x1) => x0.dispatchEvent(x1),
      uI: x0 => x0.code,
      uJ: (x0,x1) => { x0.id = x1 },
      uK: x0 => x0.arrayBuffer(),
      uL: (x0,x1) => { x0.left = x1 },
      uM: x0 => x0.close(),
      uN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uO: x0 => x0.sheet,
      uP: x0 => x0.canvasKitMaximumSurfaces,
      uQ: x0 => x0.children,
      uR: x0 => x0.audioWorklet,
      uS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uT: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      uU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uV: x0 => x0.appVersion,
      v: (x0,x1) => ({addView: x0,removeView: x1}),
      vB: Function.prototype.call.bind(DataView.prototype.getInt16),
      vC: (x0,x1) => x0.attachShadow(x1),
      vD: x0 => new Intl.Locale(x0),
      vE: (o, p, r) => o.replace(p, () => r),
      vF: (x0,x1) => x0.adoptText(x1),
      vG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      vH: (x0,x1) => x0.createEvent(x1),
      vI: (o, t) => typeof o === t,
      vJ: (x0,x1) => { x0.enabled = x1 },
      vK: (x0,x1) => { x0.onopen = x1 },
      vL: (x0,x1) => { x0.position = x1 },
      vM: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      vN: (x0,x1) => x0.contains(x1),
      vO: x0 => x0.head,
      vP: x0 => x0.nextSibling,
      vQ: (x0,x1) => { x0.download = x1 },
      vR: (x0,x1) => x0.getFloatFrequencyData(x1),
      vS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      vT: x0 => x0.call(),
      vU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      vV: x0 => x0.appName,
      w: (l, r) => l === r,
      wB: o => o instanceof Uint8ClampedArray,
      wC: (x0,x1) => x0.createElement(x1),
      wD: x0 => x0.region,
      wE: (o, p, r) => o.replaceAll(p, () => r),
      wF: x0 => x0.first(),
      wG: o => Object.keys(o),
      wH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      wI: x0 => x0.data,
      wJ: x0 => x0.enabled,
      wK: (x0,x1) => { x0.onclose = x1 },
      wL: (x0,x1) => { x0.opacity = x1 },
      wM: (x0,x1) => x0.decode(x1),
      wN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wO: x0 => x0.decode(),
      wP: (x0,x1) => x0.debug(x1),
      wQ: (x0,x1) => { x0.href = x1 },
      wR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wT: x0 => x0.toJSON(),
      wU: x0 => x0.user,
      wV: x0 => x0.appCodeName,
      x: x0 => x0.random(),
      xB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      xC: x0 => x0.scale,
      xD: x0 => x0.script,
      xE: x0 => x0.deltaMode,
      xF: x0 => x0.next(),
      xG: x0 => x0.state,
      xH: x0 => x0.readText(),
      xI: x0 => x0.readyState,
      xJ: x0 => x0.groupId,
      xK: x0 => x0.channel,
      xL: (x0,x1) => { x0.pointerEvents = x1 },
      xM: x0 => x0.displayHeight,
      xN: (x0,x1) => x0.delete(x1),
      xO: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      xP: x0 => x0.hostElement,
      xQ: x0 => ({url: x0}),
      xR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xT: x0 => x0.uid,
      xU: x0 => x0.idToken,
      xV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      y: () => globalThis.Math,
      yB: Function.prototype.call.bind(DataView.prototype.setInt32),
      yC: x0 => x0.visualViewport,
      yD: x0 => x0.language,
      yE: x0 => x0.deltaY,
      yF: x0 => x0.current(),
      yG: x0 => x0.state,
      yH: x0 => x0.clipboard,
      yI: (x0,x1) => { x0.binaryType = x1 },
      yJ: x0 => x0.deviceId,
      yK: x0 => x0.getStats(),
      yL: (x0,x1) => { x0.transform = x1 },
      yM: x0 => x0.displayWidth,
      yN: (x0,x1,x2) => x0.put(x1,x2),
      yO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      yP: x0 => x0.location,
      yQ: x0 => ({files: x0}),
      yR: (x0,x1,x2) => x0.getCurrentPosition(x1,x2),
      yS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      yT: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      yU: x0 => x0.secret,
      yV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      z: (x0,x1) => x0.prepend(x1),
      zB: Function.prototype.call.bind(DataView.prototype.setUint32),
      zC: x0 => x0.devicePixelRatio,
      zD: x0 => x0.languages,
      zE: x0 => x0.deltaX,
      zF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      zG: (x0,x1) => x0.go(x1),
      zH: (x0,x1) => x0.writeText(x1),
      zI: x0 => x0.abort(),
      zJ: x0 => x0.label,
      zK: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      zL: (x0,x1) => x0.appendChild(x1),
      zM: x0 => x0.duration,
      zN: (x0,x1,x2) => x0.transaction(x1,x2),
      zO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zP: (x0,x1) => x0.getModifierState(x1),
      zQ: () => ({}),
      zR: () => globalThis.Notification.requestPermission(),
      zS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zT: x0 => x0.sessionStorage,
      zU: x0 => x0.accessToken,
      zV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
