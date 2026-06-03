<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="/rss/channel/title" /> RSS Feed</title>
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #1a1a1a;
            color: #e0e0e0;
            padding: 2rem;
            line-height: 1.6;
          }
          .feed-container {
            max-width: 800px;
            margin: 0 auto;
          }
          h1 {
            color: #4fc3f7;
            margin-bottom: 0.5rem;
          }
          .description {
            color: #9e9e9e;
            margin-bottom: 2rem;
          }
          .link {
            color: #4fc3f7;
            text-decoration: none;
          }
          .link:hover {
            text-decoration: underline;
          }
          .item {
            background-color: #2d2d2d;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 3px solid #4fc3f7;
          }
          .item-title {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
          }
          .item-meta {
            color: #9e9e9e;
            font-size: 0.875rem;
            margin-bottom: 0.75rem;
            display: flex;
            gap: 1rem;
          }
          .item-description {
            color: #bdbdbd;
          }
          .device {
            display: inline-block;
            background-color: #02884d;
            color: #e0f2f1;
            padding: 0.125rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            text-transform: uppercase;
          }
          .difficulty {
            display: inline-block;
            padding: 0.125rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            text-transform: uppercase;
          }
          .difficulty-easy {
            background-color: #2e7d32;
            color: #e8f5e9;
          }
          .difficulty-medium {
            background-color: #f57c00;
            color: #fff3e0;
          }
          .difficulty-hard {
            background-color: #c62828;
            color: #ffebee;
          }
        </style>
      </head>
      <body>
        <div class="feed-container">
          <h1>
            <a class="link" href="{/rss/channel/link}">
              <xsl:value-of select="/rss/channel/title" />
            </a>
          </h1>
          <p class="description">
            <xsl:value-of select="/rss/channel/description" />
          </p>
          <xsl:for-each select="/rss/channel/item">
            <div class="item">
              <h2 class="item-title">
                <a class="link" href="{link}">
                  <xsl:value-of select="title" />
                </a>
              </h2>
              <div class="item-meta">
                <span><xsl:value-of select="pubDate" /></span>
                <span class="device"><xsl:value-of select="device" /></span>
                <span class="difficulty">
                  <xsl:attribute name="class">
                    difficulty-<xsl:value-of select="difficulty" />
                  </xsl:attribute>
                  <xsl:value-of select="difficulty" />
                </span>
              </div>
              <p class="item-description">
                <xsl:value-of select="description" />
              </p>
            </div>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
