import clsx from 'clsx'
import React, {type ReactNode} from 'react'

import Card from '@site/src/components/Card'

import styles from './styles.module.css'

export type CardItem = {
	title: string
	desc?: string
	href: string
	icon?: ReactNode
	className?: string
}

export default function CardList({items, className}: {items: CardItem[]; className?: string}): ReactNode {
	return (
		<section className={clsx('row', className)}>
			{items.map((item, index) => (
				<article key={index} className={clsx(styles.cardListItem, 'col col--6')}>
					<Card
						href={item.href}
						icon={item.icon}
						title={item.title}
						desc={item.desc}
						className={item.className}
					/>
				</article>
			))}
		</section>
	)
}
