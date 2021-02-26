ARG CUDAGL_TAG
FROM nvidia/cudagl:$CUDAGL_TAG

# change shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# apt install
COPY scripts/apt /build/apt
COPY scripts/add-apt-rep.sh /build/add-apt-rep.sh
RUN bash /build/add-apt-rep.sh && \
    apt update && \
    cat /build/apt | xargs apt install --allow-unauthenticated --yes && \
    apt clean

# install pyenv and using it to install 3.9 + dep
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN curl https://pyenv.run | bash && \
  pyenv install 3.6.1 && \
  pyenv global 3.6.1

# install dependencies
COPY requirements.txt /build
RUN pip install -r /build/requirements.txt

# COPY the code
COPY torchsearchsorted /workdir/torchsearchsorted
RUN cd /workdir/torchsearchsorted && \
    pip install .

# set up ipython
COPY scripts/ipython_config.py /root/.ipython/profile_default/ipython_config.py
COPY scripts/jupyter_notebook_config.py /root/.jupyter/

# set up env
ENV ROOT_DIR=/workdir
ENV PASSWORD=tf
ENV PYTHONPATH=$PYTHONPATH:/workdir

WORKDIR /workdir

CMD ["/bin/bash"]
