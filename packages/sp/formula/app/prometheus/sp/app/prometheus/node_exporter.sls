include:
  - sp.app.prometheus.user


{% from "sp/app/prometheus/map.jinja" import prometheus with context %}
{% set arch = prometheus.node_exporter.arch %}
{% set sha256 = prometheus.node_exporter.sha256 %}
{% set version = prometheus.node_exporter.version %}

{% set rel_name = 'node_exporter-' + version + '.' + arch %}
{% set rel_url = 'https://github.com/prometheus/node_exporter/releases' %}


sp-app-prometheus-node-bin:
  archive.extracted:
    - name: '/opt/prometheus'
    - source: '{{ rel_url }}/download/v{{ version }}/{{ rel_name }}.tar.gz'
    - source_hash: 'sha256={{ sha256 }}'

    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0755'

    - require:
      - user: sp-prometheus-user


{% set node_exporter = salt['pillar.get']('sp:prometheus:node-exporter', {}) %}
{% set collectors = ','.join(node_exporter.get('collecors', [])) %}
sp-app-prometheus-node-run:
  file.managed:
    - name: '/opt/prometheus/run-node-exporter'
    - group: 'prometheus'
    - user:  'prometheus'
    - mode:  '0755'

    - contents: |
        #!/bin/bash
        /opt/prometheus/{{ rel_name }}/node_exporter \
          {% if collectors -%}
          --collectors.enabled {{ collectors }} \
          {% endif -%}
          --log.level info

    - require:
      - archive: sp-app-prometheus-node-bin
      - user: sp-prometheus-user


sp-app-prometheus-node-service-unit:
  file.managed:
    - name: /etc/systemd/system/prometheus-node-exporter.service
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=prometheus node exporter
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory=/opt/prometheus
        User=prometheus
        Group=prometheus
        ExecStart=/opt/prometheus/run-node-exporter

        [Install]
        WantedBy=multi-user.target

    - require:
      - archive: sp-app-prometheus-node-bin
      - file: sp-app-prometheus-node-run

sp-app-prometheus-node-service:
  service.running:
    - name: prometheus-node-exporter
    - enable: True

    - require:
      - file: sp-app-prometheus-node-service-unit

    - watch:
      - archive: sp-app-prometheus-node-bin
      - file: sp-app-prometheus-node-run
      - file: sp-app-prometheus-node-service-unit
