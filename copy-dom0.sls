{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
SPDX-FileCopyrightText: 2024 seven-beep <ebn@entreparentheses.xyz>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- set qusal_dot = salt["pillar.get"]("qusal:dotfiles:all", default=True) -%}
{%- if salt["pillar.get"]("qusal:dotfiles:dom0", default=qusal_dot) -%}

{%- import "dom0/gui-user.jinja" as gui_user -%}

"{{ slsdotpath }}-copy-dom0-home":
  file.recurse:
    - name: {{ gui_user.gui_user_home }}
    - source: salt://{{ slsdotpath }}/files/dom0/
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - makedirs: True

"{{ slsdotpath }}-copy-dom0-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/dom0/
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-fix-executables-dom0-bin-dir-home":
  file.directory:
    - require:
      - file: "{{ slsdotpath }}-copy-dom0-home"
    - name: {{ gui_user.gui_user_home }}/.local/bin/dom0
    - file_mode: '0755'
    - dir_mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-fix-executables-dom0-bin-dir-skel":
  file.directory:
    - require:
      - file: "{{ slsdotpath }}-copy-dom0-skel"
    - name: /etc/skel/.local/bin/dom0
    - file_mode: '0755'
    - dir_mode: '0755'
    - recurse:
      - mode

{%- else -%}

"{{ sls }}-was-disabled-by-pillar":
  test.nop

{%- endif %}
