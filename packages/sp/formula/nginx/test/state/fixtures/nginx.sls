test-remove:
  sp_nginx_vhost.absent:
    - name: missing
    - watch_in:
      - service: sp-nginx-service

test-add:
  sp_nginx_vhost.present:
    - name: demo
    - source: salt://test/state/fixtures/nginx/example.conf
    - watch_in:
      - service: sp-nginx-service
