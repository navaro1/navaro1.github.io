#!/usr/bin/env bash

set -euo pipefail

bundle exec jekyll build --quiet

python3 - <<'PY'
from pathlib import Path


site = Path("_site")
home = (site / "index.html").read_text(encoding="utf-8")
article_path = site / "quantum computing" / "routing" / "quantum routing" / "quantum-async-routing-notes" / "index.html"
article = article_path.read_text(encoding="utf-8")
css = (site / "assets" / "css" / "main.css").read_text(encoding="utf-8")
javascript = (site / "assets" / "js" / "main.min.js").read_text(encoding="utf-8")


def require(name: str, condition: bool) -> None:
    if not condition:
        raise AssertionError(name)


require("CNAME contains the apex domain", (site / "CNAME").read_text(encoding="utf-8").strip() == "plewandow.ski")
require("home page uses the canonical apex URL", '<link rel="canonical" href="https://plewandow.ski/">' in home)
require("author website uses the canonical apex URL", 'href="https://plewandow.ski"' in home)
require("Inter variable font reaches the built stylesheet", "InterVariable.woff2" in css)
require("wide desktop frame reaches the built stylesheet", "max-width:1440px" in css)
require("Minimal Mistakes 4.28.1 renders the site", "Minimal Mistakes Jekyll Theme 4.28.1" in home)
require("the current theme copy button runtime is present", "Copy to clipboard" in javascript)
require("the copy button is enabled", "window.enable_copy_code_button = true" in article)
require("Mermaid 11 output receives diagram styling", "code.language-mermaid" in css)
require("MathJax 4 display equations receive overflow styling", "mjx-container[display=true]" in css)
require("MathJax 4.1.3 is available in technical articles", "mathjax@4.1.3/tex-mml-chtml.js" in article)
require("the obsolete MathJax 2 API is absent", "MathJax.Hub" not in article and "2.7.5" not in article)
require("Mermaid 11.17.2 is available in technical articles", "mermaid@11.17.2/dist/mermaid.min.js" in article)
require("Mermaid uses the current run API", "mermaid.run" in article and "window.mermaid.init(" not in article)
require("the JavaScript bundle includes jQuery 3.7.1", "Includes jQuery 3.7.1" in javascript)
require("the page does not load a second jQuery copy", "cdnjs.cloudflare.com/ajax/libs/jquery" not in home)
require("Font Awesome is pinned to 7.3.1", "@fortawesome/fontawesome-free@7.3.1" in home)
require("obsolete Universal Analytics is absent", "UA-134218317-1" not in home and "google-analytics.com" not in home)
require("the author email appears once", home.count('href="mailto:piotr.w.lewandowski@gmail.com"') == 1)
require("the X profile uses the current domain and icon", 'href="https://x.com/petlew1"' in home and "fa-square-x-twitter" in home)
require("the roman font asset reaches the built site", (site / "assets" / "fonts" / "InterVariable.woff2").is_file())
require("the italic font asset reaches the built site", (site / "assets" / "fonts" / "InterVariable-Italic.woff2").is_file())

print("site contract: 22 checks passed")
PY
