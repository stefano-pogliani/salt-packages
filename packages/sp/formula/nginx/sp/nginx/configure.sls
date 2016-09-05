# Configuration of the NGINX system.
{% from "sp/nginx/map.jinja" import sp_nginx with context %}


# Remove defaults if not desired.
{% if not sp_nginx.keep_default %}
sp-nginx-default-site:
  file.absent:
    - name: "{{ sp_nginx.conf_path }}/default.conf"
    - require:
      - pkg: sp-nginx-install
{% endif %}
