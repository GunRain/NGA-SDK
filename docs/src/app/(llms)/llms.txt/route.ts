import {NextResponse} from 'next/server'

import {docsConfig, source} from '@/lib/source'

export const revalidate = false

export const GET = async () =>
	new NextResponse(
		`# [${docsConfig.title}](${docsConfig.baseUrl})\n\n## Pages\n\n` +
			source
				.getPages()
				.filter(page => !page.data['go-import'] && !page.data['go-source'])
				.map(
					page =>
						`- [**${page.data.title}**](${docsConfig.baseUrl}${page.url === '/' ? '/index' : page.url}.md)${page.data.description ? `: ${page.data.description}` : ''}`
				)
				.join('\n') +
			`\n\n---\n\n> [**Full Content**](${docsConfig.baseUrl}/llms-full.txt): All pages in single file`,
		{headers: {'Content-Type': 'text/markdown; charset=utf-8'}}
	)
