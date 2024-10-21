FROM ubuntu:22.04
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get install -y software-properties-common
RUN apt install -y python2 python-pip
RUN apt-get install -y python2-dev
RUN mkdir testprog
RUN cd testprog
RUN cat >setup.py <<EOL
from setuptools import setup, Extension

setup(
    name="test",
    ext_modules=[Extension("test", sources=["testmodule.c"])],
    zip_safe=False
)
EOL
RUN cat >testmodule.c <<EOL
#include <stdio.h>

int main(void)
{
        printf("This is test program");
        return 0;
}
EOL
RUN python2 setup.py build_ext --inplace
RUN python2 -c "import sysconfig; print(sysconfig.get_config_var('CFLAGS'))" -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -Wdate-time -D_FORTIFY_SOURCE=2 -g -ffile-prefix-map=/build/python2.7-W40Ff2/python2.7-2.7.18=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security
RUN strings build/lib.linux-x86_64-2.7/test.so | grep -- -O
RUN add-apt-repository ppa:mitchdz/python2.7-optimization-flags -y
RUN apt install -y python2.7
RUN dpkg -s python2.7
RUN rm -rf build/ test.so
RUN export APPLY_LP2002043_UBUNTU_CFLAGS_WORKAROUND=""
RUN python2 setup.py build_ext --inplace
RUN strings build/lib.linux-x86_64-2.7/test.so | grep -- -O
RUN pip2 install cutadapt==1.11
RUN cutadapt --version

