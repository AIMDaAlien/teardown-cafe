import { getCollection } from 'astro:content';

export async function GET() {
  const teardowns = await getCollection('teardowns');
  
  const deviceTypes = new Set(teardowns.map(t => t.data.device));
  const totalImages = teardowns.reduce((sum, t) => {
    // Rough estimate: count image references in markdown
    return sum + (t.body.match(/!\[.*?\]\(.*?\)/g) || []).length;
  }, 0);
  
  const latest = teardowns.sort((a, b) => 
    b.data.pubDate.getTime() - a.data.pubDate.getTime()
  )[0];
  
  return new Response(JSON.stringify({
    totalTeardowns: teardowns.length,
    totalImages: totalImages,
    deviceTypes: deviceTypes.size,
    latestEntry: {
      title: latest.data.title,
      date: latest.data.pubDate.toISOString().split('T')[0],
      slug: latest.slug
    }
  }, null, 2), {
    headers: { 'Content-Type': 'application/json' }
  });
}
