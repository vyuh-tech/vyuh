import { defineConfig } from 'vitepress';
import tailwindcss from '@tailwindcss/vite';
import legacyRoutes from './scripts/legacy-routes.json' with { type: 'json' };
import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { CARD, SITE_URL, SUBTITLE, TAGLINE, renderCard, sectionOf, type CardPage } from './og';

// Pages whose social cards are rendered at the end of the build.
const cardPages = new Map<string, CardPage>();

export default defineConfig({
  /** Per-page Open Graph and X card tags, with a card image for every page. */
  transformHead({ pageData }) {
    const slug = pageData.relativePath.replace(/\.md$/, '');
    const home = slug === 'index';
    const url = SITE_URL + '/' + slug.replace(/(^|\/)index$/, '');
    const title = home
      ? `Vyuh — ${TAGLINE.replace(/\.$/, '')}`
      : `${pageData.frontmatter.title ?? pageData.title} | Vyuh`;
    const description =
      pageData.frontmatter.description ?? pageData.description ?? SUBTITLE;
    const image = `${SITE_URL}/og/${slug}.png`;
    const alt = home
      ? `Vyuh: ${TAGLINE} ${SUBTITLE}`
      : `${pageData.frontmatter.title ?? pageData.title}${sectionOf(slug) ? `, ${sectionOf(slug)}` : ''} — Vyuh docs`;

    cardPages.set(slug, {
      slug,
      title: pageData.frontmatter.title ?? pageData.title,
      description,
    });

    return [
      ['link', { rel: 'canonical', href: url }],
      ['meta', { property: 'og:type', content: home ? 'website' : 'article' }],
      ['meta', { property: 'og:site_name', content: 'Vyuh' }],
      ['meta', { property: 'og:locale', content: 'en_US' }],
      ['meta', { property: 'og:url', content: url }],
      ['meta', { property: 'og:title', content: title }],
      ['meta', { property: 'og:description', content: description }],
      ['meta', { property: 'og:image', content: image }],
      ['meta', { property: 'og:image:type', content: 'image/png' }],
      ['meta', { property: 'og:image:width', content: String(CARD.width) }],
      ['meta', { property: 'og:image:height', content: String(CARD.height) }],
      ['meta', { property: 'og:image:alt', content: alt }],
      ['meta', { name: 'twitter:card', content: 'summary_large_image' }],
      ['meta', { name: 'twitter:site', content: '@vyuh_tech' }],
      ['meta', { name: 'twitter:title', content: title }],
      ['meta', { name: 'twitter:description', content: description }],
      ['meta', { name: 'twitter:image', content: image }],
      ['meta', { name: 'twitter:image:alt', content: alt }],
    ];
  },

  /** Renders the social card for every page into dist/og/. */
  async buildEnd(siteConfig) {
    const pages = [...cardPages.values()];
    const batch = 8;
    for (let i = 0; i < pages.length; i += batch) {
      await Promise.all(
        pages.slice(i, i + batch).map(async page => {
          const file = path.join(siteConfig.outDir, 'og', `${page.slug}.png`);
          await mkdir(path.dirname(file), { recursive: true });
          await writeFile(file, await renderCard(page));
        }),
      );
    }
    console.log(`Rendered ${pages.length} social cards.`);
  },

  vite: {
    plugins: [tailwindcss(), {
      name: 'legacy-documentation-redirects',
      configureServer(server) {
        server.middlewares.use((request, response, next) => {
          const url = new URL(request.url ?? '/', 'http://localhost');
          const route = url.pathname.replace(/\.html$/, '').replace(/\/$/, '');
          const destination = (legacyRoutes as Record<string, string>)[route];
          if (!destination) return next();
          response.writeHead(301, { Location: destination + url.search });
          response.end();
        });
      },
    }],
    server: { watch: { ignored: ['**/.vitepress/dist/**'] } },
  },

  srcExclude: ['README.md'],
  appearance: true, // Enable dark mode toggle
  cleanUrls: true,

  title: 'Vyuh',
  description: 'A modular framework to grow your Flutter app. Independent features, shared capabilities, composable apps.',
  sitemap: {
    hostname: 'https://docs.vyuh.tech',
    transformItems: items => items.filter(item => {
      const route = '/' + item.url.replace(/\.html$/, '').replace(/\/$/, '');
      return !(route in legacyRoutes);
    }),
  },
  markdown: {
    config(md) {
      const fence = md.renderer.rules.fence!;
      md.renderer.rules.fence = (tokens, index, options, env, self) => {
        if (tokens[index].info.trim() === 'mermaid') {
          const source = encodeURIComponent(tokens[index].content).replaceAll("'", '%27');
          return `<SketchDiagram source="${source}" />`;
        }
        return fence(tokens, index, options, env, self);
      };
    },
  },

  head: [
    // Google Analytics 4
    [
      'script',
      {
        async: '',
        src: 'https://www.googletagmanager.com/gtag/js?id=G-3THXBRT184',
      },
    ],
    [
      'script',
      {},
      `
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-3THXBRT184');
    `,
    ],

    // Preconnect for faster resource loading
    ['link', { rel: 'preconnect', href: 'https://fonts.googleapis.com' }],
    [
      'link',
      { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
    ],

    // Non-blocking font loading
    // DM Sans for reading; Lora for hero emphasis; Kalam for sketches.
    // JetBrains Mono: 400 only (code doesn't need variants)
    [
      'link',
      {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400&family=Kalam:wght@400&family=Lora:ital,wght@1,500&display=swap',
        media: 'print',
        onload: "this.media='all'",
      },
    ],
    // Fallback for browsers with JS disabled
    [
      'noscript',
      {},
      '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400&family=Kalam:wght@400&family=Lora:ital,wght@1,500&display=swap">',
    ],

    // Favicon
    ['link', { rel: 'icon', href: '/favicon.svg', type: 'image/svg+xml' }],

    // Open Graph and X (Twitter) tags are generated per page in transformHead.
  ],

  themeConfig: {
    logo: '/logo.svg',

    nav: [
      { text: 'Getting Started', link: '/intro/' },
      { text: 'Concepts', link: '/concepts/' },
    ],

    sidebar: {
  "/cms/": [
    {
      "text": "Core framework",
      "link": "/intro/"
    },
    {
      "text": "CMS Integration",
      "collapsed": false,
      "items": [
        {
          "text": "Overview",
          "link": "/cms/"
        },
        {
          "text": "Content Pipeline",
          "link": "/cms/content-pipeline"
        },
        {
          "text": "Content System",
          "collapsed": true,
          "items": [
            {
              "text": "Content Types",
              "link": "/cms/guides/content-types"
            },
            {
              "text": "Layouts",
              "link": "/cms/guides/layouts"
            },
            {
              "text": "Actions",
              "link": "/cms/guides/actions"
            },
            {
              "text": "Conditions",
              "link": "/cms/guides/conditions"
            },
            {
              "text": "Modifiers",
              "link": "/cms/guides/modifiers"
            },
            {
              "text": "API Content",
              "link": "/cms/guides/api-content"
            }
          ]
        },
        {
          "text": "Content Routing",
          "collapsed": true,
          "items": [
            {
              "text": "Conditional Routes",
              "link": "/cms/guides/conditional-routes"
            },
            {
              "text": "Template Routes",
              "link": "/cms/guides/template-routes"
            }
          ]
        },
        {
          "text": "Content Feature Flags",
          "link": "/cms/feature-flags"
        },
        {
          "text": "Content Route Scopes",
          "link": "/cms/scoped-di"
        },
        {
          "text": "Sanity & Authoring",
          "collapsed": true,
          "items": [
            {
              "text": "Setting Up Sanity",
              "link": "/cms/guides/setting-up-sanity"
            },
            {
              "text": "Designing Schemas",
              "link": "/cms/guides/designing-content-schemas"
            },
            {
              "text": "Content Previews",
              "link": "/cms/guides/content-previews"
            },
            {
              "text": "Live Editing",
              "link": "/cms/guides/live-content-editing"
            },
            {
              "text": "Sanity Structure Plugin",
              "link": "/cms/guides/sanity-structure-plugin"
            }
          ]
        },
        {
          "text": "Integration Scaffolding",
          "link": "/cms/scaffolding"
        }
      ]
    },
    {
      "text": "Package Guides",
      "collapsed": true,
      "items": [
        {
          "text": "vyuh-extension-content",
          "link": "/cms/packages/vyuh-extension-content"
        },
        {
          "text": "vyuh-feature-system",
          "link": "/cms/packages/vyuh-feature-system"
        },
        {
          "text": "vyuh-feature-auth",
          "link": "/cms/packages/vyuh-feature-auth"
        },
        {
          "text": "vyuh-feature-onboarding",
          "link": "/cms/packages/vyuh-feature-onboarding"
        },
        {
          "text": "vyuh-feature-developer",
          "link": "/cms/packages/vyuh-feature-developer"
        },
        {
          "text": "vyuh-widgetbook",
          "link": "/cms/packages/vyuh-widgetbook"
        },
        {
          "text": "vyuh-content-widget",
          "link": "/cms/packages/vyuh-content-widget"
        },
        {
          "text": "sanity-client",
          "link": "/cms/packages/sanity-client"
        },
        {
          "text": "flutter-sanity-portable-text",
          "link": "/cms/packages/flutter-sanity-portable-text"
        },
        {
          "text": "vyuh-plugin-content-provider-sanity",
          "link": "/cms/packages/vyuh-plugin-content-provider-sanity"
        }
      ]
    },
    {
      "text": "Packages & APIs",
      "collapsed": true,
      "items": [
        {
          "text": "All Content APIs",
          "link": "/cms/api"
        },
        {
          "text": "Content Extension",
          "link": "/cms/api/vyuh-extension-content"
        },
        {
          "text": "System Content Feature",
          "link": "/cms/api/vyuh-feature-system"
        },
        {
          "text": "Authentication Content",
          "link": "/cms/api/vyuh-feature-auth"
        },
        {
          "text": "Onboarding Content",
          "link": "/cms/api/vyuh-feature-onboarding"
        },
        {
          "text": "Developer Tools",
          "link": "/cms/api/vyuh-feature-developer"
        },
        {
          "text": "Embedded Content",
          "link": "/cms/api/vyuh-content-widget"
        },
        {
          "text": "Sanity Client",
          "link": "/cms/api/sanity-client"
        },
        {
          "text": "Portable Text",
          "link": "/cms/api/flutter-sanity-portable-text"
        },
        {
          "text": "Sanity Provider",
          "link": "/cms/api/vyuh-plugin-content-provider-sanity"
        },
        {
          "text": "Widgetbook",
          "link": "/cms/api/vyuh-widgetbook"
        },
        {
          "text": "Schema Packages",
          "link": "/cms/api/schemas"
        }
      ]
    },
    {
      "text": "Integration Examples",
      "collapsed": true,
      "items": [
        {
          "text": "Food",
          "link": "/cms/examples/food"
        },
        {
          "text": "Puzzles",
          "link": "/cms/examples/puzzles"
        },
        {
          "text": "Conference",
          "link": "/cms/examples/conference"
        },
        {
          "text": "Movies",
          "link": "/cms/examples/movies"
        },
        {
          "text": "Wonderous",
          "link": "/cms/examples/wonderous"
        }
      ]
    }
  ],
  "/": [
    {
      "text": "Getting Started",
      "collapsed": false,
      "items": [
        {
          "text": "What is Vyuh?",
          "link": "/intro/"
        },
        {
          "text": "Quick Start",
          "link": "/intro/get-started"
        },
        {
          "text": "Compose Features",
          "link": "/intro/compose-features"
        },
        {
          "text": "Project Structure",
          "link": "/intro/project-structure"
        },
        {
          "text": "CLI",
          "link": "/intro/cli"
        }
      ]
    },
    {
      "text": "Concepts",
      "collapsed": true,
      "items": [
        {
          "text": "Overview",
          "link": "/concepts/"
        },
        {
          "text": "Why Vyuh?",
          "link": "/concepts/why-vyuh"
        },
        {
          "text": "Features & Plugins",
          "link": "/concepts/features-and-plugins"
        },
        {
          "text": "Descriptors & Builders",
          "link": "/concepts/descriptors-and-builders"
        },
        {
          "text": "Startup & Lifecycle",
          "link": "/concepts/runtime-lifecycle"
        },
        {
          "text": "Performance & Correctness",
          "link": "/concepts/performance"
        },
        {
          "text": "Glossary",
          "link": "/concepts/glossary"
        },
        {
          "text": "FAQ",
          "link": "/concepts/faq"
        }
      ]
    },
    {
      "text": "Guides",
      "collapsed": true,
      "items": [
        {
          "text": "Tutorial",
          "link": "/guides/tutorial"
        },
        {
          "text": "Features",
          "collapsed": true,
          "items": [
            {
              "text": "Creating a Feature",
              "link": "/guides/creating-a-feature"
            },
            {
              "text": "Feature Descriptors",
              "link": "/guides/feature-descriptors"
            },
            {
              "text": "Designing Features",
              "link": "/guides/designing-features"
            }
          ]
        },
        {
          "text": "Lazy Features",
          "link": "/concepts/lazy-features"
        },
        {
          "text": "Routes & Navigation",
          "link": "/guides/routes-and-navigation"
        },
        {
          "text": "Plugins & State",
          "collapsed": true,
          "items": [
            {
              "text": "Using Plugins",
              "link": "/guides/using-plugins"
            },
            { "text": "Networking", "link": "/guides/capabilities/networking" },
            { "text": "Authentication", "link": "/guides/capabilities/authentication" },
            { "text": "Storage", "link": "/guides/capabilities/storage" },
            { "text": "Secure storage", "link": "/guides/capabilities/secure-storage" },
            { "text": "Analytics", "link": "/guides/capabilities/analytics" },
            { "text": "Telemetry and logging", "link": "/guides/capabilities/telemetry" },
            { "text": "Environment configuration", "link": "/guides/capabilities/environment" },
            { "text": "Dependency injection", "link": "/guides/capabilities/dependency-injection" },
            {
              "text": "Custom Plugins",
              "link": "/guides/custom-plugins"
            },
            {
              "text": "Feature Flags",
              "link": "/guides/feature-flags"
            },
            {
              "text": "State Management",
              "link": "/guides/mobx-state-management"
            }
          ]
        },
        {
          "text": "Platform",
          "collapsed": true,
          "items": [
            {
              "text": "Platform Customization",
              "link": "/guides/platform-customization"
            },
            {
              "text": "Theming",
              "link": "/guides/theming"
            },
            {
              "text": "Errors and Recovery",
              "link": "/guides/errors-and-recovery"
            },
            {
              "text": "Internationalization",
              "link": "/guides/i18n"
            },
            {
              "text": "Dependency Injection",
              "link": "/guides/scoped-di"
            },
            {
              "text": "Events",
              "link": "/guides/events"
            },
            {
              "text": "Adding Packages",
              "link": "/guides/adding-packages"
            }
          ]
        },
        {
          "text": "Best Practices",
          "link": "/guides/best-practices"
        }
      ]
    },
    {
      "text": "Framework",
      "collapsed": true,
      "items": [
        {
          "text": "Overview",
          "link": "/framework/"
        },
        {
          "text": "vyuh_core",
          "link": "/framework/vyuh-core"
        },
        {
          "text": "vyuh_cache",
          "link": "/framework/vyuh-cache"
        },
        {
          "text": "Hive Storage",
          "link": "/framework/hive-storage"
        },
        {
          "text": "Secure Storage",
          "link": "/framework/secure-storage"
        },
        {
          "text": "Preferences Storage",
          "link": "/framework/shared-preferences-storage"
        },
        {
          "text": "Console Telemetry",
          "link": "/framework/console-telemetry"
        },
        {
          "text": "Test Helpers",
          "link": "/framework/vyuh-test"
        }
      ]
    },
    {
      "text": "Examples",
      "collapsed": true,
      "items": [
        {
          "text": "Overview",
          "link": "/examples/"
        },
        {
          "text": "Shared Plugin",
          "link": "/examples/shared-plugin"
        },
        {
          "text": "Counter",
          "link": "/examples/counter"
        },
        {
          "text": "Unsplash",
          "link": "/examples/unsplash"
        }
      ]
    },
    {
      "text": "API References",
      "collapsed": true,
      "items": [
        {
          "text": "Overview",
          "link": "/api/"
        },
        {
          "text": "Core Runtime & Plugins",
          "link": "/api/vyuh-core"
        },
        {
          "text": "Cache",
          "link": "/api/vyuh-cache"
        },
        {
          "text": "Hive Storage",
          "link": "/api/vyuh-plugin-storage-hive"
        },
        {
          "text": "Secure Storage",
          "link": "/api/vyuh-plugin-storage-secure"
        },
        {
          "text": "Preferences Storage",
          "link": "/api/vyuh-plugin-storage-shared-preferences"
        },
        {
          "text": "Console Telemetry",
          "link": "/api/vyuh-plugin-telemetry-provider-console"
        },
        {
          "text": "Test Helpers",
          "link": "/api/vyuh-test"
        }
      ]
    },
    {
      "text": "CMS Integration",
      "link": "/cms/"
    }
  ]
},

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vyuh-tech/vyuh' },
      { icon: 'x', link: 'https://x.com/vyuh_tech' },
      { icon: 'linkedin', link: 'https://www.linkedin.com/company/vyuh-tech/' },
      { icon: 'youtube', link: 'https://www.youtube.com/@vyuh_tech' },
    ],

    search: {
      provider: 'local',
    },

    editLink: {
      pattern:
        'https://github.com/vyuh-tech/vyuh/edit/main/docs/:path',
    },
  },
});
