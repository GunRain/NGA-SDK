import {createMDX} from 'fumadocs-mdx/next'

const withMDX = createMDX()

const config = {
	output: process.env.NODE_ENV === 'production' ? 'export' : undefined,
	trailingSlash: true,
	reactStrictMode: true,
	rewrites: async () => [
		{
			source: '/:slug*.md',
			destination: '/llms.md/:slug*.md'
		}
	],
	images: {
		unoptimized: true
	}
} satisfies import('next').NextConfig

export default withMDX(config)
