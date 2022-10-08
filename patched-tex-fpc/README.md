This is a minimal TeX build that is based on
[tex-fpc](https://ctan.org/pkg/tex-fpc). It is packaged as a Docker image with
a compressed size of ~6 MB.

### How can I the use the image?

The image that results from minified.Dockerfile is on dockerhub
[here](https://hub.docker.com/r/helm/my-tex-fpc).

Add the following function to your ~/.bashrc file and then restart your terminal.

	function mytexfpc {
	  docker run \
		-it --rm \
		--mount "src=$PWD,target=$PWD,type=bind" \
		--mount "src=/etc/passwd,target=/etc/passwd,type=bind" \
		--user "${UID}" \
		--group-add "$(id -g)" \
		-w "$PWD" \
		"helm/my-tex-fpc:latest" \
		"$@"
	}

Now navigate to the directory where your .tex files live, and use the below command.

	mytexfpc tex.sh test.tex

This will generate your document as `test.dvi`.

Note that the container will have access to the work directory, so you can
compile only documents that are in the work directory or a subdirectory of it.

For more flexibility, you can use `mytexfpc sh` to work in the environment interactively. 

### What is included in the image?

The image contains the binaries

1. `tex`,
2. `mf`,
3. `tangle`,
4. `weave`,
5. `inimf`
6. and `initex`.

It also contains the plain format, the compiled fonts required for it, and a
[patch](https://archive.ph/iubpK) for webmac.tex.

### Can this project help me build tex-fpc without Docker?

Yes, take a look at development.Dockerfile. Repeating the build is as simple as
redoing the steps listed in this file. It is mainly about setting some
environment variables and running a few scripts scripts.

Understanding what the scripts do requires reading the README file of the
[tex-fpc project](https://ctan.org/pkg/tex-fpc).

### What is the difference between development.Dockerfile and minified.Dockerfile?

The first one builds TeX and Metafont. It is based on debian and it installs
some development tools that enable building tex-fpc. The minified one is based on
the more minimal image, Alpine. This one just copies the build from the
development image.

### Can I extract the build from the Docker image and use it on my system directly?

If the architecture of the image matches the architecture of your machine, I
guess it should work. I tested this on my machine only, so I am not confident
it will work in all the conceivable scenarios. The image on dockerhub supports
x64 architectures only, but you probably can rebuild the image for your
architecture easily.

Anyway, here is how I do it.

	# create a temporary container from the image on dockerhub or a local image
	# of your own
	sudo docker run --name tempcontainer helm/my-tex-fpc

	# copy the distro to your host
	sudo docker cp tempcontainer:/home/texfpc/distro/ .
	sudo chown --recursive "$USER:$(id -g)" ./distro/

	# test the distro
	export PATH="$PATH:$(readlink -f ./distro)"
	tex.sh /path/to/document.tex

	# cleanup
	sudo docker rm tempcontainer

### What is the difference between the `tex.sh` script and the `tex` binary?

The `tex` binary of tex-fpc requires having the TeXformats and TeXfonts folders
in the working directory. The `tex.sh` script creates a soft links to these
directories and then invokes `tex`.

### Is PDF supported?

No, only DVI is supported in this project. I am considering trying my luck with
a minimal build of `dvipdfmx` in the future.

### Is there a way to run this on Windows?

I wish I knew.


### Thanks

Special thanks go to Wolfgang Helbig for making tex-fpc, Joachim Kuebart for
writing the webmac patch, and Dave Jarvis for [this
answer](https://tex.stackexchange.com/a/576314).
