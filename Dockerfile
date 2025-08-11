FROM condaforge/miniforge3

ENV PATH="/opt/conda/bin:${PATH}"

# store the FSL public conda channel
ENV FSL_CONDA_CHANNEL="https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/public"

# Install required tools into the base conda environment first (improves caching)
RUN /opt/conda/bin/conda install -n base -y -c $FSL_CONDA_CHANNEL -c conda-forge \
    tini \
    fsl-utils \
    fsl-avwutils && \
    /opt/conda/bin/conda clean -afy

# set FSLDIR so FSL tools can use it; in this minimal case, the FSLDIR will be the root conda directory
ENV FSLDIR="/opt/conda"

# entrypoint activates conda environment and fsl when you `docker run <command>`
WORKDIR /service
COPY . .

RUN mkdir -p data
RUN chmod +x /service/main.sh

ENTRYPOINT ["/service/main.sh"]