import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import satori from 'satori';
import { Resvg } from '@resvg/resvg-js';

/**
 * Social cards (Open Graph images), one per page, rendered at build time.
 *
 * Satori lays out the card with the site's own font, embedded as glyphs, and
 * resvg rasterizes it, so cards look the same locally and in CI.
 */

export const SITE_URL = 'https://docs.vyuh.tech';
export const TAGLINE = 'A modular framework to grow your Flutter app.';
export const SUBTITLE = 'Independent features, shared capabilities, composable apps.';
export const CARD = { width: 1200, height: 630 };

export interface CardPage {
  /** The page path without `.md`, e.g. `guides/events` or `index`. */
  slug: string;
  title: string;
  description: string;
}

const SECTIONS: Record<string, string> = {
  intro: 'Getting started',
  concepts: 'Concepts',
  guides: 'Guides',
  plugins: 'Plugins',
  framework: 'Framework',
  api: 'API reference',
  cms: 'CMS integration',
  examples: 'Examples',
};

const INDIGO = '#5856D6';
const INK = '#1d1c35';
const MUTED = '#5b5a75';

const require = createRequire(import.meta.url);
const font = (weight: number) =>
  readFileSync(require.resolve(`@fontsource/dm-sans/files/dm-sans-latin-${weight}-normal.woff`));

let fonts: { name: string; data: Buffer; weight: 400 | 500 | 700; style: 'normal' }[] | undefined;
const loadFonts = () =>
  (fonts ??= [
    { name: 'DM Sans', data: font(400), weight: 400, style: 'normal' },
    { name: 'DM Sans', data: font(500), weight: 500, style: 'normal' },
    { name: 'DM Sans', data: font(700), weight: 700, style: 'normal' },
  ]);

const logo = `data:image/svg+xml;base64,${readFileSync(
  new URL('../public/logo.svg', import.meta.url),
).toString('base64')}`;

/** The section label for a page, from its first path segment. */
export function sectionOf(slug: string): string | undefined {
  return SECTIONS[slug.split('/')[0]];
}

// A tiny element helper, so the layout below reads like markup.
type Node = { type: string; props: Record<string, unknown> };
const el = (type: string, style: Record<string, unknown>, ...children: unknown[]): Node => ({
  type,
  props: { style, children: children.length === 1 ? children[0] : children },
});

const ARROW = `data:image/svg+xml;base64,${Buffer.from(
  `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="22" viewBox="0 0 20 22"><path d="M10 21V3M3 9l7-7 7 7" fill="none" stroke="${INDIGO}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
).toString('base64')}`;

/** One layer of the architecture: a label and the blocks it holds. */
function layer(label: string, note: string, blocks: string[]): Node {
  return el(
    'div',
    {
      display: 'flex',
      flexDirection: 'column',
      gap: 10,
      padding: '12px 18px',
      borderRadius: 14,
      border: `2px solid ${INDIGO}`,
      backgroundColor: '#f6f6ff',
    },
    el(
      'div',
      { display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' },
      el('div', { fontSize: 22, fontWeight: 700 }, label),
      el('div', { fontSize: 16, fontWeight: 500, color: MUTED }, note),
    ),
    el(
      'div',
      { display: 'flex', gap: 10 },
      ...blocks.map(block =>
        el(
          'div',
          {
            fontSize: 17,
            fontWeight: 500,
            padding: '5px 12px',
            borderRadius: 10,
            border: '1.5px solid #c9c8f2',
            backgroundColor: '#ffffff',
          },
          block,
        ),
      ),
    ),
  );
}

const arrow = () =>
  el(
    'div',
    { display: 'flex', justifyContent: 'center' },
    { type: 'img', props: { src: ARROW, width: 16, height: 18 } },
  );

/** Site card: the tagline beside the three layers, plugins at the base. */
function homeBody(): Node {
  return el(
    'div',
    { display: 'flex', flexGrow: 1, alignItems: 'center', gap: 48, marginTop: 28, marginBottom: 20 },
    el(
      'div',
      { display: 'flex', flexDirection: 'column', gap: 24, width: 540 },
      el(
        'div',
        { fontSize: 60, fontWeight: 700, lineHeight: 1.08, letterSpacing: '-0.035em', display: 'block' },
        TAGLINE,
      ),
      el('div', { fontSize: 27, fontWeight: 400, lineHeight: 1.4, color: MUTED, display: 'block' }, SUBTITLE),
    ),
    el(
      'div',
      { display: 'flex', flexDirection: 'column', gap: 6, flexGrow: 1 },
      layer('Apps', 'compose a product', ['Customer app', 'Team app']),
      arrow(),
      layer('Features', 'own a slice', ['Catalog', 'Account', 'Checkout']),
      arrow(),
      layer('Plugins', 'share capabilities', ['Storage', 'Auth', 'Telemetry']),
    ),
  );
}

/** Page card: section, title and description. */
function pageBody(page: CardPage): Node {
  const section = sectionOf(page.slug);
  return el(
    'div',
    { display: 'flex', flexDirection: 'column', flexGrow: 1, justifyContent: 'center', gap: 22 },
    section
      ? el(
          'div',
          { fontSize: 24, fontWeight: 700, color: INDIGO, textTransform: 'uppercase', letterSpacing: '0.12em' },
          section,
        )
      : el('div', { display: 'none' }, ''),
    el(
      'div',
      {
        fontSize: page.title.length > 48 ? 58 : 70,
        fontWeight: 700,
        lineHeight: 1.08,
        letterSpacing: '-0.035em',
        maxWidth: 1000,
        display: 'block',
        lineClamp: 3,
      },
      page.title,
    ),
    page.description
      ? el(
          'div',
          { fontSize: 30, fontWeight: 400, lineHeight: 1.4, color: MUTED, maxWidth: 960, display: 'block', lineClamp: 2 },
          page.description,
        )
      : el('div', { display: 'none' }, ''),
  );
}

/** Every card: the same header and signature, with a body per kind. */
function layout(page: CardPage): Node {
  const home = page.slug === 'index';

  // The card, then an inner frame with explicit bounds for the content.
  return el(
    'div',
    {
      width: CARD.width,
      height: CARD.height,
      display: 'flex',
      position: 'relative',
      fontFamily: 'DM Sans',
      color: INK,
      backgroundColor: '#ffffff',
      backgroundImage:
        'radial-gradient(circle at 100% 0%, #ecebff 0%, rgba(236,235,255,0) 55%), radial-gradient(circle at 0% 100%, #f3f8ff 0%, rgba(243,248,255,0) 50%)',
    },
    el(
      'div',
      { position: 'absolute', top: 60, left: 72, right: 72, bottom: 56, display: 'flex', flexDirection: 'column' },
      // Logo and wordmark.
      el(
        'div',
        { display: 'flex', alignItems: 'center', gap: 18 },
        { type: 'img', props: { src: logo, width: 60, height: 60 } },
        el('div', { fontSize: 44, fontWeight: 700, letterSpacing: '-0.03em' }, 'Vyuh'),
      ),
      home ? homeBody() : pageBody(page),
      // The site address as a quiet signature on every card.
      el(
        'div',
        { display: 'flex', alignItems: 'center', gap: 14 },
        el('div', { width: 36, height: 4, borderRadius: 2, backgroundColor: INDIGO }),
        el('div', { fontSize: 22, fontWeight: 500, color: MUTED }, 'docs.vyuh.tech'),
      ),
    ),
  );
}

/** Renders the social card for [page] as a PNG. */
export async function renderCard(page: CardPage): Promise<Buffer> {
  const svg = await satori(layout(page) as never, { ...CARD, fonts: loadFonts() });
  return new Resvg(svg, { fitTo: { mode: 'width', value: CARD.width } }).render().asPng();
}
