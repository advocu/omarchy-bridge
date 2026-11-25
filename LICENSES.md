> Omarchy plugin: the whole game ships inside game/index.html (code, the Nunito font and the two music tracks below, byte-identical, as data URIs).

# Licences for shipped non-code assets

Bridge ships no image assets. Everything visual is drawn in code (Canvas 2D, SVG strings built in TypeScript, CSS);
the mobile build's home-screen icons and launch images are rendered from that code at build time (see the last section).
The only non-code assets are fonts and two recorded music tracks (each as Ogg Opus plus an MP3 fallback). Two more
music pieces are generated in code (`src/audio/music.ts`), so they are not assets.

## Music (`public/audio/music/`)

Every licence below was checked on the source page on 2026-09-29 (IST). Each page's "License(s)" field reads
exactly **`CC0`** and links to `http://creativecommons.org/publicdomain/zero/1.0/` (Creative Commons CC0 1.0
Universal Public Domain Dedication). The author notes are quoted as shown on the page.

| File | Title | Author | Licence (as shown) | Source page | sha256 |
|---|---|---|---|---|---|
| `jazz-improv-looped.mp3` | jazz improvisation looped | Pro Sensory (Alex McCulloch) | CC0 | https://opengameart.org/content/jazz-improvisation-looped | `0e5cf555963479c60713a5640257fc6d65a272fad3a02113ab6a700e730ad447` |
| `jazz-improv-looped.ogg` | (the same, Opus transcode) | Pro Sensory (Alex McCulloch) | CC0 | https://opengameart.org/content/jazz-improvisation-looped | `65289bc6612ad9a9b731a9e7778be286d9444cdc5d8fb660410b9ae571f6ddfd` |
| `jazzy-blues.mp3` | Jazzy blues | LushoGames | CC0 | https://opengameart.org/content/jazzy-blues | `9e410244ba3bf767b57a97564a3886fada87661ec51346329f0c2b3435fe9858` |
| `jazzy-blues.ogg` | (the same, Opus transcode) | LushoGames | CC0 | https://opengameart.org/content/jazzy-blues | `ef368ea362a351e782e078f21cb97fc4f4a267e95187cfa95ed3c1535caefeac` |

Notes, per track:
- **jazz improvisation looped.** Page text: "all my music is public domain. I wrote this piece in one take then I looped
  it. please include my name in your projects credits, Alex McCulloch." Credit: **Music: "jazz improvisation looped"
  by Alex McCulloch (Pro Sensory), CC0.** Downloaded `https://opengameart.org/sites/default/files/jazz_improv_looped_2.mp3`
  (3,168,468 bytes, 2:12, 192 kb/s); the `.mp3` is unmodified.
- **Jazzy blues.** Page text: "Recorded in 2009." Downloaded `https://opengameart.org/sites/default/files/blues_0.mp3`
  (2,103,507 bytes, 0:53, 320 kb/s); the `.mp3` is unmodified.
- The `.ogg` files (Ogg Opus, 112 kb/s VBR) are transcodes of the `.mp3`s with ffmpeg (libopus) and one change: a
  fixed gain (−2.3 dB and −2.6 dB) that brings each to −18.0 LUFS integrated (EBU R128, ffmpeg `ebur128`), true
  peak −3.1 and −2.7 dBFS. The player uses the `.ogg` and falls back to the `.mp3` with the same gain applied at
  playback (`manifest.json` `fallbackGainDb`).
- Credits line: Music by Alex McCulloch (Pro Sensory) and LushoGames, CC0 via OpenGameArt.org; two pieces generated
  in code by Bridge.
- The generated pieces ("Late Room" and "Blue Felt") are rendered by `src/audio/music.ts` from its own code (Web Audio
  oscillators, filters and seeded noise). If this folder is missing or every file fails to load, the generated
  pieces play on their own, and without OfflineAudioContext a live generative lounge plays, so the table is never
  silent.

## Fonts

- Nunito 700/800/900 latin (via `@fontsource/nunito`), SIL Open Font License 1.1. Bundled `.woff2`/`.woff` only.
- Playfair Display Black (static 900, version 1.203; Claus Eggers Sørensen; "Copyright 2017 The Playfair Display Project
  Authors (https://github.com/clauseggers/Playfair-Display), with Reserved Font Name "Playfair Display""), SIL Open Font
  License 1.1. The display face of the Steam and phone builds (look.md v4.17 §20.4), bundled **unmodified** (not subset,
  not renamed) as a data URI from `src/fonts/playfair/PlayfairDisplay-Black.ttf` (the copy in
  `crew/cinematic/fonts/playfair/`), with its licence in `src/fonts/playfair/OFL.txt` and shipped next to the Steam game
  as `assets/fonts/OFL-PlayfairDisplay.txt`. Lining figures come from the font's own `lnum` feature, switched on when the
  face is registered; the mock-only `ClubDisplayMock` is never shipped. Shrikhand is no longer bundled.


## Code bundled in game/index.html

Bridge's own code is proprietary: Copyright (C) 2026 Suyash Verma. All rights reserved. (LICENSE). The bundle also contains these libraries, all MIT, which permits use in closed-source software (checked 2026-10-26 against each package's package.json in node_modules):

| Package | Version | Licence |
|---|---|---|
| react | 18.3.1 | MIT, Copyright (c) Facebook, Inc. and its affiliates |
| react-dom | 18.3.1 | MIT, Copyright (c) Facebook, Inc. and its affiliates |
| scheduler | 0.23.2 (react-dom dependency) | MIT, Copyright (c) Facebook, Inc. and its affiliates |

The MIT licence text: Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The
above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

The Nunito font (SIL OFL 1.1) is embedded as a separate font resource, which the OFL allows when bundled with
software; it is not relicensed. Playfair Display Black (static 900, Version 1.203; "Copyright 2017 The Playfair Display
Project Authors (https://github.com/clauseggers/Playfair-Display), with Reserved Font Name "Playfair Display"") is
embedded the same way, unmodified, under the SIL Open Font License 1.1, with its full text in `OFL-PlayfairDisplay.txt`;
it is not relicensed. The music is CC0 (public domain dedication).
