import { copyFileSync } from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
copyFileSync(require.resolve('@rive-app/canvas/rive.wasm'), new URL('../../public/rive.wasm', import.meta.url));
