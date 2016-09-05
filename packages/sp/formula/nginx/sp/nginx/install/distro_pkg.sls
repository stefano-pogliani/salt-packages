{% from "sp/nginx/map.jinja" import sp_nginx with context %}
sp-nginx-install:
  pkg.installed:
    - name: {{ sp_nginx.lookup.package }}
    {% if sp_nginx.pkg_version %}
    - version: {{ sp_nginx.pkg_version }}
    {% endif %}
