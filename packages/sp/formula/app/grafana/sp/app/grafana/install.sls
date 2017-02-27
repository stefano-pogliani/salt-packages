sp-grafana-repo:
  pkgrepo.managed:
    - name: 'deb https://dl.bintray.com/fg2it/deb jessie main'
    - file: '/etc/apt/sources.list.d/grafana.list'
    - key_url: 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray'


sp-grafana-pkg:
  pkg.installed:
    - name: grafana
    - require:
      - pkgrepo: sp-grafana-repo


sp-grafana-service:
  service.running:
    - name: grafana-server
    - enable: true
    - require:
      - pkg: sp-grafana-pkg
    - watch:
      - pkg: sp-grafana-pkg
