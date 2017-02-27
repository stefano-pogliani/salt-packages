include:
  - sp.powerdns


sp-powerdns-empty-sqlite:
  {% set sqlite3_db = '/data/powerdns/records.sqlite3' %}
  {% if salt['file.file_exists' ](sqlite3_db) %}
  test.nop:
    - name: 'SQLite DB already deploied'
  {% else %}
  file.managed:
    - name: {{ sqlite3_db }}
    - source: salt://sp/powerdns/files/empty.sqlite3
    - user:  pdns
    - group: pdns
    - mode:  640
    - makedirs: True
  {% endif %}
    - require_in:
      - file: sp-powerdns-sqlite


sp-powerdns-api:
  file.managed:
    - name:   /etc/powerdns/pdns.d/pdns.api.conf
    - source: salt://sp/powerdns/files/pdns.api.conf
    - user:   root
    - group:  root
    - mode:   640

    - template: jinja
    - context:
      api_key: {{ salt['pillar.get']('sp:powerdns:api_key') }}

    - watch_in:
      - service: sp-powerdns


sp-powerdns-core:
  file.managed:
    - name:   /etc/powerdns/pdns.d/pdns.core.conf
    - source: salt://sp/powerdns/files/pdns.core.conf
    - user:   root
    - group:  root
    - mode:   640

    - watch_in:
      - service: sp-powerdns


sp-powerdns-sqlite:
  file.managed:
    - name:   /etc/powerdns/pdns.d/pdns.sqlite3.conf
    - source: salt://sp/powerdns/files/pdns.sqlite3.conf
    - user:   root
    - group:  root
    - mode:   640

    - watch_in:
      - service: sp-powerdns
