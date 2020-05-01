FROM nfcore/base:1.7
LABEL authors="Harshil Patel" \
      description="Docker image containing all requirements for nf-core/atacseq pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a


RUN mkdir /opt/scripts

COPY ./bin/* /opt/scripts/

RUN find /opt/scripts/ -type f -iname "*.py" -exec chmod +x {} \; && \
    find /opt/scripts/ -type f -iname "*.r"   -exec chmod +x {} \; && \
    find /opt/scripts/ -type f -iname "*2bed" -exec chmod +x {} \;

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/nf-core-atacseq-1.1.0/bin:$PATH
ENV PATH /opt/scripts:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name nf-core-atacseq-1.1.0 > nf-core-atacseq-1.1.0.yml
