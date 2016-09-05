# This state installs NGINX from the requested source.
# It does not configure it or define a service for it.
{% from "sp/nginx/map.jinja" import sp_nginx with context %}

# Pick install method.
{% set install_from = sp_nginx['install_from'] %}
{% if install_from %}
include:
  - sp.nginx.install.{{ install_from }}

{% else %}
sp-nginx-nomethod:
  test.fail_without_changes:
    - name: "Install method ({{ install_from }}) is not supported."
{% endif %}
