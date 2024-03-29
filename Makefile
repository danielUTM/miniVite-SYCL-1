
CXX = dpcpp

USE_TAUPROF=0
ifeq ($(USE_TAUPROF),1)
TAU=/soft/perftools/tau/tau-2.29/craycnl/lib
CXX = tau_cxx.sh -tau_makefile=$(TAU)/Makefile.tau-intel-papi-mpi-pdt 
endif
# use -xmic-avx512 instead of -xHost for Intel Xeon Phi platforms
ONEAPI = -I"/apps/intel/oneapi/2022.1.2/mpi/2021.5.1/include" -L"/apps/intel/oneapi/2022.1.2/mpi/2021.5.1/lib/release" -L"/apps/intel/oneapi/2022.1.2/mpi/2021.5.1/lib" -Xlinker --enable-new-dtags -Xlinker -rpath -Xlinker "/apps/intel/oneapi/2022.1.2/mpi/2021.5.1/lib/release" -Xlinker -rpath -Xlinker "/apps/intel/oneapi/2022.1.2/mpi/2021.5.1/lib" -lmpicxx -lmpifort -lmpi -ldl -lrt -lpthread
OPTFLAGS = -O3 -xHost -fsycl -fopenmp -DPRINT_DIST_STATS #-DPRINT_EXTRA_NEDGES #-DUSE_MPI_RMA -DUSE_MPI_ACCUMULATE #-DUSE_32_BIT_GRAPH #-DDEBUG_PRINTF #-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_LOHI_RANDOM_NUMBERS#-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_RANDOM_NUMBERS #-DPRINT_RANDOM_XY_COORD
#-DUSE_MPI_SENDRECV
#-DUSE_MPI_COLLECTIVES
# use export ASAN_OPTIONS=verbosity=1 to check ASAN output
SNTFLAGS = -std=c++11 -fopenmp -fsanitize=address -O1 -fno-omit-frame-pointer
CXXFLAGS = -std=c++17 -g $(OPTFLAGS)

OBJ = main.o
TARGET = miniVite

all: $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $^

$(TARGET):  $(OBJ)
	$(CXX) $^ $(ONEAPI) $(OPTFLAGS) -o $@

.PHONY: clean

clean:
	rm -rf *~ $(OBJ) $(TARGET)
