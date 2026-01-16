import {type InferPageType} from 'fumadocs-core/source'

import {docsConfig, source} from '../source'

export const getLLMText = async (page: InferPageType<typeof source>) =>
	`# ${page.data.title}\n\n> Source: ${'<'}${docsConfig.baseUrl}${page.url}>${await page.data.getText('processed')}`
