// Builds the browser files that stream_video_filters loads on web into
// ../../web_files, from the versions pinned in package-lock.json. The package
// ships them as web-only assets.
//
//   npm ci && npm run build

import { build } from 'esbuild';
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const out = join(here, '..', '..', 'web_files');
const require = createRequire(import.meta.url);
const filtersDir = dirname(
  require.resolve('@stream-io/video-filters-web/package.json'),
);
const { version } = JSON.parse(
  readFileSync(join(filtersDir, 'package.json'), 'utf8'),
);

rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });

// The package and its dependencies, as one ES module with no imports.
await build({
  entryPoints: [join(filtersDir, 'dist', 'esm', 'index.js')],
  outfile: join(out, 'video_filters_web.js'),
  bundle: true,
  format: 'esm',
  target: 'es2022',
  minify: true,
  legalComments: 'eof',
  logLevel: 'info',
});

// The WebAssembly runtime and the default segmentation model the package
// ships with. Browsers without WebAssembly SIMD are not supported, so the
// no-SIMD build is left out.
for (const file of ['vision_wasm_internal.js', 'vision_wasm_internal.wasm']) {
  cpSync(
    join(filtersDir, 'mediapipe', 'wasm', file),
    join(out, 'mediapipe', 'wasm', file),
  );
}
cpSync(
  join(filtersDir, 'mediapipe', 'models', 'selfie_segmenter_landscape.tflite'),
  join(out, 'mediapipe', 'models', 'selfie_segmenter_landscape.tflite'),
);

cpSync(join(filtersDir, 'LICENSE'), join(out, 'LICENSE'));
cpSync(join(filtersDir, 'NOTICE'), join(out, 'NOTICE'));
writeFileSync(join(out, 'VERSION'), `${version}\n`);
