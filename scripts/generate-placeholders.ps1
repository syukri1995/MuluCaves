# Generate placeholder SVGs for the Mulu Caves tourism app.
# Each SVG is a labelled coloured panel — no fake photography.
param(
    [string]$OutDir = "src/main/webapp/images"
)

$palette = @(
    @{ From = '#2d6a4f'; To = '#40916c' },
    @{ From = '#1b4332'; To = '#2d6a4f' },
    @{ From = '#40916c'; To = '#95d5b2' },
    @{ From = '#081c15'; To = '#2d6a4f' },
    @{ From = '#52b788'; To = '#2d6a4f' },
    @{ From = '#3a5a40'; To = '#588157' }
)

$items = @(
    @{ Path = 'hero/hero-1.svg';        Title = 'Hero · Summit of the Pinnacles'; Sub = 'Mulu Caves, Sarawak' }
    @{ Path = 'gallery/gallery-1.svg'; Title = 'Gallery 1 / 8'; Sub = 'Sunrise over the karst' }
    @{ Path = 'gallery/gallery-2.svg'; Title = 'Gallery 2 / 8'; Sub = 'Inside Deer Cave' }
    @{ Path = 'gallery/gallery-3.svg'; Title = 'Gallery 3 / 8'; Sub = 'The canopy skywalk' }
    @{ Path = 'gallery/gallery-4.svg'; Title = 'Gallery 4 / 8'; Sub = 'River cruise at dusk' }
    @{ Path = 'gallery/gallery-5.svg'; Title = 'Gallery 5 / 8'; Sub = 'Limestone pinnacles' }
    @{ Path = 'gallery/gallery-6.svg'; Title = 'Gallery 6 / 8'; Sub = 'Bats streaming at twilight' }
    @{ Path = 'gallery/gallery-7.svg'; Title = 'Gallery 7 / 8'; Sub = 'Headhunter''s Trail' }
    @{ Path = 'gallery/gallery-8.svg'; Title = 'Gallery 8 / 8'; Sub = 'Rainforest canopy' }
    @{ Path = 'activities/activity-1.svg'; Title = 'Activity · Deer Cave';       Sub = 'One of the world''s largest cave passages' }
    @{ Path = 'activities/activity-2.svg'; Title = 'Activity · Canopy Skywalk';   Sub = '20 m above the rainforest floor' }
    @{ Path = 'activities/activity-3.svg'; Title = 'Activity · Headhunter''s Trail'; Sub = 'Jungle trek with cultural history' }
    @{ Path = 'activities/activity-4.svg'; Title = 'Activity · Night River Cruise'; Sub = 'Glide the Melinau at sunset' }
    @{ Path = 'accommodation/room-1.svg';  Title = 'Stay · Mulu Marriott Resort';     Sub = 'Full-service resort' }
    @{ Path = 'accommodation/room-2.svg';  Title = 'Stay · Royal Mulu Resort';         Sub = 'Mid-range, walkable to park HQ' }
    @{ Path = 'accommodation/room-3.svg';  Title = 'Stay · National Park Hostel';      Sub = 'Affordable dorm-style rooms' }
    @{ Path = 'accommodation/room-4.svg';  Title = 'Stay · Benarat Inn';               Sub = 'Quiet homely guesthouse' }
    @{ Path = 'team/developer.svg';        Title = 'Developer photo';                  Sub = 'Replace with your portrait' }
)

$root = Join-Path (Get-Location) $OutDir
New-Item -ItemType Directory -Force -Path $root | Out-Null

for ($i = 0; $i -lt $items.Count; $i++) {
    $item = $items[$i]
    $p = $palette[$i % $palette.Count]
    $dir = Split-Path -Parent (Join-Path $root $item.Path)
    New-Item -ItemType Directory -Force -Path $dir | Out-Null

    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" preserveAspectRatio="xMidYMid slice">
  <defs>
    <linearGradient id="g$i" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="$($p.From)"/>
      <stop offset="100%" stop-color="$($p.To)"/>
    </linearGradient>
    <pattern id="p$i" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M0 20 L20 0 L40 20 L20 40 Z" fill="rgba(255,255,255,0.04)"/>
    </pattern>
  </defs>
  <rect width="800" height="500" fill="url(#g$i)"/>
  <rect width="800" height="500" fill="url(#p$i)"/>
  <g font-family="'Inter', system-ui, sans-serif" text-anchor="middle" fill="#ffffff">
    <text x="400" y="240" font-size="34" font-weight="700">$($item.Title)</text>
    <text x="400" y="280" font-size="18" opacity="0.85">$($item.Sub)</text>
    <text x="400" y="460" font-size="12" opacity="0.5">placeholder · replace with real photo</text>
  </g>
</svg>
"@
    $fullPath = Join-Path $root $item.Path
    Set-Content -Path $fullPath -Value $svg -Encoding UTF8
}

Write-Host "Generated $($items.Count) placeholder SVGs under $root"
Get-ChildItem $root -Recurse -Filter *.svg | Sort-Object FullName | ForEach-Object {
    "  $($_.FullName.Substring($root.Length + 1))"
}