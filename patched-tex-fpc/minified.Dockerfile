FROM helm/my-tex-fpc-development:latest AS initial 

RUN rm -rf \
	/root/tex/distro/tex.* \
	/root/tex/distro/*.tex \
	/root/tex/distro/plain.log

FROM alpine:latest

RUN addgroup -S texfpc && adduser -S texfpc -G texfpc -h /home/texfpc/
COPY --from=initial /root/tex/distro/ /home/texfpc/distro/
RUN chown --recursive texfpc /home/texfpc/

env TEX_HOME="/home/texfpc"
env PATH="${PATH}:${TEX_HOME}/distro/bin/"

USER texfpc
WORKDIR /home/texfpc/distro/
