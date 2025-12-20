import sharp from 'sharp';
import fs from 'fs';
import path from 'path';
import { glob } from 'glob';

// Configuration
const TARGET_WIDTH = 1200; // Max width for web images
const QUALITY = 80; // WebP quality
const IMAGE_DIR = 'public/images';

async function compressImages() {
    console.log('🖼️  Starting image compression...');

    // Find all jpg/png images recursively in public/images
    // Excluding already optimized webp files to prevent double-processing if we were replacing
    // But here we want to find source files.
    const files = await glob(`${IMAGE_DIR}/**/*.{jpg,jpeg,png,webp}`);

    let processedCount = 0;
    let savedBytes = 0;

    for (const file of files) {
        const ext = path.extname(file).toLowerCase();

        // Skip if it's already a specialized webp we created (simple check: if we have a .webp version of a .jpg)
        // For this simple script, we'll process everything and output .webp versions next to originals

        // We only process if there isn't UNLESS forced.
        // For now, let's just create .webp versions for every image we find that isn't already webp
        // OR if it is webp, we ensure it's optimized.

        const dir = path.dirname(file);
        const name = path.basename(file, ext);
        const outputPath = path.join(dir, `${name}.webp`);

        // Check if optimized webp already exists and is newer
        if (fs.existsSync(outputPath)) {
            const srcStats = fs.statSync(file);
            const destStats = fs.statSync(outputPath);

            if (destStats.mtime > srcStats.mtime && destStats.size > 0) {
                // console.log(`⏩ Skipping ${file} (already optimized)`);
                continue;
            }
        }

        try {
            const image = sharp(file);
            const metadata = await image.metadata();

            let pipeline = image;

            // Resize if too large
            if (metadata.width > TARGET_WIDTH) {
                pipeline = pipeline.resize(TARGET_WIDTH, null, {
                    withoutEnlargement: true,
                    fit: 'inside'
                });
            }

            // Convert to WebP and compress
            await pipeline
                .webp({ quality: QUALITY, effort: 4 }) // Effort 0-6 (6 is slowest/best)
                .toFile(outputPath);

            const srcSize = fs.statSync(file).size;
            const destSize = fs.statSync(outputPath).size;
            const savings = srcSize - destSize;

            if (ext !== '.webp' || savings > 0) {
                processedCount++;
                savedBytes += Math.max(0, savings); // Only count positive savings
                console.log(`✅ Optimized: ${path.relative(process.cwd(), file)} -> ${path.relative(process.cwd(), outputPath)} (${(destSize / 1024).toFixed(1)}KB)`);
            }

        } catch (err) {
            console.error(`❌ Error processing ${file}:`, err);
        }
    }

    console.log(`\n🎉 Compression complete! Processed ${processedCount} images.`);
    console.log(`💾 Scraped off ${(savedBytes / 1024 / 1024).toFixed(2)} MB of data.`);
}

compressImages();
