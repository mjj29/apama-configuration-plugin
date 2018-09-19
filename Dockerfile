ARG APAMA_VERSION=10.3
ARG APAMA_BUILDER=store/softwareag/apama-builder:${APAMA_VERSION}
ARG APAMA_IMAGE=store/softwareag/apama-correlator:${APAMA_VERSION}

FROM ${APAMA_BUILDER} as builder

FROM ubuntu:latest as compiler

COPY --from=builder /opt/softwareag /opt/softwareag

ENV \
	APAMA_HOME=/opt/softwareag/Apama \
	APAMA_WORK=/apama_work
ENV \
   PATH=${APAMA_HOME}/bin:${PATH} \
	LD_LIBRARY_PATH=${APAMA_HOME}/lib:${APAMA_WORK}/lib \
	PYTHONPATH=${APAMA_HOME}/third_party/python/lib/python3.6/site-packages:${LD_LIBRARY_PATH}

RUN apt-get update && apt-get install -y python3

COPY . $APAMA_WORK/plugin

RUN mkdir -p $APAMA_WORK/lib $APAMA_WORK/monitors
RUN cp $APAMA_WORK/plugin/eventdefinitions/ConfigurationPlugin.mon $APAMA_WORK/monitors/
RUN cp $APAMA_WORK/plugin/ConfigurationPlugin.py $APAMA_WORK/lib/

RUN cd ${APAMA_WORK}/plugin/tests && pysys run | tee logfile && grep 'THERE WERE NO NON PASSES' logfile

FROM ubuntu:latest

ENV \
	APAMA_HOME=/opt/softwareag/Apama \
	APAMA_WORK=/apama_work
ENV \
	PATH=${APAMA_HOME}/bin \
	LD_LIBRARY_PATH=${APAMA_HOME}/lib:${APAMA_WORK}/lib \
	PYTHONPATH=${APAMA_HOME}/third_party/python/lib/python3.6/site-packages

RUN apt-get update && apt-get install -y python3 && apt-get clean

COPY --from=builder  /opt/softwareag /opt/softwareag
COPY --from=compiler ${APAMA_WORK}/lib ${APAMA_WORK}/lib
COPY --from=compiler ${APAMA_WORK}/monitors ${APAMA_WORK}/monitors

WORKDIR ${APAMA_WORK}
CMD ["correlator"]

