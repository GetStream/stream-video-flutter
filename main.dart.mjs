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
      AH: x0 => x0.state,
      AI: x0 => x0.unlock(),
      AJ: (x0,x1) => x0.get(x1),
      AK: (x0,x1) => x0.removeTrack(x1),
      AL: x0 => x0.iceConnectionState,
      AM: x0 => x0.message,
      AN: x0 => x0.frameCount,
      AO: (x0,x1,x2) => x0.transaction(x1,x2),
      AP: (x0,x1) => { x0.width = x1 },
      AQ: x0 => x0.length,
      AR: (x0,x1) => { x0.charset = x1 },
      AS: x0 => x0.y,
      AT: (x0,x1) => { x0.src = x1 },
      AU: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      AV: x0 => x0.uid,
      AW: x0 => x0.webkitGetAsEntry(),
      B: s => printToConsole(s),
      BB: b => !!b,
      BC: Function.prototype.call.bind(DataView.prototype.setUint16),
      BD: x0 => x0.width,
      BE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      BF: x0 => x0.wheelDeltaX,
      BG: () => globalThis.Intl,
      BH: x0 => x0.hash,
      BI: (x0,x1) => x0.lock(x1),
      BJ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      BK: x0 => x0.track,
      BL: x0 => x0.sdpMLineIndex,
      BM: x0 => x0.code,
      BN: x0 => x0.selectedTrack,
      BO: (x0,x1) => x0.objectStore(x1),
      BP: (x0,x1) => { x0.objectFit = x1 },
      BQ: x0 => x0.buffered,
      BR: (x0,x1) => { x0.type = x1 },
      BS: x0 => x0.x,
      BT: x0 => x0.trustedTypes,
      BU: x0 => x0.storageBucket,
      BV: x0 => x0.enrollmentTime,
      BW: x0 => x0.createReader(),
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      CC: Function.prototype.call.bind(DataView.prototype.setUint8),
      CD: x0 => x0.screen,
      CE: x0 => new ResizeObserver(x0),
      CF: x0 => x0.key,
      CG: (x0,x1) => x0.segment(x1),
      CH: x0 => x0.state,
      CI: x0 => x0.orientation,
      CJ: (x0,x1) => x0.forEach(x1),
      CK: x0 => x0.sender,
      CL: x0 => x0.sdpMid,
      CM: x0 => x0.error,
      CN: x0 => x0.completed,
      CO: (x0,x1) => x0.getAll(x1),
      CP: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      CQ: x0 => x0.duration,
      CR: (x0,x1) => x0.item(x1),
      CS: x0 => x0.resultPoints,
      CT: x0 => x0.trustedTypes,
      CU: x0 => x0.databaseURL,
      CV: x0 => x0.factorId,
      CW: () => new Blob(),
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
      DH: (x0,x1) => x0.go(x1),
      DI: (x0,x1) => x0.querySelector(x1),
      DJ: x0 => x0.name,
      DK: x0 => x0.stop(),
      DL: x0 => x0.candidate,
      DM: x0 => x0.videoHeight,
      DN: x0 => x0.ready,
      DO: x0 => x0.value,
      DP: (x0,x1) => x0.requestVideoFrameCallback(x1),
      DQ: (x0,x1) => { x0.playsInline = x1 },
      DR: x0 => x0.id,
      DS: x0 => x0.message,
      DT: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      DU: x0 => x0.apiKey,
      DV: x0 => x0.displayName,
      DW: (x0,x1,x2,x3) => x0.slice(x1,x2,x3),
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
      EJ: x0 => x0.statusText,
      EK: x0 => x0.label,
      EL: x0 => x0.candidate,
      EM: x0 => x0.videoWidth,
      EN: x0 => x0.tracks,
      EO: x0 => x0.openCursor(),
      EP: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      EQ: (x0,x1) => { x0.width = x1 },
      ER: x0 => x0.length,
      ES: x0 => x0.videoElement,
      ET: x0 => { globalThis.onGoogleLibraryLoad = x0 },
      EU: x0 => x0.options,
      EV: x0 => x0.hints,
      EW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      FJ: x0 => x0.url,
      FK: x0 => x0.kind,
      FL: x0 => x0.label,
      FM: (x0,x1) => { x0.controls = x1 },
      FN: () => globalThis.window.ImageDecoder,
      FO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FP: (x0,x1) => x0.requestAnimationFrame(x1),
      FQ: (x0,x1) => { x0.height = x1 },
      FR: x0 => x0.stop(),
      FS: x0 => x0.decodeContinuously,
      FT: x0 => x0.message,
      FU: () => globalThis.firebase_core.SDK_VERSION,
      FV: x0 => x0.tenantId,
      FW: (x0,x1) => x0.file(x1),
      G: s => JSON.stringify(s),
      GB: () => [],
      GC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      GD: x0 => x0.activeElement,
      GE: x0 => x0.documentElement,
      GF: x0 => x0.tiltY,
      GG: x0 => x0.done,
      GH: (d, digits) => d.toFixed(digits),
      GI: x0 => x0.content,
      GJ: x0 => x0.status,
      GK: x0 => x0.groupId,
      GL: x0 => x0.id,
      GM: (x0,x1,x2) => ({candidate: x0,sdpMid: x1,sdpMLineIndex: x2}),
      GN: (x0,x1,x2,x3) => ({name: x0,hash: x1,salt: x2,iterations: x3}),
      GO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GP: (x0,x1,x2,x3) => x0.call(x1,x2,x3),
      GQ: (x0,x1) => { x0.border = x1 },
      GR: (x0,x1,x2) => ({mimeType: x0,audioBitsPerSecond: x1,bitsPerSecond: x2}),
      GS: (x0,x1) => new ZXing.BrowserMultiFormatReader(x0,x1),
      GT: x0 => x0.code,
      GU: (x0,x1,x2) => globalThis.firebase_core.registerVersion(x0,x1,x2),
      GV: x0 => x0.phoneNumber,
      GW: x0 => x0.lastModified,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (a, i) => a.push(i),
      HC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      HD: x0 => x0.parentNode,
      HE: x0 => x0.computedStyleMap(),
      HF: x0 => x0.tiltX,
      HG: (o, m, a) => o[m].apply(o, a),
      HH: x0 => x0.maxHeight,
      HI: x0 => x0.document,
      HJ: x0 => x0.getReader(),
      HK: x0 => x0.deviceId,
      HL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      HM: (x0,x1) => x0.addIceCandidate(x1),
      HN: (x0,x1,x2) => globalThis.crypto.subtle.deriveBits(x0,x1,x2),
      HO: x0 => x0.continue(),
      HP: x0 => x0.currentTime,
      HQ: x0 => x0.pause(),
      HR: (x0,x1) => new MediaRecorder(x0,x1),
      HS: (x0,x1) => ({width: x0,height: x1}),
      HT: (x0,x1) => globalThis.firebase_messaging.getToken(x0,x1),
      HU: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      HV: x0 => x0.email,
      HW: x0 => x0.fullPath,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Int8Array(x0),
      IC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      ID: x0 => x0.tagName,
      IE: (x0,x1) => x0.get(x1),
      IF: x0 => x0.pointerType,
      IG: x0 => x0.iterator,
      IH: x0 => x0.maxWidth,
      II: x0 => new WeakRef(x0),
      IJ: x0 => x0.read(),
      IK: x0 => x0.enumerateDevices(),
      IL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IM: x0 => x0.type,
      IN: (x0,x1,x2,x3,x4) => globalThis.crypto.subtle.importKey(x0,x1,x2,x3,x4),
      IO: x0 => x0.target,
      IP: (x0,x1) => x0.querySelectorAll(x1),
      IQ: x0 => x0.message,
      IR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IS: (x0,x1,x2) => ({width: x0,height: x1,facingMode: x2}),
      IT: x0 => x0.link,
      IU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IV: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      IW: x0 => x0.name,
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
      JJ: x0 => x0.value,
      JK: x0 => x0.mediaDevices,
      JL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JM: x0 => x0.sdp,
      JN: () => globalThis.window.isSecureContext,
      JO: (x0,x1) => x0.getAllKeys(x1),
      JP: (x0,x1) => x0.item(x1),
      JQ: (x0,x1) => { x0.currentTime = x1 },
      JR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JS: x0 => x0.facingMode,
      JT: x0 => x0.analyticsLabel,
      JU: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      JV: x0 => x0.customData,
      JW: (a, l) => a.length = l,
      K: o => o,
      KB: x0 => new Uint8Array(x0),
      KC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      KD: x0 => x0.clientY,
      KE: (x0,x1) => { x0.textContent = x1 },
      KF: x0 => x0.getCoalescedEvents(),
      KG: (x0,x1) => new Intl.Segmenter(x0,x1),
      KH: x0 => x0.minWidth,
      KI: () => globalThis.WeakRef,
      KJ: x0 => x0.done,
      KK: x0 => x0.navigator,
      KL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      KM: x0 => x0.remoteDescription,
      KN: () => globalThis.crypto.subtle,
      KO: x0 => x0.key,
      KP: x0 => x0.length,
      KQ: (x0,x1) => { x0.playbackRate = x1 },
      KR: (x0,x1) => x0.start(x1),
      KS: x0 => x0.attachStreamToVideo,
      KT: x0 => x0.image,
      KU: (x0,x1) => x0.createScriptURL(x1),
      KV: x0 => x0.message,
      KW: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      LI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      LJ: x0 => x0.cancel(),
      LK: () => globalThis.window,
      LL: (x0,x1) => { x0.onbufferedamountlow = x1 },
      LM: x0 => x0.input,
      LN: x0 => x0.close(),
      LO: x0 => x0.close(),
      LP: (x0,x1,x2) => x0.insertBefore(x1,x2),
      LQ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      LR: (x0,x1) => { x0.smoothingTimeConstant = x1 },
      LS: () => new Map(),
      LT: x0 => x0.body,
      LU: (x0,x1,x2) => x0.createScript(x1,x2),
      LV: x0 => x0.code,
      LW: (x0,x1) => x0.readEntries(x1),
      M: x0 => x0.index,
      MB: x0 => new Int16Array(x0),
      MC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      MD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      ME: x0 => x0.matches,
      MF: s => s.trimLeft(),
      MG: x0 => x0.buffer,
      MH: (x0,x1) => x0.add(x1),
      MI: (a, s, e) => a.slice(s, e),
      MJ: x0 => x0.body,
      MK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ML: (x0,x1) => { x0.onmessage = x1 },
      MM: (x0,x1) => ({type: x0,sdp: x1}),
      MN: x0 => x0.getTracks(),
      MO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      MP: x0 => x0.id,
      MQ: x0 => globalThis.URL.revokeObjectURL(x0),
      MR: (x0,x1) => { x0.maxDecibels = x1 },
      MS: (x0,x1,x2) => x0.set(x1,x2),
      MT: x0 => x0.title,
      MU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      MV: (x0,x1) => globalThis.firebase_auth.signInWithPopup(x0,x1),
      MW: x0 => x0.isDirectory,
      N: o => String(o),
      NB: x0 => new Uint16Array(x0),
      NC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      ND: x0 => x0.getBoundingClientRect(),
      NE: (x0,x1) => x0.matchMedia(x1),
      NF: s => s.toUpperCase(),
      NG: x0 => x0.wasmMemory,
      NH: x0 => x0.data,
      NI: () => new XMLHttpRequest(),
      NJ: x0 => x0.headers,
      NK: (x0,x1) => { x0.ondevicechange = x1 },
      NL: x0 => x0.arrayBuffer(),
      NM: (x0,x1) => x0.setLocalDescription(x1),
      NN: x0 => ({audio: x0}),
      NO: (x0,x1) => x0.deleteObjectStore(x1),
      NP: x0 => x0.offsetHeight,
      NQ: x0 => x0.type,
      NR: (x0,x1) => { x0.minDecibels = x1 },
      NS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      NT: x0 => x0.fcmOptions,
      NU: (o, p) => delete o[p],
      NV: (x0,x1) => x0.setCustomParameters(x1),
      NW: (x0,x1) => x0[x1],
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
      OI: (x0,x1,x2) => x0.open(x1,x2),
      OJ: x0 => x0.signal,
      OK: x0 => x0.getStats(),
      OL: (x0,x1) => { x0.onopen = x1 },
      OM: (x0,x1) => x0.createAnswer(x1),
      ON: () => new AudioContext(),
      OO: x0 => x0.length,
      OP: x0 => x0.offsetWidth,
      OQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OR: x0 => ({sampleRate: x0}),
      OS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OT: x0 => x0.notification,
      OU: (o, p, v) => o[p] = v,
      OV: (x0,x1) => x0.addScope(x1),
      OW: x0 => x0.length,
      P: (x0,x1) => x0.exec(x1),
      PB: x0 => new Int32Array(x0),
      PC: (x0,x1) => x0.querySelector(x1),
      PD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      PE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      PF: x0 => x0.flags,
      PG: () => new TextDecoder(),
      PH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      PI: (x0,x1) => x0.send(x1),
      PJ: (o, p) => p in o,
      PK: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      PL: (x0,x1) => { x0.onclose = x1 },
      PM: (x0,x1) => ({type: x0,sdp: x1}),
      PN: (x0,x1) => x0.createMediaStreamSource(x1),
      PO: x0 => x0.name,
      PP: x0 => x0.stopPropagation(),
      PQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PR: x0 => new AudioContext(x0),
      PS: (x0,x1) => { x0.onpause = x1 },
      PT: x0 => x0.messageId,
      PU: (x0,x1) => { x0.text = x1 },
      PV: () => new firebase_auth.GoogleAuthProvider(),
      PW: x0 => x0.items,
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
      QI: x0 => x0.send(),
      QJ: x0 => x0.groups,
      QK: (x0,x1) => { x0.enabled = x1 },
      QL: x0 => x0.channel,
      QM: (x0,x1) => x0.setRemoteDescription(x1),
      QN: x0 => x0.createAnalyser(),
      QO: (x0,x1) => x0.get(x1),
      QP: x0 => x0.disabled,
      QQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      QR: (x0,x1) => { x0.onstop = x1 },
      QS: (x0,x1) => { x0.onplay = x1 },
      QT: x0 => x0.from,
      QU: (x0,x1) => { x0.text = x1 },
      QV: x0 => x0.firstChild,
      QW: x0 => x0.dataTransfer,
      R: o => o,
      RB: x0 => new Uint32Array(x0),
      RC: x0 => x0.length,
      RD: (handle) => clearTimeout(handle),
      RE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RF: (x0,x1) => x0.error(x1),
      RG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      RH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      RI: x0 => x0.abort(),
      RJ: x0 => x0.close(),
      RK: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      RL: x0 => x0.getSettings(),
      RM: x0 => x0.mid,
      RN: (x0,x1) => x0.connect(x1),
      RO: (x0,x1) => x0.createObjectStore(x1),
      RP: (x0,x1) => { x0.min = x1 },
      RQ: (x0,x1) => { x0.crossOrigin = x1 },
      RR: (x0,x1) => globalThis.jsFixWebmDuration(x0,x1),
      RS: (x0,x1) => { x0.transformOrigin = x1 },
      RT: x0 => x0.collapseKey,
      RU: x0 => x0.trustedTypes,
      RV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RW: x0 => x0.level,
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
      SI: x0 => x0.readyState,
      SJ: (x0,x1) => x0.removeAttribute(x1),
      SK: (o, a) => o === a,
      SL: x0 => x0.groupId,
      SM: x0 => x0.getTransceivers(),
      SN: (x0,x1) => x0.getByteFrequencyData(x1),
      SO: x0 => x0.version,
      SP: (x0,x1) => { x0.max = x1 },
      SQ: (x0,x1) => x0.getContext(x1),
      SR: x0 => x0.mimeType,
      SS: x0 => x0.getSupportedConstraints(),
      ST: x0 => x0.data,
      SU: x0 => x0.providerId,
      SV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      SW: x0 => x0.getBattery(),
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
      TI: x0 => x0.total,
      TJ: x0 => x0.load(),
      TK: (x0,x1) => x0.setSinkId(x1),
      TL: x0 => x0.deviceId,
      TM: x0 => x0.localDescription,
      TN: x0 => x0.frequencyBinCount,
      TO: x0 => x0.objectStoreNames,
      TP: (x0,x1) => { x0.disabled = x1 },
      TQ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      TR: (x0,x1) => { x0.ondataavailable = x1 },
      TS: x0 => ({facingMode: x0}),
      TT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      TU: x0 => x0.providerData,
      TV: x0 => x0.length,
      TW: x0 => x0.length,
      U: (string, times) => string.repeat(times),
      UB: x0 => new Float64Array(x0),
      UC: x0 => x0.remove(),
      UD: x0 => x0.top,
      UE: (o, i) => o[i],
      UF: x0 => x0.blur(),
      UG: a => a.pop(),
      UH: x0 => x0.selectionDirection,
      UI: x0 => x0.loaded,
      UJ: x0 => x0.remove(),
      UK: x0 => x0.userAgent,
      UL: x0 => x0.resizeMode,
      UM: x0 => x0.naturalHeight,
      UN: x0 => x0.resume(),
      UO: (x0,x1) => { x0.onupgradeneeded = x1 },
      UP: (x0,x1) => { x0.scrollLeft = x1 },
      UQ: (x0,x1,x2,x3,x4,x5) => x0.drawImage(x1,x2,x3,x4,x5),
      UR: x0 => x0.data,
      US: x0 => x0.facingMode,
      UT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      UU: x0 => x0.tenantId,
      UV: (x0,x1) => x0.item(x1),
      UW: x0 => x0.getReader(),
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
      VI: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      VJ: (x0,x1) => x0.getElementById(x1),
      VK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      VL: x0 => x0.facingMode,
      VM: x0 => x0.naturalWidth,
      VN: x0 => x0.state,
      VO: (x0,x1) => x0.append(x1),
      VP: (x0,x1) => { x0.spellcheck = x1 },
      VQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      VR: x0 => globalThis.MediaRecorder.isTypeSupported(x0),
      VS: (x0,x1) => x0.querySelector(x1),
      VT: (x0,x1) => ({next: x0,error: x1}),
      VU: x0 => x0.refreshToken,
      VV: x0 => x0.name,
      VW: x0 => x0.value,
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
      WI: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      WJ: x0 => x0.hasChildNodes(),
      WK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WL: x0 => x0.frameRate,
      WM: (x0,x1) => x0.createElement(x1),
      WN: (x0,x1) => { x0.fftSize = x1 },
      WO: (x0,x1,x2) => x0.insertRule(x1,x2),
      WP: (x0,x1) => { x0.disabled = x1 },
      WQ: (x0,x1,x2,x3) => x0.toBlob(x1,x2,x3),
      WR: x0 => x0.disconnect(),
      WS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WT: (x0,x1) => globalThis.firebase_messaging.onMessage(x0,x1),
      WU: x0 => x0.photoURL,
      WV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WW: x0 => x0.done,
      X: x0 => x0.dotAll,
      XB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      XC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      XD: x0 => x0.clientY,
      XE: x0 => x0.language,
      XF: x0 => x0.innerWidth,
      XG: () => new WeakMap(),
      XH: x0 => x0.value,
      XI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XJ: () => globalThis.document,
      XK: x0 => x0.play(),
      XL: x0 => x0.aspectRatio,
      XM: (x0,x1) => { x0.pointerEvents = x1 },
      XN: x0 => new Blob(x0),
      XO: (x0,x1) => x0.add(x1),
      XP: (x0,x1) => x0.cancelVideoFrameCallback(x1),
      XQ: (x0,x1) => { x0.height = x1 },
      XR: (x0,x1) => x0.removeTrack(x1),
      XS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XT: x0 => globalThis.firebase_messaging.getMessaging(x0),
      XU: x0 => x0.phoneNumber,
      XV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      XW: x0 => x0.read(),
      Y: x0 => x0.unicode,
      YB: (x0,x1,x2) => new DataView(x0,x1,x2),
      YC: x0 => x0.style,
      YD: x0 => x0.clientX,
      YE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      YF: x0 => x0.height,
      YG: x0 => x0.debugSkipFontRetryDelay,
      YH: x0 => x0.selectionDirection,
      YI: x0 => x0.upload,
      YJ: () => new MediaStream(),
      YK: x0 => x0.paused,
      YL: x0 => x0.height,
      YM: (x0,x1) => { x0.height = x1 },
      YN: x0 => ({type: x0}),
      YO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      YP: (x0,x1) => x0.cancelAnimationFrame(x1),
      YQ: (x0,x1) => { x0.width = x1 },
      YR: (x0,x1) => x0.warn(x1),
      YS: (x0,x1) => { x0.onerror = x1 },
      YT: x0 => globalThis.firebase_core.getApp(x0),
      YU: x0 => x0.lastSignInTime,
      YV: x0 => x0.files,
      YW: (x0,x1) => new OffscreenCanvas(x0,x1),
      Z: x0 => x0.ignoreCase,
      ZB: (o, p) => o[p],
      ZC: x0 => x0.debugShowSemanticsNodes,
      ZD: x0 => x0.changedTouches,
      ZE: () => globalThis.window.FinalizationRegistry,
      ZF: x0 => x0.width,
      ZG: x0 => x0.status,
      ZH: x0 => x0.selectionStart,
      ZI: x0 => x0.responseURL,
      ZJ: x0 => x0.getVideoTracks(),
      ZK: x0 => x0.ended,
      ZL: x0 => x0.width,
      ZM: (x0,x1) => { x0.width = x1 },
      ZN: (x0,x1) => new Blob(x0,x1),
      ZO: (x0,x1,x2) => x0.addEventListener(x1,x2),
      ZP: (x0,x1) => x0.transferFromImageBitmap(x1),
      ZQ: (x0,x1) => x0.getItem(x1),
      ZR: () => globalThis.console,
      ZS: (x0,x1) => x0.removeChild(x1),
      ZT: () => globalThis.firebase_core.getApp(),
      ZU: x0 => x0.creationTime,
      ZV: (x0,x1) => { x0.accept = x1 },
      ZW: x0 => x0.assetBase,
      a: x0 => x0.multiline,
      aB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      aC: (x0,x1) => x0.warn(x1),
      aD: x0 => x0.offsetY,
      aE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aF: x0 => x0.clientHeight,
      aG: (x0,x1,x2) => x0.set(x1,x2),
      aH: x0 => x0.selectionEnd,
      aI: x0 => x0.statusText,
      aJ: (x0,x1) => x0.addTrack(x1),
      aK: x0 => x0.srcObject,
      aL: x0 => x0.channelCount,
      aM: x0 => x0.style,
      aN: x0 => x0.size,
      aO: x0 => x0.preventDefault(),
      aP: (x0,x1) => x0.getContext(x1),
      aQ: x0 => x0.localStorage,
      aR: x0 => x0.state,
      aS: (x0,x1) => { x0.onload = x1 },
      aT: x0 => x0.recaptchaSiteKey,
      aU: x0 => x0.metadata,
      aV: (x0,x1) => { x0.multiple = x1 },
      aW: x0 => x0.loader,
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
      bI: x0 => x0.getAllResponseHeaders(),
      bJ: x0 => x0.getAudioTracks(),
      bK: x0 => x0.readyState,
      bL: x0 => x0.latency,
      bM: (x0,x1) => { x0.src = x1 },
      bN: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      bO: x0 => x0.createRange(),
      bP: (x0,x1) => { x0.height = x1 },
      bQ: (x0,x1) => x0.key(x1),
      bR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      bS: (x0,x1) => { x0.crossOrigin = x1 },
      bT: x0 => x0.measurementId,
      bU: x0 => x0.isAnonymous,
      bV: (x0,x1) => { x0.draggable = x1 },
      bW: () => globalThis._flutter,
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
      cI: x0 => x0.status,
      cJ: (x0,x1) => x0.append(x1),
      cK: x0 => x0.type,
      cL: x0 => x0.noiseSuppression,
      cM: () => globalThis.document,
      cN: x0 => x0.vendor,
      cO: (x0,x1) => x0.selectNode(x1),
      cP: (x0,x1) => { x0.width = x1 },
      cQ: x0 => x0.length,
      cR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      cS: (x0,x1) => { x0.lang = x1 },
      cT: x0 => x0.appId,
      cU: x0 => x0.emailVerified,
      cV: (x0,x1) => { x0.type = x1 },
      d: (x0,x1) => x0.didCreateEngineInitializer(x1),
      dB: o => o.buffer,
      dC: (o, c) => o instanceof c,
      dD: x0 => x0.maxTouchPoints,
      dE: (x0,x1) => x0.contains(x1),
      dF: (x0,x1) => { x0.name = x1 },
      dG: (x0,x1) => x0.fetch(x1),
      dH: x0 => x0.multiViewEnabled,
      dI: x0 => x0.response,
      dJ: (x0,x1) => { x0.top = x1 },
      dK: x0 => x0.restartIce(),
      dL: x0 => x0.autoGainControl,
      dM: x0 => x0.src,
      dN: o => o.byteLength,
      dO: x0 => x0.getSelection(),
      dP: x0 => x0.height,
      dQ: (x0,x1) => x0.removeItem(x1),
      dR: (x0,x1) => { x0.onmessage = x1 },
      dS: (x0,x1) => { x0.defer = x1 },
      dT: x0 => x0.messagingSenderId,
      dU: x0 => x0.email,
      dV: x0 => x0.maxTouchPoints,
      e: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eB: Function.prototype.call.bind(DataView.prototype.getUint8),
      eC: (x0,x1) => x0[x1],
      eD: x0 => x0.platform,
      eE: (s) => +s,
      eF: x0 => x0.head,
      eG: x0 => x0.fontFallbackBaseUrl,
      eH: (x0,x1) => x0.replaceWith(x1),
      eI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eJ: (x0,x1) => { x0.left = x1 },
      eK: (x0,x1) => x0.createOffer(x1),
      eL: x0 => x0.echoCancellation,
      eM: (x0,x1) => x0.revokeObjectURL(x1),
      eN: () => new FileReader(),
      eO: x0 => x0.removeAllRanges(),
      eP: x0 => x0.width,
      eQ: (x0,x1,x2) => x0.setItem(x1,x2),
      eR: x0 => x0.port,
      eS: (x0,x1) => { x0.async = x1 },
      eT: x0 => x0.authDomain,
      eU: x0 => x0.displayName,
      eV: x0 => x0.hardwareConcurrency,
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
      fI: (x0,x1) => { x0.timeout = x1 },
      fJ: (x0,x1) => { x0.position = x1 },
      fK: x0 => x0.type,
      fL: x0 => x0.sampleSize,
      fM: (x0,x1) => { x0.src = x1 },
      fN: (x0,x1) => x0.readAsArrayBuffer(x1),
      fO: (x0,x1) => x0.addRange(x1),
      fP: x0 => x0.rasterEndMilliseconds,
      fQ: (x0,x1) => x0.canShare(x1),
      fR: x0 => x0.destination,
      fS: x0 => x0.stream,
      fT: x0 => x0.projectId,
      fU: x0 => globalThis.firebase_auth.multiFactor(x0),
      fV: x0 => x0.vendorSub,
      g: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      gB: (b, o, l) => new DataView(b, o, l),
      gC: (string, token) => string.split(token),
      gD: () => globalThis.document,
      gE: s => s.trim(),
      gF: x0 => x0.firstChild,
      gG: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      gH: (x0,x1) => { x0.className = x1 },
      gI: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      gJ: (x0,x1) => { x0.opacity = x1 },
      gK: x0 => x0.sdp,
      gL: x0 => x0.sampleRate,
      gM: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      gN: x0 => x0.result,
      gO: () => globalThis.window,
      gP: x0 => x0.rasterStartMilliseconds,
      gQ: (x0,x1) => x0.share(x1),
      gR: (x0,x1) => x0.addModule(x1),
      gS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gT: x0 => x0.name,
      gU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gV: x0 => x0.productSub,
      h: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      hB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      hC: o => o instanceof Array,
      hD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      hE: x0 => x0.classList,
      hF: x0 => x0.viewConstraints,
      hG: () => Date.now(),
      hH: (x0,x1) => { x0.tabIndex = x1 },
      hI: (x0,x1) => { x0.withCredentials = x1 },
      hJ: (x0,x1) => { x0.pointerEvents = x1 },
      hK: (x0,x1,x2) => x0.addTransceiver(x1,x2),
      hL: (x0,x1) => x0.replaceTrack(x1),
      hM: x0 => x0.naturalHeight,
      hN: x0 => globalThis.URL.createObjectURL(x0),
      hO: (x0,x1) => { x0.innerText = x1 },
      hP: x0 => x0.imageBitmaps,
      hQ: x0 => x0.click(),
      hR: x0 => ({parameterData: x0}),
      hS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hV: x0 => x0.product,
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
      iI: (x0,x1) => { x0.responseType = x1 },
      iJ: (x0,x1) => { x0.transform = x1 },
      iK: x0 => new RTCPeerConnection(x0),
      iL: x0 => x0.stop(),
      iM: x0 => x0.naturalWidth,
      iN: (x0,x1) => x0.get(x1),
      iO: x0 => x0.offsetY,
      iP: x0 => x0.canvasKitMaximumSurfaces,
      iQ: (o, a) => o + a,
      iR: (x0,x1,x2) => new AudioWorkletNode(x0,x1,x2),
      iS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iT: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iU: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      iV: x0 => x0.platform,
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
      jI: x0 => x0.protocol,
      jJ: x0 => x0.style,
      jK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jL: x0 => x0.getParameters(),
      jM: x0 => x0.decode(),
      jN: x0 => x0.body,
      jO: x0 => x0.offsetX,
      jP: x0 => x0.nextSibling,
      jQ: x0 => x0.children,
      jR: x0 => x0.audioWorklet,
      jS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jT: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      jU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jV: x0 => x0.languages,
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
      kI: (x0,x1,x2) => x0.close(x1,x2),
      kJ: x0 => x0.body,
      kK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kL: (x0,x1) => x0.setParameters(x1),
      kM: (x0,x1) => { x0.decoding = x1 },
      kN: x0 => x0.headers,
      kO: x0 => x0.button,
      kP: (x0,x1) => x0.debug(x1),
      kQ: (x0,x1) => { x0.download = x1 },
      kR: (x0,x1) => x0.getFloatFrequencyData(x1),
      kS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kT: x0 => x0.call(),
      kU: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kV: x0 => x0.language,
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
      lI: (x0,x1) => x0.close(x1),
      lJ: (x0,x1) => { x0.display = x1 },
      lK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lL: (x0,x1) => { x0.encodings = x1 },
      lM: (x0,x1) => { x0.crossOrigin = x1 },
      lN: (x0,x1) => x0.deleteDatabase(x1),
      lO: x0 => x0.classList,
      lP: x0 => x0.hostElement,
      lQ: (x0,x1) => { x0.href = x1 },
      lR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lT: x0 => x0.toJSON(),
      lU: x0 => x0.user,
      lV: x0 => x0.deviceMemory,
      m: o => [o],
      mB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      mC: x0 => x0.navigator,
      mD: () => new TextDecoder("utf-8", {fatal: true}),
      mE: x0 => x0.buttons,
      mF: () => Date.now(),
      mG: (a, t) => a.concat(t),
      mH: (x0,x1) => { x0.placeholder = x1 },
      mI: x0 => x0.close(),
      mJ: (x0,x1) => x0.createElement(x1),
      mK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mL: x0 => x0.clockRate,
      mM: (x0,x1) => x0.createObjectURL(x1),
      mN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mO: x0 => x0.sheet,
      mP: x0 => x0.location,
      mQ: x0 => ({url: x0}),
      mR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mT: x0 => x0.uid,
      mU: x0 => x0.idToken,
      mV: x0 => x0.appVersion,
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
      nI: (x0,x1) => x0.send(x1),
      nJ: (x0,x1) => { x0.autoplay = x1 },
      nK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nL: x0 => x0.payloadType,
      nM: x0 => x0.URL,
      nN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nO: x0 => x0.head,
      nP: (x0,x1) => x0.getModifierState(x1),
      nQ: x0 => ({files: x0}),
      nR: (x0,x1,x2) => x0.getCurrentPosition(x1,x2),
      nS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nT: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      nU: x0 => x0.secret,
      nV: x0 => x0.appName,
      o: (o0, o1, o2) => [o0, o1, o2],
      oB: Function.prototype.call.bind(DataView.prototype.getUint32),
      oC: Object.is,
      oD: (a, i, v) => a[i] = v,
      oE: x0 => x0.y,
      oF: (x0,x1) => x0.requestAnimationFrame(x1),
      oG: () => globalThis.crypto,
      oH: (x0,x1) => { x0.method = x1 },
      oI: () => new Array(),
      oJ: (x0,x1) => { x0.muted = x1 },
      oK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oL: x0 => x0.active,
      oM: x0 => new Blob(x0),
      oN: (x0,x1) => { x0.onerror = x1 },
      oO: x0 => x0.decode(),
      oP: x0 => x0.metaKey,
      oQ: () => ({}),
      oR: () => globalThis.Notification.requestPermission(),
      oS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oT: x0 => x0.sessionStorage,
      oU: x0 => x0.accessToken,
      oV: x0 => x0.appCodeName,
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
      pI: (x0,x1) => new WebSocket(x0,x1),
      pJ: (x0,x1) => { x0.id = x1 },
      pK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pL: x0 => x0.headerExtensions,
      pM: x0 => x0.close(),
      pN: x0 => x0.error,
      pO: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      pP: x0 => x0.altKey,
      pQ: (x0,x1,x2) => new File(x0,x1,x2),
      pR: x0 => ({video: x0}),
      pS: (x0,x1) => { x0.preload = x1 },
      pT: x0 => x0.hostname,
      pU: x0 => x0.signInMethod,
      pV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      qI: x0 => x0.reason,
      qJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qL: x0 => x0.reducedSize,
      qM: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      qN: (x0,x1) => { x0.onsuccess = x1 },
      qO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qP: x0 => x0.ctrlKey,
      qQ: (x0,x1) => { x0.type = x1 },
      qR: x0 => x0.active,
      qS: x0 => x0.src,
      qT: x0 => x0.location,
      qU: x0 => x0.providerId,
      qV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
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
      rI: x0 => x0.code,
      rJ: (x0,x1,x2) => x0.addEventListener(x1,x2),
      rK: x0 => x0.id,
      rL: x0 => x0.cname,
      rM: (x0,x1) => x0.decode(x1),
      rN: x0 => x0.result,
      rO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rP: x0 => x0.isComposing,
      rQ: x0 => ({name: x0}),
      rR: x0 => x0.geolocation,
      rS: (x0,x1) => x0.getAttribute(x1),
      rT: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      rU: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      rV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      s: () => globalThis,
      sB: o => o instanceof Uint16Array,
      sC: (x0,x1) => { x0.nonce = x1 },
      sD: x0 => x0.visibilityState,
      sE: x0 => x0.scrollLeft,
      sF: x0 => new Uint8Array(x0),
      sG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      sH: x0 => x0.click(),
      sI: (o, t) => typeof o === t,
      sJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sK: x0 => x0.streams,
      sL: x0 => x0.rtcp,
      sM: x0 => x0.displayHeight,
      sN: x0 => x0.indexedDB,
      sO: x0 => x0.send(),
      sP: x0 => x0.code,
      sQ: (x0,x1) => x0.query(x1),
      sR: x0 => x0.baseURI,
      sS: (x0,x1) => x0.debug(x1),
      sT: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      sU: x0 => x0.username,
      sV: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      t: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tB: Function.prototype.call.bind(DataView.prototype.getUint16),
      tC: x0 => x0.nonce,
      tD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      tE: x0 => x0.offsetLeft,
      tF: (x0,x1,x2) => x0.slice(x1,x2),
      tG: x0 => x0.history,
      tH: (x0,x1) => x0.getElementsByClassName(x1),
      tI: x0 => x0.data,
      tJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tK: x0 => x0.transceiver,
      tL: x0 => x0.clone(),
      tM: x0 => x0.displayWidth,
      tN: x0 => x0.self,
      tO: x0 => x0.status,
      tP: x0 => x0.repeat,
      tQ: (o,s,v) => o[s] = v,
      tR: (x0,x1) => x0.call(x1),
      tS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tT: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      tU: x0 => x0.providerId,
      tV: (x0,x1) => { x0.ondragleave = x1 },
      u: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uB: o => o instanceof Int16Array,
      uC: () => globalThis.window.flutterConfiguration,
      uD: x0 => x0.disconnect(),
      uE: x0 => x0.offsetParent,
      uF: (x0,x1) => x0.decode(x1),
      uG: x0 => x0.search,
      uH: (x0,x1) => x0.dispatchEvent(x1),
      uI: x0 => x0.readyState,
      uJ: x0 => x0.id,
      uK: x0 => x0.receiver,
      uL: (x0,x1) => x0.getUserMedia(x1),
      uM: x0 => x0.duration,
      uN: (x0,x1,x2) => x0.open(x1,x2),
      uO: x0 => x0.response,
      uP: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uQ: () => Symbol("jsBoxedDartObjectProperty"),
      uR: x0 => x0.reset,
      uS: x0 => ({createScriptURL: x0}),
      uT: () => globalThis.firebase_auth.debugErrorMap,
      uU: x0 => x0.profile,
      uV: x0 => x0.preventDefault(),
      v: (x0,x1) => ({addView: x0,removeView: x1}),
      vB: Function.prototype.call.bind(DataView.prototype.getInt16),
      vC: (x0,x1) => x0.attachShadow(x1),
      vD: x0 => new Intl.Locale(x0),
      vE: (o, p, r) => o.replace(p, () => r),
      vF: (x0,x1) => x0.adoptText(x1),
      vG: x0 => x0.location,
      vH: (x0,x1) => x0.createEvent(x1),
      vI: (x0,x1) => { x0.binaryType = x1 },
      vJ: x0 => x0.muted,
      vK: x0 => x0.track,
      vL: (x0,x1) => ({video: x0,audio: x1}),
      vM: x0 => x0.image,
      vN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      vO: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      vP: (x0,x1) => { x0.loop = x1 },
      vQ: x0 => x0.state,
      vR: x0 => x0.stopContinuousDecode,
      vS: (x0,x1,x2) => x0.createPolicy(x1,x2),
      vT: () => globalThis.firebase_auth.browserSessionPersistence,
      vU: x0 => x0.isNewUser,
      vV: x0 => x0.clientY,
      w: (l, r) => l === r,
      wB: o => o instanceof Uint8ClampedArray,
      wC: (x0,x1) => x0.createElement(x1),
      wD: x0 => x0.region,
      wE: (o, p, r) => o.replaceAll(p, () => r),
      wF: x0 => x0.first(),
      wG: x0 => x0.pathname,
      wH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      wI: x0 => x0.abort(),
      wJ: x0 => x0.enabled,
      wK: x0 => x0.connectionState,
      wL: (x0,x1) => x0.getDisplayMedia(x1),
      wM: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      wN: (x0,x1) => x0.contains(x1),
      wO: (x0,x1) => { x0.responseType = x1 },
      wP: (x0,x1) => { x0.volume = x1 },
      wQ: x0 => x0.permissions,
      wR: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      wS: (x0,x1) => x0.createScriptURL(x1),
      wT: () => globalThis.firebase_auth.browserLocalPersistence,
      wU: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      wV: x0 => x0.clientX,
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
      xG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      xH: x0 => x0.readText(),
      xI: () => new AbortController(),
      xJ: x0 => x0.label,
      xK: x0 => x0.signalingState,
      xL: (x0,x1) => x0.appendChild(x1),
      xM: x0 => new window.ImageDecoder(x0),
      xN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xO: () => new XMLHttpRequest(),
      xP: (x0,x1) => { x0.src = x1 },
      xQ: (x0,x1) => x0.append(x1),
      xR: x0 => x0.text,
      xS: (x0,x1) => { x0.nonce = x1 },
      xT: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      xU: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      xV: (x0,x1) => { x0.ondragover = x1 },
      y: () => globalThis.Math,
      yB: Function.prototype.call.bind(DataView.prototype.setInt32),
      yC: x0 => x0.visualViewport,
      yD: x0 => x0.language,
      yE: x0 => x0.deltaY,
      yF: x0 => x0.current(),
      yG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      yH: x0 => x0.clipboard,
      yI: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      yJ: x0 => x0.kind,
      yK: (x0,x1) => { x0.onicegatheringstatechange = x1 },
      yL: x0 => x0.document,
      yM: x0 => x0.name,
      yN: (x0,x1) => x0.delete(x1),
      yO: () => globalThis.window.navigator.userAgent,
      yP: (x0,x1) => x0.start(x1),
      yQ: x0 => x0.head,
      yR: x0 => x0.barcodeFormat,
      yS: (x0,x1) => x0.querySelectorAll(x1),
      yT: x0 => x0.name,
      yU: x0 => x0.session,
      yV: (x0,x1) => { x0.ondragenter = x1 },
      z: (x0,x1) => x0.prepend(x1),
      zB: Function.prototype.call.bind(DataView.prototype.setUint32),
      zC: x0 => x0.devicePixelRatio,
      zD: x0 => x0.languages,
      zE: x0 => x0.deltaX,
      zF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      zG: o => Object.keys(o),
      zH: (x0,x1) => x0.writeText(x1),
      zI: (x0,x1) => globalThis.fetch(x0,x1),
      zJ: (x0,x1) => { x0.srcObject = x1 },
      zK: x0 => x0.iceGatheringState,
      zL: (x0,x1,x2) => x0.setAttribute(x1,x2),
      zM: x0 => x0.repetitionCount,
      zN: (x0,x1,x2) => x0.put(x1,x2),
      zO: (x0,x1) => { x0.height = x1 },
      zP: (x0,x1) => x0.end(x1),
      zQ: (x0,x1) => { x0.src = x1 },
      zR: x0 => x0.rawBytes,
      zS: x0 => x0.nonce,
      zT: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7,recaptchaSiteKey: x8}),
      zU: x0 => x0.phoneNumber,
      zV: (x0,x1) => { x0.ondrop = x1 },

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
