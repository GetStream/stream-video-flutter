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
      AK: x0 => x0.type,
      AL: x0 => x0.mediaDevices,
      AM: (x0,x1) => ({type: x0,sdp: x1}),
      AN: (x0,x1) => x0.item(x1),
      AO: (x0,x1) => x0.createObjectStore(x1),
      AP: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      AQ: x0 => x0.altKey,
      AR: (x0,x1) => x0.query(x1),
      AS: x0 => x0.baseURI,
      AT: (x0,x1) => x0.debug(x1),
      AU: x0 => x0.location,
      AV: x0 => x0.providerId,
      AW: (x0,x1) => { x0.ondragleave = x1 },
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
      BK: x0 => x0.sdp,
      BL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      BM: (x0,x1) => x0.setRemoteDescription(x1),
      BN: x0 => x0.name,
      BO: x0 => x0.version,
      BP: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      BQ: x0 => x0.ctrlKey,
      BR: (o,s,v) => o[s] = v,
      BS: (x0,x1) => x0.call(x1),
      BT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      BU: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      BV: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      BW: x0 => x0.preventDefault(),
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
      CK: (x0,x1,x2) => x0.addTransceiver(x1,x2),
      CL: (x0,x1) => { x0.ondevicechange = x1 },
      CM: x0 => x0.mid,
      CN: x0 => x0.type,
      CO: x0 => x0.objectStoreNames,
      CP: x0 => x0.send(),
      CQ: x0 => x0.isComposing,
      CR: () => Symbol("jsBoxedDartObjectProperty"),
      CS: x0 => x0.reset,
      CT: x0 => ({createScriptURL: x0}),
      CU: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      CV: x0 => x0.username,
      CW: x0 => x0.clientY,
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
      DK: x0 => new RTCPeerConnection(x0),
      DL: x0 => x0.getSettings(),
      DM: x0 => x0.localDescription,
      DN: x0 => x0.length,
      DO: (x0,x1) => { x0.onupgradeneeded = x1 },
      DP: x0 => x0.status,
      DQ: x0 => x0.code,
      DR: x0 => x0.state,
      DS: x0 => x0.stopContinuousDecode,
      DT: (x0,x1,x2) => x0.createPolicy(x1,x2),
      DU: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      DV: x0 => x0.providerId,
      DW: x0 => x0.clientX,
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
      EK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      EL: x0 => x0.groupId,
      EM: x0 => x0.getVideoTracks(),
      EN: x0 => x0.files,
      EO: (x0,x1) => { x0.height = x1 },
      EP: x0 => x0.response,
      EQ: x0 => x0.repeat,
      ER: x0 => x0.permissions,
      ES: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      ET: (x0,x1) => x0.createScriptURL(x1),
      EU: () => globalThis.firebase_auth.debugErrorMap,
      EV: x0 => x0.profile,
      EW: (x0,x1) => { x0.ondragover = x1 },
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
      FK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FL: x0 => x0.deviceId,
      FM: x0 => x0.getAudioTracks(),
      FN: x0 => x0.clipboardData,
      FO: (x0,x1) => { x0.width = x1 },
      FP: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      FQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FR: (x0,x1) => x0.append(x1),
      FS: x0 => x0.text,
      FT: (x0,x1) => { x0.nonce = x1 },
      FU: () => globalThis.firebase_auth.browserSessionPersistence,
      FV: x0 => x0.isNewUser,
      FW: (x0,x1) => { x0.ondragenter = x1 },
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
      GK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GL: x0 => x0.resizeMode,
      GM: (x0,x1) => x0.getUserMedia(x1),
      GN: x0 => new Blob(x0),
      GO: (x0,x1) => { x0.objectFit = x1 },
      GP: (x0,x1) => { x0.responseType = x1 },
      GQ: (x0,x1) => { x0.loop = x1 },
      GR: x0 => x0.head,
      GS: x0 => x0.barcodeFormat,
      GT: (x0,x1) => x0.querySelectorAll(x1),
      GU: () => globalThis.firebase_auth.browserLocalPersistence,
      GV: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      GW: (x0,x1) => { x0.ondrop = x1 },
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
      HK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      HL: x0 => x0.facingMode,
      HM: (x0,x1) => ({video: x0,audio: x1}),
      HN: x0 => ({type: x0}),
      HO: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      HP: () => new XMLHttpRequest(),
      HQ: (x0,x1) => { x0.volume = x1 },
      HR: (x0,x1) => { x0.src = x1 },
      HS: x0 => x0.rawBytes,
      HT: (x0,x1) => x0.item(x1),
      HU: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      HV: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      HW: x0 => x0.webkitGetAsEntry(),
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
      IK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IL: x0 => x0.frameRate,
      IM: (x0,x1) => x0.getDisplayMedia(x1),
      IN: (x0,x1) => new Blob(x0,x1),
      IO: (x0,x1) => x0.requestVideoFrameCallback(x1),
      IP: () => globalThis.window.navigator.userAgent,
      IQ: (x0,x1) => { x0.src = x1 },
      IR: (x0,x1) => { x0.charset = x1 },
      IS: x0 => x0.y,
      IT: x0 => x0.nonce,
      IU: x0 => x0.name,
      IV: x0 => x0.session,
      IW: x0 => x0.createReader(),
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
      JL: x0 => x0.aspectRatio,
      JM: x0 => x0.naturalHeight,
      JN: x0 => x0.size,
      JO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JP: x0 => x0.getTracks(),
      JQ: (x0,x1) => x0.start(x1),
      JR: (x0,x1) => { x0.type = x1 },
      JS: x0 => x0.x,
      JT: x0 => x0.length,
      JU: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7,recaptchaSiteKey: x8}),
      JV: x0 => x0.phoneNumber,
      JW: () => new Blob(),
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
      KL: x0 => x0.height,
      KM: x0 => x0.naturalWidth,
      KN: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      KO: (x0,x1) => x0.requestAnimationFrame(x1),
      KP: x0 => x0.close(),
      KQ: (x0,x1) => x0.end(x1),
      KR: (x0,x1) => x0.item(x1),
      KS: x0 => x0.resultPoints,
      KT: (x0,x1) => { x0.src = x1 },
      KU: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      KV: x0 => x0.uid,
      KW: (x0,x1,x2,x3) => x0.slice(x1,x2,x3),
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
      LL: x0 => x0.width,
      LM: (x0,x1) => x0.createElement(x1),
      LN: x0 => x0.vendor,
      LO: (x0,x1,x2,x3) => x0.call(x1,x2,x3),
      LP: (x0,x1) => x0.getByteFrequencyData(x1),
      LQ: x0 => x0.length,
      LR: x0 => x0.id,
      LS: x0 => x0.message,
      LT: x0 => x0.trustedTypes,
      LU: x0 => x0.storageBucket,
      LV: x0 => x0.enrollmentTime,
      LW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      MK: x0 => x0.id,
      ML: x0 => x0.channelCount,
      MM: (x0,x1) => { x0.pointerEvents = x1 },
      MN: o => o.byteLength,
      MO: x0 => x0.videoHeight,
      MP: x0 => x0.resume(),
      MQ: x0 => x0.buffered,
      MR: x0 => x0.length,
      MS: x0 => x0.videoElement,
      MT: x0 => x0.trustedTypes,
      MU: x0 => x0.databaseURL,
      MV: x0 => x0.factorId,
      MW: (x0,x1) => x0.file(x1),
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
      NK: x0 => x0.streams,
      NL: x0 => x0.latency,
      NM: (x0,x1) => { x0.height = x1 },
      NN: () => new FileReader(),
      NO: x0 => x0.videoWidth,
      NP: x0 => x0.state,
      NQ: x0 => x0.duration,
      NR: x0 => x0.stop(),
      NS: x0 => x0.decodeContinuously,
      NT: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      NU: x0 => x0.apiKey,
      NV: x0 => x0.displayName,
      NW: x0 => x0.lastModified,
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
      OK: x0 => x0.transceiver,
      OL: x0 => x0.noiseSuppression,
      OM: (x0,x1) => { x0.width = x1 },
      ON: (x0,x1) => x0.readAsArrayBuffer(x1),
      OO: x0 => x0.currentTime,
      OP: x0 => ({audio: x0}),
      OQ: (x0,x1) => { x0.width = x1 },
      OR: (x0,x1,x2) => ({mimeType: x0,audioBitsPerSecond: x1,bitsPerSecond: x2}),
      OS: (x0,x1) => new ZXing.BrowserMultiFormatReader(x0,x1),
      OT: x0 => { globalThis.onGoogleLibraryLoad = x0 },
      OU: x0 => x0.options,
      OV: x0 => x0.hints,
      OW: x0 => x0.fullPath,
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
      PK: x0 => x0.receiver,
      PL: x0 => x0.autoGainControl,
      PM: x0 => x0.style,
      PN: x0 => x0.result,
      PO: (x0,x1) => { x0.top = x1 },
      PP: () => new AudioContext(),
      PQ: (x0,x1) => { x0.height = x1 },
      PR: (x0,x1) => new MediaRecorder(x0,x1),
      PS: (x0,x1) => ({width: x0,height: x1}),
      PT: x0 => x0.message,
      PU: () => globalThis.firebase_core.SDK_VERSION,
      PV: x0 => x0.tenantId,
      PW: x0 => x0.name,
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
      QL: x0 => x0.echoCancellation,
      QM: (x0,x1) => { x0.src = x1 },
      QN: x0 => globalThis.URL.createObjectURL(x0),
      QO: (x0,x1) => { x0.left = x1 },
      QP: (x0,x1) => x0.createMediaStreamSource(x1),
      QQ: (x0,x1) => { x0.border = x1 },
      QR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      QS: (x0,x1,x2) => ({width: x0,height: x1,facingMode: x2}),
      QT: x0 => x0.code,
      QU: (x0,x1,x2) => globalThis.firebase_core.registerVersion(x0,x1,x2),
      QV: x0 => x0.phoneNumber,
      QW: (a, l) => a.length = l,
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
      RK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RL: x0 => x0.sampleSize,
      RM: () => globalThis.document,
      RN: (x0,x1) => x0.get(x1),
      RO: (x0,x1) => { x0.position = x1 },
      RP: x0 => x0.createAnalyser(),
      RQ: x0 => x0.message,
      RR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RS: x0 => x0.facingMode,
      RT: (x0,x1) => globalThis.firebase_messaging.getToken(x0,x1),
      RU: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      RV: x0 => x0.email,
      RW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      SK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      SL: x0 => x0.sampleRate,
      SM: x0 => x0.src,
      SN: x0 => x0.body,
      SO: (x0,x1) => { x0.opacity = x1 },
      SP: (x0,x1) => x0.connect(x1),
      SQ: (x0,x1) => { x0.currentTime = x1 },
      SR: (x0,x1) => x0.start(x1),
      SS: x0 => x0.attachStreamToVideo,
      ST: x0 => x0.link,
      SU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      SV: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      SW: (x0,x1) => x0.readEntries(x1),
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
      TK: x0 => x0.id,
      TL: x0 => x0.stop(),
      TM: (x0,x1) => x0.revokeObjectURL(x1),
      TN: x0 => x0.headers,
      TO: (x0,x1) => { x0.pointerEvents = x1 },
      TP: x0 => x0.frequencyBinCount,
      TQ: (x0,x1) => { x0.playbackRate = x1 },
      TR: (x0,x1) => { x0.smoothingTimeConstant = x1 },
      TS: () => new Map(),
      TT: x0 => x0.analyticsLabel,
      TU: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      TV: x0 => x0.customData,
      TW: x0 => x0.isDirectory,
      U: (string, times) => string.repeat(times),
      UB: x0 => new Float64Array(x0),
      UC: x0 => x0.remove(),
      UD: x0 => x0.top,
      UE: (o, i) => o[i],
      UF: x0 => x0.blur(),
      UG: a => a.pop(),
      UH: x0 => x0.selectionDirection,
      UI: x0 => x0.abort(),
      UJ: x0 => x0.userAgent,
      UK: x0 => x0.muted,
      UL: x0 => x0.track,
      UM: (x0,x1) => { x0.src = x1 },
      UN: (x0,x1) => x0.deleteDatabase(x1),
      UO: (x0,x1) => { x0.transform = x1 },
      UP: (x0,x1) => { x0.fftSize = x1 },
      UQ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      UR: (x0,x1) => { x0.maxDecibels = x1 },
      US: (x0,x1,x2) => x0.set(x1,x2),
      UT: x0 => x0.image,
      UU: (x0,x1) => x0.createScriptURL(x1),
      UV: x0 => x0.message,
      UW: (x0,x1) => x0[x1],
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
      VJ: x0 => x0.navigator,
      VK: x0 => x0.label,
      VL: x0 => x0.sender,
      VM: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      VN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      VO: (x0,x1) => x0.removeAttribute(x1),
      VP: (x0,x1,x2) => x0.insertBefore(x1,x2),
      VQ: x0 => globalThis.URL.revokeObjectURL(x0),
      VR: (x0,x1) => { x0.minDecibels = x1 },
      VS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      VT: x0 => x0.body,
      VU: (x0,x1,x2) => x0.createScript(x1,x2),
      VV: x0 => x0.code,
      VW: x0 => x0.length,
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
      WJ: () => globalThis.window,
      WK: x0 => x0.kind,
      WL: x0 => x0.stop(),
      WM: x0 => x0.naturalHeight,
      WN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WO: x0 => x0.load(),
      WP: x0 => x0.id,
      WQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WR: x0 => ({sampleRate: x0}),
      WS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WT: x0 => x0.title,
      WU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WV: (x0,x1) => globalThis.firebase_auth.signInWithPopup(x0,x1),
      WW: x0 => x0.items,
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
      XK: x0 => x0.track,
      XL: x0 => x0.getParameters(),
      XM: x0 => x0.naturalWidth,
      XN: (x0,x1) => { x0.onerror = x1 },
      XO: x0 => x0.hasChildNodes(),
      XP: x0 => x0.offsetHeight,
      XQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XR: x0 => new AudioContext(x0),
      XS: (x0,x1) => { x0.onpause = x1 },
      XT: x0 => x0.fcmOptions,
      XU: (o, p) => delete o[p],
      XV: (x0,x1) => x0.setCustomParameters(x1),
      XW: x0 => x0.dataTransfer,
      Y: x0 => x0.unicode,
      YB: (x0,x1,x2) => new DataView(x0,x1,x2),
      YC: x0 => x0.style,
      YD: x0 => x0.clientX,
      YE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      YF: x0 => x0.height,
      YG: x0 => x0.debugSkipFontRetryDelay,
      YH: x0 => x0.selectionDirection,
      YI: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      YJ: () => globalThis.document,
      YK: x0 => x0.connectionState,
      YL: (x0,x1) => x0.setParameters(x1),
      YM: x0 => x0.decode(),
      YN: x0 => x0.error,
      YO: (x0,x1) => x0.appendChild(x1),
      YP: x0 => x0.offsetWidth,
      YQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      YR: (x0,x1) => { x0.onstop = x1 },
      YS: (x0,x1) => { x0.onplay = x1 },
      YT: x0 => x0.notification,
      YU: (o, p, v) => o[p] = v,
      YV: (x0,x1) => x0.addScope(x1),
      YW: x0 => x0.level,
      Z: x0 => x0.ignoreCase,
      ZB: (o, p) => o[p],
      ZC: x0 => x0.debugShowSemanticsNodes,
      ZD: x0 => x0.changedTouches,
      ZE: () => globalThis.window.FinalizationRegistry,
      ZF: x0 => x0.width,
      ZG: x0 => x0.status,
      ZH: x0 => x0.selectionStart,
      ZI: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      ZJ: () => new MediaStream(),
      ZK: x0 => x0.signalingState,
      ZL: (x0,x1) => { x0.encodings = x1 },
      ZM: (x0,x1) => { x0.decoding = x1 },
      ZN: (x0,x1) => { x0.onsuccess = x1 },
      ZO: x0 => x0.document,
      ZP: x0 => x0.stopPropagation(),
      ZQ: (x0,x1) => { x0.crossOrigin = x1 },
      ZR: (x0,x1) => globalThis.jsFixWebmDuration(x0,x1),
      ZS: (x0,x1) => { x0.transformOrigin = x1 },
      ZT: x0 => x0.messageId,
      ZU: (x0,x1) => { x0.text = x1 },
      ZV: () => new firebase_auth.GoogleAuthProvider(),
      ZW: x0 => x0.getBattery(),
      a: x0 => x0.multiline,
      aB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      aC: (x0,x1) => x0.warn(x1),
      aD: x0 => x0.offsetY,
      aE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aF: x0 => x0.clientHeight,
      aG: (x0,x1,x2) => x0.set(x1,x2),
      aH: x0 => x0.selectionEnd,
      aI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aJ: (x0,x1) => x0.addTrack(x1),
      aK: (x0,x1) => { x0.onicegatheringstatechange = x1 },
      aL: x0 => x0.clockRate,
      aM: (x0,x1) => { x0.crossOrigin = x1 },
      aN: x0 => x0.result,
      aO: (x0,x1,x2) => x0.setAttribute(x1,x2),
      aP: x0 => x0.disabled,
      aQ: (x0,x1) => x0.getContext(x1),
      aR: x0 => x0.mimeType,
      aS: x0 => x0.getSupportedConstraints(),
      aT: x0 => x0.from,
      aU: (x0,x1) => { x0.text = x1 },
      aV: x0 => x0.firstChild,
      aW: x0 => x0.length,
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
      bJ: x0 => x0.srcObject,
      bK: x0 => x0.iceGatheringState,
      bL: x0 => x0.payloadType,
      bM: (x0,x1) => x0.createObjectURL(x1),
      bN: x0 => x0.indexedDB,
      bO: x0 => x0.message,
      bP: (x0,x1) => { x0.min = x1 },
      bQ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      bR: (x0,x1) => { x0.ondataavailable = x1 },
      bS: x0 => ({facingMode: x0}),
      bT: x0 => x0.collapseKey,
      bU: x0 => x0.trustedTypes,
      bV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      bW: x0 => x0.getReader(),
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
      cJ: x0 => x0.paused,
      cK: x0 => x0.iceConnectionState,
      cL: x0 => x0.active,
      cM: x0 => x0.URL,
      cN: x0 => x0.self,
      cO: x0 => x0.code,
      cP: (x0,x1) => { x0.max = x1 },
      cQ: (x0,x1,x2,x3,x4,x5) => x0.drawImage(x1,x2,x3,x4,x5),
      cR: x0 => x0.data,
      cS: x0 => x0.facingMode,
      cT: x0 => x0.data,
      cU: x0 => x0.providerId,
      cV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      cW: x0 => x0.value,
      d: (x0,x1) => x0.didCreateEngineInitializer(x1),
      dB: o => o.buffer,
      dC: (o, c) => o instanceof c,
      dD: x0 => x0.maxTouchPoints,
      dE: (x0,x1) => x0.contains(x1),
      dF: (x0,x1) => { x0.name = x1 },
      dG: (x0,x1) => x0.fetch(x1),
      dH: x0 => x0.multiViewEnabled,
      dI: x0 => x0.statusText,
      dJ: x0 => x0.ended,
      dK: x0 => x0.sdpMLineIndex,
      dL: x0 => x0.headerExtensions,
      dM: x0 => new Blob(x0),
      dN: (x0,x1,x2) => x0.open(x1,x2),
      dO: x0 => x0.error,
      dP: (x0,x1) => { x0.disabled = x1 },
      dQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      dR: x0 => globalThis.MediaRecorder.isTypeSupported(x0),
      dS: (x0,x1) => x0.querySelector(x1),
      dT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      dU: x0 => x0.providerData,
      dV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      dW: x0 => x0.done,
      e: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eB: Function.prototype.call.bind(DataView.prototype.getUint8),
      eC: (x0,x1) => x0[x1],
      eD: x0 => x0.platform,
      eE: (s) => +s,
      eF: x0 => x0.head,
      eG: x0 => x0.fontFallbackBaseUrl,
      eH: (x0,x1) => x0.replaceWith(x1),
      eI: x0 => x0.getAllResponseHeaders(),
      eJ: x0 => x0.readyState,
      eK: x0 => x0.sdpMid,
      eL: x0 => x0.reducedSize,
      eM: x0 => x0.close(),
      eN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eO: (x0,x1) => { x0.controls = x1 },
      eP: (x0,x1) => { x0.scrollLeft = x1 },
      eQ: (x0,x1,x2,x3) => x0.toBlob(x1,x2,x3),
      eR: x0 => x0.disconnect(),
      eS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eU: x0 => x0.tenantId,
      eV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eW: x0 => x0.read(),
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
      fJ: x0 => x0.play(),
      fK: x0 => x0.candidate,
      fL: x0 => x0.cname,
      fM: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      fN: (x0,x1) => x0.contains(x1),
      fO: (x0,x1) => x0.append(x1),
      fP: (x0,x1) => { x0.spellcheck = x1 },
      fQ: (x0,x1) => { x0.height = x1 },
      fR: (x0,x1) => x0.removeTrack(x1),
      fS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fT: (x0,x1) => ({next: x0,error: x1}),
      fU: x0 => x0.refreshToken,
      fV: x0 => x0.files,
      fW: (x0,x1) => new OffscreenCanvas(x0,x1),
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
      gJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gK: x0 => x0.candidate,
      gL: x0 => x0.rtcp,
      gM: (x0,x1) => x0.decode(x1),
      gN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gO: (x0,x1,x2) => x0.insertRule(x1,x2),
      gP: (x0,x1) => { x0.disabled = x1 },
      gQ: (x0,x1) => { x0.width = x1 },
      gR: (x0,x1) => x0.warn(x1),
      gS: (x0,x1) => { x0.onerror = x1 },
      gT: (x0,x1) => globalThis.firebase_messaging.onMessage(x0,x1),
      gU: x0 => x0.photoURL,
      gV: (x0,x1) => { x0.accept = x1 },
      gW: x0 => x0.assetBase,
      h: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      hB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      hC: o => o instanceof Array,
      hD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      hE: x0 => x0.classList,
      hF: x0 => x0.viewConstraints,
      hG: () => Date.now(),
      hH: (x0,x1) => { x0.tabIndex = x1 },
      hI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hK: x0 => x0.label,
      hL: (x0,x1) => x0.replaceTrack(x1),
      hM: x0 => x0.displayHeight,
      hN: (x0,x1) => x0.delete(x1),
      hO: (x0,x1) => x0.add(x1),
      hP: x0 => x0.baseURI,
      hQ: (x0,x1) => x0.getItem(x1),
      hR: () => globalThis.console,
      hS: (x0,x1) => x0.removeChild(x1),
      hT: x0 => globalThis.firebase_messaging.getMessaging(x0),
      hU: x0 => x0.phoneNumber,
      hV: (x0,x1) => { x0.multiple = x1 },
      hW: x0 => x0.loader,
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
      iJ: (x0,x1,x2) => x0.addEventListener(x1,x2),
      iK: x0 => x0.id,
      iL: x0 => x0.clone(),
      iM: x0 => x0.displayWidth,
      iN: (x0,x1,x2) => x0.put(x1,x2),
      iO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iP: (x0,x1) => x0.cancelVideoFrameCallback(x1),
      iQ: x0 => x0.localStorage,
      iR: x0 => x0.state,
      iS: (x0,x1) => { x0.onload = x1 },
      iT: x0 => globalThis.firebase_core.getApp(x0),
      iU: x0 => x0.lastSignInTime,
      iV: (x0,x1) => { x0.draggable = x1 },
      iW: () => globalThis._flutter,
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
      jJ: x0 => x0.type,
      jK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jL: x0 => x0.receiver,
      jM: x0 => x0.duration,
      jN: (x0,x1,x2) => x0.transaction(x1,x2),
      jO: (x0,x1,x2) => x0.addEventListener(x1,x2),
      jP: (x0,x1) => x0.cancelAnimationFrame(x1),
      jQ: (x0,x1) => x0.key(x1),
      jR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jS: (x0,x1) => { x0.crossOrigin = x1 },
      jT: () => globalThis.firebase_core.getApp(),
      jU: x0 => x0.creationTime,
      jV: (x0,x1) => { x0.type = x1 },
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
      kJ: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      kK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kL: x0 => x0.track,
      kM: x0 => x0.image,
      kN: (x0,x1) => x0.objectStore(x1),
      kO: x0 => x0.preventDefault(),
      kP: (x0,x1) => x0.transferFromImageBitmap(x1),
      kQ: x0 => x0.length,
      kR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kS: (x0,x1) => { x0.lang = x1 },
      kT: x0 => x0.recaptchaSiteKey,
      kU: x0 => x0.metadata,
      kV: x0 => x0.maxTouchPoints,
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
      lJ: (x0,x1) => { x0.srcObject = x1 },
      lK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lL: x0 => x0.getTransceivers(),
      lM: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      lN: (x0,x1) => x0.getAll(x1),
      lO: x0 => x0.createRange(),
      lP: (x0,x1) => x0.getContext(x1),
      lQ: (x0,x1) => x0.removeItem(x1),
      lR: (x0,x1) => { x0.onmessage = x1 },
      lS: (x0,x1) => { x0.defer = x1 },
      lT: x0 => x0.measurementId,
      lU: x0 => x0.isAnonymous,
      lV: x0 => x0.hardwareConcurrency,
      m: o => [o],
      mB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      mC: x0 => x0.navigator,
      mD: () => new TextDecoder("utf-8", {fatal: true}),
      mE: x0 => x0.buttons,
      mF: () => Date.now(),
      mG: (a, t) => a.concat(t),
      mH: (x0,x1) => { x0.placeholder = x1 },
      mI: x0 => x0.protocol,
      mJ: (x0,x1) => x0.getElementById(x1),
      mK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mL: x0 => x0.remove(),
      mM: x0 => new window.ImageDecoder(x0),
      mN: x0 => x0.value,
      mO: (x0,x1) => x0.selectNode(x1),
      mP: (x0,x1) => { x0.height = x1 },
      mQ: (x0,x1,x2) => x0.setItem(x1,x2),
      mR: x0 => x0.port,
      mS: (x0,x1) => { x0.async = x1 },
      mT: x0 => x0.appId,
      mU: x0 => x0.emailVerified,
      mV: x0 => x0.vendorSub,
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
      nJ: (x0,x1) => x0.append(x1),
      nK: (x0,x1) => { x0.onbufferedamountlow = x1 },
      nL: (o, a) => o === a,
      nM: x0 => x0.name,
      nN: x0 => x0.openCursor(),
      nO: x0 => x0.getSelection(),
      nP: (x0,x1) => { x0.width = x1 },
      nQ: (x0,x1) => x0.canShare(x1),
      nR: x0 => x0.destination,
      nS: x0 => x0.stream,
      nT: x0 => x0.messagingSenderId,
      nU: x0 => x0.email,
      nV: x0 => x0.productSub,
      o: (o0, o1, o2) => [o0, o1, o2],
      oB: Function.prototype.call.bind(DataView.prototype.getUint32),
      oC: Object.is,
      oD: (a, i, v) => a[i] = v,
      oE: x0 => x0.y,
      oF: (x0,x1) => x0.requestAnimationFrame(x1),
      oG: () => globalThis.crypto,
      oH: (x0,x1) => { x0.method = x1 },
      oI: (x0,x1) => x0.close(x1),
      oJ: (x0,x1) => x0.setSinkId(x1),
      oK: (x0,x1) => { x0.onmessage = x1 },
      oL: x0 => x0.pause(),
      oM: x0 => x0.repetitionCount,
      oN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oO: x0 => x0.removeAllRanges(),
      oP: x0 => x0.height,
      oQ: (x0,x1) => x0.share(x1),
      oR: (x0,x1) => x0.addModule(x1),
      oS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oT: x0 => x0.authDomain,
      oU: x0 => x0.displayName,
      oV: x0 => x0.product,
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
      pK: x0 => x0.arrayBuffer(),
      pL: (x0,x1) => { x0.playsInline = x1 },
      pM: x0 => x0.frameCount,
      pN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pO: (x0,x1) => x0.addRange(x1),
      pP: x0 => x0.width,
      pQ: x0 => x0.click(),
      pR: x0 => ({parameterData: x0}),
      pS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pT: x0 => x0.projectId,
      pU: x0 => globalThis.firebase_auth.multiFactor(x0),
      pV: x0 => x0.platform,
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
      qK: (x0,x1) => { x0.onopen = x1 },
      qL: (x0,x1) => x0.removeTrack(x1),
      qM: x0 => x0.selectedTrack,
      qN: x0 => x0.continue(),
      qO: () => globalThis.window,
      qP: x0 => x0.rasterEndMilliseconds,
      qQ: (o, a) => o + a,
      qR: (x0,x1,x2) => new AudioWorkletNode(x0,x1,x2),
      qS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qT: x0 => x0.name,
      qU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qV: x0 => x0.languages,
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
      rK: (x0,x1) => { x0.onclose = x1 },
      rL: (x0,x1,x2) => ({candidate: x0,sdpMid: x1,sdpMLineIndex: x2}),
      rM: x0 => x0.completed,
      rN: x0 => x0.target,
      rO: (x0,x1) => { x0.innerText = x1 },
      rP: x0 => x0.rasterStartMilliseconds,
      rQ: x0 => x0.children,
      rR: x0 => x0.audioWorklet,
      rS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rV: x0 => x0.language,
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
      sK: x0 => x0.channel,
      sL: (x0,x1) => x0.addIceCandidate(x1),
      sM: x0 => x0.ready,
      sN: (x0,x1) => x0.getAllKeys(x1),
      sO: x0 => x0.offsetY,
      sP: x0 => x0.imageBitmaps,
      sQ: (x0,x1) => { x0.download = x1 },
      sR: (x0,x1) => x0.getFloatFrequencyData(x1),
      sS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sU: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      sV: x0 => x0.deviceMemory,
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
      tK: x0 => x0.getStats(),
      tL: x0 => x0.type,
      tM: x0 => x0.tracks,
      tN: x0 => x0.key,
      tO: x0 => x0.offsetX,
      tP: x0 => x0.canvasKitMaximumSurfaces,
      tQ: (x0,x1) => { x0.href = x1 },
      tR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tT: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      tU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tV: x0 => x0.appVersion,
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
      uK: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      uL: x0 => x0.sdp,
      uM: () => globalThis.window.ImageDecoder,
      uN: x0 => x0.close(),
      uO: x0 => x0.button,
      uP: x0 => x0.nextSibling,
      uQ: x0 => ({url: x0}),
      uR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uT: x0 => x0.call(),
      uU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uV: x0 => x0.appName,
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
      vK: x0 => x0.label,
      vL: x0 => x0.remoteDescription,
      vM: (x0,x1,x2,x3) => ({name: x0,hash: x1,salt: x2,iterations: x3}),
      vN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      vO: x0 => x0.classList,
      vP: (x0,x1) => x0.debug(x1),
      vQ: x0 => ({files: x0}),
      vR: (x0,x1,x2) => x0.getCurrentPosition(x1,x2),
      vS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      vT: x0 => x0.toJSON(),
      vU: x0 => x0.user,
      vV: x0 => x0.appCodeName,
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
      wK: x0 => x0.kind,
      wL: x0 => x0.input,
      wM: (x0,x1,x2) => globalThis.crypto.subtle.deriveBits(x0,x1,x2),
      wN: (x0,x1) => x0.deleteObjectStore(x1),
      wO: x0 => x0.sheet,
      wP: x0 => x0.hostElement,
      wQ: () => ({}),
      wR: () => globalThis.Notification.requestPermission(),
      wS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wT: x0 => x0.uid,
      wU: x0 => x0.idToken,
      wV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      xJ: x0 => x0.restartIce(),
      xK: x0 => x0.groupId,
      xL: (x0,x1) => ({type: x0,sdp: x1}),
      xM: (x0,x1,x2,x3,x4) => globalThis.crypto.subtle.importKey(x0,x1,x2,x3,x4),
      xN: x0 => x0.length,
      xO: x0 => x0.head,
      xP: x0 => x0.location,
      xQ: (x0,x1,x2) => new File(x0,x1,x2),
      xR: x0 => ({video: x0}),
      xS: (x0,x1) => { x0.preload = x1 },
      xT: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      xU: x0 => x0.secret,
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
      yJ: x0 => x0.close(),
      yK: x0 => x0.deviceId,
      yL: (x0,x1) => x0.setLocalDescription(x1),
      yM: () => globalThis.window.isSecureContext,
      yN: x0 => x0.name,
      yO: x0 => x0.decode(),
      yP: (x0,x1) => x0.getModifierState(x1),
      yQ: (x0,x1) => { x0.type = x1 },
      yR: x0 => x0.active,
      yS: x0 => x0.src,
      yT: x0 => x0.sessionStorage,
      yU: x0 => x0.accessToken,
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
      zJ: (x0,x1) => x0.createOffer(x1),
      zK: x0 => x0.enumerateDevices(),
      zL: (x0,x1) => x0.createAnswer(x1),
      zM: () => globalThis.crypto.subtle,
      zN: (x0,x1) => x0.get(x1),
      zO: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      zP: x0 => x0.metaKey,
      zQ: x0 => ({name: x0}),
      zR: x0 => x0.geolocation,
      zS: (x0,x1) => x0.getAttribute(x1),
      zT: x0 => x0.hostname,
      zU: x0 => x0.signInMethod,
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
