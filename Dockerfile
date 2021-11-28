# Based on sample from Jupyter Stacks, Copyright (c) Jupyter Development Team which was distributed under the terms of the Modified BSD License.
ARG OWNER=omniprise
ARG SOURCE=jupyter
ARG BASE_CONTAINER=$SOURCE/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="OmniPrise <info@omniprise.com>"

USER root

# ffmpeg for matplotlib anim & dvipng+cm-super for latex labels
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends ffmpeg dvipng cm-super && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Install Python 3 packages
RUN mamba install --quiet --yes \
    'folium' \
    'geocoder' \
    'geojson' \
    'geopandas' \
    'matplotlib-base' \
    'numpy' \
    'openpyxl' \
    'pandas' \
    'scikit-learn' \
    'scipy' \
    'seaborn' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

WORKDIR "${HOME}"
