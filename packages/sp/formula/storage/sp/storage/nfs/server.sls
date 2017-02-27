include:
  - sp.storage.mounts
  - sp.storage.nfs.users


sp-nfs-datadir:
  file.directory:
    - name:  '/data/nfs'
    - user:  'root'
    - group: 'root'
    - mode:  '0755'

    - require:
      - mount: 'sp-mount-/data'


sp-nfs-packages:
  pkg.installed:
    - names:
      - nfs-common
      - nfs-kernel-server


{% set exports = salt['pillar.get']('sp:nfs:exports', []) %}
{% for export in exports %}
sp-nfs-export-{{ export.name }}:
  file.directory:
    - name:  '/data/nfs/{{ export.name }}'
    {% if export.user %}
    - user: 'nfs_{{ export.user }}'
    {% endif %}
    {% if export.group %}
    - group: 'nfs_{{ export.group }}'
    {% endif %}
    - mode: {{ export.mode|default('0755') }}

    {% if export.user or export.group %}
    - require:
      {% if export.group %}
      - group: sp-nfs-group-{{ export.group }}
      {% endif %}
      {% if export.user %}
      - user:  sp-nfs-user-{{ export.user }}
      {% endif %}
    {% endif %}

    - require_in:
      - file: sp-nfs-exports-file
{% endfor %}


sp-nfs-exports-file:
  file.managed:
    - name:   '/etc/exports'
    - source: 'salt://sp/storage/nfs/files/exports'
    - group:  'root'
    - user:   'root'
    - mode:   '0755'

    - template: jinja
    - context:
        exports: {{ exports }}


sp-nfs-service-portmapper:
  service.running:
    - name: rpcbind
    - enable: true
    - require:
      - pkg:  sp-nfs-packages
      - file: sp-nfs-exports-file

sp-nfs-service-nfs:
  service.running:
    - name: nfs-kernel-server
    - enable: true
    - require:
      - pkg:  sp-nfs-packages
      - file: sp-nfs-exports-file
      - service: sp-nfs-service-portmapper
