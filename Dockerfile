FROM archlinux:20191205

RUN pacman -Suy --needed --noconfirm
RUN pacman -S --needed --noconfirm base-devel sudo

RUN useradd -m builder && \
  echo 'builder ALL=(root) NOPASSWD:/usr/bin/pacman' > /etc/sudoers.d/makepkg

CMD ["/bin/bash"]
