include:
  - sp.powerdns.repo


sp-powerdns:
  pkg.installed:
    - names:
      - pdns-server
      - pdns-backend-sqlite3
    - refresh_db: True
    - require:
      - sls: sp.powerdns.repo

  service.running:
    - name: pdns
    - enable: True
    - require:
      - pkg: sp-powerdns
