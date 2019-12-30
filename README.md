# Builder image based in Arch Linux

This is a Docker image, based, and pretty close to the Docker Arch Linux latest
image.

Only changes are running `pacman -Suy` to update the repositories and packages,
and installing `base-devel` and `sudo`.

`base-devel` is needed for compilation and building packages. It provides
things such as needed binaries for `makepkg`. `sudo` is needed because
`makepkg` refuses to run for the `root` user. This can be solved by patching
the corresponding code in `/usr/bin/makepkg`, but that would require constant
upkeep by my part.

Instead, this image creates a new user called `builder` and adds it to sudoers.
You can then build packages with `su - builder makepkg` in the corresponding
directory with a PKGBUILD.

**It does not contain `yay` or any other AUR helper.**

---

## Building
```bash
git clone https://github.com/Sighery/arch-builder-docker.git
cd arch-builder-docker
sudo docker build -t sighery/archbuilder:latest .
sudo docker run -it sighery/archbuilder:latest
```
