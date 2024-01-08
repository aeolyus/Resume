FROM archlinux

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
  cmake git base base-devel cargo

# Create non-root user, required for makepkg
WORKDIR /tmp
RUN useradd dev -G wheel --create-home
RUN sed -Ei 's/^#\ (%wheel.*NOPASSWD.*)/\1/' /etc/sudoers
USER dev

# Install paru
RUN git clone https://aur.archlinux.org/paru.git
WORKDIR /tmp/paru
RUN makepkg -si --noconfirm

# Install latex and deps
RUN paru -S --noconfirm \
  texlive-core texlive-latexextra \
  ttf-poppins ttf-font-awesome

CMD ["/bin/bash"]
