import rss from '@astrojs/rss'
import { getCollection } from 'astro:content'
import type { APIContext } from 'astro'

export async function GET(context: APIContext) {
  const teardowns = await getCollection('teardowns')

  // Sort by date, newest first
  const sortedTeardowns = teardowns.sort(
    (a, b) => b.data.pubDate.getTime() - a.data.pubDate.getTime()
  )

  return rss({
    title: 'Teardown Cafe',
    description:
      'A cafe where devices are torn down, built, and analyzed. Follow along as I document my hardware projects and experiments.',
    site: context.site || 'https://teardown.cafe',
    items: sortedTeardowns.map((teardown) => ({
      title: teardown.data.title,
      pubDate: teardown.data.pubDate,
      description: teardown.data.description,
      link: `/teardowns/${teardown.id}/`,
      categories: teardown.data.tags || [],
      customData: `<device>${teardown.data.device}</device><difficulty>${teardown.data.difficulty}</difficulty>`,
    })),
    customData: `<language>en-us</language>`,
    stylesheet: '/rss/styles.xsl',
  })
}
