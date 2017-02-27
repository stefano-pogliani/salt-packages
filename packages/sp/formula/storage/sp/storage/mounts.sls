{% set mounts = salt['pillar.get']('sp:storage:mounts', []) %}

{% for mount in mounts %} 
sp-mount-{{ mount.target }}:
  mount.mounted:
    - name: {{ mount.target }}
    - device: {{ mount.device }}
    - fstype: {{ mount.fstype }}
    - mkmnt:  True
    {% if mount.pass_num %}
    - pass_num: {{ mount.pass_num }}
    {% endif %}
    {% if mount.options %}
    - opts: {{ mount.options|json }}
    {% endif %}
{% endfor %}
