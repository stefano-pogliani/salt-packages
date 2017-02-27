include:
  - sp.app.prometheus.user


{% from "sp/app/prometheus/map.jinja" import prometheus with context %}
{% set arch = prometheus.server.arch %}
{% set sha256 = prometheus.server.sha256 %}
{% set version = prometheus.server.version %}

{% set rel_name = 'prometheus-' + version + '.' + arch %}
{% set rel_url = 'https://github.com/prometheus/prometheus/releases' %}


sp-app-prometheus-bin:
  archive.extracted:
    - name: '/opt/prometheus'
    - source: '{{ rel_url }}/download/v{{ version }}/{{ rel_name }}.tar.gz'
    - source_hash: 'sha256={{ sha256 }}'

    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0755'

    - require:
      - user: sp-prometheus-user


sp-app-prometheus-dir:
  file.directory:
    - name: '/data/prometheus'
    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0750'

sp-app-prometheus-dir-db:
  file.directory:
    - name: '/data/prometheus/db'
    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0750'

    - require:
      - file: sp-app-prometheus-dir


sp-app-prometheus-config:
  file.managed:
    - name:   '/opt/prometheus/config/prometheus.yaml'
    - source: 'salt://sp/app/prometheus/files/server.yaml'
    - group:  'prometheus'
    - user:   'prometheus'
    - mode:   '0644'
    - makedirs: true
    - dir_mode: '0755'

    - template: jinja

    - require:
      - user: sp-prometheus-user


sp-app-prometheus-run:
  file.managed:
    - name: '/opt/prometheus/run-server'
    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0755'

    - contents: |
        #!/bin/bash
        /opt/prometheus/{{ rel_name }}/prometheus \
          --log.level info \
          --storage.local.memory-chunks 65536 \
          --storage.local.path '/data/prometheus/db' \
          --storage.local.retention "$(( 3 * 30 * 24 ))h" \
          --config.file '/opt/prometheus/config/prometheus.yaml'

    - require:
      - archive: sp-app-prometheus-bin
      - file: sp-app-prometheus-config
      - user: sp-prometheus-user


sp-app-prometheus-service-unit:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=prometheus
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory=/opt/prometheus
        User=prometheus
        Group=prometheus
        ExecStart=/opt/prometheus/run-server

        [Install]
        WantedBy=multi-user.target

    - require:
      - archive: sp-app-prometheus-bin
      - file: sp-app-prometheus-run

sp-app-prometheus-service:
  service.running:
    - name: prometheus
    - enable: True

    - require:
      - file: sp-app-prometheus-service-unit

    - watch:
      - archive: sp-app-prometheus-bin
      - file: sp-app-prometheus-config
      - file: sp-app-prometheus-run
      - file: sp-app-prometheus-service-unit
