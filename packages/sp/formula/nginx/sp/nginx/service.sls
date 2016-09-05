sp-nginx-service:
  service.running:
    - name: nginx
    - enable: True

    - require:
      - pkg: sp-nginx-install
    - watch:
      - pkg:  sp-nginx-install
      - file: sp-nginx-default-site
