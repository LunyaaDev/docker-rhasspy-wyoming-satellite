# Rhasspy Wyoming Satellite

An all-in-one Docker image for the [wyoming-satellite](https://github.com/rhasspy/wyoming-satellite) service.

> This container uses your system’s audio input/output via ALSA. Make sure to set the correct `--mic-command` and `--snd-command` based on your hardware.

## Usage

### Selecting an Audio Input/Output Device

To find microphone devices, run:

```sh
arecord -l
```

Example output:

```
**** List of CAPTURE Hardware Devices ****
card 4: Microphone [USB Microphone], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

Find speakers, list playback devices using:

```sh
aplay -l
```

> Use the format `plughw:<card>,<device>` with both commands below.

---

### `docker-compose.yml` Example

```yaml
services:
  satellite:
    image: lunyaadev/rhasspy-wyoming-satellite
    container_name: wyoming-satellite
    restart: unless-stopped
    ports:
      - "10700:10700"
    devices:
      - /dev/snd:/dev/snd
    group_add:
      - audio
    command:
      [
        "--name", "my satellite",
        "--uri", "tcp://0.0.0.0:10700",
        "--mic-command", "arecord -D plughw:4,0 -r 16000 -c 1 -f S16_LE -t raw",
        "--snd-command", "aplay -D plughw:4,0 -r 22050 -c 1 -f S16_LE -t raw",
        "--debug",
      ]
```

> Replace `plughw:4,0` with the actual card/device numbers from your system.

### Start the Docker stack

```sh
docker compose up -d
```
