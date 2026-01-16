import {NextResponse} from 'next/server'

import {getLLMText} from '@/lib/gen/llms'
import {source} from '@/lib/source'

export const revalidate = false

export const GET = async () =>
	new NextResponse(
		(
			await Promise.all(
				source
					.getPages()
					.filter(page => !page.data['go-import'] && !page.data['go-source'])
					.map(getLLMText)
			)
		).join('\n\n'),
		{headers: {'Content-Type': 'text/markdown; charset=utf-8'}}
	)
