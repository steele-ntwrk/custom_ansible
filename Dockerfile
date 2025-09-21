FROM alpine/ansible:2.18.6
USER root

# System pkgs (+ pip) and build deps
RUN apk add --no-cache \
      python3 py3-pip \
      openssh-client sshpass git curl jq iputils vim less rsync ca-certificates \
      libxml2 libxslt libffi openssl nano \
    && apk add --no-cache --virtual .build-deps \
      build-base python3-dev libxml2-dev libxslt-dev libffi-dev openssl-dev

# Allow pip to write to system site-packages (Alpine enforces PEP 668)
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Python deps
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel \
 && python3 -m pip install --no-cache-dir -r /tmp/requirements.txt \
 && apk del .build-deps

# Collections
COPY galaxy-requirements.yml /tmp/galaxy-requirements.yml
RUN ansible-galaxy collection install -r /tmp/galaxy-requirements.yml -p /usr/share/ansible/collections

# Ansible cfg
RUN mkdir -p /etc/ansible /var/cache/ansible/facts
COPY ansible.cfg /etc/ansible/ansible.cfg

# (skel disabled)
COPY skel/ /opt/ansible-skel/
COPY new_project.sh /usr/local/bin/new_project.sh
RUN chmod +x /usr/local/bin/new_project.sh && ln -s /usr/local/bin/new_project.sh /usr/local/bin/new-project

RUN mkdir -p /work && chmod 0777 /work
WORKDIR /work
ENV ANSIBLE_COLLECTIONS_PATH="/etc/ansible/collections:/usr/share/ansible/collections" \
    ANSIBLE_ROLES_PATH="/etc/ansible/roles:/usr/share/ansible/roles:/work/roles" \
    PYTHONWARNINGS="ignore"

CMD ["/bin/sh","-lc","ansible --version && echo 'Skeleton disabled. Later: add skel/ + new_project.sh and uncomment.'"]
