cd lib/sickle && make && cd -
cd lib/samtools && make && cd -
cd lib/bfast && ln -sf ../samtools . && sh autogen.sh && ./configure \
    && make
