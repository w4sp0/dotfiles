{#
SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- set qusal_dot = salt["pillar.get"]("qusal:dotfiles:all", default=True) -%}
{%- if salt["pillar.get"]("qusal:dotfiles:font", default=qusal_dot) -%}

{%- import "dom0/gui-user.jinja" as gui_user -%}

"{{ slsdotpath }}-copy-font-home":
  file.recurse:
    - name: {{ gui_user.gui_user_home }}/
    - source: salt://{{ slsdotpath }}/files/font/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}

"{{ slsdotpath }}-copy-font-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/font/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root

"{{ slsdotpath }}-refresh-font-cache":
  cmd.run:
    - name: fc-cache -f
    - runas: {{ gui_user.gui_user }}
    - onlyif: command -v fc-cache
    - onchanges:
      - file: "{{ slsdotpath }}-copy-font-home"

{%- else -%}

"{{ sls }}-was-disabled-by-pillar":
  test.nop

{%- endif %}
