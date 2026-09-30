#!/usr/bin/env python3
"""Build audition/index.html: a page to listen to candidate system sounds.

Reads the clips under audition/<theme>/<event>.mp3 and lays them out as a grid
of play buttons, one row per event, one column per theme.
"""

from html import escape
from pathlib import Path

ROOT = Path(__file__).parent / "audition"

THEMES = [
    ("ocean", "Ocean", "KDE Plasma's current set. CC-BY-SA 4.0 / GPL-3 / BSD."),
    ("Yaru", "Yaru", "Ubuntu's own set. CC-BY-SA 4.0 / GPL-3."),
    ("borealis", "Borealis", "Older KDE set. GPL-2+ / Artistic."),
    ("deepin", "Deepin", "From Deepin desktop. GPL-3."),
    ("freedesktop", "Freedesktop", "Generic fallback set. Mixed open licenses."),
]

EVENTS = [
    ("desktop-login", "Log in"),
    ("message-new-instant", "New message"),
    ("bell", "Alert bell"),
    ("dialog-information", "Information"),
    ("dialog-question", "Question"),
    ("dialog-warning", "Warning"),
    ("dialog-error", "Error"),
    ("complete", "Task complete"),
    ("device-added", "Device plugged in"),
    ("device-removed", "Device removed"),
    ("power-plug", "Charger connected"),
    ("power-unplug", "Charger removed"),
    ("battery-low", "Battery low"),
    ("audio-volume-change", "Volume change"),
    ("trash-empty", "Empty trash"),
]

STYLE = """
:root { color-scheme: dark; }
* { box-sizing: border-box; }
body { margin: 0; padding: 32px 16px 64px; background: #0a0a0a; color: #f2f2f2;
  font: 15px/1.5 system-ui, -apple-system, "Segoe UI", sans-serif; }
main { max-width: 1100px; margin: 0 auto; }
h1 { font-size: 26px; margin: 0 0 4px; }
h2 { font-size: 18px; margin: 40px 0 8px; }
p { color: #a6a6a6; margin: 0 0 16px; }
.wrap { overflow-x: auto; }
table { border-collapse: collapse; width: 100%; min-width: 640px; }
th, td { padding: 8px 10px; text-align: left; border-bottom: 1px solid #222; }
th { font-weight: 600; vertical-align: bottom; }
th small { display: block; font-weight: 400; color: #8c8c8c; max-width: 170px; }
td.name { color: #ddd; white-space: nowrap; }
button { background: #1f1f1f; color: #f2f2f2; border: 1px solid #3a3a3a;
  border-radius: 999px; padding: 6px 14px; font: inherit; cursor: pointer; }
button:hover { background: #2c2c2c; }
button:focus-visible { outline: 2px solid #fff; outline-offset: 2px; }
button.playing { background: #f2f2f2; color: #0a0a0a; }
.none { color: #555; }
.grid { display: flex; flex-wrap: wrap; gap: 8px; }
"""

SCRIPT = """
let current = null, currentBtn = null;
document.addEventListener('click', e => {
  const b = e.target.closest('button[data-src]');
  if (!b) return;
  if (current) { current.pause(); currentBtn.classList.remove('playing'); }
  current = new Audio(b.dataset.src);
  currentBtn = b;
  b.classList.add('playing');
  current.addEventListener('ended', () => b.classList.remove('playing'));
  current.play();
});
"""


def button(path: Path, label: str) -> str:
    rel = path.relative_to(ROOT).as_posix()
    return f'<button data-src="{escape(rel)}">{escape(label)}</button>'


def main() -> None:
    head = "".join(
        f"<th>{escape(title)}<small>{escape(note)}</small></th>"
        for _, title, note in THEMES
    )
    rows = []
    for event, label in EVENTS:
        cells = []
        for folder, _, _ in THEMES:
            clip = ROOT / folder / f"{event}.mp3"
            cells.append(
                f"<td>{button(clip, 'Play')}</td>"
                if clip.exists()
                else '<td class="none">none</td>'
            )
        rows.append(f'<tr><td class="name">{escape(label)}</td>{"".join(cells)}</tr>')

    raw = sorted((ROOT / "kenney-cc0").glob("*.mp3"))
    raw_buttons = "".join(button(p, p.stem.replace("_", " ")) for p in raw)

    html = f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Nubo OS sounds</title>
<style>{STYLE}</style>
</head>
<body>
<main>
<h1>Nubo OS system sounds</h1>
<p>Listen and pick. Each column is a complete ready-made set.</p>
<div class="wrap">
<table>
<thead><tr><th>Event</th>{head}</tr></thead>
<tbody>
{"".join(rows)}
</tbody>
</table>
</div>

<h2>Raw material for an own Nubo set</h2>
<p>Kenney Interface Sounds, CC0: no attribution, free to modify and rebrand.
Short interface clicks and tones, not mapped to events yet.</p>
<div class="grid">{raw_buttons}</div>
</main>
<script>{SCRIPT}</script>
</body>
</html>
"""
    (ROOT / "index.html").write_text(html, encoding="utf-8")
    print(f"wrote {ROOT / 'index.html'}")


if __name__ == "__main__":
    main()
