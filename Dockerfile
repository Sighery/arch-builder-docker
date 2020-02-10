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

# Add my repo to fetch some dependencies that are AUR only which cause
# makepkg to fail
RUN pacman-key --init
RUN pacman-key --keyserver pgp.mit.edu --recv-key \
'9454 A24E 1B5E 9630 78B6  E931 7C02 D106 83AD CFB8'
RUN pacman-key --lsign-key \
'9454 A24E 1B5E 9630 78B6  E931 7C02 D106 83AD CFB8'
RUN printf \
'[sighery-archrepo]\nServer = http://archrepo.sighery.com/$arch\n' \
>> /etc/pacman.conf
RUN pacman -Syyu --needed --noconfirm

RUN mkdir -p /builds/output
RUN chmod -R 777 /builds
WORKDIR /builds

USER builder

CMD ["/bin/bash"]
