{% from "redis/map.jinja" import redis_settings with context %}
{% set cfg_name   = redis_settings.cfg_name -%}
{% set pkg_name   = redis_settings.pkg_name -%}
{% set svc_name   = redis_settings.svc_name -%}
{% set svc_state  = redis_settings.svc_state -%}
{% set svc_onboot = redis_settings.svc_onboot -%}

include:
  - redis.common
  - sp.apt.hidden_testing


# Make sure redis packages are from the testing repo.
redis-from-testing:
  sp_apt.packages_from:
    - name: 'redis-server'
    - packages: 'redis-*'
    - release:  'testing'

    - require:
      - sls: sp.apt.hidden_testing

    # Make sure this is done before redis is installed.
    - require_in:
      - pkg: {{ pkg_name }}


redis-refresh-apt-cache:
  cmd.wait:
    - name: 'apt-get update'
    - watch:
      - sp_apt: redis-from-testing

    # Make sure this is done before redis is installed.
    - require_in:
      - pkg: {{ pkg_name }}


# Redis configuration and service
redis-config:
  file.managed:
    - name: {{ cfg_name }}
    - template: jinja
    - source: salt://sp/redis/files/config.jinja
    - require:
      - pkg: {{ pkg_name }}

redis-service:
  service.{{ svc_state }}:
    - name: {{ svc_name }}
    - enable: {{ svc_onboot }}
    - watch:
      - file: {{ cfg_name }}
    - require:
      - pkg: {{ pkg_name }}
