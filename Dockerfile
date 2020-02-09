FROM archlinux:20200205

RUN pacman -Sy
RUN pacman -S --needed --noconfirm pacman-contrib

# Update mirrors
RUN curl -s \
"https://www.archlinux.org/mirrorlist/?\
country=BE&country=DK&country=FI&country=FR&country=DE&country=IS&country=IE\
&country=IT&country=LU&country=NL&country=NO&country=RO&country=ES&country=SE\
&country=CH&protocol=https&use_mirror_status=on" \
| sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - \
> /etc/pacman.d/mirrorlist

RUN pacman -S --needed --noconfirm archlinux-keyring
RUN pacman -S --needed --noconfirm sudo
RUN pacman -S --needed --noconfirm base-devel

# Clean up cache packages to free up space
RUN pacman -Scc --noconfirm

RUN useradd -m builder && \
  echo 'builder ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/makepkg

RUN printf "PKGDEST=/builds/output\n" >> /etc/makepkg.conf
RUN printf 'PACKAGER="Sighery <sighery@sighery.com>"\n' >> /etc/makepkg.conf

RUN mkdir -p /builds/output
RUN chmod -R 777 /builds
WORKDIR /builds

USER builder

CMD ["/bin/bash"]
