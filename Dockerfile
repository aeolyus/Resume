FROM oblique/archlinux-yay

RUN sudo -u aur yay -Syu --noconfirm
RUN sudo -u aur yay -S --noconfirm \
      texlive-core texlive-latexextra \
      ttf-poppins ttf-font-awesome

CMD ["/bin/bash"]
