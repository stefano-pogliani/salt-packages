include:
  - users


sp-utils:
  pkg.installed:
    - names:
      - vim


sp-deluser-pi:
  user.absent:
    - name: pi


{% for name, user in pillar.get('users', {}).items()
    if user.absent is not defined or not user.absent %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', '/home/%s' % name) -%}
{%- if 'prime_group' in user and 'name' in user['prime_group'] %}
{%- set user_group = user.prime_group.name -%}
{%- else -%}
{%- set user_group = name -%}
{%- endif %}
sp-users-{{ name }}-aliases:
  file.managed:
    - name: {{ home }}/.bash_aliases
    - user: {{ name }}
    - group: {{ user_group }}
    - mode: 644
    - source: 
      - salt://sp/essential/files/bash_aliases
{% endfor %}
