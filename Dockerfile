FROM archlinux:20191205

RUN pacman -Sy
RUN pacman -S --needed --noconfirm sudo
RUN pacman -S --needed --noconfirm base-devel

# Clean up cache packages to free up space
RUN pacman -Scc --noconfirm

RUN useradd -m builder && \
  echo 'builder ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/makepkg

RUN printf "PKGDEST=/builds/output\n" >> /etc/makepkg.conf

RUN mkdir -p /builds/output
RUN chmod -R 777 /builds
WORKDIR /builds

USER builder

CMD ["/bin/bash"]
