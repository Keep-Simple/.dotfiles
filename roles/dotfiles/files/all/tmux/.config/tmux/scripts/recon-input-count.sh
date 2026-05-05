#!/usr/bin/env bash
# Count recon sessions awaiting user input. Print "⏸N " when N>0, else nothing.
n=$(recon json 2>/dev/null | jq -r '[.sessions[]?|select(.status=="Input")]|length // 0' 2>/dev/null)
[ "${n:-0}" -gt 0 ] && printf '#[fg=#fab387]⏸%s #[default]' "$n"
