# Configures the offical NGINX repository and then installs
# nginx from it.
{% from "sp/nginx/map.jinja" import sp_nginx with context %}

{% if grains['os'] == 'Debian' %}
sp-nginx-aptutils:
  pkg.installed:
    - name: apt-utils

sp-nginx-repo:
  pkgrepo.managed:
    - humanname: nginx
    - name: "deb http://nginx.org/packages/{{ grains['os'].lower() }}/ {{ grains['oscodename'] }} nginx"
    - file: "/etc/apt/sources.list.d/nginx-official.list"
    - keyid: ABF5BD827BD9BF62
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: sp-nginx-aptutils

sp-nginx-install:
  pkg.installed:
    - name: nginx
    - require:
      - pkgrepo: sp-nginx-repo
    - watch:
      - pkgrepo: sp-nginx-repo
    {% if sp_nginx.pkg_version %}
    - version: {{ sp_nginx.pkg_version }}
    {% endif %}

{% else %}
sp-nginx-norepo:
  test.fail_without_changes:
    - name: "Officail repository install not supported for {{ grains['os'] }}"
{% endif %}
