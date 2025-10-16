# Placeholder Image

This directory should contain your teardown images.

For the sample teardown to display properly, you can either:

1. Add a file named `placeholder-monitor.jpg` here
2. Remove the `heroImage` field from `src/data/teardowns/dell-u2415-monitor.md`

## Image Guidelines

- Format: JPG, PNG, WebP
- Recommended size: 1200x675px (16:9 ratio)
- Max file size: 2MB for web performance
- EXIF metadata: Strip before upload for privacy

## Adding Images

```bash
# From your Mac terminal:
cp ~/path/to/your/image.jpg public/images/
```

Then reference in markdown frontmatter:
```yaml
heroImage: /images/image.jpg
```
