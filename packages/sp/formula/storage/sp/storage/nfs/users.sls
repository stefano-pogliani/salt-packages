{% set base_id = salt['pillar.get']('sp:nfs:base_id', 4000) %}
{% set groups = salt['pillar.get']('sp:nfs:groups', {}) %}
{% set users = salt['pillar.get']('sp:nfs:users', {}) %}


{% for (name, group) in groups.items() %}
sp-nfs-group-{{ name }}:
  group.present:
    - name: 'nfs_{{ name }}'
    - system: false
    - gid: {{ base_id + group.id }}
{% endfor %}


{% for (name, user) in users.items() %}
sp-nfs-user-{{ name }}:
  user.present:
    - name: 'nfs_{{ name }}'
    - createhome: false
    - shell: /bin/false
    - system: false
    - uid: {{ base_id + user.id }}
    - groups:
      - 'nfs_{{ user.group }}'

    - require:
      - group: sp-nfs-group-{{ user.group }}
{% endfor %}
