// Generates PWA icons from scripts/icon.svg into public/.
// Run: node scripts/generate-icons.mjs
import sharp from 'sharp'
import { readFileSync, mkdirSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root = join(__dirname, '..')
const svg = readFileSync(join(__dirname, 'icon.svg'))
const outDir = join(root, 'public', 'icons')
mkdirSync(outDir, { recursive: true })

const targets = [
  { file: 'icon-192.png', size: 192 },
  { file: 'icon-512.png', size: 512 },
  { file: 'apple-touch-icon.png', size: 180 }, // iOS home screen
  { file: 'maskable-512.png', size: 512 }, // manifest maskable (full-bleed bg)
]

for (const t of targets) {
  await sharp(svg, { density: 384 })
    .resize(t.size, t.size, { fit: 'cover' })
    .png()
    .toFile(join(outDir, t.file))
  console.log('wrote', join('public', 'icons', t.file))
}

// Favicon
await sharp(svg, { density: 384 }).resize(64, 64).png().toFile(join(root, 'public', 'favicon.png'))
console.log('wrote public/favicon.png')
