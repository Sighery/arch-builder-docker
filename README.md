[![Docker Automated build](https://img.shields.io/docker/cloud/automated/sighery/archbuilder?style=for-the-badge)](https://hub.docker.com/r/sighery/archbuilder)

# Builder image based in Arch Linux

This is a Docker image, based, and pretty close to the Docker Arch Linux latest
image.

Only changes are running `pacman -Sy` to update the repositories, and
installing `base-devel` and `sudo`.

`base-devel` is needed for compilation and building packages. It provides
things such as needed binaries for `makepkg`. `sudo` is needed because
`makepkg` refuses to run for the `root` user. This can be solved by patching
the corresponding code in `/usr/bin/makepkg`, but that would require constant
upkeep by my part.

Instead, this image creates a new user called `builder` and adds it to sudoers.
Then, it creates the paths `/builds/` and `/builds/output` and adds rights to
it for the `builder` user.

It also configures `makepkg` so that all built packages will be sent to
`/builds/output/`. This is useful to automatically get all the built packages
back.

**It does not contain `yay` or any other AUR helper.**

---

## Building this image
```bash
git clone https://github.com/Sighery/arch-builder-docker.git
cd arch-builder-docker
sudo docker build -t sighery/archbuilder:latest .
sudo docker run -it sighery/archbuilder:latest
```

---

## Usage example

For the sake of keeping it brief (and because you can check the wonderful Arch
Linux wiki on how to make PKGBUILD files). This is an example package:
https://gist.github.com/Sighery/636a4cb05a59e12727ab08785a1d35dd

You'd use it by running (either with sudo if you run docker with sudo, or
without) the following command:
```bash
sudo bash builder.sh
```

More info on what that script does here: https://stackoverflow.com/a/51186557

Basically it will build the image, create it, and then copy the output files
from it back into your host `./outputs/`.

Then you can install, or release your built packages. For installing:
```bash
sudo pacman -U outputs/package-name-1.0.0-1-any.pkg.tar.xz
```
