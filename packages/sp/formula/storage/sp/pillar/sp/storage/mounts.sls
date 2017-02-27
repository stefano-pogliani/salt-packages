sp:
  storage:
    mounts:
      - device: /dev/vgdata/lvdata
        target: /data
        fstype: ext4
        pass_num: 2
        options:
          - defaults
          - noatime
