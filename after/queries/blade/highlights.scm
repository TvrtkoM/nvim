; The blade grammar embeds HTML nodes but its bundled highlights query relies on
; a `; inherits: html` modeline to color tags/attributes. The parser installer
; STRIPS that modeline on download, so tags render flat. Re-add it here.
; `; extends` appends (rather than replaces) the installed query.
; extends
; inherits: html
