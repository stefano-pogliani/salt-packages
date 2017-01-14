sp-apt-testing-source:
  pkgrepo.managed:
    - name: deb http://httpredir.debian.org/debian testing main
    - dist: testing
    - file: /etc/apt/sources.list.d/testing.list

  file.managed:
    - name: /etc/apt/preferences.d/testing-priority
    - contents: |
        Package: *
        Pin: release a=testing
        Pin-Priority: 50

  cmd.wait:
    - name: apt-get update
    - watch:
      - file: sp-apt-testing-source
