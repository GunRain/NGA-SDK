import {
	DocsBody,
	DocsDescription,
	DocsPage,
	DocsTitle,
	PageLastUpdate
} from 'fumadocs-ui/layouts/docs/page'
import {createRelativeLink} from 'fumadocs-ui/mdx'
import type {Metadata} from 'next'
import Link from 'next/link'
import {notFound} from 'next/navigation'

import {LLMCopyButton, ViewOptions} from '@/components/ai/page-actions'
import {getPageImage} from '@/lib/gen/img'
import {docsConfig, source} from '@/lib/source'
import {getMDXComponents} from '@/mdx-components'

const BUILD_TIME = new Date().toLocaleString('zh-CN', {
	year: 'numeric',
	month: '2-digit',
	day: '2-digit'
})

export default async function Page(props: PageProps<'/[[...slug]]'>) {
	const {slug} = await props.params
	const page = source.getPage(slug)
	if (!page) notFound()

	const MDX = page.data.body

	return (
		<DocsPage
			toc={page.data.toc}
			full={page.data.full}
			footer={{
				enabled: true,
				component: (
					<footer className='mt-16 border-t text-fd-muted-foreground'>
						{page.data.lastModified && (
							<div className='px-6 pt-8 text-xs italic border-b-0'>
								<PageLastUpdate date={page.data.lastModified} />
							</div>
						)}
						<div className='flex flex-wrap gap-x-10 gap-y-12 px-6 py-12 text-sm'>
							{[
								...docsConfig.footer.links,
								{
									title: 'LLMs',
									items: [
										{
											label: 'llms.txt',
											href: '/llms.txt'
										},
										{
											label: 'llms-full.txt',
											href: '/llms-full.txt'
										}
									]
								}
							].map(group => (
								<div
									key={group.title}
									className='flex-1 min-w-[150px] flex flex-col gap-3'>
									<h4 className='font-semibold text-fd-foreground'>{group.title}</h4>
									<ul className='space-y-2'>
										{group.items.map(item => (
											<li key={item.label}>
												<Link
													href={item.href}
													target='_blank'
													className='hover:text-fd-primary transition-colors'>
													{item.label}
												</Link>
											</li>
										))}
									</ul>
								</div>
							))}
						</div>
						<div className='border-t' />
						<div className='px-6 py-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs'>
							<p>{docsConfig.footer.copyright}</p>
							<p className='opacity-70'>
								Build Time: <span className='font-mono'>{BUILD_TIME}</span>
							</p>
						</div>
					</footer>
				)
			}}>
			<DocsTitle>{page.data.title}</DocsTitle>
			<DocsDescription className='mb-0'>{page.data.description}</DocsDescription>
			{!page.data['go-import'] && !page.data['go-source'] && (
				<div className='flex flex-row gap-2 items-center border-b pb-6'>
					<LLMCopyButton markdownUrl={`${page.url === '/' ? '/index' : page.url}.md`} />
					<ViewOptions
						markdownUrl={`${page.url === '/' ? '/index' : page.url}.md`}
						githubUrl={`https://github.com/${docsConfig.git.user}/${docsConfig.git.repo}/blob/${docsConfig.git.branch}/${docsConfig.git.dir}/content/${page.path}`}
					/>
				</div>
			)}
			<DocsBody>
				<MDX components={getMDXComponents({a: createRelativeLink(source, page)})} />
			</DocsBody>
		</DocsPage>
	)
}

export const generateStaticParams = async () => source.generateParams()

export async function generateMetadata(props: PageProps<'/[[...slug]]'>) {
	const {slug} = await props.params
	const page = source.getPage(slug)
	if (!page) notFound()

	const isGoPkg = page.data['go-import'] || page.data['go-source']
	const isIndex = page.url === '/'

	const titleConfig = isIndex
		? {absolute: docsConfig.title}
		: isGoPkg
			? {absolute: page.data.title}
			: page.data.title

	return {
		alternates: {canonical: page.url || '/'},
		title: titleConfig,
		description: page.data.description,
		keywords: page.data.keywords,
		openGraph: {
			title: titleConfig,
			description: page.data.description,
			url: `${docsConfig.baseUrl}${page.url}`,
			images: getPageImage(page).url
		},
		twitter: {
			title: titleConfig,
			description: page.data.description,
			images: getPageImage(page).url
		},
		other: {
			...(page.data['go-import'] && {'go-import': page.data['go-import']}),
			...(page.data['go-source'] && {'go-source': page.data['go-source']})
		},
		...(isGoPkg && {
			robots: {
				index: false,
				follow: false,
				googleBot: {
					index: false,
					follow: false
				}
			}
		})
	} satisfies Metadata
}
