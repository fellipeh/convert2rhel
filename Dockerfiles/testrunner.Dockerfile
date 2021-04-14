FROM tmaier/docker-compose:19.03 as base

RUN apk update && apk upgrade

WORKDIR /convert2rhel

FROM base as env-builder-base

RUN apk add \
    # general convinience deps
    curl \
    git \
    make \
    vim \
    rsync \
    # libvirt deps
    libvirt-daemon \
    qemu-img \
    qemu-system-x86_64 \
    qemu-modules \
    virt-install

COPY tests/integration/.ssh/id_ed25519 /root/.ssh/id_ed25519
RUN chmod 600 /root/.ssh/id_ed25519


FROM env-builder-base as tmt-pytest-framework-builder
RUN pip install git+https://github.com/ZhukovGreen/tmt.git@poc/tmt-adoption-for-convert2rhel
RUN pip install ansible==3.2.0
COPY . .
