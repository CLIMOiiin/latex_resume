#!/bin/zsh
set -euo pipefail

cd "$(dirname "$0")/.."

INPUT_FILE="content.md"
HEADER_OUT="build/content_header.tex"
BODY_OUT="build/content_body.tex"

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Missing $INPUT_FILE"
  exit 1
fi

awk -v header_out="$HEADER_OUT" -v body_out="$BODY_OUT" '
function trim(s) {
  sub(/^[ \t]+/, "", s)
  sub(/[ \t]+$/, "", s)
  return s
}

function esc(s, t) {
  t = s
  gsub(/&/, "\\&", t)
  gsub(/%/, "\\%", t)
  gsub(/#/, "\\#", t)
  gsub(/_/, "\\_", t)
  gsub(/\$/, "\\$", t)
  gsub(/\^/, "\\textasciicircum{}", t)
  gsub(/~/, "\\textasciitilde{}", t)
  return t
}

function close_itemize() {
  if (in_itemize) {
    print "\\end{itemize}" > body_out
    in_itemize = 0
  }
}

BEGIN {
  in_itemize = 0
  name = "姓名"
  contact = "手机号 丨 邮箱 丨 城市"
  profile = "年龄 丨 专业方向 丨 求职意向"
}

{
  line = $0
  sub(/\r$/, "", line)

  if (line ~ /^name:[[:space:]]*/) {
    name = trim(substr(line, index(line, ":") + 1))
    next
  }
  if (line ~ /^contact:[[:space:]]*/) {
    contact = trim(substr(line, index(line, ":") + 1))
    next
  }
  if (line ~ /^profile:[[:space:]]*/) {
    profile = trim(substr(line, index(line, ":") + 1))
    next
  }

  if (line ~ /^##[[:space:]]+/) {
    close_itemize()
    sec = trim(substr(line, 4))
    print "" > body_out
    print "\\section{" esc(sec) "}" > body_out
    next
  }

  if (line ~ /^@entry[[:space:]]+/) {
    close_itemize()
    entry = trim(substr(line, 8))
    n = split(entry, a, /\|/)
    for (i = 1; i <= 4; i++) {
      a[i] = esc(trim(a[i]))
    }
    print "" > body_out
    print "\\cventry{" a[1] "}{" a[2] "}{" a[3] "}{" a[4] "}" > body_out
    next
  }

  if (line ~ /^@edu[[:space:]]+/) {
    close_itemize()
    entry = trim(substr(line, 6))
    n = split(entry, a, /\|/)
    for (i = 1; i <= 4; i++) {
      a[i] = esc(trim(a[i]))
    }
    print "" > body_out
    print "\\eduentry{" a[1] "}{" a[2] "}{" a[3] "}{" a[4] "}" > body_out
    next
  }

  if (line ~ /^@work[[:space:]]+/) {
    close_itemize()
    entry = trim(substr(line, 7))
    n = split(entry, a, /\|/)
    for (i = 1; i <= 4; i++) {
      a[i] = esc(trim(a[i]))
    }
    print "" > body_out
    print "\\cventry{" a[1] "}{" a[3] "}{" a[2] "}{}" > body_out
    next
  }

  if (line ~ /^@practice[[:space:]]+/) {
    close_itemize()
    entry = trim(substr(line, 10))
    n = split(entry, a, /\|/)
    for (i = 1; i <= 4; i++) {
      a[i] = esc(trim(a[i]))
    }
    print "" > body_out
    print "\\workentry{" a[1] "}{" a[2] "}{" a[3] "}{" a[4] "}" > body_out
    next
  }

  if (line ~ /^-[[:space:]]+/) {
    text = esc(trim(substr(line, 3)))
    if (!in_itemize) {
      print "\\begin{itemize}" > body_out
      in_itemize = 1
    }
    print "  \\item " text > body_out
    next
  }

  if (line ~ /^[[:space:]]*$/) {
    close_itemize()
    print "" > body_out
    next
  }

  close_itemize()

  trimmed = trim(line)
  if (trimmed ~ /^\\/) {
    print trimmed > body_out
  } else {
    print esc(line) > body_out
  }
}

END {
  close_itemize()
  print "{\\Large\\bfseries " esc(name) "}\\\\[4pt]" > header_out
  print esc(contact) "\\\\" > header_out
  print esc(profile) > header_out
}
' "$INPUT_FILE"

echo "Generated $HEADER_OUT and $BODY_OUT from $INPUT_FILE"
