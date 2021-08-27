FROM opensciencegrid/software-base:3.5-el7-release
LABEL maintainer "OSG Software <help@opensciencegrid.org>"

RUN    yum install -y htcondor-ce-collector \
                      htcondor-ce-view \
                      mod_ssl \
                      # ^^^ Doing SSL termination in the pod
                      perl-LWP-Protocol-https \
                      # ^^^ for fetch-crl, in the rare case that the CA forces HTTPS
                      https://kojipkgs.fedoraproject.org/repos-dist/epel7-infra/latest/x86_64/Packages/m/mod_auth_openidc-2.3.5-2.el7.x86_64.rpm \
                      https://kojipkgs.fedoraproject.org/repos-dist/epel7-infra/latest/x86_64/Packages/c/cjose-0.5.1-1.el7.x86_64.rpm \
                      # ^^^ Upgrade to mod_auth_openidc from epel7-infra repo
    && yum clean all \
    && rm -rf /var/cache/yum/

# Create home directory for registry user
RUN mkdir /var/lib/condor-ce/webapp

# Disable Globus (GSS_ASSIST_GRIDMAP) lookups
RUN rm /etc/condor-ce/mapfiles.d/50-gsi-callout.conf

COPY etc/supervisord.d/*      /etc/supervisord.d/
COPY etc/condor-ce/config.d/* /etc/condor-ce/config.d/
COPY etc/httpd/conf.d/*       /etc/httpd/conf.d/
