{% from "sp/nginx/map.jinja" import sp_nginx with context %}

# Install NGINX
include:
  - sp.nginx

# Create SPM repo host.
sp-spm-dir:
  file.directory:
    - name: /data/www/spm
    - group: "{{ sp_nginx.lookup.group }}"
    - user:  "{{ sp_nginx.lookup.user }}"
    - mode:  755
    - makedirs: True

sp-spm-repo-dir:
  file.directory:
    - name: /data/www/spm/repo
    - group: "{{ sp_nginx.lookup.group }}"
    - user:  "{{ sp_nginx.lookup.user }}"
    - mode:  755
    - require:
      - file: sp-spm-dir

sp-spm-repo-vhost:
  sp_nginx_vhost.present:
    - name: spm-repo
    - source: salt://sp/spm/repo/files/nginx.conf
    - require:
      - file: sp-spm-dir
      - file: sp-spm-repo-dir
    - watch_in:
      - service: sp-nginx-service

# Check that SPM is installed.
sp-spm-check-install:
  test.fail_without_changes:
    - unless: 'spm --version'

# Create SPM repo in /data/www/spm/repo
sp-spm-create-repo:
  cmd.run:
    - name: "spm create_repo /data/www/spm/repo"
    - creates: /data/www/spm/repo/SPM-METADATA
