import clsx from 'clsx'
import React, {type ReactNode} from 'react'

import Link from '@docusaurus/Link'
import Heading from '@theme/Heading'

import styles from './styles.module.css'

export default function Card({
	className,
	href,
	icon,
	title,
	desc
}: {
	className?: string
	href: string
	icon: ReactNode
	title: string
	desc?: string
}): ReactNode {
	return (
		<Link href={href} className={clsx('card padding--lg', styles.cardContainer, className)}>
			<Heading as='h2' className={clsx('text--truncate', styles.cardTitle)} title={title}>
				{icon} {title}
			</Heading>
			{desc && (
				<p className={clsx('text--truncate', styles.cardDesc)} title={desc}>
					{desc}
				</p>
			)}
		</Link>
	)
}
