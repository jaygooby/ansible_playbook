FROM python:alpine

# call with --build-arg ansible_version=2.x to override 2.3 default
ARG ansible_version=2.3

RUN apk add --no-cache binutils  \
                       build-base \
                       curl \
                       gcc \
                       libffi-dev \
                       openssl-dev \
                       openssh-client \
                       pkgconfig && \
    pip3 install --no-cache -U ansible==$ansible_version && \
    pip3 install --no-cache -U setuptools && \
    pip3 install --no-cache -U pylint && \
    ln -s /usr/local/bin/python /usr/bin/python && \
    apk del binutils \
            build-base \
            gcc \
            libffi-dev \
            openssl-dev \
            pkgconfig

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
