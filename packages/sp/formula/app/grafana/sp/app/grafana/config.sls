include:
  - sp.app.grafana.install


sp-grafana-config:
  file.managed:
    - name: '/etc/grafana/grafana.ini'
    - source: 'salt://sp/app/grafana/files/grafana.ini'
    - group: 'grafana'
    - user:  'grafana'
    - mode:  '0644'

    - require:
      - pkg: sp-grafana-pkg

    - require_in:
      - service: sp-grafana-service
    - watch_in:
      - service: sp-grafana-service
