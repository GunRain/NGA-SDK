import {loader} from 'fumadocs-core/source'
import {lucideIconsPlugin} from 'fumadocs-core/source/lucide-icons'
import {docs} from 'fumadocs-mdx:collections/server'
import {GithubInfo} from 'fumadocs-ui/components/github-info'
import type {BaseLayoutProps} from 'fumadocs-ui/layouts/shared'
import {Author} from 'next/dist/lib/metadata/types/metadata-types'
import Image from 'next/image'
import Link from 'next/link'
import {JSX} from 'react'

export const revalidate = false

export const docsConfig = {
	title: 'NGA 开发文档',
	baseUrl: 'https://app.niggergo.work',
	authors: [{name: 'ShIroRRen', url: 'https://shiror.ren'}] satisfies Author[],
	icon: {
		url: new URL('./logo.webp', import.meta.url),
		size: 32
	} satisfies {
		url: URL
		size: number | {width: number; height: number}
	},
	footer: {
		links: [
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
			}
		],
		copyright: (
			<span>
				根据{' '}
				<Link href='https://license.fileto.download/' target='_blank'>
					F2DLPR 许可证
				</Link>
				授权许可。©️ 2016-{new Date().getFullYear()}{' '}
				<Link href='https://shiror.ren/' target='_blank'>
					白彩恋
				</Link>
				，版权所有，保留一切权利。
			</span>
		)
	} satisfies {
		links: {
			title: string
			items: {
				label: string
				href: string
			}[]
		}[]
		copyright: string | JSX.Element
	},
	git: {
		user: 'ShIroRRen',
		repo: 'NGA-SDK',
		branch: 'nga',
		dir: 'docs'
	} satisfies {
		user: string
		repo: string
		branch: string
		dir?: string
	} as {
		user: string
		repo: string
		branch: string
		dir?: string
	}
}

export const docsOptions = {
	nav: {
		title: (
			<div className='flex items-center gap-2'>
				<Image
					alt='Logo'
					src={docsConfig.icon.url.href}
					width={32}
					height={32}
					className='rounded-md'
				/>
				<span className='font-semibold'>{docsConfig.title}</span>
			</div>
		)
	},
	links: [
		{
			type: 'custom' as const,
			children: <GithubInfo owner={docsConfig.git.user} repo={docsConfig.git.repo} />
		}
	],
	githubUrl: `https://github.com/${docsConfig.git.user}/${docsConfig.git.repo}`
} satisfies BaseLayoutProps as BaseLayoutProps

export const source = loader({
	baseUrl: '/',
	source: docs.toFumadocsSource(),
	plugins: [lucideIconsPlugin()]
})
