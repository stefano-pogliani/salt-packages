sp-prometheus-group:
  group.present:
    - name: prometheus
    - system: True


sp-prometheus-user:
  user.present:
    - name: prometheus
    - home: /opt/prometheus
    - createhome: True
    - shell: /bin/false
    - system: True
    - groups:
      - prometheus

    - require:
      - group: sp-prometheus-group
