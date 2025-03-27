FROM glcr.b-data.ch/jupyterlab/r/verse:4.4.3 as base

USER root

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}