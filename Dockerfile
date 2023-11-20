FROM ubuntu:focal as base
ENV TZ=Europe/Kiev
RUN apt-get update -y -q && apt-get install -y --no-install-recommends -q sudo tini && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

FROM base as machine-deps
COPY ostis-web-platform/sc-machine/scripts/install_deps_ubuntu.sh ostis-web-platform/sc-machine/scripts/install_deps_python.sh ostis-web-platform/sc-machine/scripts/set_vars.sh /tmp/machine/scripts/
COPY ostis-web-platform/sc-machine/requirements.txt /tmp/machine/
RUN /tmp/machine/scripts/install_deps_ubuntu.sh --dev

FROM machine-deps as machine
COPY ostis-web-platform/sc-machine /dm/sc-machine
RUN /dm/sc-machine/scripts/build_sc_machine.sh

FROM machine as scp
COPY ostis-web-platform/scp-machine /dm/scp-machine
RUN /dm/scp-machine/scripts/build_scp_machine.sh

FROM node:16-alpine as web-client
WORKDIR /sc-web
COPY ostis-web-platform/sc-web/package.json ostis-web-platform/sc-web/package-lock.json /sc-web/
RUN npm install
COPY ostis-web-platform/sc-web /sc-web
RUN npm run build && mkdir dist && mv client server components repo.path sc-web.ini dist

FROM base as web-server
RUN apt-get install -y --no-install-recommends -q python3.8 python3-pip
COPY ostis-web-platform/sc-web/requirements.txt /sc-web/
RUN python3 -m pip install --no-cache-dir --default-timeout=100 -r /sc-web/requirements.txt

FROM base
ENTRYPOINT [ "/usr/bin/tini", "--" ]
EXPOSE 8000 8090
ENV LD_LIBRARY_PATH=/dm/sc-machine/bin
COPY --from=scp /usr /usr
COPY --from=scp /dm/sc-machine /dm/sc-machine
COPY --from=web-server /usr/bin/python3 /usr/bin/python3
COPY --from=web-server /usr/local/lib/python3.8/dist-packages /usr/local/lib/python3.8/dist-packages
COPY --from=web-client /sc-web/dist /dm/sc-web/
COPY ostis-web-platform/scp-machine/kb /dm/scp-machine/kb
COPY ostis-web-platform/scp-example-kb /dm/scp-example-kb
COPY ostis-web-platform.ini repo.path run /dm/
COPY ostis-web-platform/ims.ostis.kb /dm/ims.ostis.kb
CMD [ "./run" ]