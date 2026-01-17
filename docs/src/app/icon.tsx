import {getIconImage} from '@/lib/gen/icon'
import {docsConfig} from '@/lib/source'

export const revalidate = false

export const size =
	typeof docsConfig.icon.size === 'number'
		? {width: docsConfig.icon.size, height: docsConfig.icon.size}
		: docsConfig.icon.size
export const contentType = 'image/png'

export default () => getIconImage(docsConfig.icon.url, size)
