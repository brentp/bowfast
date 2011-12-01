git submodule update

cd lib/sickle && make && cd -
cd lib/samtools && make && cd -
cd lib/bfast && ln -sf ../samtools . && sh autogen.sh && ./configure \
    && make && cd -

if [  -x lib/bowtie-0.12.7/bowtie ]; then
    cd lib
    rm -rf bowtie*
    wget http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.7/bowtie-0.12.7-src.zip
    unzip bowtie-0.12.7-src.zip
    cd bowtie-0.12.7 && make
fi
