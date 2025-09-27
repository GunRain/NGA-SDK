import {themes as prismThemes} from 'prism-react-renderer'

import type * as Preset from '@docusaurus/preset-classic'
import type {Config} from '@docusaurus/types'

export default {
	title: 'NGA 文档',
	tagline: '快速入门各个项目！',
	favicon: 'img/logo.ico',

	future: {v4: true},

	url: 'https://app.niggergo.work',
	baseUrl: '/',

	onBrokenLinks: 'throw',
	onBrokenMarkdownLinks: 'warn',

	i18n: {
		defaultLocale: 'zh-Hans',
		locales: ['zh-Hans']
	},

	presets: [
		[
			'classic',
			{
				docs: {sidebarPath: 'sidebars.mts'},
				blog: false
			} satisfies Preset.Options
		]
	],

	themes: [
		[
			require.resolve('@easyops-cn/docusaurus-search-local'),
			{
				hashed: true,
				language: ['zh']
			}
		]
	],

	themeConfig: {
		tableOfContents: {maxHeadingLevel: 6},
		navbar: {
			title: 'NGA 文档',
			logo: {
				alt: 'OOW Logo',
				src: 'img/logo.webp'
			},
			items: [
				{
					type: 'docSidebar',
					sidebarId: 'tutorialSidebar',
					label: '速览',
					position: 'left'
				},
				{
					href: 'https://oom-wg.dev/join',
					label: '加入我们',
					position: 'right'
				},
				{
					href: 'https://github.com/ShIroRRen/NGA-SDK',
					label: 'GitHub',
					position: 'right'
				}
			]
		},
		footer: {
			style: 'dark',
			links: [
				{
					title: '文档',
					items: [
						{
							label: '速览',
							to: '/docs/intro'
						},
						{
							label: 'NGA SDK',
							to: '/docs/nga'
						},
						{
							label: 'FVV',
							to: '/docs/fw'
						},
						{
							label: '欢律遗愉',
							to: '/docs/purejoy'
						}
					]
				},
				{
					title: '友链',
					items: [
						{
							label: 'Latest File',
							href: 'https://latestfile.zip'
						},
						{
							label: '世界之外工作组',
							href: 'https://oom-wg.dev'
						}
					]
				},
				{
					title: '更多',
					items: [
						{
							label: 'NGA - GitHub',
							href: 'https://github.com/ShIroRRen/NGA-SDK'
						},
						{
							label: 'OOM - GitHub',
							href: 'https://github.com/OOM-WG'
						},
						{
							label: 'FVV - GitHub',
							href: 'https://github.com/OOM-WG/FVV'
						}
					]
				}
			],
			copyright: `Licensed under the <a href="https://license.fileto.download/" target="_blank">F2DLPR License</a>. Copyright © 2016-${new Date().getFullYear()} <a href="https://shiror.ren/" target="_blank">ShIroRRen</a>. Built with <a href="https://docusaurus.io/zh-CN/" target="_blank" rel="noopener noreferrer">Docusaurus</a>.`
		},
		prism: {
			theme: prismThemes.github,
			darkTheme: prismThemes.dracula,
			additionalLanguages: ['dart', 'bash', 'groovy']
		}
	} satisfies Preset.ThemeConfig
} satisfies Config
