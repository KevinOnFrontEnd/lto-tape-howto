# LTO Tape

This repository contains information that i found useful while setting up and creating LTO tapes.

## Linux
### Writing Tapes

```tar czvf /dev/st0 /home/database```

- c creates new tar archive.
- z compresses archive
- v verbose mode.
- /dev/st0 is the tape device
- /home/database is the directory that is being backed up to tape.

### Reading Tapes

### Troubleshooting
```dmesg | grep st```

```lspci```

## Windows

[Iperius](https://www.iperiusbackup.co.uk/)

### Troubleshooting
[xTalk Management Console](https://www.quantum.com/en/service-support/downloads-and-firmware/sage/)