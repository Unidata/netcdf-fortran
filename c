FLAGS="--prefix /tmp/install/spock --enable-f03"
CPPFLAGS='-I/share/ed/local/spock/include -I/share/ed/local/spock/include -I/tmp/install/spock/include'
LDFLAGS='-L/tmp/install/spock/lib -lnetcdf -L/share/ed/local/spock/lib -lhdf5_hl -lhdf5 -L/share/ed/local/spock/lib -lz'
LD_LIBRARY_PATH=/tmp/install/spock/lib:/share/ed/local/spock/lib:/share/stdinstall/local/spock/lib:/share/ed/local/spock/lib:
export CPPFLAGS; export LDFLAGS; export LD_LIBRARY_PATH
DISTCHECK_CONFIGURE_FLAGS="$FLAGS"; export DISTCHECK_CONFIGURE_FLAGS
./configure $FLAGS
make check

