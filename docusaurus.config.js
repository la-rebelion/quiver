// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Quiver by La Rebelion',
  tagline: 'The arrows to be more productive as a dev or sysadmin',
  url: 'https://quiver.rebelion.la/',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  trailingSlash: false,

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'la-rebelion', // Usually your GitHub org/user name.
  projectName: 'quiver', // Usually your repo name.
  // git@github.com:la-rebelion/quiver.git      <-- your ssh URI
  //                   |          |
  //           organizationName  projectName

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'es'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/', // Serve the docs at the site's root
          sidebarPath: require.resolve('./sidebars.js'),
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
        gtag: {
          trackingID: 'G-SWE8807L5G',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      metadata: [{name: 'keywords', content: 'kubernetes, helm, docker, cloud'}],
      navbar: {
        title: 'Quiver',
        logo: {
          alt: 'La Rebelion Logo',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'doc',
            docId: 'intro',
            position: 'left',
            label: 'Scripts',
          },
          {to: 'https://rebelion.la', label: 'Blog', position: 'left'},
          {
            href: 'https://github.com/la-rebelion/quiver',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Scripts',
                to: '/',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Stack Overflow',
                href: 'https://stackoverflow.com/questions/tagged/kubernetes',
              },
              {
                label: 'Twitter',
                href: 'https://twitter.com/LaRebelionLabs',
              },
              {
                label: 'Website',
                href: 'https://rebelion.la',
              }
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Blog',
                href: 'https://rebelion.la',
              },
              {
                label: 'GitHub',
                href: 'https://github.com/la-rebelion/quiver',
              },
              {
                label: 'License',
                href: 'http://creativecommons.org/licenses/by-sa/4.0/'
              }
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} La Rebelion Labs.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;
