import {type InferPageType} from 'fumadocs-core/source'

import {source} from '../source'

export function getPageImage(page: InferPageType<typeof source>) {
	const segments = [...page.slugs, 'image.png']
	return {
		segments,
		url: `/og/${segments.join('/')}`
	}
}
